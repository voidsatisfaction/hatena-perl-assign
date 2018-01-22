package t::Intern::Diary::Engine::Index;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::More;

use Test::Intern::Diary;
use Test::Intern::Diary::Factory qw(create_user);
use Test::Intern::Diary::Mechanize qw(create_mech);

sub _get : Test(3) {
  subtest 'guest' => sub {
    my $mech = create_mech;
    $mech->get_ok('/');
    $mech->title_is('Intern::Diary::All');
    $mech->content_contains('/login');
  };

  subtest 'logged in' => sub {
    my $user = create_user;
    my $mech = create_mech(user => $user);
    $mech->get_ok('/');
    $mech->content_contains('my article');
  }
}

__PACKAGE__->runtests;

1;
