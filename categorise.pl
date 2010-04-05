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

sub categorise{
	my $text = shift;
	my $trans_label;
	my $matches = $schema->resultset('Match')->search({
		match_owner	=> $userid
	});
	while(my $row = $matches->next){
		my $exp = $row->get_column('match_pattern');
		if($text =~ m/$exp/){
			return $row->get_column('match_label');
		}
	}
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
