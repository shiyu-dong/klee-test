rm -rf ../klee-out-* ../klee-last
if [ "$1" != "--clean" ]
then
  # without optimization
  echo "=============================================="
  echo "no optimization "
  echo "=============================================="

  klee --max-time 120 --libc=uclibc --posix-runtime --use-cache=false --use-cex-cache=false  ../$1.bc --sym-args 1 10 10 --sym-files 2 2000 --max-fail 1
  klee-stats --print-all ../klee-last

  # with optimization but no flag
  echo "=============================================="
  echo "only --optimize, no --opt-flag"
  echo "=============================================="
  klee --max-time 120 --libc=uclibc --posix-runtime --use-cache=false --use-cex-cache=false  --optimize ../$1.bc --sym-args 1 10 10 --sym-files 2 2000 --max-fail 1
  klee-stats --print-all ../klee-last

  # with two memory optimization only
  echo "=============================================="
  echo "with two memory optimization only"
  echo "=============================================="
  klee --max-time 120 --libc=uclibc --posix-runtime --use-cache=false --use-cex-cache=false --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates ../$1.bc --sym-args 1 10 10 --sym-files 2 2000 --max-fail 1
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
    klee --max-time 120 --libc=uclibc --posix-runtime --use-cache=false --use-cex-cache=false --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates,${OPT} ../$1.bc --sym-args 1 10 10 --sym-files 2 2000 --max-fail 1
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
        klee --max-time 120 --libc=uclibc --posix-runtime --use-cache=false --use-cex-cache=false --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates,${OPT1},${OPT2} ../$1.bc --sym-args 1 10 10 --sym-files 2 2000 --max-fail 1
        klee-stats --print-all ../klee-last
      fi
    done
  done
fi
