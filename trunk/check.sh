#PROGRAMS="base64 basename cat chcon chmod chown chroot cksum comm cp csplit cut \
#  date dd df dircolors dirname du echo env expand expr factor false fmt fold \
#  head hostid hostname id ginstall join kill link ln logname ls md5sum mkdir \
#  mkfifo mknod mktemp mv nice nl nohup od paste pathchk pinky pr printenv printf \
#  ptx pwd readlink rm rmdir runcon seq setuidgid shred shuf sleep sort split \
#  stat stty sum sync tac tail tee tr tsort tty uname unexpand uniq unlink \
#  uptime users wc whoami who yes"
#PROGRAMS="basename date df su touch"
# Not working: chgrp, touch
PROGRAMS=" chmod chown chroot cksum comm cp csplit cut \
  dd dircolors dirname du echo env expand expr factor false fmt fold \
  head hostid hostname id ginstall join kill link ln logname ls md5sum mkdir \
  mkfifo mknod mktemp mv nice nl nohup od paste pathchk pinky pr printenv printf \
  ptx pwd readlink rm rmdir runcon seq setuidgid shred shuf sleep sort split \
  stat stty sum sync tac tail tee tr tsort tty uname unexpand uniq unlink \
  uptime users wc whoami who yes"

if [ "$1" == "--clean" ]
then
  ./compare-optimization.sh --clean
else
  if [ ! -d "test_result" ]; then
    mkdir test_result
  fi
  for program in $PROGRAMS
  do
    ./compare-optimization.sh $program &> test_result/result_$program.txt
  done
fi
