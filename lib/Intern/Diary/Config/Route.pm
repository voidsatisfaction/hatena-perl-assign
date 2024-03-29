package Intern::Diary::Config::Route;

use strict;
use warnings;
use utf8;

use Intern::Diary::Config::Route::Declare;

sub make_router {
    return router {
        # Index controller
        connect '/' => {
          engine => 'Index',
          action => 'default',
        };

        # User controller
        connect '/signin' => {
          engine => 'User',
          action => 'signin_get',
        } => { method => 'GET' };
        connect '/signin' => {
          engine => 'User',
          action => 'signin_post',
        } => { method => 'POST' };
        connect '/signout' => {
          engine => 'User',
          action => 'signout_post',
        } => { method => 'POST' };

        # Diary controller
        connect '/diary/new' => {
          engine => 'Diary',
          action => 'new_diary_get',
        } => { method => 'GET' };
        connect '/diary' => {
          engine => 'Diary',
          action => 'new_diary_post',
        } => { method => 'POST' };
        connect '/:username' => {
          engine => 'Diary',
          action => 'user_diaries_get',
        } => { method => 'GET' };

        # Article controller
        connect '/article/new' => {
          engine => 'Article',
          action => 'new_article_get',
        };
        connect '/article' => {
          engine => 'Article',
          action => 'new_article_post',
        } => { method => 'POST' };
        connect '/article/delete/:article_id' => {
          engine => 'Article',
          action => 'article_delete',
        } => { method => 'POST' };
        connect '/:username/:diarytitle' => {
          engine => 'Article',
          action => 'user_diary_articles_get',
        };
    };
}

1;
