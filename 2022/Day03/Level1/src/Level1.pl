use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


sub run {
    my @sharedItems;
    foreach my $line (@inputData) {
        my $firstString = substr($line, 0, length($line)/2);
        my @secondString = split('', substr($line, length($line)/2));

        my %firstCompartment = map {$_ => 1} split('', $firstString);
        while (@secondString) {
            my $item = shift @secondString;
            if (exists $firstCompartment{$item}) {
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