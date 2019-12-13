#include <gcc.h>
#include <stdio.h>
#include <syscall.h>
#include <x86.h>
#include <spinlock.h>

#include "thread.h"
#include "barrier.h"
#include "semaphore.h"
#include "bounded_queue.h"
#include "rwlock.h"

#define THREAD_STACK_SIZE 8192
#define NUM_THREADS	    4

// Tests
#define MUTEX			0
#define SPINLOCK		1
#define SEMAPHORE		2
#define BARRIER			3
#define CONCURRENCY		4
#define RWLOCK			5
#define BOUNDED_QUEUE		6
#define CMP_REQUEUE		7

#define TEST_ITERATION		50000


const char *test_name[100] = {"MUTEX", "SPINLOCK", "SEMAPHORE", "BARRIER", "CONCURRENCY", "RWLOCK", "BOUNDED_QUEUE", "CMP_REQUEUE"};
volatile uint32_t totals[100];

// Not used
struct balance {
    char name[32];
    int amount;
};


pid_t pids[NUM_THREADS];

spinlock_t spinlock;
mutex_t mutex;
barrier_t barrier;
semaphore_t semaphore;
rwlock_t rwlock;
bounded_queue_t bq;

void lock(int TEST_TYPE) {
    switch (TEST_TYPE) {
	case MUTEX:	   mutex_lock(&mutex); break;
	case SPINLOCK:	   spinlock_acquire(&spinlock); break;
	case SEMAPHORE:	   semaphore_p(&semaphore); break;
	default: PANIC("lock: no matching test_type %d", TEST_TYPE);
    }
}

void unlock(int TEST_TYPE) {
    switch (TEST_TYPE) {
	case MUTEX:	   mutex_unlock(&mutex);  break;
	case SPINLOCK:	   spinlock_release(&spinlock); break;
	case SEMAPHORE:	   semaphore_v(&semaphore); break;
	default: PANIC("unlock: no matching test_type");
    }
}

void print(int TEST_TYPE, const char *s) {
    if (getpid() == pids[0]) {
	printf("TEST_%s %s\n", test_name[TEST_TYPE], s);
    }
}

void concurrency_test() {
    int TEST_TYPE = CONCURRENCY;


    print(TEST_TYPE, "started");
    barrier_wait(&barrier);

    for (int i = 0; i < TEST_ITERATION; ++i) {
	++totals[TEST_TYPE];
    }

    printf("pid %u 100%\n", getpid());

    barrier_wait(&barrier);

    if (totals[TEST_TYPE] == NUM_THREADS * TEST_ITERATION) {
	PANIC("TEST_%s: failed, expect total should not be %u, got %u\n", test_name[TEST_TYPE], NUM_THREADS * TEST_ITERATION, totals[TEST_TYPE]);
    } else {
	print(TEST_TYPE, "passed.");
    }
}

void adding_test(int TEST_TYPE) {
    print(TEST_TYPE, "started");

    barrier_wait(&barrier);


    for (int i = 0; i < TEST_ITERATION; ++i) {
	lock(TEST_TYPE);

	++totals[TEST_TYPE];

	unlock(TEST_TYPE);
    }

    printf("pid %u 100%\n", getpid());

    barrier_wait(&barrier);

    if (totals[TEST_TYPE] != NUM_THREADS * TEST_ITERATION) {
	PANIC("TEST_%s: failed expect total %u got %u\n", test_name[TEST_TYPE], NUM_THREADS * TEST_ITERATION, totals[TEST_TYPE]);
    } else {
	print(TEST_TYPE, "passed");
    }
}

void barrier_test() {
    print(BARRIER, "started");

    pid_t pid = getpid();

    barrier_wait(&barrier);
    if (pid == pids[0]) printf("checkpoint1\n");

    barrier_wait(&barrier);
    if (pid == pids[0]) printf("checkpoint2\n");

    barrier_wait(&barrier);
    if (pid == pids[0]) printf("checkpoint3\n");

    barrier_wait(&barrier);
    if (pid == pids[0]) printf("checkpoint4\n");

    print(BARRIER, "passed");
}

