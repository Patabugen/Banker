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
use HTTP::Date;

## Settings
my $file = $ARGV[0];
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
		my $tran_md5 = md5_hex($columns[$cMatch] . $columns[$cAmount] . $columns[$cDate]);

		## Try and get a proper date
		my $tran_date = $columns[$cDate];
		$tran_date =~ s/ /\-/g;
		$tran_date = str2time($tran_date);
		
		## If this field is blank, it's probably a credit
		if($columns[$cAmount] ne "" ){
			push @trans, [$columns[$cMatch], $columns[$cAmount], 1, $tran_md5, $tran_date];
		}
	} else {
		my $err = $csv->error_input;
		print "Failed to parse line: $err";
	}
}
close CSV;

## Put them al into the DBase
$schema->populate('Tran', [
		[qw/tran_text tran_amount tran_owner tran_key tran_date /],
		@trans,
	]);
