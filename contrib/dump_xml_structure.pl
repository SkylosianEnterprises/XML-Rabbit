#!/usr/bin/env perl

use strict;
use warnings;

use XML::LibXML;
use Scalar::Util qw(blessed);

binmode STDOUT, ':utf8';

my $dom = XML::LibXML->load_xml(
    location => $ARGV[0],
);
my $root = $dom->documentElement();

my $node_map = {};
dump_node($root, $node_map);
foreach my $name ( sort keys %$node_map ) {
    print $node_map->{$name} . ": " . $name . "\n";
}

foreach my $ns ( $root->getNamespaces ) {
    print "Namespace: " . ( $ns->declaredPrefix || 'x' ) . "=" . $ns->declaredURI . "\n";
}

sub dump_node {
    my ($node, $map) = @_;
    return unless $node;
    unless ( $node->isa('XML::LibXML::Text') ) {
        if ( $node->namespaceURI() ) {
            unless ( $node->lookupNamespacePrefix( $node->namespaceURI() ) ) {
                $node->setNamespace( $node->namespaceURI(), "x", 1 );
            }
        }
    }
    $map->{ trim_node_path( $node->nodePath() ) } = 'node';
    foreach my $attr ( $node->attributes() ) {
        next unless blessed($attr);
        next if $attr->isa('XML::LibXML::Namespace'); # Doesn't support nodePath()
        $map->{ trim_node_path( $attr->nodePath() ) } = 'attr';
    }
    foreach my $child_node ( $node->childNodes() ) {
        dump_node( $child_node, $map );
    }
}

sub trim_node_path {
    my ($node_path) = @_;
    $node_path =~ s/\[\d+\]//g; # Strip explicit count number
    return $node_path;
}