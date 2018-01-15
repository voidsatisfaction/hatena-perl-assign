package Intern::Diary::Service::Article;

use strict;
use warnings;
use utf8;

use Carp;

use Intern::Diary::Util;
use Intern::Diary::Model::Article;

sub get_article_by_diary_and_title {
  my ($class, $dbh, $args) = @_;

  my $title = $args->{title} // croak 'title required';
  my $diary = $args->{diary} // croak 'diary required';

  my $row = $dbh->select_row(q[
    SELECT * FROM article
      WHERE title = ? AND diary_id = ?
      LIMIT 1
  ], $title, $diary->id);

  return Intern::Diary::Model::Article->new($row);
}

sub create {
  my ($class, $dbh, $args) = @_;

  my $title = $args->{title} // croak 'title required';
  my $body = $args->{body} // '';
  my $created_at = Intern::Diary::Util->now;
  my $updated_at = Intern::Diary::Util->now;
  my $diary = $args->{diary} // croak 'diary required';

  my $c = Intern::Diary::Context->new;
  $dbh = $c->dbh;

  $dbh->query(q[
    INSERT INTO article (title, body, created_at, updated_at, diary_id)
      VALUES (?)
  ], [ $title, $body, $created_at, $updated_at, $diary->id ]);

  return $class->get_article_by_diary_and_title($dbh, +{
    title => $title,
    diary => $diary,
  });
}

1;
