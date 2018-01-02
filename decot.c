/* $ xstatic gcc -s -Os -Wl,-N -W -Wall -Wextra -Werror -o decot deco.s decot.c && ./decot >decot.out */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "deco.h"

int main(int argc, char **argv) {
  char *outp;
  (void)argc; (void)argv;
  outp = malloc(sz_unc + 4);
  memcpy(outp + sz_unc, "DCBA", 4);
  fprintf(stderr, "outs0=%d outp=%p\n", sz_unc, outp);
  smart_decompress(outp);
  fprintf(stderr, "canary_ok2=%d\n", 0 == memcmp(outp + sz_unc, "DCBA", 4));
  /* uncompressed_data_size <= sz_unc. There is padding afterwards. */
  write(1, before_signature_data, AFTER_SIGNATURE_OFS);
  write(1, outp, uncompressed_data_size - AFTER_SIGNATURE_OFS);
  return 0;
}
