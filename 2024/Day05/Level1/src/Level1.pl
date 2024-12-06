use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();

my %rules;
my @updates;
my $sumMiddlePages = 0;
sub run {
    parseInput();
    UPDATE: foreach my $update (@updates) {
        my @pages = split(/,/, $update);
        my $i = 0;
        my %pageIndexes = map {$_ => $i++} @pages;
        my %currentRules;

        # Build all possible pairs and check complete set of rules and add the only the matching rules
        foreach my $page (@pages) {
            foreach my $page2 (@pages) {

                my $pair = "$page|$page2";
                if (exists $rules{$pair}) {
                $currentRules{$pair} = $rules{$pair}};
            }
        }
        my $sorted = 1;
        # See if pages are sorted
        foreach my $page1 (@pages) {
            foreach my $page2 (@pages) {
                my $index1 = $pageIndexes{$page1};
                my $index2 = $pageIndexes{$page2};
                if (exists $currentRules{"$page1|$page2"}) {
                    $sorted = 0 if $index2 < $index1;
                    next UPDATE if $sorted == 0;
                }
            }
        }

        # my $indexString = join('', @indices);
        # my @sorted = sort {$a <=> $b} @indices;
        # my $sortedIndexString = join('', @sorted);
        # if ($indexString eq $sortedIndexString) {
        #     $sumMiddlePages += getMiddlePage(@pages);
        # }
        $sumMiddlePages += getMiddlePage(@pages);

    }
    say $sumMiddlePages;
}

sub getMiddlePage {
    my @update = @_;
    my $index = int(scalar(@update)/2);
    return $update[$index];
}

sub parseInput {
    foreach my $line (@inputData) {
        if ($line =~ /^(\d+\|\d+)$/) {
            $rules{$1} = 1;
        }
        if ($line =~ /,/) {
            push @updates, $line;
        }
    }
}

=begin
sub parseInput_bad {
    foreach my $line (@inputData) {
        if ($line =~ /^(\d+)\|(\d+)$/) {
            my $first = $1;
            my $second = $2;

            # if (scalar @rules == 0) {
            #     @rules = ($first, $second);
            #     next;
            # }
            my $first_index = -1;
            my $second_index = -1;
            for (my $i = $#rules; $i > 0; $i--) {
                $first_index = $i if $rules[$i] == $first;
                $second_index = $i if $rules[$i] == $second;
            }

            if ($first_index > -1 && $second_index == -1) {
                push @rules, $second;
            }
            elsif ($first_index == -1 && $second_index > -1) {
                splice(@rules, $second_index, 0, $first);
            }
            elsif ($first_index == -1 && $second_index == -1)
            {
                push @rules, $first;
                push @rules, $second;
            }
            elsif ($first_index >= 0 && $second_index >= 0 && $first_index > $second_index) {
                my @moved = splice(@rules, $first_index, 1);
                splice(@rules, $second_index, 0, @moved);
            }

        }
        if ($line =~ /,/) {
            push @updates, $line;
        }
    }
}
=cut

run();