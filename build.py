import os

output_dir = "binaries"

def copy_file(name):
    os.system(f"cp {name} {output_dir}/")

copy_file("wc.py")
copy_file("wc.lua")
copy_file("wc.raku")
copy_file("wc-factor")
copy_file("wc.clj")

os.system(f"raco exe -o {output_dir}/wc-rkt wc.rkt")

os.system(f"cp flix/artifact/flix.jar {output_dir}")

os.system(f"ghc -O -o {output_dir}/wc-hs wc.hs")

os.system(f"go build -o {output_dir}/wc-go wc.go")

os.system(f"haxe --main Wc --cpp hxwc")
os.system(f"haxe --main Wc --python {output_dir}/hxpy-wc.py")

os.system(f"crystal build --release -o {output_dir}/wc-cr wc.cr")

os.system(f"~/dlang/ldc-1.32.2/bin/ldc2 -O2 --of={output_dir}/wc-d wc.d")

os.system(f"nim c -d:release -o:{output_dir}/wc-nim wc.nim")

# pascal needs lazarus
