package Intern::Diary::Engine::User;

use strict;
use warnings;
use utf8;

use DateTime;

sub signin_get {
  my ($class, $c) = @_;

  $c->html('signin.html', +{});
}

sub signin_post {
  my ($class, $c) = @_;

  my $user_name = $c->req->parameters->{username};

  # TODO: not use cookie, use session
  $c->set_cookie(+{
    key => 'username',
    value => $user_name,
  });

  $c->res->redirect('/');
}

sub signout_post {
  my ($class, $c) = @_;

  my $user_name = $c->user->name;

  $c->set_cookie(+{
    key => 'username',
    # Too old days
    expires => DateTime->now->set( year => 2000 ),
  });
}

1;
__END__
