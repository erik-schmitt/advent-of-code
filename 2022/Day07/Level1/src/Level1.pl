use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2022/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();
my $totalSize = 0;

sub run {
    my %fileSystem;
    my @breadCrumbs;
    my $action;
    foreach my $line (@inputData) {
        if ($line =~ /^\$ cd\s(.*)/) {
            # Change directory
            my $name = $1;

            if ($name eq '/') {
                @breadCrumbs = ();
                my $cwd = \%fileSystem;
                my %dir = (
                    'type' => 'dir',
                );
                $cwd->{$name} = \%dir;
                push @breadCrumbs, $cwd->{$name};
            }
            elsif ($name eq '..') {
                pop @breadCrumbs;
            }
            else {
                my $cwd = $breadCrumbs[-1];
                my %dir = (
                    'type' => 'dir',
                );
                $cwd->{$name} = \%dir;
                push @breadCrumbs, $cwd->{$name};
            }
            $action = 'Change directory\n';
        }
        elsif ($line =~ /^\$ ls/) {
            $action = 'Request listing\n';
        }
        elsif ($line =~ /^(\d+)\s(.+)/) {
            # Store file
            my $size = $1;
            my $name = $2;
            my $cwd = $breadCrumbs[-1];
            my %file = (
                'size' => $size,
                'type' => 'file',
            );
            $cwd->{$name} = \%file;
            $action = 'Store file\n';
        }
        elsif ($line =~ /^dir\s(.+)/) {
            # Store directory
            my $name = $1;
            my $cwd = $breadCrumbs[-1];
            my %dir = (
                'type' => 'dir',
            );
            $cwd->{$name} = \%dir;
            $action = 'Store directory\n';
        }
        else {
            die("Uknown file command: $line\n");
        }
    }
    print "File system parsed\n";
    calculateDirectorySizes(\%fileSystem);
    print "Directory sizes calculated\n";
    print "Total size is: $totalSize\n";
}

sub calculateDirectorySizes {
    my $hashRef = shift;
    my @objects = keys %{$hashRef};
    foreach my $object (@objects) {
        next if $object eq 'type';
        # print "Checking $object\n";
        if ($hashRef->{$object}{'type'} eq 'dir') {
            my $dirRef = \%{$hashRef->{$object}};
            calculateDirectorySizes($dirRef);
            $hashRef->{'size'} += $hashRef->{$object}{'size'};

            if ( $hashRef->{$object}{'size'} <= 100000) {
                $totalSize += $hashRef->{$object}{'size'};
            }
        }
        elsif ($hashRef->{$object}{'type'} eq 'file') {
            $hashRef->{'size'} += $hashRef->{$object}{'size'};
        }

    }
}

run();