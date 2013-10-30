#!/bin/bash
PROGRAMS="env factor chroot date fold expand csplit join head"

if [ "$1" == "--clean" ]
then
  ./compare-original.sh --clean
else
  if [ ! -d "test_result" ]; then
    mkdir test_result
  fi
  for program in $PROGRAMS
  do
    ./compare-original.sh $program &> test_result/result_$program.txt
    ./compare-flag.sh $program &> test_result/result_$program.txt
  done
fi
