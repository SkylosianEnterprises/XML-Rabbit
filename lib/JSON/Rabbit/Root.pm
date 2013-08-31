use strict;
use warnings;

package JSON::Rabbit::Root;
use 5.008;

# ABSTRACT: Root class with sugar functions available

use JSON::Rabbit::Sugar (); # no magic, just load
use namespace::autoclean (); # no cleanup, just load
use Moose::Exporter;

my ($import, $unimport, $init_meta) = Moose::Exporter->build_import_methods(
    also             => 'JSON::Rabbit::Sugar',
    base_class_roles => ['JSON::Rabbit::RootNode'],
);

=func import

Automatically loads L<namespace::autoclean> into the caller's package and
dispatches to L<JSON::Rabbit::Sugar/"import"> (tail call).

=cut

sub import {
    namespace::autoclean->import( -cleanee => scalar caller );
    return unless $import;
    goto &$import;
}

=func unimport

Dispatches to L<JSON::Rabbit::Sugar/"unimport"> (tail call).

=cut

sub unimport {
    return unless $unimport;
    goto &$unimport;
}

=func init_meta

Initializes the metaclass of the calling class and adds the role
L<JSON::Rabbit::RootNode>.

=cut

#sub init_meta {
#    return unless $init_meta;
#    goto &$init_meta;
#}

# FIXME: https://rt.cpan.org/Ticket/Display.html?id=51561
# Hopefully fixed by 2.06 (doy)
sub init_meta {
    my ($dummy, %opts) = @_;
    Moose->init_meta(%opts);
    Moose::Util::MetaRole::apply_base_class_roles(
        for   => $opts{for_class},
        roles => ['JSON::Rabbit::RootNode']
    );
    return Class::MOP::class_of($opts{for_class});
}

1;
