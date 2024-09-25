use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();


sub run {
   my $overlappingCount = 0;
    foreach my $line (@inputData) {
        if ($line =~ /^(\d+)-(\d+),(\d+)-(\d+)$/) {
            my $firstRangeStart = $1;
            my $firstRangeEnd = $2;
            my $secondRangeStart = $3;
            my $secondRangeEnd = $4;
            $overlappingCount++ if isOverlapping($firstRangeStart, $firstRangeEnd, $secondRangeStart, $secondRangeEnd);
        }
    }
    say $overlappingCount;
}

sub isOverlapping {
    my ($firstRangeStart, $firstRangeEnd, $secondRangeStart, $secondRangeEnd) = @_;
    my $flag = 0;
    if ($firstRangeStart <= $secondRangeStart && $firstRangeEnd >= $secondRangeStart) {
        $flag = 1; # First range overlaps with start of second range
    }
    if ($secondRangeStart <= $firstRangeStart && $secondRangeEnd >= $firstRangeStart) {
        $flag = 1; # Second range overlaps with start of first range
    }
    return $flag;
}

run();