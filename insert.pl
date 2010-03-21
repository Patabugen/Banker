#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use Text::CSV;
use dbase::Main;

my $file = 'statements/2010-feb.csv';
my $fileStart = 0;
my $csv = Text::CSV->new();

my $schema = db::Main->connect('dbi:SQLite:banker.db');

	my %regEx = (
		"Sainsbusy", "food",
		"WH Smith", "books",
		"BuyMyShizzle", "bday presents",
		"Overground", "travel",
		"BOOKFAIR", "books",
	);

my $cDate = 0;
my $cMatch = 1;
my $cAmount = 2;

my %totals = (
		"Total Out", ("count", 0, "value" , 0),
		"Total In", ("count", 0, "value" , 0),
	);

open (CSV, "<", $file) or die $!;

while (<CSV>) {
	if ($csv->parse($_)) {
		my @columns = $csv->fields();
		print $columns[$cDate]." - ";
		print "£".$columns[$cAmount]." - ";
		while(my($exp, $label) = each(%regEx)){
			if($columns[$cMatch] =~ m/$exp/){
				print $label;
				$totals{$label}{'count'}++;
				$totals{$label}{'value'} += $columns[ $cAmount ];
			}
		}
		print "\t\t\t".$columns[ $cMatch ]." - ";
		print "\n";
	} else {
		my $err = $csv->error_input;
		print "Failed to parse line: $err";
	}
}
close CSV;
