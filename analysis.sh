#!/bin/bash
PROGRAMS="seq echo fold chgrp chown readlink uname"
for program in $PROGRAMS
do
  ./get-result.py test_result_new/result_$program.txt
done
