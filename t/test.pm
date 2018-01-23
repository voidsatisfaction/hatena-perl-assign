package t::Test;

use strict;
use warnings;
use utf8;

use lib 'lib', 't/lib';

BEGIN {
  $ENV{INTERN_DIARY_ENV} = 'TEST';
}

1;
