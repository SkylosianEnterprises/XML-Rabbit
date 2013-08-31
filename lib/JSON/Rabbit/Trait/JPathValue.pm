use strict;
use warnings;

package JSON::Rabbit::Trait::JPathValue;
use Moose::Role;

with 'JSON::Rabbit::Trait::JPath';

# ABSTRACT: Single value jpath extractor trait

=method _build_default

Returns a coderef that is run to build the default value of the parent attribute. Read Only.

=cut

sub _build_default {
    my ($self) = @_;
    return sub {
        my ($parent) = @_;
        my $node = $self->_find_node(
            $parent,
            $self->_resolve_jpath_query( $parent ),
        );
        return $node;
    };
}

Moose::Util::meta_attribute_alias('JPathValue');

no Moose::Role;

1;

=head1 SYNOPSIS

    package MyJSONSyntaxNode;
    use Moose;
    with 'JSON::Rabbit::Node';

    has title => (
        isa         => 'Str',
        traits      => [qw(JPathValue)],
        jpath_query => './@title',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the extraction of primitive values from an JSON node based on an JPath query.

See L<JSON::Rabbit> for a more complete example.
