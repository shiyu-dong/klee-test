#!/bin/bash
#PROGRAMS="csplit date expand factor fold join tr seq pr mknod"
PROGRAMS="csplit"

if [ "$1" == "--clean" ]
then
  ./compare-all.sh --clean
else
  if [ ! -d "test_result_new" ]; then
    mkdir test_result_new
  fi
  for program in $PROGRAMS
  do
    ./compare-all.sh $program &> test_result_new/result_$program.txt
  done
fi
