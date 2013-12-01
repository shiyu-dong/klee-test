g++ -O3 klee-local-search.cpp -o klee-local-search
./check-all.sh --clean
make clean
make
#for program in base64 cut dd du expand fold mknod tr tsort unexpand
for program in cut dd du expand fold mknod tr tsort unexpand
do
  ./klee-local-search ${program} &> ${program}_5min_all.txt
done
