using System.Text;
using System.Text.RegularExpressions;

bool CheckFlag(string[] args, string flag)
{
    return args.Contains(flag);
}

string Filename(string[] args)
{
    return args.Where(arg => !arg.StartsWith("-")).FirstOrDefault("");
}

var filename = Filename(args);
var hasC = CheckFlag(args, "-c");
var hasL = CheckFlag(args, "-l");
var hasW = CheckFlag(args, "-w");
var hasM = CheckFlag(args, "-m");
var needsAll = !(hasC || hasL || hasW || hasM);

byte[] contents;

if (string.IsNullOrEmpty(filename))
{
    using var stdin = Console.OpenStandardInput();
    using var stream = new MemoryStream();

    int bytes;
    byte[] buffer = new byte[2048];
    while ((bytes = stdin.Read(buffer, 0, buffer.Length)) > 0)
    {
        stream.Write(buffer, 0, bytes);
    }

    contents = stream.ToArray();
}
else
{
    contents = File.ReadAllBytes(filename);
}

var text = ASCIIEncoding.UTF8.GetString(contents);

var result = new List<int>();

if (hasL || needsAll)
{
    result.Add(text.Split(new[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries).Length);
}

if (hasW || needsAll)
{
    result.Add(Regex.Split(text.TrimEnd(), @"\s+").Length);
}

if ((hasC && !hasM) || needsAll)
{
    result.Add(contents.Length);
}

if (hasM)
{
    result.Add(text.Length);
}

Console.WriteLine($"\t{string.Join("\t", result)} {filename}");