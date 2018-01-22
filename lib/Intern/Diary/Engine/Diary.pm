package Intern::Diary::Engine::Diary;

use strict;
use warnings;
use utf8;

use Intern::Diary::Context;

use Intern::Diary::Service::Diary;

sub user_diaries_get {
  my ($class, $c) = @_;
  $c->check_signin_and_redirect;

  my $diaries = Intern::Diary::Service::Diary->get_diaries_by_user($c->dbh, +{
    user => $c->user,
  });

  $c->html('diary/user_diaries_get.html', +{
    diaries => $diaries,
  });
}

1;
__END__
