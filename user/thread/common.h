#ifndef _USER_COMMON_H_
#define _USER_COMMON_H_

#include <gcc.h>
#include <stdio.h>
#include <syscall.h>
#include <x86.h>

#define INT_MAX		2147483647

// If *addr is old_value, assign it to new_value, return old_value
// Otherwise, return new_value
gcc_inline uint32_t cmpxchg(volatile uint32_t *addr, uint32_t oldval, uint32_t newval)
{
    uint32_t result;

    __asm __volatile ("lock; cmpxchgl %2, %0"
                      : "+m" (*addr), "=a" (result)
                      : "r" (newval), "a" (oldval)
                      : "memory", "cc");

    return result;
}

gcc_inline uint32_t xchg(volatile uint32_t *addr, uint32_t newval)
{
    uint32_t result;

    __asm __volatile ("lock; xchgl %0, %1"
                      : "+m" (*addr), "=a" (result)
                      : "1" (newval)
                      : "cc");

    return result;
}

gcc_inline uint32_t atomic_inc(volatile uint32_t *addr) {
    return __sync_fetch_and_add(addr, 1);
}


gcc_inline uint32_t atomic_dec(volatile uint32_t *addr) {
    return __sync_fetch_and_sub(addr, 1);
}

gcc_inline uint32_t atomic_load(volatile uint32_t *addr) {
    return __sync_fetch_and_add(addr, 0);
}

gcc_inline void atomic_store(volatile uint32_t *addr, uint32_t val) {
    __sync_lock_test_and_set(addr, val);
}


gcc_inline void pause(void)
{
    __asm __volatile ("pause" ::: "memory");
}


gcc_inline volatile uint32_t delay(uint32_t d) {
   uint32_t i;
   for (i = 0; i < d; i++) {
       __asm volatile( "nop" ::: );
   }

   return i;
}

#endif /* _USER_COMMON_H_ */
