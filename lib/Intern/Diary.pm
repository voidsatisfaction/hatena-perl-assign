package Intern::Diary;

use strict;
use warnings;
use utf8;

use Class::Load qw(load_class);

use Intern::Diary::Config;
use Intern::Diary::Context;

sub as_psgi {
    my $class = shift;
    return sub {
        my $env = shift;
        return $class->run($env);
    };
}

sub run {
    my ($class, $env) = @_;

    # make context with env
    my $context = Intern::Diary::Context->from_env($env);
    # about router matching
    my $route = Intern::Diary::Config->router->match($env)
        or $context->throw(404);
    # about query parameters
    $context->req->path_parameters(%{$route->{parameters}});

    # get destination
    my $destination = $route->{destination}
        or $context->throw(404);
    # get engine
    $destination->{engine}
        or $context->throw(404);

    my $engine = join '::', __PACKAGE__, 'Engine', $destination->{engine};
    my $action = $destination->{action} || 'default';
    my $dispatch = "$engine#$action";

    load_class $engine;

    # is there $action on $engine(controller)?
    my $handler = $engine->can($action)
        or $context->throw(501);
    $engine->$handler($context);

    $context->res->headers->header(X_Dispatch => $dispatch);
    # make 3 elements array and return
    return $context->res->finalize;
}

1;
