enum Mode {
  Cmd,
  All,
  Stdin,
  Unknown,
}

void main(string[] args) {
  import std.stdio : writeln, stdin;
  import std.file : readText;
  import std.array : join;
  import std.conv : to;
  import std.string : splitLines, stripRight, split;
  import std.range.primitives : walkLength;
  import std.algorithm.iteration : map, sum;
  import std.algorithm.searching : canFind;

  Mode mode = Mode.Unknown;
  string command;
  string filename = "";

  if (args.length == 2 && ["-c", "-l", "-w", "-m"].canFind(args[1])) {
    mode = Mode.Stdin;
    command = args[1];
  } else if (args.length == 2) {
    mode = Mode.All;
    filename = args[1];
  } else if (args.length == 3) {
    mode = Mode.Cmd;
    command = args[1];
    filename = args[2];
  } else {
    mode = Mode.All;
  }

  string contents;
  if (filename == "") {
    contents = cast(string) stdin.byChunk(1024*1024).join;
  } else {
    contents = filename.readText;
  }

  ulong[] result;
  string[] lines;

  if (mode == Mode.All || command == "-l" || command == "-w") {
    lines = contents.splitLines;
  }

  if (mode == Mode.All || command == "-l") {
    result ~= lines.length;
  }

  if (mode == Mode.All || command == "-w") {
    result ~= lines.map!(l => l.stripRight.split.length).sum;
  }

  if (mode == Mode.All || command == "-c") {
    result ~= contents.length;
  }

  if (command == "-m") {
    result ~= contents.walkLength;
  }

  writeln("\t", result.map!(a => a.to!string).join("\t"), " ", filename);
}
