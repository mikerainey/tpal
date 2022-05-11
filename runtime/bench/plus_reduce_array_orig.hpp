/*
compiled using
https://godbolt.org/
gcc 9.3
-O3 -m64 -march=x86-64 -mtune=x86-64 -fopt-info-vec -mavx -fomit-frame-pointer -DNDEBUG
./gen_rollforward.sh plus_reduce_array pra
 */

#include <stdint.h>
#include <algorithm>

