package t::Intern::Diary::Engine::Diary;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::More;

use t::Test;
use Test::Intern::Diary::Util qw(random_string);
use Test::Intern::Diary::Factory qw(create_user);
use Test::Intern::Diary::Mechanize qw(create_mech);

use Intern::Diary::Context;
use Intern::Diary::Service::Diary;

sub _get : Tests {
  subtest 'guest' => sub {
    my $mech = create_mech;
    $mech->get_ok('/diary/new');
    $mech->title_is('Intern::Diary::Signin');
  };

  subtest 'logged in' => sub {
    my $user = create_user;
    my $mech = create_mech(user => $user);
    $mech->get_ok('/diary/new');
    $mech->title_is('Intern::Diary::Diary::New');
  };
}

sub _add : Tests {
  my $db = Intern::Diary::Context->new->dbh;
  subtest 'guest' => sub {
    my $mech = create_mech;
    $mech->post('/diary', +{
      diary_title => random_string(20),
    });
    # redirect to signin
    $mech->title_is('Intern::Diary::Signin');
  };

  subtest 'logged in' => sub {
    my $user = create_user;
    my $mech = create_mech(user => $user);
    subtest 'Success: add new diary' => sub {
      my $diary_title = random_string(20);
      $mech->post_ok('/diary', +{
        diary_title => $diary_title
      });

      my $created_diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($db, +{
        title => $diary_title,
        user => $user,
      });

      ok $created_diary, 'diary is created';
      is $created_diary->title, $diary_title, 'title is same';
      is $created_diary->user_id, $user->id, 'owner is same';
    };
  };
}

__PACKAGE__->runtests;

1;
__END__
