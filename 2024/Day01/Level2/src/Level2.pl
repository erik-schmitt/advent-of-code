use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();


sub run {
    my @left;
    my %right;
    my $similarityScore = 0;

    foreach my $line (@inputData) {
        if ( $line =~ /^(\d+)\s+(\d+)$/ ) {
            push @left, $1;
            $right{$2}++;
        }
    }

    foreach my $value (sort {$a <=> $b} @left) {
        if (exists $right{$value}) {
            $similarityScore += $value * $right{$value};
        }
    }

    say $similarityScore;
}

run();