
obj/user/thread/thread:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
    }
}


int main(int argc, char *argv[])
{
40000000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
40000004:	81 e4 00 e0 ff ff    	and    $0xffffe000,%esp
4000000a:	ff 71 fc             	pushl  -0x4(%ecx)
4000000d:	55                   	push   %ebp
4000000e:	89 e5                	mov    %esp,%ebp
40000010:	53                   	push   %ebx
40000011:	51                   	push   %ecx
    struct balance b2 = {"b2", 2800};

    char stacks[3][THREAD_STACK_SIZE] gcc_aligned(THREAD_STACK_SIZE);

    // A total of 4 threads including this thread
    pids[1] = thread_create(test, (void *)&b1, stacks[0]);
40000012:	8d 9d c0 7f ff ff    	lea    -0x8040(%ebp),%ebx
{
40000018:	81 ec fc 9f 00 00    	sub    $0x9ffc,%esp
    printf("Thread Test\n");
4000001e:	68 7e 33 00 40       	push   $0x4000337e
40000023:	e8 b8 03 00 00       	call   400003e0 <printf>
    thread_init();
40000028:	e8 33 21 00 00       	call   40002160 <thread_init>
    spinlock_init(&spinlock);
4000002d:	c7 04 24 e8 67 00 40 	movl   $0x400067e8,(%esp)
    MUTEX_LOCKED_NO_WAITERS	    = 1,
    MUTEX_LOCKED_WITH_WAITERS	    = 2
};

void mutex_init(mutex_t *mtx) {
    mtx->val = MUTEX_UNLOCKED;
40000034:	c7 05 e4 67 00 40 00 	movl   $0x0,0x400067e4
4000003b:	00 00 00 
4000003e:	c7 05 84 67 00 40 00 	movl   $0x0,0x40006784
40000045:	00 00 00 
} barrier_t;


void barrier_init(barrier_t *b, uint32_t needed) {
    mutex_init(&b->lock);
    b->event = 0;
40000048:	c7 05 88 67 00 40 00 	movl   $0x0,0x40006788
4000004f:	00 00 00 
    b->still_needed = needed;
40000052:	c7 05 8c 67 00 40 04 	movl   $0x4,0x4000678c
40000059:	00 00 00 
    b->initial_needed = needed;
4000005c:	c7 05 90 67 00 40 04 	movl   $0x4,0x40006790
40000063:	00 00 00 
40000066:	e8 d5 0a 00 00       	call   40000b40 <spinlock_init>
    volatile uint32_t waiting_readers;
    volatile uint32_t waiting_writers;
} rwlock_t;

void rwlock_init(rwlock_t *rw) {
    spinlock_init(&rw->lock);
4000006b:	c7 04 24 60 67 00 40 	movl   $0x40006760,(%esp)
    uint32_t v;
    uint32_t waiters;
} semaphore_t;

void semaphore_init(semaphore_t *s, int v) {
    s->v = v;
40000072:	c7 05 50 67 00 40 01 	movl   $0x1,0x40006750
40000079:	00 00 00 
    s->waiters = 0;
4000007c:	c7 05 54 67 00 40 00 	movl   $0x0,0x40006754
40000083:	00 00 00 
40000086:	e8 b5 0a 00 00       	call   40000b40 <spinlock_init>
    condvar_init(&rw->read_can_go);
    condvar_init(&rw->write_can_go);

    rw->active_readers = 0;
4000008b:	c7 05 74 67 00 40 00 	movl   $0x0,0x40006774
40000092:	00 00 00 
    uint32_t value;
    uint32_t previous;
} condvar_t;

void condvar_init(condvar_t *cv) {
    cv->value = 0;
40000095:	c7 05 64 67 00 40 00 	movl   $0x0,0x40006764
4000009c:	00 00 00 
    rw->active_writers = 0;
4000009f:	c7 05 78 67 00 40 00 	movl   $0x0,0x40006778
400000a6:	00 00 00 
    cv->previous = 0;
400000a9:	c7 05 68 67 00 40 00 	movl   $0x0,0x40006768
400000b0:	00 00 00 
    rw->waiting_readers = 0;
400000b3:	c7 05 7c 67 00 40 00 	movl   $0x0,0x4000677c
400000ba:	00 00 00 
    cv->value = 0;
400000bd:	c7 05 6c 67 00 40 00 	movl   $0x0,0x4000676c
400000c4:	00 00 00 
    cv->previous = 0;
400000c7:	c7 05 70 67 00 40 00 	movl   $0x0,0x40006770
400000ce:	00 00 00 
    rw->waiting_writers = 0;
400000d1:	c7 05 80 67 00 40 00 	movl   $0x0,0x40006780
400000d8:	00 00 00 
    pids[0] = getpid();
400000db:	e8 10 20 00 00       	call   400020f0 <getpid>
    pids[1] = thread_create(test, (void *)&b1, stacks[0]);
400000e0:	83 c4 0c             	add    $0xc,%esp
    struct balance b1 = {"b1", 3200};
400000e3:	c7 85 c0 7f ff ff 62 	movl   $0x3162,-0x8040(%ebp)
400000ea:	31 00 00 
    pids[0] = getpid();
400000ed:	a3 ec 67 00 40       	mov    %eax,0x400067ec
    pids[1] = thread_create(test, (void *)&b1, stacks[0]);
400000f2:	8d 85 08 80 ff ff    	lea    -0x7ff8(%ebp),%eax
400000f8:	50                   	push   %eax
400000f9:	53                   	push   %ebx
400000fa:	68 20 20 00 40       	push   $0x40002020
    struct balance b1 = {"b1", 3200};
400000ff:	c7 85 c4 7f ff ff 00 	movl   $0x0,-0x803c(%ebp)
40000106:	00 00 00 
40000109:	c7 85 c8 7f ff ff 00 	movl   $0x0,-0x8038(%ebp)
40000110:	00 00 00 
40000113:	c7 85 cc 7f ff ff 00 	movl   $0x0,-0x8034(%ebp)
4000011a:	00 00 00 
4000011d:	c7 85 d0 7f ff ff 00 	movl   $0x0,-0x8030(%ebp)
40000124:	00 00 00 
40000127:	c7 85 d4 7f ff ff 00 	movl   $0x0,-0x802c(%ebp)
4000012e:	00 00 00 
40000131:	c7 85 d8 7f ff ff 00 	movl   $0x0,-0x8028(%ebp)
40000138:	00 00 00 
4000013b:	c7 85 dc 7f ff ff 00 	movl   $0x0,-0x8024(%ebp)
40000142:	00 00 00 
40000145:	c7 85 e0 7f ff ff 80 	movl   $0xc80,-0x8020(%ebp)
4000014c:	0c 00 00 
    struct balance b2 = {"b2", 2800};
4000014f:	c7 85 e4 7f ff ff 62 	movl   $0x3262,-0x801c(%ebp)
40000156:	32 00 00 
40000159:	c7 85 e8 7f ff ff 00 	movl   $0x0,-0x8018(%ebp)
40000160:	00 00 00 
40000163:	c7 85 ec 7f ff ff 00 	movl   $0x0,-0x8014(%ebp)
4000016a:	00 00 00 
4000016d:	c7 85 f0 7f ff ff 00 	movl   $0x0,-0x8010(%ebp)
40000174:	00 00 00 
40000177:	c7 85 f4 7f ff ff 00 	movl   $0x0,-0x800c(%ebp)
4000017e:	00 00 00 
40000181:	c7 85 f8 7f ff ff 00 	movl   $0x0,-0x8008(%ebp)
40000188:	00 00 00 
4000018b:	c7 85 fc 7f ff ff 00 	movl   $0x0,-0x8004(%ebp)
40000192:	00 00 00 
40000195:	c7 85 00 80 ff ff 00 	movl   $0x0,-0x8000(%ebp)
4000019c:	00 00 00 
4000019f:	c7 85 04 80 ff ff f0 	movl   $0xaf0,-0x7ffc(%ebp)
400001a6:	0a 00 00 
    pids[1] = thread_create(test, (void *)&b1, stacks[0]);
400001a9:	e8 d2 1f 00 00       	call   40002180 <thread_create>
    pids[2] = thread_create(test, (void *)&b1, stacks[1]);
400001ae:	83 c4 0c             	add    $0xc,%esp
    pids[1] = thread_create(test, (void *)&b1, stacks[0]);
400001b1:	a3 f0 67 00 40       	mov    %eax,0x400067f0
    pids[2] = thread_create(test, (void *)&b1, stacks[1]);
400001b6:	8d 85 08 a0 ff ff    	lea    -0x5ff8(%ebp),%eax
400001bc:	50                   	push   %eax
400001bd:	53                   	push   %ebx
400001be:	68 20 20 00 40       	push   $0x40002020
400001c3:	e8 b8 1f 00 00       	call   40002180 <thread_create>
    pids[3] = thread_create(test, (void *)&b2, stacks[2]);
400001c8:	83 c4 0c             	add    $0xc,%esp
    pids[2] = thread_create(test, (void *)&b1, stacks[1]);
400001cb:	a3 f4 67 00 40       	mov    %eax,0x400067f4
    pids[3] = thread_create(test, (void *)&b2, stacks[2]);
400001d0:	8d 85 08 c0 ff ff    	lea    -0x3ff8(%ebp),%eax
400001d6:	50                   	push   %eax
400001d7:	8d 85 e4 7f ff ff    	lea    -0x801c(%ebp),%eax
400001dd:	50                   	push   %eax
400001de:	68 20 20 00 40       	push   $0x40002020
400001e3:	e8 98 1f 00 00       	call   40002180 <thread_create>

    test((void *)&b1);
400001e8:	89 1c 24             	mov    %ebx,(%esp)
    pids[3] = thread_create(test, (void *)&b2, stacks[2]);
400001eb:	a3 f8 67 00 40       	mov    %eax,0x400067f8
    test((void *)&b1);
400001f0:	e8 2b 1e 00 00       	call   40002020 <test>

400001f5 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary.
	 */
	testl	$0x0fffffff, %esp
400001f5:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
400001fb:	75 04                	jne    40000201 <args_exist>

400001fd <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
400001fd:	6a 00                	push   $0x0
	pushl	$0
400001ff:	6a 00                	push   $0x0

40000201 <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
40000201:	e8 fa fd ff ff       	call   40000000 <main>

	/* When returning, push the return value on the stack. */
	pushl	%eax
40000206:	50                   	push   %eax

40000207 <spin>:
spin:
	jmp	spin
40000207:	eb fe                	jmp    40000207 <spin>
40000209:	66 90                	xchg   %ax,%ax
4000020b:	66 90                	xchg   %ax,%ax
4000020d:	66 90                	xchg   %ax,%ax
4000020f:	90                   	nop

40000210 <debug>:
#include <proc.h>
#include <stdarg.h>
#include <stdio.h>

void debug(const char *file, int line, const char *fmt, ...)
{
40000210:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[D] %s:%d: ", file, line);
40000213:	ff 74 24 18          	pushl  0x18(%esp)
40000217:	ff 74 24 18          	pushl  0x18(%esp)
4000021b:	68 00 30 00 40       	push   $0x40003000
40000220:	e8 bb 01 00 00       	call   400003e0 <printf>
    vcprintf(fmt, ap);
40000225:	58                   	pop    %eax
40000226:	5a                   	pop    %edx
40000227:	8d 44 24 24          	lea    0x24(%esp),%eax
4000022b:	50                   	push   %eax
4000022c:	ff 74 24 24          	pushl  0x24(%esp)
40000230:	e8 4b 01 00 00       	call   40000380 <vcprintf>
    va_end(ap);
}
40000235:	83 c4 1c             	add    $0x1c,%esp
40000238:	c3                   	ret    
40000239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000240 <warn>:

void warn(const char *file, int line, const char *fmt, ...)
{
40000240:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[W] %s:%d: ", file, line);
40000243:	ff 74 24 18          	pushl  0x18(%esp)
40000247:	ff 74 24 18          	pushl  0x18(%esp)
4000024b:	68 0c 30 00 40       	push   $0x4000300c
40000250:	e8 8b 01 00 00       	call   400003e0 <printf>
    vcprintf(fmt, ap);
40000255:	58                   	pop    %eax
40000256:	5a                   	pop    %edx
40000257:	8d 44 24 24          	lea    0x24(%esp),%eax
4000025b:	50                   	push   %eax
4000025c:	ff 74 24 24          	pushl  0x24(%esp)
40000260:	e8 1b 01 00 00       	call   40000380 <vcprintf>
    va_end(ap);
}
40000265:	83 c4 1c             	add    $0x1c,%esp
40000268:	c3                   	ret    
40000269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000270 <panic>:

void panic(const char *file, int line, const char *fmt, ...)
{
40000270:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[P] %s:%d: ", file, line);
40000273:	ff 74 24 18          	pushl  0x18(%esp)
40000277:	ff 74 24 18          	pushl  0x18(%esp)
4000027b:	68 18 30 00 40       	push   $0x40003018
40000280:	e8 5b 01 00 00       	call   400003e0 <printf>
    vcprintf(fmt, ap);
40000285:	58                   	pop    %eax
40000286:	5a                   	pop    %edx
40000287:	8d 44 24 24          	lea    0x24(%esp),%eax
4000028b:	50                   	push   %eax
4000028c:	ff 74 24 24          	pushl  0x24(%esp)
40000290:	e8 eb 00 00 00       	call   40000380 <vcprintf>
40000295:	83 c4 10             	add    $0x10,%esp
40000298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000029f:	90                   	nop
    va_end(ap);

    while (1)
        yield();
400002a0:	e8 6b 08 00 00       	call   40000b10 <yield>
    while (1)
400002a5:	eb f9                	jmp    400002a0 <panic+0x30>
400002a7:	66 90                	xchg   %ax,%ax
400002a9:	66 90                	xchg   %ax,%ax
400002ab:	66 90                	xchg   %ax,%ax
400002ad:	66 90                	xchg   %ax,%ax
400002af:	90                   	nop

400002b0 <atoi>:
#include <stdlib.h>

int atoi(const char *buf, int *i)
{
400002b0:	55                   	push   %ebp
400002b1:	57                   	push   %edi
400002b2:	56                   	push   %esi
400002b3:	53                   	push   %ebx
400002b4:	8b 74 24 14          	mov    0x14(%esp),%esi
    int loc = 0;
    int numstart = 0;
    int acc = 0;
    int negative = 0;
    if (buf[loc] == '+')
400002b8:	0f be 06             	movsbl (%esi),%eax
400002bb:	3c 2b                	cmp    $0x2b,%al
400002bd:	74 71                	je     40000330 <atoi+0x80>
    int negative = 0;
400002bf:	31 ed                	xor    %ebp,%ebp
    int loc = 0;
400002c1:	31 ff                	xor    %edi,%edi
        loc++;
    else if (buf[loc] == '-') {
400002c3:	3c 2d                	cmp    $0x2d,%al
400002c5:	74 49                	je     40000310 <atoi+0x60>
        negative = 1;
        loc++;
    }
    numstart = loc;
    // no grab the numbers
    while ('0' <= buf[loc] && buf[loc] <= '9') {
400002c7:	8d 50 d0             	lea    -0x30(%eax),%edx
400002ca:	80 fa 09             	cmp    $0x9,%dl
400002cd:	77 57                	ja     40000326 <atoi+0x76>
400002cf:	89 f9                	mov    %edi,%ecx
    int acc = 0;
400002d1:	31 d2                	xor    %edx,%edx
400002d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400002d7:	90                   	nop
        acc = acc * 10 + (buf[loc] - '0');
400002d8:	8d 14 92             	lea    (%edx,%edx,4),%edx
        loc++;
400002db:	83 c1 01             	add    $0x1,%ecx
        acc = acc * 10 + (buf[loc] - '0');
400002de:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
    while ('0' <= buf[loc] && buf[loc] <= '9') {
400002e2:	0f be 04 0e          	movsbl (%esi,%ecx,1),%eax
400002e6:	8d 58 d0             	lea    -0x30(%eax),%ebx
400002e9:	80 fb 09             	cmp    $0x9,%bl
400002ec:	76 ea                	jbe    400002d8 <atoi+0x28>
    }
    if (numstart == loc) {
400002ee:	39 cf                	cmp    %ecx,%edi
400002f0:	74 34                	je     40000326 <atoi+0x76>
        // no numbers have actually been scanned
        return 0;
    }
    if (negative)
        acc = -acc;
400002f2:	89 d0                	mov    %edx,%eax
400002f4:	f7 d8                	neg    %eax
400002f6:	85 ed                	test   %ebp,%ebp
400002f8:	0f 45 d0             	cmovne %eax,%edx
    *i = acc;
400002fb:	8b 44 24 18          	mov    0x18(%esp),%eax
400002ff:	89 10                	mov    %edx,(%eax)
    return loc;
}
40000301:	89 c8                	mov    %ecx,%eax
40000303:	5b                   	pop    %ebx
40000304:	5e                   	pop    %esi
40000305:	5f                   	pop    %edi
40000306:	5d                   	pop    %ebp
40000307:	c3                   	ret    
40000308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000030f:	90                   	nop
        loc++;
40000310:	0f be 46 01          	movsbl 0x1(%esi),%eax
        negative = 1;
40000314:	bd 01 00 00 00       	mov    $0x1,%ebp
        loc++;
40000319:	bf 01 00 00 00       	mov    $0x1,%edi
    while ('0' <= buf[loc] && buf[loc] <= '9') {
4000031e:	8d 50 d0             	lea    -0x30(%eax),%edx
40000321:	80 fa 09             	cmp    $0x9,%dl
40000324:	76 a9                	jbe    400002cf <atoi+0x1f>
        return 0;
40000326:	31 c9                	xor    %ecx,%ecx
}
40000328:	5b                   	pop    %ebx
40000329:	5e                   	pop    %esi
4000032a:	89 c8                	mov    %ecx,%eax
4000032c:	5f                   	pop    %edi
4000032d:	5d                   	pop    %ebp
4000032e:	c3                   	ret    
4000032f:	90                   	nop
40000330:	0f be 46 01          	movsbl 0x1(%esi),%eax
    int negative = 0;
40000334:	31 ed                	xor    %ebp,%ebp
        loc++;
40000336:	bf 01 00 00 00       	mov    $0x1,%edi
4000033b:	eb 8a                	jmp    400002c7 <atoi+0x17>
4000033d:	66 90                	xchg   %ax,%ax
4000033f:	90                   	nop

40000340 <putch>:
    int cnt;            // total bytes printed so far
    char buf[MAX_BUF];
};

static void putch(int ch, struct printbuf *b)
{
40000340:	53                   	push   %ebx
40000341:	8b 54 24 0c          	mov    0xc(%esp),%edx
    b->buf[b->idx++] = ch;
40000345:	0f b6 5c 24 08       	movzbl 0x8(%esp),%ebx
4000034a:	8b 02                	mov    (%edx),%eax
4000034c:	8d 48 01             	lea    0x1(%eax),%ecx
4000034f:	89 0a                	mov    %ecx,(%edx)
40000351:	88 5c 02 08          	mov    %bl,0x8(%edx,%eax,1)
    if (b->idx == MAX_BUF - 1) {
40000355:	81 f9 ff 01 00 00    	cmp    $0x1ff,%ecx
4000035b:	75 14                	jne    40000371 <putch+0x31>
        b->buf[b->idx] = 0;
4000035d:	c6 82 07 02 00 00 00 	movb   $0x0,0x207(%edx)
        puts(b->buf, b->idx);
40000364:	8d 5a 08             	lea    0x8(%edx),%ebx

#include "time.h"

static gcc_inline void sys_puts(const char *s, size_t len)
{
    asm volatile ("int %0"
40000367:	31 c0                	xor    %eax,%eax
40000369:	cd 30                	int    $0x30
        b->idx = 0;
4000036b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    }
    b->cnt++;
40000371:	83 42 04 01          	addl   $0x1,0x4(%edx)
}
40000375:	5b                   	pop    %ebx
40000376:	c3                   	ret    
40000377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000037e:	66 90                	xchg   %ax,%ax

40000380 <vcprintf>:

int vcprintf(const char *fmt, va_list ap)
{
40000380:	53                   	push   %ebx
40000381:	81 ec 18 02 00 00    	sub    $0x218,%esp
    struct printbuf b;

    b.idx = 0;
40000387:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
4000038e:	00 
    b.cnt = 0;
4000038f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000396:	00 
    vprintfmt((void *) putch, &b, fmt, ap);
40000397:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
4000039e:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
400003a5:	8d 44 24 10          	lea    0x10(%esp),%eax
400003a9:	50                   	push   %eax
400003aa:	68 40 03 00 40       	push   $0x40000340
400003af:	e8 3c 01 00 00       	call   400004f0 <vprintfmt>

    b.buf[b.idx] = 0;
400003b4:	8b 4c 24 18          	mov    0x18(%esp),%ecx
400003b8:	8d 5c 24 20          	lea    0x20(%esp),%ebx
400003bc:	31 c0                	xor    %eax,%eax
400003be:	c6 44 0c 20 00       	movb   $0x0,0x20(%esp,%ecx,1)
400003c3:	cd 30                	int    $0x30
    puts(b.buf, b.idx);

    return b.cnt;
}
400003c5:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400003c9:	81 c4 28 02 00 00    	add    $0x228,%esp
400003cf:	5b                   	pop    %ebx
400003d0:	c3                   	ret    
400003d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400003d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400003df:	90                   	nop

400003e0 <printf>:

int printf(const char *fmt, ...)
{
400003e0:	83 ec 14             	sub    $0x14,%esp
    va_list ap;
    int cnt;

    va_start(ap, fmt);
    cnt = vcprintf(fmt, ap);
400003e3:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400003e7:	50                   	push   %eax
400003e8:	ff 74 24 1c          	pushl  0x1c(%esp)
400003ec:	e8 8f ff ff ff       	call   40000380 <vcprintf>
    va_end(ap);

    return cnt;
}
400003f1:	83 c4 1c             	add    $0x1c,%esp
400003f4:	c3                   	ret    
400003f5:	66 90                	xchg   %ax,%ax
400003f7:	66 90                	xchg   %ax,%ax
400003f9:	66 90                	xchg   %ax,%ax
400003fb:	66 90                	xchg   %ax,%ax
400003fd:	66 90                	xchg   %ax,%ax
400003ff:	90                   	nop

40000400 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
40000400:	55                   	push   %ebp
40000401:	57                   	push   %edi
40000402:	56                   	push   %esi
40000403:	89 d6                	mov    %edx,%esi
40000405:	53                   	push   %ebx
40000406:	89 c3                	mov    %eax,%ebx
40000408:	83 ec 1c             	sub    $0x1c,%esp
4000040b:	8b 54 24 30          	mov    0x30(%esp),%edx
4000040f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
40000413:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
4000041a:	00 
{
4000041b:	8b 44 24 38          	mov    0x38(%esp),%eax
    if (num >= base) {
4000041f:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
{
40000423:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
40000427:	8b 7c 24 40          	mov    0x40(%esp),%edi
4000042b:	83 ed 01             	sub    $0x1,%ebp
    if (num >= base) {
4000042e:	39 c2                	cmp    %eax,%edx
40000430:	1b 4c 24 04          	sbb    0x4(%esp),%ecx
{
40000434:	89 54 24 08          	mov    %edx,0x8(%esp)
    if (num >= base) {
40000438:	89 04 24             	mov    %eax,(%esp)
4000043b:	73 53                	jae    40000490 <printnum+0x90>
        printnum(putch, putdat, num / base, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (--width > 0)
4000043d:	85 ed                	test   %ebp,%ebp
4000043f:	7e 16                	jle    40000457 <printnum+0x57>
40000441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch(padc, putdat);
40000448:	83 ec 08             	sub    $0x8,%esp
4000044b:	56                   	push   %esi
4000044c:	57                   	push   %edi
4000044d:	ff d3                	call   *%ebx
        while (--width > 0)
4000044f:	83 c4 10             	add    $0x10,%esp
40000452:	83 ed 01             	sub    $0x1,%ebp
40000455:	75 f1                	jne    40000448 <printnum+0x48>
    }

    // then print this (the least significant) digit
    putch("0123456789abcdef"[num % base], putdat);
40000457:	89 74 24 34          	mov    %esi,0x34(%esp)
4000045b:	ff 74 24 04          	pushl  0x4(%esp)
4000045f:	ff 74 24 04          	pushl  0x4(%esp)
40000463:	ff 74 24 14          	pushl  0x14(%esp)
40000467:	ff 74 24 14          	pushl  0x14(%esp)
4000046b:	e8 b0 1e 00 00       	call   40002320 <__umoddi3>
40000470:	0f be 80 24 30 00 40 	movsbl 0x40003024(%eax),%eax
40000477:	89 44 24 40          	mov    %eax,0x40(%esp)
}
4000047b:	83 c4 2c             	add    $0x2c,%esp
    putch("0123456789abcdef"[num % base], putdat);
4000047e:	89 d8                	mov    %ebx,%eax
}
40000480:	5b                   	pop    %ebx
40000481:	5e                   	pop    %esi
40000482:	5f                   	pop    %edi
40000483:	5d                   	pop    %ebp
    putch("0123456789abcdef"[num % base], putdat);
40000484:	ff e0                	jmp    *%eax
40000486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000048d:	8d 76 00             	lea    0x0(%esi),%esi
        printnum(putch, putdat, num / base, base, width - 1, padc);
40000490:	83 ec 0c             	sub    $0xc,%esp
40000493:	57                   	push   %edi
40000494:	55                   	push   %ebp
40000495:	50                   	push   %eax
40000496:	83 ec 08             	sub    $0x8,%esp
40000499:	ff 74 24 24          	pushl  0x24(%esp)
4000049d:	ff 74 24 24          	pushl  0x24(%esp)
400004a1:	ff 74 24 34          	pushl  0x34(%esp)
400004a5:	ff 74 24 34          	pushl  0x34(%esp)
400004a9:	e8 62 1d 00 00       	call   40002210 <__udivdi3>
400004ae:	83 c4 18             	add    $0x18,%esp
400004b1:	52                   	push   %edx
400004b2:	89 f2                	mov    %esi,%edx
400004b4:	50                   	push   %eax
400004b5:	89 d8                	mov    %ebx,%eax
400004b7:	e8 44 ff ff ff       	call   40000400 <printnum>
400004bc:	83 c4 20             	add    $0x20,%esp
400004bf:	eb 96                	jmp    40000457 <printnum+0x57>
400004c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400004c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400004cf:	90                   	nop

400004d0 <sprintputch>:
    char *ebuf;
    int cnt;
};

static void sprintputch(int ch, struct sprintbuf *b)
{
400004d0:	8b 44 24 08          	mov    0x8(%esp),%eax
    b->cnt++;
400004d4:	83 40 08 01          	addl   $0x1,0x8(%eax)
    if (b->buf < b->ebuf)
400004d8:	8b 10                	mov    (%eax),%edx
400004da:	3b 50 04             	cmp    0x4(%eax),%edx
400004dd:	73 0b                	jae    400004ea <sprintputch+0x1a>
        *b->buf++ = ch;
400004df:	8d 4a 01             	lea    0x1(%edx),%ecx
400004e2:	89 08                	mov    %ecx,(%eax)
400004e4:	8b 44 24 04          	mov    0x4(%esp),%eax
400004e8:	88 02                	mov    %al,(%edx)
}
400004ea:	c3                   	ret    
400004eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400004ef:	90                   	nop

400004f0 <vprintfmt>:
{
400004f0:	55                   	push   %ebp
400004f1:	57                   	push   %edi
400004f2:	56                   	push   %esi
400004f3:	53                   	push   %ebx
400004f4:	83 ec 2c             	sub    $0x2c,%esp
400004f7:	8b 74 24 40          	mov    0x40(%esp),%esi
400004fb:	8b 6c 24 44          	mov    0x44(%esp),%ebp
400004ff:	8b 7c 24 48          	mov    0x48(%esp),%edi
        while ((ch = *(unsigned char *) fmt++) != '%') {
40000503:	0f b6 07             	movzbl (%edi),%eax
40000506:	8d 5f 01             	lea    0x1(%edi),%ebx
40000509:	83 f8 25             	cmp    $0x25,%eax
4000050c:	75 18                	jne    40000526 <vprintfmt+0x36>
4000050e:	eb 28                	jmp    40000538 <vprintfmt+0x48>
            putch(ch, putdat);
40000510:	83 ec 08             	sub    $0x8,%esp
        while ((ch = *(unsigned char *) fmt++) != '%') {
40000513:	83 c3 01             	add    $0x1,%ebx
            putch(ch, putdat);
40000516:	55                   	push   %ebp
40000517:	50                   	push   %eax
40000518:	ff d6                	call   *%esi
        while ((ch = *(unsigned char *) fmt++) != '%') {
4000051a:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
4000051e:	83 c4 10             	add    $0x10,%esp
40000521:	83 f8 25             	cmp    $0x25,%eax
40000524:	74 12                	je     40000538 <vprintfmt+0x48>
            if (ch == '\0')
40000526:	85 c0                	test   %eax,%eax
40000528:	75 e6                	jne    40000510 <vprintfmt+0x20>
}
4000052a:	83 c4 2c             	add    $0x2c,%esp
4000052d:	5b                   	pop    %ebx
4000052e:	5e                   	pop    %esi
4000052f:	5f                   	pop    %edi
40000530:	5d                   	pop    %ebp
40000531:	c3                   	ret    
40000532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        padc = ' ';
40000538:	c6 44 24 10 20       	movb   $0x20,0x10(%esp)
        precision = -1;
4000053d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
        altflag = 0;
40000542:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
40000549:	00 
        width = -1;
4000054a:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
40000551:	ff 
        lflag = 0;
40000552:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
40000559:	00 
        switch (ch = *(unsigned char *) fmt++) {
4000055a:	0f b6 0b             	movzbl (%ebx),%ecx
4000055d:	8d 7b 01             	lea    0x1(%ebx),%edi
40000560:	8d 41 dd             	lea    -0x23(%ecx),%eax
40000563:	3c 55                	cmp    $0x55,%al
40000565:	77 11                	ja     40000578 <vprintfmt+0x88>
40000567:	0f b6 c0             	movzbl %al,%eax
4000056a:	ff 24 85 3c 30 00 40 	jmp    *0x4000303c(,%eax,4)
40000571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch('%', putdat);
40000578:	83 ec 08             	sub    $0x8,%esp
            for (fmt--; fmt[-1] != '%'; fmt--)
4000057b:	89 df                	mov    %ebx,%edi
            putch('%', putdat);
4000057d:	55                   	push   %ebp
4000057e:	6a 25                	push   $0x25
40000580:	ff d6                	call   *%esi
            for (fmt--; fmt[-1] != '%'; fmt--)
40000582:	83 c4 10             	add    $0x10,%esp
40000585:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
40000589:	0f 84 74 ff ff ff    	je     40000503 <vprintfmt+0x13>
4000058f:	90                   	nop
40000590:	83 ef 01             	sub    $0x1,%edi
40000593:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
40000597:	75 f7                	jne    40000590 <vprintfmt+0xa0>
40000599:	e9 65 ff ff ff       	jmp    40000503 <vprintfmt+0x13>
4000059e:	66 90                	xchg   %ax,%ax
                ch = *fmt;
400005a0:	0f be 43 01          	movsbl 0x1(%ebx),%eax
        switch (ch = *(unsigned char *) fmt++) {
400005a4:	0f b6 d1             	movzbl %cl,%edx
400005a7:	89 fb                	mov    %edi,%ebx
                precision = precision * 10 + ch - '0';
400005a9:	83 ea 30             	sub    $0x30,%edx
                if (ch < '0' || ch > '9')
400005ac:	8d 48 d0             	lea    -0x30(%eax),%ecx
400005af:	83 f9 09             	cmp    $0x9,%ecx
400005b2:	77 19                	ja     400005cd <vprintfmt+0xdd>
400005b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (precision = 0;; ++fmt) {
400005b8:	83 c3 01             	add    $0x1,%ebx
                precision = precision * 10 + ch - '0';
400005bb:	8d 14 92             	lea    (%edx,%edx,4),%edx
400005be:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
                ch = *fmt;
400005c2:	0f be 03             	movsbl (%ebx),%eax
                if (ch < '0' || ch > '9')
400005c5:	8d 48 d0             	lea    -0x30(%eax),%ecx
400005c8:	83 f9 09             	cmp    $0x9,%ecx
400005cb:	76 eb                	jbe    400005b8 <vprintfmt+0xc8>
            if (width < 0)
400005cd:	8b 7c 24 04          	mov    0x4(%esp),%edi
400005d1:	85 ff                	test   %edi,%edi
400005d3:	79 85                	jns    4000055a <vprintfmt+0x6a>
                width = precision, precision = -1;
400005d5:	89 54 24 04          	mov    %edx,0x4(%esp)
400005d9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
400005de:	e9 77 ff ff ff       	jmp    4000055a <vprintfmt+0x6a>
            altflag = 1;
400005e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
400005ea:	00 
        switch (ch = *(unsigned char *) fmt++) {
400005eb:	89 fb                	mov    %edi,%ebx
            goto reswitch;
400005ed:	e9 68 ff ff ff       	jmp    4000055a <vprintfmt+0x6a>
            putch(ch, putdat);
400005f2:	83 ec 08             	sub    $0x8,%esp
400005f5:	55                   	push   %ebp
400005f6:	6a 25                	push   $0x25
400005f8:	ff d6                	call   *%esi
            break;
400005fa:	83 c4 10             	add    $0x10,%esp
400005fd:	e9 01 ff ff ff       	jmp    40000503 <vprintfmt+0x13>
            precision = va_arg(ap, int);
40000602:	8b 44 24 4c          	mov    0x4c(%esp),%eax
        switch (ch = *(unsigned char *) fmt++) {
40000606:	89 fb                	mov    %edi,%ebx
            precision = va_arg(ap, int);
40000608:	8b 10                	mov    (%eax),%edx
4000060a:	83 c0 04             	add    $0x4,%eax
4000060d:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto process_precision;
40000611:	eb ba                	jmp    400005cd <vprintfmt+0xdd>
            if (width < 0)
40000613:	8b 44 24 04          	mov    0x4(%esp),%eax
40000617:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (ch = *(unsigned char *) fmt++) {
4000061c:	89 fb                	mov    %edi,%ebx
4000061e:	85 c0                	test   %eax,%eax
40000620:	0f 49 c8             	cmovns %eax,%ecx
40000623:	89 4c 24 04          	mov    %ecx,0x4(%esp)
            goto reswitch;
40000627:	e9 2e ff ff ff       	jmp    4000055a <vprintfmt+0x6a>
            putch(va_arg(ap, int), putdat);
4000062c:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000630:	83 ec 08             	sub    $0x8,%esp
40000633:	55                   	push   %ebp
40000634:	8d 58 04             	lea    0x4(%eax),%ebx
40000637:	8b 44 24 58          	mov    0x58(%esp),%eax
4000063b:	ff 30                	pushl  (%eax)
4000063d:	ff d6                	call   *%esi
4000063f:	89 5c 24 5c          	mov    %ebx,0x5c(%esp)
            break;
40000643:	83 c4 10             	add    $0x10,%esp
40000646:	e9 b8 fe ff ff       	jmp    40000503 <vprintfmt+0x13>
        return va_arg(*ap, unsigned long long);
4000064b:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
4000064f:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, unsigned long long);
40000654:	8b 10                	mov    (%eax),%edx
    if (lflag >= 2)
40000656:	0f 8f c1 01 00 00    	jg     4000081d <vprintfmt+0x32d>
        return va_arg(*ap, unsigned long);
4000065c:	83 c0 04             	add    $0x4,%eax
4000065f:	31 c9                	xor    %ecx,%ecx
40000661:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000665:	b8 0a 00 00 00       	mov    $0xa,%eax
4000066a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            printnum(putch, putdat, num, base, width, padc);
40000670:	83 ec 0c             	sub    $0xc,%esp
40000673:	0f be 5c 24 1c       	movsbl 0x1c(%esp),%ebx
40000678:	53                   	push   %ebx
40000679:	ff 74 24 14          	pushl  0x14(%esp)
4000067d:	50                   	push   %eax
4000067e:	89 f0                	mov    %esi,%eax
40000680:	51                   	push   %ecx
40000681:	52                   	push   %edx
40000682:	89 ea                	mov    %ebp,%edx
40000684:	e8 77 fd ff ff       	call   40000400 <printnum>
            break;
40000689:	83 c4 20             	add    $0x20,%esp
4000068c:	e9 72 fe ff ff       	jmp    40000503 <vprintfmt+0x13>
            putch('0', putdat);
40000691:	83 ec 08             	sub    $0x8,%esp
40000694:	55                   	push   %ebp
40000695:	6a 30                	push   $0x30
40000697:	ff d6                	call   *%esi
            putch('x', putdat);
40000699:	58                   	pop    %eax
4000069a:	5a                   	pop    %edx
4000069b:	55                   	push   %ebp
4000069c:	6a 78                	push   $0x78
4000069e:	ff d6                	call   *%esi
            num = (unsigned long long)
400006a0:	8b 44 24 5c          	mov    0x5c(%esp),%eax
400006a4:	31 c9                	xor    %ecx,%ecx
            goto number;
400006a6:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)
400006a9:	8b 10                	mov    (%eax),%edx
                (uintptr_t) va_arg(ap, void *);
400006ab:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400006af:	83 c0 04             	add    $0x4,%eax
400006b2:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto number;
400006b6:	b8 10 00 00 00       	mov    $0x10,%eax
400006bb:	eb b3                	jmp    40000670 <vprintfmt+0x180>
        return va_arg(*ap, unsigned long long);
400006bd:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
400006c1:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, unsigned long long);
400006c6:	8b 10                	mov    (%eax),%edx
    if (lflag >= 2)
400006c8:	0f 8f 63 01 00 00    	jg     40000831 <vprintfmt+0x341>
        return va_arg(*ap, unsigned long);
400006ce:	83 c0 04             	add    $0x4,%eax
400006d1:	31 c9                	xor    %ecx,%ecx
400006d3:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400006d7:	b8 10 00 00 00       	mov    $0x10,%eax
400006dc:	eb 92                	jmp    40000670 <vprintfmt+0x180>
    if (lflag >= 2)
400006de:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, long long);
400006e3:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
400006e7:	0f 8f 58 01 00 00    	jg     40000845 <vprintfmt+0x355>
        return va_arg(*ap, long);
400006ed:	8b 4c 24 4c          	mov    0x4c(%esp),%ecx
400006f1:	83 c0 04             	add    $0x4,%eax
400006f4:	8b 11                	mov    (%ecx),%edx
400006f6:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400006fa:	89 d3                	mov    %edx,%ebx
400006fc:	89 d1                	mov    %edx,%ecx
400006fe:	c1 fb 1f             	sar    $0x1f,%ebx
            if ((long long) num < 0) {
40000701:	85 db                	test   %ebx,%ebx
40000703:	0f 88 65 01 00 00    	js     4000086e <vprintfmt+0x37e>
            num = getint(&ap, lflag);
40000709:	89 ca                	mov    %ecx,%edx
4000070b:	b8 0a 00 00 00       	mov    $0xa,%eax
40000710:	89 d9                	mov    %ebx,%ecx
40000712:	e9 59 ff ff ff       	jmp    40000670 <vprintfmt+0x180>
            lflag++;
40000717:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
        switch (ch = *(unsigned char *) fmt++) {
4000071c:	89 fb                	mov    %edi,%ebx
            goto reswitch;
4000071e:	e9 37 fe ff ff       	jmp    4000055a <vprintfmt+0x6a>
            putch('X', putdat);
40000723:	83 ec 08             	sub    $0x8,%esp
40000726:	55                   	push   %ebp
40000727:	6a 58                	push   $0x58
40000729:	ff d6                	call   *%esi
            putch('X', putdat);
4000072b:	59                   	pop    %ecx
4000072c:	5b                   	pop    %ebx
4000072d:	55                   	push   %ebp
4000072e:	6a 58                	push   $0x58
40000730:	ff d6                	call   *%esi
            putch('X', putdat);
40000732:	58                   	pop    %eax
40000733:	5a                   	pop    %edx
40000734:	55                   	push   %ebp
40000735:	6a 58                	push   $0x58
40000737:	ff d6                	call   *%esi
            break;
40000739:	83 c4 10             	add    $0x10,%esp
4000073c:	e9 c2 fd ff ff       	jmp    40000503 <vprintfmt+0x13>
            if ((p = va_arg(ap, char *)) == NULL)
40000741:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000745:	8b 4c 24 04          	mov    0x4(%esp),%ecx
40000749:	83 c0 04             	add    $0x4,%eax
4000074c:	80 7c 24 10 2d       	cmpb   $0x2d,0x10(%esp)
40000751:	89 44 24 14          	mov    %eax,0x14(%esp)
40000755:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000759:	8b 18                	mov    (%eax),%ebx
4000075b:	0f 95 c0             	setne  %al
4000075e:	85 c9                	test   %ecx,%ecx
40000760:	0f 9f c1             	setg   %cl
40000763:	21 c8                	and    %ecx,%eax
40000765:	85 db                	test   %ebx,%ebx
40000767:	0f 84 31 01 00 00    	je     4000089e <vprintfmt+0x3ae>
            if (width > 0 && padc != '-')
4000076d:	8d 4b 01             	lea    0x1(%ebx),%ecx
40000770:	84 c0                	test   %al,%al
40000772:	0f 85 5b 01 00 00    	jne    400008d3 <vprintfmt+0x3e3>
                 (ch = *p++) != '\0' && (precision < 0
40000778:	0f be 1b             	movsbl (%ebx),%ebx
4000077b:	89 d8                	mov    %ebx,%eax
            for (;
4000077d:	85 db                	test   %ebx,%ebx
4000077f:	74 72                	je     400007f3 <vprintfmt+0x303>
40000781:	89 5c 24 10          	mov    %ebx,0x10(%esp)
40000785:	89 cb                	mov    %ecx,%ebx
40000787:	8b 4c 24 10          	mov    0x10(%esp),%ecx
4000078b:	89 74 24 40          	mov    %esi,0x40(%esp)
4000078f:	89 d6                	mov    %edx,%esi
40000791:	89 7c 24 48          	mov    %edi,0x48(%esp)
40000795:	8b 7c 24 04          	mov    0x4(%esp),%edi
40000799:	eb 2a                	jmp    400007c5 <vprintfmt+0x2d5>
4000079b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000079f:	90                   	nop
                if (altflag && (ch < ' ' || ch > '~'))
400007a0:	83 e8 20             	sub    $0x20,%eax
400007a3:	83 f8 5e             	cmp    $0x5e,%eax
400007a6:	76 31                	jbe    400007d9 <vprintfmt+0x2e9>
                    putch('?', putdat);
400007a8:	83 ec 08             	sub    $0x8,%esp
400007ab:	55                   	push   %ebp
400007ac:	6a 3f                	push   $0x3f
400007ae:	ff 54 24 50          	call   *0x50(%esp)
400007b2:	83 c4 10             	add    $0x10,%esp
                 (ch = *p++) != '\0' && (precision < 0
400007b5:	0f be 03             	movsbl (%ebx),%eax
400007b8:	83 c3 01             	add    $0x1,%ebx
                                         || --precision >= 0); width--)
400007bb:	83 ef 01             	sub    $0x1,%edi
                 (ch = *p++) != '\0' && (precision < 0
400007be:	0f be c8             	movsbl %al,%ecx
            for (;
400007c1:	85 c9                	test   %ecx,%ecx
400007c3:	74 22                	je     400007e7 <vprintfmt+0x2f7>
                 (ch = *p++) != '\0' && (precision < 0
400007c5:	85 f6                	test   %esi,%esi
400007c7:	78 08                	js     400007d1 <vprintfmt+0x2e1>
                                         || --precision >= 0); width--)
400007c9:	83 ee 01             	sub    $0x1,%esi
400007cc:	83 fe ff             	cmp    $0xffffffff,%esi
400007cf:	74 16                	je     400007e7 <vprintfmt+0x2f7>
                if (altflag && (ch < ' ' || ch > '~'))
400007d1:	8b 54 24 08          	mov    0x8(%esp),%edx
400007d5:	85 d2                	test   %edx,%edx
400007d7:	75 c7                	jne    400007a0 <vprintfmt+0x2b0>
                    putch(ch, putdat);
400007d9:	83 ec 08             	sub    $0x8,%esp
400007dc:	55                   	push   %ebp
400007dd:	51                   	push   %ecx
400007de:	ff 54 24 50          	call   *0x50(%esp)
400007e2:	83 c4 10             	add    $0x10,%esp
400007e5:	eb ce                	jmp    400007b5 <vprintfmt+0x2c5>
400007e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
400007eb:	8b 74 24 40          	mov    0x40(%esp),%esi
400007ef:	8b 7c 24 48          	mov    0x48(%esp),%edi
            for (; width > 0; width--)
400007f3:	8b 4c 24 04          	mov    0x4(%esp),%ecx
400007f7:	8b 5c 24 04          	mov    0x4(%esp),%ebx
400007fb:	85 c9                	test   %ecx,%ecx
400007fd:	7e 11                	jle    40000810 <vprintfmt+0x320>
400007ff:	90                   	nop
                putch(' ', putdat);
40000800:	83 ec 08             	sub    $0x8,%esp
40000803:	55                   	push   %ebp
40000804:	6a 20                	push   $0x20
40000806:	ff d6                	call   *%esi
            for (; width > 0; width--)
40000808:	83 c4 10             	add    $0x10,%esp
4000080b:	83 eb 01             	sub    $0x1,%ebx
4000080e:	75 f0                	jne    40000800 <vprintfmt+0x310>
            if ((p = va_arg(ap, char *)) == NULL)
40000810:	8b 44 24 14          	mov    0x14(%esp),%eax
40000814:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000818:	e9 e6 fc ff ff       	jmp    40000503 <vprintfmt+0x13>
        return va_arg(*ap, unsigned long long);
4000081d:	8b 48 04             	mov    0x4(%eax),%ecx
40000820:	83 c0 08             	add    $0x8,%eax
40000823:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000827:	b8 0a 00 00 00       	mov    $0xa,%eax
4000082c:	e9 3f fe ff ff       	jmp    40000670 <vprintfmt+0x180>
40000831:	8b 48 04             	mov    0x4(%eax),%ecx
40000834:	83 c0 08             	add    $0x8,%eax
40000837:	89 44 24 4c          	mov    %eax,0x4c(%esp)
4000083b:	b8 10 00 00 00       	mov    $0x10,%eax
40000840:	e9 2b fe ff ff       	jmp    40000670 <vprintfmt+0x180>
        return va_arg(*ap, long long);
40000845:	8b 08                	mov    (%eax),%ecx
40000847:	8b 58 04             	mov    0x4(%eax),%ebx
4000084a:	83 c0 08             	add    $0x8,%eax
4000084d:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000851:	e9 ab fe ff ff       	jmp    40000701 <vprintfmt+0x211>
            padc = '-';
40000856:	c6 44 24 10 2d       	movb   $0x2d,0x10(%esp)
        switch (ch = *(unsigned char *) fmt++) {
4000085b:	89 fb                	mov    %edi,%ebx
4000085d:	e9 f8 fc ff ff       	jmp    4000055a <vprintfmt+0x6a>
40000862:	c6 44 24 10 30       	movb   $0x30,0x10(%esp)
40000867:	89 fb                	mov    %edi,%ebx
40000869:	e9 ec fc ff ff       	jmp    4000055a <vprintfmt+0x6a>
4000086e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
                putch('-', putdat);
40000872:	83 ec 08             	sub    $0x8,%esp
40000875:	89 5c 24 14          	mov    %ebx,0x14(%esp)
40000879:	55                   	push   %ebp
4000087a:	6a 2d                	push   $0x2d
4000087c:	ff d6                	call   *%esi
                num = -(long long) num;
4000087e:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000882:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
40000886:	b8 0a 00 00 00       	mov    $0xa,%eax
4000088b:	89 ca                	mov    %ecx,%edx
4000088d:	89 d9                	mov    %ebx,%ecx
4000088f:	f7 da                	neg    %edx
40000891:	83 d1 00             	adc    $0x0,%ecx
40000894:	83 c4 10             	add    $0x10,%esp
40000897:	f7 d9                	neg    %ecx
40000899:	e9 d2 fd ff ff       	jmp    40000670 <vprintfmt+0x180>
                 (ch = *p++) != '\0' && (precision < 0
4000089e:	bb 28 00 00 00       	mov    $0x28,%ebx
400008a3:	b9 36 30 00 40       	mov    $0x40003036,%ecx
            if (width > 0 && padc != '-')
400008a8:	84 c0                	test   %al,%al
400008aa:	0f 85 9d 00 00 00    	jne    4000094d <vprintfmt+0x45d>
400008b0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
                 (ch = *p++) != '\0' && (precision < 0
400008b4:	b8 28 00 00 00       	mov    $0x28,%eax
400008b9:	89 cb                	mov    %ecx,%ebx
400008bb:	b9 28 00 00 00       	mov    $0x28,%ecx
400008c0:	89 74 24 40          	mov    %esi,0x40(%esp)
400008c4:	89 d6                	mov    %edx,%esi
400008c6:	89 7c 24 48          	mov    %edi,0x48(%esp)
400008ca:	8b 7c 24 04          	mov    0x4(%esp),%edi
400008ce:	e9 f2 fe ff ff       	jmp    400007c5 <vprintfmt+0x2d5>
400008d3:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
                for (width -= strnlen(p, precision); width > 0; width--)
400008d7:	83 ec 08             	sub    $0x8,%esp
400008da:	52                   	push   %edx
400008db:	89 54 24 24          	mov    %edx,0x24(%esp)
400008df:	53                   	push   %ebx
400008e0:	e8 eb 02 00 00       	call   40000bd0 <strnlen>
400008e5:	29 44 24 14          	sub    %eax,0x14(%esp)
400008e9:	8b 4c 24 14          	mov    0x14(%esp),%ecx
400008ed:	83 c4 10             	add    $0x10,%esp
400008f0:	8b 54 24 18          	mov    0x18(%esp),%edx
400008f4:	85 c9                	test   %ecx,%ecx
400008f6:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
400008fa:	7e 3e                	jle    4000093a <vprintfmt+0x44a>
400008fc:	0f be 44 24 10       	movsbl 0x10(%esp),%eax
40000901:	89 4c 24 18          	mov    %ecx,0x18(%esp)
40000905:	89 54 24 10          	mov    %edx,0x10(%esp)
40000909:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
4000090d:	8b 5c 24 04          	mov    0x4(%esp),%ebx
40000911:	89 7c 24 48          	mov    %edi,0x48(%esp)
40000915:	89 c7                	mov    %eax,%edi
                    putch(padc, putdat);
40000917:	83 ec 08             	sub    $0x8,%esp
4000091a:	55                   	push   %ebp
4000091b:	57                   	push   %edi
4000091c:	ff d6                	call   *%esi
                for (width -= strnlen(p, precision); width > 0; width--)
4000091e:	83 c4 10             	add    $0x10,%esp
40000921:	83 eb 01             	sub    $0x1,%ebx
40000924:	75 f1                	jne    40000917 <vprintfmt+0x427>
40000926:	8b 54 24 10          	mov    0x10(%esp),%edx
4000092a:	8b 4c 24 18          	mov    0x18(%esp),%ecx
4000092e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
40000932:	8b 7c 24 48          	mov    0x48(%esp),%edi
40000936:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
                 (ch = *p++) != '\0' && (precision < 0
4000093a:	0f be 03             	movsbl (%ebx),%eax
4000093d:	0f be d8             	movsbl %al,%ebx
            for (;
40000940:	85 db                	test   %ebx,%ebx
40000942:	0f 85 39 fe ff ff    	jne    40000781 <vprintfmt+0x291>
40000948:	e9 c3 fe ff ff       	jmp    40000810 <vprintfmt+0x320>
                for (width -= strnlen(p, precision); width > 0; width--)
4000094d:	83 ec 08             	sub    $0x8,%esp
                p = "(null)";
40000950:	bb 35 30 00 40       	mov    $0x40003035,%ebx
                for (width -= strnlen(p, precision); width > 0; width--)
40000955:	52                   	push   %edx
40000956:	89 54 24 24          	mov    %edx,0x24(%esp)
4000095a:	68 35 30 00 40       	push   $0x40003035
4000095f:	e8 6c 02 00 00       	call   40000bd0 <strnlen>
40000964:	29 44 24 14          	sub    %eax,0x14(%esp)
40000968:	8b 44 24 14          	mov    0x14(%esp),%eax
4000096c:	83 c4 10             	add    $0x10,%esp
4000096f:	b9 36 30 00 40       	mov    $0x40003036,%ecx
40000974:	8b 54 24 18          	mov    0x18(%esp),%edx
40000978:	85 c0                	test   %eax,%eax
4000097a:	7f 80                	jg     400008fc <vprintfmt+0x40c>
                 (ch = *p++) != '\0' && (precision < 0
4000097c:	bb 28 00 00 00       	mov    $0x28,%ebx
40000981:	e9 2a ff ff ff       	jmp    400008b0 <vprintfmt+0x3c0>
40000986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000098d:	8d 76 00             	lea    0x0(%esi),%esi

40000990 <printfmt>:
{
40000990:	83 ec 0c             	sub    $0xc,%esp
    vprintfmt(putch, putdat, fmt, ap);
40000993:	8d 44 24 1c          	lea    0x1c(%esp),%eax
40000997:	50                   	push   %eax
40000998:	ff 74 24 1c          	pushl  0x1c(%esp)
4000099c:	ff 74 24 1c          	pushl  0x1c(%esp)
400009a0:	ff 74 24 1c          	pushl  0x1c(%esp)
400009a4:	e8 47 fb ff ff       	call   400004f0 <vprintfmt>
}
400009a9:	83 c4 1c             	add    $0x1c,%esp
400009ac:	c3                   	ret    
400009ad:	8d 76 00             	lea    0x0(%esi),%esi

400009b0 <vsprintf>:

int vsprintf(char *buf, const char *fmt, va_list ap)
{
400009b0:	83 ec 1c             	sub    $0x1c,%esp
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
400009b3:	8b 44 24 20          	mov    0x20(%esp),%eax
400009b7:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
400009be:	ff 
400009bf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400009c6:	00 
400009c7:	89 44 24 04          	mov    %eax,0x4(%esp)

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
400009cb:	ff 74 24 28          	pushl  0x28(%esp)
400009cf:	ff 74 24 28          	pushl  0x28(%esp)
400009d3:	8d 44 24 0c          	lea    0xc(%esp),%eax
400009d7:	50                   	push   %eax
400009d8:	68 d0 04 00 40       	push   $0x400004d0
400009dd:	e8 0e fb ff ff       	call   400004f0 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
400009e2:	8b 44 24 14          	mov    0x14(%esp),%eax
400009e6:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
400009e9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400009ed:	83 c4 2c             	add    $0x2c,%esp
400009f0:	c3                   	ret    
400009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400009f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400009ff:	90                   	nop

40000a00 <sprintf>:

int sprintf(char *buf, const char *fmt, ...)
{
40000a00:	83 ec 1c             	sub    $0x1c,%esp
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
40000a03:	8b 44 24 20          	mov    0x20(%esp),%eax
40000a07:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
40000a0e:	ff 
40000a0f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000a16:	00 
40000a17:	89 44 24 04          	mov    %eax,0x4(%esp)
    vprintfmt((void *) sprintputch, &b, fmt, ap);
40000a1b:	8d 44 24 28          	lea    0x28(%esp),%eax
40000a1f:	50                   	push   %eax
40000a20:	ff 74 24 28          	pushl  0x28(%esp)
40000a24:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000a28:	50                   	push   %eax
40000a29:	68 d0 04 00 40       	push   $0x400004d0
40000a2e:	e8 bd fa ff ff       	call   400004f0 <vprintfmt>
    *b.buf = '\0';
40000a33:	8b 44 24 14          	mov    0x14(%esp),%eax
40000a37:	c6 00 00             	movb   $0x0,(%eax)
    va_start(ap, fmt);
    rc = vsprintf(buf, fmt, ap);
    va_end(ap);

    return rc;
}
40000a3a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000a3e:	83 c4 2c             	add    $0x2c,%esp
40000a41:	c3                   	ret    
40000a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000a50 <vsnprintf>:

int vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000a50:	83 ec 1c             	sub    $0x1c,%esp
40000a53:	8b 44 24 20          	mov    0x20(%esp),%eax
    struct sprintbuf b = { buf, buf + n - 1, 0 };
40000a57:	8b 54 24 24          	mov    0x24(%esp),%edx
40000a5b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000a62:	00 
40000a63:	89 44 24 04          	mov    %eax,0x4(%esp)
40000a67:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
40000a6b:	89 44 24 08          	mov    %eax,0x8(%esp)

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
40000a6f:	ff 74 24 2c          	pushl  0x2c(%esp)
40000a73:	ff 74 24 2c          	pushl  0x2c(%esp)
40000a77:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000a7b:	50                   	push   %eax
40000a7c:	68 d0 04 00 40       	push   $0x400004d0
40000a81:	e8 6a fa ff ff       	call   400004f0 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
40000a86:	8b 44 24 14          	mov    0x14(%esp),%eax
40000a8a:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
40000a8d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000a91:	83 c4 2c             	add    $0x2c,%esp
40000a94:	c3                   	ret    
40000a95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000aa0 <snprintf>:

int snprintf(char *buf, int n, const char *fmt, ...)
{
40000aa0:	83 ec 1c             	sub    $0x1c,%esp
40000aa3:	8b 44 24 20          	mov    0x20(%esp),%eax
    struct sprintbuf b = { buf, buf + n - 1, 0 };
40000aa7:	8b 54 24 24          	mov    0x24(%esp),%edx
40000aab:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000ab2:	00 
40000ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
40000ab7:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
40000abb:	89 44 24 08          	mov    %eax,0x8(%esp)
    vprintfmt((void *) sprintputch, &b, fmt, ap);
40000abf:	8d 44 24 2c          	lea    0x2c(%esp),%eax
40000ac3:	50                   	push   %eax
40000ac4:	ff 74 24 2c          	pushl  0x2c(%esp)
40000ac8:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000acc:	50                   	push   %eax
40000acd:	68 d0 04 00 40       	push   $0x400004d0
40000ad2:	e8 19 fa ff ff       	call   400004f0 <vprintfmt>
    *b.buf = '\0';
40000ad7:	8b 44 24 14          	mov    0x14(%esp),%eax
40000adb:	c6 00 00             	movb   $0x0,(%eax)
    va_start(ap, fmt);
    rc = vsnprintf(buf, n, fmt, ap);
    va_end(ap);

    return rc;
}
40000ade:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000ae2:	83 c4 2c             	add    $0x2c,%esp
40000ae5:	c3                   	ret    
40000ae6:	66 90                	xchg   %ax,%ax
40000ae8:	66 90                	xchg   %ax,%ax
40000aea:	66 90                	xchg   %ax,%ax
40000aec:	66 90                	xchg   %ax,%ax
40000aee:	66 90                	xchg   %ax,%ax

40000af0 <spawn>:
#include <proc.h>
#include <syscall.h>
#include <types.h>

pid_t spawn(uintptr_t exec, unsigned int quota)
{
40000af0:	53                   	push   %ebx
static gcc_inline pid_t sys_spawn(unsigned int elf_id, unsigned int quota)
{
    int errno;
    pid_t pid;

    asm volatile ("int %2"
40000af1:	b8 01 00 00 00       	mov    $0x1,%eax
40000af6:	8b 5c 24 08          	mov    0x8(%esp),%ebx
40000afa:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000afe:	cd 30                	int    $0x30
                    "a" (SYS_spawn),
                    "b" (elf_id),
                    "c" (quota)
                  : "cc", "memory");

    return errno ? -1 : pid;
40000b00:	85 c0                	test   %eax,%eax
40000b02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000b07:	0f 44 c3             	cmove  %ebx,%eax
    return sys_spawn(exec, quota);
}
40000b0a:	5b                   	pop    %ebx
40000b0b:	c3                   	ret    
40000b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000b10 <yield>:
}

static gcc_inline void sys_yield(void)
{
    asm volatile ("int %0"
40000b10:	b8 02 00 00 00       	mov    $0x2,%eax
40000b15:	cd 30                	int    $0x30

void yield(void)
{
    sys_yield();
}
40000b17:	c3                   	ret    
40000b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b1f:	90                   	nop

40000b20 <produce>:

void produce(unsigned int val)
{
40000b20:	53                   	push   %ebx
                  : "cc", "memory");
}

static gcc_inline void sys_produce(unsigned int val)
{
    asm volatile ("int %0"
40000b21:	b8 03 00 00 00       	mov    $0x3,%eax
40000b26:	8b 5c 24 08          	mov    0x8(%esp),%ebx
40000b2a:	cd 30                	int    $0x30
    sys_produce(val);
}
40000b2c:	5b                   	pop    %ebx
40000b2d:	c3                   	ret    
40000b2e:	66 90                	xchg   %ax,%ax

40000b30 <consume>:

unsigned int consume(void)
{
40000b30:	53                   	push   %ebx
}

static gcc_inline unsigned int sys_consume(void)
{
    unsigned int val;
    asm volatile ("int %1"
40000b31:	b8 04 00 00 00       	mov    $0x4,%eax
40000b36:	cd 30                	int    $0x30
40000b38:	89 d8                	mov    %ebx,%eax
    return sys_consume();
}
40000b3a:	5b                   	pop    %ebx
40000b3b:	c3                   	ret    
40000b3c:	66 90                	xchg   %ax,%ax
40000b3e:	66 90                	xchg   %ax,%ax

40000b40 <spinlock_init>:
    return result;
}

void spinlock_init(spinlock_t *lk)
{
    *lk = 0;
40000b40:	8b 44 24 04          	mov    0x4(%esp),%eax
40000b44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
40000b4a:	c3                   	ret    
40000b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000b4f:	90                   	nop

40000b50 <spinlock_acquire>:

void spinlock_acquire(spinlock_t *lk)
{
40000b50:	8b 54 24 04          	mov    0x4(%esp),%edx
    asm volatile ("lock; xchgl %0, %1"
40000b54:	b8 01 00 00 00       	mov    $0x1,%eax
40000b59:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
40000b5c:	85 c0                	test   %eax,%eax
40000b5e:	74 13                	je     40000b73 <spinlock_acquire+0x23>
    asm volatile ("lock; xchgl %0, %1"
40000b60:	b9 01 00 00 00       	mov    $0x1,%ecx
40000b65:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("pause");
40000b68:	f3 90                	pause  
    asm volatile ("lock; xchgl %0, %1"
40000b6a:	89 c8                	mov    %ecx,%eax
40000b6c:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
40000b6f:	85 c0                	test   %eax,%eax
40000b71:	75 f5                	jne    40000b68 <spinlock_acquire+0x18>
}
40000b73:	c3                   	ret    
40000b74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000b7f:	90                   	nop

40000b80 <spinlock_release>:

// Release the lock.
void spinlock_release(spinlock_t *lk)
{
40000b80:	8b 54 24 04          	mov    0x4(%esp),%edx
}

// Check whether this cpu is holding the lock.
bool spinlock_holding(spinlock_t *lk)
{
    return *lk;
40000b84:	8b 02                	mov    (%edx),%eax
    if (spinlock_holding(lk) == FALSE)
40000b86:	84 c0                	test   %al,%al
40000b88:	74 05                	je     40000b8f <spinlock_release+0xf>
    asm volatile ("lock; xchgl %0, %1"
40000b8a:	31 c0                	xor    %eax,%eax
40000b8c:	f0 87 02             	lock xchg %eax,(%edx)
}
40000b8f:	c3                   	ret    

40000b90 <spinlock_holding>:
    return *lk;
40000b90:	8b 44 24 04          	mov    0x4(%esp),%eax
40000b94:	8b 00                	mov    (%eax),%eax
}
40000b96:	c3                   	ret    
40000b97:	66 90                	xchg   %ax,%ax
40000b99:	66 90                	xchg   %ax,%ax
40000b9b:	66 90                	xchg   %ax,%ax
40000b9d:	66 90                	xchg   %ax,%ax
40000b9f:	90                   	nop

40000ba0 <strlen>:
#include <string.h>
#include <types.h>

int strlen(const char *s)
{
40000ba0:	8b 54 24 04          	mov    0x4(%esp),%edx
    int n;

    for (n = 0; *s != '\0'; s++)
40000ba4:	31 c0                	xor    %eax,%eax
40000ba6:	80 3a 00             	cmpb   $0x0,(%edx)
40000ba9:	74 15                	je     40000bc0 <strlen+0x20>
40000bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000baf:	90                   	nop
        n++;
40000bb0:	83 c0 01             	add    $0x1,%eax
    for (n = 0; *s != '\0'; s++)
40000bb3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000bb7:	75 f7                	jne    40000bb0 <strlen+0x10>
40000bb9:	c3                   	ret    
40000bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return n;
}
40000bc0:	c3                   	ret    
40000bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bcf:	90                   	nop

40000bd0 <strnlen>:

int strnlen(const char *s, size_t size)
{
40000bd0:	8b 54 24 08          	mov    0x8(%esp),%edx
40000bd4:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000bd8:	31 c0                	xor    %eax,%eax
40000bda:	85 d2                	test   %edx,%edx
40000bdc:	75 09                	jne    40000be7 <strnlen+0x17>
40000bde:	eb 10                	jmp    40000bf0 <strnlen+0x20>
        n++;
40000be0:	83 c0 01             	add    $0x1,%eax
    for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000be3:	39 d0                	cmp    %edx,%eax
40000be5:	74 09                	je     40000bf0 <strnlen+0x20>
40000be7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000beb:	75 f3                	jne    40000be0 <strnlen+0x10>
40000bed:	c3                   	ret    
40000bee:	66 90                	xchg   %ax,%ax
    return n;
}
40000bf0:	c3                   	ret    
40000bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bff:	90                   	nop

40000c00 <strcpy>:

char *strcpy(char *dst, const char *src)
{
40000c00:	53                   	push   %ebx
40000c01:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    char *ret;

    ret = dst;
    while ((*dst++ = *src++) != '\0')
40000c05:	31 c0                	xor    %eax,%eax
{
40000c07:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
40000c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000c0f:	90                   	nop
    while ((*dst++ = *src++) != '\0')
40000c10:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000c14:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000c17:	83 c0 01             	add    $0x1,%eax
40000c1a:	84 d2                	test   %dl,%dl
40000c1c:	75 f2                	jne    40000c10 <strcpy+0x10>
        /* do nothing */ ;
    return ret;
}
40000c1e:	89 c8                	mov    %ecx,%eax
40000c20:	5b                   	pop    %ebx
40000c21:	c3                   	ret    
40000c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000c30 <strncpy>:

char *strncpy(char *dst, const char *src, size_t size)
{
40000c30:	56                   	push   %esi
40000c31:	53                   	push   %ebx
40000c32:	8b 5c 24 14          	mov    0x14(%esp),%ebx
40000c36:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000c3a:	8b 44 24 10          	mov    0x10(%esp),%eax
    size_t i;
    char *ret;

    ret = dst;
    for (i = 0; i < size; i++) {
40000c3e:	85 db                	test   %ebx,%ebx
40000c40:	74 21                	je     40000c63 <strncpy+0x33>
40000c42:	01 f3                	add    %esi,%ebx
40000c44:	89 f2                	mov    %esi,%edx
40000c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c4d:	8d 76 00             	lea    0x0(%esi),%esi
        *dst++ = *src;
40000c50:	0f b6 08             	movzbl (%eax),%ecx
40000c53:	83 c2 01             	add    $0x1,%edx
40000c56:	88 4a ff             	mov    %cl,-0x1(%edx)
        // If strlen(src) < size, null-pad 'dst' out to 'size' chars
        if (*src != '\0')
            src++;
40000c59:	80 38 01             	cmpb   $0x1,(%eax)
40000c5c:	83 d8 ff             	sbb    $0xffffffff,%eax
    for (i = 0; i < size; i++) {
40000c5f:	39 da                	cmp    %ebx,%edx
40000c61:	75 ed                	jne    40000c50 <strncpy+0x20>
    }
    return ret;
}
40000c63:	89 f0                	mov    %esi,%eax
40000c65:	5b                   	pop    %ebx
40000c66:	5e                   	pop    %esi
40000c67:	c3                   	ret    
40000c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c6f:	90                   	nop

40000c70 <strlcpy>:

size_t strlcpy(char *dst, const char *src, size_t size)
{
40000c70:	56                   	push   %esi
40000c71:	53                   	push   %ebx
40000c72:	8b 44 24 14          	mov    0x14(%esp),%eax
40000c76:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000c7a:	8b 4c 24 10          	mov    0x10(%esp),%ecx
    char *dst_in;

    dst_in = dst;
    if (size > 0) {
40000c7e:	85 c0                	test   %eax,%eax
40000c80:	74 29                	je     40000cab <strlcpy+0x3b>
        while (--size > 0 && *src != '\0')
40000c82:	89 f2                	mov    %esi,%edx
40000c84:	83 e8 01             	sub    $0x1,%eax
40000c87:	74 1f                	je     40000ca8 <strlcpy+0x38>
40000c89:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
40000c8c:	eb 0f                	jmp    40000c9d <strlcpy+0x2d>
40000c8e:	66 90                	xchg   %ax,%ax
            *dst++ = *src++;
40000c90:	83 c2 01             	add    $0x1,%edx
40000c93:	83 c1 01             	add    $0x1,%ecx
40000c96:	88 42 ff             	mov    %al,-0x1(%edx)
        while (--size > 0 && *src != '\0')
40000c99:	39 da                	cmp    %ebx,%edx
40000c9b:	74 07                	je     40000ca4 <strlcpy+0x34>
40000c9d:	0f b6 01             	movzbl (%ecx),%eax
40000ca0:	84 c0                	test   %al,%al
40000ca2:	75 ec                	jne    40000c90 <strlcpy+0x20>
40000ca4:	89 d0                	mov    %edx,%eax
40000ca6:	29 f0                	sub    %esi,%eax
        *dst = '\0';
40000ca8:	c6 02 00             	movb   $0x0,(%edx)
    }
    return dst - dst_in;
}
40000cab:	5b                   	pop    %ebx
40000cac:	5e                   	pop    %esi
40000cad:	c3                   	ret    
40000cae:	66 90                	xchg   %ax,%ax

40000cb0 <strcmp>:

int strcmp(const char *p, const char *q)
{
40000cb0:	53                   	push   %ebx
40000cb1:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000cb5:	8b 54 24 0c          	mov    0xc(%esp),%edx
    while (*p && *p == *q)
40000cb9:	0f b6 01             	movzbl (%ecx),%eax
40000cbc:	0f b6 1a             	movzbl (%edx),%ebx
40000cbf:	84 c0                	test   %al,%al
40000cc1:	75 16                	jne    40000cd9 <strcmp+0x29>
40000cc3:	eb 23                	jmp    40000ce8 <strcmp+0x38>
40000cc5:	8d 76 00             	lea    0x0(%esi),%esi
40000cc8:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        p++, q++;
40000ccc:	83 c1 01             	add    $0x1,%ecx
40000ccf:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
40000cd2:	0f b6 1a             	movzbl (%edx),%ebx
40000cd5:	84 c0                	test   %al,%al
40000cd7:	74 0f                	je     40000ce8 <strcmp+0x38>
40000cd9:	38 d8                	cmp    %bl,%al
40000cdb:	74 eb                	je     40000cc8 <strcmp+0x18>
    return (int) ((unsigned char) *p - (unsigned char) *q);
40000cdd:	29 d8                	sub    %ebx,%eax
}
40000cdf:	5b                   	pop    %ebx
40000ce0:	c3                   	ret    
40000ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000ce8:	31 c0                	xor    %eax,%eax
    return (int) ((unsigned char) *p - (unsigned char) *q);
40000cea:	29 d8                	sub    %ebx,%eax
}
40000cec:	5b                   	pop    %ebx
40000ced:	c3                   	ret    
40000cee:	66 90                	xchg   %ax,%ax

40000cf0 <strncmp>:

int strncmp(const char *p, const char *q, size_t n)
{
40000cf0:	56                   	push   %esi
40000cf1:	53                   	push   %ebx
40000cf2:	8b 74 24 14          	mov    0x14(%esp),%esi
40000cf6:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000cfa:	8b 44 24 10          	mov    0x10(%esp),%eax
    while (n > 0 && *p && *p == *q)
40000cfe:	85 f6                	test   %esi,%esi
40000d00:	74 2e                	je     40000d30 <strncmp+0x40>
40000d02:	01 c6                	add    %eax,%esi
40000d04:	eb 18                	jmp    40000d1e <strncmp+0x2e>
40000d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d0d:	8d 76 00             	lea    0x0(%esi),%esi
40000d10:	38 da                	cmp    %bl,%dl
40000d12:	75 14                	jne    40000d28 <strncmp+0x38>
        n--, p++, q++;
40000d14:	83 c0 01             	add    $0x1,%eax
40000d17:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q)
40000d1a:	39 f0                	cmp    %esi,%eax
40000d1c:	74 12                	je     40000d30 <strncmp+0x40>
40000d1e:	0f b6 11             	movzbl (%ecx),%edx
40000d21:	0f b6 18             	movzbl (%eax),%ebx
40000d24:	84 d2                	test   %dl,%dl
40000d26:	75 e8                	jne    40000d10 <strncmp+0x20>
    if (n == 0)
        return 0;
    else
        return (int) ((unsigned char) *p - (unsigned char) *q);
40000d28:	0f b6 c2             	movzbl %dl,%eax
40000d2b:	29 d8                	sub    %ebx,%eax
}
40000d2d:	5b                   	pop    %ebx
40000d2e:	5e                   	pop    %esi
40000d2f:	c3                   	ret    
        return 0;
40000d30:	31 c0                	xor    %eax,%eax
}
40000d32:	5b                   	pop    %ebx
40000d33:	5e                   	pop    %esi
40000d34:	c3                   	ret    
40000d35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000d40 <strchr>:

char *strchr(const char *s, char c)
{
40000d40:	8b 44 24 04          	mov    0x4(%esp),%eax
40000d44:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
    for (; *s; s++)
40000d49:	0f b6 10             	movzbl (%eax),%edx
40000d4c:	84 d2                	test   %dl,%dl
40000d4e:	75 13                	jne    40000d63 <strchr+0x23>
40000d50:	eb 1e                	jmp    40000d70 <strchr+0x30>
40000d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000d58:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000d5c:	83 c0 01             	add    $0x1,%eax
40000d5f:	84 d2                	test   %dl,%dl
40000d61:	74 0d                	je     40000d70 <strchr+0x30>
        if (*s == c)
40000d63:	38 d1                	cmp    %dl,%cl
40000d65:	75 f1                	jne    40000d58 <strchr+0x18>
            return (char *) s;
    return 0;
}
40000d67:	c3                   	ret    
40000d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d6f:	90                   	nop
    return 0;
40000d70:	31 c0                	xor    %eax,%eax
}
40000d72:	c3                   	ret    
40000d73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000d80 <strfind>:

char *strfind(const char *s, char c)
{
40000d80:	53                   	push   %ebx
40000d81:	8b 44 24 08          	mov    0x8(%esp),%eax
40000d85:	8b 54 24 0c          	mov    0xc(%esp),%edx
    for (; *s; s++)
40000d89:	0f b6 18             	movzbl (%eax),%ebx
        if (*s == c)
40000d8c:	38 d3                	cmp    %dl,%bl
40000d8e:	74 1f                	je     40000daf <strfind+0x2f>
40000d90:	89 d1                	mov    %edx,%ecx
40000d92:	84 db                	test   %bl,%bl
40000d94:	75 0e                	jne    40000da4 <strfind+0x24>
40000d96:	eb 17                	jmp    40000daf <strfind+0x2f>
40000d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d9f:	90                   	nop
40000da0:	84 d2                	test   %dl,%dl
40000da2:	74 0b                	je     40000daf <strfind+0x2f>
    for (; *s; s++)
40000da4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000da8:	83 c0 01             	add    $0x1,%eax
        if (*s == c)
40000dab:	38 ca                	cmp    %cl,%dl
40000dad:	75 f1                	jne    40000da0 <strfind+0x20>
            break;
    return (char *) s;
}
40000daf:	5b                   	pop    %ebx
40000db0:	c3                   	ret    
40000db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000dbf:	90                   	nop

40000dc0 <strtol>:

long strtol(const char *s, char **endptr, int base)
{
40000dc0:	55                   	push   %ebp
40000dc1:	57                   	push   %edi
40000dc2:	56                   	push   %esi
40000dc3:	53                   	push   %ebx
40000dc4:	83 ec 04             	sub    $0x4,%esp
40000dc7:	8b 44 24 20          	mov    0x20(%esp),%eax
40000dcb:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000dcf:	8b 74 24 1c          	mov    0x1c(%esp),%esi
40000dd3:	89 04 24             	mov    %eax,(%esp)
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
40000dd6:	0f b6 01             	movzbl (%ecx),%eax
40000dd9:	3c 09                	cmp    $0x9,%al
40000ddb:	74 0b                	je     40000de8 <strtol+0x28>
40000ddd:	3c 20                	cmp    $0x20,%al
40000ddf:	75 16                	jne    40000df7 <strtol+0x37>
40000de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000de8:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        s++;
40000dec:	83 c1 01             	add    $0x1,%ecx
    while (*s == ' ' || *s == '\t')
40000def:	3c 20                	cmp    $0x20,%al
40000df1:	74 f5                	je     40000de8 <strtol+0x28>
40000df3:	3c 09                	cmp    $0x9,%al
40000df5:	74 f1                	je     40000de8 <strtol+0x28>

    // plus/minus sign
    if (*s == '+')
40000df7:	3c 2b                	cmp    $0x2b,%al
40000df9:	0f 84 a1 00 00 00    	je     40000ea0 <strtol+0xe0>
    int neg = 0;
40000dff:	31 ff                	xor    %edi,%edi
        s++;
    else if (*s == '-')
40000e01:	3c 2d                	cmp    $0x2d,%al
40000e03:	0f 84 87 00 00 00    	je     40000e90 <strtol+0xd0>
        s++, neg = 1;

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000e09:	0f be 11             	movsbl (%ecx),%edx
40000e0c:	f7 04 24 ef ff ff ff 	testl  $0xffffffef,(%esp)
40000e13:	75 17                	jne    40000e2c <strtol+0x6c>
40000e15:	80 fa 30             	cmp    $0x30,%dl
40000e18:	0f 84 92 00 00 00    	je     40000eb0 <strtol+0xf0>
        s += 2, base = 16;
    else if (base == 0 && s[0] == '0')
40000e1e:	8b 2c 24             	mov    (%esp),%ebp
40000e21:	85 ed                	test   %ebp,%ebp
40000e23:	75 07                	jne    40000e2c <strtol+0x6c>
        s++, base = 8;
    else if (base == 0)
        base = 10;
40000e25:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
40000e2c:	31 c0                	xor    %eax,%eax
40000e2e:	eb 15                	jmp    40000e45 <strtol+0x85>
    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9')
            dig = *s - '0';
40000e30:	83 ea 30             	sub    $0x30,%edx
            dig = *s - 'a' + 10;
        else if (*s >= 'A' && *s <= 'Z')
            dig = *s - 'A' + 10;
        else
            break;
        if (dig >= base)
40000e33:	8b 1c 24             	mov    (%esp),%ebx
40000e36:	39 da                	cmp    %ebx,%edx
40000e38:	7d 29                	jge    40000e63 <strtol+0xa3>
            break;
        s++, val = (val * base) + dig;
40000e3a:	0f af c3             	imul   %ebx,%eax
40000e3d:	83 c1 01             	add    $0x1,%ecx
40000e40:	01 d0                	add    %edx,%eax
    while (1) {
40000e42:	0f be 11             	movsbl (%ecx),%edx
        if (*s >= '0' && *s <= '9')
40000e45:	8d 6a d0             	lea    -0x30(%edx),%ebp
40000e48:	89 eb                	mov    %ebp,%ebx
40000e4a:	80 fb 09             	cmp    $0x9,%bl
40000e4d:	76 e1                	jbe    40000e30 <strtol+0x70>
        else if (*s >= 'a' && *s <= 'z')
40000e4f:	8d 6a 9f             	lea    -0x61(%edx),%ebp
40000e52:	89 eb                	mov    %ebp,%ebx
40000e54:	80 fb 19             	cmp    $0x19,%bl
40000e57:	77 27                	ja     40000e80 <strtol+0xc0>
        if (dig >= base)
40000e59:	8b 1c 24             	mov    (%esp),%ebx
            dig = *s - 'a' + 10;
40000e5c:	83 ea 57             	sub    $0x57,%edx
        if (dig >= base)
40000e5f:	39 da                	cmp    %ebx,%edx
40000e61:	7c d7                	jl     40000e3a <strtol+0x7a>
        // we don't properly detect overflow!
    }

    if (endptr)
40000e63:	85 f6                	test   %esi,%esi
40000e65:	74 02                	je     40000e69 <strtol+0xa9>
        *endptr = (char *) s;
40000e67:	89 0e                	mov    %ecx,(%esi)
    return (neg ? -val : val);
40000e69:	89 c2                	mov    %eax,%edx
40000e6b:	f7 da                	neg    %edx
40000e6d:	85 ff                	test   %edi,%edi
40000e6f:	0f 45 c2             	cmovne %edx,%eax
}
40000e72:	83 c4 04             	add    $0x4,%esp
40000e75:	5b                   	pop    %ebx
40000e76:	5e                   	pop    %esi
40000e77:	5f                   	pop    %edi
40000e78:	5d                   	pop    %ebp
40000e79:	c3                   	ret    
40000e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        else if (*s >= 'A' && *s <= 'Z')
40000e80:	8d 6a bf             	lea    -0x41(%edx),%ebp
40000e83:	89 eb                	mov    %ebp,%ebx
40000e85:	80 fb 19             	cmp    $0x19,%bl
40000e88:	77 d9                	ja     40000e63 <strtol+0xa3>
            dig = *s - 'A' + 10;
40000e8a:	83 ea 37             	sub    $0x37,%edx
40000e8d:	eb a4                	jmp    40000e33 <strtol+0x73>
40000e8f:	90                   	nop
        s++, neg = 1;
40000e90:	83 c1 01             	add    $0x1,%ecx
40000e93:	bf 01 00 00 00       	mov    $0x1,%edi
40000e98:	e9 6c ff ff ff       	jmp    40000e09 <strtol+0x49>
40000e9d:	8d 76 00             	lea    0x0(%esi),%esi
        s++;
40000ea0:	83 c1 01             	add    $0x1,%ecx
    int neg = 0;
40000ea3:	31 ff                	xor    %edi,%edi
40000ea5:	e9 5f ff ff ff       	jmp    40000e09 <strtol+0x49>
40000eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000eb0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
40000eb4:	3c 78                	cmp    $0x78,%al
40000eb6:	74 1d                	je     40000ed5 <strtol+0x115>
    else if (base == 0 && s[0] == '0')
40000eb8:	8b 1c 24             	mov    (%esp),%ebx
40000ebb:	85 db                	test   %ebx,%ebx
40000ebd:	0f 85 69 ff ff ff    	jne    40000e2c <strtol+0x6c>
        s++, base = 8;
40000ec3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
40000eca:	83 c1 01             	add    $0x1,%ecx
40000ecd:	0f be d0             	movsbl %al,%edx
40000ed0:	e9 57 ff ff ff       	jmp    40000e2c <strtol+0x6c>
        s += 2, base = 16;
40000ed5:	0f be 51 02          	movsbl 0x2(%ecx),%edx
40000ed9:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
40000ee0:	83 c1 02             	add    $0x2,%ecx
40000ee3:	e9 44 ff ff ff       	jmp    40000e2c <strtol+0x6c>
40000ee8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000eef:	90                   	nop

40000ef0 <memset>:

void *memset(void *v, int c, size_t n)
{
40000ef0:	57                   	push   %edi
40000ef1:	56                   	push   %esi
40000ef2:	53                   	push   %ebx
40000ef3:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000ef7:	8b 7c 24 10          	mov    0x10(%esp),%edi
    if (n == 0)
40000efb:	85 c9                	test   %ecx,%ecx
40000efd:	74 28                	je     40000f27 <memset+0x37>
        return v;
    if ((int) v % 4 == 0 && n % 4 == 0) {
40000eff:	89 f8                	mov    %edi,%eax
40000f01:	09 c8                	or     %ecx,%eax
40000f03:	a8 03                	test   $0x3,%al
40000f05:	75 29                	jne    40000f30 <memset+0x40>
        c &= 0xFF;
40000f07:	0f b6 54 24 14       	movzbl 0x14(%esp),%edx
        c = (c << 24) | (c << 16) | (c << 8) | c;
        asm volatile ("cld; rep stosl\n"
                      :: "D" (v), "a" (c), "c" (n / 4)
40000f0c:	c1 e9 02             	shr    $0x2,%ecx
        c = (c << 24) | (c << 16) | (c << 8) | c;
40000f0f:	89 d0                	mov    %edx,%eax
40000f11:	89 d6                	mov    %edx,%esi
40000f13:	89 d3                	mov    %edx,%ebx
40000f15:	c1 e0 18             	shl    $0x18,%eax
40000f18:	c1 e6 10             	shl    $0x10,%esi
40000f1b:	09 f0                	or     %esi,%eax
40000f1d:	c1 e3 08             	shl    $0x8,%ebx
40000f20:	09 d0                	or     %edx,%eax
40000f22:	09 d8                	or     %ebx,%eax
        asm volatile ("cld; rep stosl\n"
40000f24:	fc                   	cld    
40000f25:	f3 ab                	rep stos %eax,%es:(%edi)
    } else
        asm volatile ("cld; rep stosb\n"
                      :: "D" (v), "a" (c), "c" (n)
                      : "cc", "memory");
    return v;
}
40000f27:	89 f8                	mov    %edi,%eax
40000f29:	5b                   	pop    %ebx
40000f2a:	5e                   	pop    %esi
40000f2b:	5f                   	pop    %edi
40000f2c:	c3                   	ret    
40000f2d:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("cld; rep stosb\n"
40000f30:	8b 44 24 14          	mov    0x14(%esp),%eax
40000f34:	fc                   	cld    
40000f35:	f3 aa                	rep stos %al,%es:(%edi)
}
40000f37:	89 f8                	mov    %edi,%eax
40000f39:	5b                   	pop    %ebx
40000f3a:	5e                   	pop    %esi
40000f3b:	5f                   	pop    %edi
40000f3c:	c3                   	ret    
40000f3d:	8d 76 00             	lea    0x0(%esi),%esi

40000f40 <memmove>:

void *memmove(void *dst, const void *src, size_t n)
{
40000f40:	57                   	push   %edi
40000f41:	56                   	push   %esi
40000f42:	8b 44 24 0c          	mov    0xc(%esp),%eax
40000f46:	8b 74 24 10          	mov    0x10(%esp),%esi
40000f4a:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
40000f4e:	39 c6                	cmp    %eax,%esi
40000f50:	73 26                	jae    40000f78 <memmove+0x38>
40000f52:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
40000f55:	39 c2                	cmp    %eax,%edx
40000f57:	76 1f                	jbe    40000f78 <memmove+0x38>
        s += n;
        d += n;
40000f59:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000f5c:	89 fe                	mov    %edi,%esi
40000f5e:	09 ce                	or     %ecx,%esi
40000f60:	09 d6                	or     %edx,%esi
40000f62:	83 e6 03             	and    $0x3,%esi
40000f65:	74 39                	je     40000fa0 <memmove+0x60>
            asm volatile ("std; rep movsl\n"
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
                          : "cc", "memory");
        else
            asm volatile ("std; rep movsb\n"
                          :: "D" (d - 1), "S" (s - 1), "c" (n)
40000f67:	83 ef 01             	sub    $0x1,%edi
40000f6a:	8d 72 ff             	lea    -0x1(%edx),%esi
            asm volatile ("std; rep movsb\n"
40000f6d:	fd                   	std    
40000f6e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile ("cld" ::: "cc");
40000f70:	fc                   	cld    
            asm volatile ("cld; rep movsb\n"
                          :: "D" (d), "S" (s), "c" (n)
                          : "cc", "memory");
    }
    return dst;
}
40000f71:	5e                   	pop    %esi
40000f72:	5f                   	pop    %edi
40000f73:	c3                   	ret    
40000f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000f78:	89 c2                	mov    %eax,%edx
40000f7a:	09 ca                	or     %ecx,%edx
40000f7c:	09 f2                	or     %esi,%edx
40000f7e:	83 e2 03             	and    $0x3,%edx
40000f81:	74 0d                	je     40000f90 <memmove+0x50>
            asm volatile ("cld; rep movsb\n"
40000f83:	89 c7                	mov    %eax,%edi
40000f85:	fc                   	cld    
40000f86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000f88:	5e                   	pop    %esi
40000f89:	5f                   	pop    %edi
40000f8a:	c3                   	ret    
40000f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000f8f:	90                   	nop
                          :: "D" (d), "S" (s), "c" (n / 4)
40000f90:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("cld; rep movsl\n"
40000f93:	89 c7                	mov    %eax,%edi
40000f95:	fc                   	cld    
40000f96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000f98:	eb ee                	jmp    40000f88 <memmove+0x48>
40000f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
40000fa0:	83 ef 04             	sub    $0x4,%edi
40000fa3:	8d 72 fc             	lea    -0x4(%edx),%esi
40000fa6:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("std; rep movsl\n"
40000fa9:	fd                   	std    
40000faa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000fac:	eb c2                	jmp    40000f70 <memmove+0x30>
40000fae:	66 90                	xchg   %ax,%ax

40000fb0 <memcpy>:

void *memcpy(void *dst, const void *src, size_t n)
{
    return memmove(dst, src, n);
40000fb0:	eb 8e                	jmp    40000f40 <memmove>
40000fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000fc0 <memcmp>:
}

int memcmp(const void *v1, const void *v2, size_t n)
{
40000fc0:	56                   	push   %esi
40000fc1:	53                   	push   %ebx
40000fc2:	8b 74 24 14          	mov    0x14(%esp),%esi
40000fc6:	8b 54 24 0c          	mov    0xc(%esp),%edx
40000fca:	8b 44 24 10          	mov    0x10(%esp),%eax
    const uint8_t *s1 = (const uint8_t *) v1;
    const uint8_t *s2 = (const uint8_t *) v2;

    while (n-- > 0) {
40000fce:	85 f6                	test   %esi,%esi
40000fd0:	74 2e                	je     40001000 <memcmp+0x40>
40000fd2:	01 c6                	add    %eax,%esi
40000fd4:	eb 14                	jmp    40000fea <memcmp+0x2a>
40000fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000fdd:	8d 76 00             	lea    0x0(%esi),%esi
        if (*s1 != *s2)
            return (int) *s1 - (int) *s2;
        s1++, s2++;
40000fe0:	83 c0 01             	add    $0x1,%eax
40000fe3:	83 c2 01             	add    $0x1,%edx
    while (n-- > 0) {
40000fe6:	39 f0                	cmp    %esi,%eax
40000fe8:	74 16                	je     40001000 <memcmp+0x40>
        if (*s1 != *s2)
40000fea:	0f b6 0a             	movzbl (%edx),%ecx
40000fed:	0f b6 18             	movzbl (%eax),%ebx
40000ff0:	38 d9                	cmp    %bl,%cl
40000ff2:	74 ec                	je     40000fe0 <memcmp+0x20>
            return (int) *s1 - (int) *s2;
40000ff4:	0f b6 c1             	movzbl %cl,%eax
40000ff7:	29 d8                	sub    %ebx,%eax
    }

    return 0;
}
40000ff9:	5b                   	pop    %ebx
40000ffa:	5e                   	pop    %esi
40000ffb:	c3                   	ret    
40000ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
40001000:	31 c0                	xor    %eax,%eax
}
40001002:	5b                   	pop    %ebx
40001003:	5e                   	pop    %esi
40001004:	c3                   	ret    
40001005:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40001010 <memchr>:

void *memchr(const void *s, int c, size_t n)
{
40001010:	8b 44 24 04          	mov    0x4(%esp),%eax
    const void *ends = (const char *) s + n;
40001014:	8b 54 24 0c          	mov    0xc(%esp),%edx
40001018:	01 c2                	add    %eax,%edx
    for (; s < ends; s++)
4000101a:	39 d0                	cmp    %edx,%eax
4000101c:	73 1a                	jae    40001038 <memchr+0x28>
4000101e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
40001023:	eb 0a                	jmp    4000102f <memchr+0x1f>
40001025:	8d 76 00             	lea    0x0(%esi),%esi
40001028:	83 c0 01             	add    $0x1,%eax
4000102b:	39 c2                	cmp    %eax,%edx
4000102d:	74 09                	je     40001038 <memchr+0x28>
        if (*(const unsigned char *) s == (unsigned char) c)
4000102f:	38 08                	cmp    %cl,(%eax)
40001031:	75 f5                	jne    40001028 <memchr+0x18>
            return (void *) s;
    return NULL;
}
40001033:	c3                   	ret    
40001034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return NULL;
40001038:	31 c0                	xor    %eax,%eax
}
4000103a:	c3                   	ret    
4000103b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000103f:	90                   	nop

40001040 <memzero>:

void *memzero(void *v, size_t n)
{
    return memset(v, 0, n);
40001040:	ff 74 24 08          	pushl  0x8(%esp)
40001044:	6a 00                	push   $0x0
40001046:	ff 74 24 0c          	pushl  0xc(%esp)
4000104a:	e8 a1 fe ff ff       	call   40000ef0 <memset>
4000104f:	83 c4 0c             	add    $0xc,%esp
}
40001052:	c3                   	ret    
40001053:	66 90                	xchg   %ax,%ax
40001055:	66 90                	xchg   %ax,%ax
40001057:	66 90                	xchg   %ax,%ax
40001059:	66 90                	xchg   %ax,%ax
4000105b:	66 90                	xchg   %ax,%ax
4000105d:	66 90                	xchg   %ax,%ax
4000105f:	90                   	nop

40001060 <futex>:
#define E_FAIL			-1
#define E_AGAIN			-2

int futex(uint32_t *uaddr, uint32_t futex_op, uint32_t val1,
	  const struct timespect *timeout,
	  uint32_t *uaddr2, uint32_t val3) {
40001060:	57                   	push   %edi
					 const struct timespect *timeout,
					 uint32_t *uaddr2, uint32_t val3)
{
    int errno;
    unsigned int ret;
    asm volatile ("int %2"
40001061:	b8 09 00 00 00       	mov    $0x9,%eax
40001066:	56                   	push   %esi
40001067:	53                   	push   %ebx
40001068:	8b 5c 24 10          	mov    0x10(%esp),%ebx
4000106c:	8b 4c 24 14          	mov    0x14(%esp),%ecx
40001070:	8b 54 24 18          	mov    0x18(%esp),%edx
40001074:	8b 74 24 20          	mov    0x20(%esp),%esi
40001078:	8b 7c 24 24          	mov    0x24(%esp),%edi
4000107c:	cd 30                	int    $0x30
		    "c" (op),
		    "d" (val1),
		    "S" (uaddr2),
		    "D" (val3)
                  : "cc", "memory");
    return errno ? errno : ret;
4000107e:	85 c0                	test   %eax,%eax
40001080:	0f 44 c3             	cmove  %ebx,%eax
    return sys_futex(uaddr, futex_op, val1, timeout, uaddr2, val3);
}
40001083:	5b                   	pop    %ebx
40001084:	5e                   	pop    %esi
40001085:	5f                   	pop    %edi
40001086:	c3                   	ret    
40001087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000108e:	66 90                	xchg   %ax,%ax

40001090 <mutex_init>:
40001090:	8b 44 24 04          	mov    0x4(%esp),%eax
40001094:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
4000109a:	c3                   	ret    
4000109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000109f:	90                   	nop

400010a0 <mutex_lock>:

void mutex_lock(mutex_t *mtx) {
400010a0:	55                   	push   %ebp
// Otherwise, return new_value
gcc_inline uint32_t cmpxchg(volatile uint32_t *addr, uint32_t oldval, uint32_t newval)
{
    uint32_t result;

    __asm __volatile ("lock; cmpxchgl %2, %0"
400010a1:	ba 01 00 00 00       	mov    $0x1,%edx
400010a6:	31 c0                	xor    %eax,%eax
400010a8:	57                   	push   %edi
400010a9:	56                   	push   %esi
400010aa:	53                   	push   %ebx
400010ab:	8b 6c 24 14          	mov    0x14(%esp),%ebp
400010af:	f0 0f b1 55 00       	lock cmpxchg %edx,0x0(%ebp)
    int c = 0;
    // Check if it's locked
    if ((c = cmpxchg(&mtx->val, MUTEX_UNLOCKED, MUTEX_LOCKED_NO_WAITERS)) != MUTEX_UNLOCKED) {
400010b4:	85 c0                	test   %eax,%eax
400010b6:	74 34                	je     400010ec <mutex_lock+0x4c>
	// It's already locked, the old value (either 0 or more waitiers) is unchanged
	// This caller is a waiter, so set mtx->val to have waiters
	if (c != MUTEX_LOCKED_WITH_WAITERS)
400010b8:	83 f8 02             	cmp    $0x2,%eax
400010bb:	74 0d                	je     400010ca <mutex_lock+0x2a>

gcc_inline uint32_t xchg(volatile uint32_t *addr, uint32_t newval)
{
    uint32_t result;

    __asm __volatile ("lock; xchgl %0, %1"
400010bd:	b8 02 00 00 00       	mov    $0x2,%eax
400010c2:	f0 87 45 00          	lock xchg %eax,0x0(%ebp)
	    c = xchg(&mtx->val, MUTEX_LOCKED_WITH_WAITERS);

	while (c != MUTEX_UNLOCKED) {
400010c6:	85 c0                	test   %eax,%eax
400010c8:	74 22                	je     400010ec <mutex_lock+0x4c>
    asm volatile ("int %2"
400010ca:	b9 04 00 00 00       	mov    $0x4,%ecx
400010cf:	90                   	nop
400010d0:	31 f6                	xor    %esi,%esi
400010d2:	ba 02 00 00 00       	mov    $0x2,%edx
400010d7:	b8 09 00 00 00       	mov    $0x9,%eax
400010dc:	89 eb                	mov    %ebp,%ebx
400010de:	89 f7                	mov    %esi,%edi
400010e0:	cd 30                	int    $0x30
400010e2:	89 d0                	mov    %edx,%eax
400010e4:	f0 87 45 00          	lock xchg %eax,0x0(%ebp)
400010e8:	85 c0                	test   %eax,%eax
400010ea:	75 e4                	jne    400010d0 <mutex_lock+0x30>
	    futex(&mtx->val, FUTEX_WAIT, MUTEX_LOCKED_WITH_WAITERS, NULL, NULL, 0);

	    c = xchg(&mtx->val, MUTEX_LOCKED_WITH_WAITERS);
	}
    }
}
400010ec:	5b                   	pop    %ebx
400010ed:	5e                   	pop    %esi
400010ee:	5f                   	pop    %edi
400010ef:	5d                   	pop    %ebp
400010f0:	c3                   	ret    
400010f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400010f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400010ff:	90                   	nop

40001100 <mutex_unlock>:

void mutex_unlock(mutex_t *mtx) {
40001100:	57                   	push   %edi
40001101:	56                   	push   %esi
40001102:	53                   	push   %ebx
40001103:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    if (__sync_fetch_and_sub(&mtx->val, 1) != MUTEX_LOCKED_NO_WAITERS) {
40001107:	f0 83 2b 01          	lock subl $0x1,(%ebx)
4000110b:	74 1b                	je     40001128 <mutex_unlock+0x28>
4000110d:	31 ff                	xor    %edi,%edi
	mtx->val = MUTEX_UNLOCKED;
4000110f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
40001115:	ba 01 00 00 00       	mov    $0x1,%edx
4000111a:	b8 09 00 00 00       	mov    $0x9,%eax
4000111f:	b9 08 00 00 00       	mov    $0x8,%ecx
40001124:	89 fe                	mov    %edi,%esi
40001126:	cd 30                	int    $0x30
	futex(&mtx->val, FUTEX_WAKE, 1, NULL, NULL, 0);
    }
}
40001128:	5b                   	pop    %ebx
40001129:	5e                   	pop    %esi
4000112a:	5f                   	pop    %edi
4000112b:	c3                   	ret    
4000112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40001130 <barrier_init>:
void barrier_init(barrier_t *b, uint32_t needed) {
40001130:	8b 44 24 04          	mov    0x4(%esp),%eax
40001134:	8b 54 24 08          	mov    0x8(%esp),%edx
    mtx->val = MUTEX_UNLOCKED;
40001138:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    b->event = 0;
4000113e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    b->still_needed = needed;
40001145:	89 50 08             	mov    %edx,0x8(%eax)
    b->initial_needed = needed;
40001148:	89 50 0c             	mov    %edx,0xc(%eax)
}
4000114b:	c3                   	ret    
4000114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40001150 <barrier_wait>:

void barrier_wait(barrier_t *b) {
40001150:	55                   	push   %ebp
    __asm __volatile ("lock; cmpxchgl %2, %0"
40001151:	ba 01 00 00 00       	mov    $0x1,%edx
40001156:	31 c0                	xor    %eax,%eax
40001158:	57                   	push   %edi
40001159:	56                   	push   %esi
4000115a:	53                   	push   %ebx
4000115b:	83 ec 08             	sub    $0x8,%esp
4000115e:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
40001162:	f0 0f b1 55 00       	lock cmpxchg %edx,0x0(%ebp)
    if ((c = cmpxchg(&mtx->val, MUTEX_UNLOCKED, MUTEX_LOCKED_NO_WAITERS)) != MUTEX_UNLOCKED) {
40001167:	85 c0                	test   %eax,%eax
40001169:	74 39                	je     400011a4 <barrier_wait+0x54>
	if (c != MUTEX_LOCKED_WITH_WAITERS)
4000116b:	83 f8 02             	cmp    $0x2,%eax
4000116e:	74 0d                	je     4000117d <barrier_wait+0x2d>
    __asm __volatile ("lock; xchgl %0, %1"
40001170:	b8 02 00 00 00       	mov    $0x2,%eax
40001175:	f0 87 45 00          	lock xchg %eax,0x0(%ebp)
	while (c != MUTEX_UNLOCKED) {
40001179:	85 c0                	test   %eax,%eax
4000117b:	74 27                	je     400011a4 <barrier_wait+0x54>
4000117d:	b9 04 00 00 00       	mov    $0x4,%ecx
40001182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001188:	31 f6                	xor    %esi,%esi
4000118a:	ba 02 00 00 00       	mov    $0x2,%edx
4000118f:	b8 09 00 00 00       	mov    $0x9,%eax
40001194:	89 eb                	mov    %ebp,%ebx
40001196:	89 f7                	mov    %esi,%edi
40001198:	cd 30                	int    $0x30
4000119a:	89 d0                	mov    %edx,%eax
4000119c:	f0 87 45 00          	lock xchg %eax,0x0(%ebp)
400011a0:	85 c0                	test   %eax,%eax
400011a2:	75 e4                	jne    40001188 <barrier_wait+0x38>
    mutex_lock(&b->lock);

    if (--b->still_needed > 0) {
400011a4:	8b 45 08             	mov    0x8(%ebp),%eax
400011a7:	8d 70 ff             	lea    -0x1(%eax),%esi
400011aa:	8b 45 04             	mov    0x4(%ebp),%eax
400011ad:	89 75 08             	mov    %esi,0x8(%ebp)
400011b0:	89 04 24             	mov    %eax,(%esp)
400011b3:	8d 45 04             	lea    0x4(%ebp),%eax
400011b6:	89 44 24 04          	mov    %eax,0x4(%esp)
400011ba:	85 f6                	test   %esi,%esi
400011bc:	74 52                	je     40001210 <barrier_wait+0xc0>
    if (__sync_fetch_and_sub(&mtx->val, 1) != MUTEX_LOCKED_NO_WAITERS) {
400011be:	f0 83 6d 00 01       	lock subl $0x1,0x0(%ebp)
400011c3:	74 1e                	je     400011e3 <barrier_wait+0x93>
400011c5:	31 f6                	xor    %esi,%esi
	mtx->val = MUTEX_UNLOCKED;
400011c7:	c7 45 00 00 00 00 00 	movl   $0x0,0x0(%ebp)
400011ce:	ba 01 00 00 00       	mov    $0x1,%edx
400011d3:	89 eb                	mov    %ebp,%ebx
400011d5:	b8 09 00 00 00       	mov    $0x9,%eax
400011da:	b9 08 00 00 00       	mov    $0x8,%ecx
400011df:	89 f7                	mov    %esi,%edi
400011e1:	cd 30                	int    $0x30
400011e3:	b9 04 00 00 00       	mov    $0x4,%ecx
400011e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400011ef:	90                   	nop
400011f0:	31 f6                	xor    %esi,%esi
400011f2:	8b 5c 24 04          	mov    0x4(%esp),%ebx
400011f6:	8b 14 24             	mov    (%esp),%edx
400011f9:	b8 09 00 00 00       	mov    $0x9,%eax
400011fe:	89 f7                	mov    %esi,%edi
40001200:	cd 30                	int    $0x30
	mutex_unlock(&b->lock);
	
	// Wait till enough
	do {
	    futex(&b->event, FUTEX_WAIT, ev, NULL, NULL, 0);
	} while (b->event == ev);
40001202:	39 55 04             	cmp    %edx,0x4(%ebp)
40001205:	74 e9                	je     400011f0 <barrier_wait+0xa0>
	++b->event;
	b->still_needed = b->initial_needed;
	futex(&b->event, FUTEX_WAKE, INT_MAX, NULL, NULL, 0);
	mutex_unlock(&b->lock);
    }
}
40001207:	83 c4 08             	add    $0x8,%esp
4000120a:	5b                   	pop    %ebx
4000120b:	5e                   	pop    %esi
4000120c:	5f                   	pop    %edi
4000120d:	5d                   	pop    %ebp
4000120e:	c3                   	ret    
4000120f:	90                   	nop
	++b->event;
40001210:	8b 04 24             	mov    (%esp),%eax
40001213:	b9 08 00 00 00       	mov    $0x8,%ecx
40001218:	ba ff ff ff 7f       	mov    $0x7fffffff,%edx
4000121d:	8d 5d 04             	lea    0x4(%ebp),%ebx
40001220:	89 f7                	mov    %esi,%edi
40001222:	83 c0 01             	add    $0x1,%eax
40001225:	89 45 04             	mov    %eax,0x4(%ebp)
	b->still_needed = b->initial_needed;
40001228:	8b 45 0c             	mov    0xc(%ebp),%eax
4000122b:	89 45 08             	mov    %eax,0x8(%ebp)
4000122e:	b8 09 00 00 00       	mov    $0x9,%eax
40001233:	cd 30                	int    $0x30
    if (__sync_fetch_and_sub(&mtx->val, 1) != MUTEX_LOCKED_NO_WAITERS) {
40001235:	bf ff ff ff ff       	mov    $0xffffffff,%edi
4000123a:	f0 0f c1 7d 00       	lock xadd %edi,0x0(%ebp)
4000123f:	83 ff 01             	cmp    $0x1,%edi
40001242:	74 c3                	je     40001207 <barrier_wait+0xb7>
	mtx->val = MUTEX_UNLOCKED;
40001244:	c7 45 00 00 00 00 00 	movl   $0x0,0x0(%ebp)
4000124b:	ba 01 00 00 00       	mov    $0x1,%edx
40001250:	89 eb                	mov    %ebp,%ebx
40001252:	89 f7                	mov    %esi,%edi
40001254:	b8 09 00 00 00       	mov    $0x9,%eax
40001259:	cd 30                	int    $0x30
}
4000125b:	83 c4 08             	add    $0x8,%esp
4000125e:	5b                   	pop    %ebx
4000125f:	5e                   	pop    %esi
40001260:	5f                   	pop    %edi
40001261:	5d                   	pop    %ebp
40001262:	c3                   	ret    
40001263:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000126a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40001270 <semaphore_init>:
void semaphore_init(semaphore_t *s, int v) {
40001270:	8b 44 24 04          	mov    0x4(%esp),%eax
    s->v = v;
40001274:	8b 54 24 08          	mov    0x8(%esp),%edx
    s->waiters = 0;
40001278:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    s->v = v;
4000127f:	89 10                	mov    %edx,(%eax)
}
40001281:	c3                   	ret    
40001282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40001290 <semaphore_p>:

/*
 * Waits until the value is positive, then it atomically
 * decrements the value by 1
 */
void semaphore_p(semaphore_t *s) {
40001290:	55                   	push   %ebp
40001291:	57                   	push   %edi
40001292:	56                   	push   %esi
40001293:	53                   	push   %ebx
40001294:	83 ec 04             	sub    $0x4,%esp
40001297:	8b 6c 24 18          	mov    0x18(%esp),%ebp
    atomic_inc(&s->waiters);
4000129b:	8d 45 04             	lea    0x4(%ebp),%eax
4000129e:	89 04 24             	mov    %eax,(%esp)

    return result;
}

gcc_inline uint32_t atomic_inc(volatile uint32_t *addr) {
    return __sync_fetch_and_add(addr, 1);
400012a1:	f0 83 00 01          	lock addl $0x1,(%eax)
400012a5:	b9 04 00 00 00       	mov    $0x4,%ecx
400012aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
gcc_inline uint32_t atomic_dec(volatile uint32_t *addr) {
    return __sync_fetch_and_sub(addr, 1);
}

gcc_inline uint32_t atomic_load(volatile uint32_t *addr) {
    return __sync_fetch_and_add(addr, 0);
400012b0:	31 f6                	xor    %esi,%esi
400012b2:	f0 0f c1 75 00       	lock xadd %esi,0x0(%ebp)

    do {
	uint32_t initial_v = atomic_load(&s->v);

	if (initial_v == 0) {
400012b7:	85 f6                	test   %esi,%esi
400012b9:	75 15                	jne    400012d0 <semaphore_p+0x40>
400012bb:	b8 09 00 00 00       	mov    $0x9,%eax
400012c0:	89 eb                	mov    %ebp,%ebx
400012c2:	89 f2                	mov    %esi,%edx
400012c4:	89 f7                	mov    %esi,%edi
400012c6:	cd 30                	int    $0x30
    return errno ? errno : ret;
400012c8:	eb e6                	jmp    400012b0 <semaphore_p+0x20>
400012ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	    futex(&s->v, FUTEX_WAIT, initial_v, NULL, NULL, 0);
	} else if (cmpxchg(&s->v, initial_v, initial_v - 1) == initial_v) {
400012d0:	8d 56 ff             	lea    -0x1(%esi),%edx
    __asm __volatile ("lock; cmpxchgl %2, %0"
400012d3:	89 f0                	mov    %esi,%eax
400012d5:	f0 0f b1 55 00       	lock cmpxchg %edx,0x0(%ebp)
400012da:	39 c6                	cmp    %eax,%esi
400012dc:	75 d2                	jne    400012b0 <semaphore_p+0x20>
    return __sync_fetch_and_sub(addr, 1);
400012de:	8b 04 24             	mov    (%esp),%eax
400012e1:	f0 83 28 01          	lock subl $0x1,(%eax)
	    break;
	} else {
	    // v is not 0 but failed to get it, retry!
	}
    } while (1);
}
400012e5:	83 c4 04             	add    $0x4,%esp
400012e8:	5b                   	pop    %ebx
400012e9:	5e                   	pop    %esi
400012ea:	5f                   	pop    %edi
400012eb:	5d                   	pop    %ebp
400012ec:	c3                   	ret    
400012ed:	8d 76 00             	lea    0x0(%esi),%esi

400012f0 <semaphore_v>:
/*
 * Atomically increments the value by 1. If any threads
 * are waiting in P, one is enabled, so that its call to P
 * succeeds at decrementing the value and returns
 */
void semaphore_v(semaphore_t *s) {
400012f0:	57                   	push   %edi
400012f1:	56                   	push   %esi
400012f2:	53                   	push   %ebx
400012f3:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    return __sync_fetch_and_add(addr, 1);
400012f7:	f0 83 03 01          	lock addl $0x1,(%ebx)
    return __sync_fetch_and_add(addr, 0);
400012fb:	31 c0                	xor    %eax,%eax
400012fd:	f0 0f c1 43 04       	lock xadd %eax,0x4(%ebx)
    atomic_inc(&s->v);

    if (atomic_load(&s->waiters) > 0) {
40001302:	85 c0                	test   %eax,%eax
40001304:	74 15                	je     4000131b <semaphore_v+0x2b>
    asm volatile ("int %2"
40001306:	31 ff                	xor    %edi,%edi
40001308:	b8 09 00 00 00       	mov    $0x9,%eax
4000130d:	b9 08 00 00 00       	mov    $0x8,%ecx
40001312:	ba 01 00 00 00       	mov    $0x1,%edx
40001317:	89 fe                	mov    %edi,%esi
40001319:	cd 30                	int    $0x30
	futex(&s->v, FUTEX_WAKE, 1, NULL, NULL, 0);
    }
}
4000131b:	5b                   	pop    %ebx
4000131c:	5e                   	pop    %esi
4000131d:	5f                   	pop    %edi
4000131e:	c3                   	ret    
4000131f:	90                   	nop

40001320 <condvar_init>:
void condvar_init(condvar_t *cv) {
40001320:	8b 44 24 04          	mov    0x4(%esp),%eax
    cv->value = 0;
40001324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    cv->previous = 0;
4000132a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
40001331:	c3                   	ret    
40001332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40001340 <condvar_wait>:
 *
 */


// Previous = current
void condvar_wait(condvar_t *cv, spinlock_t *s) {
40001340:	55                   	push   %ebp
40001341:	31 d2                	xor    %edx,%edx
40001343:	57                   	push   %edi
40001344:	56                   	push   %esi
40001345:	53                   	push   %ebx
40001346:	83 ec 28             	sub    $0x28,%esp
40001349:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
4000134d:	8b 6c 24 40          	mov    0x40(%esp),%ebp
40001351:	f0 0f c1 13          	lock xadd %edx,(%ebx)
}

gcc_inline void atomic_store(volatile uint32_t *addr, uint32_t val) {
    __sync_lock_test_and_set(addr, val);
40001355:	89 d0                	mov    %edx,%eax
40001357:	89 54 24 18          	mov    %edx,0x18(%esp)
4000135b:	87 43 04             	xchg   %eax,0x4(%ebx)
4000135e:	31 ff                	xor    %edi,%edi
40001360:	89 fe                	mov    %edi,%esi
    uint32_t value = atomic_load(&cv->value);
    atomic_store(&cv->previous, value);

    spinlock_release(s);
40001362:	55                   	push   %ebp
40001363:	e8 18 f8 ff ff       	call   40000b80 <spinlock_release>
40001368:	8b 54 24 1c          	mov    0x1c(%esp),%edx
4000136c:	b8 09 00 00 00       	mov    $0x9,%eax
40001371:	b9 04 00 00 00       	mov    $0x4,%ecx
40001376:	cd 30                	int    $0x30
    futex(&cv->value, FUTEX_WAIT, value, NULL, NULL, 0);
    spinlock_acquire(s);
40001378:	89 6c 24 40          	mov    %ebp,0x40(%esp)
}
4000137c:	83 c4 2c             	add    $0x2c,%esp
4000137f:	5b                   	pop    %ebx
40001380:	5e                   	pop    %esi
40001381:	5f                   	pop    %edi
40001382:	5d                   	pop    %ebp
    spinlock_acquire(s);
40001383:	e9 c8 f7 ff ff       	jmp    40000b50 <spinlock_acquire>
40001388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000138f:	90                   	nop

40001390 <condvar_signal>:

// Current = previous + 1
void condvar_signal(condvar_t *cv) {
40001390:	57                   	push   %edi
    return __sync_fetch_and_add(addr, 0);
40001391:	31 c0                	xor    %eax,%eax
40001393:	56                   	push   %esi
40001394:	53                   	push   %ebx
40001395:	8b 5c 24 10          	mov    0x10(%esp),%ebx
40001399:	f0 0f c1 43 04       	lock xadd %eax,0x4(%ebx)
    atomic_store(&cv->value, 1u + atomic_load(&cv->previous));
4000139e:	83 c0 01             	add    $0x1,%eax
    __sync_lock_test_and_set(addr, val);
400013a1:	87 03                	xchg   %eax,(%ebx)
400013a3:	31 ff                	xor    %edi,%edi
400013a5:	b8 09 00 00 00       	mov    $0x9,%eax
400013aa:	b9 08 00 00 00       	mov    $0x8,%ecx
400013af:	ba 01 00 00 00       	mov    $0x1,%edx
400013b4:	89 fe                	mov    %edi,%esi
400013b6:	cd 30                	int    $0x30

    futex(&cv->value, FUTEX_WAKE, 1, NULL, NULL, 0);
}
400013b8:	5b                   	pop    %ebx
400013b9:	5e                   	pop    %esi
400013ba:	5f                   	pop    %edi
400013bb:	c3                   	ret    
400013bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

400013c0 <condvar_broadcast>:


/*
 * 
 */
void condvar_broadcast(condvar_t *cv) {
400013c0:	57                   	push   %edi
    return __sync_fetch_and_add(addr, 0);
400013c1:	31 c0                	xor    %eax,%eax
400013c3:	56                   	push   %esi
400013c4:	53                   	push   %ebx
400013c5:	8b 5c 24 10          	mov    0x10(%esp),%ebx
400013c9:	f0 0f c1 43 04       	lock xadd %eax,0x4(%ebx)
    atomic_store(&cv->value, 1u + atomic_load(&cv->previous));
400013ce:	83 c0 01             	add    $0x1,%eax
    __sync_lock_test_and_set(addr, val);
400013d1:	87 03                	xchg   %eax,(%ebx)
400013d3:	31 ff                	xor    %edi,%edi
400013d5:	b8 09 00 00 00       	mov    $0x9,%eax
400013da:	b9 08 00 00 00       	mov    $0x8,%ecx
400013df:	ba ff ff ff 7f       	mov    $0x7fffffff,%edx
400013e4:	89 fe                	mov    %edi,%esi
400013e6:	cd 30                	int    $0x30

    futex(&cv->value, FUTEX_WAKE, INT_MAX, NULL, NULL, 0);
}
400013e8:	5b                   	pop    %ebx
400013e9:	5e                   	pop    %esi
400013ea:	5f                   	pop    %edi
400013eb:	c3                   	ret    
400013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

400013f0 <bounded_queue_init>:
    uint32_t data[BOUNDED_QUEUE_CAPACITY];
    uint32_t head;
    uint32_t size;
} bounded_queue_t;

void bounded_queue_init(bounded_queue_t *bq) {
400013f0:	53                   	push   %ebx
400013f1:	83 ec 14             	sub    $0x14,%esp
400013f4:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    spinlock_init(&bq->lock);
400013f8:	53                   	push   %ebx
400013f9:	e8 42 f7 ff ff       	call   40000b40 <spinlock_init>
    cv->value = 0;
400013fe:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    cv->previous = 0;
40001405:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    cv->value = 0;
4000140c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    cv->previous = 0;
40001413:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    condvar_init(&bq->empty);
    condvar_init(&bq->full);

    bq->head = 0;
4000141a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    bq->size = 0;
40001421:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
}
40001428:	83 c4 18             	add    $0x18,%esp
4000142b:	5b                   	pop    %ebx
4000142c:	c3                   	ret    
4000142d:	8d 76 00             	lea    0x0(%esi),%esi

40001430 <bounded_queue_push>:

void bounded_queue_push(bounded_queue_t *bq, uint32_t item) {
40001430:	57                   	push   %edi
40001431:	56                   	push   %esi
40001432:	53                   	push   %ebx
40001433:	8b 5c 24 10          	mov    0x10(%esp),%ebx
40001437:	8b 7c 24 14          	mov    0x14(%esp),%edi
    spinlock_acquire(&bq->lock);
4000143b:	83 ec 0c             	sub    $0xc,%esp
4000143e:	53                   	push   %ebx
4000143f:	e8 0c f7 ff ff       	call   40000b50 <spinlock_acquire>

    while (bq->size == BOUNDED_QUEUE_CAPACITY) {
40001444:	8b 4b 40             	mov    0x40(%ebx),%ecx
40001447:	83 c4 10             	add    $0x10,%esp
4000144a:	83 f9 0a             	cmp    $0xa,%ecx
4000144d:	75 1e                	jne    4000146d <bounded_queue_push+0x3d>
4000144f:	8d 73 0c             	lea    0xc(%ebx),%esi
40001452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        condvar_wait(&bq->full, &bq->lock);
40001458:	83 ec 08             	sub    $0x8,%esp
4000145b:	53                   	push   %ebx
4000145c:	56                   	push   %esi
4000145d:	e8 de fe ff ff       	call   40001340 <condvar_wait>
    while (bq->size == BOUNDED_QUEUE_CAPACITY) {
40001462:	8b 4b 40             	mov    0x40(%ebx),%ecx
40001465:	83 c4 10             	add    $0x10,%esp
40001468:	83 f9 0a             	cmp    $0xa,%ecx
4000146b:	74 eb                	je     40001458 <bounded_queue_push+0x28>
    }

    bq->data[(bq->head + bq->size) % BOUNDED_QUEUE_CAPACITY] = item;
4000146d:	8b 73 3c             	mov    0x3c(%ebx),%esi
40001470:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    bq->size++;
    condvar_signal(&bq->empty);
40001475:	83 ec 0c             	sub    $0xc,%esp
    bq->data[(bq->head + bq->size) % BOUNDED_QUEUE_CAPACITY] = item;
40001478:	01 ce                	add    %ecx,%esi
    bq->size++;
4000147a:	83 c1 01             	add    $0x1,%ecx
    bq->data[(bq->head + bq->size) % BOUNDED_QUEUE_CAPACITY] = item;
4000147d:	89 f0                	mov    %esi,%eax
4000147f:	f7 e2                	mul    %edx
40001481:	c1 ea 03             	shr    $0x3,%edx
40001484:	8d 04 92             	lea    (%edx,%edx,4),%eax
40001487:	01 c0                	add    %eax,%eax
40001489:	29 c6                	sub    %eax,%esi
    condvar_signal(&bq->empty);
4000148b:	8d 43 04             	lea    0x4(%ebx),%eax
    bq->data[(bq->head + bq->size) % BOUNDED_QUEUE_CAPACITY] = item;
4000148e:	89 7c b3 14          	mov    %edi,0x14(%ebx,%esi,4)
    bq->size++;
40001492:	89 4b 40             	mov    %ecx,0x40(%ebx)
    condvar_signal(&bq->empty);
40001495:	50                   	push   %eax
40001496:	e8 f5 fe ff ff       	call   40001390 <condvar_signal>


    spinlock_release(&bq->lock);
4000149b:	83 c4 10             	add    $0x10,%esp
4000149e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
400014a2:	5b                   	pop    %ebx
400014a3:	5e                   	pop    %esi
400014a4:	5f                   	pop    %edi
    spinlock_release(&bq->lock);
400014a5:	e9 d6 f6 ff ff       	jmp    40000b80 <spinlock_release>
400014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

400014b0 <bounded_queue_pop>:

uint32_t bounded_queue_pop(bounded_queue_t *bq)
{
400014b0:	57                   	push   %edi
400014b1:	56                   	push   %esi
400014b2:	53                   	push   %ebx
400014b3:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    spinlock_acquire(&bq->lock);
400014b7:	83 ec 0c             	sub    $0xc,%esp
400014ba:	53                   	push   %ebx
400014bb:	e8 90 f6 ff ff       	call   40000b50 <spinlock_acquire>

    while (bq->size == 0) {
400014c0:	8b 4b 40             	mov    0x40(%ebx),%ecx
400014c3:	83 c4 10             	add    $0x10,%esp
400014c6:	85 c9                	test   %ecx,%ecx
400014c8:	75 1a                	jne    400014e4 <bounded_queue_pop+0x34>
400014ca:	8d 73 04             	lea    0x4(%ebx),%esi
400014cd:	8d 76 00             	lea    0x0(%esi),%esi
        condvar_wait(&bq->empty, &bq->lock);
400014d0:	83 ec 08             	sub    $0x8,%esp
400014d3:	53                   	push   %ebx
400014d4:	56                   	push   %esi
400014d5:	e8 66 fe ff ff       	call   40001340 <condvar_wait>
    while (bq->size == 0) {
400014da:	8b 4b 40             	mov    0x40(%ebx),%ecx
400014dd:	83 c4 10             	add    $0x10,%esp
400014e0:	85 c9                	test   %ecx,%ecx
400014e2:	74 ec                	je     400014d0 <bounded_queue_pop+0x20>
    }

    uint32_t top_item = bq->data[bq->head];
400014e4:	8b 73 3c             	mov    0x3c(%ebx),%esi
    bq->head = (bq->head + 1) % BOUNDED_QUEUE_CAPACITY;
400014e7:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    --bq->size;
    condvar_signal(&bq->full);
400014ec:	83 ec 0c             	sub    $0xc,%esp
    --bq->size;
400014ef:	83 e9 01             	sub    $0x1,%ecx
    uint32_t top_item = bq->data[bq->head];
400014f2:	8b 7c b3 14          	mov    0x14(%ebx,%esi,4),%edi
    bq->head = (bq->head + 1) % BOUNDED_QUEUE_CAPACITY;
400014f6:	83 c6 01             	add    $0x1,%esi
    --bq->size;
400014f9:	89 4b 40             	mov    %ecx,0x40(%ebx)
    bq->head = (bq->head + 1) % BOUNDED_QUEUE_CAPACITY;
400014fc:	89 f0                	mov    %esi,%eax
400014fe:	f7 e2                	mul    %edx
40001500:	c1 ea 03             	shr    $0x3,%edx
40001503:	8d 04 92             	lea    (%edx,%edx,4),%eax
40001506:	01 c0                	add    %eax,%eax
40001508:	29 c6                	sub    %eax,%esi
    condvar_signal(&bq->full);
4000150a:	8d 43 0c             	lea    0xc(%ebx),%eax
    bq->head = (bq->head + 1) % BOUNDED_QUEUE_CAPACITY;
4000150d:	89 73 3c             	mov    %esi,0x3c(%ebx)
    condvar_signal(&bq->full);
40001510:	50                   	push   %eax
40001511:	e8 7a fe ff ff       	call   40001390 <condvar_signal>

    spinlock_release(&bq->lock);
40001516:	89 1c 24             	mov    %ebx,(%esp)
40001519:	e8 62 f6 ff ff       	call   40000b80 <spinlock_release>
    return top_item;
4000151e:	83 c4 10             	add    $0x10,%esp
}
40001521:	89 f8                	mov    %edi,%eax
40001523:	5b                   	pop    %ebx
40001524:	5e                   	pop    %esi
40001525:	5f                   	pop    %edi
40001526:	c3                   	ret    
40001527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000152e:	66 90                	xchg   %ax,%ax

40001530 <rwlock_init>:
void rwlock_init(rwlock_t *rw) {
40001530:	53                   	push   %ebx
40001531:	83 ec 14             	sub    $0x14,%esp
40001534:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    spinlock_init(&rw->lock);
40001538:	53                   	push   %ebx
40001539:	e8 02 f6 ff ff       	call   40000b40 <spinlock_init>
    rw->active_readers = 0;
4000153e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    cv->value = 0;
40001545:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    rw->active_writers = 0;
4000154c:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    cv->previous = 0;
40001553:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    rw->waiting_readers = 0;
4000155a:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    cv->value = 0;
40001561:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    cv->previous = 0;
40001568:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    rw->waiting_writers = 0;
4000156f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
40001576:	83 c4 18             	add    $0x18,%esp
40001579:	5b                   	pop    %ebx
4000157a:	c3                   	ret    
4000157b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000157f:	90                   	nop

40001580 <rwlock_read>:

static bool write_can_go(rwlock_t *rw) {
    return rw->active_writers == 0 && rw->active_readers == 0;
}

void rwlock_read(rwlock_t *rw) {
40001580:	56                   	push   %esi
40001581:	53                   	push   %ebx
40001582:	83 ec 10             	sub    $0x10,%esp
40001585:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    spinlock_acquire(&rw->lock);
40001589:	53                   	push   %ebx

    ++rw->waiting_readers;

    while (!read_can_go(rw)) {
	condvar_wait(&rw->read_can_go, &rw->lock);
4000158a:	8d 73 04             	lea    0x4(%ebx),%esi
    spinlock_acquire(&rw->lock);
4000158d:	e8 be f5 ff ff       	call   40000b50 <spinlock_acquire>
    ++rw->waiting_readers;
40001592:	8b 43 1c             	mov    0x1c(%ebx),%eax
    while (!read_can_go(rw)) {
40001595:	83 c4 10             	add    $0x10,%esp
    ++rw->waiting_readers;
40001598:	83 c0 01             	add    $0x1,%eax
4000159b:	89 43 1c             	mov    %eax,0x1c(%ebx)
    while (!read_can_go(rw)) {
4000159e:	66 90                	xchg   %ax,%ax
    return rw->active_writers == 0 && rw->waiting_writers == 0;
400015a0:	8b 43 18             	mov    0x18(%ebx),%eax
400015a3:	85 c0                	test   %eax,%eax
400015a5:	75 29                	jne    400015d0 <rwlock_read+0x50>
400015a7:	8b 43 20             	mov    0x20(%ebx),%eax
400015aa:	85 c0                	test   %eax,%eax
400015ac:	75 22                	jne    400015d0 <rwlock_read+0x50>
    }

    --rw->waiting_readers;
400015ae:	8b 43 1c             	mov    0x1c(%ebx),%eax
400015b1:	83 e8 01             	sub    $0x1,%eax
400015b4:	89 43 1c             	mov    %eax,0x1c(%ebx)
    ++rw->active_readers;
400015b7:	8b 43 14             	mov    0x14(%ebx),%eax
400015ba:	83 c0 01             	add    $0x1,%eax
400015bd:	89 43 14             	mov    %eax,0x14(%ebx)

    spinlock_release(&rw->lock);
400015c0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
400015c4:	83 c4 04             	add    $0x4,%esp
400015c7:	5b                   	pop    %ebx
400015c8:	5e                   	pop    %esi
    spinlock_release(&rw->lock);
400015c9:	e9 b2 f5 ff ff       	jmp    40000b80 <spinlock_release>
400015ce:	66 90                	xchg   %ax,%ax
	condvar_wait(&rw->read_can_go, &rw->lock);
400015d0:	83 ec 08             	sub    $0x8,%esp
400015d3:	53                   	push   %ebx
400015d4:	56                   	push   %esi
400015d5:	e8 66 fd ff ff       	call   40001340 <condvar_wait>
400015da:	83 c4 10             	add    $0x10,%esp
400015dd:	eb c1                	jmp    400015a0 <rwlock_read+0x20>
400015df:	90                   	nop

400015e0 <rwlock_done_read>:

void rwlock_done_read(rwlock_t *rw) {
400015e0:	53                   	push   %ebx
400015e1:	83 ec 14             	sub    $0x14,%esp
400015e4:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    spinlock_acquire(&rw->lock);
400015e8:	53                   	push   %ebx
400015e9:	e8 62 f5 ff ff       	call   40000b50 <spinlock_acquire>

    --rw->active_readers;
400015ee:	8b 43 14             	mov    0x14(%ebx),%eax

    if (rw->active_readers == 0 && rw->waiting_writers > 0) {
400015f1:	83 c4 10             	add    $0x10,%esp
    --rw->active_readers;
400015f4:	83 e8 01             	sub    $0x1,%eax
400015f7:	89 43 14             	mov    %eax,0x14(%ebx)
    if (rw->active_readers == 0 && rw->waiting_writers > 0) {
400015fa:	8b 43 14             	mov    0x14(%ebx),%eax
400015fd:	85 c0                	test   %eax,%eax
400015ff:	75 07                	jne    40001608 <rwlock_done_read+0x28>
40001601:	8b 43 20             	mov    0x20(%ebx),%eax
40001604:	85 c0                	test   %eax,%eax
40001606:	75 10                	jne    40001618 <rwlock_done_read+0x38>
	condvar_signal(&rw->write_can_go);
    }

    spinlock_release(&rw->lock);
40001608:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
4000160c:	83 c4 08             	add    $0x8,%esp
4000160f:	5b                   	pop    %ebx
    spinlock_release(&rw->lock);
40001610:	e9 6b f5 ff ff       	jmp    40000b80 <spinlock_release>
40001615:	8d 76 00             	lea    0x0(%esi),%esi
	condvar_signal(&rw->write_can_go);
40001618:	83 ec 0c             	sub    $0xc,%esp
4000161b:	8d 43 0c             	lea    0xc(%ebx),%eax
4000161e:	50                   	push   %eax
4000161f:	e8 6c fd ff ff       	call   40001390 <condvar_signal>
40001624:	83 c4 10             	add    $0x10,%esp
    spinlock_release(&rw->lock);
40001627:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
4000162b:	83 c4 08             	add    $0x8,%esp
4000162e:	5b                   	pop    %ebx
    spinlock_release(&rw->lock);
4000162f:	e9 4c f5 ff ff       	jmp    40000b80 <spinlock_release>
40001634:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000163b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000163f:	90                   	nop

40001640 <rwlock_write>:

void rwlock_write(rwlock_t *rw) {
40001640:	56                   	push   %esi
40001641:	53                   	push   %ebx
40001642:	83 ec 10             	sub    $0x10,%esp
40001645:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    spinlock_acquire(&rw->lock);
40001649:	53                   	push   %ebx

    ++rw->waiting_writers;

    while (!write_can_go(rw)) {
	condvar_wait(&rw->write_can_go, &rw->lock);
4000164a:	8d 73 0c             	lea    0xc(%ebx),%esi
    spinlock_acquire(&rw->lock);
4000164d:	e8 fe f4 ff ff       	call   40000b50 <spinlock_acquire>
    ++rw->waiting_writers;
40001652:	8b 43 20             	mov    0x20(%ebx),%eax
    while (!write_can_go(rw)) {
40001655:	83 c4 10             	add    $0x10,%esp
    ++rw->waiting_writers;
40001658:	83 c0 01             	add    $0x1,%eax
4000165b:	89 43 20             	mov    %eax,0x20(%ebx)
    while (!write_can_go(rw)) {
4000165e:	66 90                	xchg   %ax,%ax
    return rw->active_writers == 0 && rw->active_readers == 0;
40001660:	8b 43 18             	mov    0x18(%ebx),%eax
40001663:	85 c0                	test   %eax,%eax
40001665:	75 29                	jne    40001690 <rwlock_write+0x50>
40001667:	8b 43 14             	mov    0x14(%ebx),%eax
4000166a:	85 c0                	test   %eax,%eax
4000166c:	75 22                	jne    40001690 <rwlock_write+0x50>
    }

    --rw->waiting_writers;
4000166e:	8b 43 20             	mov    0x20(%ebx),%eax
40001671:	83 e8 01             	sub    $0x1,%eax
40001674:	89 43 20             	mov    %eax,0x20(%ebx)
    ++rw->active_writers;
40001677:	8b 43 18             	mov    0x18(%ebx),%eax
4000167a:	83 c0 01             	add    $0x1,%eax
4000167d:	89 43 18             	mov    %eax,0x18(%ebx)

    spinlock_release(&rw->lock);
40001680:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
40001684:	83 c4 04             	add    $0x4,%esp
40001687:	5b                   	pop    %ebx
40001688:	5e                   	pop    %esi
    spinlock_release(&rw->lock);
40001689:	e9 f2 f4 ff ff       	jmp    40000b80 <spinlock_release>
4000168e:	66 90                	xchg   %ax,%ax
	condvar_wait(&rw->write_can_go, &rw->lock);
40001690:	83 ec 08             	sub    $0x8,%esp
40001693:	53                   	push   %ebx
40001694:	56                   	push   %esi
40001695:	e8 a6 fc ff ff       	call   40001340 <condvar_wait>
4000169a:	83 c4 10             	add    $0x10,%esp
4000169d:	eb c1                	jmp    40001660 <rwlock_write+0x20>
4000169f:	90                   	nop

400016a0 <rwlock_done_write>:

void rwlock_done_write(rwlock_t *rw) {
400016a0:	53                   	push   %ebx
400016a1:	83 ec 14             	sub    $0x14,%esp
400016a4:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    spinlock_acquire(&rw->lock);
400016a8:	53                   	push   %ebx
400016a9:	e8 a2 f4 ff ff       	call   40000b50 <spinlock_acquire>

    --rw->active_writers;
400016ae:	8b 43 18             	mov    0x18(%ebx),%eax

    if (rw->waiting_writers > 0) {
400016b1:	83 c4 10             	add    $0x10,%esp
    --rw->active_writers;
400016b4:	83 e8 01             	sub    $0x1,%eax
400016b7:	89 43 18             	mov    %eax,0x18(%ebx)
    if (rw->waiting_writers > 0) {
400016ba:	8b 43 20             	mov    0x20(%ebx),%eax
400016bd:	85 c0                	test   %eax,%eax
400016bf:	74 1f                	je     400016e0 <rwlock_done_write+0x40>
	condvar_signal(&rw->write_can_go);
400016c1:	83 ec 0c             	sub    $0xc,%esp
400016c4:	8d 43 0c             	lea    0xc(%ebx),%eax
400016c7:	50                   	push   %eax
400016c8:	e8 c3 fc ff ff       	call   40001390 <condvar_signal>
400016cd:	83 c4 10             	add    $0x10,%esp
	//    condvar_signal(&rw->read_can_go);
	//}
	condvar_broadcast(&rw->read_can_go);
    }

    spinlock_release(&rw->lock);
400016d0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
400016d4:	83 c4 08             	add    $0x8,%esp
400016d7:	5b                   	pop    %ebx
    spinlock_release(&rw->lock);
400016d8:	e9 a3 f4 ff ff       	jmp    40000b80 <spinlock_release>
400016dd:	8d 76 00             	lea    0x0(%esi),%esi
	condvar_broadcast(&rw->read_can_go);
400016e0:	83 ec 0c             	sub    $0xc,%esp
400016e3:	8d 43 04             	lea    0x4(%ebx),%eax
400016e6:	50                   	push   %eax
400016e7:	e8 d4 fc ff ff       	call   400013c0 <condvar_broadcast>
400016ec:	83 c4 10             	add    $0x10,%esp
    spinlock_release(&rw->lock);
400016ef:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
400016f3:	83 c4 08             	add    $0x8,%esp
400016f6:	5b                   	pop    %ebx
    spinlock_release(&rw->lock);
400016f7:	e9 84 f4 ff ff       	jmp    40000b80 <spinlock_release>
400016fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40001700 <lock>:
void lock(int TEST_TYPE) {
40001700:	55                   	push   %ebp
40001701:	57                   	push   %edi
40001702:	56                   	push   %esi
40001703:	53                   	push   %ebx
40001704:	83 ec 0c             	sub    $0xc,%esp
40001707:	8b 44 24 20          	mov    0x20(%esp),%eax
    switch (TEST_TYPE) {
4000170b:	83 f8 01             	cmp    $0x1,%eax
4000170e:	74 30                	je     40001740 <lock+0x40>
40001710:	83 f8 02             	cmp    $0x2,%eax
40001713:	0f 84 a7 00 00 00    	je     400017c0 <lock+0xc0>
40001719:	85 c0                	test   %eax,%eax
4000171b:	74 3b                	je     40001758 <lock+0x58>
	default: PANIC("lock: no matching test_type %d", TEST_TYPE);
4000171d:	50                   	push   %eax
4000171e:	68 94 31 00 40       	push   $0x40003194
40001723:	6a 35                	push   $0x35
40001725:	68 90 32 00 40       	push   $0x40003290
4000172a:	e8 41 eb ff ff       	call   40000270 <panic>
4000172f:	83 c4 10             	add    $0x10,%esp
}
40001732:	83 c4 0c             	add    $0xc,%esp
40001735:	5b                   	pop    %ebx
40001736:	5e                   	pop    %esi
40001737:	5f                   	pop    %edi
40001738:	5d                   	pop    %ebp
40001739:	c3                   	ret    
4000173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	case SPINLOCK:	   spinlock_acquire(&spinlock); break;
40001740:	c7 44 24 20 e8 67 00 	movl   $0x400067e8,0x20(%esp)
40001747:	40 
}
40001748:	83 c4 0c             	add    $0xc,%esp
4000174b:	5b                   	pop    %ebx
4000174c:	5e                   	pop    %esi
4000174d:	5f                   	pop    %edi
4000174e:	5d                   	pop    %ebp
	case SPINLOCK:	   spinlock_acquire(&spinlock); break;
4000174f:	e9 fc f3 ff ff       	jmp    40000b50 <spinlock_acquire>
40001754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    __asm __volatile ("lock; cmpxchgl %2, %0"
40001758:	ba 01 00 00 00       	mov    $0x1,%edx
4000175d:	f0 0f b1 15 e4 67 00 	lock cmpxchg %edx,0x400067e4
40001764:	40 
    if ((c = cmpxchg(&mtx->val, MUTEX_UNLOCKED, MUTEX_LOCKED_NO_WAITERS)) != MUTEX_UNLOCKED) {
40001765:	85 c0                	test   %eax,%eax
40001767:	74 c9                	je     40001732 <lock+0x32>
	if (c != MUTEX_LOCKED_WITH_WAITERS)
40001769:	83 f8 02             	cmp    $0x2,%eax
4000176c:	74 10                	je     4000177e <lock+0x7e>
    __asm __volatile ("lock; xchgl %0, %1"
4000176e:	b8 02 00 00 00       	mov    $0x2,%eax
40001773:	f0 87 05 e4 67 00 40 	lock xchg %eax,0x400067e4
	while (c != MUTEX_UNLOCKED) {
4000177a:	85 c0                	test   %eax,%eax
4000177c:	74 b4                	je     40001732 <lock+0x32>
4000177e:	bd e4 67 00 40       	mov    $0x400067e4,%ebp
40001783:	b9 04 00 00 00       	mov    $0x4,%ecx
40001788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000178f:	90                   	nop
40001790:	31 f6                	xor    %esi,%esi
40001792:	ba 02 00 00 00       	mov    $0x2,%edx
40001797:	b8 09 00 00 00       	mov    $0x9,%eax
4000179c:	89 eb                	mov    %ebp,%ebx
4000179e:	89 f7                	mov    %esi,%edi
400017a0:	cd 30                	int    $0x30
400017a2:	89 d0                	mov    %edx,%eax
400017a4:	f0 87 05 e4 67 00 40 	lock xchg %eax,0x400067e4
400017ab:	85 c0                	test   %eax,%eax
400017ad:	75 e1                	jne    40001790 <lock+0x90>
}
400017af:	83 c4 0c             	add    $0xc,%esp
400017b2:	5b                   	pop    %ebx
400017b3:	5e                   	pop    %esi
400017b4:	5f                   	pop    %edi
400017b5:	5d                   	pop    %ebp
400017b6:	c3                   	ret    
400017b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400017be:	66 90                	xchg   %ax,%ax
	case SEMAPHORE:	   semaphore_p(&semaphore); break;
400017c0:	c7 44 24 20 50 67 00 	movl   $0x40006750,0x20(%esp)
400017c7:	40 
}
400017c8:	83 c4 0c             	add    $0xc,%esp
400017cb:	5b                   	pop    %ebx
400017cc:	5e                   	pop    %esi
400017cd:	5f                   	pop    %edi
400017ce:	5d                   	pop    %ebp
	case SEMAPHORE:	   semaphore_p(&semaphore); break;
400017cf:	e9 bc fa ff ff       	jmp    40001290 <semaphore_p>
400017d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400017db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400017df:	90                   	nop

400017e0 <unlock>:
void unlock(int TEST_TYPE) {
400017e0:	57                   	push   %edi
400017e1:	56                   	push   %esi
400017e2:	53                   	push   %ebx
400017e3:	8b 74 24 10          	mov    0x10(%esp),%esi
    switch (TEST_TYPE) {
400017e7:	83 fe 01             	cmp    $0x1,%esi
400017ea:	74 24                	je     40001810 <unlock+0x30>
400017ec:	83 fe 02             	cmp    $0x2,%esi
400017ef:	74 5f                	je     40001850 <unlock+0x70>
400017f1:	85 f6                	test   %esi,%esi
400017f3:	74 2b                	je     40001820 <unlock+0x40>
	default: PANIC("unlock: no matching test_type");
400017f5:	83 ec 04             	sub    $0x4,%esp
400017f8:	68 a9 32 00 40       	push   $0x400032a9
400017fd:	6a 3e                	push   $0x3e
400017ff:	68 90 32 00 40       	push   $0x40003290
40001804:	e8 67 ea ff ff       	call   40000270 <panic>
40001809:	83 c4 10             	add    $0x10,%esp
}
4000180c:	5b                   	pop    %ebx
4000180d:	5e                   	pop    %esi
4000180e:	5f                   	pop    %edi
4000180f:	c3                   	ret    
	case SPINLOCK:	   spinlock_release(&spinlock); break;
40001810:	c7 44 24 10 e8 67 00 	movl   $0x400067e8,0x10(%esp)
40001817:	40 
}
40001818:	5b                   	pop    %ebx
40001819:	5e                   	pop    %esi
4000181a:	5f                   	pop    %edi
	case SPINLOCK:	   spinlock_release(&spinlock); break;
4000181b:	e9 60 f3 ff ff       	jmp    40000b80 <spinlock_release>
    if (__sync_fetch_and_sub(&mtx->val, 1) != MUTEX_LOCKED_NO_WAITERS) {
40001820:	f0 83 2d e4 67 00 40 	lock subl $0x1,0x400067e4
40001827:	01 
40001828:	74 e2                	je     4000180c <unlock+0x2c>
4000182a:	ba 01 00 00 00       	mov    $0x1,%edx
4000182f:	b8 09 00 00 00       	mov    $0x9,%eax
40001834:	bb e4 67 00 40       	mov    $0x400067e4,%ebx
40001839:	89 f7                	mov    %esi,%edi
	mtx->val = MUTEX_UNLOCKED;
4000183b:	c7 05 e4 67 00 40 00 	movl   $0x0,0x400067e4
40001842:	00 00 00 
40001845:	b9 08 00 00 00       	mov    $0x8,%ecx
4000184a:	cd 30                	int    $0x30
}
4000184c:	5b                   	pop    %ebx
4000184d:	5e                   	pop    %esi
4000184e:	5f                   	pop    %edi
4000184f:	c3                   	ret    
	case SEMAPHORE:	   semaphore_v(&semaphore); break;
40001850:	c7 44 24 10 50 67 00 	movl   $0x40006750,0x10(%esp)
40001857:	40 
}
40001858:	5b                   	pop    %ebx
40001859:	5e                   	pop    %esi
4000185a:	5f                   	pop    %edi
	case SEMAPHORE:	   semaphore_v(&semaphore); break;
4000185b:	e9 90 fa ff ff       	jmp    400012f0 <semaphore_v>

40001860 <print>:
void print(int TEST_TYPE, const char *s) {
40001860:	83 ec 0c             	sub    $0xc,%esp
    if (getpid() == pids[0]) {
40001863:	e8 88 08 00 00       	call   400020f0 <getpid>
40001868:	3b 05 ec 67 00 40    	cmp    0x400067ec,%eax
4000186e:	74 08                	je     40001878 <print+0x18>
}
40001870:	83 c4 0c             	add    $0xc,%esp
40001873:	c3                   	ret    
40001874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	printf("TEST_%s %s\n", test_name[TEST_TYPE], s);
40001878:	83 ec 04             	sub    $0x4,%esp
4000187b:	ff 74 24 18          	pushl  0x18(%esp)
4000187f:	8b 44 24 18          	mov    0x18(%esp),%eax
40001883:	ff 34 85 00 60 00 40 	pushl  0x40006000(,%eax,4)
4000188a:	68 c7 32 00 40       	push   $0x400032c7
4000188f:	e8 4c eb ff ff       	call   400003e0 <printf>
}
40001894:	83 c4 10             	add    $0x10,%esp
40001897:	83 c4 0c             	add    $0xc,%esp
4000189a:	c3                   	ret    
4000189b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000189f:	90                   	nop

400018a0 <concurrency_test>:
void concurrency_test() {
400018a0:	83 ec 14             	sub    $0x14,%esp
    print(TEST_TYPE, "started");
400018a3:	68 d3 32 00 40       	push   $0x400032d3
400018a8:	6a 04                	push   $0x4
400018aa:	e8 b1 ff ff ff       	call   40001860 <print>
    barrier_wait(&barrier);
400018af:	c7 04 24 84 67 00 40 	movl   $0x40006784,(%esp)
400018b6:	e8 95 f8 ff ff       	call   40001150 <barrier_wait>
400018bb:	83 c4 10             	add    $0x10,%esp
400018be:	ba 50 c3 00 00       	mov    $0xc350,%edx
400018c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400018c7:	90                   	nop
	++totals[TEST_TYPE];
400018c8:	a1 d0 65 00 40       	mov    0x400065d0,%eax
400018cd:	83 c0 01             	add    $0x1,%eax
400018d0:	a3 d0 65 00 40       	mov    %eax,0x400065d0
    for (int i = 0; i < TEST_ITERATION; ++i) {
400018d5:	83 ea 01             	sub    $0x1,%edx
400018d8:	75 ee                	jne    400018c8 <concurrency_test+0x28>
    printf("pid %u 100%\n", getpid());
400018da:	e8 11 08 00 00       	call   400020f0 <getpid>
400018df:	83 ec 08             	sub    $0x8,%esp
400018e2:	50                   	push   %eax
400018e3:	68 db 32 00 40       	push   $0x400032db
400018e8:	e8 f3 ea ff ff       	call   400003e0 <printf>
    barrier_wait(&barrier);
400018ed:	c7 04 24 84 67 00 40 	movl   $0x40006784,(%esp)
400018f4:	e8 57 f8 ff ff       	call   40001150 <barrier_wait>
    if (totals[TEST_TYPE] == NUM_THREADS * TEST_ITERATION) {
400018f9:	a1 d0 65 00 40       	mov    0x400065d0,%eax
400018fe:	83 c4 10             	add    $0x10,%esp
40001901:	3d 40 0d 03 00       	cmp    $0x30d40,%eax
40001906:	74 16                	je     4000191e <concurrency_test+0x7e>
	print(TEST_TYPE, "passed.");
40001908:	83 ec 08             	sub    $0x8,%esp
4000190b:	68 e8 32 00 40       	push   $0x400032e8
40001910:	6a 04                	push   $0x4
40001912:	e8 49 ff ff ff       	call   40001860 <print>
40001917:	83 c4 10             	add    $0x10,%esp
}
4000191a:	83 c4 0c             	add    $0xc,%esp
4000191d:	c3                   	ret    
	PANIC("TEST_%s: failed, expect total should not be %u, got %u\n", test_name[TEST_TYPE], NUM_THREADS * TEST_ITERATION, totals[TEST_TYPE]);
4000191e:	a1 d0 65 00 40       	mov    0x400065d0,%eax
40001923:	83 ec 08             	sub    $0x8,%esp
40001926:	50                   	push   %eax
40001927:	68 40 0d 03 00       	push   $0x30d40
4000192c:	ff 35 10 60 00 40    	pushl  0x40006010
40001932:	68 b4 31 00 40       	push   $0x400031b4
40001937:	6a 58                	push   $0x58
40001939:	68 90 32 00 40       	push   $0x40003290
4000193e:	e8 2d e9 ff ff       	call   40000270 <panic>
}
40001943:	83 c4 20             	add    $0x20,%esp
40001946:	83 c4 0c             	add    $0xc,%esp
40001949:	c3                   	ret    
4000194a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40001950 <adding_test>:
void adding_test(int TEST_TYPE) {
40001950:	56                   	push   %esi
    barrier_wait(&barrier);
40001951:	be 50 c3 00 00       	mov    $0xc350,%esi
void adding_test(int TEST_TYPE) {
40001956:	53                   	push   %ebx
40001957:	83 ec 0c             	sub    $0xc,%esp
4000195a:	8b 5c 24 18          	mov    0x18(%esp),%ebx
    print(TEST_TYPE, "started");
4000195e:	68 d3 32 00 40       	push   $0x400032d3
40001963:	53                   	push   %ebx
40001964:	e8 f7 fe ff ff       	call   40001860 <print>
    barrier_wait(&barrier);
40001969:	c7 04 24 84 67 00 40 	movl   $0x40006784,(%esp)
40001970:	e8 db f7 ff ff       	call   40001150 <barrier_wait>
40001975:	83 c4 10             	add    $0x10,%esp
40001978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000197f:	90                   	nop
	lock(TEST_TYPE);
40001980:	83 ec 0c             	sub    $0xc,%esp
40001983:	53                   	push   %ebx
40001984:	e8 77 fd ff ff       	call   40001700 <lock>
	++totals[TEST_TYPE];
40001989:	8b 04 9d c0 65 00 40 	mov    0x400065c0(,%ebx,4),%eax
	unlock(TEST_TYPE);
40001990:	89 1c 24             	mov    %ebx,(%esp)
	++totals[TEST_TYPE];
40001993:	83 c0 01             	add    $0x1,%eax
40001996:	89 04 9d c0 65 00 40 	mov    %eax,0x400065c0(,%ebx,4)
	unlock(TEST_TYPE);
4000199d:	e8 3e fe ff ff       	call   400017e0 <unlock>
    for (int i = 0; i < TEST_ITERATION; ++i) {
400019a2:	83 c4 10             	add    $0x10,%esp
400019a5:	83 ee 01             	sub    $0x1,%esi
400019a8:	75 d6                	jne    40001980 <adding_test+0x30>
    printf("pid %u 100%\n", getpid());
400019aa:	e8 41 07 00 00       	call   400020f0 <getpid>
400019af:	83 ec 08             	sub    $0x8,%esp
400019b2:	50                   	push   %eax
400019b3:	68 db 32 00 40       	push   $0x400032db
400019b8:	e8 23 ea ff ff       	call   400003e0 <printf>
    barrier_wait(&barrier);
400019bd:	c7 04 24 84 67 00 40 	movl   $0x40006784,(%esp)
400019c4:	e8 87 f7 ff ff       	call   40001150 <barrier_wait>
    if (totals[TEST_TYPE] != NUM_THREADS * TEST_ITERATION) {
400019c9:	8b 04 9d c0 65 00 40 	mov    0x400065c0(,%ebx,4),%eax
400019d0:	83 c4 10             	add    $0x10,%esp
400019d3:	3d 40 0d 03 00       	cmp    $0x30d40,%eax
400019d8:	74 31                	je     40001a0b <adding_test+0xbb>
	PANIC("TEST_%s: failed expect total %u got %u\n", test_name[TEST_TYPE], NUM_THREADS * TEST_ITERATION, totals[TEST_TYPE]);
400019da:	8b 04 9d c0 65 00 40 	mov    0x400065c0(,%ebx,4),%eax
400019e1:	83 ec 08             	sub    $0x8,%esp
400019e4:	50                   	push   %eax
400019e5:	68 40 0d 03 00       	push   $0x30d40
400019ea:	ff 34 9d 00 60 00 40 	pushl  0x40006000(,%ebx,4)
400019f1:	68 ec 31 00 40       	push   $0x400031ec
400019f6:	6a 71                	push   $0x71
400019f8:	68 90 32 00 40       	push   $0x40003290
400019fd:	e8 6e e8 ff ff       	call   40000270 <panic>
}
40001a02:	83 c4 20             	add    $0x20,%esp
40001a05:	83 c4 04             	add    $0x4,%esp
40001a08:	5b                   	pop    %ebx
40001a09:	5e                   	pop    %esi
40001a0a:	c3                   	ret    
	print(TEST_TYPE, "passed");
40001a0b:	83 ec 08             	sub    $0x8,%esp
40001a0e:	68 f0 32 00 40       	push   $0x400032f0
40001a13:	53                   	push   %ebx
40001a14:	e8 47 fe ff ff       	call   40001860 <print>
40001a19:	83 c4 10             	add    $0x10,%esp
}
40001a1c:	83 c4 04             	add    $0x4,%esp
40001a1f:	5b                   	pop    %ebx
40001a20:	5e                   	pop    %esi
40001a21:	c3                   	ret    
40001a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40001a30 <barrier_test>:
void barrier_test() {
40001a30:	53                   	push   %ebx
40001a31:	83 ec 10             	sub    $0x10,%esp
    print(BARRIER, "started");
40001a34:	68 d3 32 00 40       	push   $0x400032d3
40001a39:	6a 03                	push   $0x3
40001a3b:	e8 20 fe ff ff       	call   40001860 <print>
    pid_t pid = getpid();
40001a40:	e8 ab 06 00 00       	call   400020f0 <getpid>
    barrier_wait(&barrier);
40001a45:	c7 04 24 84 67 00 40 	movl   $0x40006784,(%esp)
    pid_t pid = getpid();
40001a4c:	89 c3                	mov    %eax,%ebx
    barrier_wait(&barrier);
40001a4e:	e8 fd f6 ff ff       	call   40001150 <barrier_wait>
    if (pid == pids[0]) printf("checkpoint1\n");
40001a53:	83 c4 10             	add    $0x10,%esp
40001a56:	39 1d ec 67 00 40    	cmp    %ebx,0x400067ec
40001a5c:	74 62                	je     40001ac0 <barrier_test+0x90>
    barrier_wait(&barrier);
40001a5e:	83 ec 0c             	sub    $0xc,%esp
40001a61:	68 84 67 00 40       	push   $0x40006784
40001a66:	e8 e5 f6 ff ff       	call   40001150 <barrier_wait>
    if (pid == pids[0]) printf("checkpoint2\n");
40001a6b:	83 c4 10             	add    $0x10,%esp
40001a6e:	39 1d ec 67 00 40    	cmp    %ebx,0x400067ec
40001a74:	0f 84 8e 00 00 00    	je     40001b08 <barrier_test+0xd8>
    barrier_wait(&barrier);
40001a7a:	83 ec 0c             	sub    $0xc,%esp
40001a7d:	68 84 67 00 40       	push   $0x40006784
40001a82:	e8 c9 f6 ff ff       	call   40001150 <barrier_wait>
    if (pid == pids[0]) printf("checkpoint3\n");
40001a87:	83 c4 10             	add    $0x10,%esp
40001a8a:	39 1d ec 67 00 40    	cmp    %ebx,0x400067ec
40001a90:	74 5e                	je     40001af0 <barrier_test+0xc0>
    barrier_wait(&barrier);
40001a92:	83 ec 0c             	sub    $0xc,%esp
40001a95:	68 84 67 00 40       	push   $0x40006784
40001a9a:	e8 b1 f6 ff ff       	call   40001150 <barrier_wait>
    if (pid == pids[0]) printf("checkpoint4\n");
40001a9f:	83 c4 10             	add    $0x10,%esp
40001aa2:	39 1d ec 67 00 40    	cmp    %ebx,0x400067ec
40001aa8:	74 2e                	je     40001ad8 <barrier_test+0xa8>
    print(BARRIER, "passed");
40001aaa:	83 ec 08             	sub    $0x8,%esp
40001aad:	68 f0 32 00 40       	push   $0x400032f0
40001ab2:	6a 03                	push   $0x3
40001ab4:	e8 a7 fd ff ff       	call   40001860 <print>
}
40001ab9:	83 c4 18             	add    $0x18,%esp
40001abc:	5b                   	pop    %ebx
40001abd:	c3                   	ret    
40001abe:	66 90                	xchg   %ax,%ax
    if (pid == pids[0]) printf("checkpoint1\n");
40001ac0:	83 ec 0c             	sub    $0xc,%esp
40001ac3:	68 f7 32 00 40       	push   $0x400032f7
40001ac8:	e8 13 e9 ff ff       	call   400003e0 <printf>
40001acd:	83 c4 10             	add    $0x10,%esp
40001ad0:	eb 8c                	jmp    40001a5e <barrier_test+0x2e>
40001ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (pid == pids[0]) printf("checkpoint4\n");
40001ad8:	83 ec 0c             	sub    $0xc,%esp
40001adb:	68 1e 33 00 40       	push   $0x4000331e
40001ae0:	e8 fb e8 ff ff       	call   400003e0 <printf>
40001ae5:	83 c4 10             	add    $0x10,%esp
40001ae8:	eb c0                	jmp    40001aaa <barrier_test+0x7a>
40001aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (pid == pids[0]) printf("checkpoint3\n");
40001af0:	83 ec 0c             	sub    $0xc,%esp
40001af3:	68 11 33 00 40       	push   $0x40003311
40001af8:	e8 e3 e8 ff ff       	call   400003e0 <printf>
40001afd:	83 c4 10             	add    $0x10,%esp
40001b00:	eb 90                	jmp    40001a92 <barrier_test+0x62>
40001b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (pid == pids[0]) printf("checkpoint2\n");
40001b08:	83 ec 0c             	sub    $0xc,%esp
40001b0b:	68 04 33 00 40       	push   $0x40003304
40001b10:	e8 cb e8 ff ff       	call   400003e0 <printf>
40001b15:	83 c4 10             	add    $0x10,%esp
40001b18:	e9 5d ff ff ff       	jmp    40001a7a <barrier_test+0x4a>
40001b1d:	8d 76 00             	lea    0x0(%esi),%esi

40001b20 <rwlock_test>:
void rwlock_test(int TEST_TYPE) {
40001b20:	56                   	push   %esi
40001b21:	53                   	push   %ebx
40001b22:	83 ec 1c             	sub    $0x1c,%esp
40001b25:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    print(TEST_TYPE, "started");
40001b29:	68 d3 32 00 40       	push   $0x400032d3
40001b2e:	53                   	push   %ebx
40001b2f:	e8 2c fd ff ff       	call   40001860 <print>
    barrier_wait(&barrier);
40001b34:	c7 04 24 84 67 00 40 	movl   $0x40006784,(%esp)
40001b3b:	e8 10 f6 ff ff       	call   40001150 <barrier_wait>
    pid_t pid = getpid();
40001b40:	e8 ab 05 00 00       	call   400020f0 <getpid>
    if (pid == pids[0] || pid == pids[2]) {
40001b45:	83 c4 10             	add    $0x10,%esp
    pid_t pid = getpid();
40001b48:	89 c6                	mov    %eax,%esi
    if (pid == pids[0] || pid == pids[2]) {
40001b4a:	39 05 ec 67 00 40    	cmp    %eax,0x400067ec
40001b50:	74 0c                	je     40001b5e <rwlock_test+0x3e>
40001b52:	39 05 f4 67 00 40    	cmp    %eax,0x400067f4
40001b58:	0f 85 22 01 00 00    	jne    40001c80 <rwlock_test+0x160>
	printf("pid %u writer\n", getpid());
40001b5e:	e8 8d 05 00 00       	call   400020f0 <getpid>
40001b63:	83 ec 08             	sub    $0x8,%esp
40001b66:	50                   	push   %eax
40001b67:	68 2b 33 00 40       	push   $0x4000332b
40001b6c:	e8 6f e8 ff ff       	call   400003e0 <printf>
40001b71:	83 c4 10             	add    $0x10,%esp
    for (volatile int i = 0; i < TEST_ITERATION; ++i) {
40001b74:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40001b7b:	00 
40001b7c:	8b 44 24 0c          	mov    0xc(%esp),%eax
40001b80:	3d 4f c3 00 00       	cmp    $0xc34f,%eax
40001b85:	7e 43                	jle    40001bca <rwlock_test+0xaa>
40001b87:	e9 8c 00 00 00       	jmp    40001c18 <rwlock_test+0xf8>
40001b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (pid == pids[0] || pid == pids[2]) {
40001b90:	39 35 f4 67 00 40    	cmp    %esi,0x400067f4
40001b96:	74 3a                	je     40001bd2 <rwlock_test+0xb2>
	    rwlock_read(&rwlock);
40001b98:	83 ec 0c             	sub    $0xc,%esp
40001b9b:	68 60 67 00 40       	push   $0x40006760
40001ba0:	e8 db f9 ff ff       	call   40001580 <rwlock_read>
	    rwlock_done_read(&rwlock);
40001ba5:	c7 04 24 60 67 00 40 	movl   $0x40006760,(%esp)
40001bac:	e8 2f fa ff ff       	call   400015e0 <rwlock_done_read>
40001bb1:	83 c4 10             	add    $0x10,%esp
    for (volatile int i = 0; i < TEST_ITERATION; ++i) {
40001bb4:	8b 44 24 0c          	mov    0xc(%esp),%eax
40001bb8:	83 c0 01             	add    $0x1,%eax
40001bbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
40001bbf:	8b 44 24 0c          	mov    0xc(%esp),%eax
40001bc3:	3d 4f c3 00 00       	cmp    $0xc34f,%eax
40001bc8:	7f 4e                	jg     40001c18 <rwlock_test+0xf8>
	if (pid == pids[0] || pid == pids[2]) {
40001bca:	39 35 ec 67 00 40    	cmp    %esi,0x400067ec
40001bd0:	75 be                	jne    40001b90 <rwlock_test+0x70>
	    if (i % write_freq == 0) {
40001bd2:	8b 44 24 0c          	mov    0xc(%esp),%eax
40001bd6:	69 c0 91 7e fb 3a    	imul   $0x3afb7e91,%eax,%eax
40001bdc:	c1 c8 04             	ror    $0x4,%eax
40001bdf:	3d b8 8d 06 00       	cmp    $0x68db8,%eax
40001be4:	77 ce                	ja     40001bb4 <rwlock_test+0x94>
		rwlock_write(&rwlock);
40001be6:	83 ec 0c             	sub    $0xc,%esp
40001be9:	68 60 67 00 40       	push   $0x40006760
40001bee:	e8 4d fa ff ff       	call   40001640 <rwlock_write>
		++totals[TEST_TYPE];
40001bf3:	8b 04 9d c0 65 00 40 	mov    0x400065c0(,%ebx,4),%eax
		rwlock_done_write(&rwlock);
40001bfa:	c7 04 24 60 67 00 40 	movl   $0x40006760,(%esp)
		++totals[TEST_TYPE];
40001c01:	83 c0 01             	add    $0x1,%eax
40001c04:	89 04 9d c0 65 00 40 	mov    %eax,0x400065c0(,%ebx,4)
		rwlock_done_write(&rwlock);
40001c0b:	e8 90 fa ff ff       	call   400016a0 <rwlock_done_write>
40001c10:	83 c4 10             	add    $0x10,%esp
40001c13:	eb 9f                	jmp    40001bb4 <rwlock_test+0x94>
40001c15:	8d 76 00             	lea    0x0(%esi),%esi
    printf("pid %u 100%\n", getpid());
40001c18:	e8 d3 04 00 00       	call   400020f0 <getpid>
40001c1d:	83 ec 08             	sub    $0x8,%esp
40001c20:	50                   	push   %eax
40001c21:	68 db 32 00 40       	push   $0x400032db
40001c26:	e8 b5 e7 ff ff       	call   400003e0 <printf>
    barrier_wait(&barrier);
40001c2b:	c7 04 24 84 67 00 40 	movl   $0x40006784,(%esp)
40001c32:	e8 19 f5 ff ff       	call   40001150 <barrier_wait>
    if (totals[TEST_TYPE] != expected) {
40001c37:	8b 04 9d c0 65 00 40 	mov    0x400065c0(,%ebx,4),%eax
40001c3e:	83 c4 10             	add    $0x10,%esp
40001c41:	83 f8 0a             	cmp    $0xa,%eax
40001c44:	74 5a                	je     40001ca0 <rwlock_test+0x180>
	PANIC("TEST_%s: failed expect total %u got %u\n", test_name[TEST_TYPE], expected, totals[TEST_TYPE]);
40001c46:	8b 04 9d c0 65 00 40 	mov    0x400065c0(,%ebx,4),%eax
40001c4d:	83 ec 08             	sub    $0x8,%esp
40001c50:	50                   	push   %eax
40001c51:	6a 0a                	push   $0xa
40001c53:	ff 34 9d 00 60 00 40 	pushl  0x40006000(,%ebx,4)
40001c5a:	68 ec 31 00 40       	push   $0x400031ec
40001c5f:	68 ad 00 00 00       	push   $0xad
40001c64:	68 90 32 00 40       	push   $0x40003290
40001c69:	e8 02 e6 ff ff       	call   40000270 <panic>
40001c6e:	83 c4 20             	add    $0x20,%esp
}
40001c71:	83 c4 14             	add    $0x14,%esp
40001c74:	5b                   	pop    %ebx
40001c75:	5e                   	pop    %esi
40001c76:	c3                   	ret    
40001c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001c7e:	66 90                	xchg   %ax,%ax
	printf("pid %u reader\n", getpid());
40001c80:	e8 6b 04 00 00       	call   400020f0 <getpid>
40001c85:	83 ec 08             	sub    $0x8,%esp
40001c88:	50                   	push   %eax
40001c89:	68 3a 33 00 40       	push   $0x4000333a
40001c8e:	e8 4d e7 ff ff       	call   400003e0 <printf>
40001c93:	83 c4 10             	add    $0x10,%esp
40001c96:	e9 d9 fe ff ff       	jmp    40001b74 <rwlock_test+0x54>
40001c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40001c9f:	90                   	nop
	print(TEST_TYPE, "passed");
40001ca0:	83 ec 08             	sub    $0x8,%esp
40001ca3:	68 f0 32 00 40       	push   $0x400032f0
40001ca8:	53                   	push   %ebx
40001ca9:	e8 b2 fb ff ff       	call   40001860 <print>
40001cae:	83 c4 10             	add    $0x10,%esp
}
40001cb1:	83 c4 14             	add    $0x14,%esp
40001cb4:	5b                   	pop    %ebx
40001cb5:	5e                   	pop    %esi
40001cb6:	c3                   	ret    
40001cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001cbe:	66 90                	xchg   %ax,%ax

40001cc0 <bounded_buffer_test>:
void bounded_buffer_test(int TEST_TYPE) {
40001cc0:	55                   	push   %ebp
40001cc1:	57                   	push   %edi
40001cc2:	56                   	push   %esi
40001cc3:	53                   	push   %ebx
40001cc4:	83 ec 24             	sub    $0x24,%esp
40001cc7:	8b 74 24 38          	mov    0x38(%esp),%esi
    print(TEST_TYPE, "started");
40001ccb:	68 d3 32 00 40       	push   $0x400032d3
40001cd0:	56                   	push   %esi
40001cd1:	e8 8a fb ff ff       	call   40001860 <print>
    barrier_wait(&barrier);
40001cd6:	c7 04 24 84 67 00 40 	movl   $0x40006784,(%esp)
40001cdd:	e8 6e f4 ff ff       	call   40001150 <barrier_wait>
    pid_t pid = getpid();
40001ce2:	e8 09 04 00 00       	call   400020f0 <getpid>
    if (pid == pids[0]) {
40001ce7:	83 c4 10             	add    $0x10,%esp
    pid_t pid = getpid();
40001cea:	89 c7                	mov    %eax,%edi
    if (pid == pids[0]) {
40001cec:	a1 ec 67 00 40       	mov    0x400067ec,%eax
40001cf1:	39 f8                	cmp    %edi,%eax
40001cf3:	0f 84 37 01 00 00    	je     40001e30 <bounded_buffer_test+0x170>
    } else if (pid == pids[1]) {
40001cf9:	39 3d f0 67 00 40    	cmp    %edi,0x400067f0
40001cff:	0f 84 4b 01 00 00    	je     40001e50 <bounded_buffer_test+0x190>
void bounded_buffer_test(int TEST_TYPE) {
40001d05:	c7 44 24 0c e8 03 00 	movl   $0x3e8,0xc(%esp)
40001d0c:	00 
	      bounded_queue_push(&bq, item);
40001d0d:	bd 0b 00 00 00       	mov    $0xb,%ebp
40001d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void bounded_buffer_test(int TEST_TYPE) {
40001d18:	bb 0a 00 00 00       	mov    $0xa,%ebx
40001d1d:	eb 12                	jmp    40001d31 <bounded_buffer_test+0x71>
40001d1f:	90                   	nop
	  } else if (pid == pids[1]) {
40001d20:	39 3d f0 67 00 40    	cmp    %edi,0x400067f0
40001d26:	0f 84 a4 00 00 00    	je     40001dd0 <bounded_buffer_test+0x110>
	for (int item = 1; item <= 10; ++item) {
40001d2c:	83 eb 01             	sub    $0x1,%ebx
40001d2f:	74 23                	je     40001d54 <bounded_buffer_test+0x94>
	  if (pid == pids[0]) {
40001d31:	39 c7                	cmp    %eax,%edi
40001d33:	75 eb                	jne    40001d20 <bounded_buffer_test+0x60>
	      bounded_queue_push(&bq, item);
40001d35:	89 e8                	mov    %ebp,%eax
40001d37:	83 ec 08             	sub    $0x8,%esp
40001d3a:	29 d8                	sub    %ebx,%eax
40001d3c:	50                   	push   %eax
40001d3d:	68 a0 67 00 40       	push   $0x400067a0
40001d42:	e8 e9 f6 ff ff       	call   40001430 <bounded_queue_push>
40001d47:	a1 ec 67 00 40       	mov    0x400067ec,%eax
40001d4c:	83 c4 10             	add    $0x10,%esp
	for (int item = 1; item <= 10; ++item) {
40001d4f:	83 eb 01             	sub    $0x1,%ebx
40001d52:	75 dd                	jne    40001d31 <bounded_buffer_test+0x71>
    for (int i = 0; i < iter; ++i) {
40001d54:	83 6c 24 0c 01       	subl   $0x1,0xc(%esp)
40001d59:	75 bd                	jne    40001d18 <bounded_buffer_test+0x58>
    if (pid == pids[0] || pid == pids[1])
40001d5b:	39 c7                	cmp    %eax,%edi
40001d5d:	0f 84 99 00 00 00    	je     40001dfc <bounded_buffer_test+0x13c>
40001d63:	39 3d f0 67 00 40    	cmp    %edi,0x400067f0
40001d69:	0f 84 8d 00 00 00    	je     40001dfc <bounded_buffer_test+0x13c>
    barrier_wait(&barrier);
40001d6f:	83 ec 0c             	sub    $0xc,%esp
40001d72:	68 84 67 00 40       	push   $0x40006784
40001d77:	e8 d4 f3 ff ff       	call   40001150 <barrier_wait>
    if (totals[TEST_TYPE] != expected) {
40001d7c:	8b 04 b5 c0 65 00 40 	mov    0x400065c0(,%esi,4),%eax
40001d83:	83 c4 10             	add    $0x10,%esp
40001d86:	3d d8 d6 00 00       	cmp    $0xd6d8,%eax
40001d8b:	0f 84 86 00 00 00    	je     40001e17 <bounded_buffer_test+0x157>
	PANIC("TEST_%s: failed expect total %u got %u\n", test_name[TEST_TYPE], expected, totals[TEST_TYPE]);
40001d91:	8b 04 b5 c0 65 00 40 	mov    0x400065c0(,%esi,4),%eax
40001d98:	83 ec 08             	sub    $0x8,%esp
40001d9b:	50                   	push   %eax
40001d9c:	68 d8 d6 00 00       	push   $0xd6d8
40001da1:	ff 34 b5 00 60 00 40 	pushl  0x40006000(,%esi,4)
40001da8:	68 ec 31 00 40       	push   $0x400031ec
40001dad:	68 d2 00 00 00       	push   $0xd2
40001db2:	68 90 32 00 40       	push   $0x40003290
40001db7:	e8 b4 e4 ff ff       	call   40000270 <panic>
40001dbc:	83 c4 20             	add    $0x20,%esp
}
40001dbf:	83 c4 1c             	add    $0x1c,%esp
40001dc2:	5b                   	pop    %ebx
40001dc3:	5e                   	pop    %esi
40001dc4:	5f                   	pop    %edi
40001dc5:	5d                   	pop    %ebp
40001dc6:	c3                   	ret    
40001dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001dce:	66 90                	xchg   %ax,%ax
	      totals[TEST_TYPE] += bounded_queue_pop(&bq);
40001dd0:	83 ec 0c             	sub    $0xc,%esp
40001dd3:	68 a0 67 00 40       	push   $0x400067a0
40001dd8:	e8 d3 f6 ff ff       	call   400014b0 <bounded_queue_pop>
40001ddd:	83 c4 10             	add    $0x10,%esp
40001de0:	89 c1                	mov    %eax,%ecx
40001de2:	8b 04 b5 c0 65 00 40 	mov    0x400065c0(,%esi,4),%eax
40001de9:	01 c8                	add    %ecx,%eax
40001deb:	89 04 b5 c0 65 00 40 	mov    %eax,0x400065c0(,%esi,4)
40001df2:	a1 ec 67 00 40       	mov    0x400067ec,%eax
40001df7:	e9 30 ff ff ff       	jmp    40001d2c <bounded_buffer_test+0x6c>
	printf("pid %u 100%\n", getpid());
40001dfc:	e8 ef 02 00 00       	call   400020f0 <getpid>
40001e01:	83 ec 08             	sub    $0x8,%esp
40001e04:	50                   	push   %eax
40001e05:	68 db 32 00 40       	push   $0x400032db
40001e0a:	e8 d1 e5 ff ff       	call   400003e0 <printf>
40001e0f:	83 c4 10             	add    $0x10,%esp
40001e12:	e9 58 ff ff ff       	jmp    40001d6f <bounded_buffer_test+0xaf>
	print(TEST_TYPE, "passed");
40001e17:	83 ec 08             	sub    $0x8,%esp
40001e1a:	68 f0 32 00 40       	push   $0x400032f0
40001e1f:	56                   	push   %esi
40001e20:	e8 3b fa ff ff       	call   40001860 <print>
40001e25:	83 c4 10             	add    $0x10,%esp
}
40001e28:	83 c4 1c             	add    $0x1c,%esp
40001e2b:	5b                   	pop    %ebx
40001e2c:	5e                   	pop    %esi
40001e2d:	5f                   	pop    %edi
40001e2e:	5d                   	pop    %ebp
40001e2f:	c3                   	ret    
	printf("pid %u producer\n", getpid());
40001e30:	e8 bb 02 00 00       	call   400020f0 <getpid>
40001e35:	83 ec 08             	sub    $0x8,%esp
40001e38:	50                   	push   %eax
40001e39:	68 49 33 00 40       	push   $0x40003349
40001e3e:	e8 9d e5 ff ff       	call   400003e0 <printf>
    for (int i = 0; i < iter; ++i) {
40001e43:	a1 ec 67 00 40       	mov    0x400067ec,%eax
40001e48:	83 c4 10             	add    $0x10,%esp
40001e4b:	e9 b5 fe ff ff       	jmp    40001d05 <bounded_buffer_test+0x45>
	printf("pid %u consumer\n", getpid());
40001e50:	e8 9b 02 00 00       	call   400020f0 <getpid>
40001e55:	83 ec 08             	sub    $0x8,%esp
40001e58:	50                   	push   %eax
40001e59:	68 5a 33 00 40       	push   $0x4000335a
40001e5e:	e8 7d e5 ff ff       	call   400003e0 <printf>
    for (int i = 0; i < iter; ++i) {
40001e63:	a1 ec 67 00 40       	mov    0x400067ec,%eax
40001e68:	83 c4 10             	add    $0x10,%esp
40001e6b:	e9 95 fe ff ff       	jmp    40001d05 <bounded_buffer_test+0x45>

40001e70 <cmp_requeue_test>:
void cmp_requeue_test(int TEST_TYPE) {
40001e70:	55                   	push   %ebp
40001e71:	57                   	push   %edi
40001e72:	56                   	push   %esi
40001e73:	53                   	push   %ebx
40001e74:	83 ec 24             	sub    $0x24,%esp
    print(TEST_TYPE, "started");
40001e77:	68 d3 32 00 40       	push   $0x400032d3
40001e7c:	ff 74 24 3c          	pushl  0x3c(%esp)
40001e80:	e8 db f9 ff ff       	call   40001860 <print>
    volatile int woken1 = 0;
40001e85:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
40001e8c:	00 
    volatile int woken2 = 0;
40001e8d:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
40001e94:	00 
    pid_t pid = getpid();
40001e95:	e8 56 02 00 00       	call   400020f0 <getpid>
    barrier_wait(&barrier);
40001e9a:	c7 04 24 84 67 00 40 	movl   $0x40006784,(%esp)
    pid_t pid = getpid();
40001ea1:	89 c3                	mov    %eax,%ebx
    barrier_wait(&barrier);
40001ea3:	e8 a8 f2 ff ff       	call   40001150 <barrier_wait>
    if (pid == pids[1] || pid == pids[2] || pid == pids[3]) {
40001ea8:	83 c4 10             	add    $0x10,%esp
40001eab:	39 1d f0 67 00 40    	cmp    %ebx,0x400067f0
40001eb1:	0f 84 c9 00 00 00    	je     40001f80 <cmp_requeue_test+0x110>
40001eb7:	39 1d f4 67 00 40    	cmp    %ebx,0x400067f4
40001ebd:	0f 84 bd 00 00 00    	je     40001f80 <cmp_requeue_test+0x110>
40001ec3:	39 1d f8 67 00 40    	cmp    %ebx,0x400067f8
40001ec9:	0f 84 b1 00 00 00    	je     40001f80 <cmp_requeue_test+0x110>
	while (woken1 + woken2 != 3) {
40001ecf:	8b 44 24 08          	mov    0x8(%esp),%eax
40001ed3:	8b 54 24 0c          	mov    0xc(%esp),%edx
40001ed7:	bd a8 61 00 40       	mov    $0x400061a8,%ebp
40001edc:	b9 40 00 00 00       	mov    $0x40,%ecx
40001ee1:	01 d0                	add    %edx,%eax
40001ee3:	83 f8 03             	cmp    $0x3,%eax
40001ee6:	0f 84 ab 00 00 00    	je     40001f97 <cmp_requeue_test+0x127>
40001eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void cmp_requeue_test(int TEST_TYPE) {
40001ef0:	bf 10 27 00 00       	mov    $0x2710,%edi
40001ef5:	8d 76 00             	lea    0x0(%esi),%esi


gcc_inline volatile uint32_t delay(uint32_t d) {
   uint32_t i;
   for (i = 0; i < d; i++) {
       __asm volatile( "nop" ::: );
40001ef8:	90                   	nop
   for (i = 0; i < d; i++) {
40001ef9:	83 ef 01             	sub    $0x1,%edi
40001efc:	75 fa                	jne    40001ef8 <cmp_requeue_test+0x88>
40001efe:	ba 01 00 00 00       	mov    $0x1,%edx
40001f03:	b8 09 00 00 00       	mov    $0x9,%eax
40001f08:	89 eb                	mov    %ebp,%ebx
40001f0a:	be a4 61 00 40       	mov    $0x400061a4,%esi
40001f0f:	cd 30                	int    $0x30
    return errno ? errno : ret;
40001f11:	85 c0                	test   %eax,%eax
40001f13:	0f 45 d8             	cmovne %eax,%ebx
40001f16:	89 df                	mov    %ebx,%edi
	    if (ret1 < 0) {
40001f18:	85 db                	test   %ebx,%ebx
40001f1a:	0f 88 b0 00 00 00    	js     40001fd0 <cmp_requeue_test+0x160>
	    woken1 += ret1;
40001f20:	8b 5c 24 08          	mov    0x8(%esp),%ebx
40001f24:	01 df                	add    %ebx,%edi
40001f26:	89 7c 24 08          	mov    %edi,0x8(%esp)
40001f2a:	bf 10 27 00 00       	mov    $0x2710,%edi
40001f2f:	90                   	nop
       __asm volatile( "nop" ::: );
40001f30:	90                   	nop
   for (i = 0; i < d; i++) {
40001f31:	83 ef 01             	sub    $0x1,%edi
40001f34:	75 fa                	jne    40001f30 <cmp_requeue_test+0xc0>
    asm volatile ("int %2"
40001f36:	ba 01 00 00 00       	mov    $0x1,%edx
40001f3b:	b8 09 00 00 00       	mov    $0x9,%eax
40001f40:	bb a4 61 00 40       	mov    $0x400061a4,%ebx
40001f45:	89 ee                	mov    %ebp,%esi
40001f47:	cd 30                	int    $0x30
    return errno ? errno : ret;
40001f49:	85 c0                	test   %eax,%eax
40001f4b:	0f 45 d8             	cmovne %eax,%ebx
40001f4e:	89 df                	mov    %ebx,%edi
	    if (ret2 < 0) {
40001f50:	85 db                	test   %ebx,%ebx
40001f52:	0f 88 a0 00 00 00    	js     40001ff8 <cmp_requeue_test+0x188>
	    woken2 += ret2;
40001f58:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
40001f5c:	01 df                	add    %ebx,%edi
40001f5e:	89 7c 24 0c          	mov    %edi,0xc(%esp)
	while (woken1 + woken2 != 3) {
40001f62:	8b 44 24 08          	mov    0x8(%esp),%eax
40001f66:	8b 54 24 0c          	mov    0xc(%esp),%edx
40001f6a:	01 d0                	add    %edx,%eax
40001f6c:	83 f8 03             	cmp    $0x3,%eax
40001f6f:	0f 85 7b ff ff ff    	jne    40001ef0 <cmp_requeue_test+0x80>
40001f75:	eb 20                	jmp    40001f97 <cmp_requeue_test+0x127>
40001f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001f7e:	66 90                	xchg   %ax,%ax
    asm volatile ("int %2"
40001f80:	31 d2                	xor    %edx,%edx
40001f82:	b8 09 00 00 00       	mov    $0x9,%eax
40001f87:	bb a8 61 00 40       	mov    $0x400061a8,%ebx
40001f8c:	b9 04 00 00 00       	mov    $0x4,%ecx
40001f91:	89 d6                	mov    %edx,%esi
40001f93:	89 d7                	mov    %edx,%edi
40001f95:	cd 30                	int    $0x30
    printf("pid %u 100%\n", getpid());
40001f97:	e8 54 01 00 00       	call   400020f0 <getpid>
40001f9c:	83 ec 08             	sub    $0x8,%esp
40001f9f:	50                   	push   %eax
40001fa0:	68 db 32 00 40       	push   $0x400032db
40001fa5:	e8 36 e4 ff ff       	call   400003e0 <printf>
    barrier_wait(&barrier);
40001faa:	c7 04 24 84 67 00 40 	movl   $0x40006784,(%esp)
40001fb1:	e8 9a f1 ff ff       	call   40001150 <barrier_wait>
    print(TEST_TYPE, "passed");
40001fb6:	58                   	pop    %eax
40001fb7:	5a                   	pop    %edx
40001fb8:	68 f0 32 00 40       	push   $0x400032f0
40001fbd:	ff 74 24 3c          	pushl  0x3c(%esp)
40001fc1:	e8 9a f8 ff ff       	call   40001860 <print>
}
40001fc6:	83 c4 2c             	add    $0x2c,%esp
40001fc9:	5b                   	pop    %ebx
40001fca:	5e                   	pop    %esi
40001fcb:	5f                   	pop    %edi
40001fcc:	5d                   	pop    %ebp
40001fcd:	c3                   	ret    
40001fce:	66 90                	xchg   %ax,%ax
		PANIC("TEST_%s: FUTEX_CMP_REQUEUE received %d\n", ret1);
40001fd0:	53                   	push   %ebx
40001fd1:	68 14 32 00 40       	push   $0x40003214
40001fd6:	68 ec 00 00 00       	push   $0xec
40001fdb:	68 90 32 00 40       	push   $0x40003290
40001fe0:	e8 8b e2 ff ff       	call   40000270 <panic>
40001fe5:	83 c4 10             	add    $0x10,%esp
40001fe8:	b9 40 00 00 00       	mov    $0x40,%ecx
40001fed:	e9 2e ff ff ff       	jmp    40001f20 <cmp_requeue_test+0xb0>
40001ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		PANIC("TEST_%s: FUTEX_WAKE received %d\n", ret2);
40001ff8:	53                   	push   %ebx
40001ff9:	68 3c 32 00 40       	push   $0x4000323c
40001ffe:	68 f3 00 00 00       	push   $0xf3
40002003:	68 90 32 00 40       	push   $0x40003290
40002008:	e8 63 e2 ff ff       	call   40000270 <panic>
4000200d:	83 c4 10             	add    $0x10,%esp
40002010:	b9 40 00 00 00       	mov    $0x40,%ecx
40002015:	e9 3e ff ff ff       	jmp    40001f58 <cmp_requeue_test+0xe8>
4000201a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40002020 <test>:
void test(void *arg) {
40002020:	83 ec 0c             	sub    $0xc,%esp
    barrier_test();
40002023:	e8 08 fa ff ff       	call   40001a30 <barrier_test>
    if (getpid() == pids[0]) {
40002028:	e8 c3 00 00 00       	call   400020f0 <getpid>
4000202d:	3b 05 ec 67 00 40    	cmp    0x400067ec,%eax
40002033:	74 72                	je     400020a7 <test+0x87>
    concurrency_test();
40002035:	e8 66 f8 ff ff       	call   400018a0 <concurrency_test>
    adding_test(SPINLOCK);
4000203a:	83 ec 0c             	sub    $0xc,%esp
4000203d:	6a 01                	push   $0x1
4000203f:	e8 0c f9 ff ff       	call   40001950 <adding_test>
    adding_test(MUTEX);
40002044:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
4000204b:	e8 00 f9 ff ff       	call   40001950 <adding_test>
    rwlock_test(RWLOCK);
40002050:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
40002057:	e8 c4 fa ff ff       	call   40001b20 <rwlock_test>
    adding_test(SEMAPHORE);
4000205c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
40002063:	e8 e8 f8 ff ff       	call   40001950 <adding_test>
    bounded_buffer_test(BOUNDED_QUEUE);
40002068:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
4000206f:	e8 4c fc ff ff       	call   40001cc0 <bounded_buffer_test>
    cmp_requeue_test(CMP_REQUEUE);
40002074:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
4000207b:	e8 f0 fd ff ff       	call   40001e70 <cmp_requeue_test>
    if (getpid() == pids[0]) {
40002080:	e8 6b 00 00 00       	call   400020f0 <getpid>
40002085:	83 c4 10             	add    $0x10,%esp
40002088:	3b 05 ec 67 00 40    	cmp    0x400067ec,%eax
4000208e:	74 3f                	je     400020cf <test+0xaf>
    barrier_wait(&barrier);
40002090:	83 ec 0c             	sub    $0xc,%esp
40002093:	68 84 67 00 40       	push   $0x40006784
40002098:	e8 b3 f0 ff ff       	call   40001150 <barrier_wait>
    thread_exit();
4000209d:	e8 3e 01 00 00       	call   400021e0 <thread_exit>
400020a2:	83 c4 10             	add    $0x10,%esp
    while (1) {
400020a5:	eb fe                	jmp    400020a5 <test+0x85>
	printf("pids[0] %u pids[1] %u pids[2] %u pids[3] %u\n", pids[0], pids[1], pids[2], pids[3]);
400020a7:	83 ec 0c             	sub    $0xc,%esp
400020aa:	ff 35 f8 67 00 40    	pushl  0x400067f8
400020b0:	ff 35 f4 67 00 40    	pushl  0x400067f4
400020b6:	ff 35 f0 67 00 40    	pushl  0x400067f0
400020bc:	50                   	push   %eax
400020bd:	68 60 32 00 40       	push   $0x40003260
400020c2:	e8 19 e3 ff ff       	call   400003e0 <printf>
400020c7:	83 c4 20             	add    $0x20,%esp
400020ca:	e9 66 ff ff ff       	jmp    40002035 <test+0x15>
	printf("All tests passed.\n");
400020cf:	83 ec 0c             	sub    $0xc,%esp
400020d2:	68 6b 33 00 40       	push   $0x4000336b
400020d7:	e8 04 e3 ff ff       	call   400003e0 <printf>
400020dc:	83 c4 10             	add    $0x10,%esp
400020df:	eb af                	jmp    40002090 <test+0x70>
400020e1:	66 90                	xchg   %ax,%ax
400020e3:	66 90                	xchg   %ax,%ax
400020e5:	66 90                	xchg   %ax,%ax
400020e7:	66 90                	xchg   %ax,%ax
400020e9:	66 90                	xchg   %ax,%ax
400020eb:	66 90                	xchg   %ax,%ax
400020ed:	66 90                	xchg   %ax,%ax
400020ef:	90                   	nop

400020f0 <getpid>:
                  : "cc", "memory");

    return errno ? -1 : pid;
}

pid_t getpid() {
400020f0:	53                   	push   %ebx
    asm volatile ("int %2"
400020f1:	b8 08 00 00 00       	mov    $0x8,%eax
400020f6:	cd 30                	int    $0x30
    return errno ? -1 : pid;
400020f8:	85 c0                	test   %eax,%eax
400020fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
400020ff:	0f 44 c3             	cmove  %ebx,%eax
    return sys_getpid();
}
40002102:	5b                   	pop    %ebx
40002103:	c3                   	ret    
40002104:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000210b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000210f:	90                   	nop

40002110 <sys_getpid>:
40002110:	eb de                	jmp    400020f0 <getpid>
40002112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40002119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40002120 <sys_thread_create>:

pid_t sys_thread_create(uintptr_t eip, uintptr_t stack) {
40002120:	53                   	push   %ebx
    int errno;
    pid_t pid;

    asm volatile ("int %2"
40002121:	b8 05 00 00 00       	mov    $0x5,%eax
40002126:	8b 5c 24 08          	mov    0x8(%esp),%ebx
4000212a:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
4000212e:	cd 30                	int    $0x30
                    "a" (SYS_thread_create),
		    "b" (eip),
		    "c" (stack)
                  : "cc", "memory");

    return errno ? -1 : pid;
40002130:	85 c0                	test   %eax,%eax
40002132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40002137:	0f 44 c3             	cmove  %ebx,%eax
}
4000213a:	5b                   	pop    %ebx
4000213b:	c3                   	ret    
4000213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40002140 <sys_thread_exit>:

int sys_thread_exit() {
    int errno;

    asm volatile ("int %1"
40002140:	b8 07 00 00 00       	mov    $0x7,%eax
40002145:	cd 30                	int    $0x30
                  : "=a" (errno)
                  : "i" (T_SYSCALL),
                    "a" (SYS_thread_exit)
                  : "cc", "memory");

    return errno ? -1 : 0;
40002147:	85 c0                	test   %eax,%eax
40002149:	0f 95 c0             	setne  %al
4000214c:	0f b6 c0             	movzbl %al,%eax
4000214f:	f7 d8                	neg    %eax
}
40002151:	c3                   	ret    
40002152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40002159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40002160 <thread_init>:

volatile static bool threads[1024];

void thread_init() {
    for (int i = 0; i < 1024; ++i) {
40002160:	31 c0                	xor    %eax,%eax
40002162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	threads[i] = 0;
40002168:	c6 80 c0 61 00 40 00 	movb   $0x0,0x400061c0(%eax)
    for (int i = 0; i < 1024; ++i) {
4000216f:	83 c0 01             	add    $0x1,%eax
40002172:	3d 00 04 00 00       	cmp    $0x400,%eax
40002177:	75 ef                	jne    40002168 <thread_init+0x8>
    }
}
40002179:	c3                   	ret    
4000217a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40002180 <thread_create>:

int thread_create(void(* fcn)(void *), void *arg, void *stack) {
40002180:	53                   	push   %ebx
    asm volatile ("int %2"
40002181:	b8 05 00 00 00       	mov    $0x5,%eax
40002186:	8b 5c 24 08          	mov    0x8(%esp),%ebx
4000218a:	8b 4c 24 10          	mov    0x10(%esp),%ecx
4000218e:	cd 30                	int    $0x30
    return errno ? -1 : pid;
40002190:	85 c0                	test   %eax,%eax
40002192:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40002197:	0f 44 c3             	cmove  %ebx,%eax
    pid_t pid = sys_thread_create((uintptr_t)fcn, (uintptr_t)stack);

    threads[pid] = 1;

    return pid;
}
4000219a:	5b                   	pop    %ebx
    threads[pid] = 1;
4000219b:	c6 80 c0 61 00 40 01 	movb   $0x1,0x400061c0(%eax)
}
400021a2:	c3                   	ret    
400021a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400021aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

400021b0 <thread_join>:

void thread_join(pid_t pid) {
400021b0:	8b 54 24 04          	mov    0x4(%esp),%edx
    while (threads[pid] == 1) {
400021b4:	0f b6 82 c0 61 00 40 	movzbl 0x400061c0(%edx),%eax
400021bb:	3c 01                	cmp    $0x1,%al
400021bd:	75 1a                	jne    400021d9 <thread_join+0x29>
400021bf:	90                   	nop
void thread_join(pid_t pid) {
400021c0:	b8 10 27 00 00       	mov    $0x2710,%eax
400021c5:	8d 76 00             	lea    0x0(%esi),%esi
       __asm volatile( "nop" ::: );
400021c8:	90                   	nop
   for (i = 0; i < d; i++) {
400021c9:	83 e8 01             	sub    $0x1,%eax
400021cc:	75 fa                	jne    400021c8 <thread_join+0x18>
    while (threads[pid] == 1) {
400021ce:	0f b6 82 c0 61 00 40 	movzbl 0x400061c0(%edx),%eax
400021d5:	3c 01                	cmp    $0x1,%al
400021d7:	74 e7                	je     400021c0 <thread_join+0x10>
	delay(10000);
    }
}
400021d9:	c3                   	ret    
400021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

400021e0 <thread_exit>:

void thread_exit() {
400021e0:	53                   	push   %ebx
    asm volatile ("int %1"
400021e1:	b8 07 00 00 00       	mov    $0x7,%eax
400021e6:	cd 30                	int    $0x30
    asm volatile ("int %2"
400021e8:	b8 08 00 00 00       	mov    $0x8,%eax
400021ed:	cd 30                	int    $0x30
    return errno ? -1 : pid;
400021ef:	85 c0                	test   %eax,%eax
400021f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
400021f6:	0f 44 c3             	cmove  %ebx,%eax
    sys_thread_exit();


    threads[getpid()] = 0;
}
400021f9:	5b                   	pop    %ebx
    threads[getpid()] = 0;
400021fa:	c6 80 c0 61 00 40 00 	movb   $0x0,0x400061c0(%eax)
}
40002201:	c3                   	ret    
40002202:	66 90                	xchg   %ax,%ax
40002204:	66 90                	xchg   %ax,%ax
40002206:	66 90                	xchg   %ax,%ax
40002208:	66 90                	xchg   %ax,%ax
4000220a:	66 90                	xchg   %ax,%ax
4000220c:	66 90                	xchg   %ax,%ax
4000220e:	66 90                	xchg   %ax,%ax

40002210 <__udivdi3>:
40002210:	f3 0f 1e fb          	endbr32 
40002214:	55                   	push   %ebp
40002215:	57                   	push   %edi
40002216:	56                   	push   %esi
40002217:	53                   	push   %ebx
40002218:	83 ec 1c             	sub    $0x1c,%esp
4000221b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
4000221f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
40002223:	8b 74 24 34          	mov    0x34(%esp),%esi
40002227:	8b 5c 24 38          	mov    0x38(%esp),%ebx
4000222b:	85 d2                	test   %edx,%edx
4000222d:	75 19                	jne    40002248 <__udivdi3+0x38>
4000222f:	39 f3                	cmp    %esi,%ebx
40002231:	76 4d                	jbe    40002280 <__udivdi3+0x70>
40002233:	31 ff                	xor    %edi,%edi
40002235:	89 e8                	mov    %ebp,%eax
40002237:	89 f2                	mov    %esi,%edx
40002239:	f7 f3                	div    %ebx
4000223b:	89 fa                	mov    %edi,%edx
4000223d:	83 c4 1c             	add    $0x1c,%esp
40002240:	5b                   	pop    %ebx
40002241:	5e                   	pop    %esi
40002242:	5f                   	pop    %edi
40002243:	5d                   	pop    %ebp
40002244:	c3                   	ret    
40002245:	8d 76 00             	lea    0x0(%esi),%esi
40002248:	39 f2                	cmp    %esi,%edx
4000224a:	76 14                	jbe    40002260 <__udivdi3+0x50>
4000224c:	31 ff                	xor    %edi,%edi
4000224e:	31 c0                	xor    %eax,%eax
40002250:	89 fa                	mov    %edi,%edx
40002252:	83 c4 1c             	add    $0x1c,%esp
40002255:	5b                   	pop    %ebx
40002256:	5e                   	pop    %esi
40002257:	5f                   	pop    %edi
40002258:	5d                   	pop    %ebp
40002259:	c3                   	ret    
4000225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40002260:	0f bd fa             	bsr    %edx,%edi
40002263:	83 f7 1f             	xor    $0x1f,%edi
40002266:	75 48                	jne    400022b0 <__udivdi3+0xa0>
40002268:	39 f2                	cmp    %esi,%edx
4000226a:	72 06                	jb     40002272 <__udivdi3+0x62>
4000226c:	31 c0                	xor    %eax,%eax
4000226e:	39 eb                	cmp    %ebp,%ebx
40002270:	77 de                	ja     40002250 <__udivdi3+0x40>
40002272:	b8 01 00 00 00       	mov    $0x1,%eax
40002277:	eb d7                	jmp    40002250 <__udivdi3+0x40>
40002279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40002280:	89 d9                	mov    %ebx,%ecx
40002282:	85 db                	test   %ebx,%ebx
40002284:	75 0b                	jne    40002291 <__udivdi3+0x81>
40002286:	b8 01 00 00 00       	mov    $0x1,%eax
4000228b:	31 d2                	xor    %edx,%edx
4000228d:	f7 f3                	div    %ebx
4000228f:	89 c1                	mov    %eax,%ecx
40002291:	31 d2                	xor    %edx,%edx
40002293:	89 f0                	mov    %esi,%eax
40002295:	f7 f1                	div    %ecx
40002297:	89 c6                	mov    %eax,%esi
40002299:	89 e8                	mov    %ebp,%eax
4000229b:	89 f7                	mov    %esi,%edi
4000229d:	f7 f1                	div    %ecx
4000229f:	89 fa                	mov    %edi,%edx
400022a1:	83 c4 1c             	add    $0x1c,%esp
400022a4:	5b                   	pop    %ebx
400022a5:	5e                   	pop    %esi
400022a6:	5f                   	pop    %edi
400022a7:	5d                   	pop    %ebp
400022a8:	c3                   	ret    
400022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400022b0:	89 f9                	mov    %edi,%ecx
400022b2:	b8 20 00 00 00       	mov    $0x20,%eax
400022b7:	29 f8                	sub    %edi,%eax
400022b9:	d3 e2                	shl    %cl,%edx
400022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
400022bf:	89 c1                	mov    %eax,%ecx
400022c1:	89 da                	mov    %ebx,%edx
400022c3:	d3 ea                	shr    %cl,%edx
400022c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
400022c9:	09 d1                	or     %edx,%ecx
400022cb:	89 f2                	mov    %esi,%edx
400022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
400022d1:	89 f9                	mov    %edi,%ecx
400022d3:	d3 e3                	shl    %cl,%ebx
400022d5:	89 c1                	mov    %eax,%ecx
400022d7:	d3 ea                	shr    %cl,%edx
400022d9:	89 f9                	mov    %edi,%ecx
400022db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
400022df:	89 eb                	mov    %ebp,%ebx
400022e1:	d3 e6                	shl    %cl,%esi
400022e3:	89 c1                	mov    %eax,%ecx
400022e5:	d3 eb                	shr    %cl,%ebx
400022e7:	09 de                	or     %ebx,%esi
400022e9:	89 f0                	mov    %esi,%eax
400022eb:	f7 74 24 08          	divl   0x8(%esp)
400022ef:	89 d6                	mov    %edx,%esi
400022f1:	89 c3                	mov    %eax,%ebx
400022f3:	f7 64 24 0c          	mull   0xc(%esp)
400022f7:	39 d6                	cmp    %edx,%esi
400022f9:	72 15                	jb     40002310 <__udivdi3+0x100>
400022fb:	89 f9                	mov    %edi,%ecx
400022fd:	d3 e5                	shl    %cl,%ebp
400022ff:	39 c5                	cmp    %eax,%ebp
40002301:	73 04                	jae    40002307 <__udivdi3+0xf7>
40002303:	39 d6                	cmp    %edx,%esi
40002305:	74 09                	je     40002310 <__udivdi3+0x100>
40002307:	89 d8                	mov    %ebx,%eax
40002309:	31 ff                	xor    %edi,%edi
4000230b:	e9 40 ff ff ff       	jmp    40002250 <__udivdi3+0x40>
40002310:	8d 43 ff             	lea    -0x1(%ebx),%eax
40002313:	31 ff                	xor    %edi,%edi
40002315:	e9 36 ff ff ff       	jmp    40002250 <__udivdi3+0x40>
4000231a:	66 90                	xchg   %ax,%ax
4000231c:	66 90                	xchg   %ax,%ax
4000231e:	66 90                	xchg   %ax,%ax

40002320 <__umoddi3>:
40002320:	f3 0f 1e fb          	endbr32 
40002324:	55                   	push   %ebp
40002325:	57                   	push   %edi
40002326:	56                   	push   %esi
40002327:	53                   	push   %ebx
40002328:	83 ec 1c             	sub    $0x1c,%esp
4000232b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
4000232f:	8b 74 24 30          	mov    0x30(%esp),%esi
40002333:	8b 5c 24 34          	mov    0x34(%esp),%ebx
40002337:	8b 7c 24 38          	mov    0x38(%esp),%edi
4000233b:	85 c0                	test   %eax,%eax
4000233d:	75 19                	jne    40002358 <__umoddi3+0x38>
4000233f:	39 df                	cmp    %ebx,%edi
40002341:	76 5d                	jbe    400023a0 <__umoddi3+0x80>
40002343:	89 f0                	mov    %esi,%eax
40002345:	89 da                	mov    %ebx,%edx
40002347:	f7 f7                	div    %edi
40002349:	89 d0                	mov    %edx,%eax
4000234b:	31 d2                	xor    %edx,%edx
4000234d:	83 c4 1c             	add    $0x1c,%esp
40002350:	5b                   	pop    %ebx
40002351:	5e                   	pop    %esi
40002352:	5f                   	pop    %edi
40002353:	5d                   	pop    %ebp
40002354:	c3                   	ret    
40002355:	8d 76 00             	lea    0x0(%esi),%esi
40002358:	89 f2                	mov    %esi,%edx
4000235a:	39 d8                	cmp    %ebx,%eax
4000235c:	76 12                	jbe    40002370 <__umoddi3+0x50>
4000235e:	89 f0                	mov    %esi,%eax
40002360:	89 da                	mov    %ebx,%edx
40002362:	83 c4 1c             	add    $0x1c,%esp
40002365:	5b                   	pop    %ebx
40002366:	5e                   	pop    %esi
40002367:	5f                   	pop    %edi
40002368:	5d                   	pop    %ebp
40002369:	c3                   	ret    
4000236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40002370:	0f bd e8             	bsr    %eax,%ebp
40002373:	83 f5 1f             	xor    $0x1f,%ebp
40002376:	75 50                	jne    400023c8 <__umoddi3+0xa8>
40002378:	39 d8                	cmp    %ebx,%eax
4000237a:	0f 82 e0 00 00 00    	jb     40002460 <__umoddi3+0x140>
40002380:	89 d9                	mov    %ebx,%ecx
40002382:	39 f7                	cmp    %esi,%edi
40002384:	0f 86 d6 00 00 00    	jbe    40002460 <__umoddi3+0x140>
4000238a:	89 d0                	mov    %edx,%eax
4000238c:	89 ca                	mov    %ecx,%edx
4000238e:	83 c4 1c             	add    $0x1c,%esp
40002391:	5b                   	pop    %ebx
40002392:	5e                   	pop    %esi
40002393:	5f                   	pop    %edi
40002394:	5d                   	pop    %ebp
40002395:	c3                   	ret    
40002396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000239d:	8d 76 00             	lea    0x0(%esi),%esi
400023a0:	89 fd                	mov    %edi,%ebp
400023a2:	85 ff                	test   %edi,%edi
400023a4:	75 0b                	jne    400023b1 <__umoddi3+0x91>
400023a6:	b8 01 00 00 00       	mov    $0x1,%eax
400023ab:	31 d2                	xor    %edx,%edx
400023ad:	f7 f7                	div    %edi
400023af:	89 c5                	mov    %eax,%ebp
400023b1:	89 d8                	mov    %ebx,%eax
400023b3:	31 d2                	xor    %edx,%edx
400023b5:	f7 f5                	div    %ebp
400023b7:	89 f0                	mov    %esi,%eax
400023b9:	f7 f5                	div    %ebp
400023bb:	89 d0                	mov    %edx,%eax
400023bd:	31 d2                	xor    %edx,%edx
400023bf:	eb 8c                	jmp    4000234d <__umoddi3+0x2d>
400023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400023c8:	89 e9                	mov    %ebp,%ecx
400023ca:	ba 20 00 00 00       	mov    $0x20,%edx
400023cf:	29 ea                	sub    %ebp,%edx
400023d1:	d3 e0                	shl    %cl,%eax
400023d3:	89 44 24 08          	mov    %eax,0x8(%esp)
400023d7:	89 d1                	mov    %edx,%ecx
400023d9:	89 f8                	mov    %edi,%eax
400023db:	d3 e8                	shr    %cl,%eax
400023dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
400023e1:	89 54 24 04          	mov    %edx,0x4(%esp)
400023e5:	8b 54 24 04          	mov    0x4(%esp),%edx
400023e9:	09 c1                	or     %eax,%ecx
400023eb:	89 d8                	mov    %ebx,%eax
400023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
400023f1:	89 e9                	mov    %ebp,%ecx
400023f3:	d3 e7                	shl    %cl,%edi
400023f5:	89 d1                	mov    %edx,%ecx
400023f7:	d3 e8                	shr    %cl,%eax
400023f9:	89 e9                	mov    %ebp,%ecx
400023fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
400023ff:	d3 e3                	shl    %cl,%ebx
40002401:	89 c7                	mov    %eax,%edi
40002403:	89 d1                	mov    %edx,%ecx
40002405:	89 f0                	mov    %esi,%eax
40002407:	d3 e8                	shr    %cl,%eax
40002409:	89 e9                	mov    %ebp,%ecx
4000240b:	89 fa                	mov    %edi,%edx
4000240d:	d3 e6                	shl    %cl,%esi
4000240f:	09 d8                	or     %ebx,%eax
40002411:	f7 74 24 08          	divl   0x8(%esp)
40002415:	89 d1                	mov    %edx,%ecx
40002417:	89 f3                	mov    %esi,%ebx
40002419:	f7 64 24 0c          	mull   0xc(%esp)
4000241d:	89 c6                	mov    %eax,%esi
4000241f:	89 d7                	mov    %edx,%edi
40002421:	39 d1                	cmp    %edx,%ecx
40002423:	72 06                	jb     4000242b <__umoddi3+0x10b>
40002425:	75 10                	jne    40002437 <__umoddi3+0x117>
40002427:	39 c3                	cmp    %eax,%ebx
40002429:	73 0c                	jae    40002437 <__umoddi3+0x117>
4000242b:	2b 44 24 0c          	sub    0xc(%esp),%eax
4000242f:	1b 54 24 08          	sbb    0x8(%esp),%edx
40002433:	89 d7                	mov    %edx,%edi
40002435:	89 c6                	mov    %eax,%esi
40002437:	89 ca                	mov    %ecx,%edx
40002439:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
4000243e:	29 f3                	sub    %esi,%ebx
40002440:	19 fa                	sbb    %edi,%edx
40002442:	89 d0                	mov    %edx,%eax
40002444:	d3 e0                	shl    %cl,%eax
40002446:	89 e9                	mov    %ebp,%ecx
40002448:	d3 eb                	shr    %cl,%ebx
4000244a:	d3 ea                	shr    %cl,%edx
4000244c:	09 d8                	or     %ebx,%eax
4000244e:	83 c4 1c             	add    $0x1c,%esp
40002451:	5b                   	pop    %ebx
40002452:	5e                   	pop    %esi
40002453:	5f                   	pop    %edi
40002454:	5d                   	pop    %ebp
40002455:	c3                   	ret    
40002456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000245d:	8d 76 00             	lea    0x0(%esi),%esi
40002460:	29 fe                	sub    %edi,%esi
40002462:	19 c3                	sbb    %eax,%ebx
40002464:	89 f2                	mov    %esi,%edx
40002466:	89 d9                	mov    %ebx,%ecx
40002468:	e9 1d ff ff ff       	jmp    4000238a <__umoddi3+0x6a>