void rwlock_test(int TEST_TYPE) {
    print(TEST_TYPE, "started");

    barrier_wait(&barrier);

    pid_t pid = getpid();

    uint32_t write_freq = 10000;
    uint32_t expected = TEST_ITERATION * 2 / write_freq;  // Only 2 writers

    if (pid == pids[0] || pid == pids[2]) {
	printf("pid %u writer\n", getpid());
    } else {
	printf("pid %u reader\n", getpid());
    }

    for (volatile int i = 0; i < TEST_ITERATION; ++i) {
	if (pid == pids[0] || pid == pids[2]) {
	    if (i % write_freq == 0) {
		rwlock_write(&rwlock);
		++totals[TEST_TYPE];
		rwlock_done_write(&rwlock);
	    }
	} else {
	    rwlock_read(&rwlock);
	    rwlock_done_read(&rwlock);
	}
    }

    printf("pid %u 100%\n", getpid());

    barrier_wait(&barrier);

    if (totals[TEST_TYPE] != expected) {
	PANIC("TEST_%s: failed expect total %u got %u\n", test_name[TEST_TYPE], expected, totals[TEST_TYPE]);
    } else {
	print(TEST_TYPE, "passed");
    }
}

void bounded_buffer_test(int TEST_TYPE) {
    print(TEST_TYPE, "started");

    barrier_wait(&barrier);

    pid_t pid = getpid();

    if (pid == pids[0]) {
	printf("pid %u producer\n", getpid());
    } else if (pid == pids[1]) {
	printf("pid %u consumer\n", getpid());
    }

    uint32_t iter = 1000;
    uint32_t expected = 55 * iter;
    for (int i = 0; i < iter; ++i) {
	for (int item = 1; item <= 10; ++item) {
	  if (pid == pids[0]) {
	      bounded_queue_push(&bq, item);
	  } else if (pid == pids[1]) {
	      totals[TEST_TYPE] += bounded_queue_pop(&bq);
	  }
	}
    }

    if (pid == pids[0] || pid == pids[1])
	printf("pid %u 100%\n", getpid());

    barrier_wait(&barrier);

    if (totals[TEST_TYPE] != expected) {
	PANIC("TEST_%s: failed expect total %u got %u\n", test_name[TEST_TYPE], expected, totals[TEST_TYPE]);
    } else {
	print(TEST_TYPE, "passed");
    }
}

uint32_t futex1 = 0;
uint32_t futex2 = 0;
volatile bool waker_in_place = 0;

void cmp_requeue_test(int TEST_TYPE) {
    print(TEST_TYPE, "started");

    volatile int woken1 = 0;
    volatile int woken2 = 0;
    pid_t pid = getpid();

    barrier_wait(&barrier);

    if (pid == pids[1] || pid == pids[2] || pid == pids[3]) {
	futex(&futex1, FUTEX_WAIT, 0, NULL, NULL, 0);
    } else {
	while (woken1 + woken2 != 3) {
	    delay(10000);
	    int ret1 = futex(&futex1, FUTEX_CMP_REQUEUE, 1, NULL, &futex2, 0);
	    if (ret1 < 0) {
		PANIC("TEST_%s: FUTEX_CMP_REQUEUE received %d\n", ret1);
	    }
	    woken1 += ret1;

	    delay(10000);
	    int ret2 = futex(&futex2, FUTEX_CMP_REQUEUE, 1, NULL, &futex1, 0);
	    if (ret2 < 0) {
		PANIC("TEST_%s: FUTEX_WAKE received %d\n", ret2);
	    }
	    woken2 += ret2;
	}
    }

    printf("pid %u 100%\n", getpid());

    barrier_wait(&barrier);

    print(TEST_TYPE, "passed");
}

void test(void *arg) {
    barrier_test();

    if (getpid() == pids[0]) {
	printf("pids[0] %u pids[1] %u pids[2] %u pids[3] %u\n", pids[0], pids[1], pids[2], pids[3]);
    }

    concurrency_test();
    adding_test(SPINLOCK);
    adding_test(MUTEX);
    rwlock_test(RWLOCK);
    adding_test(SEMAPHORE);
    bounded_buffer_test(BOUNDED_QUEUE);
    cmp_requeue_test(CMP_REQUEUE);

    if (getpid() == pids[0]) {
	printf("All tests passed.\n");
    }

    barrier_wait(&barrier);
    thread_exit();
    while (1) {
	;
    }
}


int main(int argc, char *argv[])
{
    printf("Thread Test\n");

    thread_init();
    mutex_init(&mutex);
    barrier_init(&barrier, NUM_THREADS);
    spinlock_init(&spinlock);
    semaphore_init(&semaphore, 1);
    rwlock_init(&rwlock);
    pids[0] = getpid();

    struct balance b1 = {"b1", 3200};
    struct balance b2 = {"b2", 2800};

    char stacks[3][THREAD_STACK_SIZE] gcc_aligned(THREAD_STACK_SIZE);

    // A total of 4 threads including this thread
    pids[1] = thread_create(test, (void *)&b1, stacks[0]);
    pids[2] = thread_create(test, (void *)&b1, stacks[1]);
    pids[3] = thread_create(test, (void *)&b2, stacks[2]);

    test((void *)&b1);

    while (1) {
	;
    }

    return 0;
}
