#ifndef _USER_SYSCALL_H_
#define _USER_SYSCALL_H_

#include <lib/syscall.h>

#include <debug.h>
#include <gcc.h>
#include <proc.h>
#include <types.h>
#include <x86.h>

#include "time.h"

static gcc_inline void sys_puts(const char *s, size_t len)
{
    asm volatile ("int %0"
                  :: "i" (T_SYSCALL),
                     "a" (SYS_puts),
                     "b" (s),
                     "c" (len)
                  : "cc", "memory");
}

static gcc_inline pid_t sys_spawn(unsigned int elf_id, unsigned int quota)
{
    int errno;
    pid_t pid;

    asm volatile ("int %2"
                  : "=a" (errno), "=b" (pid)
                  : "i" (T_SYSCALL),
                    "a" (SYS_spawn),
                    "b" (elf_id),
                    "c" (quota)
                  : "cc", "memory");

    return errno ? -1 : pid;
}

static gcc_inline void sys_yield(void)
{
    asm volatile ("int %0"
                  :: "i" (T_SYSCALL),
                     "a" (SYS_yield)
                  : "cc", "memory");
}

static gcc_inline void sys_produce(unsigned int val)
{
    asm volatile ("int %0"
                  :: "i" (T_SYSCALL),
                     "a" (SYS_produce),
                     "b" (val)
                  : "cc", "memory");
}

static gcc_inline unsigned int sys_consume(void)
{
    unsigned int val;
    asm volatile ("int %1"
                  : "=b" (val)
                  : "i" (T_SYSCALL),
                    "a" (SYS_consume)
                  : "cc", "memory");
    return val;
}

static gcc_inline int sys_futex(uint32_t *uaddr, uint32_t op, uint32_t val1,
					 const struct timespect *timeout,
					 uint32_t *uaddr2, uint32_t val3)
{
    int errno;
    unsigned int ret;
    asm volatile ("int %2"
                  : "=a" (errno), "=b" (ret)
                  : "i" (T_SYSCALL),
                    "a" (SYS_futex),
		    "b" (uaddr),
		    "c" (op),
		    "d" (val1),
		    "S" (uaddr2),
		    "D" (val3)
                  : "cc", "memory");
    return errno ? errno : ret;
}

#endif  /* !_USER_SYSCALL_H_ */
