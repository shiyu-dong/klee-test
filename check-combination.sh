FLAG1="\
RaiseAllocation,\
ScalarReplAggregates,\
MemCpyOpt,\
InstructionCombining,\
CondPropagation,\
DeadArgElimination,\
DeadStoreElimination,\
DeadTypeElimination,\
FunctionAttrs,\
GlobalDCE,\
GVN,\
IPConstantPropagation,\
LICM,\
LoopDeletion,\
LoopIndexSplit,\
LoopRotate,\
LoopUnswitch,\
PruneEH,\
Reassociate,\
SimplifyLibCalls,\
SCCP,\
StripDeadPrototypes,\
CFGSimplification"

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

PROGRAMS="base64 cat chcon comm date df dircolors dirname factor mknod tr pr cut chgrp chown echo fold readlink seq uname"

if [ "$1" == "--clean" ]
then
  ./combination-optimization.sh --clean
else
  if [ ! -d "test_result" ]; then
    mkdir test_result
  fi
  for program in $PROGRAMS
  do
    ./combination-optimization.sh $program ${FLAG1} &> test_result/result_$program.1.txt
  done
  for program in $PROGRAMS
  do
    ./combination-optimization.sh $program ${FLAG2} &> test_result/result_$program.2.txt
  done
fi
