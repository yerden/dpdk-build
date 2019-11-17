#!/usr/bin/python

import sys, json;
import os.path;

files = list(json.load(sys.stdin).values())

dirs = {}
for path in files:
    dirs[os.path.dirname(path)] = 1

print ('\n'.join(dirs.keys()))
