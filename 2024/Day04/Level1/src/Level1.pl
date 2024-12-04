use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


my $count = 0;
my @searchGrid;
my $width = scalar split('', $inputData[0]);
my $height = scalar @inputData;
my $length = length 'XMAS';

sub run {
    loadWordSearch();

     foreach my $m (0..$height - 1) {
        foreach my $n (0..$width - 1) {
            if ('X' eq $searchGrid[$m][$n]) {
                $count += findWord($m, $n);
            }
        }
    }
    say $count;
}

sub findWord {
    my ($m, $n) = @_;
    my $matches = 0;
    my $validDirections = getValidDirections($m,$n);
    foreach my $direction (sort keys %{$validDirections}){
        $matches++ if checkForWord($direction, $m, $n);
    }
    return $matches;
}

sub getValidDirections {
    my ($m, $n) = @_;
    my %directions;
    $directions{'east'} = 1 if $n + $length <= $width;
    $directions{'west'} = 1 if $n + 1 - $length >= 0;
    $directions{'north'} = 1 if $m + 1 - $length >= 0;
    $directions{'south'} = 1 if $m + $length <= $height;

    $directions{'northeast'} = 1 if exists $directions{'east'} && exists $directions{'north'};
    $directions{'northwest'} = 1 if exists $directions{'west'} && exists $directions{'north'};
    $directions{'southeast'} = 1 if exists $directions{'east'} && exists $directions{'south'};
    $directions{'southwest'} = 1 if exists $directions{'west'} && exists $directions{'south'};
    return \%directions;
}

sub checkForWord {
    my ($direction, $m, $n) = @_;
    my $string = '';

    $string = $searchGrid[$m][$n+1] . $searchGrid[$m][$n+2] . $searchGrid[$m][$n+3] if ($direction eq 'east');
    $string = $searchGrid[$m][$n-1] . $searchGrid[$m][$n-2] . $searchGrid[$m][$n-3] if $direction eq 'west';
    $string = $searchGrid[$m+1][$n] . $searchGrid[$m+2][$n] . $searchGrid[$m+3][$n] if $direction eq 'south';
    $string = $searchGrid[$m-1][$n] . $searchGrid[$m-2][$n] . $searchGrid[$m-3][$n] if $direction eq 'north';
    $string = $searchGrid[$m+1][$n+1] . $searchGrid[$m+2][$n+2] . $searchGrid[$m+3][$n+3] if $direction eq 'southeast';
    $string = $searchGrid[$m+1][$n-1] . $searchGrid[$m+2][$n-2] . $searchGrid[$m+3][$n-3] if $direction eq 'southwest';
    $string = $searchGrid[$m-1][$n+1] . $searchGrid[$m-2][$n+2] . $searchGrid[$m-3][$n+3] if $direction eq 'northeast';
    $string = $searchGrid[$m-1][$n-1] . $searchGrid[$m-2][$n-2] . $searchGrid[$m-3][$n-3] if $direction eq 'northwest';

    die "Invalid direction: $direction" if $string eq '';
    return 1 if $string eq 'MAS';
    return 0;
}

sub loadWordSearch {
    foreach my $m (0..$height - 1) {
        my $line = shift @inputData;
        my @row = split('', $line);

        foreach my $n (0..$width - 1) {
            my $current = $row[$n];
            $searchGrid[$m][$n] = $current;
        }
    }
}

run();