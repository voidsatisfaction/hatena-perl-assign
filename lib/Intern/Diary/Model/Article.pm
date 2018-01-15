package Intern::Diary::Model::Article;

use strict;
use warnings;
use utf8;

use Intern::Diary::Util;

use Class::Accessor::Lite (
  ro => [qw(
    id
    title
    body
    diary_id
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

sub updated_at {
  my ($self) = @_;

  $self->{_updated_at} ||= eval {
    Intern::Diary::Util::datetime_from_db(
      $self->{updated_at}
    );
  };
}

1;
