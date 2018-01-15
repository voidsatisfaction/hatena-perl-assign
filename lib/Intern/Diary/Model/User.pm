package Intern::Diary::Model::User;

use strict;
use warnings;
use utf8;

use DateTime;
use DateTime::Format::MySQL;

use Intern::Diary::Util;

use Class::Accessor::Lite (
  ro => [qw(
    id
    name
  )],
  new => 1,
);

sub created_at {
  my ($self) = @_;
  $self->{_created_at} ||= eval {
    Intern::Diary::Util::datetime_from_db(
      $self->{created_at}
    );
  };
}

1;
