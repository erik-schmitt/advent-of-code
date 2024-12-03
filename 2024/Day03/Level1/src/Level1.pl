use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


sub run {
    my $sum = 0;
    foreach my $line (@inputData) {
        while($line =~ /mul\((\d{1,3}),(\d{1,3})\)/g) {
            $sum += $1 * $2;
        }
    }
    say $sum;
}

run();