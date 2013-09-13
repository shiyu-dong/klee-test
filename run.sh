if [ "$1" == "--clean" ]
then
  ./compare-optimization.sh --clean
  rm *.txt
else
  ./compare-optimization.sh $1 > output.txt
  ./get-result.py > result-$1.txt
fi
