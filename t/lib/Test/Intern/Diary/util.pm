package Test::Intern::Diary::Util;

sub random_string ($) {
  my $n = shift;
  unless ($n) {
    $n = 10;
  }
  return random_regex('\w{' . $n . '}');
}

1;
