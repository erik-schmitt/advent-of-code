use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

use Math::Base::Convert qw(cnv);
my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();

my %operationLookup = (
    0 => '+',
    1 => '*',
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
        do {
            my $operand = shift @currentOperands;
            if (@currentOperations) {
                my $opcode = shift @currentOperations;
                my $equation = $actualResult . ' ' . $operationLookup{$opcode} . ' ' . $operand;
                $actualResult = eval("$equation") or die "Can't evaluate expression: $equation";
            }
            else {
                die "Operation missing";
            }
        }
        while (@currentOperands);
        $isTrue = 1 if $actualResult == $expectedResult;
    }
    return $isTrue;
}

sub getOperations {
    my $digits = shift;
    my @operations;
    my $count = 2 ** $digits;
    for (my $i = 0; $i < $count; $i++) {
        my $converted = cnv($i, 'dec', 'bin');
        push @operations, sprintf("%0${digits}d", $converted);
    }
    return @operations;
}

run();