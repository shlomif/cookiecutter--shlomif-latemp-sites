package HTML::Latemp::DocBook::GenMake;

use strict;
use warnings;

use Moo;

use Path::Tiny qw/ path /;
use Template                          ();
use HTML::Latemp::DocBook::DocsList   ();
use HTML::Latemp::DocBook::EndFormats ();

has [ 'dest_var', 'post_dest_var' ] => ( is => 'ro', required => 1 );
has [ 'disable_docbook4', ]         => ( is => 'ro', default  => '', );

my $gen_make_fn = "lib/make/docbook/sf-homepage-docbooks-generated.mak";

sub generate
{
    my ( $self, $args ) = @_;

    my $tt        = Template->new( {} );
    my $documents = HTML::Latemp::DocBook::DocsList->new->docs_list;

    my $disable_docbook4 = $self->disable_docbook4;
    my $output           = '';
    $tt->process(
        "lib/make/docbook/sf-homepage-docbook-gen.tt",
        {
            ( $disable_docbook4 ? ( docbook_versions => [ 5, ] ) : () ),
            DEST      => $self->dest_var,
            POST_DEST => $self->post_dest_var,
            (
                $disable_docbook4
                ? ()
                : ( docs_4 => [ grep { $_->{db_ver} != 5 } @$documents ], )
            ),
            docs_5 => [ grep { $_->{db_ver} == 5 } @$documents ],
            fmts =>
                scalar( HTML::Latemp::DocBook::EndFormats->new->get_formats ),
            top_header => <<"EOF",
### This file is auto-generated from gen-dobook-make-helpers.pl
EOF
        },
        ( \$output ),
    ) or die $tt->error();

    $output =~ s/\n{3,}/\n\n/g;

    path($gen_make_fn)->spew_utf8($output);

    return;
}

1;
