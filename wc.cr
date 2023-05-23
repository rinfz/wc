require "option_parser"

def get_contents(filename : String | Nil)
  if filename.nil?
    STDIN.gets_to_end
  else
    File.read(filename)
  end
end

filename = nil
flag_words = false
flag_lines = false
flag_bytes = false
flag_chars = false

parser = OptionParser.parse do |parser|
  parser.banner = "Usage: wc [-clmw] [file]"
  parser.on("-l", "Count lines") { flag_lines = true }
  parser.on("-w", "Count words") { flag_words = true }
  parser.on("-c", "Count bytes") { flag_bytes = true }
  parser.on("-m", "Count characters") do
    flag_bytes = false
    flag_chars = true
  end
  parser.unknown_args do |args, _|
    if args.size > 0
      filename = args[0]
    end
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

contents = get_contents(filename)

# if no args provided, set default behaviour
if !flag_words && !flag_lines && !flag_bytes && !flag_chars
  flag_words = true
  flag_lines = true
  flag_bytes = true
end

result = [] of Int64

if flag_lines
  result << contents.lines.size
end

if flag_words
  result << contents.split.size
end

if flag_bytes
  result << contents.to_slice.size
end

if flag_chars
  result << contents.size
end

print "\t", result.join("\t"), " ", filename, "\n"
