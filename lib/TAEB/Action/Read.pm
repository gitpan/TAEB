package TAEB::Action::Read;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Item';

use constant command => "r";

has '+item' => (
    required => 1,
);

sub respond_read_what { shift->item->slot }

sub respond_difficult_spell {
    shift->item->difficult(TAEB->level);
    return 'n';
}

sub post_responses {
    my $self = shift;
    my $item = $self->item;

    if ($item->match(type => 'scroll')) {
        TAEB->inventory->decrease_quantity($item->slot)
    }
}

sub msg_learned_spell {
    my $self = shift;
    my $name = shift;

    $self->item->identify_as("spellbook of $name");
}

sub can_read {
    my $self = shift;
    my $item = shift;

    return 0 unless $item->match(type => [qw/scroll spellbook/]);
    return 1;
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

