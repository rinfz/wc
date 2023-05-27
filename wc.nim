import std/[parseopt, strutils, strformat]
from std/unicode import runeLen

var
  filename = ""
  allOpt = false
  hasL = false
  hasM = false
  hasC = false
  hasW = false

var args = initOptParser()
for kind, key, val in args.getopt():
  case kind
  of cmdArgument: filename = key
  of cmdShortOption:
    case key
    of "l": hasL = true
    of "m": hasM = true
    of "c": hasC = true
    of "w": hasW = true
  of cmdLongOption, cmdEnd: discard

if not (hasL or hasM or hasC or hasW):
  allOpt = true

var text: string
if filename == "":
  text = stdin.readAll()
else:
  var f = filename.open()
  text = f.readAll()
  f.close()

var result = newSeq[int]()

if hasW or allOpt:
  result.add text.splitWhitespace.len

if (hasC and not hasM) or allOpt:
  result.add text.len

if hasM:
  result.add text.runeLen

if hasL or allOpt:
  text.stripLineEnd
  result.insert(text.countLines, 0)

echo "\t", result.join("\t"), &" {filename}"
