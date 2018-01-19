package Intern::Diary::Service::User;

use strict;
use warnings;
use utf8;

use Carp;

use DateTime;
use DateTime::Format::MySQL;

use Intern::Diary::Model::User;
use Intern::Diary::Util;

sub create {
  my ($class, $db, $args) = @_;

  my $name = $args->{name} // croak 'name required';

  $db->query(q[
    INSERT INTO user (name, created_at)
      VALUES (?)
  ], [ $name, Intern::Diary::Util::now ]);

  return $class->get_user_by_name($db, { name => $name });
}

sub get_user_by_name {
  my ($class, $db, $args) = @_;

  my $name = $args->{name} // croak 'name required';

  my $row = $db->select_row(q[
    SELECT * FROM user
      WHERE name = ?
      LIMIT 1
  ], $name);

  unless ($row) {
    return undef;
  }

  return Intern::Diary::Model::User->new($row);
}

sub get_or_create_by_name {
  my ($class, $db, $args) = @_;
  return $class->get_user_by_name($db, $args) // $class->create($db, $args);
}

1;
