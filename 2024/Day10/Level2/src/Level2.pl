use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

my @map;
my $width = scalar split('', $inputData[0]);
my $height = scalar @inputData;
say "Height: $height";
say "Width: $width";
my $sumOfRatings = 0;
my %trailheads;
my %mappedTrails;

sub run {
    readMap();
    foreach my $start (sort keys %trailheads) {
        my ($y, $x) = split(/,/, $start);
        %mappedTrails = ();
        findTrails($y,$x, "$y,$x");
        $sumOfRatings += scalar keys %mappedTrails;
    }
    say $sumOfRatings;
}

sub findTrails {
    my ($y,$x, $path) = @_;
    if ($map[$y][$x] == 9) {
        $path .= ";$y,$x";
        if (exists $mappedTrails{$path}) {
            return;
        }
        $mappedTrails{$path} = 1;
        return;
    }
    else {
        my @directions = getValidDirections($y, $x);
        foreach my $direction (@directions) {
            my $newY = $y;
            my $newX = $x;
            if ($direction eq 'north') { $newY--; }
            if ($direction eq 'east') { $newX++; }
            if ($direction eq 'south') { $newY++; }
            if ($direction eq 'west') { $newX--; }
            $path .= ";$newY,$newX";
            findTrails($newY, $newX, $path);
        }
        return;
    }
}

sub getValidDirections {
    my ($y,$x) = @_;
    my $elevation = $map[$y][$x] + 1;
    my @directions;
    push @directions, "north" if $y-1 >= 0 && $map[$y-1][$x] == $elevation;
    push @directions, "east" if $x+1 < $width && $map[$y][$x+1] == $elevation;
    push @directions, "south" if $y+1 < $height && $map[$y+1][$x] == $elevation;
    push @directions, "west" if $x-1 >=0 && $map[$y][$x-1] == $elevation;
    return @directions;
}

sub readMap {
    foreach my $m (0..$height - 1) {
        my $line = shift @inputData;
        my @row = split('', $line);

        foreach my $n (0..$width - 1) {
            my $current = $row[$n];

            if ($current eq '0') {
                $trailheads{"$m,$n"} = -1;
            }
            $map[$m][$n] = $current;
        }
    }
}

run();