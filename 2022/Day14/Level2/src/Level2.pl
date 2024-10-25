use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

my @cave;
my $blocked = 1;
my $unitsOfSand = 0;
my $minX = 500;
my $maxX = 500;
my $minY = 0;
my $maxY = 0;
$cave[500][0] = '+';
my $moving;

sub run {
    parseInput();

    # Add the floor to the data structure
    $maxY += 2; # location of floor
    for (my $i = 0; $i <= $maxX+1000; $i++) {
        $cave[$i][$maxY] = '#';
    }

    printWindow();
    while ($blocked) {
        $blocked = traceSand();
        $unitsOfSand++ if $blocked == 1;
    }
    printWindow();
    say $unitsOfSand;
}

sub printWindow {
    say "Start X: ", $minX-5, " Start Y: ", $minY, " End X: ", $maxX+5, " End Y: ", $maxY;
    for (my $i = $minY; $i < $maxY + 1; $i++) {
        for (my $j = $minX-5; $j < $maxX+5; $j++) {
            my $value = defined($cave[$j][$i]) ? $cave[$j][$i] : ".";
            printf("%1s", $value);
        }
        print "\n";
    }
    print "\n" x 3;
}

sub traceSand {
    my $x = 500;
    my $y = 0;
    $moving = 1;
    while ($moving) {
        return 0 if $cave[500][0] eq 'o'; # Sand is blocking source

        # Update these values for our viewing window
        $maxY = $y if $y > $maxY;
        $maxX = $x if $x > $maxX;
        $minX = $x if $x < $minX;

        if (!(defined($cave[$x][$y+1]))) { # able to fall straight down
            $y++;
            next;
        }
        if (!(defined($cave[$x-1][$y+1]))) { # able to fall down and left
            $x--;
            $y++;
            next;
        }
        if (!(defined($cave[$x+1][$y+1]))) { # able to fall down and right
            $x++;
            $y++;
            next;
        }
        $cave[$x][$y] = 'o'; # Final position
        $moving = 0;
    }
    return 1;
}

sub parseInput {
    foreach my $line (@inputData) {
        my @paths = split(/ -> /, $line);
        my $path = shift @paths;

        # Get starting position and mark it
        $path =~ /^(\d+),(\d+)/;
        my $startX = $1;
        my $startY = $2;
        $cave[$startX][$startY] = '#';

        # Mark the paths
        foreach my $path (@paths) {
            $path =~ /^(\d+),(\d+)/;
            my $endX = $1;
            my $endY = $2;
            $minX  = $endX if $endX < $minX;
            $maxX = $endX if $endX > $maxX;
            $maxY = $endY if $endY > $maxY;

            if ($endX < $startX ) {
                my $x = $startX - 1;
                while ($x >= $endX) {
                    $cave[$x][$startY] = '#';
                    $x--;
                }
            }
            else {
                my $x = $startX + 1;
                while ($x <= $endX) {
                    $cave[$x][$startY] = '#';
                    $x++;
                }
            }

            if ($endY < $startY ) {
                my $y = $startY - 1;
                while ($y >= $endY) {
                    $cave[$startX][$y] = '#';
                    $y--;
                }
            }
            else {
                my $y = $startY + 1;
                while ($y <= $endY) {
                    $cave[$startX][$y] = '#';
                    $y++;
                }
            }
            $startX = $endX;
            $startY = $endY;
        }
    }
}

run();