/* $ xstatic gcc -s -Os -Wl,-N -W -Wall -Wextra -Werror -o decot deco.s decot.c && ./decot >decot.out */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "deco.h"

int main(int argc, char **argv) {
  char *outp;
  (void)argc; (void)argv;
  outp = malloc(sz_unc + 4);  /* !! why +4? fast? */
  memcpy(outp + sz_unc, "DCBA", 4);
  fprintf(stderr, "outs0=%d outp=%p\n", sz_unc, outp);
#if 0  /* Works. */
  {
    /* 0: OK, -1 (etc.): error. */
    int got;
    got = decompress(compressed_data, sz_cpr, outp, &sz_unc /* , 0 b_method */);
    /* decompress doesn't seem tho change *sz_unc. */
    fprintf(stderr, "got=%d sz_unc=%d canary_ok=%d\n", got, sz_unc, 0 == memcmp(outp + sz_unc, "DCBA", 4));
    if (b_ftid != 0) {
      lxunfilter(outp, sz_unc, b_cto8 /* , 0 b_ftid */);
    }
  }
#else  /* Works. */
  smart_decompress(outp);
#endif
  fprintf(stderr, "canary_ok2=%d\n", 0 == memcmp(outp + sz_unc, "DCBA", 4));
  write(1, outp, sz_unc);
  return 0;
}
