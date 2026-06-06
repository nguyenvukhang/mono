#include <stdlib.h>
#include <string.h>

char *make_string() {
  char *x = malloc(10 * sizeof(char));
  memcpy(x, "hello", 6);
  return x;
}

void edit_string(char *x) { memcpy(x, "hello", 6); }
void edit_string_arr(char **x) {
  *x = malloc(10 * sizeof(char));
  memcpy(*x, "hello", 6);
}

void free_string(char *x) { free(x); }
