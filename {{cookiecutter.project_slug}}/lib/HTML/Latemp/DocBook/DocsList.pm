package HTML::Latemp::DocBook::DocsList;

use strict;
use warnings;
use autodie;

use Moo;

use YAML::XS ();

my @documents = @{ YAML::XS::LoadFile("./lib/docbook/docs.yaml") };

foreach my $d (@documents)
{
    if ( $d->{db_ver} ne 5 )
    {
        die "Illegal db_ver $d->{db_ver}!";
    }

    if ( !exists( $d->{custom_css} ) )
    {
        $d->{custom_css} = 0;
    }

    if ( !exists( $d->{del_revhistory} ) )
    {
        $d->{del_revhistory} = 0;
    }
}

sub docs_list
{
    my $self = shift;

    return \@documents;
}

1;
