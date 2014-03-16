#!/usr/bin/perl
# Creates an n-gram profile
# Based on the module below
use Text::Ngrams;

# ./create-profile.pl n L profile_name
my $windowSize = @ARGV[0];  # window size
my $onlyFirst = @ARGV[1];   # number of most frequent n-grams
my $profileName = @ARGV[2]; # name of file to store profile
my $ng = "";
my $outText = "";
my $i;

while (<STDIN>) {
  $input .= $_;        # text file to read
}  

# Open file for writing
open(my $fh, ">", $profileName) or die "Couldn't open ", $profileName;

# Add the results for each n-gram size to a string
for($i = 0; $i < $windowSize; $i++) {
  $ng = Text::Ngrams->new( windowsize => $i+1, type => byte );
  $ng->process_text($input);
  $outText .= $ng->to_string( orderby => 'frequency', onlyfirst => $onlyFirst, normalize => 1, spartan => 1);

  # Print a new line in between n-gram results of different size
  # Except for the final n-gram size
  if($i != $windowSize-1) { 
    $outText .= "\n";
  }
  $ng = "";
}

# Print text in string to profile_name
print $fh $outText;

# Close file handle
close($fh) || die "Couldn't close file properly";
