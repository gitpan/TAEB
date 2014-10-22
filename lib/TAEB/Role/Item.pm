package TAEB::Role::Item;
use Moose::Role;
with 'MooseX::Role::Matcher' => {
    default_match => 'name',
    allow_missing_methods => 1,
};

sub is_auto_picked_up {
    my $self = shift;
    return 0 if !TAEB->autopickup;

    return 1 if $self->match(identity => 'gold piece')
             || $self->match(type => 'wand');

    return 0;
}

my %short_buc = (
    blessed  => 'B',
    cursed   => 'C',
    uncursed => 'UC',
);
sub debug_line {
    my $self = shift;

    my @fields;

    push @fields, $self->quantity . 'x' unless $self->quantity == 1;

    if ($self->buc) {
        push @fields, $self->buc;
    }
    else {
        for (keys %short_buc) {
            my $checker = "is_$_";
            my $value = $self->$checker;
            push @fields, '!' . $short_buc{$_}
                if defined($value)
                && $value == 0;
        }
    }

    if ($self->does('NetHack::Item::Role::Enchantable')) {
        push @fields, $self->enchantment if defined $self->numeric_enchantment;
    }

    push @fields, $self->name;

    if ($self->does('NetHack::Item::Role::Chargeable')) {
        push @fields, ('(' .
                      (defined($self->recharges) ? $self->recharges : '?') .
                      ':' . $self->charges . ')') if defined($self->charges);
    }

    if ($self->can('is_worn') && $self->is_worn) {
        push @fields, '(worn)';
    }

    if ($self->is_wielded) {
        push @fields, '(wielded)';
    }

    if ($self->cost_each) {
        if ($self->quantity == 1) {
            push @fields, '($' . $self->cost . ')';
        }
        else {
            push @fields, '($'. $self->cost_each .' each, $' . $self->cost . ')';
        }
    }

    return join ' ', @fields;
}

around throw_range => sub {
    my $orig = shift;
    my $self = shift;

    $orig->($self,
        strength => TAEB->numeric_strength,
        @_,
    );
};

around match => sub {
    my $orig = shift;
    my $self = shift;

    if (@_ == 1 && !ref($_[0])) {
        return $self->match(artifact   => $_[0])
            || $self->match(identity   => $_[0])
            || $self->match(appearance => $_[0]);
    }

    return $orig->($self, @_);
};

no Moose::Role;

1;
