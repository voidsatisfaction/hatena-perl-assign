package Intern::Diary::Util;

use strict;
use warnings;
use utf8;

use String::Random qw(random_regex);

use DateTime;
use DateTime::Format::MySQL;
use DateTime::Format::Strptime;

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

sub datetime_to_cookie_string ($) {
  my $dt = shift;
  my $formatter = DateTime::Format::Strptime->new(
    pattern => '%j%m%G %l%M %p',
  );
  $dt->set_formatter($formatter);
}

1;
__END__
