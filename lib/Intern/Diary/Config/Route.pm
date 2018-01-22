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
    };
}

1;
