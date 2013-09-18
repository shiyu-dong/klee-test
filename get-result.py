#!/usr/bin/python
import re
import sys

# read on target log
fo = open(sys.argv[1],"r")

while True:
  # extract message from the on target log to log
  line = fo.readline()
  if len(line) == 0:
    break;

  elif line.find("==========") != -1:
    sys.stdout.write(line)
    while True:
      line = fo.readline()
      sys.stdout.write(line)
      if line.find("=========") != -1:
        break

  elif line.find("KLEE: done") != -1:
    sys.stdout.write(line)

  elif line.find("----------") != -1:
    sys.stdout.write(line)
    row = 0
    while True:
      line = fo.readline()
      if line.find("---------") != -1 and row >= 2:
        sys.stdout.write(line)
        sys.stdout.write("\n")
        break
      else:
        sys.stdout.write(line)
        row += 1

fo.close()
