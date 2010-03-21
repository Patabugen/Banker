package db::Main::Result::Tran;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('trans');
__PACKAGE__->add_columns(qw/tran_id tran_text tran_date tran_amount tran_group tran_owner /);
__PACKAGE__->set_primary_key('tran_id');
__PACKAGE__->belongs_to('tran_owner' => 'db::Main::Result::User');

1;
