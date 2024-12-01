use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


sub run {
    my @left;
    my @right;
    my $sumOfDifferences = 0;

    foreach my $line (@inputData) {
        if ( $line =~ /^(\d+)\s+(\d+)$/ ) {
            push @left, $1;
            push @right, $2;
        }
    }

    @left = sort {$a <=> $b} @left;
    @right = sort {$a <=> $b} @right;

    while (@left) {
        my $left = shift @left;
        my $right = shift @right;
        my $difference = abs($left - $right);
        $sumOfDifferences += $difference;
    }

    say $sumOfDifferences;
}

run();