use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


sub run {
    my $sumSignalStrength = 0;
    my $instruction = '';
    my $value = '';
    my $clock = 0;
    my $registerX = 1;
    my $cycleInterval = 20;
    my $instructionComplete = -1;

    while(@inputData || $instructionComplete > $clock) {
        if ($clock == $cycleInterval) {
            $sumSignalStrength += $cycleInterval * $registerX;
            $cycleInterval += 40;
            say "Clock: $clock; X: $registerX; Sum: $sumSignalStrength";
        }

        if ($clock == $instructionComplete) {
            if ($instruction eq 'addx') {
                $registerX += $value;
            }
        }


        if (@inputData && $clock >= $instructionComplete) {
            my $line = shift @inputData;
            $line =~ /^(\w+)\s*(.*)/;
            $instruction = $1;
            $value = $2;

            if ($instruction eq 'noop') {
                1;
            }
            elsif ($instruction eq 'addx') {
                $instructionComplete = $clock + 2;
            }
            else {
                die "Unknown instruction: $instruction";
            }
        }
        say "Clock: $clock; X: $registerX; Value: $value";
        $clock++;
    }

    say $registerX;
    say $sumSignalStrength;
}

run();