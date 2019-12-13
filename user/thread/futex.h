#ifndef _USER_FUTEX_H_
#define _USER_FUTEX_H_

#include <gcc.h>
#include <stdio.h>
#include <syscall.h>
#include <types.h>
#include "common.h"

// Arguments
#define FUTEX_PRIVATE_FLAG  (1 << 0)
#define FUTEX_LOCK_REALTIME (1 << 1)

// Operations
#define FUTEX_WAIT	    (1 << 2)
#define FUTEX_WAKE	    (1 << 3)
#define FUTEX_FD	    (1 << 4)        // Not used
#define FUTEX_REQUEUE	    (1 << 5)        // Not used
#define FUTEX_CMP_REQUEUE   (1 << 6)
#define FUTEX_WAKE_OP	    (1 << 7)        // Not used
#define FUTEX_WAIT_BITSET   (1 << 8)        // Not used
#define FUTEX_WAKE_BITSET   (1 << 9)        // Not used

// Return value
#define E_SUCC			 0
#define E_FAIL			-1
#define E_AGAIN			-2

int futex(uint32_t *uaddr, uint32_t futex_op, uint32_t val1,
	  const struct timespect *timeout,
	  uint32_t *uaddr2, uint32_t val3) {
    return sys_futex(uaddr, futex_op, val1, timeout, uaddr2, val3);
}

#endif  /* _USER_FUTEX_H_ */
