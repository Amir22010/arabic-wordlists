#!/usr/bin/perl -CASD

# Extracts Arabic words and outputs them line-delimited in
# lexicographical order and as a frequency list into cwd
# install deps with `cpan List::Uniq Lingua::AR::Tashkeel`

use strict;
use warnings;
use List::Uniq 'uniq';
use Lingua::AR::Tashkeel v0.004 'strip';
use autodie ':all';

local $/; $, = "\n";
my ($filename, @words, %freq) = $ARGV[0] // 'stdin';
@words = split ' ', <> =~ s/[\P{InArabic}\p{Punct}\d]+?/ /gurx;
$freq{strip $_}++ foreach @words;
open my $fh, '>', "$filename.freqlist";
foreach my $word (sort { $freq{$b} <=> $freq{$a} } keys %freq) {
    print $fh "$word $freq{$word}\n";
}
open $fh, '>', "$filename.wordlist";
print $fh grep { length > 1 } uniq {
    sort => 1,
    compare => sub { strip(shift) cmp strip(shift) }
}, @words;