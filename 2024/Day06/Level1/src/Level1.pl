use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();

my %visitedPositions;
my @labMap;
my $width = scalar split('', $inputData[0]);
my $height = scalar @inputData;
my $currentX;
my $currentY;

my %nextDirection = (
    'up' => 'right',
    'right' => 'down',
    'down' => 'left',
    'left' => 'up'
);

sub run {
    readLabMap();
    traceRoute();
    say scalar keys %visitedPositions;
}

sub traceRoute {
    my $direction = 'up';
    my $status = 'moving';
    $visitedPositions{"$currentY,$currentX"}++;
    my %directionsChecked;
    say "Starting at $currentY,$currentX";

    MOVE: while ($status eq 'moving') {
        $status = checkPosition($currentX, $currentY-1) if $direction eq 'up';
        $status = checkPosition($currentX, $currentY+1) if $direction eq 'down';
        $status = checkPosition($currentX-1, $currentY) if $direction eq 'left';
        $status = checkPosition($currentX+1, $currentY) if $direction eq 'right';

        if ($status eq 'blocked') {
            $directionsChecked{$direction}++;
            $status = 'done' if scalar keys %directionsChecked == 4;

            $direction = $nextDirection{$direction};
            $status = 'moving';
            say "Turning to $direction";
            next MOVE;
        }

        if ($status eq 'moving') {
             say "Moved to $currentY,$currentX";
            $currentY -= 1 if $direction eq 'up';
            $currentY += 1 if $direction eq 'down';
            $currentX -= 1 if $direction eq 'left';
            $currentX += 1 if $direction eq 'right';
            $visitedPositions{"$currentY,$currentX"}++;
            %directionsChecked = ();
        }
    }
}

sub checkPosition {
    my ($x, $y) = @_;
    return 'done' if $x < 0;
    return 'done' if $x >= $width;
    return 'done' if $y < 0;
    return 'done' if $y >= $height;
    return 'blocked' if $labMap[$y][$x] eq '#';
    return 'moving';
}

sub readLabMap {
    foreach my $m (0..$height - 1) {
        my $line = shift @inputData;
        my @row = split('', $line);

        foreach my $n (0..$width - 1) {
            my $current = $row[$n];

            if ($current eq '^') {
               $current = 'X';
               $currentX = $n;
               $currentY = $m;
            }
            $labMap[$m][$n] = $current;
        }
    }
}

run();