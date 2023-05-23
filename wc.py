import sys
import argparse

parser = argparse.ArgumentParser(prog='wc')
parser.add_argument('filename', nargs='?', default=None)
parser.add_argument('-c', action='store_true', dest='bytes')
parser.add_argument('-l', action='store_true', dest='lines')
parser.add_argument('-m', action='store_true', dest='chars')
parser.add_argument('-w', action='store_true', dest='words')

args = parser.parse_args()

if args.filename is None:
    contents = sys.stdin.buffer.read()
else:
    with open(args.filename, 'rb') as f:
        contents = f.read()

if args.chars:
    args.bytes = False

# if no args provided, set default behaviour
if all(not getattr(args, a) for a in ('bytes', 'lines', 'chars', 'words')):
    args.bytes = True
    args.words = True
    args.lines = True

text = None
result = []

if args.chars or args.words or args.lines:
    text = contents.decode('utf-8')

if args.lines:
    result.append(len(text.splitlines()))

if args.words:
    result.append(len(text.split()))

if args.bytes:
    result.append(len(contents))

if args.chars:
    result.append(len(text))

print('', *result, args.filename or '', sep='\t')
