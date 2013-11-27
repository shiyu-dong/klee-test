./check-all.sh --clean
if [ ! -d "test_result_new" ]; then
  mkdir test_result_new
fi
./replay-flag.sh csplit --optimize &> test_result_new/result_csplit.txt
./replay-flag.sh csplit --optimize &>> test_result_new/result_csplit.txt
./replay-flag.sh csplit --optimize &>> test_result_new/result_csplit.txt
./replay-flag.sh csplit --optimize &>> test_result_new/result_csplit.txt
./replay-flag.sh csplit --optimize &>> test_result_new/result_csplit.txt
./replay-flag.sh csplit --optimize &>> test_result_new/result_csplit.txt
#./replay-flag.sh csplit --optimize --opt-flag=TailCallElimination,GVN,FunctionAttrs,PruneEH,GlobalOptimizer,DeadStoreElimination,StripDeadPrototypes &>> test_result_new/result_csplit.txt
#./replay-flag.sh date --optimize &> test_result_new/result_date.txt
#./replay-flag.sh date --optimize --opt-flag=DeadTypeElimination,GVN,ConstantMerge &>> test_result_new/result_date.txt
#./replay-flag.sh expand --optimize &> test_result_new/result_expand.txt
#./replay-flag.sh expand --optimize --opt-flag=DeadTypeElimination,ScalarReplAggregates,DeadStoreElimination,SimplifyLibCalls,SCCP,LoopIndexSplit,InstructionCombining &>> test_result_new/result_expand.txt
#./replay-flag.sh factor --optimize &> test_result_new/result_factor.txt
#./replay-flag.sh factor --optimize --opt-flag=LoopUnroll,SCCP,FunctionInlining,AggressiveDCE,DeadArgElimination,SimplifyLibCalls,ConstantMerge,ArgumentPromotion,DeadStoreElimination,CondPropagation &>> test_result_new/result_factor.txt
#./replay-flag.sh fold --optimize &> test_result_new/result_fold.txt
#./replay-flag.sh fold --optimize --opt-flag=SCCP,InstructionCombining,GVN,LoopUnswitch,AggressiveDCE,LoopUnroll,DeadStoreElimination&>> test_result_new/result_fold.txt
#./replay-flag.sh tr --optimize &> test_result_new/result_tr.txt
#./replay-flag.sh tr --optimize --opt-flag=SCCP,LoopRotate,ScalarReplAggregates,GVN,CFGSimplification,PruneEH &>> test_result_new/result_tr.txt
