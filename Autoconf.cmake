include(CheckSymbolExists)
include(CheckIncludeFiles)
include(CheckTypeSize)
include(CheckCSourceCompiles)

macro(AC_HEADER_STDC)
  check_include_files("stdlib.h;stdarg.h;string.h;float.h" STDC_HEADERS)
  if(STDC_HEADERS)
    check_symbol_exists(memchr "string.h" STDC_HEADERS)
  endif(STDC_HEADERS)
  if(STDC_HEADERS)
    check_symbol_exists(free "stdlib.h" STDC_HEADERS)
  endif(STDC_HEADERS)
endmacro(AC_HEADER_STDC)

macro(AC_HEADER_TIME)
  check_c_source_compiles("
#include <time.h>
#include <sys/time.h>

int main() {
  if ((struct tm *)0)
    return 0;
  return 1;
}" TIME_WITH_SYS_TIME)
endmacro()

macro(AC_TYPE_SIGNAL)
  set(CMAKE_C_RETSIGTYPE void CACHE INTERNAL "your code may safely assume C89 semantics that RETSIGTYPE is void.")
endmacro(AC_TYPE_SIGNAL)

function(AC_C_RESTRICT)
  if(NOT DEFINED CACHE{CMAKE_C_RESTRICT})
    foreach(ac_kw __restrict __restrict__ _Restrict restrict)
      check_c_source_compiles("int foo (int * ${ac_kw} ip) {
  return ip[0];
}

int main() {
  int s[1];
  int * ${ac_kw} t = s;
  t[0] = 0;
  return foo(t);
}" ac_cv_c_restrict_${ac_kw})
      if(ac_cv_c_restrict_${ac_kw})
        set(CMAKE_C_RESTRICT ${ac_kw} CACHE STRING "If the C compiler recognizes a variant spelling for the restrict keyword (__restrict, __restrict__, or _Restrict), then define CMAKE_C_RESTRICT to that; this is more likely to do the right thing with compilers that support language variants where plain restrict is not a keyword. Otherwise, if the C compiler recognizes the restrict keyword, set CMAKE_C_RESTRICT to restrict. Otherwise, define CMAKE_C_RESTRICT to be empty. Thus, programs may simply use CMAKE_C_RESTRICT as if every C compiler supported it; for those that do not, the makefile or configuration header defines it away.")
        break()
      endif(ac_cv_c_restrict_${ac_kw})
    endforeach(ac_kw)
  endif(NOT DEFINED CACHE{CMAKE_C_RESTRICT})
  if(NOT DEFINED CACHE{CMAKE_C_RESTRICT})
    set(CMAKE_C_RESTRICT "" CACHE STRING "")
  endif(NOT DEFINED CACHE{CMAKE_C_RESTRICT})
endfunction(AC_C_RESTRICT)

function(AC_C_VOLATILE)
  if(NOT DEFINED CACHE{CMAKE_C_VOLATILE})
    check_c_source_compiles("int main() {
  volatile int x;
  int * volatile y = (int *) 0;
  return !x && !y;
}" ac_cv_c_volatile)
    if(ac_cv_c_volatile)
      set(CMAKE_C_VOLATILE "volatile" CACHE STRING "If the C compiler does not understand the keyword volatile, define CMAKE_C_VOLATILE to be empty. Programs can simply use CMAKE_C_VOLATILE as if every C compiler supported it; for those that do not, the makefile or configuration header defines it as empty.")
    else(ac_cv_c_volatile)
      set(CMAKE_C_VOLATILE "" CACHE STRING "")
    endif(ac_cv_c_volatile)
  endif(NOT DEFINED CACHE{CMAKE_C_VOLATILE})
endfunction(AC_C_VOLATILE)

function(AC_C_INLINE)
  if(NOT DEFINED CACHE{CMAKE_C_INLINE})
    foreach(ac_kw inline __inline__ __inline)
      check_c_source_compiles("#ifndef __cplusplus
typedef int foo_t;
static ${ac_kw} foo_t static_foo () {return 0; }
${ac_kw} foo_t foo () {return 0; }
#endif

int main() { return 0; }" ac_cv_c_inline_${ac_kw})
      if(ac_cv_c_inline_${ac_kw})
        set(CMAKE_C_INLINE ${ac_kw} CACHE STRING "If the C compiler supports the keyword inline, set CMAKE_C_INLINE to inline. Otherwise define CMAKE_C_INLINE to __inline__ or __inline if it accepts one of those, otherwise define CMAKE_C_INLINE to be empty.")
        break()
      endif(ac_cv_c_inline_${ac_kw})
    endforeach(ac_kw)
  endif(NOT DEFINED CACHE{CMAKE_C_INLINE})
  if(NOT DEFINED CACHE{CMAKE_C_INLINE})
    set(CMAKE_C_INLINE "" CACHE STRING "")
  endif(NOT DEFINED CACHE{CMAKE_C_INLINE})
endfunction(AC_C_INLINE)

