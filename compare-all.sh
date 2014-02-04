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
RaiseAllocation,\
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

FLAG3="\
PromoteMemoryToRegister,\
ScalarReplAggregates,\
IndVarSimplify,\
LoopRotate,\
InstructionCombining,\
PromoteMemoryToRegister"

FLAG4="\
PromoteMemoryToRegister,\
InstructionCombining,\
ScalarReplAggregates,\
InstructionCombining,\
LoopRotate,\
InstructionCombining,\
IndVarSimplify,\
InstructionCombining,\
ScalarReplAggregates,\
InstructionCombining,\
PromoteMemoryToRegister"

FLAG5="\
PromoteMemoryToRegister,\
InstructionCombining,\
ScalarReplAggregates,\
InstructionCombining"

FLAG6="\
LoopRotate,\
IndVarSimplify,\
PromoteMemoryToRegister,\
InstructionCombining,\
ScalarReplAggregates,\
InstructionCombining"

rm -rf ../klee-out-* ../klee-last
if [ "$1" != "--clean" ]
then
  for SOLVER in stp z3 btor
  do
    # without optimization
    echo "=============================================="
    echo "no optimization"
    echo "=============================================="
    ./run-a-test.sh $1 null null ${SOLVER}
    klee-stats --print-all ../klee-last

    cd ../../../obj-gcov/src/
    rm -rf *.gcda
    klee-replay $1 ../../obj-llvm/src/klee-last/*.ktest
    gcov -b -c $1
    cd ../../obj-llvm/src/klee-test

    # with original klee optimization
    echo "=============================================="
    echo "original optimization"
    echo "=============================================="
    ./run-a-test.sh $1 optimize null ${SOLVER}
    klee-stats --print-all ../klee-last

    cd ../../../obj-gcov/src/
    rm -rf *.gcda
    klee-replay $1 ../../obj-llvm/src/klee-last/*.ktest
    gcov -b -c $1
    cd ../../obj-llvm/src/klee-test


    # with selected opt-flag
    for OPT in \
      IndVarSimplify \
      InstructionCombining \
      LoopRotate \
      PromoteMemoryToRegister \
      ScalarReplAggregates \
    do
      echo "=============================================="
      echo "with optimization flag "${OPT}
      echo "=============================================="
      ./run-a-test.sh $1 optimize ${OPT} ${SOLVER}
      klee-stats --print-all ../klee-last

      cd ../../../obj-gcov/src/
      rm -rf *.gcda
      klee-replay $1 ../../obj-llvm/src/klee-last/*.ktest
      gcov -b -c $1
      cd ../../obj-llvm/src/klee-test
    done
  done
fi
