package Intern::Diary::Engine::Article;

use strict;
use warnings;
use utf8;

use Carp;

use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Article;

sub new_article_get {
  my ($class, $c) = @_;
  $c->check_signin_and_redirect;

  my $user = $c->user;

  my $diaries = Intern::Diary::Service::Diary->get_diaries_by_user($c->dbh, +{
    user => $user,
  });

  $c->html('article/new_article_get.html', +{
    diaries => $diaries,
  });
}

sub new_article_post {
  my ($class, $c) = @_;
  $c->check_signin_and_redirect;

  my $user = $c->user;
  my $diary_title = $c->req->parameters->{diary_title};
  my $article_title = $c->req->parameters->{article_title};
  my $article_body = $c->req->parameters->{article_body};
  # QUESTION: Redirect with alert message? e.g. diary_title cannot be blank
  return $c->throw_redirect("/article/new") unless $diary_title && $article_title;

  # QUESTION: Validation?
  my $diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($c->dbh, +{
    user => $user,
    title => $diary_title,
  });

  Intern::Diary::Service::Article->create($c->dbh, +{
    title => $article_title,
    body => $article_body,
    diary => $diary,
  }) // croak 'article should exist';

  my $user_name = $user->name;

  $c->throw_redirect("/$user_name/$diary_title");
}

sub user_diary_articles_get {
  my ($class, $c) = @_;

  my $user_name = $c->req->parameters->{username};
  my $diary_title = $c->req->parameters->{diarytitle};

  # QUESTION: JOIN vs individual query
  my $user = Intern::Diary::Service::User->get_user_by_name($c->dbh, +{
    name => $user_name,
  });

  my $diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($c->dbh, +{
    user => $user,
    title => $diary_title,
  });

  my $articles = Intern::Diary::Service::Article->get_articles_by_diary($c->dbh, +{
    diary => $diary,
  });

  $c->html('article/user_diary_articles_get.html', +{
    owner => $user_name,
    articles => $articles,
  });
}

sub article_delete {
  my ($class, $c) = @_;
  $c->check_signin_and_redirect;

  my $article_id = $c->req->parameters->{article_id};
  my $article = Intern::Diary::Service::Article->get_article_by_article_id($c->dbh, +{
    article_id => $article_id,
  });
  my $article_user = Intern::Diary::Service::User->get_user_by_article($c->dbh, +{
    article => $article,
  });

  unless ($c->check_same_user($article_user)) {
    return $c->error(403);
  }

  Intern::Diary::Service::Article->delete_by_article_id($c->dbh, +{
    article_id => $article_id,
  });

  my $user_name = $c->user->name;
  $c->throw_redirect("/$user_name");
}

1;
__END__
