use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

sub run {
    my $instruction = '';
    my $value = '';
    my $clock = 0;
    my $registerX = 1;
    my $instructionComplete = -1;
    my $xCoord = 0;

    while(@inputData || $instructionComplete > $clock) {
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

        if ($xCoord < $registerX-1 || $xCoord > $registerX+1) {
            print "#";
        }
        else {
            print ".";
        }

        $clock++;
        $xCoord++;
        if ($xCoord % 40 == 0) {
            print "\n";
            $xCoord = 0;
        }
    }
}

run();