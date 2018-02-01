package t::Intern::Diary::Model::Diary;

use strict;
use warnings;
use utf8;

use Test::More;
use Test::Exception;

use Intern::Diary::Model::Diary;

subtest 'Diary model' => sub {
  my $id = 1;
  my $title = 'testtestdiary';
  my $user_id = 1;

  use_ok 'Intern::Diary::Model::Diary';
  # TODO: fix here
  # isa_ok Intern::Diary::Model::Diary->new, 'Intern::Diary::Model::Diary';

  subtest 'Success: Diary->new' => sub {
    my $diary = Intern::Diary::Model::Diary->new({
      id => $id,
      title => $title,
      user_id => $user_id,
    });

    is $diary->id, $id, 'id is same';
    is $diary->title, $title, 'title is same';
    $diary->user_id, $user_id, 'user_id is same';
  };
};

done_testing;

1;
