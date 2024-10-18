use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;
use Data::Dumper;
use JSON::PP;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();

my %packetData;
my $sumOfIndices = 0;

sub run {
    storeInput();
    foreach my $i (sort keys %packetData) {
        my $result = comparePackets($packetData{$i}{1}, $packetData{$i}{2});
        $sumOfIndices += $i if $result == 1;
    }
    say $sumOfIndices;
}

sub storeInput {
    # Create a new JSON::PP object
    my $json = JSON::PP->new;

    my $i = 0;
    my $pair = 1;
    foreach my $line (@inputData) {
        if ($i % 3 == 0) {
            $packetData{$pair}{'1'} = $json->decode($line);
        }
        if ($i % 3 == 1) {
            $packetData{$pair}{'2'} = $json->decode($line);
        }
        if ($i % 3 == 2) {
            die "Data found" unless $line =~ /^\s*$/;
            $pair++;
        }
        $i++;
    }
}

sub comparePackets {
    my ($left, $right) = @_;

    if (ref($left) eq '' && ref($right) eq '') { # Both sides are integers
        return 1 if $left < $right;
        return 0 if $left > $right;
        return undef;
    }
    elsif (ref($left) eq '' && ref($right) eq 'ARRAY') { # Convert left side to list and compare
        return comparePackets([$left], $right);
    }
    elsif (ref($left) eq 'ARRAY' && ref($right) eq '') { # Convert right side to list and compare
        return comparePackets($left, [$right]);
    }
    elsif (ref($left) eq 'ARRAY' && ref($right) eq 'ARRAY') { # Both sides are lists
        my $min = scalar @{$left};
        $min = scalar @{$right} if scalar @{$right} < $min;
        for (my $i = 0; $i < $min; $i++) {
            my $result = comparePackets($left->[$i], $right->[$i]);
            return $result if defined $result;
        }
        if (scalar @{$left} < scalar @{$right}) {
            return 1;
        }
        elsif (scalar @{$left} > scalar @{$right}) {
            return 0;
        }
        else {
            return undef;
        }
    }
    else {
        die "Something went wrong";
    }
}

run();