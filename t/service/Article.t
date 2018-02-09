package t::Intern::Diary::Service::Article;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent qw(Test::Class);

use Test::More;
use Test::Deep;
use Test::Exception;
use Test::Intern::Diary::Util;
use Test::Intern::Diary::Factory;

use Intern::Diary::Context;
use Intern::Diary::Service::Article;

sub _require : Test(startup => 1) {
  my ($self) = @_;
  require_ok 'Intern::Diary::Service::Article';
}

sub get_article_by_diary_and_title : Test(3) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  my $diary = create_diary;
  my $article = create_article(
    diary => $diary,
  );
  subtest 'Fail: title is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Article->get_article_by_diary_and_title($db, +{
        diary => $diary
      });
    };
  };

  subtest 'Fail: diary is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Article->get_article_by_diary_and_title($db, +{
        title => $article->title,
      });
    };
  };

  subtest 'Success' => sub {
    my $title = $article->title;

    my $get_article = Intern::Diary::Service::Article->get_article_by_diary_and_title($db, +{
      title => $article->title,
      diary => $diary,
    });

    ok $get_article, 'article exists';
    isa_ok $get_article, 'Intern::Diary::Model::Article', 'article is blessed';
    ok cmp_deeply($get_article, $article), 'article ok';
  };
}

sub get_articles : Test(3) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  for (my $i = 0; $i < 21; $i++) {
    # time.sleep
    create_article
  }

  subtest 'Success: designated per_page' => sub {
    my $get_articles = Intern::Diary::Service::Article->get_articles($db, +{
      per_page => 10,
      page => 0,
      order_by => 'created_at DESC',
    });

    is scalar(@$get_articles), 10, '10 articles';
  };

  subtest 'Success: not designated per_page' => sub {
    my $get_articles = Intern::Diary::Service::Article->get_articles($db, +{
      page => 0,
      order_by => 'created_at DESC',
    });

    is scalar(@$get_articles), 10, 'default maximum is 15'
  };

  subtest 'Success: more than max_per_page' => sub {
    my $get_articles = Intern::Diary::Service::Article->get_articles($db, +{
      per_page => 100,
      page => 0,
      order_by => 'created_at DESC',
    });

    is scalar(@$get_articles), 15, 'per_page maximum is 15'
  };
}

sub get_article_by_article_id : Test(2) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  my $article = create_article;
  subtest 'Fail: id is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Artice->get_article_by_article_id($db, +{});
    };
  };

  subtest 'Success' => sub {
    my $get_article = Intern::Diary::Service::Article->get_article_by_article_id($db, +{
      article_id => $article->id,
    });

    ok $get_article, 'article exists';
    isa_ok $get_article, 'Intern::Diary::Model::Article', 'article is blessed';
    ok cmp_deeply($get_article, $article), 'article ok';
  };
}

sub get_articles_by_diary : Test(2) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  my $diary = create_diary();
  subtest 'Fail: diary is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Article->get_articles_by_diary($db, +{});
    };
  };

  subtest 'Success' => sub {
    my $get_articles = Intern::Diary::Service::Article->get_articles_by_diary($db, +{
      diary => $diary,
    });

    is scalar(@$get_articles), 0, 'article does not exists';

    my $n = 10;
    for (my $i = 0; $i < $n; $i++) {
      create_article((diary => $diary));
      create_article();
    }

    $get_articles = Intern::Diary::Service::Article->get_articles_by_diary($db, +{
      diary => $diary,
    });

    is scalar(@$get_articles), $n, "$n articles are fetched";
  };
}

sub create : Test(3) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  my $diary = create_diary;
  my $title = Test::Intern::Diary::Util::random_string(30);

  subtest 'Fail: title is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Article->create($db, +{
        diary => $diary,
      });
    };
  };

  subtest 'Fail: diary is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Article->create($db, +{
        title => $title,
      });
    };
  };

  subtest 'Success' => sub {
    my $created_article = Intern::Diary::Service::Article->create($db, +{
      title => $title,
      diary => $diary,
    });

    ok $created_article, 'article exists';
    isa_ok $created_article, 'Intern::Diary::Model::Article', 'article is blessed';
    is $created_article->title, $title, 'title is same';
    is $created_article->diary_id, $diary->id, 'diary_id is same';
  }
}

sub delete_by_article_id : Test(2) {
  my ($self) = @_;

  my $db = Intern::Diary::Context->new->dbh;

  my $user = create_user;
  my $diary = create_diary(user => $user);
  my $article = create_article(diary => $diary);

  subtest 'Fail: id is undefined' => sub {
    dies_ok {
      Intern::Diary::Service::Article->delete_by_article_id($db, +{});
    };
  };

  subtest 'Success' => sub {
    Intern::Diary::Service::Article->delete_by_article_id($db, +{
      article_id => $article->id,
    });

    my $deleted_article = Intern::Diary::Service::Article->get_article_by_diary_and_title($db, +{
      diary => $diary,
      title => $article->title,
    });

    ok !$deleted_article, 'article has been deleted';
  };
}

__PACKAGE__->runtests;

1;
