use strict;
use warnings FATAL => 'all';

my $input_file = './Level1/InputDataLevel1.txt';
open(my $in_fh, '<', $input_file) or die "Can't open '$input_file' - $!";
my @input_data = <$in_fh>;


sub run {
    print @input_data;
}

run();