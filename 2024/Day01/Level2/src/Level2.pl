use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();


sub run {
    my @calorieListing;
    my $currentCalories = 0;
    foreach my $line (@inputData) {
        if ( $line =~ /^(\d+)$/ ) {
            $currentCalories += $1;
        }
        else {
            push @calorieListing, $currentCalories;
            $currentCalories = 0;
        }
    }

    push @calorieListing, $currentCalories;

    my @sortedCalorieListing = sort {$a <=> $b} @calorieListing;
    my $maxCalories = $sortedCalorieListing[-1] + $sortedCalorieListing[-2] + $sortedCalorieListing[-3];
    say "Max Calories: $maxCalories";
}

run();