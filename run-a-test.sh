CMD=""
if [ "$3" != "" ]
then
  CMD="$CMD klee-flag "
else
  CMD="$CMD klee-original "
fi

CMD="$CMD --simplify-sym-indices \
  --write-cvcs \
  --write-cov \
  --output-module \
  --max-memory=1000 \
  --disable-inlining \
  --use-forked-solver \
  --use-cache=false \
  --use-cex-cache=false \
  --libc=uclibc \
  --posix-runtime \
  --dump-states-on-halt=false \
  --allow-external-sym-calls \
  --only-output-states-covering-new \
  --environ=../test.env \
  --run-in=/tmp/sandbox \
  --max-sym-array-size=4096 \
  --max-instruction-time=30. \
  --watchdog \
  --max-time=300. \
  --max-memory-inhibit=false \
  --max-static-fork-pct=1 \
  --max-static-solve-pct=1 \
  --max-static-cpfork-pct=1 \
  --switch-type=internal \
  --search=dfs \
  --randomize-fork \
  --use-batching-search \
  --batch-instructions=10000"

if [ "$2" != "" ]; then
  CMD="$CMD $2"
  if [ "$3" != "" ]; then
    CMD="$CMD $3"
  fi
fi
CMD="$CMD ../$1.bc \
  --sym-args 0 1 10 \
  --sym-args 0 2 2 \
  --sym-files 1 8 \
  --sym-stdout"

${CMD}

# --max-forks=10 \
# --stop-after-n-tests=10 \
# --no-output \
# --dump-states-on-halt=false \
# --time-passes \
# --search=random-path \
# --search=nurs:covnew \

#  --output-dir="
#  if [ "$2" != "" ]; then
#    if [ "$3" != "" ]; then
#      CMD="$CMD../klee-out-$1-flag"
#    else
#      CMD="$CMD../klee-out-$1-original"
#    fi
#  else
#    CMD="$CMD../klee-out-$1-no-opt"
#  fi
#  CMD="$CMD \
