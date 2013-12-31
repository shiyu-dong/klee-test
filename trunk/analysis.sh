#!/bin/bash
#PROGRAMS="base64 cat chcon chgrp chown cksum comm cut date df dircolors dirname du factor fold mknod pr seq tr uname"
#PROGRAMS="env factor chroot date fold expand csplit join head"
#PROGRAMS="csplit date expand factor fold join tr seq pr mknod"
#PROGRAMS="base64 cut dd du expand fold mknod tr tsort unexpand"
PROGRAMS="basename chcon cksum comm dircolors dirname env \
  expr groups link logname mkdir mkfifo nice nl wc unlink \
  touch tee sync sum split sleep setuidgid rmdir readlink \
  printf pathchk paste od"


for program in $PROGRAMS
do
  ./get-result-local-search.py test_result_new/result_$program.txt
done
