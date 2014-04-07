#!/usr/bin/perl
# Creates an n-gram profile
# Based on the module below
use Text::Ngrams;

# ./create-profile.pl n L profile_name
my $windowSize = 3;  # window size
my $onlyFirst = 50;   # number of most frequent n-grams
my $path = @ARGV[0]; # name of lyrics file to create new profile
my $emotion = @ARGV[1]; # name of emotion to to update profile
my $ng = "";
my $outText = "";
my @result1 = ();
my @result2 = ();
my $row1;
my $row2;
my %newProfile;
my $i;

# Create n-gram profile of input file
$ng = Text::Ngrams->new( windowsize => $windowSize, type => byte );
$ng->process_files($path);
$outText .= $ng->to_string( orderby => 'frequency', onlyfirst => $onlyFirst, normalize => 1, spartan => 1);

# Open file for writing
my $fileName = "";
if ($emotion eq "happy") { $fileName = "happy.txt"; }
if ($emotion eq "love") { $fileName = "love.txt"; }
if ($emotion eq "free") { $fileName = "free.txt"; }
if ($emotion eq "sad") { $fileName = "sad.txt"; }
if ($emotion eq "alive") { $fileName = "alive.txt"; }
if ($emotion eq "angry") { $fileName = "angry.txt"; }
if ($emotion eq "crazy") { $fileName = "crazy.txt"; }
if ($emotion eq "fear") { $fileName = "fear.txt"; }
if ($emotion eq "lonely") { $fileName = "lonely.txt"; }
if ($emotion eq "victorious") { $fileName = "victorious.txt"; }

open(my $fh, "<", $fileName) or die "couldn't open ", $profilename;

my $currProfile = "";

# Updates profile with 
while($row = <$fh>) {
  chomp $row;
  my @args = split("\t", $row);
  my $halfVal = $args[1]/2.0;
  $newProfile{@args[0]} = $halfVal;
}

# close file handle
close($fh) || die "couldn't close file properly";

# gets appropriate frequencies from the second profile
my @lines = split("\n", $outText);

foreach my $line(@lines) {
  my @args2 = split("\t", $line);
  my $halfVal = $args2[1]/2.0;
  
  if (exists $newProfile{@args2[0]}) {
    $newProfile{@args2[0]} = $newProfile{@args2[0]} + $halfVal;
  } else {
    $newProfile{@args2[0]} = $halfVal;
  }
}

open(my $fh1, ">", $fileName) or die "Couldn't open ", $fileName;

my $count = 0; 
foreach my $key (sort { $newProfile{$b} cmp $newProfile{$a} } keys %newProfile) {
  print $fh1 ($key . "\t" . $newProfile{$key} . "\n");
  if ($count == 49) {
    last;
  }
  $count = $count + 1;
}

# Close file handle
close($fh1) || die "Couldn't close file properly";

