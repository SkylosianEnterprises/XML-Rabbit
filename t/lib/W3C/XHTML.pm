use strict;
use warnings;

package W3C::XHTML;
use Moose;
with 'JSON::Rabbit::RootNode';

has 'title' => (
    isa         => 'Str',
    traits      => [qw(JPathValue)],
    jpath_query => '$.html.head.title',
);

has 'style' => (
    isa         => 'Maybe[W3C::XHTML::Style]',
    traits      => [qw(JPathObject)],
    jpath_query => '$.html.head.style',
);

has 'body' => (
    isa         => 'W3C::XHTML::Body',
    traits      => [qw(JPathObject)],
    jpath_query => '$.html.body',
);

has 'all_sources' => (
    isa         => 'ArrayRef[Str]',
    traits      => [qw(JPathValueList)],
    jpath_query => '$..src',
);

has 'body_and_all_images' => (
    traits      => ['JPathObjectList'],
    jpath_query => '$.body|$.img',
    isa_map     => {
        'body' => 'W3C::XHTML::Body',
        'img'  => 'W3C::XHTML::Image',
    },
);

no Moose;
__PACKAGE__->meta->make_immutable();

1;
