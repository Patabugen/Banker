#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use Text::CSV;
use DBI;

my $file = 'statements/2010-feb.csv';
my $fileStart = 0;
my $csv = Text::CSV->new();
# my $db = DBI->connect("dbi:mysql:dbname=banker.db", "", "");

my %regEx = { };
%regex->{ food } => "Sainsbury";

#print %regEx;

open (CSV, "<", $file) or die $!;

while (<CSV>) {
	if ($csv->parse($_)) {
		my @columns = $csv->fields();
		print $columns[0]." - ";
		print "£".$columns[2]." - ";
	#	while(my($key, $value) = each(%regEx)){
	#		print $value;
	#	}
		print "\n";
	#	@column = split(/ /, @column
	#	print "@columns\n";
	} else {
		my $err = $csv->error_input;
		print "Failed to parse line: $err";
	}
}

close CSV;
