use strict;
use warnings;

package JSON::Rabbit::RootNode;
use Moose::Role;
with 'JSON::Rabbit::Role::Document';

# ABSTRACT: Root node base class

# Preload JPath attribute traits
use JSON::Rabbit::Trait::JPathValue;
use JSON::Rabbit::Trait::JPathValueList;
use JSON::Rabbit::Trait::JPathValueMap;
use JSON::Rabbit::Trait::JPathObject;
use JSON::Rabbit::Trait::JPathObjectList;
use JSON::Rabbit::Trait::JPathObjectMap;

with 'JSON::Rabbit::Role::Node' => {
    'node' => { lazy => 1, builder => '_build__node' },
};

=attr node

An instance of a L<JSON::LibJSON::Node> class representing the root node of an
JSON document. Read Only.

It is lazily loaded from the C<document> attribute, which is inherited from
L<JSON::Rabbit::Role::Document>.

=cut

sub _build__node {
    return shift->_document;
}

no Moose::Role;

1;

=head1 SYNOPSIS

    package MyJSONSyntax;
    use Moose;
    with 'JSON::Rabbit::RootNode';

    has title => (
        isa         => 'Str',
        traits      => [qw(JPathValue)],
        xpath_query => '/root/title',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the base node attribute used to hold the root of the JSON document.

See L<JSON::Rabbit> for a more complete example.
