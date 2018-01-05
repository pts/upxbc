/* A hello-world program with .text, .data and .rodata sections, useful for
 * executable compression and benchmarking the various libc implementations
 * for size and overhead.
 */

#include <stdio.h>

int answer = 42;

int main(int argc, char **argv) {
  (void)argv;
  printf("Hello%d, %s! (%d)\n", answer, "World", argc);
  return 0;
}