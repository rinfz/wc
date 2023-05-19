enum Mode
  Cmd
  All
  Stdin
  Unknown
end

mode = Mode::Unknown
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

if mode.all? || command == "-l"
  result.push contents.lines.size
end

if mode.all? || command == "-w"
  words_per_line = contents.lines.map do |line|
    line.strip.split.size
  end
  result.push words_per_line.sum
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
