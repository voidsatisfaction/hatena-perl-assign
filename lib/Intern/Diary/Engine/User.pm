package Intern::Diary::Engine::User;

use strict;
use warnings;
use utf8;

sub signin_get {
  my ($class, $c) = @_;

  $c->html('signin.html', +{});
}

sub signin_post {
  my ($class, $c) = @_;

  my $user_name = $c->req->parameters->{username};

  $c->plain_text($user_name);
}

1;
__END__
