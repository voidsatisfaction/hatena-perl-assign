package Intern::Diary::Service::Diary;

use strict;
use warnings;
use utf8;

use Carp;

use Intern::Diary::Model::Diary;

sub create {
  my ($class, $db, $args) = @_;

  my $title = $args->{title} // croak 'title required';
  my $user = $args->{user} // croak 'user required';

  $db->query(q[
    INSERT INTO diary (title, user_id)
      VALUES (?)
  ], [ $title, $user->id ]);

  return $class->get_diary_by_user_and_title($db, +{
    title => $title,
    user => $user,
  });
}

sub get_diary_by_user_and_title {
  my ($class, $db, $args) = @_;

  my $title = $args->{title} // croak 'title required';
  my $user = $args->{user} // croak  'user required';

  my $row = $db->select_row(q[
    SELECT * FROM diary
      WHERE title = ? AND user_id = ?
      LIMIT 1
  ], $title, $user->id);

  unless ($row) {
    return undef;
  }

  return Intern::Diary::Model::Diary->new($row);
}

1;
