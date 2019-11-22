#!/usr/bin/python

import sys, json;
import argparse;

parser = argparse.ArgumentParser(description='Parse list of installed files by meson/ninja.')
parser.add_argument('--keys', action='store_true')
parser.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin)
parser.add_argument('outfile', nargs='?', type=argparse.FileType('w'), default=sys.stdout)
args = parser.parse_args()

obj = json.load(args.infile)
files = []

if args.keys:
    files = list(obj.keys())
else:
    files = list(obj.values())

print('\n'.join(files), file=args.outfile)
