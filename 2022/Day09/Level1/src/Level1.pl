use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();

my @headPosition = (0,0);
my @tailPosition = (0,0);
my %visited = (
"0,0" => 1,
);

sub run {
    foreach my $move (@inputData) {
        $move =~ /^(\w)\s(\d+)$/;
        my $direction = $1;
        my $distance = $2;
        step($direction, $distance);
    }
    say scalar keys %visited;
}

sub step {
    my ($direction, $distance) = @_;
    while ($distance > 0) {
        # Move head
        moveHead($direction);

        # Update distance left to travel
        $distance--;

        # Move tail to follow if needed
        unless(headTouchesTail()) {
            moveTail();
        }

        # Mark location visited
        $visited{"$tailPosition[0],$tailPosition[1]"}++;
    }
}

sub moveHead {
    my $direction = shift;

    $headPosition[0]-- if $direction eq 'L';
    $headPosition[0]++ if $direction eq 'R';
    $headPosition[1]++ if $direction eq 'U';
    $headPosition[1]-- if $direction eq 'D';
}

sub headTouchesTail
{
    my $xSeparation = $headPosition[0] - $tailPosition[0];
    my $ySeparation = $headPosition[1] - $tailPosition[1];

    my $isTouching = 1;

    $isTouching = 0 if $xSeparation < -1;
    $isTouching = 0 if $xSeparation > 1;
    $isTouching = 0 if $ySeparation < -1;
    $isTouching = 0 if $ySeparation > 1;

    return $isTouching;
}

sub moveTail {
    my $xSeparation = $headPosition[0] - $tailPosition[0];
    my $ySeparation = $headPosition[1] - $tailPosition[1];

    if ($xSeparation > 1 && $ySeparation == 0) {
        $tailPosition[0]++;
    }
    elsif ($xSeparation < -1 && $ySeparation == 0) {
        $tailPosition[0]--;
    }
    elsif ($xSeparation == 0 && $ySeparation > 1) {
        $tailPosition[1]++;
    }
    elsif ($xSeparation == 0 && $ySeparation < 1) {
        $tailPosition[1]--;
    }
    elsif ($xSeparation > 0 && $ySeparation > 0) {
        $tailPosition[0]++;
        $tailPosition[1]++;
    }
    elsif ($xSeparation < 0 && $ySeparation > 0) {
        $tailPosition[0]--;
        $tailPosition[1]++;
    }
    elsif ($xSeparation < 0 && $ySeparation < 0) {
        $tailPosition[0]--;
        $tailPosition[1]--;
    }
    elsif ($xSeparation > 0 && $ySeparation < 1) {
        $tailPosition[0]++;
        $tailPosition[1]--;
    }
}

run();