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


int num_compiler_flags=33;

string compiler_flags[]= {
  "AggressiveDCE",
  "ArgumentPromotion",
  "CFGSimplification",
  "CondPropagation",
  "ConstantMerge",
  "DeadArgElimination",
  "DeadStoreElimination",
  "DeadTypeElimination",
  "FunctionAttrs",
  "FunctionInlining",
  "GlobalDCE",
  "GlobalOptimizer",
  "GVN",
  "IndVarSimplify",
  "InstructionCombining",
  "IPConstantPropagation",
  "JumpThreading",
  "LICM",
  "LoopDeletion",
  "LoopIndexSplit",
  "LoopRotate",
  "LoopUnroll",
  "LoopUnswitch",
  "MemCpyOpt",
  "PromoteMemoryToRegister",
  "PruneEH",
  "RaiseAllocation",
  "Reassociate",
  "ScalarReplAggregates",
  "SCCP",
  "SimplifyLibCalls",
  "StripDeadPrototypes",
  "TailCallElimination"
};


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

int main(int argc, char* argv[]) {

  // Current flags selected so far as "the optimal"
  string current_compiler_flags="";
  double current_lcov=-1;
  int i;

  // Create test_result_new folder if it doesn't exist
  FILE *test=popen("[ ! -d \"test_result_new\" ] && mkdir test_result_new", "r");
  pclose(test);

  // Original optimizations.

  test=popen("echo \"==============================================\n original optimization\n==============================================\" > test_result_new/result_date.txt","r");
  //        popen("echo \"original optimization\" >> test_result_new/result_date.txt","r");
  //  popen("echo \"=====\" >> test_result_new/result_date.txt","r");

  //    popen("./run-a-test.sh date --optimize >> test_result_new/result_date.txt","r");
  pclose(test);

  // TODO: change date.bc to argv[1].bc
  test=popen("klee-original --simplify-sym-indices --write-cvcs --write-cov --output-module --max-memory=1000 --disable-inlining --use-cache=false --use-cex-cache=false --libc=uclibc --posix-runtime --dump-states-on-halt=false --allow-external-sym-calls --only-output-states-covering-new --environ=../test.env --run-in=/tmp/sandbox --max-sym-array-size=4096 --max-instruction-time=30. --watchdog --time-passes --max-time=300 --max-memory-inhibit=false --max-static-fork-pct=1 --max-static-solve-pct=1 --max-static-cpfork-pct=1 --switch-type=internal --randomize-fork --search=random-path --search=nurs:covnew --use-batching-search --batch-instructions=10000 --optimize ../date.bc --sym-args 0 1 10 --sym-args 0 2 2 --sym-files 1 8 --sym-stdout >> test_result_new/result_date.txt","r");
  pclose(test);

  test=popen("klee-stats --print-all ../klee-last >> test_result_new/result_date.txt","r");
  pclose(test);

  test=popen("rm -rf ../../../obj-gcov/src/*.gcda","r");
  pclose(test);

  test=popen("klee-replay ../../../obj-gcov/src/date ../../../obj-llvm/src/klee-last/*.ktest >> test_result_new/result_date.txt","r");
  pclose(test);

  test=popen("cd ../../../obj-gcov/src && gcov -b -c date >> ../../obj-llvm/src/klee-test/test_result_new/result_date.txt","r");
  pclose(test);

  data kleeData;


  // TODO: I think we need to update the current_lcov here.


  // Used to store the previous best flag for last iteration
  string previous_best_flag = "";

  int iters=0;
  // Arbitrarilly asking for 10 flags.
  while(iters<10) {
    iters++;
    // pid_t child, grand_child;
    // int cstatus, gcstatus;
    // pid_t c, gc;

    // hash map that maps from optimization flag in string to struct data
    map<string, data*> dataMap;

    // Do a clean here
    test=popen("./check-all.sh --clean","r");
    cout<<"Before first open"<<endl;

    /*
       char* arg1[] = {"check-all.sh", NULL};
       cout << *arg1 << endl;
       execvp("./check-all.sh", arg1);
       */


    // Trying all optimizations one at a time.
    for(i=0;i<10;++i) {
      // One optimization.

      string str ="echo \"==============================================\n with optimization flag ";
      if(current_compiler_flags.compare("")) {
        str+=current_compiler_flags;
        str+=",";
      }
      str+=compiler_flags[i];
      str+="\n==============================================\" >> test_result_new/result_date.txt";
      test=popen(str.c_str(),"r");

      //		  test=popen("echo \"==============================================\ \n with optimization flag AggressiveDCE \n ==============================================\" >> test_result_new/result_date.txt","r");

      pclose(test);
      //        popen("echo \"with optimization flag AggressiveDCE\" >> test_result_new/result_date.txt","r");
      //  popen("echo \"=====\" >> test_result_new/result_date.txt","r");

      //    popen("./run-a-test.sh date --optimize >> test_result_new/result_date.txt","r");

      str="klee-flag --simplify-sym-indices --write-cvcs --write-cov --output-module --max-memory=1000 --disable-inlining --use-cache=false --use-cex-cache=false --libc=uclibc --posix-runtime --dump-states-on-halt=false --allow-external-sym-calls --only-output-states-covering-new --environ=../test.env --run-in=/tmp/sandbox --max-sym-array-size=4096 --max-instruction-time=30. --watchdog --time-passes --max-time=300 --max-memory-inhibit=false --max-static-fork-pct=1 --max-static-solve-pct=1 --max-static-cpfork-pct=1 --switch-type=internal --randomize-fork --search=random-path --search=nurs:covnew --use-batching-search --batch-instructions=10000 --optimize --opt-flag=";

      if(current_compiler_flags.compare("")) {
        str+=current_compiler_flags;
        str+=",";
      }
      str+=compiler_flags[i];
      str+=" ../date.bc --sym-args 0 1 10 --sym-args 0 2 2 --sym-files 1 8 --sym-stdout >> test_result_new/result_date.txt";

      cout<<"The string compiler flag is:"<<str<<endl;

      test=popen(str.c_str(),"r");

      //		  test=popen("klee --simplify-sym-indices --write-cvcs --write-cov --output-module --max-memory=1000 --disable-inlining --use-cache=false --use-cex-cache=false --libc=uclibc --posix-runtime --dump-states-on-halt=false --allow-external-sym-calls --only-output-states-covering-new --environ=../test.env --run-in=/tmp/sandbox --max-sym-array-size=4096 --max-instruction-time=30. --watchdog --time-passes --max-time=300 --max-memory-inhibit=false --max-static-fork-pct=1 --max-static-solve-pct=1 --max-static-cpfork-pct=1 --switch-type=internal --randomize-fork --search=random-path --search=nurs:covnew --use-batching-search --batch-instructions=10000 --optimize --opt-flag=AggressiveDCE ../date.bc --sym-args 0 1 10 --sym-args 0 2 2 --sym-files 1 8 --sym-stdout >> test_result_new/result_date.txt","r");
      pclose(test);

      test=popen("klee-stats --print-all ../klee-last >> test_result_new/result_date.txt","r");
      pclose(test);

      test=popen("rm -rf ../../../obj-gcov/src/*.gcda","r");
      pclose(test);

      test=popen("klee-replay ../../../obj-gcov/src/date ../../../obj-llvm/src/klee-last/*.ktest >> test_result_new/result_date.txt","r");
      pclose(test);

      test=popen("cd ../../../obj-gcov/src && gcov -b -c date >> ../../obj-llvm/src/klee-test/test_result_new/result_date.txt","r");
      pclose(test);

    }

    cout<<"After first open"<<endl;
    cout<<"Before second open"<<endl;
    test=popen("./get-result-local-search.py test_result_new/result_date.txt","r");
    //    test=popen("./get-result.py test_result_new/result_date.txt >> csv/date.csv","r");
    pclose(test);

    cout<<"After second open"<<endl;

    if (argc <= 1) {
      cerr << "expecting program name.\n";
      exit(1);
    }

    string filename = argv[1];
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

        // TODO: verify
        int pos3 = flag.find_last_of(',');
        if (pos3 != string::npos)
          flag = flag.substr(pos3 + 1);

        line = line.substr(pos2 + 2);


        // get time
        pos1 = line.find('"');
        pos2 = line.find('"', pos1 + 1);
        new_data->time = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
        line = line.substr(pos2 + 2);
        cout << new_data->time << endl;

        // get lcov
        pos1 = line.find('"');
        pos2 = line.find('"', pos1 + 1);
        new_data->lcov = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
        line = line.substr(pos2 + 2);
        cout << new_data->lcov << endl;

        // get bcov
        pos1 = line.find('"');
        pos2 = line.find('"', pos1 + 1);
        new_data->bcov = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
        line = line.substr(pos2 + 2);
        cout << new_data->bcov << endl;

        // get once
        pos1 = line.find('"');
        pos2 = line.find('"', pos1 + 1);
        new_data->once = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
        line = line.substr(pos2 + 2);
        cout << new_data->once << endl;

        // get calls
        pos1 = line.find('"');
        pos2 = line.find('"', pos1 + 1);
        new_data->calls = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
        cout << new_data->calls << endl;

        if (flag.compare("OriginalOptimization"))
          dataMap[flag] = new_data;
        else
          kleeData = *new_data;
      }
      myfile.close();
    }
    else {
      cout << "Error. Unable to open file";
      exit(1);
    }

    // TODO: Should we compare with the no-opt instead of original-opt?
    cout << dataMap.size() << endl;
    double best_lcov_val=-1;
    string best_compiler_flag="";
    for (std::map<string, data*>::iterator it = dataMap.begin(); it != dataMap.end(); ++it) {
      cout <<"OSWALDO_FIRST:"<< it->first << endl;
      cout <<"OSWALDO_SECOND:"<< it->second->time << " " << it->second->lcov << " " << it->second->bcov << " " << it->second->once << " " << it->second->calls << endl;
      if(it->second->lcov > best_lcov_val && (it->first).compare("OriginalOptimization") && (it->first).compare(previous_best_flag)) {
        best_lcov_val = it->second->lcov;
        best_compiler_flag=it->first;
      }
    }
    cout<<"The best lcov this iter is:"<<best_lcov_val<<endl;
    cout<<"The current lcov so far is:"<<current_lcov<<endl;
    cout<<"The flags so far are: "<<current_compiler_flags<<endl;
    cout<<"The best flag for this iteration is:"<<best_compiler_flag<<endl;


    // TODO: Should we discard all remaining flags if none of them performs better than the previous best result?
    // TODO: Should we check duplication in these flags? At least see if it is the same as the most recently added one?
    current_lcov=best_lcov_val;
    if(best_compiler_flag.compare("")) {
      if(current_compiler_flags.compare(""))
        current_compiler_flags+=",";
      current_compiler_flags+=best_compiler_flag;
      previous_best_flag = best_compiler_flag;
    }

    //TODO: Verify
    dataMap.clear();
    test=popen("rm test_result_new/*.txt","r");
    pclose(test);

    /*
       if(best_lcov_val < current_lcov) 
       break;
       else {
       current_lcov=best_lcov_val;
       if(current_compiler_flags.compare(""))
       current_compiler_flags+=",";
       current_compiler_flags+=best_compiler_flag;
       }
       */


    /*



    // parent process is the main function to parse the result and save into the map
    // child process is used for running the python script for the klee result
    // grandchild process is used for calling klee and generating output
    child = fork();
    if (child == 0) {
    printf("GrandChild: PID of Grand Child = %ld\n", (long) getpid());
    grand_child = fork();
    if (grand_child == 0) {
    // // Dummy code
    // char *execArgs[] = { "echo", "Hello, World!", NULL };
    // execvp("echo", execArgs);

    // OSWALDO: Run the different optimziations here.

    // OSWALDO: Commented out


    char* arg1[] = {"run-a-test.sh","date","--optimize", NULL};
    cout << *arg1 << endl;
    // OSWALDO: Commented this out.
    //execvp("./run-a-test.sh", arg1);
    // OSWALDO: Using popen
    popen("./run-a-test.sh date --optimize > test_result_new/result_date.txt","r");

    //	char* arg1[] = {"check-all.sh", NULL};
    //	cout << *arg1 << endl;
    //	execvp("./check-all.sh", arg1);


    //	fprintf(stderr, "Grand child process could not do execvp.\n");
    //	exit(1);
    }
    else {

    //	gc = wait(&gcstatus);
    char *execArgs[] = { "echo", "Hello, World!", NULL };
    // // Dummy code
    // execvp("echo", execArgs);
    // printf("Child: Grand Child %ld exited with status = %d\n", (long) gc, gcstatus);

    char* arg2[] = {"analysis.sh", NULL};
    cout << *arg2 << endl;
    // OSWALDO: Commented this out.
    //	execvp("./analysis.sh", arg2);

    // OSWALDO
    cout<<"BEfore "<<endl;
    popen("./get-result.py test_result_new/result_date.txt","r");
    cout<<"AFter "<<endl;
    }

    fprintf(stderr, "Child process could not do execvp.\n");
    exit(1);
    }
    else {
    c = wait(&cstatus);
    printf("Parent: Child %ld exited with status = %d\n", (long) c, cstatus);
    cout << "Finish running!\n";
    }

    if (argc <= 1) {
    cerr << "expecting program name.\n";
    exit(1);
    }

    string filename = argv[1];
    filename = "csv/" + filename + ".csv";
    cout << filename << endl;

    ifstream myfile(filename.c_str());

    string line;
    cout<<"BEFORE OSWALDO"<<endl;
    if (myfile.is_open()) {
      cout<<"AFTER OSWALDO"<<endl;
      while (getline (myfile,line)) {
        cout<<"ENTERED OSWALDO"<<endl;
        data* new_data = new data;
        string flag;

        // Ugly but useful code to parse from the csv files
        // get flag
        cout << line << endl;
        int pos1 = line.find('"');
        int pos2 = line.find('"', pos1 + 1);
        flag = line.substr(pos1 + 1, pos2 - 1);
        line = line.substr(pos2 + 2);



        // get time
        pos1 = line.find('"');
        pos2 = line.find('"', pos1 + 1);
        new_data->time = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
        line = line.substr(pos2 + 2);
        cout << new_data->time << endl;

        // get lcov
        pos1 = line.find('"');
        pos2 = line.find('"', pos1 + 1);
        new_data->lcov = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
        line = line.substr(pos2 + 2);
        cout << new_data->lcov << endl;

        // get bcov
        pos1 = line.find('"');
        pos2 = line.find('"', pos1 + 1);
        new_data->bcov = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
        line = line.substr(pos2 + 2);
        cout << new_data->bcov << endl;

        // get once
        pos1 = line.find('"');
        pos2 = line.find('"', pos1 + 1);
        new_data->once = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
        line = line.substr(pos2 + 2);
        cout << new_data->once << endl;

        // get calls
        pos1 = line.find('"');
        pos2 = line.find('"', pos1 + 1);
        new_data->calls = atof(line.substr(pos1 + 1, pos2 - 1).c_str());
        cout << new_data->calls << endl;

        dataMap[flag] = new_data;
      }
      myfile.close();
    }
    else {
      cout << "Unable to open file";
      exit(1);
    }

    cout << dataMap.size() << endl;
    for (std::map<string, data*>::iterator it = dataMap.begin(); it != dataMap.end(); ++it) {
      cout <<"OSWALDO_FIRST:"<< it->first << endl;
      cout <<"OSWALDO_SECOND:"<< it->second->time << " " << it->second->lcov << " " << it->second->bcov << " " << it->second->once << " " << it->second->calls << endl;
    }
    // Must come out of infinite loop.
    break;
    */
  }

  cout<<"The best compiler flags are: "<<current_compiler_flags<<endl;

  return 0;
}
