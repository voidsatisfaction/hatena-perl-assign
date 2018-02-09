package Intern::Diary::Engine::Index;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::Article;

sub default {
    my ($class, $c) = @_;

    my $per_page = $c->req->parameters->{per_page} // $c->default_per_page;
    my $page = $c->req->parameters->{page} // 0;

    my $articles = Intern::Diary::Service::Article->get_articles($c->dbh, +{
      page => $page,
      per_page => $per_page,
      order_by => 'created_at DESC',
    });

    $c->html('index.html', {
      articles => $articles,
      next_page => $page + 1,
      per_page => $per_page,
    });
}

1;
__END__
