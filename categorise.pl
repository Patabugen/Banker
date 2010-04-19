#!/usr/bin/perl

## Common Elements
use strict;
use warnings;
use diagnostics;

use dbase::Main;
my $schema = dbase::Main->connect('dbi:SQLite:banker.db');
my $userid = 1;
## End Common Elements

my $trans = $schema->resultset('Tran')->search(
	{
		tran_owner	=> $userid,
		tran_group	=> undef
	},
	{
		rows		=> 5
	}
);

my @matches;
my $match_rs = $schema->resultset('Match');
my $matchResults = $match_rs->search({
	match_owner	=> $userid
});

while(my $row = $matchResults->next){
	push @matches, [ $row->match_pattern,  $row->match_label ];
}


sub categorise{
	my @matches = shift;
	my $text = shift;
	my $trans_label;
	for my $pat (@matches){
		my $pattern = @$pat[0];
		my $label = @$pat[1];
		if($text =~ m/Q$pattern/i){
			return $label;
		}
	}
	return "";
}

while (my $row = $trans->next) {
	my $text = $row->get_column('tran_text');
	my $label = categorise(@matches, $text);
	if($label eq "")
	{
		print "Not Matched: \'".$text."'\n";
		print "\tType New Pattern:\t";
		my $new = <>;
		if($new eq "\n"){
			## Pick a label
			print "Or dont, enter a label then:\t";
			chomp($label = <>);
		}else{
			chomp($new);
			while($label eq ""){
				print "\tLabel:\t\t\t";
				chomp($label = <>);
			}
			my $new_match = $match_rs->new(
				{
					match_pattern	=> $new,
					match_label	=> $label
				}
			);
			$new_match = $new_match->insert();
			print "Created: [ $new , $label ] with ID ".$new_match->id()."\n";
#			$schema->populate('Match', [ [qw/match_pattern match_label/], [$new, $label]]);
			push @matches, [ $new, $label ];

		}
	}
	if($label ne "")
	{
		print "Saving: ".$label."\n";
		$row->update({
			'tran_group' => $label}
		);
	}
}
