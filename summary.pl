#!/usr/bin/perl

## Common Elements
use strict;
use warnings;
use diagnostics;

use dbase::Main;
my $schema = dbase::Main->connect('dbi:SQLite:banker.db');
my $userid = 1;
## End Common Elements

my $trans = $schema->resultset('Tran')->search({tran_owner => $userid});

while(my $row = $trans->next){
	print $row->tran_text."\n";
	print "\t Label: ";
	print defined($row->tran_group) ? $row->tran_group : "No Label";
	print "\n";
	print "\t Amount: ";
	print defined($row->tran_amount) ? $row->tran_amount : "No Label";
	print "\n";
}
