use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

my @tours;
my @map;
my %visitedSet;
my $distance = 9999999;
my $arrayWidth = scalar split('', $inputData[0]);
my $arrayHeight = scalar @inputData;
my $endX;
my $endY;


sub run {
    readInput();
    foreach my $start (@tours) {
        my $cost = findShortestPath($start->{'x'}, $start->{'y'});
        $distance = $cost if $cost ne '' && $cost < $distance;
    }
    say $distance;
}

sub findShortestPath {
    my ($startX, $startY) = @_;
    my @priorityQueue = ();
    foreach my $key (keys %visitedSet) {
        $visitedSet{$key} = 0;
    }
    push @priorityQueue, {'x' => $startX, 'y' => $startY, 'cost' => 0};
    $visitedSet{"$startX,$startY"} = 1;

    # Use Dijkstra's algorithm for shortest path
    while (@priorityQueue) {
        @priorityQueue = sort prioritySort @priorityQueue;
        my $node = shift @priorityQueue;
        my $cost = $node->{'cost'};
        my $x = $node->{'x'};
        my $y = $node->{'y'};

        if ($x == $endX && $y == $endY) {
            return $cost;
        }

        my @choices = getChoices($x,$y); # Check directions within bounds of map
        my @validChoices;
        foreach my $choice (@choices) {
            push @validChoices, $choice if $map[$choice->{'x'}][$choice->{'y'}] <= $map[$x][$y] + 1; # Check location height
        }

        foreach my $candidate (@validChoices) {
            if ($visitedSet{"$candidate->{'x'},$candidate->{'y'}"} == 0) {
                $visitedSet{"$candidate->{'x'},$candidate->{'y'}"} = 1;
                push @priorityQueue, {'x' => $candidate->{'x'}, 'y' => $candidate->{'y'}, 'cost' => $cost+1};
            }
        }
    }
    return ''; # Not all starting points will reach the end point so we return '' here
}

sub prioritySort {
    return $a->{'cost'} <=> $b->{'cost'};
}

sub getChoices {
    my ($x, $y) = @_;
    my @choices;
    if ($x > 0) {
        push @choices, {'x' => $x-1, 'y' => $y}; # Left
    }
    if ($y > 0) {
        push @choices, {'x' => $x, 'y' => $y-1}; # Up
    }
    if ($x+1 < $arrayWidth) {
        push @choices, {'x' => $x+1, 'y' => $y}; # Right
    }
    if ($y+1 < $arrayHeight) {
        push @choices, {'x' => $x, 'y' => $y+1}; # Down
    }
    return @choices;
}

sub readInput {
    foreach my $i (0..$arrayHeight - 1) {
        my $line = shift @inputData;
        my @row = split('', $line);

        foreach my $j (0..$arrayWidth - 1)
        {
            my $height = ord($row[$j]); # Convert letter to ASCII value
            if ($height == ord('S')) {
                $height = ord('a');
            }
            if ($height == ord('E')) {
                $endX = $j;
                $endY = $i;
                $height = ord('z');
            }
            if ($height == ord('a')) {
                push @tours, {'x' => $j, 'y' => $i};
            }
            $map[$j][$i] = $height;
            $visitedSet{"$j,$i"} = 0;
        }
    }
}

run();