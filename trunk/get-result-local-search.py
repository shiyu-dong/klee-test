#!/usr/bin/python
import re
import sys
import os
import csv

# read on target log
fo = open(sys.argv[1],"r")
name = re.split('_|\.', sys.argv[1])[3]

if not os.path.exists("csv"):
  os.makedirs("csv")
fw = open("csv/"+name+".csv", "wb")
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
  line_coverage = ""
  branch_coverage = ""
  taken_at_least_once = ""
  calls_executed = ""

  while True:
    if len(line) == 0:
      break
    if line.find("==========") != -1:
      # Oswaldo: Changed
      # sys.stdout.write("==============================================")
      while True:
        line = fo.readline()
        #sys.stdout.write(line)
        #print line
        if line.find("=========") != -1:
          break
        elif line.find("optimiz") != -1:
          if line.find("no optimization") != -1:
            opt = "NoOptimization"
            print opt
          elif line.find("only --optimize, no --opt-flag") != -1:
            opt = "OptimizeOnly"
            print opt
          elif line.find("original optimization") != -1:
            opt = "OriginalOptimization"
            print opt
          else:
            opt = line.split()[3]
            # sys.stdout.write(opt)
            #print opt
        else:
          pass
          # sys.stdout.write("ERROR! Expetcting optimization name.")

    elif line.find("KLEE: done") != -1:
      #sys.stdout.write(line)
      if line.find("completed paths") != -1:
        for token in line.split():
          if token.isdigit():
            pathNum = int(token)
            break

    elif line.find("----------") != -1 and line.find("===-") == -1:
      #sys.stdout.write(line)
      row = 0
      while True:
        line = fo.readline()
        row += 1
        #sys.stdout.write(line)
        #print line
        if line.find("---------") != -1 and row >= 4:
          # sys.stdout.write("\n")
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
        line_coverage = re.split(':|%', line)[1]
        line = fo.readline()
        if line.find("Branches executed") != -1:
          branch_coverage = re.split(':|%', line)[1]
          line = fo.readline()
          if line.find("Taken at least once") != -1:
            taken_at_least_once = re.split(':|%', line)[1]
          line = fo.readline()
          if line.find("Calls executed") != -1:
            calls_executed = re.split(':|%', line)[1]
          break;
        else:
          break
      else:
        continue
    line = fo.readline()

  if len(opt) > 0:
    result.append([opt, time, line_coverage, branch_coverage, taken_at_least_once, calls_executed])
for i in result:
  #print i
  wr.writerow(i)

fo.close()
