/*
 * Acknowledgement: https://www.remlab.net/op/futex-condvar.shtml
 */

#ifndef _USER_CONDITION_VARIABLE_H_
#define _USER_CONDITION_VARIABLE_H_

#include <spinlock.h>
#include "common.h"

typedef struct condition_variable {
    uint32_t value;
    uint32_t previous;
} condvar_t;

void condvar_init(condvar_t *cv) {
    cv->value = 0;
    cv->previous = 0;
}


/*
 * Normal case:
 * When wait, waiter_a sets previous to A. Goes to sleep checking condition current value == A.
 * When wake, waker_a sets current value to A + 1, wakes it up.
 *
 * Interrupt right after unlock and before sleep:
 * When wait, waiter_a sets previous to A. Not to sleep yet.
 * When wake, waker_a sets current value to A + 1. wakes up nobody.
 * Then wait proceeds, waiter_a finds out that current value != A, return immediately.
 *
 * A lot of waiters:
 * When wait, waiter_a sets previous to current A, before waiter_a goes to sleep, waiter_b sets previous to current A.
 * When wake, waker_a sets current to 1 + A, wakes up a waiter. If any waiter did not go to sleep before this, they will
 *   not enter sleep at the first place since 1 + A != A.
 *
 */


// Previous = current
void condvar_wait(condvar_t *cv, spinlock_t *s) {
    uint32_t value = atomic_load(&cv->value);
    atomic_store(&cv->previous, value);

    spinlock_release(s);
    futex(&cv->value, FUTEX_WAIT, value, NULL, NULL, 0);
    spinlock_acquire(s);
}

// Current = previous + 1
void condvar_signal(condvar_t *cv) {
    atomic_store(&cv->value, 1u + atomic_load(&cv->previous));

    futex(&cv->value, FUTEX_WAKE, 1, NULL, NULL, 0);
}


/*
 * 
 */
void condvar_broadcast(condvar_t *cv) {
    atomic_store(&cv->value, 1u + atomic_load(&cv->previous));

    futex(&cv->value, FUTEX_WAKE, INT_MAX, NULL, NULL, 0);
}

#endif  /* _USER_CONDITION_VARIABLE_H_ */
