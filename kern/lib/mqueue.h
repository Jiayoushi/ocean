#ifndef _KERN_LIB_MQUEUE_H_
#define _KERN_LIB_MQUEUE_H_

#ifdef _KERN_

#include <lib/x86.h>

#define MQUEUE_CAPACITY	    100

typedef struct {
    void *data[MQUEUE_CAPACITY];

    uint32_t head;
    uint32_t tail;
    uint32_t size;
} mqueue_t;

void *mqueue_get(mqueue_t *mq, uint32_t index);
void mqueue_init(mqueue_t *mq);
void mqueue_push(mqueue_t *mq, void *val);
void *mqueue_pop(mqueue_t *mq);
uint32_t mqueue_size(mqueue_t *mq);

#endif  /* _KERN_ */

#endif  /* !_KERN_LIB_MQUEUE_H_ */
