package Intern::Diary::Engine::API::Article;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::Article;

sub all_articles_with_pagination {
  my ($class, $c) = @_;

  my $page = $c->req->parameters->{page};
  my $per_page = $c->req->parameters->{per_page} // $c->default_per_page;

  my $articles = Intern::Diary::Service::Article->get_articles($c->dbh, +{
    per_page => $per_page,
    page => $page,
    order_by => 'created_at DESC'
  });

  my $json_articles = [ map { $_->json_hash } @$articles ];

  $c->json(+{
    articles => $json_articles,
    per_page => $per_page,
    next_page => $page + 1,
  });
}

1;
__END__
