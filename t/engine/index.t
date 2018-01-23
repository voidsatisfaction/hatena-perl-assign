package t::Intern::Diary::Engine::Index;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Intern::Diary::Context;

use Test::More;

use t::Test;
use Test::Intern::Diary;
use Test::Intern::Diary::Factory qw(create_user);
use Test::Intern::Diary::Mechanize qw(create_mech);

sub _get : Test(2) {
  subtest 'guest' => sub {
    my $mech = create_mech;
    $mech->get_ok('/');
    $mech->title_is('Intern::Diary::All');
    $mech->content_contains('/signin');
  };

  subtest 'logged in' => sub {
    my $user = create_user;
    my $mech = create_mech(user => $user);
    $mech->get_ok('/');
  }
}

__PACKAGE__->runtests;

1;
