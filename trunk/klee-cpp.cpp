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

struct data {
  double time;
  double lcov;
  double bcov;
  double once;
  double calls;
};

int main(int argc, char* argv[]) {

  pid_t child, grand_child;
  int cstatus, gcstatus;
  pid_t c, gc;
  map<string, data*> dataMap;

  child = fork();
  if (child == 0) {
    printf("GrandChild: PID of Grand Child = %ld\n", (long) getpid());
    grand_child = fork();
    if (grand_child == 0) {
      char *execArgs[] = { "echo", "Hello, World!", NULL };
      execvp("echo", execArgs);
      //char* arg1[] = {"check-all.sh", NULL};
      //cout << *arg1 << endl;
      //execvp("./check-all.sh", arg1);
      fprintf(stderr, "Grand child process could not do execvp.\n");
      exit(1);
    }
    else {
      gc = wait(&gcstatus);
      char *execArgs[] = { "echo", "Hello, World!", NULL };
      execvp("echo", execArgs);
      printf("Child: Grand Child %ld exited with status = %d\n", (long) gc, gcstatus);
      //char* arg2[] = {"analysis.sh", NULL};
      //cout << *arg2 << endl;
      //execvp("./analysis.sh", arg2);
    }

    fprintf(stderr, "Child process could not do execvp.\n");
    exit(1);
  }
  else { /* Parent process. */
    if (child == (pid_t)(-1)) {
      fprintf(stderr, "Fork failed.\n"); exit(1);
    }
    else {
      c = wait(&cstatus); /* Wait for child to complete. */
      printf("Parent: Child %ld exited with status = %d\n", (long) c, cstatus);
      cout << "Finish running!\n";
    }
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
      std::istringstream ss(line);
      string flag;
      string token;

      if (getline(ss, token, ','))
        flag = token;
      cout << flag << endl;
      if (getline(ss, token, ','))
        new_data->time = atof(token.c_str());
      if (getline(ss, token, ','))
        new_data->lcov = atof(token.c_str());
      if (getline(ss, token, ','))
        new_data->bcov = atof(token.c_str());
      if (getline(ss, token, ','))
        new_data->once = atof(token.c_str());
      if (getline(ss, token, ','))
        new_data->calls = atof(token.c_str());

      dataMap[flag] = new_data;
    }
    myfile.close();
  }
  else
    cout << "Unable to open file"; 

  cout << dataMap.size() << endl;
  return 0;
} /* End of main. */
