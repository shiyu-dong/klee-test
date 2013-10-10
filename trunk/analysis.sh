#!/bin/bash
#PROGRAMS="seq echo fold chgrp chown readlink uname"
PROGRAMS="base64 cat chcon comm date df dircolors dirname factor mknod tr pr cut chgrp chown echo fold readlink seq uname"
for program in $PROGRAMS
do
  ./get-result.py test_result_new/result_$program.txt
done
