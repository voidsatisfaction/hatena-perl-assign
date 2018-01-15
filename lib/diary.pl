#!/usr/local/bin perl
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
);

my $user_name = shift @ARGV;
my $command = shift @ARGV;

my $dbh = Intern::Diary::Context->new->dbh // croak 'dbh is not set';

my $user = Intern::Diary::Service::User->get_or_create_by_name($dbh, +{
  name => $user_name,
});

my $handler = $HANDLERS{$command};
$handler->($user, @ARGV);

exit 0;

sub add_diary {
  my ($user, $title) = @_;

  my $diary = Intern::Diary::Service::Diary->create($dbh, +{
    user => $user,
    title => $title,
  });

  print "-------Diary: ${title}-------", "\n";
  print "is added", "\n";
  print "-----------------------------", "\n";
}

sub add_article {
  my ($user, $diary_title, $title, $body) = @_;

  my $diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($dbh, +{
    title => $diary_title,
    user => $user,
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
