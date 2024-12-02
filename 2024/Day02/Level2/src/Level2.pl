use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();


sub run {
    my $safeCount = 0;
    REPORT: foreach my $report (@inputData) {
        my @levels = split(/\s+/, $report);
        my $safe = safeReport(@levels);

        if (!$safe) {
            my $index = 0;
            while ($index < scalar @levels) {
                my @dampened = @levels;
                splice(@dampened, $index, 1);
                $safe = safeReport(@dampened);
                last if $safe;
                $index++;
            }
            next REPORT unless $safe;
        }
        $safeCount++;
    }
    say $safeCount;
}

sub safeReport {
    my @levels = @_;

    my $first = shift @levels;
    my $second = shift @levels;
    my $direction = $first < $second ? 1 : -1;
    return 0 unless safeLevels($first, $second, $direction);

    while (@levels) {
        $first = $second;
        $second = shift @levels;
        return 0 unless safeLevels($first, $second, $direction);
    }
    return 1;
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