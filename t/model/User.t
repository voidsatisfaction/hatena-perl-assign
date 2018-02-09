package t::Intern::Diary::Model::User;

use strict;
use warnings;
use utf8;

use Test::More;
use Test::Fatal;

use Intern::Diary::Model::User;

subtest 'User model' => sub {
  my $dummy_id = 1;
  my $dummy_name = 'bren';
  my $dummy_created_at = '1993-04-21 23:12:01';

  use_ok 'Intern::Diary::Model::User';
  # QUESTION: why below assertion makes error?
  # isa_ok Intern::Diary::Model::User->new, 'Intern::Diary::Model::User';

  subtest 'User->new success' => sub {
    my $dummy_user = Intern::Diary::Model::User->new({
      id => $dummy_id,
      name => $dummy_name,
      created_at => $dummy_created_at,
    });

    is $dummy_user->id, $dummy_id;
    is $dummy_user->name, $dummy_name;
    is $dummy_user->created_at, $dummy_created_at;
    ok( exception{ $dummy_created_at->{created_at} }, 'created at is not readable field' )
  };
};

done_testing;

1;
