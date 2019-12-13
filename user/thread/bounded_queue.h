#ifndef _USER_BOUNDED_QUEUE_H_
#define _USER_BOUNDED_QUEUE_H_

#include <spinlock.h>
#include "mutex.h"
#include "condvar.h"
#include "common.h"

#define BOUNDED_QUEUE_CAPACITY	    10

typedef struct {
    spinlock_t lock;
    condvar_t empty;
    condvar_t full;

    uint32_t data[BOUNDED_QUEUE_CAPACITY];
    uint32_t head;
    uint32_t size;
} bounded_queue_t;

void bounded_queue_init(bounded_queue_t *bq) {
    spinlock_init(&bq->lock);
    condvar_init(&bq->empty);
    condvar_init(&bq->full);

    bq->head = 0;
    bq->size = 0;
}

void bounded_queue_push(bounded_queue_t *bq, uint32_t item) {
    spinlock_acquire(&bq->lock);

    while (bq->size == BOUNDED_QUEUE_CAPACITY) {
        condvar_wait(&bq->full, &bq->lock);
    }

    bq->data[(bq->head + bq->size) % BOUNDED_QUEUE_CAPACITY] = item;
    bq->size++;
    condvar_signal(&bq->empty);


    spinlock_release(&bq->lock);
}

uint32_t bounded_queue_pop(bounded_queue_t *bq)
{
    spinlock_acquire(&bq->lock);

    while (bq->size == 0) {
        condvar_wait(&bq->empty, &bq->lock);
    }

    uint32_t top_item = bq->data[bq->head];
    bq->head = (bq->head + 1) % BOUNDED_QUEUE_CAPACITY;
    --bq->size;
    condvar_signal(&bq->full);

    spinlock_release(&bq->lock);
    return top_item;
}

#endif  /* _USER_BOUNDED_QUEUE_H_ */
