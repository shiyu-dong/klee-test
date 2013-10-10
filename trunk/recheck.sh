if [ ! -d "test_result" ]; then
  mkdir test_result
fi
./replay.sh tr DeadArgElimination &> test_result/result_tr_DeadArgElimination.txt
./replay.sh echo RaiseAllocation &> test_result/result_echo_RaiseAllocation.txt
