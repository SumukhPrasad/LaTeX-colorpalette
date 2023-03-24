use strict; use warnings;

open my $styfh, '<', 'colorpalette.sty' or die "Whoops!";
my $styfile = do { local $/; <$styfh> };

package glbl; # temporarily step into MyPackage
our $finishedlist;
our @sections;
package main;

push @glbl::sections, [$1, $2] while ( $styfile =~ /% SECTION (.+) \{((.|\n)+?)% \}/g );

for my $i (0 .. $#glbl::sections) {
     $glbl::finishedlist = $glbl::finishedlist . "## $sections[$i][0]\n";
     my @matches;
     push @matches, "![#$2](https://placehold.co/15x15/$2/$2.png) `#$2` $1" while ( $glbl::sections[$i][1] =~ /definecolor\{(.+)\}\{(?:.+)\}\{(.+)\}/g );
     while (@matches) {
          $glbl::finishedlist = $glbl::finishedlist . "| " . (join " | ", splice(@matches, 0, 4)) . " |\n";
     };
     $glbl::finishedlist = $glbl::finishedlist . "\n\n";
};;

print "Generating README.md...\n\n";
open my $rmtemplatefh, '<', 'README.md-template' or die "Whoops!";
my $rmtemplatefile = do { local $/; <$rmtemplatefh> };
my $filledrmtemplate = $rmtemplatefile =~ s/{LST}/$glbl::finishedlist/r;
print $filledrmtemplate . "\n";
close($rmtemplatefile);

open my $rmfh, '+<', 'README.md' or die "Whoops!";
my $rmfile = do { local $/; <$rmfh> };
seek($rmfh, 0, 0);
print $rmfh $filledrmtemplate;
truncate($rmfh, length($filledrmtemplate));
close($rmfile);

print "Done.\n";