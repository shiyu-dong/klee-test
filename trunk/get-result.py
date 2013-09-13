#!/usr/bin/python
import re
import sys

# read on target log
fo = open("output.txt","r")

while True:
  # extract message from the on target log to log
  line = fo.readline()
  if len(line) == 0:
    break;
  elif line.find("==========") != -1:
    while True:
      sys.stdout.write(line)
      line = fo.readline()
      if line.find("=========") == -1:
        sys.stdout.write(line)
        break

  elif line.find("KLEE: done") != -1:
    sys.stdout.write(line)

  elif line.find("----------") != -1:
    sys.stdout.write(line)
    line = fo.readline()
    sys.stdout.write(line)
    line = fo.readline()
    sys.stdout.write(line)
    line = fo.readline()
    sys.stdout.write(line)
    line = fo.readline()
    sys.stdout.write(line)
fo.close()
