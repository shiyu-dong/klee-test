#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <map>
#include <string>
#include <sstream>
#include <unistd.h>
#include <vector>

using namespace std;

// FLAGS THAT INDIVIDUALLY HAVE SOME EFFECT ON THE BENCHMARKS:
// 1) base64: IndvarSimplify, InstructionCombining.
// 2) cut: IndVarSimplify.
// 3) dd: InstructionCombining.
// 4) du: InstructionCombining.
// 5) expand: InstructionCombining.
// 6) fold: IndvarSimplify, InstructionCombining.
// 7) mknod: All, except DeadArgElimination.
// 8) tr: AggressiveDCE, CondPropagation, DeadArgElimination, FunctionInlining, IndVarSimplify, JumpThreading, LoopIndexSplit, LoopRotate, LoopUnswitch.
// 9) tsort:  None.
// 10) unexpand: IndVarSimplify, InstructionCombining.
// 11) small benchmarks: InstructionCombining, PruneEH, ScalarReplAggregates


// // Keeping flags that affect the coverage for the specific benchmarks
// string compiler_flags[]= {
//   "AggressiveDCE",
//   "ArgumentPromotion",
//   "CFGSimplification",
//   "CondPropagation",
//   "ConstantMerge",
//   "DeadArgElimination",
//   "DeadStoreElimination",
//   "DeadTypeElimination",
//   "FunctionAttrs",
//   "FunctionInlining",
//   "GlobalDCE",
//   "GlobalOptimizer",
//   "GVN",
//   "IndVarSimplify",
//   "InstructionCombining", 
//   "IPConstantPropagation",
//   "JumpThreading",
//   "LICM",
//   "LoopDeletion",
//   "LoopIndexSplit",
//   "LoopRotate",
//   "LoopUnroll",
//   "LoopUnswitch",
//   "MemCpyOpt",
//   "PromoteMemoryToRegister",
//   "PruneEH",
//   "RaiseAllocation",
//   "Reassociate",
//   "ScalarReplAggregates",
//   "SCCP",
//   "SimplifyLibCalls",
//   "StripDeadPrototypes",
//   "TailCallElimination"
// };
//
// int num_compiler_flags=33;

// The lines of code for each benchmark is:

string compiler_flags[]= {
  "AggressiveDCE",
  "CondPropagation",
  "DeadArgElimination",
  "FunctionInlining",
  "IndVarSimplify",
  "InstructionCombining",
  "JumpThreading",
  "LoopIndexSplit",
  "LoopRotate",
  "LoopUnswitch",
  "PruneEH",
  "ScalarReplAggregates",
};

int num_compiler_flags=12;

// mknod:   80 (small)
// base64: 105 (small)
// fold:   113 (small)
// expand: 151 (small)
// unexpand: 194 (small)
// tsort:  203 (medium)
// cut:    296 (medium)
// du:     302 (medium)
// dd:     561 (large)
// tr:     659 (large)



// string benchmarks[]= {
//   "base64",
//   "cut",
//   "dd",
//   "du",
//   "expand",
//   "fold",
//   "mknod",
//   "tr",
//   "tsort",
//   "unexpand"
// };
//
// int num_benchmarks=10;

string benchmarks[]= {
  "cut", // medium
  "dd", // large
  "du", // medium
  "expand", // small
  "tr", // large
};

int num_benchmarks=5;


// used to store the parsed information
struct data {
  double time; // Running time
  double lcov; // Lines executed
  double bcov; // Branches executed
  double once; // Taken at least once
  double calls; // Calls executed
  data(){};
  ~data(){};
};


// hash map that maps benchmark names to the weight given .
map<string, double> benchmarkWeight;


