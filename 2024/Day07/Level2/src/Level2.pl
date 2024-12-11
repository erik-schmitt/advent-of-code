use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

use Math::Base::Convert;
my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

my %operationLookup = (
    0 => '+',
    1 => '*',
    2 => '||'
);

sub run {
    my $sum = 0;
    foreach my $line (@inputData) {
        $line =~ /^(\d+):/;
        my $result = $1;
        $sum += $result if equationIsTrue($line);
    }
    say $sum;
}

sub equationIsTrue {
    my $line = shift;
    $line =~ s/^(\d+):\s+//;
    my $expectedResult = $1;
    my @operands = split(/\s/, $line);
    my @combinationsOfOperations = getOperations(scalar @operands - 1);
    my $isTrue = 0;
    while (!$isTrue && @combinationsOfOperations) {
        my $currentOperationList = shift @combinationsOfOperations;
        my @currentOperations = split(//, $currentOperationList);
        my @currentOperands = @operands;
        my $actualResult = shift @currentOperands;
        my $notBigEnough = 1;
        do {
            my $operand = shift @currentOperands;
            if (@currentOperations) {
                my $opcode = shift @currentOperations;
                my $operation = $operationLookup{$opcode};
                if ($operation eq '||') {
                    $actualResult = "$actualResult$operand";
                }
                elsif ($operation eq '+') {
                    $actualResult += $operand;
                }
                elsif ($operation eq '*') {
                    $actualResult *= $operand;
                }
                else {
                    die "Unknown operation: $operation";
                }
            }
            else {
                die "Operation missing";
            }
            # Since the actual result can only increase, we can exit the test early if the result is too large
            $notBigEnough = 0 if $actualResult > $expectedResult;
        }
        while (@currentOperands && $notBigEnough);
        $isTrue = 1 if $actualResult == $expectedResult;
    }
    return $isTrue;
}

sub getOperations {
    my $digits = shift;
    my @operations;
    my $count = 3 ** $digits;
    my $baseThreeEncoding = ['0'..'2'];
    my $decimalToBaseThree = Math::Base::Convert->new('10', $baseThreeEncoding);
    for (my $i = 0; $i < $count; $i++) {
        my $converted = $decimalToBaseThree->cnv($i);
        push @operations, sprintf("%0${digits}d", $converted);
    }
    return @operations;
}

run();