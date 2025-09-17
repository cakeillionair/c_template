#ifndef DEBUG_H
#define DEBUG_H

#ifdef DEBUG
# define dbg_code(...) __VA_ARGS__
# define dbg_printf(fmt, ...) printf("[DBG:%16s:%3.3d]"fmt, __FILE__, __LINE__, __VA_OPT__(,) __VA_ARGS__)
#else
# define dbg_printf(fmt, ...) ((void) 0)
# define dbg_code(...)
#endif

#endif