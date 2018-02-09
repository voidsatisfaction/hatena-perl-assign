package t::Intern::Diary::Engine::User;

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
use Intern::Diary::Service::User;

sub _default : Tests {
  subtest 'signin page' => sub {
    my $mech = create_mech;
    $mech->get_ok('/signin');
    $mech->title_is('Intern::Diary::Signin');
    $mech->content_contains('/signin');
  };
}

sub _add : Tests {
  my $user_name = random_string(10);
  my $mech = create_mech;
  my $c = Intern::Diary::Context->new;

  subtest 'user created' => sub {
    $mech->get_ok('/signin');
    $mech->submit_form_ok({
      fields => {
        username => $user_name,
      },
    }, 'submit form ok');

    my $created_user = Intern::Diary::Service::User->get_user_by_name($c->dbh, +{
      name => $user_name,
    });

    ok $created_user, 'user created successfully';
    is $created_user->name, $user_name, 'two are same user';
  };
}

__PACKAGE__->runtests;

1;
