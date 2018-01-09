package Intern::Diary::Model::User;

use strict;
use warnings;
use utf8;

use Data::Dumper;

use DateTime;
use DateTime::Format::MySQL;

use Class::Accessor::Lite (
  ro => [qw(
    id
    name
  )],
  new => 1,
);

# QUESTION: What is the meaning of this method?
# Just for cache?
sub created_at {
  my ($self) = @_;
  $self->{_created_at} ||= eval {
    my $dt = DateTime::Format::MySQL->parse_datetime( $self->{created_at} );
    $dt -> set_time_zone('UTC');
    $dt -> set_formatter( DateTime::Format::MySQL->new );
    $dt;
  };
}

1;
