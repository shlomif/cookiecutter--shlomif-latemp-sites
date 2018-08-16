package App::Deps::Verify;

use strict;
use warnings;

use Moo;

use File::Which qw/ which /;
use YAML::XS qw/ LoadFile /;

sub verify_deps_in_yaml
{
    my ( $self, $modules_fn ) = @_;

    return $self->find_deps( LoadFile($modules_fn) );
}

sub find_exes
{
    my ( $self, $lines ) = @_;

    my @not_found;
    foreach my $line (@$lines)
    {
        my $cmd = $line->{exe};
        if (
            not(
                  ( $cmd =~ m{\A/} )
                ? ( -e $cmd )
                : ( defined( scalar( which($cmd) ) ) )
            )
            )
        {
            push @not_found, $line;
        }
    }

    if (@not_found)
    {
        print "The following commands could not be found:\n\n";
        foreach my $cmd ( sort { $a->{exe} cmp $b->{exe} } @not_found )
        {
            print "$cmd->{exe}\t$cmd->{url}\n";
        }
        exit(-1);
    }
    return;
}

sub find_perl5_modules
{
    my ( $self, $required_modules ) = @_;

    my @not_found;

    foreach my $m ( sort { $a cmp $b } keys(%$required_modules) )
    {
        my $v = $required_modules->{$m};
        local $SIG{__WARN__} = sub { };
        my $verdict = eval( "use $m " . ( $v || '' ) . ' ();' );
        my $Err = $@;

        if ($Err)
        {
            push @not_found, $m;
        }
    }

    if (@not_found)
    {
        print "The following modules could not be found:\n\n";
        foreach my $module (@not_found)
        {
            print "$module\n";
        }
        exit(-1);
    }
    return;
}

sub find_python3_modules
{
    my ( $self, $mods ) = @_;
    my @required_modules = keys %$mods;
    my @not_found;

    foreach my $module (@required_modules)
    {
        if ( $module !~ m#\A[a-zA-Z0-9_\.]+\z# )
        {
            die "invalid python3 module id - $module !";
        }
        if ( system( 'python3', '-c', "import $module" ) != 0 )
        {
            push @not_found, $module;
        }
    }
    if (@not_found)
    {
        print "The following python3 modules could not be found:\n\n";
        foreach my $module (@not_found)
        {
            print "$module\n";
        }
        exit(-1);
    }
    return;
}

sub find_required_files
{
    my ( $self, $required_files ) = @_;

    my @not_found;

    foreach my $path (@$required_files)
    {
        my $p = $path->{path};
        if ( $p =~ m#[\\\$]# )
        {
            die "Invalid path $p!";
        }
        if ( !-e ( $p =~ s#\A~/#$ENV{HOME}/#r ) )
        {
            push @not_found, $path;
        }
    }

    if (@not_found)
    {
        print "The following required files could not be found.\n";
        print "Please set them up:\n";
        print "\n";

        foreach my $path (@not_found)
        {
            print "$path->{path}\n$path->{desc}\n";
        }
        exit(-1);
    }
    return;
}

sub find_deps
{
    my ( $self, $yaml_data ) = @_;

    $self->find_exes( $yaml_data->{required}->{executables} );
    $self->find_perl5_modules( $yaml_data->{required}->{perl5_modules} );
    $self->find_python3_modules( $yaml_data->{required}->{py3_modules} );
    $self->find_required_files( $yaml_data->{required}->{files} );

    return;
}

1;
