use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();


sub run {
    my @sharedItems;
    while (@inputData) {
        my @firstString = split('', shift @inputData);
        my @secondString = split('', shift @inputData);
        my @thirdString = split('', shift @inputData);

        my %commonItems;
        my %firstRucksack = map {$_ => 1} @firstString;
        
        while (@secondString) {
            my $item = shift @secondString;
            if (exists $firstRucksack{$item}) {
                $commonItems{$item}++;
            }
        }
        while (@thirdString) {
            my $item = shift @thirdString;
            if (exists $commonItems{$item}) {
                push @sharedItems, $item;
                last;
            }
        }        
    }

    my $prioritySum = 0;
    foreach my $itemType (@sharedItems) {
        my $ord = ord($itemType); # Get ASCII table value
        
        # Convert A-Z to scores of 27-52
        if ($ord > 64 && $ord < 91) {
            $prioritySum += $ord - 38;
        }
        # Convert a-z to scores of 1-26
        elsif ($ord > 96 && $ord < 123) {
            $prioritySum += $ord - 96;
        }
        else {
            die("Unknown ASCII value for '$itemType'");
        }
    }
    say $prioritySum;
}

run();