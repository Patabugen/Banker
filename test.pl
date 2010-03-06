#!/usr/bin/perl

use strict;
use warnings;
use Text::CSV;

my $file = 'prospects.csv';
my $csv = Text::CSV->new();

open (CSV, "<", $file) or die $!;

while (<CSV>) {
	if ($csv->parse($_)) {
		my @columns = $csv->fields();
		print "@columns\n";
	} else {
		my $err = $csv->error_input;
		print "Failed to parse line: $err";
	}
}

close CSV;

