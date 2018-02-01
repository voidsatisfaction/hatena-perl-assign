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

sub get_diaries_by_user {
  my ($class, $dbh, $args) = @_;

  my $user = $args->{user} // croak 'user required';

  my $rows = $dbh->select_all(q[
    SELECT * FROM diary
      WHERE user_id = ?
  ], $user->id);

  return [ map { Intern::Diary::Model::Diary->new($_) } @$rows ];
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

sub get_or_create_by_user_and_title {
  my ($class, $db, $args) = @_;

  return $class->get_diary_by_user_and_title($db, $args) // $class->create($db, $args);
}

sub get_diary_by_article {
  my ($class, $db, $args) = @_;

  my $article = $args->{article} // croak 'article required';

  my $row = $db->select_row(q[
    SELECT * FROM diary
      WHERE
        id = ?
      LIMIT 1
  ], $article->diary_id) or return;

  return Intern::Diary::Model::Diary->new($row);
}

1;
