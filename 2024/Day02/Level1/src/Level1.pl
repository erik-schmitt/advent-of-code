use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


sub run {
    my $safeCount = 0;
    REPORT: foreach my $report (@inputData) {
        my @levels = split(/\s+/, $report);
        my $first = shift @levels;
        my $second = shift @levels;
        my $direction = $first < $second ? 1 : -1;
        next REPORT unless safeLevels($first, $second, $direction);

        while (@levels) {
            $first = $second;
            $second = shift @levels;
            next REPORT unless safeLevels($first, $second, $direction);
        }
        $safeCount++;
    }
    say $safeCount;
}

sub safeLevels {
    my ($first, $second, $direction) = @_;
    my $safe = 1;
    if ($direction > 0) {
        $safe = 0 if $first + 4 <= $second;
        $safe = 0 if $first >= $second;
    }
    else {
        $safe = 0 if $second + 4 <= $first;
        $safe = 0 if $second >= $first;
    }
    return $safe;
}

run();