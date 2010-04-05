#!/usr/bin/perl

## Common Elements
use strict;
use warnings;
use diagnostics;

use dbase::Main;
my $schema = dbase::Main->connect('dbi:SQLite:banker.db');
## End Common Elements


## Libraries specific to this file
use Digest::MD5 qw(md5_hex);
use Text::CSV;

## Settings
my $file = 'statements/2010-feb.csv';
my $fileStart = 0;

## Library Objects I'll be using
my $csv = Text::CSV->new();

## These too, come from DB or form input
## They tell us where abouts in the CSV file to look for data
my $cDate = 0;
my $cMatch = 1;
my $cAmount = 2;

open (CSV, "<", $file) or die $!;

my @trans;
while (<CSV>) {
	if ($csv->parse($_)) {
		my @columns = $csv->fields();
		my $trans_md5 = md5_hex($columns[$cMatch] . $columns[$cAmount] . $columns[$cDate]);
		push @trans, [$columns[$cMatch], $columns[$cAmount], $trans_label, 1, $trans_md5];
	} else {
		my $err = $csv->error_input;
		print "Failed to parse line: $err";
	}
}
close CSV;

## Put them al into the DBase
$schema->populate('Tran', [
		[qw/tran_text tran_amount tran_group tran_owner tran_key /],
		@trans,
	]);
