#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use Text::CSV;
use dbase::Main;
use Digest::MD5;

## Settings
my $file = 'statements/2010-feb.csv';
my $fileStart = 0;

## Library Objects I'll be using
my $csv = Text::CSV->new();
my $schema = dbase::Main->connect('dbi:SQLite:banker.db');


## This will come from the dbase eventually
	my %regEx = (
		"Sainsbusy", "food",
		"WH Smith", "books",
		"BuyMyShizzle", "bday presents",
		"Overground", "travel",
		"BOOKFAIR", "books",
	);

## These too, come from DB or form input
## They tell us where abouts in the CSV file to look for data
my $cDate = 0;
my $cMatch = 1;
my $cAmount = 2;

## Setup the defaults
my %totals = (
		"Total Out", ("count", 0, "value" , 0),
		"Total In", ("count", 0, "value" , 0),
	);

open (CSV, "<", $file) or die $!;

my @trans;
while (<CSV>) {
	if ($csv->parse($_)) {
		my @columns = $csv->fields();
		print $columns[$cDate]." - ";
		print "£".$columns[$cAmount]." - ";
		while(my($exp, $label) = each(%regEx)){
			if($columns[$cMatch] =~ m/$exp/){
				push @trans, [$columns[$cMatch], $columns[$cAmount], $label, 1];
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

## Put them al into the DBase
$schema->populate('Tran', [
		[qw/tran_text tran_amount tran_group tran_owner/],
		@trans,
	]);
