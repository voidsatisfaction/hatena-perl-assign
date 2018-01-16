#!/usr/local/bin perl

=pod
## Description

CLI diary application made by voidsatisfaction

## Usage

carton exec -- perl lib/diary.pl [username] [command] [parameter...]

e.g)
carton exec -- perl lib/diary.pl wlekmf add_diary my_diary
carton exec -- perl lib/diary.pl wlekmf add_diary my_diary

=cut

use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Carp;

use Intern::Diary::Context;
use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Article;

my %HANDLERS = (
  add_diary => \&add_diary,
  add_article => \&add_article,
  get_articles => \&get_articles,
  help => \&help,
);

# check @ARGV is enough
if (scalar(@ARGV) < 2) {
  help();
  exit 0;
}

my $user_name = shift @ARGV;
my $command = shift @ARGV;

# check command is already registered
unless (is_command_valid($command, %HANDLERS)) {
  help();
  exit 0;
}

my $dbh = Intern::Diary::Context->new->dbh // croak 'dbh is not set';

my $user = Intern::Diary::Service::User->get_or_create_by_name($dbh, +{
  name => $user_name,
});

my $handler = $HANDLERS{$command} // $HANDLERS{'help'};
$handler->($user, @ARGV);

exit 0;

sub is_command_valid {
  my ($command, %HANDLERS) = @_;

  return exists $HANDLERS{$command};
}

sub help {
  print '
# Usage

carton exec -- perl lib/diary.pl [username] [command] [parameter...]

# API example

## Diary

carton exec -- perl lib/diary.pl username add_diary my_diary

## Article

carton exec -- perl lib/diary.pl username add_article my_diary title [body]

';
}

sub add_diary {
  my ($user, $title) = @_;

  my $diary = Intern::Diary::Service::Diary->create($dbh, +{
    user => $user,
    title => $title,
  }) // croak 'diary does not exists';

  print "-------Diary: ${title}-------", "\n";
  print "is added", "\n";
  print "-----------------------------", "\n";
}

sub add_article {
  my ($user, $diary_title, $title, $body) = @_;

  my $diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($dbh, +{
    user => $user,
    title => $diary_title,
  }) // croak 'diary does not exist';

  my $article = Intern::Diary::Service::Article->create($dbh, +{
    title => $title,
    body => $body,
    diary => $diary,
  });

  print "-------Article: ${title}-------", "\n";
  print "$body", "\n";
  print "-------------------------------", "\n";
}

sub get_articles {
  my ($user, $diary_title) = @_;

  my $diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($dbh, +{
    user => $user,
    title => $diary_title,
  }) // croak 'diary does not exist';

  my $articles = Intern::Diary::Service::Article-> get_articles_by_diary($dbh, {
    diary => $diary,
  });
  my $length = scalar(@$articles);

  print "There are $length articles in total\n";
  foreach my $article (@$articles) {
    my $article_title = $article->title;
    my $article_body = $article->body;
    print '-' x 20, "\n";
    print "title: $article_title\n";
    print $article->body, "\n";
  }
}
