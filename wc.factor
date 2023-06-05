USING: command-line kernel namespaces sequences sequences.extras io io.files
       io.encodings.utf8 io.encodings.binary formatting locals vectors
       io.streams.byte-array io.streams.string unicode splitting math
       byte-arrays io.encodings.string io.encodings math.parser ;
IN: wc

! lwcm

: is-flag? ( str -- ? )
  first 45 = ;

: matches-flag? ( str x -- ? )
  swap dup is-flag? [ second ] when = ;

: any-flag? ( seq c -- ? )
  swap [ over matches-flag? ] any? swap drop ;

: has-flag? ( seq c ? -- ? )
  rot rot swap dup length 0 = [ 2drop ] [ swap any-flag? swap drop ] if ;

: words ( str -- x )
  "\r\n\t " split [ length 0 > ] filter length ;

:: count-stuff ( args bytes -- vector )
   bytes utf8 <byte-reader> stream-contents :> text
   3 <vector> :> result
   args CHAR: c t has-flag? :> has-c
   args CHAR: m f has-flag? :> has-m
   args CHAR: l t has-flag? :> has-l
   args CHAR: w t has-flag? :> has-w
   result has-l [ text <string-reader> stream-lines length suffix! ] when drop
   result has-w [ text words suffix! ] when drop
   result has-c has-m not and [ bytes length suffix! ] when drop
   result has-m [ text length suffix! ] when drop
   result ;

: wc-run ( -- )
  command-line get
  [ is-flag? ] partition
  dup length 0 =
         [ swap input-stream get stream-contents* utf8 encode ]
         [ dup swapd first binary file-contents ] if
         count-stuff
  [ number>string ] map "\t" join CHAR: \t prefix
  swap dup length 0 > [ first " " swap append append ] [ drop ] if
  print ;

MAIN: wc-run
