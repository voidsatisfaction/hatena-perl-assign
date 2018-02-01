package Intern::Diary::Engine::API::Article;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::Article;

sub all_articles_with_pagination {
  my ($class, $c) = @_;

  # TODO: make pagination setting

  my $articles = Intern::Diary::Service::Article->get_articles($c->dbh, +{
    per_page => 10,
    page => 0,
  });

  my $json_articles = [ map { $_->json_hash } @$articles ];

  $c->json($json_articles);
}

1;
__END__
