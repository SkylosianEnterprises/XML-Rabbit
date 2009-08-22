package Rabbit::Document;
use Moose;

use XML::LibXML 1.69 ();
use Encode ();

has '_file' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    init_arg => 'file',
);

has '_parser' => (
    is      => 'ro',
    isa     => 'XML::LibXML',
    lazy    => 1,
    default => sub { XML::LibXML->new(), },
);

has '_document' => (
    is         => 'ro',
    isa        => 'XML::LibXML::Document',
    lazy_build => 1,
    reader     => '_document',
);

sub _build__document {
    my ( $self ) = @_;
    my $doc = $self->_parser->parse_file( $self->_file );
    confess("No input file specified.\n") unless $doc;
    return $doc;
}

sub dump_document_xml {
    my ( $self ) = @_;
    return Encode::decode(
        $self->_document->actualEncoding,
        $self->_document->toString(1),
    );
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;

=head1 NAME

Rabbit::Document - Moose-based XML loader - document base class


=head1 SYNOPSIS

    package MyXMLSyntax;
    use Moose;
    extends 'Rabbit::Document';

    sub root_node {
        return shift->_document->documentElement();
    }


=head1 DESCRIPTION

This module provides the base document attribute used to hold the parsed XML content.

See L<Rabbit> for a more complete example.


=head1 ATTRIBUTES


=over 12


=item C<new>

Standard Moose constructor.


=item C<file>

A string representing the path to the file that contains the XML document data. Required.


=item C<_document>

An instance of a L<XML::LibXML::Document> class. Read Only.


=item C<dump_document_xml>

Dumps the XML of the entire document as a native perl string.


=item C<meta>

Moose meta object.


=back


=head1 BUGS

See L<Rabbit/BUGS>.


=head1 SUPPORT

See L<Rabbit/SUPPORT>.


=head1 AUTHOR

See L<Rabbit/AUTHOR>.


=head1 COPYRIGHT

See L<Rabbit/COPYRIGHT>.

=head1 LICENSE

See L<Rabbit/LICENSE>.


=cut
