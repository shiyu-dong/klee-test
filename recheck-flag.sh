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

if [ ! -d "test_result" ]; then
  mkdir test_result
fi
./replay-flag.sh chgrp ${FLAG2} &> test_result/result_chgrp.2.txt
