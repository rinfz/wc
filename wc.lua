function contents_stdin()
   local buf = ""
   while true do
      local block = io.stdin:read(16*1024)
      if not block then break end
      buf = buf .. block
   end
   return buf
end

function contents_file(fname)
   local handle = io.open(fname, "rb")
   local result = handle:read "*a"
   handle:close()
   return result
end

function values(o)
   local result = {}
   for _, v in pairs(o) do
      result[v] = 1
   end
   return result
end

function get_filename(args)
   for k, _ in pairs(args) do
      if string.sub(k, 1, 1) ~= "-" then
         return k
      end
   end
   return ""
end

function check_arg(args, flag)
   return args[flag] ~= nil
end

function split(s, sep)
   local result = {}
   for part in string.gmatch(contents, sep) do
      table.insert(result, part)
   end
   return result
end

-- remove table. for luajit
new_args = values({table.unpack(arg, 1, #arg)})
has_c = check_arg(new_args, "-c")
has_l = check_arg(new_args, "-l")
has_m = check_arg(new_args, "-m")
has_w = check_arg(new_args, "-w")
needs_all = not (has_c or has_l or has_m or has_w)

filename = get_filename(new_args)

if filename == "" then
   contents = contents_stdin()
else
   contents = contents_file(filename)
end

result = {}
if has_l or needs_all then
   table.insert(result, #split(contents, "\n"))
end

if has_w or needs_all then
   table.insert(result, #split(contents, "%s+"))
end

if (has_c and not has_m) or needs_all then
   table.insert(result, #contents)
end

if has_m then
   table.insert(result, utf8.len(contents))
end

for k, v in pairs(result) do
   io.write("\t")
   io.write(v)
end

io.write(string.format(" %s\n", filename))
