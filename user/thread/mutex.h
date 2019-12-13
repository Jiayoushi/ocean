#ifndef _USER_MUTEX_H_
#define _USER_MUTEX_H_

#include <gcc.h>
#include <stdio.h>
#include <syscall.h>
#include <x86.h>

#include "futex.h"
#include "thread.h"
#include "common.h"

typedef struct mutex {
    uint32_t val gcc_aligned(sizeof(uint32_t));
} mutex_t;

enum mutex_state {
    MUTEX_UNLOCKED		    = 0,
    MUTEX_LOCKED_NO_WAITERS	    = 1,
    MUTEX_LOCKED_WITH_WAITERS	    = 2
};

void mutex_init(mutex_t *mtx) {
    mtx->val = MUTEX_UNLOCKED;
}

void mutex_lock(mutex_t *mtx) {
    int c = 0;
    // Check if it's locked
    if ((c = cmpxchg(&mtx->val, MUTEX_UNLOCKED, MUTEX_LOCKED_NO_WAITERS)) != MUTEX_UNLOCKED) {
	// It's already locked, the old value (either 0 or more waitiers) is unchanged
	// This caller is a waiter, so set mtx->val to have waiters
	if (c != MUTEX_LOCKED_WITH_WAITERS)
	    c = xchg(&mtx->val, MUTEX_LOCKED_WITH_WAITERS);

	while (c != MUTEX_UNLOCKED) {
	    futex(&mtx->val, FUTEX_WAIT, MUTEX_LOCKED_WITH_WAITERS, NULL, NULL, 0);

	    c = xchg(&mtx->val, MUTEX_LOCKED_WITH_WAITERS);
	}
    }
}

void mutex_unlock(mutex_t *mtx) {
    if (__sync_fetch_and_sub(&mtx->val, 1) != MUTEX_LOCKED_NO_WAITERS) {
	mtx->val = MUTEX_UNLOCKED;
	futex(&mtx->val, FUTEX_WAKE, 1, NULL, NULL, 0);
    }
}

#endif  /* _USER_MUTEX_H_ */
