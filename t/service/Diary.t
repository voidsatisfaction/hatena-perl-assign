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

use Test::Intern::Diary::Util qw(random_string);
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
  my $diary = create_diary(user => $user);

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
    is $created_diary->user_id, $user->id, 'owner is same';
  };
}

sub get_or_create_by_user_and_title : Test(4) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;
  my $user = create_user;
  my $title = random_string(20);
  subtest 'Fail: user is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Diary->get_or_create_by_user_and_title($db, +{
        title => $title,
      });
    };
  };

  subtest 'Fail: title is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Diary->get_or_create_by_user_and_title($db, +{
        user => $user,
      });
    };
  };

  subtest 'Success: diary is created' => sub {
    my $diary = Intern::Diary::Service::Diary->get_or_create_by_user_and_title($db, +{
      user => $user,
      title => $title,
    });

    ok $diary, 'diary is created';
    isa_ok $diary, 'Intern::Diary::Model::Diary', 'diary is blessed';
    is $diary->title, $title, 'title is same';
    is $diary->user_id, $user->id, 'owner is same';
  };

  subtest 'Success: diary is found' => sub {
    my $created_diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($db, +{
      user => $user,
      title => $title,
    });

    ok $created_diary, 'already created';

    my $diary = Intern::Diary::Service::Diary->get_or_create_by_user_and_title($db, +{
      user => $user,
      title => $title,
    });

    ok $diary, 'diary exists';
    cmp_deeply $created_diary, $diary, 'diaries are same';
  };
}

sub get_diary_by_article : Test(2) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  my $diary = create_diary();
  my $article = create_article(diary => $diary);

  subtest 'Fail: article is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Diary->get_diary_by_article($db, +{});
    };
  };

  subtest 'Success' => sub {
    my $get_diary = Intern::Diary::Service::Diary->get_diary_by_article($db, +{
      article => $article,
    });

    ok $get_diary, 'diary exists';
    isa_ok $get_diary, 'Intern::Diary::Model::Diary', 'diary is blessed';
    cmp_deeply $get_diary, $diary, 'diaries are same';
  };
}

__PACKAGE__->runtests;

1;
