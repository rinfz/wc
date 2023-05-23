use v6;

multi sub MAIN(
    $file = Nil,
    Bool :c($bytes) = False,
    Bool :l($lines) = False,
    Bool :m($chars) = False,
    Bool :w($words) = False,
) {
    my $all = !($bytes || $lines || $chars || $words);

    my $bin_mode = $all || $bytes;
    my $raw_contents = $file ?? $file.IO.slurp(bin => $bin_mode) !! slurp(bin => $bin_mode);
    my $contents = $bin_mode ?? $raw_contents.decode !! $raw_contents;
    my @result = [];

    if ($all || $lines || $words) {
        my $in_lines = $contents.lines;
        @result.push: $in_lines.elems if $lines || $all;
        @result.push: $in_lines.map({ .words }).sum if $words || $all;
    }

    @result.push: $raw_contents.bytes if $bytes || $all;
    @result.push: $contents.chars if $chars;

    print "\t", @result.join("\t");
    if ($file) {
        say " ", $file;
    } else {
        say();
    }
}
