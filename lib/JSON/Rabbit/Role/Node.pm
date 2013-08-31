use strict;
use warnings;

package JSON::Rabbit::Role::Node;
use MooseX::Role::Parameterized;

use Encode ();
use JSON::Path qw/ jpath /;

# ABSTRACT: Base role for all nodes

=attr node

An instance of a L<JSON::LibJSON::Node> class representing the a node in an JSON document. Read Only.

=cut

parameter 'node'          => ( isa => 'HashRef', default => sub { +{} } );

=attr xpc

An instance of a L<JSON::LibJSON::JPathContext> class initialized with the C<node> attribute. Read Only.

=cut

parameter 'xpc'           => ( isa => 'HashRef', default => sub { +{} } );

=attr namespace_map

A HashRef of strings that defines the prefix/namespace JSON mappings for the
JPath parser. Usually overriden in a subclass like this:

    has '+namespace_map' => (
        default => sub { {
            myprefix      => "http://my.example.com",
            myotherprefix => "http://other.example2.org",
        } },
    );

=cut

parameter 'namespace_map' => ( isa => 'HashRef', default => sub { +{} } );

role {
    my ($p) = @_;

    has '_node' => (
        is       => 'ro',
        reader   => 'node',
        init_arg => 'node',
        %{ $p->node }
    );

    has 'namespace_map' => (
        is       => 'ro',
        isa      => 'HashRef[Str]',
        lazy     => 1,
        default  => sub { +{} },
        %{ $p->namespace_map },
    );

};

=method dump_xml

Dumps the JSON of the current node as a native perl string.

=cut

sub dump_xml {
    my ($self) = @_;
    return $self->node->toString(1);
}

sub find {
    my( $self, $jpath, $node ) = @_;
    return jpath( $node, $jpath );
}

sub findnodes {
    my( $self, $jpath, $node ) = @_;
    return jpath( $node, $jpath );
}

no MooseX::Role::Parameterized;

1;

=head1 SYNOPSIS

See L<JSON::Rabbit::RootNode> or L<JSON::Rabbit::Node> for examples.

=head1 DESCRIPTION

This module provides attributes and methods common to all nodes.

See L<JSON::Rabbit> for a more complete example.
