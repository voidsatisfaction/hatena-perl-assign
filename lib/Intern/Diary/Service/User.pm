package Intern::Diary::Service::User;

use strict;
use warnings;
use utf8;

use Carp;

use DateTime;
use DateTime::Format::MySQL;

use Intern::Diary::Util;
use Intern::Diary::Model::User;
use Intern::Diary::Service::Diary;

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
  ], $name) or return;

  return Intern::Diary::Model::User->new($row);
}

sub get_user_by_diary {
  my ($class, $db, $args) = @_;

  my $diary = $args->{diary} // croak 'diary required';
  my $user_id = $diary->user_id;

  my $row = $db->select_row(q[
    SELECT * FROM user
      WHERE
        id = ?
  ], $user_id) or return;

  return Intern::Diary::Model::User->new($row);
}

sub get_user_by_article {
  my ($class, $db, $args) = @_;

  my $article = $args->{article} // croak 'article required';
  my $diary = Intern::Diary::Service::Diary->get_diary_by_article($db, +{
    article => $article,
  });
  my $user = $class->get_user_by_diary($db, +{
    diary => $diary,
  });

  return $user;
}

sub get_or_create_by_name {
  my ($class, $db, $args) = @_;
  return $class->get_user_by_name($db, $args) // $class->create($db, $args);
}

1;
