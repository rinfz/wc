import java.nio.charset.Charset

use GetOpt.{OptionDescr, ArgDescr}
use GetOpt.ArgDescr.NoArg
use GetOpt.ArgOrder.{Permute}
use GetOpt.{getOpt, usageInfo}

enum Flag with ToString, Eq {
  case Bytes
  case Lines
  case Characters
  case Words
}

def options(): List[OptionDescr[Flag]] =
     {optionIds = 'c' :: Nil, optionNames = "bytes" :: Nil, argDescriptor = NoArg(Flag.Bytes), explanation = "count bytes"}
  :: {optionIds = 'l' :: Nil, optionNames = "lines" :: Nil, argDescriptor = NoArg(Flag.Lines), explanation = "count lines"}
  :: {optionIds = 'm' :: Nil, optionNames = "characters" :: Nil, argDescriptor = NoArg(Flag.Characters), explanation = "count characters"}
  :: {optionIds = 'w' :: Nil, optionNames = "words" :: Nil, argDescriptor = NoArg(Flag.Words), explanation = "count words"}
  :: Nil

def encode(bytes: Array[Int8, r]): String \ IO =
  import static get java.nio.charset.StandardCharsets.UTF_8: Charset as csUtf8;
  import new java.lang.String(Array[Int8, r], Charset): ##java.lang.String as newByteString;
  newByteString(bytes, csUtf8())

def gatherStats(opts: List[Flag], bytes: Array[Int8, r]): List[Int32] \ IO =
  // lines, words, bytes, chars
  let needsAll = List.length(opts) == 0;
  let needsEncode = needsAll or List.exists(x -> x != Flag.Bytes, opts);
  let encoded = if (needsEncode) Some(encode(bytes)) else None;
  let l = lazy (encoded |> Option.map(String.lines >> List.length));
  let w = lazy (encoded |> Option.map(String.words >> List.length));
  let c = lazy (bytes   |> Array.length |> Some);
  let m = lazy (encoded |> Option.map(String.length));
  let result = foreach (
    (f, v) <- List#{(Flag.Lines, l), (Flag.Words, w), (Flag.Bytes, c), (Flag.Characters, m)};
    if List.memberOf(f, opts) or needsAll
  )
    yield force v;
  result |> List.filterMap(identity)

def processOpts(opts: List[Flag]): List[Flag] =
  if (List.length(opts) == 0)
    List#{Flag.Lines, Flag.Words, Flag.Bytes}
  else if (List.memberOf(Flag.Bytes, opts) and List.memberOf(Flag.Characters, opts))
    opts |> List.filter(x -> x != Flag.Bytes)
  else
    opts

def readStdin(_rc: Region[r]): Array[Int8, r] \ IO =
  import static get java.lang.System.in: ##java.io.InputStream \ IO as getSystemIn;
  import java.io.InputStream.readAllBytes(): Array[Int8, r] \ IO as readAllBytes;
  getSystemIn() |> readAllBytes

def main(): Unit \ IO =
  let args = Environment.getArgs();
  let cliOpts = GetOpt.preprocess({quoteOpen = "'", quoteClose = "'", stripQuoteMarks = true}, args);
  let header = "Usage: wc [-clmw] file";
  let options1 = options();
  match getOpt(Permute, options1, cliOpts) {
    case Validation.Success(opts) => {
      let processedOpts = opts.options |> processOpts;
      region rc {
        let statsFn = gatherStats(processedOpts);
        match List.head(opts.nonOptions) {
          case Some(filename) => {
            match File.readBytes(rc, filename) {
              case Ok(bytes) => {
                System.StdOut.print("\t");
                System.StdOut.print(bytes |> statsFn |> List.join("\t"));
                println(" ${filename}")
              }
              case Err(err) => println("Could not read file: ${err}")
            }
          }
          case None => {
            System.StdOut.print("\t");
            println(readStdin(rc) |> statsFn |> List.join("\t"))
          }
        }
      }
    }
    case Validation.Failure(errs) => {
      println(usageInfo(header, options1));
      println("Errors: ${errs}")
    }
  }
