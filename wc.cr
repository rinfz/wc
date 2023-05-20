enum Mode
  Cmd
  All
  Stdin
end

mode = nil
args = ARGV

command = nil
filename = nil

if args.size == 1 && ["-c", "-l", "-w", "-m"].includes?(args[0])
  mode = Mode::Stdin
  command = args[0]
elsif args.size == 1
  mode = Mode::All
  filename = args[0]
elsif args.size == 2
  mode = Mode::Cmd
  command, filename = args
else
  mode = Mode::All
end

if filename.nil?
  contents = STDIN.gets_to_end
else
  contents = File.read(filename)
end

result = [] of Int64
lines : Array(String)?

if mode.all? || command == "-l" || command == "-w"
  lines = contents.lines
end

if !lines.nil?
  if mode.all? || command == "-l"
    result.push lines.size
  end

  if mode.all? || command == "-w"
    words_per_line = lines.map do |line|
      line.strip.split.size
    end
    result.push words_per_line.sum
  end
end

if mode.all? || command == "-c"
  result.push contents.to_slice.size
end

if command == "-m"
  result.push contents.size
end

if result.empty?
  raise "Unknown Command"
end

print "\t", result.join("\t"), " ", filename, "\n"
