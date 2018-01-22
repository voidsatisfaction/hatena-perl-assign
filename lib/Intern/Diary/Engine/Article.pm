package Intern::Diary::Engine::Article;

use strict;
use warnings;
use utf8;

use Intern::Diary::Service::User;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::Article;

sub user_diary_articles_get {
  my ($class, $c) = @_;

  my $user_name = $c->req->parameters->{username};
  my $diary_title = $c->req->parameters->{diarytitle};

  # QUESTION: JOIN vs individual query
  my $user = Intern::Diary::Service::User->get_user_by_name($c->dbh, +{
    name => $user_name,
  });

  my $diary = Intern::Diary::Service::Diary->get_diary_by_user_and_title($c->dbh, +{
    user => $user,
    title => $diary_title,
  });

  my $articles = Intern::Diary::Service::Article->get_articles_by_diary($c->dbh, +{
    diary => $diary,
  });

  $c->html('article/user_diary_articles_get.html', +{
    articles => $articles,
  });
}

1;
__END__
