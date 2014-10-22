package TAEB::World::Level::Rogue;
use TAEB::OO;
extends 'TAEB::World::Level';

__PACKAGE__->meta->add_method("is_$_" => sub { 0 })
    for (grep { $_ ne 'rogue' } @TAEB::World::Level::special_levels);

sub is_rogue { 1 }

=head2 glyph_to_type str[, str] -> str

This will look up the given glyph (and if given color) and return a tile type
for it. Note that monsters and items (and any other miss) will return
"obscured".

=cut

our %rogue_glyphs = (
    ' '  => 'rock',
    '+'  => 'opendoor',
    '%'  => 'stairsdown',
    '^'  => 'trap',
    '"'  => 'trap',
    '|'  => 'wall',
    '-'  => 'wall',
    '.'  => 'floor',
    '#'  => 'corridor',
);

sub glyph_to_type {
    my $self  = shift;
    my $glyph = shift;

    return $rogue_glyphs{$glyph} || 'obscured';
}

=head2 glyph_is_monster str -> bool

Returns whether the given glyph is that of a monster.

=cut

sub glyph_is_monster {
    my $self = shift;
    return shift =~ /[a-zA-Z&';1-5@]/;
}

=head2 glyph_is_item str -> bool

Returns whether the given glyph is that of an item.

=cut

sub glyph_is_item {
    my $self = shift;
    return shift =~ /[`?!:*()+=\],\/]/;
}

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

