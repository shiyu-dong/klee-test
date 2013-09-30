#!/usr/bin/python
import re
import sys
import os
import csv

# read on target log
fo = open(sys.argv[1],"r")
name = re.split('_|\.', sys.argv[1])[3]

if not os.path.exists("test_result_saved/csv"):
  os.makedirs("test_result_saved/csv")
fw = open("test_result_saved/csv/"+name+".csv", "wb")
wr = csv.writer(fw, quoting=csv.QUOTE_ALL)
result = []

while True:

  line = fo.readline()
  if len(line) == 0:
    break

  opt = ""
  pathNum = 0
  time = ""
  query = ""
  coverage = ""

  while True:
    if len(line) == 0:
      break
    if line.find("==========") != -1:
      sys.stdout.write(line)
      while True:
        line = fo.readline()
        sys.stdout.write(line)
        if line.find("=========") != -1:
          break
        elif line.find("optimiz") != -1:
          if line.find("no optimization") != -1:
            opt = "NoOptimization"
            print opt
          elif line.find("only --optimize, no --opt-flag") != -1:
            opt = "OptimizeOnly"
            print opt
          else:
            opt = line.split()[3]
            print opt
        else:
          sys.stdout.write("ERROR! Expetcting optimization name.")

    elif line.find("KLEE: done") != -1:
      sys.stdout.write(line)
      if line.find("completed paths") != -1:
        for token in line.split():
          if token.isdigit():
            pathNum = int(token)
            break

    elif line.find("----------") != -1:
      sys.stdout.write(line)
      row = 0
      while True:
        line = fo.readline()
        row += 1
        sys.stdout.write(line)
        if line.find("---------") != -1 and row >= 4:
          sys.stdout.write("\n")
          break
        elif line.find("klee-last") != -1 and row == 3:
          info = line.split()
          time = info[5]
          query = info[27]
        else:
          pass

    elif line.find("File") != -1 and line.find(name) != -1:
      line = fo.readline()
      if line.find("Lines executed") != -1:
        coverage = re.split(':|%', line)[1]
        break
      else:
        continue
    line = fo.readline()

  if len(opt) > 0:
    result.append([opt, pathNum, coverage, time, query])
for i in result:
  print i
  wr.writerow(i)

fo.close()
