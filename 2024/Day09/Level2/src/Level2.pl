use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;

my $fileReader = FileReader->new(filename => './Level2/InputDataLevel2.txt');
my @inputData = $fileReader->getFile();

my $fileBlockCount = 0;
my $emptyBlockCount = 0;
my %emptyIndices;
my %fileIndices;
my %fileSizes;

sub run {
    my @diskMap = parseInput();
    my $fileSystem = idBlocks(@diskMap);
    compactFileSystem($fileSystem);

    my $checksum = calculateChecksum($fileSystem);
    say $checksum;
}

sub idBlocks {
    my @map = @_;
    my %files;
    my @output;
    my $state = 'file';
    my $fileID = 0;
    my $index = 0;
    while(@map) {
        my $size = shift @map;
        if ($state eq 'file') {
            $fileIndices{$fileID} = $index;
            $fileSizes{$fileID} = $size;
            for (my $j = 0; $j < $size; $j++) {
                push @output, $fileID;
                $index++;
                $fileBlockCount++;
            }

            $state = 'empty';
            $fileID++;
        }
        else {
            $state = 'file';
            next if $size == 0;
            $emptyIndices{$index} = $size;
            for (my $j = 0; $j < $size; $j++) {
                push @output, '.';
                $index++;
                $emptyBlockCount++;
            }
        }
    }
    return \@output;
}

sub updateEmptyIndices {
    my $files = shift;
    my $size = 0;
    my $systemSize = scalar @{$files};
    my $state = 'file';
    my $emptyIndex;
    %emptyIndices = ();
    for (my $index = 0; $index < $systemSize; $index++) {
        if ($files->[$index] eq '.') {
            $size++;
            $emptyIndex = $index if $state eq 'file';
            $state = 'empty';
        }
        else {
            $emptyIndices{$emptyIndex} = $size if $state eq 'empty';
            $size = 0;
            $state = 'file';
        }
    }
    $emptyIndices{$emptyIndex} = $size if $state eq 'empty';
}

sub compactFileSystem {
    my $files = shift;
    my $totalBlockCount = scalar @{$files};
    say "Blocks: $totalBlockCount";
    say "Files: $fileBlockCount";
    say "Empty: $emptyBlockCount";

    my $fileCount = scalar keys %fileIndices;
    FILE: for (my $i = $fileCount -1 ; $i >= 0; $i--) {
        my $fileSize = $fileSizes{$i};
        foreach my $j (sort {$a <=> $b} keys %emptyIndices) {
            my $emptySize = $emptyIndices{$j};
            if ($fileSize <= $emptySize) {
                my $start = $fileIndices{$i};
                next FILE if $start < $j;

                my $end = $start + $fileSize - 1;
                my @block = @{$files}[$start .. $end];
                my @removed = splice(@{$files}, $j, $fileSize, @block);
                splice(@{$files}, $start, $fileSize, @removed);
                updateEmptyIndices($files);
                say "Moved file $i" if $i % 100 == 0;
                next FILE;
            }
        }
    }
}

sub calculateChecksum {
    my $fileSystem = shift;
    my $checksum = 0;
    for (my $i = 0; $i < scalar @{$fileSystem}; $i++) {
        $checksum += $i * $fileSystem->[$i] if $fileSystem->[$i] ne '.';
    }
    return $checksum;
}

sub parseInput {
    my $line = shift @inputData;
    my @characters = split(//, $line);
    return @characters;
}

run();