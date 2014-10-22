package TAEB::World::Level::Bigroom;
use TAEB::OO;
extends 'TAEB::World::Level';

__PACKAGE__->meta->add_method("is_$_" => sub { 0 })
    for (grep { $_ ne 'bigroom' } @TAEB::World::Level::special_levels);

sub is_bigroom { 1 }

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;


