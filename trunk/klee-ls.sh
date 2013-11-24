#g++ -O3 klee-local-search.cpp -o klee-local-search
./check-all.sh --clean
make clean
make
for program in factor fold join mknod pr seq
do
  ./klee-local-search ${program} &> ${program}_5min_all.txt
done
