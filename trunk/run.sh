if [ "$1" == "--clean" ]
then
  ./compare-optimization.sh --clean
else
  ./compare-optimization.sh $1 > output-tr.txt
  ./compare-optimization-echo.sh echo > output-echo.txt
  ./get-result.py output-tr.txt > result-tr.txt 
  ./get-result.py output-echo.txt > result-echo.txt
fi
