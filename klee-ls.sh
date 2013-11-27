g++ -O3 klee-local-search.cpp -o klee-local-search
./check-all.sh --clean
make clean
make
for program in tr
do
  ./klee-local-search ${program} &> ${program}_2min_all.txt
done
