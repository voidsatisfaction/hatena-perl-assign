package t::Intern::Diary::Model::Article;

use strict;
use warnings;
use utf8;

use Test::More;

use Intern::Diary::Model::Article;

subtest 'Article model' => sub {
  my $args = {
    id => 18,
    title => 'test_test_article',
    body => 'lasdkmfalkmwflemflwekmflewkfmalkmeflamefkalwek',
    created_at => '1993-04-21 23:12:01',
    updated_at => '1993-04-21 23:12:01',
    diary_id => 10,
  };

  use_ok 'Intern::Diary::Model::Article';
  # QUESTION: why error?
  # isa_ok Intern::Diary::Model::Article->new, 'Intern::Diary::Model::Article';

  subtest 'Article-new success' => sub {
    my $article = Intern::Diary::Model::Article->new($args);

    ok $article, 'article exists';
    is $article->id, $args->{id}, 'id ok';
    is $article->title, $args->{title}, 'title ok';
    is $article->body, $args->{body}, 'body ok';
    is $article->diary_id, $args->{diary_id}, 'diary_id ok';
  };
};

done_testing

1;
