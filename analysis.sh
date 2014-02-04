#!/bin/bash
PROGRAMS="base64 basename chcon cksum comm cut dd dircolors dirname \
du env expand expr fold groups link logname mkdir mkfifo mknod nice nl \
od paste pathchk printf readlink rmdir setuidgid sleep split sum \
sync tee touch tr tsort unexpand unlink wc"


for program in $PROGRAMS
do
  ./get-result-local-search.py test_result_new/result_$program.txt
done