// Weight:
// 1.0 is given to smalles benchmarks.
// 2.0 is given to medium benchmarks.
// 3.0 is given to the largest benchmarks.
void initializeBenchmarkWeight() {

  benchmarkWeight["mknod"]=1.0;
  benchmarkWeight["base64"]=1.0;
  benchmarkWeight["fold"]=1.0;
  benchmarkWeight["expand"]=1.0;
  benchmarkWeight["unexpand"]=1.0;

  benchmarkWeight["tsort"]=2.0;
  benchmarkWeight["cut"]=2.0;
  benchmarkWeight["du"]=2.0;

  benchmarkWeight["tr"]=3.0;
  benchmarkWeight["dd"]=3.0;



  double total=0.0;

  // Maximum percentage that can be obtained across all benchmarks.
  for (std::map<string, double>::iterator it = benchmarkWeight.begin(); it != benchmarkWeight.end(); ++it) 
    total+=100.00*(it->second);

  // Normalizing the weights.
  for (std::map<string, double>::iterator it = benchmarkWeight.begin(); it != benchmarkWeight.end(); ++it) 
    benchmarkWeight[it->first]=(it->second)/total;

}


int main(int argc, char* argv[]) {

  // Current flags selected so far as "the optimal"
  string current_compiler_flags="";
  double current_lcov=-1;
  string best_flag_all="";
  double best_coverage_all=-1;
  int not_change_count = 0;
  double delta = 1e-6;
  int i;


  // Initialize the weight given to the results obtained for the benchmarks.
  initializeBenchmarkWeight();


  // Create test_result_new folder if it doesn't exist
  FILE *test=popen("[ ! -d \"test_result_new\" ] && mkdir test_result_new", "r");
  pclose(test);

  string command;


  // running klee without optimization for all benchmarks.
  for(i=0;i<num_benchmarks;++i) {
    command = "./replay-flag.sh ";
    command = command + benchmarks[i] + " > test_result_new/result_" + benchmarks[i]+ ".txt 2>&1";
    test=popen(command.c_str(), "r");
    pclose(test);
  }

  // running klee with original optimization for all benchmarks
  for(i=0;i<num_benchmarks;++i) {
    command = "./replay-flag.sh ";
    command = command + benchmarks[i] + " optimize >> test_result_new/result_" + benchmarks[i]+ ".txt 2>&1";
    test=popen(command.c_str(), "r");
    pclose(test);
  }

  //// running klee-stats
  //command = "klee-stats --print-all ../klee-last >> test_result_new/result_";
  //command = command + argv[1] + ".txt";
  //test=popen(command.c_str(), "r");
  //pclose(test);

  //// running klee replay
  //test=popen("rm -rf ../../../obj-gcov/src/*.gcda","r");
  //pclose(test);

  //command = "klee-replay ../../../obj-gcov/src/";
  //command = command + argv[1] + " ../../../obj-llvm/src/klee-last/*.ktest >> test_result_new/result_" + argv[1] + ".txt";
  //test=popen(command.c_str(),"r");
  //pclose(test);

  //// running gcov
  //command = "cd ../../../obj-gcov/src && gcov -b -c ";
  //command = command + argv[1] + " >> ../../obj-llvm/src/klee-test/test_result_new/result_" + argv[1] + ".txt";
  //test=popen(command.c_str(),"r");
  //pclose(test);

  data kleeData;

  // Used to store the previous best flag for last iteration
  string previous_best_flag = "";

  int iters=0;
  // // Arbitrarilly asking for 10 flags.
  // while(iters<10) {

  // Arbitrarilly asking for 5 flags.
  while(iters<5) {
    iters++;

    // hash map that maps benchmark names to it's data map.
    map<string, map<string,data*> > benchmarkMap;

    // hash map that maps benchmark names to it's best flag.
    map<string, string> benchmarkBestFlagMap;

    // hash map that maps benchmark names to it's best line-coverage value.
    map<string, float> benchmarkLCovMap;

    // Do a clean here
    test=popen("./check-all.sh --clean","r");
    cout<<"Before first open"<<endl;

    // Trying all optimizations one at a time.
    for(i=0;i<num_compiler_flags;++i) {
      // One optimization.

      string flag_str="";
      if(current_compiler_flags.compare("")) {
        flag_str+=current_compiler_flags;
        flag_str+=",";
      }
      flag_str += compiler_flags[i];


      cout<<"The string compiler flag is:"<<flag_str<<endl;

      // running klee with new flag combination for every benchmark
      int j;
      for(j=0;j<num_benchmarks;++j) {
        command = "./replay-flag.sh ";
        command = command + benchmarks[j] + " optimize " + flag_str + " >> test_result_new/result_" + benchmarks[j]+ ".txt 2>&1";
        test=popen(command.c_str(),"r");
        pclose(test);
      }

      //// running klee-stats
      //command = "klee-stats --print-all ../klee-last >> test_result_new/result_";
      //command = command + argv[1] + ".txt";
      //test=popen(command.c_str(), "r");
      //pclose(test);

      //// running klee replay
      //test=popen("rm -rf ../../../obj-gcov/src/*.gcda","r");
      //pclose(test);

      //command = "klee-replay ../../../obj-gcov/src/";
      //command = command + argv[1] + " ../../../obj-llvm/src/klee-last/*.ktest >> test_result_new/result_" + argv[1] + ".txt";
      //test=popen(command.c_str(),"r");
      //pclose(test);

      //// running gcov
      //command = "cd ../../../obj-gcov/src && gcov -b -c ";
      //command = command + argv[1] + " >> ../../obj-llvm/src/klee-test/test_result_new/result_" + argv[1] + ".txt";
      //test=popen(command.c_str(),"r");
      //pclose(test);
    }

    int j;
    for(j=0;j<num_benchmarks;++j) {
      cout<<"After first open"<<endl;
      cout<<"Before second open"<<endl;
      command = "./get-result-local-search.py test_result_new/result_";
      command = command + benchmarks[j] + ".txt";
      test=popen(command.c_str(),"r");
      pclose(test);
      cout<<"After second open"<<endl;
    }

    /*
       if (argc <= 1) {
       cerr << "expecting program name.\n";
       exit(1);
       }
       */

    for(j=0;j<num_benchmarks;++j) {


      // hash map that maps from optimization flag in string to struct data
      map<string, data*> dataMap;

      string filename = benchmarks[j];
      filename = "csv/" + filename + ".csv";
      cout << filename << endl;

      ifstream myfile(filename.c_str());

      string line;
      cout<<"BEFORE OSWALDO:"<<filename<<endl;
      if (myfile.is_open()) {
        cout<<"AFTER OSWALDO:"<<filename<<endl;
        while (getline (myfile,line)) {
          cout<<"ENTERED OSWALDO"<<endl;
          data* new_data = new data;
          string flag;

          // Ugly but useful code to parse from the csv files
          // get flag
          cout <<"The line is:"<<  line << endl;
          int pos1 = line.find('"');
          int pos2 = line.find('"', pos1 + 1);
          flag = line.substr(pos1 + 1, pos2 - 1);
          int pos3 = flag.find_last_of(',');
          if (pos3 != string::npos)
            flag = flag.substr(pos3 + 1);
          line = line.substr(pos2 + 2);

          // get time
          pos1 = line.find('"');
          pos2 = line.find('"', pos1 + 1);
          new_data->time = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
          line = line.substr(pos2 + 2);
          //cout << new_data->time << endl;

          // get lcov
          pos1 = line.find('"');
          pos2 = line.find('"', pos1 + 1);
          new_data->lcov = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
          line = line.substr(pos2 + 2);
          //cout << new_data->lcov << endl;

          // get bcov
          pos1 = line.find('"');
          pos2 = line.find('"', pos1 + 1);
          new_data->bcov = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
          line = line.substr(pos2 + 2);
          //cout << new_data->bcov << endl;

          // get once
          pos1 = line.find('"');
          pos2 = line.find('"', pos1 + 1);
          new_data->once = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
          line = line.substr(pos2 + 2);
          //cout << new_data->once << endl;

          // get calls
          pos1 = line.find('"');
          pos2 = line.find('"', pos1 + 1);
          new_data->calls = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
          //cout << new_data->calls << endl;

          if (flag.compare("OriginalOptimization") && flag.compare("NoOptimization"))
            dataMap[flag] = new_data;
          else
            //	    kleeData = *new_data;
            dataMap[flag]= new_data;
        }
        myfile.close();
      }
      else {
        cout << "Error. Unable to open file";
        exit(1);
      }

      cout << dataMap.size() << endl;
      double best_lcov_val=-1;
      string best_compiler_flag="";
      for (std::map<string, data*>::iterator it = dataMap.begin(); it != dataMap.end(); ++it) {
        cout <<"OSWALDO_FIRST:"<< it->first << endl;
        cout <<"OSWALDO_SECOND:"<< it->second->time << " " << it->second->lcov << " " << it->second->bcov << " " << it->second->once << " " << it->second->calls << endl;
        if(it->second->lcov > best_lcov_val && (it->first).compare("OriginalOptimization") && (it->first).compare("NoOptimization") && (it->first).compare(previous_best_flag)) {
          best_lcov_val = it->second->lcov;
          best_compiler_flag=it->first;
        }
      }

      cout<<"The best lcov this iter is:"<<best_lcov_val<<endl;
      cout<<"The current lcov so far is:"<<current_lcov<<endl;
      cout<<"The flags so far are: "<<current_compiler_flags<<endl;
      cout<<"The best flag for this iteration is:"<<best_compiler_flag<<endl;

      // OSWALDO: Fix this.
      /*
      // see if any change happened compared to previous iteration
      if (best_lcov_val - current_lcov < delta)
      not_change_count++;
      else
      not_change_count = 0;
      */

      // OSWALDO: Fix this.
      /*
         current_lcov=best_lcov_val;
         if(best_compiler_flag.compare("")) {
         if(current_compiler_flags.compare(""))
         current_compiler_flags+=",";
         current_compiler_flags+=best_compiler_flag;
         previous_best_flag = best_compiler_flag;
         }

         if (best_lcov_val > best_coverage_all) {
         best_coverage_all=best_lcov_val;
         best_flag_all=current_compiler_flags;
         }
         */

      benchmarkMap[benchmarks[j]]=dataMap;

      benchmarkBestFlagMap[benchmarks[j]]=best_compiler_flag;

      benchmarkLCovMap[benchmarks[j]]=best_lcov_val;

      dataMap.clear();

      // OSWALDO: Fix this.

      /*
      // save output for each iteration by name "result_program_iters.txt"
      string iters_str;
      ostringstream convert;
      convert << iters;
      iters_str = convert.str();

      command = "mv test_result_new/result_";
      command = command + argv[1] + ".txt test_result_new/result_" + argv[1] + "_" + iters_str + ".txt";
      test=popen(command.c_str(), "r");

      pclose(test);

      // if has not changed for two iterations, break
      if (not_change_count >= 2) {
      cout << "Coverage has not changed for two iterations, stop\n";
      break;
      }
      */

    }

    // OSWALDO

    // hash map that maps from optimization flag to value of the flag.
    // For now, we're just counting the number of times that the flag is the best.
    map<string, double> flagValue;

    // Initializing the count for all flags.
    for(j=0;j<num_compiler_flags;++j) 
      flagValue[compiler_flags[j]]=0.0;

    int k;
    for(j=0;j<num_benchmarks;++j) {
      string benchmark=benchmarks[j];
      map<string,data*> tempDataMap=benchmarkMap[benchmark];
      for(k=0;k<num_compiler_flags;++k) {
        string compiler_flag=compiler_flags[k];
        data *dataValue=tempDataMap[compiler_flag];
        flagValue[compiler_flag]+=benchmarkWeight[benchmark]*(dataValue->lcov);
      }
    }

    std::string best_flag_name="";
    int best_flag_value=-1;

    for (std::map<string, double>::iterator it = flagValue.begin(); it != flagValue.end(); ++it) 
      if(it->second > best_flag_value) {
        best_flag_value = it->second;
        best_flag_name = it->first;
      }

    cout<<"The best flag is "<<best_flag_name<<" with value "<<best_flag_value<<endl;

    if(current_compiler_flags.compare(""))
      current_compiler_flags+=",";
    current_compiler_flags+=best_flag_name;

  }

  cout<< "The best compiler flags after 10 iterations (or break earlier) are: "<<current_compiler_flags<< " and the coverage is" << current_lcov << endl;
  cout << "The best complier flags in this experiments are: " << best_flag_all << " and the coverage is " << best_coverage_all << endl;

  return 0;
}
