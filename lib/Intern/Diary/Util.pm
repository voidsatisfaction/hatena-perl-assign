package Intern::Diary::Util;

use strict;
use warnings;
use utf8;

use String::Random qw(random_regex);

use DateTime;
use DateTime::Format::MySQL;

use Intern::Diary::Config;

sub now () {
    my $now = DateTime->now(time_zone => config->param('db_timezone'));
    $now->set_formatter( DateTime::Format::MySQL->new );
    $now;
}

sub datetime_from_db ($) {
    my $dt = DateTime::Format::MySQL->parse_datetime( shift );
    $dt->set_time_zone(config->param('db_timezone'));
    $dt->set_formatter( DateTime::Format::MySQL->new );
    $dt;
}

# QUESTION
# where is the right place for this util to be located?
sub random_string ($) {
  my $n = shift;
  unless ($n) {
    $n = 10;
  }
  return random_regex('\w{' . $n . '}');
}

1;
__END__
