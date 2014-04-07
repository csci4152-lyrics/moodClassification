#!/usr/bin/perl
# Creates an n-gram profile
# Based on the module below
use Text::Ngrams;
use List::MoreUtils qw(firstidx);

# ./algo.pl < input.txt
my $windowSize = 3;  # window size
my $onlyFirst = 50;   # number of most frequent n-grams
my @file_name = ("alive", "angry", "crazy", "fear", "free", "happy", "lonely", "love", "sad", "victorious");
my @related_degree = (0,0,0,0,0,0,0,0,0,0);
my $ng = "";
my $outText = "";
my $input = "";
my $count = 0; #count : index of file_name array
my $fh;
my $row;
my $path = "emotions-char/";
my @args;
my @ng_text;
my @ng_fre;
my $i = 0;
my $is_sentence = 0;
my $constant1 = 0.01 ;
my $constant2 = 0.005;
my $constant3 = 0.15;
my $index;
my $temp1;
my $sum = 0;

################################################
#create input profile
#################################################
#read from input text file 
while (<STDIN>) {
  $input .= $_;        # text file to read
  $i++;
}  
if ($i == 1) {
	$is_sentence = 1;
}
#print $is_sentence;
$i = 0;
# Create ngram from input
$ng = Text::Ngrams->new( windowsize => $windowSize, type => byte );
$ng->process_text($input);
$outText .= $ng->to_string( orderby => 'frequency', onlyfirst => $onlyFirst, normalize => 1, spartan => 1);
$i = 0;
my @lines = split("\n", $outText);
my @A_text = ();
my @A_fre = ();
my @temp = ();
foreach (@lines) {
	chomp $_;
	@temp = split("\t", $_);
	$A_text[$i] = $temp[0];
	$A_fre[$i] = $temp[1];
	$i++;
}

#print $A_text[1]. " " . $A_fre[1] . "\n";
#print $outText;

############################################
#scan through all mood profiles
###########################################
$count = 0;
while ($count < 10) {
	# Open mood profile to read
	open($fh, "<", $path.$file_name[$count].".txt") or die "Couldn't open ", $path.$file_name[$count].".txt";
	#read and store mood profile 
	$i = 0;
	while($row = <$fh>) {
		chomp $row;
		@args = split("\t", $row);
		$ng_text[$i] = $args[0];
		$ng_fre[$i] = $args[1];
		$i++;
	}
	# Close file handle
	close($fh) || die "Couldn't close file properly";
	
	#implement step 3 the algo here
	#print $ng_text[0]. " " . $ng_fre[0] . "\n";
	for ($i = 0; $i < scalar @A_text; $i++) {
		$index = firstidx { $_ eq $A_text[$i] } @ng_text;
		if ($is_sentence == 1) {
			if ($index != -1) {
				if ($ng_fre[$index] > $constant1) {
					$related_degree[$count]++;
				}
			}
		}
		else {
			if ($index != -1) {
				if (abs ($A_fre[$i] - $ng_fre[$index]) < $constant2  ) {
					$related_degree[$count]++;
				}
			}
			else {
				if ($A_fre[$i] < $constant2) {
					$related_degree[$count]++;
				}
			}
		}
	}
	$count++;
}
#############################
#step 4 algo
for ($count = 0; $count < 10; $count++) {
	$sum = $sum + $related_degree[$count];
}
for ($count = 0; $count < 10; $count++) {
	if (1.0*$related_degree[$count]/$sum > $constant3) {
		print $file_name[$count] . "\n";
	}
}




