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
		
	}
);

while(my $row = $groups->next){
	print $row->tran_group().":\n";
	print "\t Transactions: ";
	print $row->get_column('tran_count')."\n";
	print "\t Total ";
	print $row->get_column('group_total')."\n";
	print "\t Average: ";
	print $row->get_column('group_total') / $row->get_column('tran_count')."\n";
	
}

sub print_r {
    package print_r;
    our $level;
    our @level_index;
    if ( ! defined $level ) { $level = 0 };
    if ( ! defined @level_index ) { $level_index[$level] = 0 };

    for ( @_ ) {
        my $element = $_;
        my $index   = $level_index[$level];

        print "\t" x $level . "[$index] => ";

        if ( ref($element) eq 'ARRAY' ) {
            my $array = $_;

            $level_index[++$level] = 0;

            print "(Array)\n";

            for ( @$array ) {
                main::print_r( $_ );
            }
            --$level if ( $level > 0 );
        } elsif ( ref($element) eq 'HASH' ) {
            my $hash = $_;

            print "(Hash)\n";

            ++$level;

            for ( keys %$hash ) {
                $level_index[$level] = $_;
                main::print_r( $$hash{$_} );
            }
        } else {
            print "$element\n";
        }

        $level_index[$level]++;
    }
} # End print_r

