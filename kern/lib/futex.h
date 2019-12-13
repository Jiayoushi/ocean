#ifndef _KERN_LIB_FUTEX_H_
#define _KERN_LIB_FUTEX_H_

#ifdef _KERN_

#include <lib/time.h>
#include <lib/spinlock.h>
#include <lib/x86.h>

// Arguments
#define FUTEX_PRIVATE_FLAG  (1 << 0)
#define FUTEX_LOCK_REALTIME (1 << 1)

// Operations
#define FUTEX_WAIT          (1 << 2)
#define FUTEX_WAKE          (1 << 3)
#define FUTEX_FD            (1 << 4)
#define FUTEX_REQUEUE       (1 << 5)
#define FUTEX_CMP_REQUEUE   (1 << 6)
#define FUTEX_WAKE_OP       (1 << 7)
#define FUTEX_WAIT_BITSET   (1 << 8)
#define FUTEX_WAKE_BITSET   (1 << 9)

int futex(uint32_t *uaddr, uint32_t op, uint32_t val1,
          const struct timespect *timeout,
          uint32_t *uaddr2, uint32_t val3);

void futex_init();

#endif  /* _KERN_ */

#endif  /* !_KERN_LIB_FUTEX_H_ */
