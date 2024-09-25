use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


sub run {
    my $fullyContainedCount = 0;
    foreach my $line (@inputData) {
        if ($line =~ /^(\d+)-(\d+),(\d+)-(\d+)$/) {
            my $firstRangeStart = $1;
            my $firstRangeEnd = $2;
            my $secondRangeStart = $3;
            my $secondRangeEnd = $4;
            $fullyContainedCount++ if isFullyContained($firstRangeStart, $firstRangeEnd, $secondRangeStart, $secondRangeEnd);
        }
    }
    say $fullyContainedCount;
}

sub isFullyContained {
    my ($firstRangeStart, $firstRangeEnd, $secondRangeStart, $secondRangeEnd) = @_;
    my $flag = 0;
    if ($firstRangeStart >= $secondRangeStart && $firstRangeEnd <= $secondRangeEnd ) {
        $flag = 1; # First range is contained in second range
    }
    if ($firstRangeStart <= $secondRangeStart && $firstRangeEnd >= $secondRangeEnd ) {
        $flag = 1; # Second range is contained in first range
    }
    return $flag;
}

run();