package t::Intern::Diary::Engine::Article;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::More;

use URI;
use URI::QueryParam;

use t::Test;
use Test::Intern::Diary::Util qw(random_string);
use Test::Intern::Diary::Factory qw(create_user create_diary create_article);
use Test::Intern::Diary::Mechanize qw(create_mech);

use Intern::Diary::Context;
use Intern::Diary::Service::Article;

sub _user_diary_articles_get : Tests {
  my $user = create_user;
  my $user_name = $user->name;
  my $diary = create_diary(user => $user);
  my $diary_title = $diary->title;
  my $article1 = create_article(diary => $diary);
  my $article1_title = $article1->title;
  my $article2 = create_article(diary => $diary);
  my $article2_title = $article2->title;

  my $permalink = URI->new("/$user_name/$diary_title");

  subtest 'not logged in' => sub {
    my $mech = create_mech;
    $mech->get_ok($permalink);
    $mech->content_lacks('edit');
    $mech->content_lacks('/article/delete');
    $mech->content_lacks('/article/new');
    $mech->content_contains($article1_title);
    $mech->content_contains($article2_title);
  };

  subtest 'other user' => sub {
    my $other_user = create_user;
    my $mech = create_mech(user => $other_user);
    $mech->get_ok($permalink);
    $mech->content_lacks('edit');
    $mech->content_lacks('/article/delete');
    $mech->content_lacks('/article/new');
    $mech->content_contains($article1_title);
    $mech->content_contains($article2_title);
  };

  subtest 'owner' => sub {
    my $mech = create_mech(user => $user);
    $mech->get_ok($permalink);
    $mech->content_contains('edit');
    $mech->content_contains('/article/delete');
    $mech->content_contains('/article/new');
    $mech->content_contains($article1_title);
    $mech->content_contains($article2_title);
  }
}

sub _new_article_get : Tests {
  my $user = create_user;
  my $user_name = $user->name;
  my $diary = create_diary(user => $user);
  my $diary_title = $diary->title;

  subtest 'guest' => sub {
    my $mech = create_mech;
    $mech->get_ok('/article/new');
    $mech->title_is('Intern::Diary::Signin');
  };

  subtest 'logged in' => sub {
    my $mech = create_mech(user => $user);
    $mech->get_ok('/article/new');
    $mech->title_is('Intern::Diary::Article::New');
  };
}

sub _new_article_post : Tests {
  my $c = Intern::Diary::Context->new;
  my $user = create_user;
  my $diary = create_diary(user => $user);
  my $diary_title = $diary->title;

  subtest 'guest' => sub {
    my $mech = create_mech;
    $mech->post('/article', +{
      diary_title => $diary_title,
    });
    # redirect to signin
    $mech->title_is('Intern::Diary::Signin');
  };

  subtest 'logged in' => sub {
    my $article_title = random_string(20);
    my $article_body = random_string(30);
    my $mech = create_mech(user => $user);
    subtest 'Success: add new article' => sub {
      $mech->get_ok('/article/new');
      $mech->submit_form_ok(+{
        fields => {
          diary_title => $diary_title,
          article_title => $article_title,
          article_body => $article_body,
        },
      });

      my $created_article = Intern::Diary::Service::Article->get_article_by_diary_and_title($c->dbh, +{
        title => $article_title,
        diary => $diary,
      });

      ok $created_article, 'article created';
      is $created_article->title, $article_title, 'article titles are same';
      is $created_article->body, $article_body, 'article bodies are same';
    };
  };
}

__PACKAGE__->runtests;

1;
__END__
