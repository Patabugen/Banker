package dbase::Main::Result::User;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('users');
__PACKAGE__->add_columns(qw/ user_id user_name /);
__PACKAGE__->set_primary_key('user_id');
__PACKAGE__->has_many('trans' => 'dbase::Main::Result::Tran');


1;
