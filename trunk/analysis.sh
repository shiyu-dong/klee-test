#!/bin/bash
#PROGRAMS="base64 cat chcon chgrp chown cksum comm cut date df dircolors dirname du factor fold mknod pr seq tr uname"
#PROGRAMS="env factor chroot date fold expand csplit join head"
PROGRAMS="csplit date expand factor fold join tr seq pr mknod"

for program in $PROGRAMS
do
  ./get-result.py test_result_new/result_$program.txt
done
