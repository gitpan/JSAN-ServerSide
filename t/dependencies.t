use strict;
use warnings;

use Test::More tests => 6;

use JSAN::ServerSide;


my %dependencies =
    ( '/files/A.js' => [ qw( B C ) ],
      '/files/B.js' => [ 'C' ],
      '/files/C.js' => [],
      '/files/D.js' => [ qw( E F G ) ],
      '/files/E.js' => [ 'D' ],
      '/files/F.js' => [],
      '/files/G.js' => [],
    );

{
    no warnings 'redefine';
    *JSAN::Parse::FileDeps::library_deps =
        sub { shift;
              return @{ $dependencies{+shift} } };

    *JSAN::ServerSide::_last_mod = sub { 1 };

}

{
    my $js = JSAN::ServerSide->new( js_dir => '/files', uri_prefix => '/uris' );
    $js->add('A');

    is_deeply( [ $js->uris() ], [ '/uris/C.js', '/uris/B.js', '/uris/A.js' ] );
    is_deeply( [ $js->files() ], [ '/files/C.js', '/files/B.js', '/files/A.js' ] );
}

{
    my $js = JSAN::ServerSide->new( js_dir => '/files', uri_prefix => '/uris' );

    $js->add('D');

    is_deeply( [ $js->uris() ], [ '/uris/E.js', '/uris/F.js', '/uris/G.js', '/uris/D.js' ] );
    is_deeply( [ $js->files() ], [ '/files/E.js', '/files/F.js', '/files/G.js', '/files/D.js' ] );
}

{
    my $js = JSAN::ServerSide->new( js_dir => '/files', uri_prefix => '/uris' );

    $js->add('E');

    is_deeply( [ $js->uris() ], ['/uris/F.js', '/uris/G.js', '/uris/D.js', '/uris/E.js' ] );
    is_deeply( [ $js->files() ], ['/files/F.js', '/files/G.js', '/files/D.js', '/files/E.js' ] );
}
