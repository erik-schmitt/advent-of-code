use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

sub run {
    my @forest = ();
    my $width = scalar split('', $inputData[0]);
    my $height = scalar @inputData;
    my %rows;
    my %columns;

    foreach my $m (0..$height - 1)
    {
        my $line = shift @inputData;
        my @row = split('', $line);

        foreach my $n (0..$width - 1)
        {
            my $currentTree = $row[$n];
            $forest[$m][$n] = $currentTree;

            push @{$rows{$m}}, $currentTree;
            push @{$columns{$n}}, $currentTree;
        }
    }

    my $maxTreeScore = 0;
    foreach my $m (0..$height - 1) {
        foreach my $n (0..$width - 1) {
            my $isEdge = 0;
            my $currentTree = $forest[$m][$n];
            # Trees on the edges always have 0 tree score
            if ($m == 0 or $m == $height-1) {
                $isEdge = 1;
            }
            if ($n == 0 or $n == $width-1) {
                $isEdge = 1;
            }

            # Check interior trees only
            unless ($isEdge) {
                my $leftScore = 1;
                my $rightScore = 1;
                my $upScore = 1;
                my $downScore = 1;

                for (my $i = $n-1; $i > 0; $i--) {
                    last if ${rows{$m}}[$i] >= $currentTree;
                    $leftScore++;
                }
                for (my $i = $n+1; $i < $width - 1; $i++) {
                    last if ${rows{$m}}[$i] >= $currentTree;
                    $rightScore++;
                }
                for (my $i = $m-1; $i > 0; $i--) {
                    last if ${columns{$n}}[$i] >= $currentTree;
                    $upScore++;
                }
                for (my $i = $m+1; $i < $height - 1; $i++) {
                    last if ${columns{$n}}[$i] >= $currentTree;
                    $downScore++;
                }
                my $currentTreeScore =  $leftScore * $rightScore * $upScore * $downScore;
                $maxTreeScore = $currentTreeScore if $currentTreeScore > $maxTreeScore;
            }
           ;
        }
    }
    say $maxTreeScore;
}

run();