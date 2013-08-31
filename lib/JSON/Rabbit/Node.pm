use strict;
use warnings;

package JSON::Rabbit::Node;
use Moose::Role;

# ABSTRACT: Node base class

# Preload JPath attribute traits
use JSON::Rabbit::Trait::JPathValue;
use JSON::Rabbit::Trait::JPathValueList;
use JSON::Rabbit::Trait::JPathValueMap;
use JSON::Rabbit::Trait::JPathObject;
use JSON::Rabbit::Trait::JPathObjectList;
use JSON::Rabbit::Trait::JPathObjectMap;

=attr node

An instance of a L<JSON::LibJSON::Node> class representing a node in an JSON document tree. Read Only.

=attr xpc

An instance of a L<JSON::LibJSON::JPathContext> class initialized with the C<node> attribute. Read Only.

=cut

with 'JSON::Rabbit::Role::Node' => {
    'node'          => { required => 1 },
    'xpc'           => { required => 1 },
    'namespace_map' => { required => 1 },
};

no Moose::Role;

1;

=head1 SYNOPSIS

    package MyJSONSyntaxNode;
    use Moose;
    with 'JSON::Rabbit::Node';

    has title => (
        isa         => 'Str',
        traits      => [qw(JPathValue)],
        xpath_query => './@title',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the base node attribute used to hold a specific node in the JSON document tree.

See L<JSON::Rabbit> for a more complete example.
