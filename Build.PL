use strict;
use warnings;

use Module::Build;

my $builder =
    Module::Build->new
        ( module_name        => 'JSAN::ServerSide',
          license            => 'perl',
          requires           => { 'JSAN::Parse::FileDeps' => 0,
                                  'Params::Validate' => 0,
                                  'Test::More'  => 0,
                                  'URI::ToDisk' => 0,
                                },
          build_requires     => { 'Module::Build' => 0 },
          create_makefile_pl => 'passthrough',
          create_readme      => 1,
          sign               => 1,
        );

$builder->create_build_script();
