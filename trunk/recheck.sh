if [ ! -d "test_result" ]; then
  mkdir test_result
fi
./replay.sh date GlobalOptimizer &> test_result/result_date_GlobalOptimizer.txt
./replay.sh date IndVarSimplify &> test_result/result_date_IndVarSimplify.txt
