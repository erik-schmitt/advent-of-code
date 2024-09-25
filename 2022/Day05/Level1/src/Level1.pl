use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();


sub run {
    my %stacks;
    my @startingConfiguration;
    foreach my $line (@inputData) {
        if ($line =~ /^move/) {
            say %stacks;
            exit;
        }
        elsif ($line eq '')
        {
            readStartingConfiguration(\%stacks, \@startingConfiguration);
        }
        else {
            push @startingConfiguration, $line;
        }
    }

    my $topElements;
    foreach my $stack (sort keys %stacks) {
        $topElements .= pop @{$stacks{$stack}};
    }
    say $topElements, "\n";
}

sub readStartingConfiguration {
    my ($stacks_ref, $start_ref) = @_;
    
    # Read stack labels
    my $line = pop @{$start_ref};
    %{$stacks_ref} = map {$_ => []} split(' ', $line);

    # Read containers
    my $numberOfStacks = scalar keys %{$stacks_ref};
    while (@{$start_ref}) {
        my $line = pop @{$start_ref};
        $line .= ' '; # So substrings don't go outside string
        for (my $i = 0; $i < length($line); $i+3) {
            my $container = substr($line, $i, 4);
            push @{$stacks_ref->{$i+1}}, $container;
            # $line = substr($line, $i+3);            
        }
    }
}

run();