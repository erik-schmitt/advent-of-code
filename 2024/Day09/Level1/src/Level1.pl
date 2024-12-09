use strict;
use warnings;
use v5.38;
use lib 'c:/users/eriks/Documents/Code/advent-of-code/2024/utils/';
use FileReader;
use Data::Dumper;

my $fileReader = FileReader->new(filename => './Level1/InputDataLevel1.txt');
my @inputData = $fileReader->getFile();

# Example input
# 42 blocks
# 28 files
# 14 empty
# 1928 checksum

my $fileBlockCount = 0;

my @emptyIndices;

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
            for (my $j = 0; $j < $size; $j++) {
                push @emptyIndices, $index;
                push @output, '.';
                $index++;
            }
        }
    }
    return \@output;
}

sub compactFileSystem {
    my $files = shift;
    my $totalBlockCount = scalar @{$files};
    my $emptyBlockCount = scalar @emptyIndices;
    say "Blocks: $totalBlockCount";
    say "Files: $fileBlockCount";
    say "Empty: $emptyBlockCount";
    my $i = 0;

    $i = $totalBlockCount - 1;
    while ($i >= $fileBlockCount ) {
        my $block = $files->[$i];
        if ($block ne '.') {
            my $index = shift @emptyIndices;
            my @removed = splice(@{$files}, $index, 1, ($block));
            die "Something is wrong" if $removed[0] ne '.';
            splice(@{$files}, $i, 1, @removed);
        }
        $i--;
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