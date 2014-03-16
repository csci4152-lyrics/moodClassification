#!/usr/bin/perl
# Creates an n-gram profile
# Based on the module below
use Text::Ngrams;

# ./create-profile.pl n L profile_name
my $windowSize = @ARGV[0];  # window size
my $onlyFirst = @ARGV[1];   # number of most frequent n-grams
my $pName1 = @ARGV[2];      # profile 1
my $pName2 = @ARGV[3];      # profile 2
my @result1 = ();
my @result2 = ();
my $distance = 0.0;
my $tmp = 0.0;
my $row1;
my $row2;
my $nError = 0; 

my $count = $onlyFirst; 

# Open file for writing
open(my $fh1, "<", $pName1) or die "Couldn't open ", $pName1;

# Note: I assume that n-grams and frequencies are split by tabs 
# (wasn't made obvious in question, so I'm not positive if this is right or not) 

# Gets appropriate frequencies from the first profile
while($row1 = <$fh1>) {
  chomp $row;
  my @args = split("\t", $row1);
  my @chars = split(" ", $args[0]);
  if(scalar(@chars) == $windowSize && $count > 0) {
    $nError = 1; # No error
    chomp $args[1];
    push(@result1, $args[1]);
    $count--;
  }
}

close($fh1) || die "Couldn't close file properly";

# Open file for writing
open(my $fh2, "<", $pName2) or die "Couldn't open ", $pName2;

# Gets appropriate frequencies from the second profile
while($row2 = <$fh2>) {
  chomp $row2;
  my @args = split("\t", $row2);
  my @chars = split(" ", $args[0]);
  if(scalar(@chars) == $windowSize && $onlyFirst > 0) {
    chomp $args[1];
    push(@result2, $args[1]);
    $onlyFirst--;
  }
}

# Close file handle
close($fh2) || die "Couldn't close file properly";

# Ngram error check
if ($nError == 0) {
  print "Error: n-gram size too large\n";
} else {
  for(my $i=0; $i<scalar(@result1); $i++) {
    $tmp = (($result1[$i]-$result2[$i])*2)/($result1[$i]+$result2[$i]);
    $tmp *= $tmp; 
    $distance = $distance + $tmp;
  }

  # Print the result 
  print $distance . "\n";
}
