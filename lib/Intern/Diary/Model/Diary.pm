package Intern::Diary::Model::Diary;

use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
  ro => [qw(
    id
    title
  )],
  new => 1,
);

1;
