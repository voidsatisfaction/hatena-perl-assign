package Intern::Diary::Engine::Index;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::Article;

sub default {
    my ($class, $c) = @_;

    my $articles = Intern::Diary::Service::Article->get_articles($c->dbh);

    $c->plain_text($articles);
}

1;
__END__
