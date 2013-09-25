rm -rf ../klee-out-* ../klee-last
if [ "$1" != "--clean" ]
then
  # without optimization
  echo "=============================================="
  echo "no optimization "
  echo "=============================================="
  ./run-a-test.sh $1
  klee-stats --print-all ../klee-last

  # with optimization but no flag
  echo "=============================================="
  echo "only --optimize, no --opt-flag"
  echo "=============================================="
  ./run-a-test.sh $1 --optimize
  klee-stats --print-all ../klee-last

  # with two memory optimization only
  echo "=============================================="
  echo "with two memory optimization only"
  echo "=============================================="
  ./run-a-test.sh $1 --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates
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
    ./run-a-test.sh $1 --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates,${OPT}
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
        ./run-a-test.sh $1 --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates,${OPT1},${OPT2}
        klee-stats --print-all ../klee-last
      fi
    done
  done
fi
