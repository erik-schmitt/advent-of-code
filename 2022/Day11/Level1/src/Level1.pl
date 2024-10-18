use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();

my %itemWorryLevel = ();
my %monkeys = ();
my $rounds = 20; # 20 Rounds of monkey business

sub run {
    readInitialState();
    # print Dumper \%itemWorryLevel;
    # print Dumper \%monkeys;

    for (1..$rounds) {
        for (my $i = 0; $i < keys %monkeys; $i++) {
            my $itemArrayRef = $monkeys{$i}{'items'};
            while (my $worryLevel = shift @{$itemArrayRef}) {
                # print Dumper $itemArrayRef;
                # my $worryLevel = shift @{$itemArrayRef};
                # print Dumper $worryLevel;

                # Update worry level based upon monkey
                my $operation = $monkeys{$i}{'operation'};
                $operation =~ s/old/\$worryLevel/g;
                my $newWorryLevel = eval $operation;

                # Decrease worry level
                print Dumper $itemArrayRef unless defined $newWorryLevel;
                $newWorryLevel = sprintf("%0d", $newWorryLevel/3);

                # Test the item to determine where the item will be thrown
                my $divisor = $monkeys{$i}{'test'};
                my $catcher = $newWorryLevel % $divisor == 0 ? $monkeys{$i}{'true'} : $monkeys{$i}{'false'};
                # print Dumper @{$monkeys{$catcher}{'items'}};
                push @{$monkeys{$catcher}{'items'}}, $newWorryLevel;
                # print Dumper @{$monkeys{$catcher}{'items'}}

                # Update touches
                $monkeys{$i}{'touches'}++;
            }
        }
    }

    # my $i = 0;
    my @list;
    foreach my $monkey ( sort { $monkeys{$a}{'touches'} <=> $monkeys{$b}{'touches'} } keys %monkeys ) {
        push @list, $monkeys{$monkey}{'touches'};
        # $i++;
        # last if $i > 1;
    }
    # print Dumper @list;
    my $activeMonkeyCount1 = pop @list;
    my $activeMonkeyCount2 = pop @list;
    say $activeMonkeyCount1 * $activeMonkeyCount2;
}

sub readInitialState {
    my $monkey;
    foreach my $line (@inputData) {
        if ($line =~ /^Monkey\s+(\d+):/) {
            $monkey = $1;
            $monkeys{$monkey}{'touches'} = 0;
        }
        elsif ($line =~ /^\s+Starting items:\s(.+)+/ ) {
            my @items = split(', ', $1);
            foreach my $item (@items) {
                $itemWorryLevel{$item} = $item;
            }
            $monkeys{$monkey}{'items'} = \@items;
        }
        elsif ($line =~ /^\s+Operation: new =\s(.+)$/ ) {
            $monkeys{$monkey}{'operation'} = $1;
        }
        elsif ($line =~ /^\s+Test: divisible by\s(\d+)$/ ) {
            $monkeys{$monkey}{'test'} = $1;
        }
        elsif ($line =~ /^\s+If true:.+monkey\s(\d+)$/ ) {
            $monkeys{$monkey}{'true'} = $1;
        }
        elsif ($line =~ /^\s+If false:.+monkey\s(\d+)$/ ) {
            $monkeys{$monkey}{'false'} = $1;
        }
    }
}

run();