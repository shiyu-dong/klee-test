#!/usr/bin/python
import re
import sys
import os
import csv

#Solvers = ["stp", "z3", "btor"]
Solvers = ["stp"]
#Programs = ["base64","chmod","comm","csplit","dircolors","echo","env","factor","join","ln","mkfifo"]
Programs = ["base64", "basename", "chcon", "chgrp", "cksum", "comm", "cut","dd","dircolors","dirname", \
    "du", "env", "expand", "expr", "fold", "groups", "link", "logname", "mkdir", "mkfifo", "mknod", "nice", "nl", \
    "od", "paste", "pathchk", "printf", "readlink", "rmdir", "setuidgid", "sleep", "split", "sum", \
    "sync", "tee", "touch", "tr", "tsort", "unexpand", "unlink", "wc"]

if not os.path.exists("csv"):
  os.makedirs("csv")

result_lcov = []
result_bcov = []
for program in Programs:
  for solver in Solvers:
    temp_lcov = []
    temp_lcov.append(program)
    temp_lcov.append(solver)
    temp_bcov = []
    temp_bcov.append(program)
    temp_bcov.append(solver)
    temp_opt_name = []
    temp_opt_name.append("Program")
    temp_opt_name.append("Solver")
    fo = open("test_result_new/result_"+program+"_"+solver+".txt", "r")
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
          while True:
            line = fo.readline()
            #sys.stdout.write(line)
            if line.find("=========") != -1:
              break
            elif line.find("optimiz") != -1:
              if line.find("no optimization") != -1:
                opt = "NoOptimization"
                #print opt
              elif line.find("only --optimize, no --opt-flag") != -1:
                opt = "OptimizeOnly"
                #print opt
              elif line.find("original optimization") != -1:
                opt = "OriginalOptimization"
                #print opt
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

        elif line.find("File") != -1 and line.find(program) != -1:
          line = fo.readline()
          if line.find("Lines executed") != -1:
            line_coverage = re.split(':|%', line)[1]
            #print line_coverage
            line = fo.readline()
            if line.find("Branches executed") != -1:
              branch_coverage = re.split(':|%', line)[1]
              #print branch_coverage
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
        temp_lcov.append(line_coverage)
        temp_bcov.append(branch_coverage)
        temp_opt_name.append(opt)
        #result_lcov.append([opt, time, line_coverage, branch_coverage, taken_at_least_once, calls_executed])
    result_lcov.append(temp_lcov)
    result_bcov.append(temp_bcov)
    #print result_lcov
    #print result_bcov

result_lcov.insert(0, temp_opt_name)
result_bcov.insert(0, temp_opt_name)
fw = open("csv/lcov.csv", "wb")
wr = csv.writer(fw, quoting=csv.QUOTE_ALL)
for i in result_lcov:
  wr.writerow(i)
fw.close()
fw = open("csv/bcov.csv", "wb")
wr = csv.writer(fw, quoting=csv.QUOTE_ALL)
for i in result_bcov:
  wr.writerow(i)
fw.close()

fo.close()
