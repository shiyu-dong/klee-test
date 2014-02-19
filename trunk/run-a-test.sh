# $1: program name
# $2: time
# $3: solver (or none)
# $4: optimize (or none)
# $5: opt-flag (or none)

CMD=""
if [ "$4" != "none" ]
then
  if [ "$5" != "none" ]
  then
    CMD="$CMD klee-flag "
  else
    CMD="$CMD klee-original "
  fi
fi

CMD="$CMD --simplify-sym-indices \
  --write-cvcs \
  --write-cov \
  --output-module \
  --max-memory=1000 \
  --disable-inlining \
  --use-forked-solver \
  --libc=uclibc \
  --posix-runtime \
  --dump-states-on-halt=false \
  --allow-external-sym-calls \
  --only-output-states-covering-new \
  --use-cache=false \
  --use-cex-cache=false \
  --use-metasmt=$3 \
  --environ=../test.env \
  --run-in=/tmp/sandbox \
  --max-sym-array-size=4096 \
  --max-instruction-time=30. \
  --watchdog \
  --max-time=$2. \
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

CMD="$CMD --output-dir="
if [ "$4" != "none" ]; then
  if [ "$5" != "none" ]; then
    CMD="$CMD../klee-mutation-$1-$3-$5"
  else
    CMD="$CMD../klee-mutation-$1-$3-original"
  fi
else
  CMD="$CMD../klee-mutation-$1-$3-no-opt"
fi

#CMD="$CMD ../$1.bc \
#  --sym-args 0 3 10 \
#  --sym-files 2 8 \
#  --sym-stdout"

CMD="$CMD ../$1.bc \
  --sym-args 0 1 10 \
  --sym-args 0 2 2 \
  --sym-files 1 8 \
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

## Multi solver
#  --use-metasmt=$3 \

## Disable cache
#  --use-cache=false \
#  --use-cex-cache=false \

## Old arguments
#CMD="$CMD ../$1.bc \
#  --sym-args 0 1 10 \
#  --sym-args 0 2 2 \
#  --sym-files 1 8 \
#  --sym-stdout"

## New arguments
#CMD="$CMD ../$1.bc \
#  --sym-args 0 3 10 \
#  --sym-files 2 8 \
#  --sym-stdout"
