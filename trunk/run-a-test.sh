# $1: program name
# $2: time
# $3: solver (or none)
# $4: optimize (or none)
# $5: opt-flag (or none)

CMD=""
if [ "$4" != "none" ]
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
  --max-time=$2. \
  --use-metasmt=$3 \
  --max-memory-inhibit=false \
  --max-static-fork-pct=1 \
  --max-static-solve-pct=1 \
  --max-static-cpfork-pct=1 \
  --switch-type=internal \
  --search=dfs \
  --randomize-fork \
  --use-batching-search \
  --batch-instructions=10000"

if [ "$4" != "none" ]; then
  CMD="$CMD --$4"
  if [ "$5" != "none" ]; then
    CMD="$CMD --opt-flag=$5"
  fi
fi
CMD="$CMD ../$1.bc \
  --sym-args 0 3 10 \
  --sym-files 2 8 \
  --sym-stdout"

echo $CMD
${CMD}

# --max-forks=10 \
# --stop-after-n-tests=10 \
# --no-output \
# --dump-states-on-halt=false \
# --time-passes \
# --search=random-path \
# --search=nurs:covnew \

## Old arguments
#CMD="$CMD ../$1.bc \
#  --sym-args 0 1 10 \
#  --sym-args 0 2 2 \
#  --sym-files 1 8 \
#  --sym-stdout"

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
