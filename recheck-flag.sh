FLAG2="\
aiseAllocation,\
ScalarReplAggregates,\
MemCpyOpt,\
InstructionCombining,\
DeadStoreElimination,\
DeadTypeElimination,\
FunctionAttrs,\
GlobalDCE,\
IPConstantPropagation,\
LoopDeletion,\
LoopRotate,\
PruneEH,\
Reassociate,\
StripDeadPrototypes"

if [ ! -d "test_result_new" ]; then
  mkdir test_result_new
fi
./replay-flag.sh chgrp ${FLAG2} &> test_result_new/result_chgrp.txt
