#include <lib/mqueue.h>
#include <lib/cv.h>
#include <lib/debug.h>
#include <lib/string.h>
#include <lib/thread.h>
#include <dev/intr.h>
#include <thread/PCurID/export.h>
#include <thread/PThread/export.h>

void mqueue_init(mqueue_t *mq) {
    mq->head = 0;
    mq->tail = 0;
    mq->size = 0;
}

void *mqueue_get(mqueue_t *mq, uint32_t index) {
    return mq->data[(mq->head + index) % mq->size];
}

void *mqueue_pop(mqueue_t *mq) {
    KERN_ASSERT(mq->size != 0);

    void *front = mq->data[mq->head];

    if (mq->head != mq->tail)
	mq->head = (mq->head + 1) % MQUEUE_CAPACITY;
    --mq->size;

    return front;
}

void mqueue_push(mqueue_t *mq, void *val) {
    KERN_ASSERT(mq->size != MQUEUE_CAPACITY);

    if (mq->head != mq->tail)
	mq->tail = (mq->tail + 1) % MQUEUE_CAPACITY;
    mq->data[mq->tail] = val;

    ++mq->size;
}

uint32_t mqueue_size(mqueue_t *mq) {
    return mq->size;
}
