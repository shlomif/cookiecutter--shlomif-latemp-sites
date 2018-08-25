use strict;
use warnings;
use Test::Code::TidyAll qw/ tidyall_ok /;

my $KEY = 'TIDYALL_DATA_DIR';
tidyall_ok( ( exists( $ENV{$KEY} ) ? ( data_dir => $ENV{$KEY} ) : () ) );
