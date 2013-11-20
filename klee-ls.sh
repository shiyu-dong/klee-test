#g++ -O3 klee-local-search.cpp -o klee-local-search
./check-all.sh --clean
make clean
make
./klee-local-search tr
