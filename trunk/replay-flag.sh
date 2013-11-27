# $1: program name
# $2: --optimize (or null)
# $3: --opt-flag=... (or null)

echo "=============================================="
if [ "$2" != "" ]
then
  if [ "$3" != "" ]
  then
    echo "with optimization flag "$3
  else
    echo "original optimization"
  fi
else
  echo "no optimization"
fi
echo "=============================================="

if [ "$2" != "" ]
then
  if [ "$3" != "" ]
  then
    ./run-a-test.sh $1 $2 $3
  else
    ./run-a-test.sh $1 $2
  fi
else
  ./run-a-test.sh $1
fi


klee-stats --print-all ../klee-last

cd ../../../obj-gcov/src/
rm -rf *.gcda
klee-replay $1 ../../obj-llvm/src/klee-last/*.ktest
gcov -b -c $1
cd ../../obj-llvm/src/klee-test
