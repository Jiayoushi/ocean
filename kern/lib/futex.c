#include <lib/futex.h>
#include <lib/cv.h>
#include <lib/mqueue.h>
#include <lib/debug.h>
#include <lib/string.h>
#include <lib/thread.h>
#include <dev/intr.h>
#include <thread/PCurID/export.h>
#include <thread/PThread/export.h>
#include <pcpu/PCPUIntro/export.h>

#define TOTAL_FUTEX_QUEUE_NUM		    1000

/*
 * One futex_q per process
 *
 * futex:
 * pid: 
 */
struct futex_q {
    uint32_t futex;
    uint32_t pid;

    struct futex_q *prev;
    struct futex_q *next;
};

/*
 * One process can have multiple futexes, but it can only sleep on one
 * Each process has its futex_q as futex_q_pool[pid]
 */
static struct futex_q futex_q_pool[NUM_IDS];



/*
 * futex_queue: Each futex_queue is a queue of processes waiting on some futex
 * Their futexs are mapped into the same futex_queue, but they could
 * be waiting on essentially different futexs
 *
 *
 * waiters: a list of futex_q
 */

struct futex_queue {
    spinlock_t lock;

    struct futex_q *waiters_head;
    struct futex_q *waiters_tail;

    uint32_t waiters;
};

void futex_queue_init(struct futex_queue *queue) {
    spinlock_init(&queue->lock);

    queue->waiters_head = NULL;
    queue->waiters_tail = NULL;
    queue->waiters = 0;
}

void futex_queue_push(struct futex_queue *queue, struct futex_q *q) {
    if (queue->waiters_tail == NULL) {
	queue->waiters_tail = q;
	queue->waiters_head = q;
	q->prev = NULL;
    } else {
	queue->waiters_tail->next = q;
	q->prev = queue->waiters_tail;
	queue->waiters_tail = q;
    }

    q->next = NULL;
    ++queue->waiters;
}

void futex_queue_remove(struct futex_queue *queue, struct futex_q *q) {
    KERN_ASSERT(queue->waiters > 0);

    if (queue->waiters == 1) {
	queue->waiters_head = NULL;
	queue->waiters_tail = NULL;
    } else if (queue->waiters_head == q) {
	queue->waiters_head = q->next;
    } else if (queue->waiters_tail == q) {
	q->prev->next = NULL;
    } else {
	q->prev->next = q->next;
	q->next->prev = q->prev;
    }

    --queue->waiters;
}


/*
 * futex_queues: each process is hashed into one futex_queue
 * Each futex queue is a queue of futex_q that waits on some futex
 */

static struct futex_queue futex_queues[TOTAL_FUTEX_QUEUE_NUM];

static uint32_t hash_bucket(uint32_t *uaddr) {
    return (uint32_t)uaddr % TOTAL_FUTEX_QUEUE_NUM;
}

static struct futex_queue *get_hashed_futex_queue(uint32_t *uaddr) {
    return &futex_queues[hash_bucket(uaddr)];
}


static int futex_wait(uint32_t *uaddr, uint32_t val1,
		      const struct timespect *timeout) {
    struct futex_queue *queue = get_hashed_futex_queue(uaddr);

    spinlock_acquire(&queue->lock);

    if (*uaddr == val1) {
	struct futex_q *q = &futex_q_pool[get_curid()];
	q->futex = (uint32_t)uaddr;
	q->pid = get_curid();

	// Add to waiter list
	futex_queue_push(queue, q);

	//KERN_DEBUG("cpu %u pid %u waits on queue %u waiters_size %u \n", 
	//		get_pcpu_idx(), get_curid(), queue, queue->waiters);

	thread_suspend(&queue->lock, get_curid());
    } else {
	spinlock_release(&queue->lock);
    }

    return 0;
}

// WAKE
static int futex_wake(uint32_t *uaddr, uint32_t to_wake) {
    struct futex_queue *queue = get_hashed_futex_queue(uaddr);

    spinlock_acquire(&queue->lock);

    if (queue->waiters == 0) {
	spinlock_release(&queue->lock);
	return 0;
    }

    uint32_t woken = 0;
    for (struct futex_q *q = queue->waiters_head; q != NULL && woken < to_wake; q = q->next) {
	if (q->futex == (uint32_t)uaddr) {
	    futex_queue_remove(queue, q);
	    thread_ready(q->pid);
	    ++woken;
	}
    }

    spinlock_release(&queue->lock);
    return 0;
}

/*
 * Wake up "to_wake" number of waiters.
 *
 * If there are more threads waiting than woken, remove these waiters to the wait queue
 * of uaddr2.
 *
 * Return how many threads has been woken.
 */
static int futex_cmp_requeue(uint32_t *uaddr, uint32_t to_wake, uint32_t requeue_limit,
			     uint32_t *uaddr2, uint32_t val3) {
    struct futex_queue *queue = get_hashed_futex_queue(uaddr);
    struct futex_queue *queue2 = get_hashed_futex_queue(uaddr2);

    if (queue == queue2) {
	return -2;
    }

    spinlock_acquire(&queue->lock);
    spinlock_acquire(&queue2->lock);

    if (queue->waiters == 0) {
	spinlock_release(&queue->lock);
	spinlock_release(&queue2->lock);
	return 0;
    }

    /*
     * The whole operation is only started if the value pointed to by uaddr is still val3
     */
    if (*uaddr != val3) {
	spinlock_release(&queue->lock);
	spinlock_release(&queue2->lock);
	return -1;
    }
    
    struct futex_q *q = NULL;

    uint32_t woken = 0;
    for (q = queue->waiters_head; q != NULL && woken < to_wake; q = q->next) {
	if (q->futex == (uint32_t)uaddr) {
	    //KERN_DEBUG("cpu %u pid %u wakes up pid %u \n", get_pcpu_idx(), get_curid(), q->pid);
	    futex_queue_remove(queue, q);
	    thread_ready(q->pid);
	    ++woken;
	}
    }

    uint32_t requeued = 0;
    for ( ; q != NULL && requeued < requeue_limit; q = q->next) {
	if (q->futex == (uint32_t)uaddr) {
	    futex_queue_remove(queue, q);

	    q->futex = (uint32_t)uaddr2;
	    futex_queue_push(queue2, q);
	    ++requeued;
	}
    }

    spinlock_release(&queue2->lock);
    spinlock_release(&queue->lock);
    return woken;
}





/*
  Atomic operations are used in order to change the state of the futex 
  in the uncontended case without the overhead of a syscall. 
  In the contended cases, the kernel is invoked to put tasks to sleep 
  and wake them up.
*/

// The uaddr is used by the kernel to generate a unique "futex_futex" 
// to reference the futex.

gcc_inline uint32_t get_op(uint32_t op) {
    return op & 0xFFFFFFFC;
}

int futex(uint32_t *uaddr, uint32_t op, uint32_t val1,
          const struct timespect *timeout,
          uint32_t *uaddr2, uint32_t val3) {

    switch (get_op(op)) {
	case FUTEX_WAIT:
	    return futex_wait(uaddr, val1, NULL);
	case FUTEX_WAKE:
	    return futex_wake(uaddr, val1);
	case FUTEX_CMP_REQUEUE:
	    return futex_cmp_requeue(uaddr, val1, 0xFFFFFFFF, uaddr2, val3);
	default:
	    break;
    }

    return -1;  
}



/*
 *  Initialize every futex queue
 */
void futex_init() {
    for (uint32_t i = 0; i < TOTAL_FUTEX_QUEUE_NUM; ++i) {
	futex_queue_init(&futex_queues[i]);
    }
}
