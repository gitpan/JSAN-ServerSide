use strict;
use warnings;

use Test::More tests => 3;

use JSAN::ServerSide;


my %dependencies =
    ( '/A.js' => [ qw( B C ) ],
      '/B.js' => [ 'C' ],
      '/C.js' => [],
      '/D.js' => [ qw( E F G ) ],
      '/E.js' => [ 'D' ],
      '/F.js' => [],
      '/G.js' => [],
    );

{
    no warnings 'redefine';
    *JSAN::Parse::FileDeps::library_deps =
        sub { shift;
              return @{ $dependencies{+shift} } };

    *JSAN::ServerSide::_last_mod = sub { 1 };

}

{
    my $js = JSAN::ServerSide->new( js_dir => '/', uri_prefix => '/' );

    $js->add('A');

    my @uris = $js->uris;

    is_deeply( \@uris, [ '/C.js', '/B.js', '/A.js' ] );
}

{
    my $js = JSAN::ServerSide->new( js_dir => '/', uri_prefix => '/' );

    $js->add('D');

    my @uris = $js->uris;

    is_deeply( \@uris, [ '/E.js', '/F.js', '/G.js', '/D.js' ] );
}

{
    my $js = JSAN::ServerSide->new( js_dir => '/', uri_prefix => '/' );

    $js->add('E');

    my @uris = $js->uris;

    is_deeply( \@uris, ['/F.js', '/G.js', '/D.js', '/E.js' ] );
}
