use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();


my $count = 0;
my @searchGrid;
my $width = scalar split('', $inputData[0]);
my $height = scalar @inputData;
my $length = 2;

sub run {
    loadWordSearch();

     foreach my $m (0..$height - 1) {
        foreach my $n (0..$width - 1) {
            if ('A' eq $searchGrid[$m][$n]) {
                $count += checkForMatch($m,$n) if validRange($m,$n);
            }
        }
    }
    say $count;
}

sub validRange {
    my ($m, $n) = @_;
    return 0 unless $n + $length <= $width;
    return 0 unless $n + 1 - $length >= 0;
    return 0 unless $m + 1 - $length >= 0;
    return 0 unless $m + $length <= $height;
    return 1;
}

sub checkForMatch {
    my ($m, $n) = @_;

    my %matches = (
        'SSMM' => 1,
        'MSMS' => 1,
        'SMSM' => 1,
        'MMSS' => 1,
    );

    my $string = $searchGrid[$m-1][$n-1] . $searchGrid[$m-1][$n+1] . $searchGrid[$m+1][$n-1] . $searchGrid[$m+1][$n+1];
    return 1 if exists $matches{$string};
    return 0;
}

sub loadWordSearch {
    foreach my $m (0..$height - 1) {
        my $line = shift @inputData;
        my @row = split('', $line);

        foreach my $n (0..$width - 1) {
            my $current = $row[$n];
            $searchGrid[$m][$n] = $current;
        }
    }
}

run();