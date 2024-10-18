use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

my @rope = ([0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]);
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

        for (my $t = 1; $t < scalar @rope; $t++) {
            my $h = $t - 1;
            # Move tail to follow if needed
            unless(headTouchesTail(\@{$rope[$h]}, \@{$rope[$t]})) {
                moveTail(\@{$rope[$h]}, \@{$rope[$t]});
            }

            if ($t == scalar @rope - 1) {
                # Mark location visited
                $visited{"$rope[$t][0],$rope[$t][1]"}++;
            }
        }

    }
}

sub moveHead {
    my $direction = shift;

    $rope[0][0]-- if $direction eq 'L';
    $rope[0][0]++ if $direction eq 'R';
    $rope[0][1]++ if $direction eq 'U';
    $rope[0][1]-- if $direction eq 'D';
}

sub headTouchesTail
{
    my ($headPosition, $tailPosition) = @_;
    my $xSeparation = $headPosition->[0] - $tailPosition->[0];
    my $ySeparation = $headPosition->[1] - $tailPosition->[1];

    my $isTouching = 1;

    $isTouching = 0 if $xSeparation < -1;
    $isTouching = 0 if $xSeparation > 1;
    $isTouching = 0 if $ySeparation < -1;
    $isTouching = 0 if $ySeparation > 1;

    return $isTouching;
}

sub moveTail {
    my ($headPosition, $tailPosition) = @_;
    my $xSeparation = $headPosition->[0] - $tailPosition->[0];
    my $ySeparation = $headPosition->[1] - $tailPosition->[1];

    if ($xSeparation > 1 && $ySeparation == 0) {
        $tailPosition->[0]++;
    }
    elsif ($xSeparation < -1 && $ySeparation == 0) {
        $tailPosition->[0]--;
    }
    elsif ($xSeparation == 0 && $ySeparation > 1) {
        $tailPosition->[1]++;
    }
    elsif ($xSeparation == 0 && $ySeparation < 1) {
        $tailPosition->[1]--;
    }
    elsif ($xSeparation > 0 && $ySeparation > 0) {
        $tailPosition->[0]++;
        $tailPosition->[1]++;
    }
    elsif ($xSeparation < 0 && $ySeparation > 0) {
        $tailPosition->[0]--;
        $tailPosition->[1]++;
    }
    elsif ($xSeparation < 0 && $ySeparation < 0) {
        $tailPosition->[0]--;
        $tailPosition->[1]--;
    }
    elsif ($xSeparation > 0 && $ySeparation < 1) {
        $tailPosition->[0]++;
        $tailPosition->[1]--;
    }
}

run();