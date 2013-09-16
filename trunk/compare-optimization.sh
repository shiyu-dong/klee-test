rm -rf ../klee-out-* ../klee-last
if [ "$1" != "--clean" ]
then
  # without optimization
  echo "=============================================="
  echo "No Optimization "
  echo "=============================================="

  klee --max-time 120 --libc=uclibc --posix-runtime --use-cache=false --use-cex-cache=false  ../$1.bc --sym-args 1 10 10 --sym-files 2 2000 --max-fail 1 
  klee-stats --print-all ../klee-last

  # with optimization but no flag
  echo "=============================================="
  echo "Empty Optimization, no flag"
  echo "=============================================="
  klee --max-time 120 --libc=uclibc --posix-runtime --use-cache=false --use-cex-cache=false  --optimize ../$1.bc --sym-args 1 10 10 --sym-files 2 2000 --max-fail 1

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
    PruneEH \
    RaiseAllocation \
    Reassociate \
    SCCP \
    SimplifyLibCalls \
    StripDeadPrototypes \
    TailCallElimination
  do
    echo "=============================================="
    echo "Optimization with flag: "${OPT}
    echo "=============================================="
  klee --max-time 120 --libc=uclibc --posix-runtime --use-cache=false --use-cex-cache=false --optimize --opt-flag=PromoteMemoryToRegister,ScalarReplAggregates,${OPT} ../$1.bc --sym-args 1 10 10 --sym-files 2 2000 --max-fail 1 

    klee-stats --print-all ../klee-last
  done
fi
