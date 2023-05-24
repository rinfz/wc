import Data.List
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.ByteString as BS
import System.Environment
import System.Exit
import System.Console.GetOpt
import System.IO

data Flag = Lines | Words | Bytes | Chars
  deriving (Eq, Ord, Enum, Show, Bounded)

flags :: [OptDescr Flag]
flags = [ Option ['c'] [] (NoArg Bytes) "count bytes"
        , Option ['m'] [] (NoArg Chars) "count chars"
        , Option ['w'] [] (NoArg Words) "count words"
        , Option ['l'] [] (NoArg Lines) "count lines"
        ]

gatherFlags :: [Flag] -> [Flag]
gatherFlags args
  | null args = [Lines, Words, Bytes]
  | Bytes `elem` args && Chars `elem` args = filter (\f -> f /= Bytes) args
  | otherwise = args

parse :: [String] -> IO ([Flag], [String])
parse argv = case getOpt Permute flags argv of
  (args, fs, []) -> do
    let files = if null fs then [] else fs
    return (gatherFlags args, files)
  (_,_,errs) -> do
    hPutStrLn stderr (concat errs ++ usageInfo header flags)
    exitWith (ExitFailure 1)
  where header = "Usage: wc [-clmw] file"

readInput :: [String] -> IO BS.ByteString
readInput [] = BS.getContents
readInput files = BS.readFile $ head files

countStuff :: Flag -> BS.ByteString -> T.Text -> Int
countStuff Chars _ = T.length
countStuff Lines _ = length . T.lines
countStuff Words _ = length . T.words
countStuff Bytes s = const $ BS.length s

needsDecode :: [Flag] -> Bool
needsDecode = any (/= Bytes)

-- lwcm
main :: IO ()
main = do
  (args, files) <- getArgs >>= parse
  contents <- readInput files
  let text = if needsDecode args
        then T.decodeUtf8 contents
        else T.empty
  let result = [ countStuff f contents text | f <- sort args]
  putStr $ "\t" ++ (intercalate "\t" $ map show result)
  if not $ null files
    then putStrLn $ " " ++ head files
    else putStrLn ""
