package t::Intern::Diary::Service::Diary;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use String::Random qw(random_regex);

use parent qw(Test::Class);

use Test::More;
use Test::Deep;
use Test::Exception;
use Test::Intern::Diary::Factory;

use Intern::Diary::Context;
use Intern::Diary::Service::Diary;

sub _require : Test(startup => 1) {
  my ($self) = @_;
  require_ok 'Intern::Diary::Service::Diary'
}

sub get_diaries_by_user : Test(2) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  my $user = create_user;
  my $diary1 = create_diary(user => $user);
  my $diary2 = create_diary(user => $user);

  subtest 'Fail: user is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Diary->get_diaries_by_user($db, +{});
    };
  };

  subtest 'Success' => sub {
    my $get_diaries = Intern::Diary::Service::Diary->get_diaries_by_user($db, +{
      user => $user,
    });

    ok $get_diaries, 'diaries exist';
    is scalar @$get_diaries, 2, 'diaries numbers are same';
    cmp_deeply [map { $_->user_id } @$get_diaries], [$diary1->user_id, $diary2->user_id];
  };
}

sub get_diary_by_user_and_title : Test(3) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  my $user = create_user;
  my $diary = create_diary((user => $user));

  subtest 'Fail: user is undefined' => sub {
    dies_ok {
      my $get_diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($db, +{
        title => $diary->title,
      });
    };
  };

  subtest 'Fail: title is undefined' => sub {
    dies_ok {
      my $get_diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($db, +{
        name => $diary->name,
      });
    };
  };

  subtest 'Success' => sub {
    my $get_diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($db, {
      title => $diary->title,
      user => $user,
    });

    ok $get_diary, 'diary exists';
    isa_ok $get_diary, 'Intern::Diary::Model::Diary', 'diary is blessed';
    ok cmp_deeply($get_diary, $diary), 'diary ok';
  };
}

sub create : Test(3) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  my $user = create_user;

  subtest 'Fail: user is undefined' => sub {
    dies_ok {
      my $created_diary = Intern::Diary::Service::Diary->create($db, +{
        title => "dummy diary",
      });
    };
  };

  subtest 'Fail: user is undefined' => sub {
    dies_ok {
      my $created_diary = Intern::Diary::Service::Diary->create($db, +{
        user => $user,
      });
    };
  };

  subtest 'Success' => sub {
    my $title = random_regex('test_diary_\w{30}');

    my $created_diary = Intern::Diary::Service::Diary->create($db, +{
      user => $user,
      title => $title,
    });

    ok $created_diary, 'diary exists';
    isa_ok $created_diary, 'Intern::Diary::Model::Diary', 'diary is blessed';
    is $created_diary->title, $title, 'title is same';
  };
}

__PACKAGE__->runtests;

1;
