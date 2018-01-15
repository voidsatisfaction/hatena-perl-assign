package t::Intern::Diary::Service::User;

use strict;
use warnings;
use utf8;

use parent qw(Test::Class);

use Test::More;
use Test::Exception;
use Test::Deep;

use Intern::Diary::Service::User;
use Intern::Diary::Context;

sub _require : Test(startup => 1) {
  my ($self) = @_;
  require_ok 'Intern::Diary::Service::User';
}

sub get_or_create_by_name : Test(2) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  subtest 'Fail: name is not registered' => sub {
    dies_ok {
      my $user = Intern::Diary::Service::User->get_or_create_by_name($db, {});
    };
  };

  subtest 'Success: get already existing user' => sub {
    my $created_name = 'abc';
    my $created_user = Intern::Diary::Service::User->create($db, { name => $created_name });

    my $get_user = Intern::Diary::Service::User->get_or_create_by_name($db, { name => $created_name });

    ok $get_user, 'user exists';
    isa_ok $get_user, 'Intern::Diary::Model::User', 'user is blessed';
    ok cmp_deeply($get_user, $created_user), 'two are the same users';
  };
}

sub get_user_by_name : Test(2) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;
  my $dummy_name = 'user1';
  my $create_user = Intern::Diary::Service::User->create($db, { name => $dummy_name });

  subtest 'Fail: name is not registered' => sub {
    dies_ok {
      my $user = Intern::Diary::Service::User->get_user_by_name($db, {});
    };
  };

  subtest 'Success: get user by name' => sub {
    my $get_user = Intern::Diary::Service::User->get_user_by_name($db, { name => $dummy_name });

    ok $get_user, 'user exists';
    isa_ok $get_user, 'Intern::Diary::Model::User', 'user is blessed';
    is $get_user->{name}, $create_user->{name}, 'two users are same';
  };
}

sub create : Test(2) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  subtest 'Fail: create user fail: name is not registered' => sub {
    dies_ok {
      my $user = Intern::Diary::Service::User->create($db, {});
    };
  };

  subtest 'Success: create new user' => sub {
    my $dummy_name = 'user';
    my $dummy_user = Intern::Diary::Service::User->create($db, {
      name => $dummy_name,
    });

    ok $dummy_user, 'created user exists';
    isa_ok $dummy_user, 'Intern::Diary::Model::User', 'created user is blessed';
    is $dummy_user->{name}, $dummy_name, 'two users are same';
  };
}

__PACKAGE__->runtests;

1;
