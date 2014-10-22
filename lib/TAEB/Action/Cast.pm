package TAEB::Action::Cast;
use TAEB::OO;
extends 'TAEB::Action';
with 'TAEB::Action::Role::Direction';

use constant command => 'Z';

has spell => (
    is       => 'ro',
    isa      => 'TAEB::World::Spell',
    required => 1,
    provided => 1,
);

sub single_cast { shift->spell->slot }

sub exception_hunger_cast {
    my $self = shift;

    if (TAEB->nutrition > 10) {
        TAEB->nutrition(10);
        TAEB->log->action("Adjusting our nutrition to 10 because we're too hungry to cast spells");
        $self->aborted(1);
    }
    else {
        TAEB->log->action("Our nutrition is known to be <= 10 and we got a 'too hungry to cast' message. Why did you cast?", level => 'error');
    }

    return "\e\e\e";
}

sub done {
    my $spell = shift->spell;

    # detect food doesn't make us hungry
    return if $spell->name eq 'detect food';

    my $nutrition = TAEB->nutrition;

    # in the future, let's check to see how much we actually spent (Amulet of
    # Yendor)
    my $energy = 5 * $spell->power;
    my $hunger = 2 * $energy;

    if (TAEB->role eq 'Wiz') {
           if (TAEB->int >= 17) { $hunger = 0 }
        elsif (TAEB->int == 16) { $hunger = int($hunger / 4) }
        elsif (TAEB->int == 15) { $hunger = int($hunger / 2) }
    }

    if ($hunger > $nutrition - 3) {
        $hunger = $nutrition - 3;
    }

    TAEB->nutrition($nutrition - $hunger);
}

sub msg_killed {
    my ($self, $monster_name) = @_;

    return unless defined $self->target_tile;

    $self->target_tile->witness_kill($monster_name);
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

