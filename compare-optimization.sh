rm -rf ../klee-out-* ../klee-last
if [ "$1" != "--clean" ]
then
  # without optimization
  echo "=============================================="
  echo "No Optimization "
  echo "=============================================="
  klee --libc=uclibc --posix-runtime ../$1.bc --sym-arg 3
  klee-stats --print-all ../klee-last

  # with optimization but no flag
  echo "=============================================="
  echo "Empty Optimization, no flag"
  echo "=============================================="
  klee --libc=uclibc --posix-runtime --optimize ../$1.bc --sym-arg 3
  klee-stats --print-all ../klee-last

  #compare different optimizations for one program
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
    TailCallElimination
  do
    echo "=============================================="
    echo "Optimization with flag: "${OPT}
    echo "=============================================="
    klee --libc=uclibc --posix-runtime --optimize --opt-flag=${OPT} ../$1.bc --sym-arg 3
    klee-stats --print-all ../klee-last
  done
fi
