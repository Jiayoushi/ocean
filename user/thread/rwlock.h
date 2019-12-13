#ifndef _USER_RWLOCK_H_
#define _USER_RWLOCK_H_

#include "condvar.h"
#include "common.h"

typedef struct rwlock {
    spinlock_t lock;
    condvar_t read_can_go;
    condvar_t write_can_go;

    volatile uint32_t active_readers;
    volatile uint32_t active_writers;
    volatile uint32_t waiting_readers;
    volatile uint32_t waiting_writers;
} rwlock_t;

void rwlock_init(rwlock_t *rw) {
    spinlock_init(&rw->lock);
    condvar_init(&rw->read_can_go);
    condvar_init(&rw->write_can_go);

    rw->active_readers = 0;
    rw->active_writers = 0;
    rw->waiting_readers = 0;
    rw->waiting_writers = 0;
}

static bool read_can_go(rwlock_t *rw) {
    return rw->active_writers == 0 && rw->waiting_writers == 0;
}

static bool write_can_go(rwlock_t *rw) {
    return rw->active_writers == 0 && rw->active_readers == 0;
}

void rwlock_read(rwlock_t *rw) {
    spinlock_acquire(&rw->lock);

    ++rw->waiting_readers;

    while (!read_can_go(rw)) {
	condvar_wait(&rw->read_can_go, &rw->lock);
    }

    --rw->waiting_readers;
    ++rw->active_readers;

    spinlock_release(&rw->lock);
}

void rwlock_done_read(rwlock_t *rw) {
    spinlock_acquire(&rw->lock);

    --rw->active_readers;

    if (rw->active_readers == 0 && rw->waiting_writers > 0) {
	condvar_signal(&rw->write_can_go);
    }

    spinlock_release(&rw->lock);
}

void rwlock_write(rwlock_t *rw) {
    spinlock_acquire(&rw->lock);

    ++rw->waiting_writers;

    while (!write_can_go(rw)) {
	condvar_wait(&rw->write_can_go, &rw->lock);
    }

    --rw->waiting_writers;
    ++rw->active_writers;

    spinlock_release(&rw->lock);
}

void rwlock_done_write(rwlock_t *rw) {
    spinlock_acquire(&rw->lock);

    --rw->active_writers;

    if (rw->waiting_writers > 0) {
	condvar_signal(&rw->write_can_go);
    } else {
	//for (uint32_t i = 0; i < rw->waiting_readers; ++i) {
	//    condvar_signal(&rw->read_can_go);
	//}
	condvar_broadcast(&rw->read_can_go);
    }

    spinlock_release(&rw->lock);
}


#endif  /* _USER_RWLOCK_H_ */
