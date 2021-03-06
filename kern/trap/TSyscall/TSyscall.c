#include <lib/debug.h>
#include <lib/cv.h>
#include <lib/pmap.h>
#include <lib/types.h>
#include <lib/x86.h>
#include <lib/trap.h>
#include <lib/futex.h>
#include <lib/syscall.h>
#include <lib/time.h>
#include <dev/intr.h>
#include <pcpu/PCPUIntro/export.h>
#include <proc/PProc/export.h>

#include "import.h"

static char sys_buf[NUM_IDS][PAGESIZE];

/**
 * Copies a string from user into buffer and prints it to the screen.
 * This is called by the user level "printf" library as a system call.
 */
void sys_puts(tf_t *tf)
{
    unsigned int cur_pid;
    unsigned int str_uva, str_len;
    unsigned int remain, cur_pos, nbytes;

    cur_pid = get_curid();
    str_uva = syscall_get_arg2(tf);
    str_len = syscall_get_arg3(tf);

    if (!(VM_USERLO <= str_uva && str_uva + str_len <= VM_USERHI)) {
        syscall_set_errno(tf, E_INVAL_ADDR);
        return;
    }

    remain = str_len;
    cur_pos = str_uva;

    debug_lock();
    while (remain) {
        if (remain < PAGESIZE - 1)
            nbytes = remain;
        else
            nbytes = PAGESIZE - 1;

        if (pt_copyin(cur_pid, cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
            debug_unlock();
            syscall_set_errno(tf, E_MEM);
            return;
        }

        sys_buf[cur_pid][nbytes] = '\0';
        KERN_INFO("From cpu %d: %s", get_pcpu_idx(), sys_buf[cur_pid]);

        remain -= nbytes;
        cur_pos += nbytes;
    }
    debug_unlock();

    syscall_set_errno(tf, E_SUCC);
}

extern uint8_t _binary___obj_user_pingpong_ping_start[];
extern uint8_t _binary___obj_user_pingpong_pong_start[];
extern uint8_t _binary___obj_user_pingpong_ding_start[];

/**
 * Spawns a new child process.
 * The user level library function sys_spawn (defined in user/include/syscall.h)
 * takes two arguments [elf_id] and [quota], and returns the new child process id
 * or NUM_IDS (as failure), with appropriate error number.
 * Currently, we have three user processes defined in user/pingpong/ directory,
 * ping, pong, and ding.
 * The linker ELF addresses for those compiled binaries are defined above.
 * Since we do not yet have a file system implemented in mCertiKOS,
 * we statically load the ELF binaries into the memory based on the
 * first parameter [elf_id].
 * For example, ping, pong, and ding correspond to the elf_ids
 * 1, 2, 3, and 4, respectively.
 * If the parameter [elf_id] is none of these, then it should return
 * NUM_IDS with the error number E_INVAL_PID. The same error case apply
 * when the proc_create fails.
 * Otherwise, you should mark it as successful, and return the new child process id.
 */
void sys_spawn(tf_t *tf)
{
    unsigned int curid;
    unsigned int new_pid;
    unsigned int elf_id, quota;
    void *elf_addr;

    curid = get_curid();
    elf_id = syscall_get_arg2(tf);
    quota = syscall_get_arg3(tf);

    if (container_can_consume(curid, quota) == 0) {
        syscall_set_errno(tf, E_EXCEEDS_QUOTA);
        syscall_set_retval1(tf, NUM_IDS);
        return;
    }
    else if (NUM_IDS < curid * MAX_CHILDREN + 1 + MAX_CHILDREN) {
        syscall_set_errno(tf, E_MAX_NUM_CHILDEN_REACHED);
        syscall_set_retval1(tf, NUM_IDS);
        return;
    }
    else if (container_get_nchildren(curid) == MAX_CHILDREN) {
        syscall_set_errno(tf, E_INVAL_CHILD_ID);
        syscall_set_retval1(tf, NUM_IDS);
        return;
    }

    switch (elf_id) {
    case 1:
        elf_addr = _binary___obj_user_pingpong_ping_start;
        break;
    case 2:
        elf_addr = _binary___obj_user_pingpong_pong_start;
        break;
    case 3:
        elf_addr = _binary___obj_user_pingpong_ding_start;
        break;
    default:
        syscall_set_errno(tf, E_INVAL_PID);
        syscall_set_retval1(tf, NUM_IDS);
        return;
    }

    new_pid = proc_create(elf_addr, quota);

    if (new_pid == NUM_IDS) {
        syscall_set_errno(tf, E_INVAL_PID);
        syscall_set_retval1(tf, NUM_IDS);
    } else {
        syscall_set_errno(tf, E_SUCC);
        syscall_set_retval1(tf, new_pid);
    }
}

/**
 * Yields to another thread/process.
 * The user level library function sys_yield (defined in user/include/syscall.h)
 * does not take any argument and does not have any return values.
 * Do not forget to set the error number as E_SUCC.
 */
void sys_yield(tf_t *tf)
{
    thread_yield();
    syscall_set_errno(tf, E_SUCC);
}

BoundedBuffer bb;

void sys_produce(tf_t *tf)
{
    unsigned int val = syscall_get_arg2(tf);
    BB_enqueue(&bb, val);
    NO_INTR(
        KERN_DEBUG("CPU %d: Process %d: Produced %d\n", get_pcpu_idx(), get_curid(), val);
    );
    syscall_set_errno(tf, E_SUCC);
}

void sys_consume(tf_t *tf)
{
    unsigned int val = BB_dequeue(&bb);
    NO_INTR(
        KERN_DEBUG("CPU %d: Process %d: Consumed %d\n", get_pcpu_idx(), get_curid(), val);
    );
    syscall_set_errno(tf, E_SUCC);
    syscall_set_retval1(tf, val);
}


void sys_thread_join(tf_t *tf) {

}

void sys_thread_exit(tf_t *tf) {
    //thread_exit();
}

void sys_thread_create(tf_t *tf) {
    uintptr_t eip = syscall_get_arg2(tf);
    uintptr_t esp = syscall_get_arg3(tf);

    if (!(VM_USERLO <= eip && eip <= VM_USERHI)) {
        syscall_set_errno(tf, E_INVAL_ADDR);
        return;
    }

    if (!(VM_USERLO <= esp && esp <= VM_USERHI)) {
        syscall_set_errno(tf, E_INVAL_ADDR);
        return;
    }

    unsigned int pid = thread_create(eip, esp);
    if (pid != NUM_IDS) {
        syscall_set_errno(tf, E_SUCC);
    } else {
        syscall_set_errno(tf, E_INVAL_PID);
    }

    syscall_set_retval1(tf, pid);
}

void sys_getpid(tf_t *tf) {
    syscall_set_errno(tf, E_SUCC);
    syscall_set_retval1(tf, get_curid());
}

void sys_futex(tf_t *tf) {
    uint32_t *uaddr = (uint32_t *)syscall_get_arg2(tf);
    uint32_t op = syscall_get_arg3(tf);
    uint32_t val1 = syscall_get_arg4(tf);
    uint32_t *uaddr2 = (uint32_t *)syscall_get_arg5(tf);
    uint32_t val3 = syscall_get_arg6(tf);
 
    // TODO: Timeout is not passed in
    int ret = futex(uaddr, op, val1, NULL, uaddr2, val3);

    if (ret < 0) {
	syscall_set_errno(tf, ret);
    } else {
	syscall_set_errno(tf, E_SUCC);
	syscall_set_retval1(tf, ret);
    }
}
