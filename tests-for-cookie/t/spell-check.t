#!/usr/bin/env perl

use strict;
use warnings;

use lib '../{{cookiecutter.project_slug}}/lib/';
use lib './t/lib';

use Test::More;

if ( $ENV{SKIP_SPELL_CHECK} )
{
    plan skip_all => 'Skipping spell check due to environment variable';
}
else
{
    plan tests => 1;
}

require Shlomif::Spelling::Iface;

# TEST
Shlomif::Spelling::Iface->new->test_spelling("No spelling errors.");
