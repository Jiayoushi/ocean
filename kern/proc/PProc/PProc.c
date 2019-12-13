#include <lib/elf.h>
#include <lib/debug.h>
#include <lib/string.h>
#include <lib/kstack.h>
#include <lib/gcc.h>
#include <lib/seg.h>
#include <lib/trap.h>
#include <lib/x86.h>
#include <pcpu/PCPUIntro/export.h>
#include <kern/thread/PThread/export.h>

#include "import.h"

extern tf_t uctx_pool[NUM_IDS];

void proc_start_user(void)
{
    unsigned int cur_pid;

    cur_pid = get_curid();

    kstack_switch(cur_pid);
    set_pdir_base(cur_pid);

    trap_return((void *) &uctx_pool[cur_pid]);
}

unsigned int proc_create(void *elf_addr, unsigned int quota)
{
    unsigned int pid, id;

    id = get_curid();
    pid = thread_spawn((void *) proc_start_user, id, quota);

    if (pid != NUM_IDS) {
        elf_load(elf_addr, pid);

        uctx_pool[pid].es = CPU_GDT_UDATA | 3;
        uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
        uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
        uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
        uctx_pool[pid].esp = VM_USERHI;
        uctx_pool[pid].eflags = FL_IF;
        uctx_pool[pid].eip = elf_entry(elf_addr);

        seg_init_proc(get_pcpu_idx(), pid);
    }

    return pid;
}

// Create a thread that shares the same memory space with the parent process
unsigned int thread_create(uintptr_t eip, uintptr_t esp) {
    unsigned int pid, id;

    static int cpu_idx = 1;
    cpu_idx = (cpu_idx + 1) % 3;
    if (cpu_idx == 0) {
	++cpu_idx;
    }

    id = get_curid();
    pid = thread_copy((void *)proc_start_user, id, cpu_idx);

    if (pid != NUM_IDS) {
        // Copy user context and set child return value
        memcpy(&uctx_pool[pid], &uctx_pool[id], sizeof(struct tf_t));

	uctx_pool[pid].eip = eip;
	uctx_pool[pid].esp = esp;

	seg_init_proc(cpu_idx, pid);
    }

    return pid;
}
