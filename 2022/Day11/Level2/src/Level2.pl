use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

my %monkeys = ();
my $rounds = 10000;
my $lcm = 1;

sub run {
    readInitialState();

    for (1..$rounds) {
        for (my $i = 0; $i < keys %monkeys; $i++) {
            my $itemArrayRef = $monkeys{$i}{'items'};
            while (my $worryLevel = shift @{$itemArrayRef}) {

                # Update worry level based upon monkey
                my $newWorryLevel;
                my $operator = $monkeys{$i}{'operator'};
                my $operand = $monkeys{$i}{'operand'};
                if ($operator eq 'multiply') {
                    if ($operand eq 'old') {
                        $newWorryLevel = $worryLevel * $worryLevel;
                    }
                    else {
                        $newWorryLevel = $worryLevel * $operand;
                    }
                }
                elsif ($operator eq 'add') {
                    $newWorryLevel = $worryLevel + $operand;
                }
                else {
                    die "Unknown operator: $operator";
                }

                # Use modular arithmetic by using the least common multiple of all of the monkeys.
                # This works because multiplication and addition are the only operations specified and they do not affect the remainder.
                $newWorryLevel = $newWorryLevel % $lcm;
                my $result = $newWorryLevel % $monkeys{$i}{'test'};

                # Test the item to determine where the item will be thrown
                my $catcher = $result == 0 ? $monkeys{$i}{'true'} : $monkeys{$i}{'false'};
                push @{$monkeys{$catcher}{'items'}}, $newWorryLevel;

                # Update touches
                $monkeys{$i}{'touches'}++;
            }
        }
    }

    my @list;
    foreach my $monkey ( sort { $monkeys{$a}{'touches'} <=> $monkeys{$b}{'touches'} } keys %monkeys ) {
        push @list, $monkeys{$monkey}{'touches'};
    }
    my $activeMonkeyCount1 = pop @list;
    my $activeMonkeyCount2 = pop @list;
    say $activeMonkeyCount1 * $activeMonkeyCount2;
}

sub readInitialState {
    my $monkey;
    foreach my $line (@inputData) {
        next if $line =~ /^\s*$/;
        
        if ($line =~ /^Monkey\s+(\d+):/) {
            $monkey = $1;
            $monkeys{$monkey}{'touches'} = 0;
        }
        elsif ($line =~ /^\s+Starting items:\s(.+)+/ ) {
            my @items = split(', ', $1);
            $monkeys{$monkey}{'items'} = \@items;
        }
        elsif ($line =~ /^\s+Operation: new =\s(.+)$/ ) {
            if ($line =~ /\*\s(\w+)/) {
                $monkeys{$monkey}{'operator'} = 'multiply';
                $monkeys{$monkey}{'operand'} = $1;
            }
            elsif ($line =~ /\+\s(\w+)/) {
                $monkeys{$monkey}{'operator'} = 'add';
                $monkeys{$monkey}{'operand'} = $1;
            }
            else {
                die "Unknown operation: $line";
            }
        }
        elsif ($line =~ /^\s+Test: divisible by\s(\d+)$/ ) {
            $monkeys{$monkey}{'test'} = $1;
            $lcm *= $1;
        }
        elsif ($line =~ /^\s+If true:.+monkey\s(\d+)$/ ) {
            $monkeys{$monkey}{'true'} = $1;
        }
        elsif ($line =~ /^\s+If false:.+monkey\s(\d+)$/ ) {
            $monkeys{$monkey}{'false'} = $1;
        }
        else {
            die "Unknown input line: $line";
        }
    }
}

run();