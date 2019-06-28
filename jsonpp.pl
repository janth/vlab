#!/usr/bin/perl

# Weeds out comments from json file
# alternartives: 
# * pip install commentjson
#   https://commentjson.readthedocs.io/en/latest/
#
# * jq
#   https://stedolan.github.io/jq/

my $in_multi = 0;
while (<>) {
   if (m/^\s*\/\*/) {
      $in_multi++;
      next;
   }
   if (m/^\s*\*\//) {
      $in_multi--;
      next;
   }
   next if ($in_multi);
   next if (m/^#/);
   next if (m/^\/\//);
   next if (m/^\s*$/); # Skip empty lines

   s/#.*$//; # Strip trailing comments
   #s/\/\/.*$//; # Strip trailing comments
   s/\ +$//; # Strip trailing blanks
   print
}
