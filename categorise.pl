#!/usr/bin/perl

## Common Elements
use strict;
use warnings;
use diagnostics;

use dbase::Main;
my $schema = dbase::Main->connect('dbi:SQLite:banker.db');
my $userid = 1;
## End Common Elements

my $trans = $schema->resultset('Tran')->search({
	tran_owner	=> $userid,
	tran_group	=> undef
});

my @matches;
my $matchResults = $schema->resultset('Match')->search({
	match_owner	=> $userid
});
while(my $row = $matchResults->next){
	push @matches, [$row->get_column('match_pattern'),  $row->get_column('match_label')];
}


sub categorise{
	my $text = shift;
	my $trans_label;
	use vars qw(@matches);
#	foreach $index (@matches){
#		$pattern = @matches{$index};
#		if($text =~ m/$pattern/){
#			return @matches{index};
#		}
#	}
	return "";
}

while (my $row = $trans->next) {
	my $text = $row->get_column('tran_text');
	my $label = categorise($text);
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
			$schema->populate('Match', [ [qw/match_pattern match_label/], [$new, $label]]);
			$schema->commit();
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
