#include <libgen.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define EXISTS(filename) (access(filename, F_OK) == 0)
#define BANNER(thing) "(t) \x1b[36m" thing "\x1b[m\n"

#define MAX_USER_ARGS 8
#define MAX_FIXED_ARGS 4
#define MAX_ARGS (MAX_USER_ARGS + MAX_FIXED_ARGS)
// Maximum path length
#define P 256

#define MATCH(filename) else if (EXISTS(filename) && printf(BANNER(filename)))

#define ARG(arg) args[i++] = arg;

int main(int argc, char **argv) {
  argv++, argc--; // Skip the first arg.
  if (argc > MAX_USER_ARGS) {
    printf("Broski that's too many args. Limit is %d\n", MAX_USER_ARGS);
    return 1;
  }

  char buf[2][P];
  char *cwd = buf[0], *prev_cwd = buf[1], *tmp;
  getcwd(cwd, P - 1);

  char *args[MAX_ARGS] = {NULL};
  for (int l = 0; l < 8; ++l) {
    int i = 0;
    if (0) {
    }
    MATCH("Makefile") {
      ARG("make");
      ARG("--no-print-directory");
    }
    MATCH("Cargo.toml") {
      ARG("cargo");
      ARG("run");
    }
    MATCH("package.json") {
      ARG("npm");
      ARG("run");
    }
    MATCH("build.sh") {
      ARG("bash");
      ARG("build.sh");
    }
    MATCH("run.py") {
      ARG("python3");
      ARG("run.py");
    }
    if (__builtin_expect(i, 1)) {
      // Append the rest of the user-passed arguments.
      memcpy(&args[i], argv, (sizeof(char *)) * argc);
      // Forward it all.
      execvp(args[0], args);
    }
    printf("(t) \x1b[37m%s\x1b[m\n", cwd);
    tmp = cwd;
    cwd = prev_cwd;
    prev_cwd = tmp;
    // Go up one directory, and try again.
    chdir("..");
    getcwd(cwd, P - 1);
    if (strncmp(cwd, prev_cwd, P) == 0)
      break;
  }
  printf("Nothing to be done by t.\n");
  return 0;
}
