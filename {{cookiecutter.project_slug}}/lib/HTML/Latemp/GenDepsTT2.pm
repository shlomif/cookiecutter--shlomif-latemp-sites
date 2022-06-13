package HTML::Latemp::GenDepsTT2;

use strict;
use warnings;
use 5.014;

use File::Find::Object::Rule ();
use Path::Tiny               qw/ path /;

use Moo;

has [ 'src_dir', 'src_var', ] => ( is => 'ro', required => 1, );

sub _map_tt2_to_deps
{
    my $self  = shift;
    my $files = shift;

    my $src_dir = $self->src_dir;
    my $src_var = $self->src_var;

    return [
        map {
            my $s = $_;
            $s =~ s{\.tt2\z}{};
            $s =~ s{\A(?:\./)?\Q$src_dir\E/}{$src_var/};
            $s;
        } @$files
    ];
}

# Write deps.mak
sub run
{
    my ( $self, $args ) = @_;
    my @files = File::Find::Object::Rule->name('*.tt2')->in( $self->src_dir );

    my $rule    = File::Find::Object::Rule->new;
    my $discard = $rule->new->directory->name(
        qr{\A(?:screenplay-xml/from-vcs|fiction-xml|presentations|MathJax)\z})
        ->prune->discard;

    my @headers =
        map { ( $_ . '' ) =~ s{\Alib/}{}r }
        File::Find::Object::Rule->or( $discard, $rule->new() )
        ->name(qr/\.(tt2|html|xhtml)\z/)->in('lib');

    my %files_containing_headers =
        ( map { $_ => { re => qr{^\#include *"\Q$_\E"}ms, files => {}, }, }
            @headers, );

    foreach my $fn (@files)
    {
        my $contents = path($fn)->slurp_utf8;

        foreach my $match ( $contents =~
m{^\[%\s+(?:INCLUDE\s*|PROCESS\s*|INSERT\s*|path_slurp\s*\(\s*)"([^"]+)"}gms
            )
        {
            if ( exists( $files_containing_headers{$match} )
                or ( $match =~ m#\Adocbook/|fiction-xml/|screenplay-xml/# ) )
            {
                $files_containing_headers{$match}{files}{$fn} = 1;
            }
        }
    }

    my $deps_text = "";

    foreach my $header ( sort { $a cmp $b } keys(%files_containing_headers) )
    {
        my $header_deps = [
            sort { $a cmp $b }
                keys( %{ $files_containing_headers{$header}{files} } )
        ];

        if (@$header_deps)
        {
            $deps_text .=
                join( ' ', @{ $self->_map_tt2_to_deps($header_deps) } );

            $deps_text .= ": lib/$header\n\n";
        }
    }

    path("lib/make/deps.mak")->spew_utf8($deps_text);

    return;
}

1;

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
