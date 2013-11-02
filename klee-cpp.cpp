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
using namespace std;

// used to store the parsed information
struct data {
  double time; // Running time
  double lcov; // Lines executed
  double bcov; // Branches executed
  double once; // Taken at least once
  double calls; // Calls executed
  data(){};
  ~data();
};

int main(int argc, char* argv[]) {

  pid_t child, grand_child;
  int cstatus, gcstatus;
  pid_t c, gc;

  // hash map that maps from optimization flag in string to struct data
  map<string, data*> dataMap;

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
      char* arg1[] = {"check-all.sh", NULL};
      cout << *arg1 << endl;
      execvp("./check-all.sh", arg1);
      fprintf(stderr, "Grand child process could not do execvp.\n");
      exit(1);
    }
    else {
      gc = wait(&gcstatus);
      char *execArgs[] = { "echo", "Hello, World!", NULL };
      // // Dummy code
      // execvp("echo", execArgs);
      // printf("Child: Grand Child %ld exited with status = %d\n", (long) gc, gcstatus);
      char* arg2[] = {"analysis.sh", NULL};
      cout << *arg2 << endl;
      execvp("./analysis.sh", arg2);
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
  if (myfile.is_open()) {
    while (getline (myfile,line)) {

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
    cout << it->first << endl;
    cout << it->second->time << " " << it->second->lcov << " " << it->second->bcov << " " << it->second->once << " " << it->second->calls << endl;
  }
  return 0;
}
