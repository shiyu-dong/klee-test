#!/bin/bash
PROGRAMS="base64 basename date df touch"
for program in $PROGRAMS
do
  ./get-result.py test_result_saved/result_$program.txt
done
