use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;
use Data::Dumper;
use JSON::PP;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

my %packetData;
my $distressValue1 = '[[2]]';
my $distressValue2 = '[[6]]';
my $distressKey1;
my $distressKey2;


sub run {
    storeInput();

    # Sort the packets
    my @sortedPacketKeys = sort sortPackets keys %packetData;

    # Get decoder indices
    my $decoderIndex1;
    my $decoderIndex2;
    my $i = 1;
    while (@sortedPacketKeys) {
        my $key = shift @sortedPacketKeys;
        $decoderIndex1 = $i if $key == $distressKey1;
        $decoderIndex2 = $i if $key == $distressKey2;
        $i++;
    }

    say $decoderIndex1 * $decoderIndex2;
}

sub sortPackets {
    return comparePackets($packetData{$a}, $packetData{$b}) ? -1 : 1;
}

sub storeInput {
    # Create a new JSON::PP object
    my $json = JSON::PP->new;

    my $i = 0;
    foreach my $line (@inputData) {
        next if $line =~ /^\s*$/;
        $packetData{$i} = $json->decode($line);
        $i++;
    }

    # Add additional packets to the hash
    $packetData{$i} = $json->decode($distressValue1);
    $distressKey1 = $i;
    $packetData{++$i} = $json->decode($distressValue2);
    $distressKey2 = $i;
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