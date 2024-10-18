use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();


sub run {
    my $totalScore = 0;
    foreach my $line (@inputData) {
        if ($line =~ /(\w)\s(\w)/) {
            my $opponentChoice = $1; # A = Rock, B = Paper, C = Scissors
            my $myOutcome = $2; # X = Lose, Y = Draw, Z = Win

            $totalScore += 3 if $myOutcome eq 'Y'; # Draw
            $totalScore += 6 if $myOutcome eq 'Z'; # Win

            # Loss
            if ($myOutcome eq 'X') {
                $totalScore += 3 if $opponentChoice eq 'A';
                $totalScore += 1 if $opponentChoice eq 'B';
                $totalScore += 2 if $opponentChoice eq 'C';
            }

            # Draw
            if ($myOutcome eq 'Y') {
                $totalScore += 1 if $opponentChoice eq 'A';
                $totalScore += 2 if $opponentChoice eq 'B';
                $totalScore += 3 if $opponentChoice eq 'C';
            }

            # Win
            if ($myOutcome eq 'Z') {
                $totalScore += 2 if $opponentChoice eq 'A';
                $totalScore += 3 if $opponentChoice eq 'B';
                $totalScore += 1 if $opponentChoice eq 'C';
            }
        }
    }
    say $totalScore;
}

run();