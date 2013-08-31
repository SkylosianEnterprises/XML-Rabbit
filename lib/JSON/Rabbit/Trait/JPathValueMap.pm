use strict;
use warnings;

package JSON::Rabbit::Trait::JPathValueMap;
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

=attr xpath_key

The xpath query that specifies what will be put in the key in the hash. Required.

=cut

has 'xpath_key' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

=attr xpath_value

The xpath query that specifies what will be put in the value in the hash. Required.

=cut

has 'xpath_value' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

=method _build_default

Returns a coderef that is run to build the default value of the parent attribute. Read Only.

=cut

sub _build_default {
    my ($self) = @_;
    return sub {
        my ($parent) = @_;
        my $xpath_query = $self->_resolve_xpath_query( $parent );
        my %node_map;
        foreach my $node ( $self->_find_nodes( $parent, $xpath_query ) ) {
            my $key = $parent->xpc->findvalue( $self->xpath_key, $node );
            if ( defined($key) and length $key > 0 ) {
                my $value = $parent->xpc->findvalue( $self->xpath_value, $node );
                $node_map{$key} = $value;
            }
        }
        return \%node_map;
    };
}

Moose::Util::meta_attribute_alias('JPathValueMap');

no Moose::Role;

1;

=head1 SYNOPSIS

    package MyJSONSyntaxNode;
    use Moose;
    with 'JSON::Rabbit::RootNode';

    has reference_map => (
        isa         => 'HashRef[Str]',
        traits      => [qw(JPathValueMap)],
        xpath_query => '//*[@href]',
        xpath_key   => './@href',
        xpath_value => './@title';
    );

    no Moose;
    __PACKAGE__->meta->make_immutable();

    1;

=head1 DESCRIPTION

This module provides the extraction of primitive values from an JSON node based on an JPath query.

See L<JSON::Rabbit> for a more complete example.
