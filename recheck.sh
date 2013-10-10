if [ ! -d "test_result" ]; then
  mkdir test_result
fi
./replay.sh tr SimplifyLibCalls &> test_result/result_tr_SimplifyLibCalls.txt
./replay.sh pr GlobalOptimizer &> test_result/result_pr_GlobalOptimizer.txt
./replay.sh pr InstructionCombining &> test_result/result_pr_InstructionCombining.txt
