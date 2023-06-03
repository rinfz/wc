import sys.io.File;
import haxe.io.Bytes;

class Wc {
  static function getFilename(args: Array<String>): String {
    var filtered = args.filter(a -> a.charAt(0) != "-");
    if (filtered.length == 0) {
      return "";
    } else {
      return filtered[0];
    }
  }

  static public function main(): Void {
    var args = Sys.args();
    var hasL = args.contains("-l");
    var hasW = args.contains("-w");
    var hasC = args.contains("-c");
    var hasM = args.contains("-m");
    var needsAll = !(hasL || hasW || hasC || hasM);
    var filename = getFilename(args);

    var contents: Bytes;
    if (filename == "") {
      contents = Sys.stdin().readAll();
    } else {
      contents = File.getBytes(filename);
    }

    var text = contents.toString();
    var result = new Array<Int>();

    if (hasL || needsAll) {
      var re0 = ~/\n+$/;
      result.push(re0.replace(text, "").split("\n").length);
    }

    if (hasW || needsAll) {
      var re1 = ~/\s+/g;
      result.push(re1.split(StringTools.rtrim(text)).length);
    }

    if ((hasC && !hasM) || needsAll) {
      result.push(contents.length);
    }

    if (hasM) {
      result.push(text.length);
    }

    Sys.println("\t" + result.join("\t") + " " + filename);
  }
}