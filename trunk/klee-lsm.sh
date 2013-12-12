./check-all.sh --clean
make clean
make
./klee-local-search-multibenchmark &> lsm_5min.txt
