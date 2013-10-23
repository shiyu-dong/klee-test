rm -rf ../klee-out-* ../klee-last
if [ "$1" != "--clean" ]
then
  # with original klee optimization
  echo "=============================================="
  echo "original optimization "
  echo "=============================================="
  ./run-a-test.sh $1 --optimize
  klee-stats --print-all ../klee-last

  cd ../../../obj-gcov/src/
  rm -rf *.gcda
  klee-replay $1 ../../obj-llvm/src/klee-last/*.ktest
  gcov -b -c $1
  cd ../../obj-llvm/src/klee-test
fi
