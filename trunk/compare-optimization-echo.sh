rm -rf ../klee-out-* ../klee-last
if [ "$1" != "--clean" ]
then
  # without optimization
  echo "=============================================="
  echo "no optimization "
  echo "=============================================="

  klee --libc=uclibc --posix-runtime --use-cache=false --use-cex-cache=false ../$1.bc --sym-arg 3
  klee-stats --print-all ../klee-last

  # with optimization but no flag
  echo "=============================================="
  echo "only --optimize, no --opt-flag"
  echo "=============================================="
  klee --libc=uclibc --posix-runtime --optimize --use-cache=false --use-cex-cache=false ../$1.bc --sym-arg 3
  klee-stats --print-all ../klee-last

  # with two memory optimization only
  echo "=============================================="
  echo "with two memory optimization only"
  echo "=============================================="
  klee --libc=uclibc --posix-runtime --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates --use-cache=false --use-cex-cache=false ../$1.bc --sym-arg 3
  klee-stats --print-all ../klee-last

  # with 2+1
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
    PruneEH \
    RaiseAllocation \
    Reassociate \
    SCCP \
    SimplifyLibCalls \
    StripDeadPrototypes \
    TailCallElimination
  do
    echo "=============================================="
    echo "with two memory optimizations and flag "${OPT}
    echo "=============================================="
    klee --libc=uclibc --posix-runtime --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates,${OPT} --use-cache=false --use-cex-cache=false ../$1.bc --sym-arg 3
    klee-stats --print-all ../klee-last
  done

  # with 2+2
  for OPT1 in \
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
    PruneEH \
    RaiseAllocation \
    Reassociate \
    SCCP \
    SimplifyLibCalls \
    StripDeadPrototypes \
    TailCallElimination
  do
    for OPT2 in \
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
      PruneEH \
      RaiseAllocation \
      Reassociate \
      SCCP \
      SimplifyLibCalls \
      StripDeadPrototypes \
      TailCallElimination
    do
      if [ ${OPT1} != ${OPT2} ]
      then
        echo "=============================================="
        echo "with two optimizations and flags "${OPT1}","${OPT2}
        echo "=============================================="
        klee --libc=uclibc --posix-runtime --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates,${OPT1},${OPT2} --use-cache=false --use-cex-cache=false ../$1.bc --sym-arg 3
        klee-stats --print-all ../klee-last
      fi
    done
  done
fi
