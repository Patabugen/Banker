package dbase::Main::Result::Match;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('matches');
__PACKAGE__->add_columns(qw/match_id match_owner match_pattern match_label /);
__PACKAGE__->set_primary_key('match_id');
__PACKAGE__->belongs_to('match_owner' => 'dbase::Main::Result::User');

1;
