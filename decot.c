/*
 * decot.c: Example C program to execute smart_decompress.
 *
 * $ xstatic gcc -s -Os -Wl,-N -W -Wall -Wextra -Werror -o decot deco.s decot.c && ./decot >decot.out
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void smart_decompress(char *outp) __attribute__((regparm(3)));
extern unsigned ubufsize;
extern const unsigned uncompressed_data_size;
extern const char prefix_data[];
extern const char prefix_data_end[];

int main(int argc, char **argv) {
  char *outp;
  (void)argc; (void)argv;
  outp = malloc(ubufsize + 4);
  memcpy(outp + ubufsize, "DCBA", 4);
#if 0  /* This makes M_LZMA segfault. */
  ubufsize = 0;
#endif
  fprintf(stderr, "outs0=%d outp=%p\n", ubufsize, outp);
  smart_decompress(outp);
  fprintf(stderr, "outs2=%d canary_ok2=%d\n", ubufsize, 0 == memcmp(outp + ubufsize, "DCBA", 4));
  /* uncompressed_data_size <= ubufsize. There is padding afterwards. */
  write(1, prefix_data, prefix_data_end - prefix_data);
  write(1, outp, uncompressed_data_size);
  return 0;
}
