#!/usr/bin/perl
# Creates an n-gram profile
# Based on the module below
use Text::Ngrams;

# ./create-profile.pl n L profile_name
my $windowSize = @ARGV[0];  # window size
my $onlyFirst = @ARGV[1];   # number of most frequent n-grams

my $ng = "";
my $outText = "";
my $i;

while (<STDIN>) {
  $input .= $_;        # text file to read
}  

# Add the results for each n-gram size to a string
$ng = Text::Ngrams->new( windowsize => $windowSize, type => byte );
$ng->process_text($input);
$outText .= $ng->to_string( orderby => 'frequency', onlyfirst => $onlyFirst, normalize => 1, spartan => 1);

# Print text in string to profile_name
print $outText;

