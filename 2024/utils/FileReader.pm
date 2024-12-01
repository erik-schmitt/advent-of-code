package FileReader;

use strict;
use warnings FATAL => 'all';
use Moose;

has 'filename' => (
    is  => 'rw',
    isa => 'Str',
    required => 1,
);


sub getFile {
    my $self = shift;
    my @contents;
    
    open(my $fh, '<', $self->filename) or die("Could not open '$self->filename' - $!");
    while (my $line = <$fh>) {
        chomp $line;
        push @contents, $line;
    }
    close $fh;
    return @contents;
}

no Moose;
1;