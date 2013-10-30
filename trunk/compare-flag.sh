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

rm -rf ../klee-out-* ../klee-last
if [ "$1" != "--clean" ]
then

  for OPT in \
    ${FLAG1} \
    ${FLAG2} \
    AggressiveDCE \
    ArgumentPromotion \
    CFGSimplification \
    CondPropagation \
    ConstantMerge \
    DeadArgElimination \
    DeadStoreElimination \
    DeadTypeElimination \
    FunctionAttrs \
    FunctionInlining \
    GlobalDCE \
    GlobalOptimizer \
    GVN \
    IndVarSimplify \
    InstructionCombining \
    IPConstantPropagation \
    JumpThreading \
    LICM \
    LoopDeletion \
    LoopIndexSplit \
    LoopRotate \
    LoopUnroll \
    LoopUnswitch \
    MemCpyOpt \
    PromoteMemoryToRegister \
    PruneEH \
    RaiseAllocation \
    Reassociate \
    ScalarReplAggregates \
    SCCP \
    SimplifyLibCalls \
    StripDeadPrototypes \
    TailCallElimination
  do
    echo "=============================================="
    echo "with optimization flag "${OPT}
    echo "=============================================="
    ./run-a-test.sh $1 --optimize --opt-flag=${OPT}
    klee-stats --print-all ../klee-last

    cd ../../../obj-gcov/src/
    rm -rf *.gcda
    klee-replay $1 ../../obj-llvm/src/klee-last/*.ktest
    gcov -b -c $1
    cd ../../obj-llvm/src/klee-test

  done
fi
