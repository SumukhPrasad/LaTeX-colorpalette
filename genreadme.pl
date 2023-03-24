use strict; use warnings;

open my $styfh, '<', 'colorpalette.sty' or die "Whoops!";
my $styfile = do { local $/; <$styfh> };
my @matches;
push @matches, "- ![#$2](https://placehold.co/15x15/#$2/#$2.png) `#$2` $1" while ( $styfile =~ /definecolor\{(.+)\}\{(?:.+)\}\{(.+)\}/g );
my $count = @matches;
print "Found " . $count . " colours.\n";
close($styfile);

print "Generating README.md...\n\n";
open my $rmtemplatefh, '<', 'README.md-template' or die "Whoops!";
my $rmtemplatefile = do { local $/; <$rmtemplatefh> };
my $filledrmtemplate = $rmtemplatefile =~ s/{CNUM}/$count/r;
$filledrmtemplate = $filledrmtemplate =~ s/{LST}/${\join("\n", @matches)}/r;
print $filledrmtemplate . "\n";
close($rmtemplatefile);

open my $rmfh, '+<', 'README.md' or die "Whoops!";
my $rmfile = do { local $/; <$rmfh> };
seek($rmfh, 0, 0);
print $rmfh $filledrmtemplate;
truncate($rmfile, tell($rmfh));
close($rmfile);

print "Done.\n"