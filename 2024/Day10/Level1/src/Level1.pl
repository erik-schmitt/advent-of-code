use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;
use Data::Dumper;
my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();

my @map;
my $width = scalar split('', $inputData[0]);
my $height = scalar @inputData;
say "Height: $height";
say "Width: $width";
my $sumOfScores = 0;
my %trailheads;
my %mappedTrails;

sub run {
    readMap();
    foreach my $start (sort keys %trailheads) {
        my ($y, $x) = split(/,/, $start);
        %mappedTrails = ();
        my $score = findTrails($y,$x);
        $sumOfScores += $score;
    }
    say $sumOfScores;
}

sub findTrails {
    my ($y,$x) = @_;
    if ($map[$y][$x] == 9) {
        if (exists $mappedTrails{"$y,$x"}) {
            return 0;
        }
        $mappedTrails{"$y,$x"} = 1;
        return 1;
    }
    else {
        my $score = 0;
        my @directions = getValidDirections($y, $x);
        foreach my $direction (@directions) {
            $score += findTrails($y-1,$x) if $direction eq 'north';
            $score += findTrails($y,$x+1) if $direction eq 'east';
            $score += findTrails($y+1,$x) if $direction eq 'south';
            $score += findTrails($y,$x-1) if $direction eq 'west';
        }
        return $score;
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