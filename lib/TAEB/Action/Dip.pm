package TAEB::Action::Dip;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Item' => { items => [qw/item into/] };

use constant command => "#dip\n";

has '+item' => (
    required => 1,
);

has '+into' => (
    isa     => 'NetHack::Item | Str',
    default => 'fountain',
);

sub respond_dip_what {
    my $self = shift;
    $self->current_item($self->item);
    return $self->item->slot;
}

sub respond_dip_into_water {
    my $self  = shift;
    my $item  = shift;
    my $water = shift;

    # fountains are very much a special case - if water we want moat, pool, etc
    return 'y' if $self->into eq 'water' && $water ne 'fountain';

    return 'y' if $self->into eq $water;

    return 'n';
}

sub respond_dip_into_what {
    my $self = shift;
    $self->current_item($self->into);
    return $self->into->slot if blessed($self->into);

    TAEB->log->action("Unable to dip into '" . $self->into . "'. Sending escape, but I doubt this will work.", level => 'error');
    return "\e";
}

sub msg_excalibur {
    my $self = shift;
    my $excalibur = $self->item;

    $excalibur->buc('blessed');
    $excalibur->proof;
    $excalibur->remove_damage;
    $excalibur->specific_name('Excalibur');
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

