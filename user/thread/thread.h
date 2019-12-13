#ifndef _USER_THREAD_H_
#define _USER_THREAD_H_

#include <types.h>

pid_t getpid();

pid_t thread_create(void(* fcn)(void *), void *arg, void *stack);
void thread_join(pid_t pid);
void thread_exit();
void thread_init();

#endif  /* _USER_THREAD_H_ */
