use strict;
use warnings;

package JSON::Rabbit::Trait::JPathValueList;
use Moose::Role;

with 'JSON::Rabbit::Trait::JPath';

# ABSTRACT: Multiple value xpath extractor trait

around '_process_options' => sub {
    my ($orig, $self, $name, $options, @rest) = @_;

    $self->$orig($name, $options, @rest);

    # This should really be:
    # has '+isa' => ( required => 1 );
    # but for some unknown reason Moose doesn't allow that
    confess("isa attribute is required") unless defined( $options->{'isa'} );
};

=method _build_default

Returns a coderef that is run to build the default value of the parent attribute. Read Only.

=cut

sub _build_default {
    my ($self) = @_;
    return sub {
        my ($parent) = @_;
        my $xpath_query = $self->_resolve_xpath_query( $parent );
        my @nodes;
        foreach my $node ( $self->_find_nodes( $parent, $xpath_query ) ) {
            push @nodes, $node->to_literal . "";
        }
        return \@nodes;
    };
}

Moose::Util::meta_attribute_alias('JPathValueList');

no Moose::Role;

1;

=head1 SYNOPSIS

    package MyJSONSyntaxNode;
    use Moose;
    with 'JSON::Rabbit::RootNode';

    has all_references => (
        isa         => 'ArrayRef[Str]',
        traits      => [qw(JPathValueList)],
        xpath_query => '//@href|//@src',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the extraction of primitive values from an JSON node based on an JPath query.

See L<JSON::Rabbit> for a more complete example.
