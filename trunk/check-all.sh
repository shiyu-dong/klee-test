#!/bin/bash
PROGRAMS="base64 basename chcon cksum comm cut dd dircolors dirname \
du env expand expr fold groups link logname mkdir mkfifo mknod nice nl \
od paste pathchk printf readlink rmdir setuidgid sleep split sum \
sync tee touch tr tsort unexpand unlink wc"

MUTATION="base64 basename chcon chgrp cksum comm cut dd dircolors dirname \
du env expand expr fold groups link logname mkdir mkfifo mknod nice nl \
od paste pathchk printf readlink rmdir setuidgid sleep split sum \
sync tee touch tr tsort unexpand unlink wc"

SOLVER="[ base64 chmod comm csplit dircolors echo env factor join ln mkfifo"

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
