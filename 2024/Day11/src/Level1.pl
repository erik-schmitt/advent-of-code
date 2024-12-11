use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './InputData.txt');
my @inputData = $fileReader->getFile();

my %stoneProperties;

use constant BLINKS => 25;

sub run {
    parseInput();
    my $blinkCount = 1;
    while ($blinkCount <= BLINKS) {
        updateStones();
        $blinkCount++;
    }
    my $stoneCount = 0;
    foreach my $stone (keys %stoneProperties) {
        $stoneCount += $stoneProperties{$stone};
    }
    say $stoneCount;
}

sub updateStones {
    my %updatedProperties;
    foreach my $stone (sort keys %stoneProperties) {
        if ($stone eq '0') {
            $updatedProperties{'1'} += $stoneProperties{$stone};
        }
        elsif (length($stone) % 2 == 0) {
            my $l = length($stone) / 2;
            my $a = substr($stone, 0, $l) + 0;
            my $b = substr($stone, $l) + 0;
            $updatedProperties{$a} += $stoneProperties{$stone};
            $updatedProperties{$b} += $stoneProperties{$stone};
        }
        else {
            my $newStone = $stone * 2024;
            $updatedProperties{$newStone} += $stoneProperties{$stone};
        }
    }
    %stoneProperties = %updatedProperties;
}

sub parseInput {
    my $line = shift @inputData;
    my @stones = split(/\s/, $line);
    foreach my $stone (@stones) {
        $stoneProperties{$stone}++;
    }
}

run();