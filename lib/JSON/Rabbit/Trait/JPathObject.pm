use strict;
use warnings;

package JSON::Rabbit::Trait::JPathObject;
use Moose::Role;

with 'JSON::Rabbit::Trait::JPath';

# ABSTRACT: JSON DOM object xpath extractor trait

around '_process_options' => sub {
    my ($orig, $self, $name, $options, @rest) = @_;

    $self->$orig($name, $options, @rest);

    # This should really be:
    # has '+isa' => ( required => 1 );
    # but for some unknown reason Moose doesn't allow that
    confess("isa attribute is required") unless defined( $options->{'isa'} );
};

=attr isa_map

Specifies the prefix:tag to class name mapping used with union xpath
queries. See L<JSON::Rabbit> for more detailed information.

=cut

has 'isa_map' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    lazy    => 1,
    default => sub { +{} },
);

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
        $self->_convert_isa_map( $parent );
        my $class = $self->_resolve_class();
        return $self->_create_instance( $parent, $class, $node );
    };
}

Moose::Util::meta_attribute_alias('JPathObject');

no Moose::Role;

1;

=head1 SYNOPSIS

    package MyJSONSyntaxNode;
    use Moose;
    with 'JSON::Rabbit::Node';

    has 'first_person' => (
        isa         => 'MyJSONSyntax::Person',
        traits      => [qw(JPathObject)],
        xpath_query => './person[1]',
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the extraction of complex values (subtrees) from an JSON
node based on an JPath query. The subtree is used as input for the
constructor of the class specified in the isa attribute.

See L<JSON::Rabbit> for a more complete example.
