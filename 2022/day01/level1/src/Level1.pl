use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


sub run {
    my $maxCalories = -1;
    my $currentCalories = 0;
    foreach my $line (@inputData) {
        if ( $line =~ /^(\d+)$/ ) {
            $currentCalories += $1;
        }
        else {
            if ($currentCalories > $maxCalories ) {
                $maxCalories = $currentCalories;
            }
            $currentCalories = 0;
        }
    }

    if ($currentCalories > $maxCalories ) {
        $maxCalories = $currentCalories;
    }
    say "Max Calories: $maxCalories";
}

run();