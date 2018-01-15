package Test::Intern::Diary::Factory;

use strict;
use warnings;
use utf8;

use String::Random qw(random_regex);
use Exporter::Lite;

our @EXPORT = qw(
  create_user
  create_diary
  create_article
);

use Intern::Diary::Util;
use Intern::Diary::Context;
use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Article;

sub create_user {
  my %args = @_;

  my $name = $args{name} // random_regex('test_user_\w{15}');
  my $created_at = $args{created_at} // Intern::Diary::Util->now;

  my $c = Intern::Diary::Context->new;
  my $dbh = $c->dbh;

  $dbh->query(q[
    INSERT INTO user (name, created_at)
      VALUES (?)
  ], [ $name, $created_at ]);

  return Intern::Diary::Service::User->get_user_by_name($dbh, +{
    name => $name,
  });
}

sub create_diary {
  my %args = @_;

  my $title = $args{title} // random_regex('test_diary_\w{30}');
  my $user = $args{user} // create_user;

  my $c = Intern::Diary::Context->new;
  my $dbh = $c->dbh;

  $dbh->query(q[
    INSERT INTO diary (title, user_id)
      VALUES (?)
  ], [ $title, $user->id ]);

  return Intern::Diary::Service::Diary->get_diary_by_user_and_title($dbh, +{
    title => $title,
    user => $user,
  });
}

sub create_article {
  my %args = @_;

  my $title = $args{title} // random_regex('test_article_\w{30}');
  my $body = $args{body} // random_regex('test_article_\w{200}');
  my $created_at = $args{created_at} // Intern::Diary::Util->now;
  my $updated_at = $args{updated_at} // Intern::Diary::Util->now;
  my $diary = $args{diary} // create_diary;

  my $c = Intern::Diary::Context->new;
  my $dbh = $c->dbh;

  $dbh->query(q[
    INSERT INTO article (title, body, created_at, updated_at, diary_id)
      VALUES (?)
  ], [ $title, $body, $created_at, $updated_at, $diary->id ]);

  return Intern::Diary::Service::Article->get_article_by_diary_and_title($dbh, +{
    title => $title,
    diary => $diary,
  });
}

1;
