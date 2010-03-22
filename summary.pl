#!/usr/bin/perl

## Common Elements
use strict;
use warnings;
use diagnostics;

use dbase::Main;
my $schema = dbase::Main->connect('dbi:SQLite:banker.db');
my $userid = 1;
## End Common Elements

my $groups = $schema->resultset('Tran')->search(
	{
		tran_owner	=> $userid
	},
	{
		select		=> ['tran_text', 'tran_group', { count => 'tran_id' }, { sum => 'tran_amount' }],
		as		=> [qw/ tran_text tran_group tran_count group_total /],
		group_by	=> 'tran_group'
	}
);

my $row = $groups->next;
while(my $row = $groups->next){
	print $row->tran_group().":\n";
	print "\t Transactions: ";
	print $row->get_column('tran_count')."\n";
	print "\t Total ";
	print $row->get_column('group_total')."\n";
	print "\t Average: ";
	print $row->get_column('group_total') / $row->get_column('tran_count')."\n";
	
}
