package TAEB::Action::Save;
use TAEB::OO;
extends 'TAEB::Action';

use constant command => 'S';

sub respond_save { 'y' }

__PACKAGE__->meta->make_immutable;
no TAEB::OO;

1;

