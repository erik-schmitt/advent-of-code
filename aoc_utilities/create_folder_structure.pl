use strict;
use warnings;

use File::Spec;


my $base = '';
# Check that base path exists

# Get Year
die "Invalid number of arguments: please specify year for folder structure" unless scalar @ARGV == 1;
my $year = shift @ARGV;
die "Invalid Year: $year" unless $year =~ /^\d{4}$/;
die "Invalid Year prior to 2015: $year" unless $year >= 2015;

# Create Year folder
create_path(File::Spec->catfile($base, $year);

# Create utils folder
create_path(File::Spec->catfile($base, $year, 'utils');

my $template = File::Spec->catfile($base, 'aoc_utilities', 'Day_TEMPLATE');
# Check that template folder exists

# Update year in template libraries

# Create folder structure for each day
for (my $i = 1; $i <=25; $i++) {
    my $day = 'Day' . sprintf("%02d, $i");
    create_path(File::Spec->catfile($base, $year, $day));
    # Copy folder structure from template
}

sub create_path {
    my $path = shift;
    # Skip if path already exists
}