use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


sub run {
    my $totalScore = 0;
    foreach my $line (@inputData) {
        if ($line =~ /(\w)\s(\w)/) {
            my $opponentChoice = $1; # A = Rock, B = Paper, C = Scissors
            my $myChoice = $2; # X = Rock, Y = Paper, Z = Sissors

            $totalScore += 1 if $myChoice eq 'X';
            $totalScore += 2 if $myChoice eq 'Y';
            $totalScore += 3 if $myChoice eq 'Z';

            # 3 points for a draw
            $totalScore += 3 if $opponentChoice eq 'A' && $myChoice eq 'X';
            $totalScore += 3 if $opponentChoice eq 'B' && $myChoice eq 'Y';
            $totalScore += 3 if $opponentChoice eq 'C' && $myChoice eq 'Z';

            # 6 points for a win
            $totalScore += 6 if $opponentChoice eq 'C' && $myChoice eq 'X';
            $totalScore += 6 if $opponentChoice eq 'A' && $myChoice eq 'Y';
            $totalScore += 6 if $opponentChoice eq 'B' && $myChoice eq 'Z';
        }
    }
    say $totalScore;
}

run();