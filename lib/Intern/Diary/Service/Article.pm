package Intern::Diary::Service::Article;

use strict;
use warnings;
use utf8;

use Carp;

use Intern::Diary::Util;
use Intern::Diary::Context;
use Intern::Diary::Model::Article;

sub get_article_by_diary_and_title {
  my ($class, $dbh, $args) = @_;

  my $title = $args->{title} // croak 'title required';
  my $diary = $args->{diary} // croak 'diary required';

  my $row = $dbh->select_row(q[
    SELECT * FROM article
      WHERE
        title = ?
          AND
        diary_id = ?
      LIMIT 1
  ], $title, $diary->id) or return;

  return Intern::Diary::Model::Article->new($row);
}

sub get_article_by_article_id {
  my ($class, $dbh, $args) = @_;

  my $article_id = $args->{article_id} // croak 'article_id required';

  my $row = $dbh->select_row(q[
    SELECT * FROM article
      WHERE
        id = ?
      LIMIT 1
  ], $article_id) or return;

  return Intern::Diary::Model::Article->new($row);
}

sub get_articles_by_diary {
  my ($class, $dbh, $args) = @_;

  my $diary = $args->{diary} // croak 'diary required';

  my $rows = $dbh->select_all(q[
    SELECT * FROM article
      WHERE diary_id = ?
  ], $diary->id) or return;

  return [ map { Intern::Diary::Model::Article->new($_) } @$rows ];
}

sub get_articles {
  my ($class, $dbh, $args) = @_;

  my $c = Intern::Diary::Context->new;

  my $per_page = $args->{per_page} // $c->default_per_page;
  if ($per_page > $c->max_per_page) {
    $per_page = $c->max_per_page;
  }
  my $page = $args->{page} // 0;
  my $order_by = $args->{order_by} // 'created_at DESC';
  my $offset = $page * $per_page;

  my $rows = $dbh->select_all(q[
    SELECT * FROM article
      ORDER BY ?
      LIMIT ?
      OFFSET ?
  ], $order_by, $per_page, $offset) or return;

  return [ map { Intern::Diary::Model::Article->new($_) } @$rows ];
}

sub create {
  my ($class, $dbh, $args) = @_;

  my $title = $args->{title} // croak 'title required';
  my $body = $args->{body} // '';
  my $created_at = Intern::Diary::Util->now;
  my $updated_at = Intern::Diary::Util->now;
  my $diary = $args->{diary} // croak 'diary required';

  $dbh->query(q[
    INSERT INTO article (title, body, created_at, updated_at, diary_id)
      VALUES (?)
  ], [ $title, $body, $created_at, $updated_at, $diary->id ]);

  return $class->get_article_by_diary_and_title($dbh, +{
    title => $title,
    diary => $diary,
  });
}

sub delete_by_article_id {
  my ($class, $dbh, $args) = @_;

  my $article_id = $args->{article_id} // croak 'article_id required';

  $dbh->query(q[
    DELETE FROM article
      WHERE
        id = ?
  ], $article_id);
}

1;
