package Test::Intern::Diary::Mechanize;

use strict;
use warnings;
use utf8;

use parent qw(Test::WWW::Mechanize::PSGI);
use Plack::Builder;

use Test::More ();

use Exporter qw(import);
our @EXPORT = qw(create_mech);

use Intern::Diary;

my $app = builder {
    enable 'HTTPExceptions';

    Intern::Diary->as_psgi;
};

sub create_mech (;%) {
    return __PACKAGE__->new(@_);
}

sub new {
    my ($class, %opts) = @_;

    my $user = delete $opts{user} // undef;

    unless ($user) {
      my $self = $class->SUPER::new(
          app     => $app,
          %opts,
      );

      return $self;
    }

    my $user_name = $user->name;
    my $user_mw = sub {
      my $app = shift;
      sub {
        my $env = shift;
        # apply username cookie
        my $cookie = "username=$user_name";
        $env->{HTTP_COOKIE} = $cookie;
        $app->($env);
      };
    };


    my $self = $class->SUPER::new(
        app     => $user_mw->($app),
        %opts,
    );

    return $self;
}

1;
