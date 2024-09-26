use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


sub run {
    my @buffer = split('', $inputData[0]);
    my @lastFour;
    my $characterCount = 0;
    while (@buffer) {
        my $newCharacter = shift @buffer;
        if (@lastFour > 3) {
            shift @lastFour;
        }
        push @lastFour, $newCharacter;
        $characterCount++;
        if (scalar @lastFour == 4 && isUnique(@lastFour)) {
            last;
        }
    }
    say $characterCount;
}

sub isUnique {
    my @string = @_;
    my %unique = map {$_ => 1} @string;
    if (scalar keys %unique != scalar @string) {
        return 0;
    }
    return 1;
}

run();