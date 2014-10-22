package TAEB::Role::Item::Food;
use Moose::Role;
with 'TAEB::Role::Item';

sub is_safely_edible {
    my $self = shift;

    # Induces vomiting.
    return 0 if $self->appearance eq 'tripe ration';

    return 1;
}

no Moose::Role;

1;
