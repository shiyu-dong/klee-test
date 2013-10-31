#!/bin/bash
PROGRAMS="csplit date expand factor fold join tr seq pr mknod"

if [ "$1" == "--clean" ]
then
  ./compare-all.sh --clean
else
  if [ ! -d "test_result" ]; then
    mkdir test_result
  fi
  for program in $PROGRAMS
  do
    ./compare-all.sh $program &> test_result/result_$program.txt
  done
fi
