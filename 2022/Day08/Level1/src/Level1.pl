use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();

sub run {
    my @forest = ();
    my $width = scalar split('', $inputData[0]);
    my $height = scalar @inputData;
    my %rows;
    my %columns;
    # my %checkedTrees;

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
            # $checkedTrees{"$m,$n"} = 'false';
        }
    }
    say "Forest stored";

    my $visibleTrees = 0;
    foreach my $m (0..$height - 1) {
        foreach my $n (0..$width - 1) {
            my $isVisible = 0;
            my $currentTree = $forest[$m][$n];
            say "Tree $m,$n height is $currentTree";
            # Trees on the edges are always visible
            if ($m == 0 or $m == $height-1) {
                $isVisible = 1;
            }
            if ($n == 0 or $n == $width-1) {
                $isVisible = 1;
            }

            # Check interior trees only
            unless ($isVisible) {
                my $leftIsTaller = 0;
                my $rightIsTaller = 0;
                my $upIsTaller = 0;
                my $downIsTaller = 0;
                # say "Row: ";
                # print Dumper @{rows{$m}};
                # say "Column: ";
                # print Dumper @{columns{$n}};
                foreach my $i (0..$width - 1) {
                    if ($i < $n) {
                        $leftIsTaller = 1 if ${rows{$m}}[$i] >= $currentTree;
                    }
                    if ($i > $n) {
                        $rightIsTaller = 1 if ${rows{$m}}[$i] >= $currentTree;
                    }
                }
                foreach my $i (0..$height - 1) {
                    if ($i < $m) {
                        $upIsTaller = 1 if ${columns{$n}}[$i] >= $currentTree;
                    }
                    if ($i > $m) {
                        $downIsTaller = 1 if ${columns{$n}}[$i] >= $currentTree;
                    }
                }
                $isVisible = 1 unless $leftIsTaller == 1 && $rightIsTaller == 1 && $upIsTaller == 1 && $downIsTaller == 1;
            }
            my $string = $isVisible ? "visible" : "not visible";
            # say "Tree $m,$n is: $string";
            $visibleTrees++ if $isVisible == 1;
        }
    }
    say $visibleTrees;
}

run();