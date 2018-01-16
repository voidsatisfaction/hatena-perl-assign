package Test::Intern::Diary::Util;

use strict;
use warnings;
use utf8;

use String::Random qw(random_regex);

sub random_string ($) {
  my $n = shift;
  unless ($n) {
    $n = 10;
  }
  return random_regex('\w{' . $n . '}');
}

1;
