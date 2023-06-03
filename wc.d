import std;

bool hasFlag(string[] args, string flag) {
  return args.canFind(flag);
}

string getFilename(string[] args) {
  auto filtered = args.filter!(a => !a.startsWith("-")).array;
  if (filtered.length == 0) {
    return "";
  }
  return filtered.front();
}

void main(string[] args0) {
  auto args = args0[1..$];

  auto hasL = args.hasFlag("-l");
  auto hasW = args.hasFlag("-w");
  auto hasC = args.hasFlag("-c");
  auto hasM = args.hasFlag("-m");
  auto needsAll = !(hasL || hasW || hasC || hasM);
  auto filename = args.getFilename();

  string contents;
  if (filename == "") {
    contents = cast(string) stdin.byChunk(16*1024).join;
  } else {
    contents = filename.readText;
  }

  ulong[] result;
  if (hasL || needsAll) {
    result ~= contents.splitLines.length;
  }

  if (hasW || needsAll) {
    result ~= contents.split.length;
  }

  if ((hasC && !hasM) || needsAll) {
    result ~= contents.length;
  }

  if (hasM) {
    result ~= contents.walkLength;
  }

  writeln("\t", result.map!(a => a.to!string).join("\t"), " ", filename);
}
