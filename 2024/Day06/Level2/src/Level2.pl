use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();


# my %visitedPositions;
my @labMap;
my $width = scalar split('', $inputData[0]);
my $height = scalar @inputData;
my $startX;
my $startY;
my %obstacles;
my %nextDirection = (
    'up' => 'right',
    'right' => 'down',
    'down' => 'left',
    'left' => 'up'
);

# check all positions that the guard visited in Level 1 heading in same direction
# Optimizatin idea: You can store position and direction in a set (or dictionary, whatever) and if a position and direction repeats, you're in a loop.
sub run {
    readLabMap();
    tryObstacle();
    say scalar keys %obstacles;
}

sub tryObstacle {
    foreach my $m (0..$height - 1) {
        foreach my $n (0..$width - 1) {
            next if $m == $startY && $n == $startX; # Can't be in starting position
            next if $labMap[$m][$n] eq '#'; # Already an obstacle here
            $labMap[$m][$n] = '#'; # Place an obstacle for the test
            say "Checking $m,$n";
            $obstacles{"$m,$n"} = 1 if traceRoute();
            $labMap[$m][$n] = '.'; # Reset map
        }
    }

}

sub traceRoute {
    my $direction = 'up';
    my $status = 'moving';
    my $currentX = $startX;
    my $currentY = $startY;
    my %visitedPositions;
    $visitedPositions{"$currentY,$currentX"}++;
    my %directionsChecked;
    my $moves = 0;
    my $max_moves = $height * $width;

    MOVE: while ($status eq 'moving' && $moves < $max_moves) {
        $status = checkPosition($currentX, $currentY-1) if $direction eq 'up';
        $status = checkPosition($currentX, $currentY+1) if $direction eq 'down';
        $status = checkPosition($currentX-1, $currentY) if $direction eq 'left';
        $status = checkPosition($currentX+1, $currentY) if $direction eq 'right';

        if ($status eq 'blocked') {
            $directionsChecked{$direction}++;
            return 1 if scalar keys %directionsChecked == 4; # Blocked in completely

            $direction = $nextDirection{$direction};
            $status = 'moving';
            next MOVE;
        }

        if ($status eq 'moving') {
            $moves++;
            $currentY -= 1 if $direction eq 'up';
            $currentY += 1 if $direction eq 'down';
            $currentX -= 1 if $direction eq 'left';
            $currentX += 1 if $direction eq 'right';
            $visitedPositions{"$currentY,$currentX"}++;
            %directionsChecked = ();
        }
    }
    return 0 if $status eq 'done'; # Not blocked in
    return 1; # Was in infinite loop
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
               $startX = $n;
               $startY = $m;
            }
            $labMap[$m][$n] = $current;
        }
    }
}

run();