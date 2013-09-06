#!perl

use Test::More tests => 9;

require_ok( 'JSON::Rabbit' );
require_ok( 'JSON::Rabbit::Sugar' );
require_ok( 'JSON::Rabbit::Root' );
require_ok( 'JSON::Rabbit::RootNode' );
require_ok( 'JSON::Rabbit::Node' );
require_ok( 'JSON::Rabbit::Trait::JPathValue' );
require_ok( 'JSON::Rabbit::Trait::JPathValueList' );
require_ok( 'JSON::Rabbit::Trait::JPathObject' );
require_ok( 'JSON::Rabbit::Trait::JPathObjectList' );

diag( "Testing JSON::Rabbit $XML::Rabbit::VERSION, Perl $], $^X" );
