#!/bin/bash
#PROGRAMS="csplit date expand factor fold join tr seq pr mknod"
PROGRAMS="base64 cut dd du expand fold mknod tr tsort unexpand \
  basename chcon cksum comm dircolors dirname env \
  expr groups link logname mkdir mkfifo nice nl wc unlink \
  touch tee sync sum split sleep setuidgid rmdir readlink \
  printf pathchk paste od"

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
