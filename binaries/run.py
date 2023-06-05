import os

path = "../big.txt"

commands = {
    "CPython": f"python3 wc.py {path}",
    "Lua": f"lua wc.lua {path}",
    "LuaJIT": f"luajit wcjit.lua {path}",
    "Raku": f"raku wc.raku {path}",
    "Factor": f"./wc-factor {path}",
    "Racket Interpreted": f"racket ../wc.rkt {path}",
    "Racket Compiled": f"./wc-rkt {path}",
    "Clojure": f"clj wc.clj {path}",
    "Clojure Babashka": f"bb wc.clj {path}",
    "Flix": f"java -jar flix.jar {path}",
    "Haskell": f"./wc-hs {path}",
    "C#": f"../cswc/cswc/bin/Release/net7.0/cswc {path}",
    "Go": f"./wc-go {path}",
    "Haxe": f"../hxwc/Wc {path}",
    "Haxe Python": f"python3 hxpy-wc.py {path}",
    "Crystal": f"./wc-cr {path}",
    "D LDC": f"./wc-d {path}",
    "Nim": f"./wc-nim {path}",
    "Pascal": f"./wc-pascal {path}",
}

# todo: also hyperfine --input for stdin
print('hyperfine --export-csv timings.csv -w 10 {}'.format(
    ' '.join(f"'{cmd}'" for cmd in commands.values())
))
