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
  # without optimization
  echo "=============================================="
  echo "no optimization "
  echo "=============================================="
  ./run-a-test.sh $1
  klee-stats --print-all ../klee-last

  cd ../../../obj-gcov/src/
  rm -rf *.gcda
  klee-replay $1 ../../obj-llvm/src/klee-last/*.ktest
  gcov -b -c $1
  cd ../../obj-llvm/src/klee-test

  for OPT in \
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
    TailCallElimination \
    ${FLAG1} \
    ${FLAG2}
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

#   # with two memory optimization only
#   echo "=============================================="
#   echo "with two memory optimization only"
#   echo "=============================================="
#   ./run-a-test.sh $1 --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates
#   klee-stats --print-all ../klee-last

#  # with 2+1
#  for OPT in \
#    AggressiveDCE \
#    ArgumentPromotion \
#    CFGSimplification \
#    CondPropagation \
#    ConstantMerge \
#    DeadArgElimination \
#    DeadStoreElimination \
#    DeadTypeElimination \
#    FunctionAttrs \
#    FunctionInlining \
#    GlobalDCE \
#    GlobalOptimizer \
#    GVN \
#    IndVarSimplify \
#    InstructionCombining \
#    IPConstantPropagation \
#    JumpThreading \
#    LICM \
#    LoopDeletion \
#    LoopIndexSplit \
#    LoopRotate \
#    LoopUnroll \
#    LoopUnswitch \
#    MemCpyOpt \
#    PruneEH \
#    RaiseAllocation \
#    Reassociate \
#    SCCP \
#    SimplifyLibCalls \
#    StripDeadPrototypes \
#    TailCallElimination
#  do
#    echo "=============================================="
#    echo "with two memory optimizations and flag "${OPT}
#    echo "=============================================="
#    ./run-a-test.sh $1 --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates,${OPT}
#    klee-stats --print-all ../klee-last
#  done
#
#  # with 2+2
#  for OPT1 in \
#    AggressiveDCE \
#    ArgumentPromotion \
#    CFGSimplification \
#    CondPropagation \
#    ConstantMerge \
#    DeadArgElimination \
#    DeadStoreElimination \
#    DeadTypeElimination \
#    FunctionAttrs \
#    FunctionInlining \
#    GlobalDCE \
#    GlobalOptimizer \
#    GVN \
#    IndVarSimplify \
#    InstructionCombining \
#    IPConstantPropagation \
#    JumpThreading \
#    LICM \
#    LoopDeletion \
#    LoopIndexSplit \
#    LoopRotate \
#    LoopUnroll \
#    LoopUnswitch \
#    MemCpyOpt \
#    PruneEH \
#    RaiseAllocation \
#    Reassociate \
#    SCCP \
#    SimplifyLibCalls \
#    StripDeadPrototypes \
#    TailCallElimination
#  do
#    for OPT2 in \
#      AggressiveDCE \
#      ArgumentPromotion \
#      CFGSimplification \
#      CondPropagation \
#      ConstantMerge \
#      DeadArgElimination \
#      DeadStoreElimination \
#      DeadTypeElimination \
#      FunctionAttrs \
#      FunctionInlining \
#      GlobalDCE \
#      GlobalOptimizer \
#      GVN \
#      IndVarSimplify \
#      InstructionCombining \
#      IPConstantPropagation \
#      JumpThreading \
#      LICM \
#      LoopDeletion \
#      LoopIndexSplit \
#      LoopRotate \
#      LoopUnroll \
#      LoopUnswitch \
#      MemCpyOpt \
#      PruneEH \
#      RaiseAllocation \
#      Reassociate \
#      SCCP \
#      SimplifyLibCalls \
#      StripDeadPrototypes \
#      TailCallElimination
#    do
#      if [ ${OPT1} != ${OPT2} ]
#      then
#        echo "=============================================="
#        echo "with two optimizations and flags "${OPT1}","${OPT2}
#        echo "=============================================="
#        ./run-a-test.sh $1 --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates,${OPT1},${OPT2}
#        klee-stats --print-all ../klee-last
#      fi
#    done
#  done
