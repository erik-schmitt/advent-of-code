use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();


sub run {
    my %stacks;
    my @startingConfiguration;
    foreach my $line (@inputData) {
        if ($line =~ /^move (\d+) from (\d+) to (\d+)/) {
            my $quantity = $1;
            my $source = $2;
            my $destination = $3;
            my $offset = $quantity * -1;
            my @containers = splice(@{$stacks{$source}}, $offset, $quantity);
            push @{$stacks{$destination}}, @containers;
        }
        elsif ($line eq '')
        {
            readStartingConfiguration(\%stacks, \@startingConfiguration);
        }
        else {
            push @startingConfiguration, $line;
        }
    }

    my $topElements = '';
    foreach my $stackNumber (sort {$a <=> $b} keys %stacks) {
        $topElements .= pop @{$stacks{$stackNumber}};
    }
    $topElements =~ s/\[//g;
    $topElements =~ s/\]//g;
    say $topElements, "\n";
}

sub readStartingConfiguration {
    my ($stacks, $startingConfiguration) = @_;

    # Read stack labels
    my $line = pop @{$startingConfiguration};
    %{$stacks} = map {$_ => []} split(' ', $line);

    # Read containers
    my $numberOfStacks = scalar keys %{$stacks};
    while (@{$startingConfiguration}) {
        my $line = pop @{$startingConfiguration};
        for (my $i = 0; $i < $numberOfStacks; $i++) {
            my $container = substr($line, $i*4, 3);
            push @{$stacks->{$i+1}}, $container if $container =~ /\w/;
        }
    }
}

run();