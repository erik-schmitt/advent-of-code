use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

my $rowNumber = 10;
# my $rowNumber = 2000000;
my $min = 0;
my $max = 20;
my %rows;

sub run {
    parseInput();
    for (my $m = $min; $m <= $max; $m++) {
        for (my $n = $min; $n <= $max; $n++) {
            if (!exists $rows{"$n,$m"}) {
                say $n * 4000000 + $m;
                last;
            }
        }
    }
}
=begin
sub getRowCount {
    my $count = 0;
    foreach my $key (sort {$a <=> $b} keys %row) {
        $count++ if exists $row{$key} && $row{$key} eq '#';
    }
    return $count;
}
=cut

sub findManhattanDistance {
    my ($x1, $y1, $x2, $y2) = @_;
    my $distance = abs($x1- $x2) + abs($y1 - $y2);
    return $distance;
}

sub markRow {
    
}

sub parseInput {
    foreach my $line (@inputData) {
        $line =~ /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/;
        my $sx = $1;
        my $sy = $2;
        my $bx = $3;
        my $by = $4;

        $row{$sx} = 'S' if $sy == $rowNumber;
        $row{$bx} = 'B' if $by == $rowNumber;

        my $distanceToBeacon = findManhattanDistance($sx, $sy, $bx, $by);
        my $distanceToRow = findManhattanDistance($sx, $sy, $sx, $rowNumber);

        say $line;
        say "Distance to Beacon: $distanceToBeacon";
        say "Distance to Row: $distanceToRow";
        next if $distanceToBeacon < $distanceToRow;

        # Traverse the row and mark it
        my $currentDistance = $distanceToRow;
        my $x = $sx;
        while ($currentDistance <= $distanceToBeacon) {
            $row{$x} = '#' unless exists $row{$x};
            $x--;
            $currentDistance = findManhattanDistance($sx, $sy, $x, $rowNumber);
        }

        $currentDistance = $distanceToRow;
        $x = $sx;
        while ($currentDistance <= $distanceToBeacon) {
            $row{$x} = '#' unless exists $row{$x};
            $x++;
            $currentDistance = findManhattanDistance($sx, $sy, $x, $rowNumber);
        }
    }
}

run();