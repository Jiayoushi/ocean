#ifndef _USER_SEMAPHORE_H_
#define _USER_SEMAPHORE_H_

#include <spinlock.h>
#include "futex.h"

typedef struct semaphore {
    uint32_t v;
    uint32_t waiters;
} semaphore_t;

void semaphore_init(semaphore_t *s, int v) {
    s->v = v;
    s->waiters = 0;
}

/*
 * Waits until the value is positive, then it atomically
 * decrements the value by 1
 */
void semaphore_p(semaphore_t *s) {
    atomic_inc(&s->waiters);

    do {
	uint32_t initial_v = atomic_load(&s->v);

	if (initial_v == 0) {
	    futex(&s->v, FUTEX_WAIT, initial_v, NULL, NULL, 0);
	} else if (cmpxchg(&s->v, initial_v, initial_v - 1) == initial_v) {
	    atomic_dec(&s->waiters);
	    break;
	} else {
	    // v is not 0 but failed to get it, retry!
	}
    } while (1);
}

/*
 * Atomically increments the value by 1. If any threads
 * are waiting in P, one is enabled, so that its call to P
 * succeeds at decrementing the value and returns
 */
void semaphore_v(semaphore_t *s) {
    atomic_inc(&s->v);

    if (atomic_load(&s->waiters) > 0) {
	futex(&s->v, FUTEX_WAKE, 1, NULL, NULL, 0);
    }
}

#endif  /* _USER_SEMAPHORE_H_ */
