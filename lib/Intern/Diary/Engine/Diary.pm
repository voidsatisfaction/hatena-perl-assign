package Intern::Diary::Engine::Diary;

use strict;
use warnings;
use utf8;

use Carp;

use Intern::Diary::Context;

use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;

sub user_diaries_get {
  my ($class, $c) = @_;

  my $user_name = $c->req->parameters->{username};
  my $user = Intern::Diary::Service::User->get_user_by_name($c->dbh, +{
    name => $user_name,
  });

  my $diaries = Intern::Diary::Service::Diary->get_diaries_by_user($c->dbh, +{
    user => $user,
  });

  $c->html('diary/user_diaries_get.html', +{
    owner => $user_name,
    diaries => $diaries,
  });
}

sub new_diary_get {
  my ($class, $c) = @_;
  $c->check_signin_and_redirect;

  $c->html('diary/new_diary_get.html');
}

sub new_diary_post {
  my ($class, $c) = @_;
  $c->check_signin_and_redirect;

  my $user = $c->user;
  my $diary_title = $c->req->parameters->{diary_title};

  Intern::Diary::Service::Diary->get_or_create_by_user_and_title($c->dbh, +{
    user => $user,
    title => $diary_title,
  }) // croak 'diary should exists';

  my $user_name = $user->name;
  $c->throw_redirect("/$user_name");
}

1;
__END__
