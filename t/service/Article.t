package t::Intern::Diary::Service::Article;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent qw(Test::Class);

use Test::More;
use Test::Deep;
use Test::Exception;
use Test::Intern::Diary::Factory;

use Intern::Diary::Util;
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

__PACKAGE__->runtests;

1;
