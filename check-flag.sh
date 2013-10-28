#!/bin/bash
#PROGRAMS="base64 cat chcon chgrp chown cksum comm cut date df dircolors dirname du factor fold mknod tr pr seq uname"
# always 100%: basename dirname
# always the same: echo readlink
#PROGRAMS="base64 cat chcon chgrp chown cksum comm cut date df dircolors dirname du factor fold mknod pr seq tr uname"
PROGRAMS="env factor chroot date fold expand csplit join head"

if [ "$1" == "--clean" ]
then
  ./compare-optimization.sh --clean
else
  if [ ! -d "test_result" ]; then
    mkdir test_result
  fi
  for program in $PROGRAMS
  do
    ./compare-flag.sh $program &> test_result/result_$program.txt
  done
fi
