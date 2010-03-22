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
	tran_group	=> null
});

## This will come from the dbase eventually
	my %regEx = (
		"Sainsbusy", "food",
		"WH Smith", "books",
		"BuyMyShizzle", "bday presents",
		"Overground", "travel",
		"BOOKFAIR", "books",
	);

while (my $row = $trans->next) {
	print $row->get_column('tran_text')."\n";
#	my $trans_label;
#	print $trans_md5." - £".$columns[$cAmount]." - ";
#	while(my($exp, $label) = each(%regEx)){
#		if($columns[$cMatch] =~ m/$exp/){
#			$trans_label = $label;
#			last;
#		}
#	}
}
