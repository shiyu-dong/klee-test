CMD="klee \
--simplify-sym-indices \
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
--allow-external-sym-calls \
--only-output-states-covering-new \
--environ=../test.env \
--run-in=/tmp/sandbox \
--max-sym-array-size=4096 \
--max-instruction-time=30. \
--watchdog \
--max-time=600. \
--max-memory-inhibit=false \
--max-static-fork-pct=1 \
--max-static-solve-pct=1 \
--max-static-cpfork-pct=1 \
--switch-type=internal \
--randomize-fork \
--search=random-path \
--search=nurs:covnew \
--use-batching-search \
--batch-instructions=10000"
if [ "$2" != "" ]; then
  CMD="$CMD $2"
fi
if [ "$3" != "" ]; then
  CMD="$CMD $3"
fi
CMD="$CMD ../$1.bc \
--sym-args 0 1 10 \
--sym-args 0 2 2 \
--sym-files 1 8 \
--sym-stdout $> test_result/$1/$1.txt"

${CMD}

# --max-forks=10 \
# --stop-after-n-tests=10 \
# --no-output \
