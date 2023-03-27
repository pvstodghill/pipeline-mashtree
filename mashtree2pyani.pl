#! /usr/bin/env perl

use strict;
use feature 'postderef';
use warnings FATAL => 'all';
no warnings "experimental::postderef";
#use Carp::Always;

# use FindBin;
# use lib "$FindBin::Bin";
# use Xyzzy;

use constant { TRUE => 1, FALSE => 0 };

# 'wide character' warning.
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $n = 0;
while (<STDIN>) {
  $n++;
  if ($n == 1) {
    print;
    next;
  }

  chomp;
  my @fields = split(/\t/);
  for (my $j=1; $j<=$#fields; $j++) {
    my $score = $fields[$j];
    if ($score eq "" || $score > .4) {
      $score = .4;
    }
    $score = 100.0 * (1.0 - $score);
    $fields[$j] = $score;
  }
  print join("\t",@fields),"\n";
}
