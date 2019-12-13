/*
 * Acknowledgement: "Futexes Are Tricky" http://dept-info.labri.fr/~denis/Enseignement/2008-IR/Articles/01-futex.pdf
 */

#ifndef _USER_BARRIER_H_
#define _USER_BARRIER_H_

#include <types.h>
#include "mutex.h"
#include "common.h"


typedef struct barrier {
    mutex_t lock;

    // Futex
    uint32_t event;

    uint32_t still_needed;
    uint32_t initial_needed;
} barrier_t;


void barrier_init(barrier_t *b, uint32_t needed) {
    mutex_init(&b->lock);
    b->event = 0;
    b->still_needed = needed;
    b->initial_needed = needed;
}

void barrier_wait(barrier_t *b) {
    mutex_lock(&b->lock);

    if (--b->still_needed > 0) {
	uint32_t ev = b->event;
	mutex_unlock(&b->lock);
	
	// Wait till enough
	do {
	    futex(&b->event, FUTEX_WAIT, ev, NULL, NULL, 0);
	} while (b->event == ev);


    // Enough 
    } else {
	++b->event;
	b->still_needed = b->initial_needed;
	futex(&b->event, FUTEX_WAKE, INT_MAX, NULL, NULL, 0);
	mutex_unlock(&b->lock);
    }
}




#endif  /* _USER_BARRIER_H_ */
