#include "thread.h"
#include <gcc.h>
#include <stdio.h>
#include <syscall.h>
#include <x86.h>

#include "common.h"

pid_t sys_getpid() {
    int errno;
    pid_t pid;

    asm volatile ("int %2"
                  : "=a" (errno), "=b" (pid)
                  : "i" (T_SYSCALL),
                    "a" (SYS_getpid)
                  : "cc", "memory");

    return errno ? -1 : pid;
}

pid_t getpid() {
    return sys_getpid();
}

pid_t sys_thread_create(uintptr_t eip, uintptr_t stack) {
    int errno;
    pid_t pid;

    asm volatile ("int %2"
                  : "=a" (errno), "=b" (pid)
                  : "i" (T_SYSCALL),
                    "a" (SYS_thread_create),
		    "b" (eip),
		    "c" (stack)
                  : "cc", "memory");

    return errno ? -1 : pid;
}

int sys_thread_exit() {
    int errno;

    asm volatile ("int %1"
                  : "=a" (errno)
                  : "i" (T_SYSCALL),
                    "a" (SYS_thread_exit)
                  : "cc", "memory");

    return errno ? -1 : 0;
}

volatile static bool threads[1024];

void thread_init() {
    for (int i = 0; i < 1024; ++i) {
	threads[i] = 0;
    }
}

int thread_create(void(* fcn)(void *), void *arg, void *stack) {
    pid_t pid = sys_thread_create((uintptr_t)fcn, (uintptr_t)stack);

    threads[pid] = 1;

    return pid;
}

void thread_join(pid_t pid) {
    while (threads[pid] == 1) {
	delay(10000);
    }
}

void thread_exit() {
    sys_thread_exit();


    threads[getpid()] = 0;
}
