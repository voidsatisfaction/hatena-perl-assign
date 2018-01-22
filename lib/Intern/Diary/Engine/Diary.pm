package Intern::Diary::Engine::Diary;

use strict;
use warnings;
use utf8;

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
    diaries => $diaries,
  });
}

1;
__END__
