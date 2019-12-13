
obj/user/pingpong/pong:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
#include <proc.h>
#include <stdio.h>
#include <syscall.h>

int main(int argc, char **argv)
{
40000000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
40000004:	83 e4 f0             	and    $0xfffffff0,%esp
40000007:	ff 71 fc             	pushl  -0x4(%ecx)
4000000a:	55                   	push   %ebp
4000000b:	89 e5                	mov    %esp,%ebp
4000000d:	53                   	push   %ebx
    unsigned int i;
    printf("pong started.\n");

    for (i = 0; i < 40; i++) {
4000000e:	31 db                	xor    %ebx,%ebx
{
40000010:	51                   	push   %ecx
    printf("pong started.\n");
40000011:	83 ec 0c             	sub    $0xc,%esp
40000014:	68 94 21 00 40       	push   $0x40002194
40000019:	e8 22 02 00 00       	call   40000240 <printf>
4000001e:	83 c4 10             	add    $0x10,%esp
40000021:	eb 0d                	jmp    40000030 <main+0x30>
40000023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000027:	90                   	nop
    for (i = 0; i < 40; i++) {
40000028:	83 c3 01             	add    $0x1,%ebx
4000002b:	83 fb 28             	cmp    $0x28,%ebx
4000002e:	74 12                	je     40000042 <main+0x42>
        if (i % 2 == 0)
40000030:	f6 c3 01             	test   $0x1,%bl
40000033:	75 f3                	jne    40000028 <main+0x28>
            consume();
40000035:	e8 56 09 00 00       	call   40000990 <consume>
    for (i = 0; i < 40; i++) {
4000003a:	83 c3 01             	add    $0x1,%ebx
4000003d:	83 fb 28             	cmp    $0x28,%ebx
40000040:	75 ee                	jne    40000030 <main+0x30>
    }

    return 0;
}
40000042:	8d 65 f8             	lea    -0x8(%ebp),%esp
40000045:	31 c0                	xor    %eax,%eax
40000047:	59                   	pop    %ecx
40000048:	5b                   	pop    %ebx
40000049:	5d                   	pop    %ebp
4000004a:	8d 61 fc             	lea    -0x4(%ecx),%esp
4000004d:	c3                   	ret    

4000004e <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary.
	 */
	testl	$0x0fffffff, %esp
4000004e:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
40000054:	75 04                	jne    4000005a <args_exist>

40000056 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
40000056:	6a 00                	push   $0x0
	pushl	$0
40000058:	6a 00                	push   $0x0

4000005a <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
4000005a:	e8 a1 ff ff ff       	call   40000000 <main>

	/* When returning, push the return value on the stack. */
	pushl	%eax
4000005f:	50                   	push   %eax

40000060 <spin>:
spin:
	jmp	spin
40000060:	eb fe                	jmp    40000060 <spin>
40000062:	66 90                	xchg   %ax,%ax
40000064:	66 90                	xchg   %ax,%ax
40000066:	66 90                	xchg   %ax,%ax
40000068:	66 90                	xchg   %ax,%ax
4000006a:	66 90                	xchg   %ax,%ax
4000006c:	66 90                	xchg   %ax,%ax
4000006e:	66 90                	xchg   %ax,%ax

40000070 <debug>:
#include <proc.h>
#include <stdarg.h>
#include <stdio.h>

void debug(const char *file, int line, const char *fmt, ...)
{
40000070:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[D] %s:%d: ", file, line);
40000073:	ff 74 24 18          	pushl  0x18(%esp)
40000077:	ff 74 24 18          	pushl  0x18(%esp)
4000007b:	68 00 20 00 40       	push   $0x40002000
40000080:	e8 bb 01 00 00       	call   40000240 <printf>
    vcprintf(fmt, ap);
40000085:	58                   	pop    %eax
40000086:	5a                   	pop    %edx
40000087:	8d 44 24 24          	lea    0x24(%esp),%eax
4000008b:	50                   	push   %eax
4000008c:	ff 74 24 24          	pushl  0x24(%esp)
40000090:	e8 4b 01 00 00       	call   400001e0 <vcprintf>
    va_end(ap);
}
40000095:	83 c4 1c             	add    $0x1c,%esp
40000098:	c3                   	ret    
40000099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400000a0 <warn>:

void warn(const char *file, int line, const char *fmt, ...)
{
400000a0:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[W] %s:%d: ", file, line);
400000a3:	ff 74 24 18          	pushl  0x18(%esp)
400000a7:	ff 74 24 18          	pushl  0x18(%esp)
400000ab:	68 0c 20 00 40       	push   $0x4000200c
400000b0:	e8 8b 01 00 00       	call   40000240 <printf>
    vcprintf(fmt, ap);
400000b5:	58                   	pop    %eax
400000b6:	5a                   	pop    %edx
400000b7:	8d 44 24 24          	lea    0x24(%esp),%eax
400000bb:	50                   	push   %eax
400000bc:	ff 74 24 24          	pushl  0x24(%esp)
400000c0:	e8 1b 01 00 00       	call   400001e0 <vcprintf>
    va_end(ap);
}
400000c5:	83 c4 1c             	add    $0x1c,%esp
400000c8:	c3                   	ret    
400000c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400000d0 <panic>:

void panic(const char *file, int line, const char *fmt, ...)
{
400000d0:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[P] %s:%d: ", file, line);
400000d3:	ff 74 24 18          	pushl  0x18(%esp)
400000d7:	ff 74 24 18          	pushl  0x18(%esp)
400000db:	68 18 20 00 40       	push   $0x40002018
400000e0:	e8 5b 01 00 00       	call   40000240 <printf>
    vcprintf(fmt, ap);
400000e5:	58                   	pop    %eax
400000e6:	5a                   	pop    %edx
400000e7:	8d 44 24 24          	lea    0x24(%esp),%eax
400000eb:	50                   	push   %eax
400000ec:	ff 74 24 24          	pushl  0x24(%esp)
400000f0:	e8 eb 00 00 00       	call   400001e0 <vcprintf>
400000f5:	83 c4 10             	add    $0x10,%esp
400000f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400000ff:	90                   	nop
    va_end(ap);

    while (1)
        yield();
40000100:	e8 6b 08 00 00       	call   40000970 <yield>
    while (1)
40000105:	eb f9                	jmp    40000100 <panic+0x30>
40000107:	66 90                	xchg   %ax,%ax
40000109:	66 90                	xchg   %ax,%ax
4000010b:	66 90                	xchg   %ax,%ax
4000010d:	66 90                	xchg   %ax,%ax
4000010f:	90                   	nop

40000110 <atoi>:
#include <stdlib.h>

int atoi(const char *buf, int *i)
{
40000110:	55                   	push   %ebp
40000111:	57                   	push   %edi
40000112:	56                   	push   %esi
40000113:	53                   	push   %ebx
40000114:	8b 74 24 14          	mov    0x14(%esp),%esi
    int loc = 0;
    int numstart = 0;
    int acc = 0;
    int negative = 0;
    if (buf[loc] == '+')
40000118:	0f be 06             	movsbl (%esi),%eax
4000011b:	3c 2b                	cmp    $0x2b,%al
4000011d:	74 71                	je     40000190 <atoi+0x80>
    int negative = 0;
4000011f:	31 ed                	xor    %ebp,%ebp
    int loc = 0;
40000121:	31 ff                	xor    %edi,%edi
        loc++;
    else if (buf[loc] == '-') {
40000123:	3c 2d                	cmp    $0x2d,%al
40000125:	74 49                	je     40000170 <atoi+0x60>
        negative = 1;
        loc++;
    }
    numstart = loc;
    // no grab the numbers
    while ('0' <= buf[loc] && buf[loc] <= '9') {
40000127:	8d 50 d0             	lea    -0x30(%eax),%edx
4000012a:	80 fa 09             	cmp    $0x9,%dl
4000012d:	77 57                	ja     40000186 <atoi+0x76>
4000012f:	89 f9                	mov    %edi,%ecx
    int acc = 0;
40000131:	31 d2                	xor    %edx,%edx
40000133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000137:	90                   	nop
        acc = acc * 10 + (buf[loc] - '0');
40000138:	8d 14 92             	lea    (%edx,%edx,4),%edx
        loc++;
4000013b:	83 c1 01             	add    $0x1,%ecx
        acc = acc * 10 + (buf[loc] - '0');
4000013e:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
    while ('0' <= buf[loc] && buf[loc] <= '9') {
40000142:	0f be 04 0e          	movsbl (%esi,%ecx,1),%eax
40000146:	8d 58 d0             	lea    -0x30(%eax),%ebx
40000149:	80 fb 09             	cmp    $0x9,%bl
4000014c:	76 ea                	jbe    40000138 <atoi+0x28>
    }
    if (numstart == loc) {
4000014e:	39 cf                	cmp    %ecx,%edi
40000150:	74 34                	je     40000186 <atoi+0x76>
        // no numbers have actually been scanned
        return 0;
    }
    if (negative)
        acc = -acc;
40000152:	89 d0                	mov    %edx,%eax
40000154:	f7 d8                	neg    %eax
40000156:	85 ed                	test   %ebp,%ebp
40000158:	0f 45 d0             	cmovne %eax,%edx
    *i = acc;
4000015b:	8b 44 24 18          	mov    0x18(%esp),%eax
4000015f:	89 10                	mov    %edx,(%eax)
    return loc;
}
40000161:	89 c8                	mov    %ecx,%eax
40000163:	5b                   	pop    %ebx
40000164:	5e                   	pop    %esi
40000165:	5f                   	pop    %edi
40000166:	5d                   	pop    %ebp
40000167:	c3                   	ret    
40000168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000016f:	90                   	nop
        loc++;
40000170:	0f be 46 01          	movsbl 0x1(%esi),%eax
        negative = 1;
40000174:	bd 01 00 00 00       	mov    $0x1,%ebp
        loc++;
40000179:	bf 01 00 00 00       	mov    $0x1,%edi
    while ('0' <= buf[loc] && buf[loc] <= '9') {
4000017e:	8d 50 d0             	lea    -0x30(%eax),%edx
40000181:	80 fa 09             	cmp    $0x9,%dl
40000184:	76 a9                	jbe    4000012f <atoi+0x1f>
        return 0;
40000186:	31 c9                	xor    %ecx,%ecx
}
40000188:	5b                   	pop    %ebx
40000189:	5e                   	pop    %esi
4000018a:	89 c8                	mov    %ecx,%eax
4000018c:	5f                   	pop    %edi
4000018d:	5d                   	pop    %ebp
4000018e:	c3                   	ret    
4000018f:	90                   	nop
40000190:	0f be 46 01          	movsbl 0x1(%esi),%eax
    int negative = 0;
40000194:	31 ed                	xor    %ebp,%ebp
        loc++;
40000196:	bf 01 00 00 00       	mov    $0x1,%edi
4000019b:	eb 8a                	jmp    40000127 <atoi+0x17>
4000019d:	66 90                	xchg   %ax,%ax
4000019f:	90                   	nop

400001a0 <putch>:
    int cnt;            // total bytes printed so far
    char buf[MAX_BUF];
};

static void putch(int ch, struct printbuf *b)
{
400001a0:	53                   	push   %ebx
400001a1:	8b 54 24 0c          	mov    0xc(%esp),%edx
    b->buf[b->idx++] = ch;
400001a5:	0f b6 5c 24 08       	movzbl 0x8(%esp),%ebx
400001aa:	8b 02                	mov    (%edx),%eax
400001ac:	8d 48 01             	lea    0x1(%eax),%ecx
400001af:	89 0a                	mov    %ecx,(%edx)
400001b1:	88 5c 02 08          	mov    %bl,0x8(%edx,%eax,1)
    if (b->idx == MAX_BUF - 1) {
400001b5:	81 f9 ff 01 00 00    	cmp    $0x1ff,%ecx
400001bb:	75 14                	jne    400001d1 <putch+0x31>
        b->buf[b->idx] = 0;
400001bd:	c6 82 07 02 00 00 00 	movb   $0x0,0x207(%edx)
        puts(b->buf, b->idx);
400001c4:	8d 5a 08             	lea    0x8(%edx),%ebx

#include "time.h"

static gcc_inline void sys_puts(const char *s, size_t len)
{
    asm volatile ("int %0"
400001c7:	31 c0                	xor    %eax,%eax
400001c9:	cd 30                	int    $0x30
        b->idx = 0;
400001cb:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    }
    b->cnt++;
400001d1:	83 42 04 01          	addl   $0x1,0x4(%edx)
}
400001d5:	5b                   	pop    %ebx
400001d6:	c3                   	ret    
400001d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400001de:	66 90                	xchg   %ax,%ax

400001e0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap)
{
400001e0:	53                   	push   %ebx
400001e1:	81 ec 18 02 00 00    	sub    $0x218,%esp
    struct printbuf b;

    b.idx = 0;
400001e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
400001ee:	00 
    b.cnt = 0;
400001ef:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400001f6:	00 
    vprintfmt((void *) putch, &b, fmt, ap);
400001f7:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
400001fe:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
40000205:	8d 44 24 10          	lea    0x10(%esp),%eax
40000209:	50                   	push   %eax
4000020a:	68 a0 01 00 40       	push   $0x400001a0
4000020f:	e8 3c 01 00 00       	call   40000350 <vprintfmt>

    b.buf[b.idx] = 0;
40000214:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000218:	8d 5c 24 20          	lea    0x20(%esp),%ebx
4000021c:	31 c0                	xor    %eax,%eax
4000021e:	c6 44 0c 20 00       	movb   $0x0,0x20(%esp,%ecx,1)
40000223:	cd 30                	int    $0x30
    puts(b.buf, b.idx);

    return b.cnt;
}
40000225:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000229:	81 c4 28 02 00 00    	add    $0x228,%esp
4000022f:	5b                   	pop    %ebx
40000230:	c3                   	ret    
40000231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000023f:	90                   	nop

40000240 <printf>:

int printf(const char *fmt, ...)
{
40000240:	83 ec 14             	sub    $0x14,%esp
    va_list ap;
    int cnt;

    va_start(ap, fmt);
    cnt = vcprintf(fmt, ap);
40000243:	8d 44 24 1c          	lea    0x1c(%esp),%eax
40000247:	50                   	push   %eax
40000248:	ff 74 24 1c          	pushl  0x1c(%esp)
4000024c:	e8 8f ff ff ff       	call   400001e0 <vcprintf>
    va_end(ap);

    return cnt;
}
40000251:	83 c4 1c             	add    $0x1c,%esp
40000254:	c3                   	ret    
40000255:	66 90                	xchg   %ax,%ax
40000257:	66 90                	xchg   %ax,%ax
40000259:	66 90                	xchg   %ax,%ax
4000025b:	66 90                	xchg   %ax,%ax
4000025d:	66 90                	xchg   %ax,%ax
4000025f:	90                   	nop

40000260 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
40000260:	55                   	push   %ebp
40000261:	57                   	push   %edi
40000262:	56                   	push   %esi
40000263:	89 d6                	mov    %edx,%esi
40000265:	53                   	push   %ebx
40000266:	89 c3                	mov    %eax,%ebx
40000268:	83 ec 1c             	sub    $0x1c,%esp
4000026b:	8b 54 24 30          	mov    0x30(%esp),%edx
4000026f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
40000273:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
4000027a:	00 
{
4000027b:	8b 44 24 38          	mov    0x38(%esp),%eax
    if (num >= base) {
4000027f:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
{
40000283:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
40000287:	8b 7c 24 40          	mov    0x40(%esp),%edi
4000028b:	83 ed 01             	sub    $0x1,%ebp
    if (num >= base) {
4000028e:	39 c2                	cmp    %eax,%edx
40000290:	1b 4c 24 04          	sbb    0x4(%esp),%ecx
{
40000294:	89 54 24 08          	mov    %edx,0x8(%esp)
    if (num >= base) {
40000298:	89 04 24             	mov    %eax,(%esp)
4000029b:	73 53                	jae    400002f0 <printnum+0x90>
        printnum(putch, putdat, num / base, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (--width > 0)
4000029d:	85 ed                	test   %ebp,%ebp
4000029f:	7e 16                	jle    400002b7 <printnum+0x57>
400002a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch(padc, putdat);
400002a8:	83 ec 08             	sub    $0x8,%esp
400002ab:	56                   	push   %esi
400002ac:	57                   	push   %edi
400002ad:	ff d3                	call   *%ebx
        while (--width > 0)
400002af:	83 c4 10             	add    $0x10,%esp
400002b2:	83 ed 01             	sub    $0x1,%ebp
400002b5:	75 f1                	jne    400002a8 <printnum+0x48>
    }

    // then print this (the least significant) digit
    putch("0123456789abcdef"[num % base], putdat);
400002b7:	89 74 24 34          	mov    %esi,0x34(%esp)
400002bb:	ff 74 24 04          	pushl  0x4(%esp)
400002bf:	ff 74 24 04          	pushl  0x4(%esp)
400002c3:	ff 74 24 14          	pushl  0x14(%esp)
400002c7:	ff 74 24 14          	pushl  0x14(%esp)
400002cb:	e8 00 0d 00 00       	call   40000fd0 <__umoddi3>
400002d0:	0f be 80 24 20 00 40 	movsbl 0x40002024(%eax),%eax
400002d7:	89 44 24 40          	mov    %eax,0x40(%esp)
}
400002db:	83 c4 2c             	add    $0x2c,%esp
    putch("0123456789abcdef"[num % base], putdat);
400002de:	89 d8                	mov    %ebx,%eax
}
400002e0:	5b                   	pop    %ebx
400002e1:	5e                   	pop    %esi
400002e2:	5f                   	pop    %edi
400002e3:	5d                   	pop    %ebp
    putch("0123456789abcdef"[num % base], putdat);
400002e4:	ff e0                	jmp    *%eax
400002e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400002ed:	8d 76 00             	lea    0x0(%esi),%esi
        printnum(putch, putdat, num / base, base, width - 1, padc);
400002f0:	83 ec 0c             	sub    $0xc,%esp
400002f3:	57                   	push   %edi
400002f4:	55                   	push   %ebp
400002f5:	50                   	push   %eax
400002f6:	83 ec 08             	sub    $0x8,%esp
400002f9:	ff 74 24 24          	pushl  0x24(%esp)
400002fd:	ff 74 24 24          	pushl  0x24(%esp)
40000301:	ff 74 24 34          	pushl  0x34(%esp)
40000305:	ff 74 24 34          	pushl  0x34(%esp)
40000309:	e8 b2 0b 00 00       	call   40000ec0 <__udivdi3>
4000030e:	83 c4 18             	add    $0x18,%esp
40000311:	52                   	push   %edx
40000312:	89 f2                	mov    %esi,%edx
40000314:	50                   	push   %eax
40000315:	89 d8                	mov    %ebx,%eax
40000317:	e8 44 ff ff ff       	call   40000260 <printnum>
4000031c:	83 c4 20             	add    $0x20,%esp
4000031f:	eb 96                	jmp    400002b7 <printnum+0x57>
40000321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000032f:	90                   	nop

40000330 <sprintputch>:
    char *ebuf;
    int cnt;
};

static void sprintputch(int ch, struct sprintbuf *b)
{
40000330:	8b 44 24 08          	mov    0x8(%esp),%eax
    b->cnt++;
40000334:	83 40 08 01          	addl   $0x1,0x8(%eax)
    if (b->buf < b->ebuf)
40000338:	8b 10                	mov    (%eax),%edx
4000033a:	3b 50 04             	cmp    0x4(%eax),%edx
4000033d:	73 0b                	jae    4000034a <sprintputch+0x1a>
        *b->buf++ = ch;
4000033f:	8d 4a 01             	lea    0x1(%edx),%ecx
40000342:	89 08                	mov    %ecx,(%eax)
40000344:	8b 44 24 04          	mov    0x4(%esp),%eax
40000348:	88 02                	mov    %al,(%edx)
}
4000034a:	c3                   	ret    
4000034b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000034f:	90                   	nop

40000350 <vprintfmt>:
{
40000350:	55                   	push   %ebp
40000351:	57                   	push   %edi
40000352:	56                   	push   %esi
40000353:	53                   	push   %ebx
40000354:	83 ec 2c             	sub    $0x2c,%esp
40000357:	8b 74 24 40          	mov    0x40(%esp),%esi
4000035b:	8b 6c 24 44          	mov    0x44(%esp),%ebp
4000035f:	8b 7c 24 48          	mov    0x48(%esp),%edi
        while ((ch = *(unsigned char *) fmt++) != '%') {
40000363:	0f b6 07             	movzbl (%edi),%eax
40000366:	8d 5f 01             	lea    0x1(%edi),%ebx
40000369:	83 f8 25             	cmp    $0x25,%eax
4000036c:	75 18                	jne    40000386 <vprintfmt+0x36>
4000036e:	eb 28                	jmp    40000398 <vprintfmt+0x48>
            putch(ch, putdat);
40000370:	83 ec 08             	sub    $0x8,%esp
        while ((ch = *(unsigned char *) fmt++) != '%') {
40000373:	83 c3 01             	add    $0x1,%ebx
            putch(ch, putdat);
40000376:	55                   	push   %ebp
40000377:	50                   	push   %eax
40000378:	ff d6                	call   *%esi
        while ((ch = *(unsigned char *) fmt++) != '%') {
4000037a:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
4000037e:	83 c4 10             	add    $0x10,%esp
40000381:	83 f8 25             	cmp    $0x25,%eax
40000384:	74 12                	je     40000398 <vprintfmt+0x48>
            if (ch == '\0')
40000386:	85 c0                	test   %eax,%eax
40000388:	75 e6                	jne    40000370 <vprintfmt+0x20>
}
4000038a:	83 c4 2c             	add    $0x2c,%esp
4000038d:	5b                   	pop    %ebx
4000038e:	5e                   	pop    %esi
4000038f:	5f                   	pop    %edi
40000390:	5d                   	pop    %ebp
40000391:	c3                   	ret    
40000392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        padc = ' ';
40000398:	c6 44 24 10 20       	movb   $0x20,0x10(%esp)
        precision = -1;
4000039d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
        altflag = 0;
400003a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
400003a9:	00 
        width = -1;
400003aa:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
400003b1:	ff 
        lflag = 0;
400003b2:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
400003b9:	00 
        switch (ch = *(unsigned char *) fmt++) {
400003ba:	0f b6 0b             	movzbl (%ebx),%ecx
400003bd:	8d 7b 01             	lea    0x1(%ebx),%edi
400003c0:	8d 41 dd             	lea    -0x23(%ecx),%eax
400003c3:	3c 55                	cmp    $0x55,%al
400003c5:	77 11                	ja     400003d8 <vprintfmt+0x88>
400003c7:	0f b6 c0             	movzbl %al,%eax
400003ca:	ff 24 85 3c 20 00 40 	jmp    *0x4000203c(,%eax,4)
400003d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch('%', putdat);
400003d8:	83 ec 08             	sub    $0x8,%esp
            for (fmt--; fmt[-1] != '%'; fmt--)
400003db:	89 df                	mov    %ebx,%edi
            putch('%', putdat);
400003dd:	55                   	push   %ebp
400003de:	6a 25                	push   $0x25
400003e0:	ff d6                	call   *%esi
            for (fmt--; fmt[-1] != '%'; fmt--)
400003e2:	83 c4 10             	add    $0x10,%esp
400003e5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
400003e9:	0f 84 74 ff ff ff    	je     40000363 <vprintfmt+0x13>
400003ef:	90                   	nop
400003f0:	83 ef 01             	sub    $0x1,%edi
400003f3:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
400003f7:	75 f7                	jne    400003f0 <vprintfmt+0xa0>
400003f9:	e9 65 ff ff ff       	jmp    40000363 <vprintfmt+0x13>
400003fe:	66 90                	xchg   %ax,%ax
                ch = *fmt;
40000400:	0f be 43 01          	movsbl 0x1(%ebx),%eax
        switch (ch = *(unsigned char *) fmt++) {
40000404:	0f b6 d1             	movzbl %cl,%edx
40000407:	89 fb                	mov    %edi,%ebx
                precision = precision * 10 + ch - '0';
40000409:	83 ea 30             	sub    $0x30,%edx
                if (ch < '0' || ch > '9')
4000040c:	8d 48 d0             	lea    -0x30(%eax),%ecx
4000040f:	83 f9 09             	cmp    $0x9,%ecx
40000412:	77 19                	ja     4000042d <vprintfmt+0xdd>
40000414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (precision = 0;; ++fmt) {
40000418:	83 c3 01             	add    $0x1,%ebx
                precision = precision * 10 + ch - '0';
4000041b:	8d 14 92             	lea    (%edx,%edx,4),%edx
4000041e:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
                ch = *fmt;
40000422:	0f be 03             	movsbl (%ebx),%eax
                if (ch < '0' || ch > '9')
40000425:	8d 48 d0             	lea    -0x30(%eax),%ecx
40000428:	83 f9 09             	cmp    $0x9,%ecx
4000042b:	76 eb                	jbe    40000418 <vprintfmt+0xc8>
            if (width < 0)
4000042d:	8b 7c 24 04          	mov    0x4(%esp),%edi
40000431:	85 ff                	test   %edi,%edi
40000433:	79 85                	jns    400003ba <vprintfmt+0x6a>
                width = precision, precision = -1;
40000435:	89 54 24 04          	mov    %edx,0x4(%esp)
40000439:	ba ff ff ff ff       	mov    $0xffffffff,%edx
4000043e:	e9 77 ff ff ff       	jmp    400003ba <vprintfmt+0x6a>
            altflag = 1;
40000443:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
4000044a:	00 
        switch (ch = *(unsigned char *) fmt++) {
4000044b:	89 fb                	mov    %edi,%ebx
            goto reswitch;
4000044d:	e9 68 ff ff ff       	jmp    400003ba <vprintfmt+0x6a>
            putch(ch, putdat);
40000452:	83 ec 08             	sub    $0x8,%esp
40000455:	55                   	push   %ebp
40000456:	6a 25                	push   $0x25
40000458:	ff d6                	call   *%esi
            break;
4000045a:	83 c4 10             	add    $0x10,%esp
4000045d:	e9 01 ff ff ff       	jmp    40000363 <vprintfmt+0x13>
            precision = va_arg(ap, int);
40000462:	8b 44 24 4c          	mov    0x4c(%esp),%eax
        switch (ch = *(unsigned char *) fmt++) {
40000466:	89 fb                	mov    %edi,%ebx
            precision = va_arg(ap, int);
40000468:	8b 10                	mov    (%eax),%edx
4000046a:	83 c0 04             	add    $0x4,%eax
4000046d:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto process_precision;
40000471:	eb ba                	jmp    4000042d <vprintfmt+0xdd>
            if (width < 0)
40000473:	8b 44 24 04          	mov    0x4(%esp),%eax
40000477:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (ch = *(unsigned char *) fmt++) {
4000047c:	89 fb                	mov    %edi,%ebx
4000047e:	85 c0                	test   %eax,%eax
40000480:	0f 49 c8             	cmovns %eax,%ecx
40000483:	89 4c 24 04          	mov    %ecx,0x4(%esp)
            goto reswitch;
40000487:	e9 2e ff ff ff       	jmp    400003ba <vprintfmt+0x6a>
            putch(va_arg(ap, int), putdat);
4000048c:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000490:	83 ec 08             	sub    $0x8,%esp
40000493:	55                   	push   %ebp
40000494:	8d 58 04             	lea    0x4(%eax),%ebx
40000497:	8b 44 24 58          	mov    0x58(%esp),%eax
4000049b:	ff 30                	pushl  (%eax)
4000049d:	ff d6                	call   *%esi
4000049f:	89 5c 24 5c          	mov    %ebx,0x5c(%esp)
            break;
400004a3:	83 c4 10             	add    $0x10,%esp
400004a6:	e9 b8 fe ff ff       	jmp    40000363 <vprintfmt+0x13>
        return va_arg(*ap, unsigned long long);
400004ab:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
400004af:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, unsigned long long);
400004b4:	8b 10                	mov    (%eax),%edx
    if (lflag >= 2)
400004b6:	0f 8f c1 01 00 00    	jg     4000067d <vprintfmt+0x32d>
        return va_arg(*ap, unsigned long);
400004bc:	83 c0 04             	add    $0x4,%eax
400004bf:	31 c9                	xor    %ecx,%ecx
400004c1:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400004c5:	b8 0a 00 00 00       	mov    $0xa,%eax
400004ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            printnum(putch, putdat, num, base, width, padc);
400004d0:	83 ec 0c             	sub    $0xc,%esp
400004d3:	0f be 5c 24 1c       	movsbl 0x1c(%esp),%ebx
400004d8:	53                   	push   %ebx
400004d9:	ff 74 24 14          	pushl  0x14(%esp)
400004dd:	50                   	push   %eax
400004de:	89 f0                	mov    %esi,%eax
400004e0:	51                   	push   %ecx
400004e1:	52                   	push   %edx
400004e2:	89 ea                	mov    %ebp,%edx
400004e4:	e8 77 fd ff ff       	call   40000260 <printnum>
            break;
400004e9:	83 c4 20             	add    $0x20,%esp
400004ec:	e9 72 fe ff ff       	jmp    40000363 <vprintfmt+0x13>
            putch('0', putdat);
400004f1:	83 ec 08             	sub    $0x8,%esp
400004f4:	55                   	push   %ebp
400004f5:	6a 30                	push   $0x30
400004f7:	ff d6                	call   *%esi
            putch('x', putdat);
400004f9:	58                   	pop    %eax
400004fa:	5a                   	pop    %edx
400004fb:	55                   	push   %ebp
400004fc:	6a 78                	push   $0x78
400004fe:	ff d6                	call   *%esi
            num = (unsigned long long)
40000500:	8b 44 24 5c          	mov    0x5c(%esp),%eax
40000504:	31 c9                	xor    %ecx,%ecx
            goto number;
40000506:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)
40000509:	8b 10                	mov    (%eax),%edx
                (uintptr_t) va_arg(ap, void *);
4000050b:	8b 44 24 4c          	mov    0x4c(%esp),%eax
4000050f:	83 c0 04             	add    $0x4,%eax
40000512:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto number;
40000516:	b8 10 00 00 00       	mov    $0x10,%eax
4000051b:	eb b3                	jmp    400004d0 <vprintfmt+0x180>
        return va_arg(*ap, unsigned long long);
4000051d:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
40000521:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, unsigned long long);
40000526:	8b 10                	mov    (%eax),%edx
    if (lflag >= 2)
40000528:	0f 8f 63 01 00 00    	jg     40000691 <vprintfmt+0x341>
        return va_arg(*ap, unsigned long);
4000052e:	83 c0 04             	add    $0x4,%eax
40000531:	31 c9                	xor    %ecx,%ecx
40000533:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000537:	b8 10 00 00 00       	mov    $0x10,%eax
4000053c:	eb 92                	jmp    400004d0 <vprintfmt+0x180>
    if (lflag >= 2)
4000053e:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, long long);
40000543:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
40000547:	0f 8f 58 01 00 00    	jg     400006a5 <vprintfmt+0x355>
        return va_arg(*ap, long);
4000054d:	8b 4c 24 4c          	mov    0x4c(%esp),%ecx
40000551:	83 c0 04             	add    $0x4,%eax
40000554:	8b 11                	mov    (%ecx),%edx
40000556:	89 44 24 4c          	mov    %eax,0x4c(%esp)
4000055a:	89 d3                	mov    %edx,%ebx
4000055c:	89 d1                	mov    %edx,%ecx
4000055e:	c1 fb 1f             	sar    $0x1f,%ebx
            if ((long long) num < 0) {
40000561:	85 db                	test   %ebx,%ebx
40000563:	0f 88 65 01 00 00    	js     400006ce <vprintfmt+0x37e>
            num = getint(&ap, lflag);
40000569:	89 ca                	mov    %ecx,%edx
4000056b:	b8 0a 00 00 00       	mov    $0xa,%eax
40000570:	89 d9                	mov    %ebx,%ecx
40000572:	e9 59 ff ff ff       	jmp    400004d0 <vprintfmt+0x180>
            lflag++;
40000577:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
        switch (ch = *(unsigned char *) fmt++) {
4000057c:	89 fb                	mov    %edi,%ebx
            goto reswitch;
4000057e:	e9 37 fe ff ff       	jmp    400003ba <vprintfmt+0x6a>
            putch('X', putdat);
40000583:	83 ec 08             	sub    $0x8,%esp
40000586:	55                   	push   %ebp
40000587:	6a 58                	push   $0x58
40000589:	ff d6                	call   *%esi
            putch('X', putdat);
4000058b:	59                   	pop    %ecx
4000058c:	5b                   	pop    %ebx
4000058d:	55                   	push   %ebp
4000058e:	6a 58                	push   $0x58
40000590:	ff d6                	call   *%esi
            putch('X', putdat);
40000592:	58                   	pop    %eax
40000593:	5a                   	pop    %edx
40000594:	55                   	push   %ebp
40000595:	6a 58                	push   $0x58
40000597:	ff d6                	call   *%esi
            break;
40000599:	83 c4 10             	add    $0x10,%esp
4000059c:	e9 c2 fd ff ff       	jmp    40000363 <vprintfmt+0x13>
            if ((p = va_arg(ap, char *)) == NULL)
400005a1:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400005a5:	8b 4c 24 04          	mov    0x4(%esp),%ecx
400005a9:	83 c0 04             	add    $0x4,%eax
400005ac:	80 7c 24 10 2d       	cmpb   $0x2d,0x10(%esp)
400005b1:	89 44 24 14          	mov    %eax,0x14(%esp)
400005b5:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400005b9:	8b 18                	mov    (%eax),%ebx
400005bb:	0f 95 c0             	setne  %al
400005be:	85 c9                	test   %ecx,%ecx
400005c0:	0f 9f c1             	setg   %cl
400005c3:	21 c8                	and    %ecx,%eax
400005c5:	85 db                	test   %ebx,%ebx
400005c7:	0f 84 31 01 00 00    	je     400006fe <vprintfmt+0x3ae>
            if (width > 0 && padc != '-')
400005cd:	8d 4b 01             	lea    0x1(%ebx),%ecx
400005d0:	84 c0                	test   %al,%al
400005d2:	0f 85 5b 01 00 00    	jne    40000733 <vprintfmt+0x3e3>
                 (ch = *p++) != '\0' && (precision < 0
400005d8:	0f be 1b             	movsbl (%ebx),%ebx
400005db:	89 d8                	mov    %ebx,%eax
            for (;
400005dd:	85 db                	test   %ebx,%ebx
400005df:	74 72                	je     40000653 <vprintfmt+0x303>
400005e1:	89 5c 24 10          	mov    %ebx,0x10(%esp)
400005e5:	89 cb                	mov    %ecx,%ebx
400005e7:	8b 4c 24 10          	mov    0x10(%esp),%ecx
400005eb:	89 74 24 40          	mov    %esi,0x40(%esp)
400005ef:	89 d6                	mov    %edx,%esi
400005f1:	89 7c 24 48          	mov    %edi,0x48(%esp)
400005f5:	8b 7c 24 04          	mov    0x4(%esp),%edi
400005f9:	eb 2a                	jmp    40000625 <vprintfmt+0x2d5>
400005fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400005ff:	90                   	nop
                if (altflag && (ch < ' ' || ch > '~'))
40000600:	83 e8 20             	sub    $0x20,%eax
40000603:	83 f8 5e             	cmp    $0x5e,%eax
40000606:	76 31                	jbe    40000639 <vprintfmt+0x2e9>
                    putch('?', putdat);
40000608:	83 ec 08             	sub    $0x8,%esp
4000060b:	55                   	push   %ebp
4000060c:	6a 3f                	push   $0x3f
4000060e:	ff 54 24 50          	call   *0x50(%esp)
40000612:	83 c4 10             	add    $0x10,%esp
                 (ch = *p++) != '\0' && (precision < 0
40000615:	0f be 03             	movsbl (%ebx),%eax
40000618:	83 c3 01             	add    $0x1,%ebx
                                         || --precision >= 0); width--)
4000061b:	83 ef 01             	sub    $0x1,%edi
                 (ch = *p++) != '\0' && (precision < 0
4000061e:	0f be c8             	movsbl %al,%ecx
            for (;
40000621:	85 c9                	test   %ecx,%ecx
40000623:	74 22                	je     40000647 <vprintfmt+0x2f7>
                 (ch = *p++) != '\0' && (precision < 0
40000625:	85 f6                	test   %esi,%esi
40000627:	78 08                	js     40000631 <vprintfmt+0x2e1>
                                         || --precision >= 0); width--)
40000629:	83 ee 01             	sub    $0x1,%esi
4000062c:	83 fe ff             	cmp    $0xffffffff,%esi
4000062f:	74 16                	je     40000647 <vprintfmt+0x2f7>
                if (altflag && (ch < ' ' || ch > '~'))
40000631:	8b 54 24 08          	mov    0x8(%esp),%edx
40000635:	85 d2                	test   %edx,%edx
40000637:	75 c7                	jne    40000600 <vprintfmt+0x2b0>
                    putch(ch, putdat);
40000639:	83 ec 08             	sub    $0x8,%esp
4000063c:	55                   	push   %ebp
4000063d:	51                   	push   %ecx
4000063e:	ff 54 24 50          	call   *0x50(%esp)
40000642:	83 c4 10             	add    $0x10,%esp
40000645:	eb ce                	jmp    40000615 <vprintfmt+0x2c5>
40000647:	89 7c 24 04          	mov    %edi,0x4(%esp)
4000064b:	8b 74 24 40          	mov    0x40(%esp),%esi
4000064f:	8b 7c 24 48          	mov    0x48(%esp),%edi
            for (; width > 0; width--)
40000653:	8b 4c 24 04          	mov    0x4(%esp),%ecx
40000657:	8b 5c 24 04          	mov    0x4(%esp),%ebx
4000065b:	85 c9                	test   %ecx,%ecx
4000065d:	7e 11                	jle    40000670 <vprintfmt+0x320>
4000065f:	90                   	nop
                putch(' ', putdat);
40000660:	83 ec 08             	sub    $0x8,%esp
40000663:	55                   	push   %ebp
40000664:	6a 20                	push   $0x20
40000666:	ff d6                	call   *%esi
            for (; width > 0; width--)
40000668:	83 c4 10             	add    $0x10,%esp
4000066b:	83 eb 01             	sub    $0x1,%ebx
4000066e:	75 f0                	jne    40000660 <vprintfmt+0x310>
            if ((p = va_arg(ap, char *)) == NULL)
40000670:	8b 44 24 14          	mov    0x14(%esp),%eax
40000674:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000678:	e9 e6 fc ff ff       	jmp    40000363 <vprintfmt+0x13>
        return va_arg(*ap, unsigned long long);
4000067d:	8b 48 04             	mov    0x4(%eax),%ecx
40000680:	83 c0 08             	add    $0x8,%eax
40000683:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000687:	b8 0a 00 00 00       	mov    $0xa,%eax
4000068c:	e9 3f fe ff ff       	jmp    400004d0 <vprintfmt+0x180>
40000691:	8b 48 04             	mov    0x4(%eax),%ecx
40000694:	83 c0 08             	add    $0x8,%eax
40000697:	89 44 24 4c          	mov    %eax,0x4c(%esp)
4000069b:	b8 10 00 00 00       	mov    $0x10,%eax
400006a0:	e9 2b fe ff ff       	jmp    400004d0 <vprintfmt+0x180>
        return va_arg(*ap, long long);
400006a5:	8b 08                	mov    (%eax),%ecx
400006a7:	8b 58 04             	mov    0x4(%eax),%ebx
400006aa:	83 c0 08             	add    $0x8,%eax
400006ad:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400006b1:	e9 ab fe ff ff       	jmp    40000561 <vprintfmt+0x211>
            padc = '-';
400006b6:	c6 44 24 10 2d       	movb   $0x2d,0x10(%esp)
        switch (ch = *(unsigned char *) fmt++) {
400006bb:	89 fb                	mov    %edi,%ebx
400006bd:	e9 f8 fc ff ff       	jmp    400003ba <vprintfmt+0x6a>
400006c2:	c6 44 24 10 30       	movb   $0x30,0x10(%esp)
400006c7:	89 fb                	mov    %edi,%ebx
400006c9:	e9 ec fc ff ff       	jmp    400003ba <vprintfmt+0x6a>
400006ce:	89 4c 24 08          	mov    %ecx,0x8(%esp)
                putch('-', putdat);
400006d2:	83 ec 08             	sub    $0x8,%esp
400006d5:	89 5c 24 14          	mov    %ebx,0x14(%esp)
400006d9:	55                   	push   %ebp
400006da:	6a 2d                	push   $0x2d
400006dc:	ff d6                	call   *%esi
                num = -(long long) num;
400006de:	8b 4c 24 18          	mov    0x18(%esp),%ecx
400006e2:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
400006e6:	b8 0a 00 00 00       	mov    $0xa,%eax
400006eb:	89 ca                	mov    %ecx,%edx
400006ed:	89 d9                	mov    %ebx,%ecx
400006ef:	f7 da                	neg    %edx
400006f1:	83 d1 00             	adc    $0x0,%ecx
400006f4:	83 c4 10             	add    $0x10,%esp
400006f7:	f7 d9                	neg    %ecx
400006f9:	e9 d2 fd ff ff       	jmp    400004d0 <vprintfmt+0x180>
                 (ch = *p++) != '\0' && (precision < 0
400006fe:	bb 28 00 00 00       	mov    $0x28,%ebx
40000703:	b9 36 20 00 40       	mov    $0x40002036,%ecx
            if (width > 0 && padc != '-')
40000708:	84 c0                	test   %al,%al
4000070a:	0f 85 9d 00 00 00    	jne    400007ad <vprintfmt+0x45d>
40000710:	89 5c 24 10          	mov    %ebx,0x10(%esp)
                 (ch = *p++) != '\0' && (precision < 0
40000714:	b8 28 00 00 00       	mov    $0x28,%eax
40000719:	89 cb                	mov    %ecx,%ebx
4000071b:	b9 28 00 00 00       	mov    $0x28,%ecx
40000720:	89 74 24 40          	mov    %esi,0x40(%esp)
40000724:	89 d6                	mov    %edx,%esi
40000726:	89 7c 24 48          	mov    %edi,0x48(%esp)
4000072a:	8b 7c 24 04          	mov    0x4(%esp),%edi
4000072e:	e9 f2 fe ff ff       	jmp    40000625 <vprintfmt+0x2d5>
40000733:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
                for (width -= strnlen(p, precision); width > 0; width--)
40000737:	83 ec 08             	sub    $0x8,%esp
4000073a:	52                   	push   %edx
4000073b:	89 54 24 24          	mov    %edx,0x24(%esp)
4000073f:	53                   	push   %ebx
40000740:	e8 eb 02 00 00       	call   40000a30 <strnlen>
40000745:	29 44 24 14          	sub    %eax,0x14(%esp)
40000749:	8b 4c 24 14          	mov    0x14(%esp),%ecx
4000074d:	83 c4 10             	add    $0x10,%esp
40000750:	8b 54 24 18          	mov    0x18(%esp),%edx
40000754:	85 c9                	test   %ecx,%ecx
40000756:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
4000075a:	7e 3e                	jle    4000079a <vprintfmt+0x44a>
4000075c:	0f be 44 24 10       	movsbl 0x10(%esp),%eax
40000761:	89 4c 24 18          	mov    %ecx,0x18(%esp)
40000765:	89 54 24 10          	mov    %edx,0x10(%esp)
40000769:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
4000076d:	8b 5c 24 04          	mov    0x4(%esp),%ebx
40000771:	89 7c 24 48          	mov    %edi,0x48(%esp)
40000775:	89 c7                	mov    %eax,%edi
                    putch(padc, putdat);
40000777:	83 ec 08             	sub    $0x8,%esp
4000077a:	55                   	push   %ebp
4000077b:	57                   	push   %edi
4000077c:	ff d6                	call   *%esi
                for (width -= strnlen(p, precision); width > 0; width--)
4000077e:	83 c4 10             	add    $0x10,%esp
40000781:	83 eb 01             	sub    $0x1,%ebx
40000784:	75 f1                	jne    40000777 <vprintfmt+0x427>
40000786:	8b 54 24 10          	mov    0x10(%esp),%edx
4000078a:	8b 4c 24 18          	mov    0x18(%esp),%ecx
4000078e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
40000792:	8b 7c 24 48          	mov    0x48(%esp),%edi
40000796:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
                 (ch = *p++) != '\0' && (precision < 0
4000079a:	0f be 03             	movsbl (%ebx),%eax
4000079d:	0f be d8             	movsbl %al,%ebx
            for (;
400007a0:	85 db                	test   %ebx,%ebx
400007a2:	0f 85 39 fe ff ff    	jne    400005e1 <vprintfmt+0x291>
400007a8:	e9 c3 fe ff ff       	jmp    40000670 <vprintfmt+0x320>
                for (width -= strnlen(p, precision); width > 0; width--)
400007ad:	83 ec 08             	sub    $0x8,%esp
                p = "(null)";
400007b0:	bb 35 20 00 40       	mov    $0x40002035,%ebx
                for (width -= strnlen(p, precision); width > 0; width--)
400007b5:	52                   	push   %edx
400007b6:	89 54 24 24          	mov    %edx,0x24(%esp)
400007ba:	68 35 20 00 40       	push   $0x40002035
400007bf:	e8 6c 02 00 00       	call   40000a30 <strnlen>
400007c4:	29 44 24 14          	sub    %eax,0x14(%esp)
400007c8:	8b 44 24 14          	mov    0x14(%esp),%eax
400007cc:	83 c4 10             	add    $0x10,%esp
400007cf:	b9 36 20 00 40       	mov    $0x40002036,%ecx
400007d4:	8b 54 24 18          	mov    0x18(%esp),%edx
400007d8:	85 c0                	test   %eax,%eax
400007da:	7f 80                	jg     4000075c <vprintfmt+0x40c>
                 (ch = *p++) != '\0' && (precision < 0
400007dc:	bb 28 00 00 00       	mov    $0x28,%ebx
400007e1:	e9 2a ff ff ff       	jmp    40000710 <vprintfmt+0x3c0>
400007e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400007ed:	8d 76 00             	lea    0x0(%esi),%esi

400007f0 <printfmt>:
{
400007f0:	83 ec 0c             	sub    $0xc,%esp
    vprintfmt(putch, putdat, fmt, ap);
400007f3:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400007f7:	50                   	push   %eax
400007f8:	ff 74 24 1c          	pushl  0x1c(%esp)
400007fc:	ff 74 24 1c          	pushl  0x1c(%esp)
40000800:	ff 74 24 1c          	pushl  0x1c(%esp)
40000804:	e8 47 fb ff ff       	call   40000350 <vprintfmt>
}
40000809:	83 c4 1c             	add    $0x1c,%esp
4000080c:	c3                   	ret    
4000080d:	8d 76 00             	lea    0x0(%esi),%esi

40000810 <vsprintf>:

int vsprintf(char *buf, const char *fmt, va_list ap)
{
40000810:	83 ec 1c             	sub    $0x1c,%esp
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
40000813:	8b 44 24 20          	mov    0x20(%esp),%eax
40000817:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
4000081e:	ff 
4000081f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000826:	00 
40000827:	89 44 24 04          	mov    %eax,0x4(%esp)

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
4000082b:	ff 74 24 28          	pushl  0x28(%esp)
4000082f:	ff 74 24 28          	pushl  0x28(%esp)
40000833:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000837:	50                   	push   %eax
40000838:	68 30 03 00 40       	push   $0x40000330
4000083d:	e8 0e fb ff ff       	call   40000350 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
40000842:	8b 44 24 14          	mov    0x14(%esp),%eax
40000846:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
40000849:	8b 44 24 1c          	mov    0x1c(%esp),%eax
4000084d:	83 c4 2c             	add    $0x2c,%esp
40000850:	c3                   	ret    
40000851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000085f:	90                   	nop

40000860 <sprintf>:

int sprintf(char *buf, const char *fmt, ...)
{
40000860:	83 ec 1c             	sub    $0x1c,%esp
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
40000863:	8b 44 24 20          	mov    0x20(%esp),%eax
40000867:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
4000086e:	ff 
4000086f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000876:	00 
40000877:	89 44 24 04          	mov    %eax,0x4(%esp)
    vprintfmt((void *) sprintputch, &b, fmt, ap);
4000087b:	8d 44 24 28          	lea    0x28(%esp),%eax
4000087f:	50                   	push   %eax
40000880:	ff 74 24 28          	pushl  0x28(%esp)
40000884:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000888:	50                   	push   %eax
40000889:	68 30 03 00 40       	push   $0x40000330
4000088e:	e8 bd fa ff ff       	call   40000350 <vprintfmt>
    *b.buf = '\0';
40000893:	8b 44 24 14          	mov    0x14(%esp),%eax
40000897:	c6 00 00             	movb   $0x0,(%eax)
    va_start(ap, fmt);
    rc = vsprintf(buf, fmt, ap);
    va_end(ap);

    return rc;
}
4000089a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
4000089e:	83 c4 2c             	add    $0x2c,%esp
400008a1:	c3                   	ret    
400008a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400008a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400008b0 <vsnprintf>:

int vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
400008b0:	83 ec 1c             	sub    $0x1c,%esp
400008b3:	8b 44 24 20          	mov    0x20(%esp),%eax
    struct sprintbuf b = { buf, buf + n - 1, 0 };
400008b7:	8b 54 24 24          	mov    0x24(%esp),%edx
400008bb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400008c2:	00 
400008c3:	89 44 24 04          	mov    %eax,0x4(%esp)
400008c7:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
400008cb:	89 44 24 08          	mov    %eax,0x8(%esp)

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
400008cf:	ff 74 24 2c          	pushl  0x2c(%esp)
400008d3:	ff 74 24 2c          	pushl  0x2c(%esp)
400008d7:	8d 44 24 0c          	lea    0xc(%esp),%eax
400008db:	50                   	push   %eax
400008dc:	68 30 03 00 40       	push   $0x40000330
400008e1:	e8 6a fa ff ff       	call   40000350 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
400008e6:	8b 44 24 14          	mov    0x14(%esp),%eax
400008ea:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
400008ed:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400008f1:	83 c4 2c             	add    $0x2c,%esp
400008f4:	c3                   	ret    
400008f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400008fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000900 <snprintf>:

int snprintf(char *buf, int n, const char *fmt, ...)
{
40000900:	83 ec 1c             	sub    $0x1c,%esp
40000903:	8b 44 24 20          	mov    0x20(%esp),%eax
    struct sprintbuf b = { buf, buf + n - 1, 0 };
40000907:	8b 54 24 24          	mov    0x24(%esp),%edx
4000090b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000912:	00 
40000913:	89 44 24 04          	mov    %eax,0x4(%esp)
40000917:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
4000091b:	89 44 24 08          	mov    %eax,0x8(%esp)
    vprintfmt((void *) sprintputch, &b, fmt, ap);
4000091f:	8d 44 24 2c          	lea    0x2c(%esp),%eax
40000923:	50                   	push   %eax
40000924:	ff 74 24 2c          	pushl  0x2c(%esp)
40000928:	8d 44 24 0c          	lea    0xc(%esp),%eax
4000092c:	50                   	push   %eax
4000092d:	68 30 03 00 40       	push   $0x40000330
40000932:	e8 19 fa ff ff       	call   40000350 <vprintfmt>
    *b.buf = '\0';
40000937:	8b 44 24 14          	mov    0x14(%esp),%eax
4000093b:	c6 00 00             	movb   $0x0,(%eax)
    va_start(ap, fmt);
    rc = vsnprintf(buf, n, fmt, ap);
    va_end(ap);

    return rc;
}
4000093e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000942:	83 c4 2c             	add    $0x2c,%esp
40000945:	c3                   	ret    
40000946:	66 90                	xchg   %ax,%ax
40000948:	66 90                	xchg   %ax,%ax
4000094a:	66 90                	xchg   %ax,%ax
4000094c:	66 90                	xchg   %ax,%ax
4000094e:	66 90                	xchg   %ax,%ax

40000950 <spawn>:
#include <proc.h>
#include <syscall.h>
#include <types.h>

pid_t spawn(uintptr_t exec, unsigned int quota)
{
40000950:	53                   	push   %ebx
static gcc_inline pid_t sys_spawn(unsigned int elf_id, unsigned int quota)
{
    int errno;
    pid_t pid;

    asm volatile ("int %2"
40000951:	b8 01 00 00 00       	mov    $0x1,%eax
40000956:	8b 5c 24 08          	mov    0x8(%esp),%ebx
4000095a:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
4000095e:	cd 30                	int    $0x30
                    "a" (SYS_spawn),
                    "b" (elf_id),
                    "c" (quota)
                  : "cc", "memory");

    return errno ? -1 : pid;
40000960:	85 c0                	test   %eax,%eax
40000962:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000967:	0f 44 c3             	cmove  %ebx,%eax
    return sys_spawn(exec, quota);
}
4000096a:	5b                   	pop    %ebx
4000096b:	c3                   	ret    
4000096c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000970 <yield>:
}

static gcc_inline void sys_yield(void)
{
    asm volatile ("int %0"
40000970:	b8 02 00 00 00       	mov    $0x2,%eax
40000975:	cd 30                	int    $0x30

void yield(void)
{
    sys_yield();
}
40000977:	c3                   	ret    
40000978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000097f:	90                   	nop

40000980 <produce>:

void produce(unsigned int val)
{
40000980:	53                   	push   %ebx
                  : "cc", "memory");
}

static gcc_inline void sys_produce(unsigned int val)
{
    asm volatile ("int %0"
40000981:	b8 03 00 00 00       	mov    $0x3,%eax
40000986:	8b 5c 24 08          	mov    0x8(%esp),%ebx
4000098a:	cd 30                	int    $0x30
    sys_produce(val);
}
4000098c:	5b                   	pop    %ebx
4000098d:	c3                   	ret    
4000098e:	66 90                	xchg   %ax,%ax

40000990 <consume>:

unsigned int consume(void)
{
40000990:	53                   	push   %ebx
}

static gcc_inline unsigned int sys_consume(void)
{
    unsigned int val;
    asm volatile ("int %1"
40000991:	b8 04 00 00 00       	mov    $0x4,%eax
40000996:	cd 30                	int    $0x30
40000998:	89 d8                	mov    %ebx,%eax
    return sys_consume();
}
4000099a:	5b                   	pop    %ebx
4000099b:	c3                   	ret    
4000099c:	66 90                	xchg   %ax,%ax
4000099e:	66 90                	xchg   %ax,%ax

400009a0 <spinlock_init>:
    return result;
}

void spinlock_init(spinlock_t *lk)
{
    *lk = 0;
400009a0:	8b 44 24 04          	mov    0x4(%esp),%eax
400009a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
400009aa:	c3                   	ret    
400009ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400009af:	90                   	nop

400009b0 <spinlock_acquire>:

void spinlock_acquire(spinlock_t *lk)
{
400009b0:	8b 54 24 04          	mov    0x4(%esp),%edx
    asm volatile ("lock; xchgl %0, %1"
400009b4:	b8 01 00 00 00       	mov    $0x1,%eax
400009b9:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
400009bc:	85 c0                	test   %eax,%eax
400009be:	74 13                	je     400009d3 <spinlock_acquire+0x23>
    asm volatile ("lock; xchgl %0, %1"
400009c0:	b9 01 00 00 00       	mov    $0x1,%ecx
400009c5:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("pause");
400009c8:	f3 90                	pause  
    asm volatile ("lock; xchgl %0, %1"
400009ca:	89 c8                	mov    %ecx,%eax
400009cc:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
400009cf:	85 c0                	test   %eax,%eax
400009d1:	75 f5                	jne    400009c8 <spinlock_acquire+0x18>
}
400009d3:	c3                   	ret    
400009d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400009db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400009df:	90                   	nop

400009e0 <spinlock_release>:

// Release the lock.
void spinlock_release(spinlock_t *lk)
{
400009e0:	8b 54 24 04          	mov    0x4(%esp),%edx
}

// Check whether this cpu is holding the lock.
bool spinlock_holding(spinlock_t *lk)
{
    return *lk;
400009e4:	8b 02                	mov    (%edx),%eax
    if (spinlock_holding(lk) == FALSE)
400009e6:	84 c0                	test   %al,%al
400009e8:	74 05                	je     400009ef <spinlock_release+0xf>
    asm volatile ("lock; xchgl %0, %1"
400009ea:	31 c0                	xor    %eax,%eax
400009ec:	f0 87 02             	lock xchg %eax,(%edx)
}
400009ef:	c3                   	ret    

400009f0 <spinlock_holding>:
    return *lk;
400009f0:	8b 44 24 04          	mov    0x4(%esp),%eax
400009f4:	8b 00                	mov    (%eax),%eax
}
400009f6:	c3                   	ret    
400009f7:	66 90                	xchg   %ax,%ax
400009f9:	66 90                	xchg   %ax,%ax
400009fb:	66 90                	xchg   %ax,%ax
400009fd:	66 90                	xchg   %ax,%ax
400009ff:	90                   	nop

40000a00 <strlen>:
#include <string.h>
#include <types.h>

int strlen(const char *s)
{
40000a00:	8b 54 24 04          	mov    0x4(%esp),%edx
    int n;

    for (n = 0; *s != '\0'; s++)
40000a04:	31 c0                	xor    %eax,%eax
40000a06:	80 3a 00             	cmpb   $0x0,(%edx)
40000a09:	74 15                	je     40000a20 <strlen+0x20>
40000a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000a0f:	90                   	nop
        n++;
40000a10:	83 c0 01             	add    $0x1,%eax
    for (n = 0; *s != '\0'; s++)
40000a13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000a17:	75 f7                	jne    40000a10 <strlen+0x10>
40000a19:	c3                   	ret    
40000a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return n;
}
40000a20:	c3                   	ret    
40000a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a2f:	90                   	nop

40000a30 <strnlen>:

int strnlen(const char *s, size_t size)
{
40000a30:	8b 54 24 08          	mov    0x8(%esp),%edx
40000a34:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a38:	31 c0                	xor    %eax,%eax
40000a3a:	85 d2                	test   %edx,%edx
40000a3c:	75 09                	jne    40000a47 <strnlen+0x17>
40000a3e:	eb 10                	jmp    40000a50 <strnlen+0x20>
        n++;
40000a40:	83 c0 01             	add    $0x1,%eax
    for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a43:	39 d0                	cmp    %edx,%eax
40000a45:	74 09                	je     40000a50 <strnlen+0x20>
40000a47:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000a4b:	75 f3                	jne    40000a40 <strnlen+0x10>
40000a4d:	c3                   	ret    
40000a4e:	66 90                	xchg   %ax,%ax
    return n;
}
40000a50:	c3                   	ret    
40000a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a5f:	90                   	nop

40000a60 <strcpy>:

char *strcpy(char *dst, const char *src)
{
40000a60:	53                   	push   %ebx
40000a61:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    char *ret;

    ret = dst;
    while ((*dst++ = *src++) != '\0')
40000a65:	31 c0                	xor    %eax,%eax
{
40000a67:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
40000a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000a6f:	90                   	nop
    while ((*dst++ = *src++) != '\0')
40000a70:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000a74:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000a77:	83 c0 01             	add    $0x1,%eax
40000a7a:	84 d2                	test   %dl,%dl
40000a7c:	75 f2                	jne    40000a70 <strcpy+0x10>
        /* do nothing */ ;
    return ret;
}
40000a7e:	89 c8                	mov    %ecx,%eax
40000a80:	5b                   	pop    %ebx
40000a81:	c3                   	ret    
40000a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000a90 <strncpy>:

char *strncpy(char *dst, const char *src, size_t size)
{
40000a90:	56                   	push   %esi
40000a91:	53                   	push   %ebx
40000a92:	8b 5c 24 14          	mov    0x14(%esp),%ebx
40000a96:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000a9a:	8b 44 24 10          	mov    0x10(%esp),%eax
    size_t i;
    char *ret;

    ret = dst;
    for (i = 0; i < size; i++) {
40000a9e:	85 db                	test   %ebx,%ebx
40000aa0:	74 21                	je     40000ac3 <strncpy+0x33>
40000aa2:	01 f3                	add    %esi,%ebx
40000aa4:	89 f2                	mov    %esi,%edx
40000aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000aad:	8d 76 00             	lea    0x0(%esi),%esi
        *dst++ = *src;
40000ab0:	0f b6 08             	movzbl (%eax),%ecx
40000ab3:	83 c2 01             	add    $0x1,%edx
40000ab6:	88 4a ff             	mov    %cl,-0x1(%edx)
        // If strlen(src) < size, null-pad 'dst' out to 'size' chars
        if (*src != '\0')
            src++;
40000ab9:	80 38 01             	cmpb   $0x1,(%eax)
40000abc:	83 d8 ff             	sbb    $0xffffffff,%eax
    for (i = 0; i < size; i++) {
40000abf:	39 da                	cmp    %ebx,%edx
40000ac1:	75 ed                	jne    40000ab0 <strncpy+0x20>
    }
    return ret;
}
40000ac3:	89 f0                	mov    %esi,%eax
40000ac5:	5b                   	pop    %ebx
40000ac6:	5e                   	pop    %esi
40000ac7:	c3                   	ret    
40000ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000acf:	90                   	nop

40000ad0 <strlcpy>:

size_t strlcpy(char *dst, const char *src, size_t size)
{
40000ad0:	56                   	push   %esi
40000ad1:	53                   	push   %ebx
40000ad2:	8b 44 24 14          	mov    0x14(%esp),%eax
40000ad6:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000ada:	8b 4c 24 10          	mov    0x10(%esp),%ecx
    char *dst_in;

    dst_in = dst;
    if (size > 0) {
40000ade:	85 c0                	test   %eax,%eax
40000ae0:	74 29                	je     40000b0b <strlcpy+0x3b>
        while (--size > 0 && *src != '\0')
40000ae2:	89 f2                	mov    %esi,%edx
40000ae4:	83 e8 01             	sub    $0x1,%eax
40000ae7:	74 1f                	je     40000b08 <strlcpy+0x38>
40000ae9:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
40000aec:	eb 0f                	jmp    40000afd <strlcpy+0x2d>
40000aee:	66 90                	xchg   %ax,%ax
            *dst++ = *src++;
40000af0:	83 c2 01             	add    $0x1,%edx
40000af3:	83 c1 01             	add    $0x1,%ecx
40000af6:	88 42 ff             	mov    %al,-0x1(%edx)
        while (--size > 0 && *src != '\0')
40000af9:	39 da                	cmp    %ebx,%edx
40000afb:	74 07                	je     40000b04 <strlcpy+0x34>
40000afd:	0f b6 01             	movzbl (%ecx),%eax
40000b00:	84 c0                	test   %al,%al
40000b02:	75 ec                	jne    40000af0 <strlcpy+0x20>
40000b04:	89 d0                	mov    %edx,%eax
40000b06:	29 f0                	sub    %esi,%eax
        *dst = '\0';
40000b08:	c6 02 00             	movb   $0x0,(%edx)
    }
    return dst - dst_in;
}
40000b0b:	5b                   	pop    %ebx
40000b0c:	5e                   	pop    %esi
40000b0d:	c3                   	ret    
40000b0e:	66 90                	xchg   %ax,%ax

40000b10 <strcmp>:

int strcmp(const char *p, const char *q)
{
40000b10:	53                   	push   %ebx
40000b11:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000b15:	8b 54 24 0c          	mov    0xc(%esp),%edx
    while (*p && *p == *q)
40000b19:	0f b6 01             	movzbl (%ecx),%eax
40000b1c:	0f b6 1a             	movzbl (%edx),%ebx
40000b1f:	84 c0                	test   %al,%al
40000b21:	75 16                	jne    40000b39 <strcmp+0x29>
40000b23:	eb 23                	jmp    40000b48 <strcmp+0x38>
40000b25:	8d 76 00             	lea    0x0(%esi),%esi
40000b28:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        p++, q++;
40000b2c:	83 c1 01             	add    $0x1,%ecx
40000b2f:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
40000b32:	0f b6 1a             	movzbl (%edx),%ebx
40000b35:	84 c0                	test   %al,%al
40000b37:	74 0f                	je     40000b48 <strcmp+0x38>
40000b39:	38 d8                	cmp    %bl,%al
40000b3b:	74 eb                	je     40000b28 <strcmp+0x18>
    return (int) ((unsigned char) *p - (unsigned char) *q);
40000b3d:	29 d8                	sub    %ebx,%eax
}
40000b3f:	5b                   	pop    %ebx
40000b40:	c3                   	ret    
40000b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b48:	31 c0                	xor    %eax,%eax
    return (int) ((unsigned char) *p - (unsigned char) *q);
40000b4a:	29 d8                	sub    %ebx,%eax
}
40000b4c:	5b                   	pop    %ebx
40000b4d:	c3                   	ret    
40000b4e:	66 90                	xchg   %ax,%ax

40000b50 <strncmp>:

int strncmp(const char *p, const char *q, size_t n)
{
40000b50:	56                   	push   %esi
40000b51:	53                   	push   %ebx
40000b52:	8b 74 24 14          	mov    0x14(%esp),%esi
40000b56:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000b5a:	8b 44 24 10          	mov    0x10(%esp),%eax
    while (n > 0 && *p && *p == *q)
40000b5e:	85 f6                	test   %esi,%esi
40000b60:	74 2e                	je     40000b90 <strncmp+0x40>
40000b62:	01 c6                	add    %eax,%esi
40000b64:	eb 18                	jmp    40000b7e <strncmp+0x2e>
40000b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b6d:	8d 76 00             	lea    0x0(%esi),%esi
40000b70:	38 da                	cmp    %bl,%dl
40000b72:	75 14                	jne    40000b88 <strncmp+0x38>
        n--, p++, q++;
40000b74:	83 c0 01             	add    $0x1,%eax
40000b77:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q)
40000b7a:	39 f0                	cmp    %esi,%eax
40000b7c:	74 12                	je     40000b90 <strncmp+0x40>
40000b7e:	0f b6 11             	movzbl (%ecx),%edx
40000b81:	0f b6 18             	movzbl (%eax),%ebx
40000b84:	84 d2                	test   %dl,%dl
40000b86:	75 e8                	jne    40000b70 <strncmp+0x20>
    if (n == 0)
        return 0;
    else
        return (int) ((unsigned char) *p - (unsigned char) *q);
40000b88:	0f b6 c2             	movzbl %dl,%eax
40000b8b:	29 d8                	sub    %ebx,%eax
}
40000b8d:	5b                   	pop    %ebx
40000b8e:	5e                   	pop    %esi
40000b8f:	c3                   	ret    
        return 0;
40000b90:	31 c0                	xor    %eax,%eax
}
40000b92:	5b                   	pop    %ebx
40000b93:	5e                   	pop    %esi
40000b94:	c3                   	ret    
40000b95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000ba0 <strchr>:

char *strchr(const char *s, char c)
{
40000ba0:	8b 44 24 04          	mov    0x4(%esp),%eax
40000ba4:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
    for (; *s; s++)
40000ba9:	0f b6 10             	movzbl (%eax),%edx
40000bac:	84 d2                	test   %dl,%dl
40000bae:	75 13                	jne    40000bc3 <strchr+0x23>
40000bb0:	eb 1e                	jmp    40000bd0 <strchr+0x30>
40000bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000bb8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000bbc:	83 c0 01             	add    $0x1,%eax
40000bbf:	84 d2                	test   %dl,%dl
40000bc1:	74 0d                	je     40000bd0 <strchr+0x30>
        if (*s == c)
40000bc3:	38 d1                	cmp    %dl,%cl
40000bc5:	75 f1                	jne    40000bb8 <strchr+0x18>
            return (char *) s;
    return 0;
}
40000bc7:	c3                   	ret    
40000bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bcf:	90                   	nop
    return 0;
40000bd0:	31 c0                	xor    %eax,%eax
}
40000bd2:	c3                   	ret    
40000bd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000be0 <strfind>:

char *strfind(const char *s, char c)
{
40000be0:	53                   	push   %ebx
40000be1:	8b 44 24 08          	mov    0x8(%esp),%eax
40000be5:	8b 54 24 0c          	mov    0xc(%esp),%edx
    for (; *s; s++)
40000be9:	0f b6 18             	movzbl (%eax),%ebx
        if (*s == c)
40000bec:	38 d3                	cmp    %dl,%bl
40000bee:	74 1f                	je     40000c0f <strfind+0x2f>
40000bf0:	89 d1                	mov    %edx,%ecx
40000bf2:	84 db                	test   %bl,%bl
40000bf4:	75 0e                	jne    40000c04 <strfind+0x24>
40000bf6:	eb 17                	jmp    40000c0f <strfind+0x2f>
40000bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bff:	90                   	nop
40000c00:	84 d2                	test   %dl,%dl
40000c02:	74 0b                	je     40000c0f <strfind+0x2f>
    for (; *s; s++)
40000c04:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000c08:	83 c0 01             	add    $0x1,%eax
        if (*s == c)
40000c0b:	38 ca                	cmp    %cl,%dl
40000c0d:	75 f1                	jne    40000c00 <strfind+0x20>
            break;
    return (char *) s;
}
40000c0f:	5b                   	pop    %ebx
40000c10:	c3                   	ret    
40000c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c1f:	90                   	nop

40000c20 <strtol>:

long strtol(const char *s, char **endptr, int base)
{
40000c20:	55                   	push   %ebp
40000c21:	57                   	push   %edi
40000c22:	56                   	push   %esi
40000c23:	53                   	push   %ebx
40000c24:	83 ec 04             	sub    $0x4,%esp
40000c27:	8b 44 24 20          	mov    0x20(%esp),%eax
40000c2b:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000c2f:	8b 74 24 1c          	mov    0x1c(%esp),%esi
40000c33:	89 04 24             	mov    %eax,(%esp)
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
40000c36:	0f b6 01             	movzbl (%ecx),%eax
40000c39:	3c 09                	cmp    $0x9,%al
40000c3b:	74 0b                	je     40000c48 <strtol+0x28>
40000c3d:	3c 20                	cmp    $0x20,%al
40000c3f:	75 16                	jne    40000c57 <strtol+0x37>
40000c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c48:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        s++;
40000c4c:	83 c1 01             	add    $0x1,%ecx
    while (*s == ' ' || *s == '\t')
40000c4f:	3c 20                	cmp    $0x20,%al
40000c51:	74 f5                	je     40000c48 <strtol+0x28>
40000c53:	3c 09                	cmp    $0x9,%al
40000c55:	74 f1                	je     40000c48 <strtol+0x28>

    // plus/minus sign
    if (*s == '+')
40000c57:	3c 2b                	cmp    $0x2b,%al
40000c59:	0f 84 a1 00 00 00    	je     40000d00 <strtol+0xe0>
    int neg = 0;
40000c5f:	31 ff                	xor    %edi,%edi
        s++;
    else if (*s == '-')
40000c61:	3c 2d                	cmp    $0x2d,%al
40000c63:	0f 84 87 00 00 00    	je     40000cf0 <strtol+0xd0>
        s++, neg = 1;

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000c69:	0f be 11             	movsbl (%ecx),%edx
40000c6c:	f7 04 24 ef ff ff ff 	testl  $0xffffffef,(%esp)
40000c73:	75 17                	jne    40000c8c <strtol+0x6c>
40000c75:	80 fa 30             	cmp    $0x30,%dl
40000c78:	0f 84 92 00 00 00    	je     40000d10 <strtol+0xf0>
        s += 2, base = 16;
    else if (base == 0 && s[0] == '0')
40000c7e:	8b 2c 24             	mov    (%esp),%ebp
40000c81:	85 ed                	test   %ebp,%ebp
40000c83:	75 07                	jne    40000c8c <strtol+0x6c>
        s++, base = 8;
    else if (base == 0)
        base = 10;
40000c85:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
40000c8c:	31 c0                	xor    %eax,%eax
40000c8e:	eb 15                	jmp    40000ca5 <strtol+0x85>
    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9')
            dig = *s - '0';
40000c90:	83 ea 30             	sub    $0x30,%edx
            dig = *s - 'a' + 10;
        else if (*s >= 'A' && *s <= 'Z')
            dig = *s - 'A' + 10;
        else
            break;
        if (dig >= base)
40000c93:	8b 1c 24             	mov    (%esp),%ebx
40000c96:	39 da                	cmp    %ebx,%edx
40000c98:	7d 29                	jge    40000cc3 <strtol+0xa3>
            break;
        s++, val = (val * base) + dig;
40000c9a:	0f af c3             	imul   %ebx,%eax
40000c9d:	83 c1 01             	add    $0x1,%ecx
40000ca0:	01 d0                	add    %edx,%eax
    while (1) {
40000ca2:	0f be 11             	movsbl (%ecx),%edx
        if (*s >= '0' && *s <= '9')
40000ca5:	8d 6a d0             	lea    -0x30(%edx),%ebp
40000ca8:	89 eb                	mov    %ebp,%ebx
40000caa:	80 fb 09             	cmp    $0x9,%bl
40000cad:	76 e1                	jbe    40000c90 <strtol+0x70>
        else if (*s >= 'a' && *s <= 'z')
40000caf:	8d 6a 9f             	lea    -0x61(%edx),%ebp
40000cb2:	89 eb                	mov    %ebp,%ebx
40000cb4:	80 fb 19             	cmp    $0x19,%bl
40000cb7:	77 27                	ja     40000ce0 <strtol+0xc0>
        if (dig >= base)
40000cb9:	8b 1c 24             	mov    (%esp),%ebx
            dig = *s - 'a' + 10;
40000cbc:	83 ea 57             	sub    $0x57,%edx
        if (dig >= base)
40000cbf:	39 da                	cmp    %ebx,%edx
40000cc1:	7c d7                	jl     40000c9a <strtol+0x7a>
        // we don't properly detect overflow!
    }

    if (endptr)
40000cc3:	85 f6                	test   %esi,%esi
40000cc5:	74 02                	je     40000cc9 <strtol+0xa9>
        *endptr = (char *) s;
40000cc7:	89 0e                	mov    %ecx,(%esi)
    return (neg ? -val : val);
40000cc9:	89 c2                	mov    %eax,%edx
40000ccb:	f7 da                	neg    %edx
40000ccd:	85 ff                	test   %edi,%edi
40000ccf:	0f 45 c2             	cmovne %edx,%eax
}
40000cd2:	83 c4 04             	add    $0x4,%esp
40000cd5:	5b                   	pop    %ebx
40000cd6:	5e                   	pop    %esi
40000cd7:	5f                   	pop    %edi
40000cd8:	5d                   	pop    %ebp
40000cd9:	c3                   	ret    
40000cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        else if (*s >= 'A' && *s <= 'Z')
40000ce0:	8d 6a bf             	lea    -0x41(%edx),%ebp
40000ce3:	89 eb                	mov    %ebp,%ebx
40000ce5:	80 fb 19             	cmp    $0x19,%bl
40000ce8:	77 d9                	ja     40000cc3 <strtol+0xa3>
            dig = *s - 'A' + 10;
40000cea:	83 ea 37             	sub    $0x37,%edx
40000ced:	eb a4                	jmp    40000c93 <strtol+0x73>
40000cef:	90                   	nop
        s++, neg = 1;
40000cf0:	83 c1 01             	add    $0x1,%ecx
40000cf3:	bf 01 00 00 00       	mov    $0x1,%edi
40000cf8:	e9 6c ff ff ff       	jmp    40000c69 <strtol+0x49>
40000cfd:	8d 76 00             	lea    0x0(%esi),%esi
        s++;
40000d00:	83 c1 01             	add    $0x1,%ecx
    int neg = 0;
40000d03:	31 ff                	xor    %edi,%edi
40000d05:	e9 5f ff ff ff       	jmp    40000c69 <strtol+0x49>
40000d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000d10:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
40000d14:	3c 78                	cmp    $0x78,%al
40000d16:	74 1d                	je     40000d35 <strtol+0x115>
    else if (base == 0 && s[0] == '0')
40000d18:	8b 1c 24             	mov    (%esp),%ebx
40000d1b:	85 db                	test   %ebx,%ebx
40000d1d:	0f 85 69 ff ff ff    	jne    40000c8c <strtol+0x6c>
        s++, base = 8;
40000d23:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
40000d2a:	83 c1 01             	add    $0x1,%ecx
40000d2d:	0f be d0             	movsbl %al,%edx
40000d30:	e9 57 ff ff ff       	jmp    40000c8c <strtol+0x6c>
        s += 2, base = 16;
40000d35:	0f be 51 02          	movsbl 0x2(%ecx),%edx
40000d39:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
40000d40:	83 c1 02             	add    $0x2,%ecx
40000d43:	e9 44 ff ff ff       	jmp    40000c8c <strtol+0x6c>
40000d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d4f:	90                   	nop

40000d50 <memset>:

void *memset(void *v, int c, size_t n)
{
40000d50:	57                   	push   %edi
40000d51:	56                   	push   %esi
40000d52:	53                   	push   %ebx
40000d53:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000d57:	8b 7c 24 10          	mov    0x10(%esp),%edi
    if (n == 0)
40000d5b:	85 c9                	test   %ecx,%ecx
40000d5d:	74 28                	je     40000d87 <memset+0x37>
        return v;
    if ((int) v % 4 == 0 && n % 4 == 0) {
40000d5f:	89 f8                	mov    %edi,%eax
40000d61:	09 c8                	or     %ecx,%eax
40000d63:	a8 03                	test   $0x3,%al
40000d65:	75 29                	jne    40000d90 <memset+0x40>
        c &= 0xFF;
40000d67:	0f b6 54 24 14       	movzbl 0x14(%esp),%edx
        c = (c << 24) | (c << 16) | (c << 8) | c;
        asm volatile ("cld; rep stosl\n"
                      :: "D" (v), "a" (c), "c" (n / 4)
40000d6c:	c1 e9 02             	shr    $0x2,%ecx
        c = (c << 24) | (c << 16) | (c << 8) | c;
40000d6f:	89 d0                	mov    %edx,%eax
40000d71:	89 d6                	mov    %edx,%esi
40000d73:	89 d3                	mov    %edx,%ebx
40000d75:	c1 e0 18             	shl    $0x18,%eax
40000d78:	c1 e6 10             	shl    $0x10,%esi
40000d7b:	09 f0                	or     %esi,%eax
40000d7d:	c1 e3 08             	shl    $0x8,%ebx
40000d80:	09 d0                	or     %edx,%eax
40000d82:	09 d8                	or     %ebx,%eax
        asm volatile ("cld; rep stosl\n"
40000d84:	fc                   	cld    
40000d85:	f3 ab                	rep stos %eax,%es:(%edi)
    } else
        asm volatile ("cld; rep stosb\n"
                      :: "D" (v), "a" (c), "c" (n)
                      : "cc", "memory");
    return v;
}
40000d87:	89 f8                	mov    %edi,%eax
40000d89:	5b                   	pop    %ebx
40000d8a:	5e                   	pop    %esi
40000d8b:	5f                   	pop    %edi
40000d8c:	c3                   	ret    
40000d8d:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("cld; rep stosb\n"
40000d90:	8b 44 24 14          	mov    0x14(%esp),%eax
40000d94:	fc                   	cld    
40000d95:	f3 aa                	rep stos %al,%es:(%edi)
}
40000d97:	89 f8                	mov    %edi,%eax
40000d99:	5b                   	pop    %ebx
40000d9a:	5e                   	pop    %esi
40000d9b:	5f                   	pop    %edi
40000d9c:	c3                   	ret    
40000d9d:	8d 76 00             	lea    0x0(%esi),%esi

40000da0 <memmove>:

void *memmove(void *dst, const void *src, size_t n)
{
40000da0:	57                   	push   %edi
40000da1:	56                   	push   %esi
40000da2:	8b 44 24 0c          	mov    0xc(%esp),%eax
40000da6:	8b 74 24 10          	mov    0x10(%esp),%esi
40000daa:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
40000dae:	39 c6                	cmp    %eax,%esi
40000db0:	73 26                	jae    40000dd8 <memmove+0x38>
40000db2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
40000db5:	39 c2                	cmp    %eax,%edx
40000db7:	76 1f                	jbe    40000dd8 <memmove+0x38>
        s += n;
        d += n;
40000db9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000dbc:	89 fe                	mov    %edi,%esi
40000dbe:	09 ce                	or     %ecx,%esi
40000dc0:	09 d6                	or     %edx,%esi
40000dc2:	83 e6 03             	and    $0x3,%esi
40000dc5:	74 39                	je     40000e00 <memmove+0x60>
            asm volatile ("std; rep movsl\n"
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
                          : "cc", "memory");
        else
            asm volatile ("std; rep movsb\n"
                          :: "D" (d - 1), "S" (s - 1), "c" (n)
40000dc7:	83 ef 01             	sub    $0x1,%edi
40000dca:	8d 72 ff             	lea    -0x1(%edx),%esi
            asm volatile ("std; rep movsb\n"
40000dcd:	fd                   	std    
40000dce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile ("cld" ::: "cc");
40000dd0:	fc                   	cld    
            asm volatile ("cld; rep movsb\n"
                          :: "D" (d), "S" (s), "c" (n)
                          : "cc", "memory");
    }
    return dst;
}
40000dd1:	5e                   	pop    %esi
40000dd2:	5f                   	pop    %edi
40000dd3:	c3                   	ret    
40000dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000dd8:	89 c2                	mov    %eax,%edx
40000dda:	09 ca                	or     %ecx,%edx
40000ddc:	09 f2                	or     %esi,%edx
40000dde:	83 e2 03             	and    $0x3,%edx
40000de1:	74 0d                	je     40000df0 <memmove+0x50>
            asm volatile ("cld; rep movsb\n"
40000de3:	89 c7                	mov    %eax,%edi
40000de5:	fc                   	cld    
40000de6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000de8:	5e                   	pop    %esi
40000de9:	5f                   	pop    %edi
40000dea:	c3                   	ret    
40000deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000def:	90                   	nop
                          :: "D" (d), "S" (s), "c" (n / 4)
40000df0:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("cld; rep movsl\n"
40000df3:	89 c7                	mov    %eax,%edi
40000df5:	fc                   	cld    
40000df6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000df8:	eb ee                	jmp    40000de8 <memmove+0x48>
40000dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
40000e00:	83 ef 04             	sub    $0x4,%edi
40000e03:	8d 72 fc             	lea    -0x4(%edx),%esi
40000e06:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("std; rep movsl\n"
40000e09:	fd                   	std    
40000e0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000e0c:	eb c2                	jmp    40000dd0 <memmove+0x30>
40000e0e:	66 90                	xchg   %ax,%ax

40000e10 <memcpy>:

void *memcpy(void *dst, const void *src, size_t n)
{
    return memmove(dst, src, n);
40000e10:	eb 8e                	jmp    40000da0 <memmove>
40000e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000e20 <memcmp>:
}

int memcmp(const void *v1, const void *v2, size_t n)
{
40000e20:	56                   	push   %esi
40000e21:	53                   	push   %ebx
40000e22:	8b 74 24 14          	mov    0x14(%esp),%esi
40000e26:	8b 54 24 0c          	mov    0xc(%esp),%edx
40000e2a:	8b 44 24 10          	mov    0x10(%esp),%eax
    const uint8_t *s1 = (const uint8_t *) v1;
    const uint8_t *s2 = (const uint8_t *) v2;

    while (n-- > 0) {
40000e2e:	85 f6                	test   %esi,%esi
40000e30:	74 2e                	je     40000e60 <memcmp+0x40>
40000e32:	01 c6                	add    %eax,%esi
40000e34:	eb 14                	jmp    40000e4a <memcmp+0x2a>
40000e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e3d:	8d 76 00             	lea    0x0(%esi),%esi
        if (*s1 != *s2)
            return (int) *s1 - (int) *s2;
        s1++, s2++;
40000e40:	83 c0 01             	add    $0x1,%eax
40000e43:	83 c2 01             	add    $0x1,%edx
    while (n-- > 0) {
40000e46:	39 f0                	cmp    %esi,%eax
40000e48:	74 16                	je     40000e60 <memcmp+0x40>
        if (*s1 != *s2)
40000e4a:	0f b6 0a             	movzbl (%edx),%ecx
40000e4d:	0f b6 18             	movzbl (%eax),%ebx
40000e50:	38 d9                	cmp    %bl,%cl
40000e52:	74 ec                	je     40000e40 <memcmp+0x20>
            return (int) *s1 - (int) *s2;
40000e54:	0f b6 c1             	movzbl %cl,%eax
40000e57:	29 d8                	sub    %ebx,%eax
    }

    return 0;
}
40000e59:	5b                   	pop    %ebx
40000e5a:	5e                   	pop    %esi
40000e5b:	c3                   	ret    
40000e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
40000e60:	31 c0                	xor    %eax,%eax
}
40000e62:	5b                   	pop    %ebx
40000e63:	5e                   	pop    %esi
40000e64:	c3                   	ret    
40000e65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000e70 <memchr>:

void *memchr(const void *s, int c, size_t n)
{
40000e70:	8b 44 24 04          	mov    0x4(%esp),%eax
    const void *ends = (const char *) s + n;
40000e74:	8b 54 24 0c          	mov    0xc(%esp),%edx
40000e78:	01 c2                	add    %eax,%edx
    for (; s < ends; s++)
40000e7a:	39 d0                	cmp    %edx,%eax
40000e7c:	73 1a                	jae    40000e98 <memchr+0x28>
40000e7e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
40000e83:	eb 0a                	jmp    40000e8f <memchr+0x1f>
40000e85:	8d 76 00             	lea    0x0(%esi),%esi
40000e88:	83 c0 01             	add    $0x1,%eax
40000e8b:	39 c2                	cmp    %eax,%edx
40000e8d:	74 09                	je     40000e98 <memchr+0x28>
        if (*(const unsigned char *) s == (unsigned char) c)
40000e8f:	38 08                	cmp    %cl,(%eax)
40000e91:	75 f5                	jne    40000e88 <memchr+0x18>
            return (void *) s;
    return NULL;
}
40000e93:	c3                   	ret    
40000e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return NULL;
40000e98:	31 c0                	xor    %eax,%eax
}
40000e9a:	c3                   	ret    
40000e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000e9f:	90                   	nop

40000ea0 <memzero>:

void *memzero(void *v, size_t n)
{
    return memset(v, 0, n);
40000ea0:	ff 74 24 08          	pushl  0x8(%esp)
40000ea4:	6a 00                	push   $0x0
40000ea6:	ff 74 24 0c          	pushl  0xc(%esp)
40000eaa:	e8 a1 fe ff ff       	call   40000d50 <memset>
40000eaf:	83 c4 0c             	add    $0xc,%esp
}
40000eb2:	c3                   	ret    
40000eb3:	66 90                	xchg   %ax,%ax
40000eb5:	66 90                	xchg   %ax,%ax
40000eb7:	66 90                	xchg   %ax,%ax
40000eb9:	66 90                	xchg   %ax,%ax
40000ebb:	66 90                	xchg   %ax,%ax
40000ebd:	66 90                	xchg   %ax,%ax
40000ebf:	90                   	nop

40000ec0 <__udivdi3>:
40000ec0:	f3 0f 1e fb          	endbr32 
40000ec4:	55                   	push   %ebp
40000ec5:	57                   	push   %edi
40000ec6:	56                   	push   %esi
40000ec7:	53                   	push   %ebx
40000ec8:	83 ec 1c             	sub    $0x1c,%esp
40000ecb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
40000ecf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
40000ed3:	8b 74 24 34          	mov    0x34(%esp),%esi
40000ed7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
40000edb:	85 d2                	test   %edx,%edx
40000edd:	75 19                	jne    40000ef8 <__udivdi3+0x38>
40000edf:	39 f3                	cmp    %esi,%ebx
40000ee1:	76 4d                	jbe    40000f30 <__udivdi3+0x70>
40000ee3:	31 ff                	xor    %edi,%edi
40000ee5:	89 e8                	mov    %ebp,%eax
40000ee7:	89 f2                	mov    %esi,%edx
40000ee9:	f7 f3                	div    %ebx
40000eeb:	89 fa                	mov    %edi,%edx
40000eed:	83 c4 1c             	add    $0x1c,%esp
40000ef0:	5b                   	pop    %ebx
40000ef1:	5e                   	pop    %esi
40000ef2:	5f                   	pop    %edi
40000ef3:	5d                   	pop    %ebp
40000ef4:	c3                   	ret    
40000ef5:	8d 76 00             	lea    0x0(%esi),%esi
40000ef8:	39 f2                	cmp    %esi,%edx
40000efa:	76 14                	jbe    40000f10 <__udivdi3+0x50>
40000efc:	31 ff                	xor    %edi,%edi
40000efe:	31 c0                	xor    %eax,%eax
40000f00:	89 fa                	mov    %edi,%edx
40000f02:	83 c4 1c             	add    $0x1c,%esp
40000f05:	5b                   	pop    %ebx
40000f06:	5e                   	pop    %esi
40000f07:	5f                   	pop    %edi
40000f08:	5d                   	pop    %ebp
40000f09:	c3                   	ret    
40000f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000f10:	0f bd fa             	bsr    %edx,%edi
40000f13:	83 f7 1f             	xor    $0x1f,%edi
40000f16:	75 48                	jne    40000f60 <__udivdi3+0xa0>
40000f18:	39 f2                	cmp    %esi,%edx
40000f1a:	72 06                	jb     40000f22 <__udivdi3+0x62>
40000f1c:	31 c0                	xor    %eax,%eax
40000f1e:	39 eb                	cmp    %ebp,%ebx
40000f20:	77 de                	ja     40000f00 <__udivdi3+0x40>
40000f22:	b8 01 00 00 00       	mov    $0x1,%eax
40000f27:	eb d7                	jmp    40000f00 <__udivdi3+0x40>
40000f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000f30:	89 d9                	mov    %ebx,%ecx
40000f32:	85 db                	test   %ebx,%ebx
40000f34:	75 0b                	jne    40000f41 <__udivdi3+0x81>
40000f36:	b8 01 00 00 00       	mov    $0x1,%eax
40000f3b:	31 d2                	xor    %edx,%edx
40000f3d:	f7 f3                	div    %ebx
40000f3f:	89 c1                	mov    %eax,%ecx
40000f41:	31 d2                	xor    %edx,%edx
40000f43:	89 f0                	mov    %esi,%eax
40000f45:	f7 f1                	div    %ecx
40000f47:	89 c6                	mov    %eax,%esi
40000f49:	89 e8                	mov    %ebp,%eax
40000f4b:	89 f7                	mov    %esi,%edi
40000f4d:	f7 f1                	div    %ecx
40000f4f:	89 fa                	mov    %edi,%edx
40000f51:	83 c4 1c             	add    $0x1c,%esp
40000f54:	5b                   	pop    %ebx
40000f55:	5e                   	pop    %esi
40000f56:	5f                   	pop    %edi
40000f57:	5d                   	pop    %ebp
40000f58:	c3                   	ret    
40000f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000f60:	89 f9                	mov    %edi,%ecx
40000f62:	b8 20 00 00 00       	mov    $0x20,%eax
40000f67:	29 f8                	sub    %edi,%eax
40000f69:	d3 e2                	shl    %cl,%edx
40000f6b:	89 54 24 08          	mov    %edx,0x8(%esp)
40000f6f:	89 c1                	mov    %eax,%ecx
40000f71:	89 da                	mov    %ebx,%edx
40000f73:	d3 ea                	shr    %cl,%edx
40000f75:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000f79:	09 d1                	or     %edx,%ecx
40000f7b:	89 f2                	mov    %esi,%edx
40000f7d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40000f81:	89 f9                	mov    %edi,%ecx
40000f83:	d3 e3                	shl    %cl,%ebx
40000f85:	89 c1                	mov    %eax,%ecx
40000f87:	d3 ea                	shr    %cl,%edx
40000f89:	89 f9                	mov    %edi,%ecx
40000f8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
40000f8f:	89 eb                	mov    %ebp,%ebx
40000f91:	d3 e6                	shl    %cl,%esi
40000f93:	89 c1                	mov    %eax,%ecx
40000f95:	d3 eb                	shr    %cl,%ebx
40000f97:	09 de                	or     %ebx,%esi
40000f99:	89 f0                	mov    %esi,%eax
40000f9b:	f7 74 24 08          	divl   0x8(%esp)
40000f9f:	89 d6                	mov    %edx,%esi
40000fa1:	89 c3                	mov    %eax,%ebx
40000fa3:	f7 64 24 0c          	mull   0xc(%esp)
40000fa7:	39 d6                	cmp    %edx,%esi
40000fa9:	72 15                	jb     40000fc0 <__udivdi3+0x100>
40000fab:	89 f9                	mov    %edi,%ecx
40000fad:	d3 e5                	shl    %cl,%ebp
40000faf:	39 c5                	cmp    %eax,%ebp
40000fb1:	73 04                	jae    40000fb7 <__udivdi3+0xf7>
40000fb3:	39 d6                	cmp    %edx,%esi
40000fb5:	74 09                	je     40000fc0 <__udivdi3+0x100>
40000fb7:	89 d8                	mov    %ebx,%eax
40000fb9:	31 ff                	xor    %edi,%edi
40000fbb:	e9 40 ff ff ff       	jmp    40000f00 <__udivdi3+0x40>
40000fc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
40000fc3:	31 ff                	xor    %edi,%edi
40000fc5:	e9 36 ff ff ff       	jmp    40000f00 <__udivdi3+0x40>
40000fca:	66 90                	xchg   %ax,%ax
40000fcc:	66 90                	xchg   %ax,%ax
40000fce:	66 90                	xchg   %ax,%ax

40000fd0 <__umoddi3>:
40000fd0:	f3 0f 1e fb          	endbr32 
40000fd4:	55                   	push   %ebp
40000fd5:	57                   	push   %edi
40000fd6:	56                   	push   %esi
40000fd7:	53                   	push   %ebx
40000fd8:	83 ec 1c             	sub    $0x1c,%esp
40000fdb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
40000fdf:	8b 74 24 30          	mov    0x30(%esp),%esi
40000fe3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
40000fe7:	8b 7c 24 38          	mov    0x38(%esp),%edi
40000feb:	85 c0                	test   %eax,%eax
40000fed:	75 19                	jne    40001008 <__umoddi3+0x38>
40000fef:	39 df                	cmp    %ebx,%edi
40000ff1:	76 5d                	jbe    40001050 <__umoddi3+0x80>
40000ff3:	89 f0                	mov    %esi,%eax
40000ff5:	89 da                	mov    %ebx,%edx
40000ff7:	f7 f7                	div    %edi
40000ff9:	89 d0                	mov    %edx,%eax
40000ffb:	31 d2                	xor    %edx,%edx
40000ffd:	83 c4 1c             	add    $0x1c,%esp
40001000:	5b                   	pop    %ebx
40001001:	5e                   	pop    %esi
40001002:	5f                   	pop    %edi
40001003:	5d                   	pop    %ebp
40001004:	c3                   	ret    
40001005:	8d 76 00             	lea    0x0(%esi),%esi
40001008:	89 f2                	mov    %esi,%edx
4000100a:	39 d8                	cmp    %ebx,%eax
4000100c:	76 12                	jbe    40001020 <__umoddi3+0x50>
4000100e:	89 f0                	mov    %esi,%eax
40001010:	89 da                	mov    %ebx,%edx
40001012:	83 c4 1c             	add    $0x1c,%esp
40001015:	5b                   	pop    %ebx
40001016:	5e                   	pop    %esi
40001017:	5f                   	pop    %edi
40001018:	5d                   	pop    %ebp
40001019:	c3                   	ret    
4000101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001020:	0f bd e8             	bsr    %eax,%ebp
40001023:	83 f5 1f             	xor    $0x1f,%ebp
40001026:	75 50                	jne    40001078 <__umoddi3+0xa8>
40001028:	39 d8                	cmp    %ebx,%eax
4000102a:	0f 82 e0 00 00 00    	jb     40001110 <__umoddi3+0x140>
40001030:	89 d9                	mov    %ebx,%ecx
40001032:	39 f7                	cmp    %esi,%edi
40001034:	0f 86 d6 00 00 00    	jbe    40001110 <__umoddi3+0x140>
4000103a:	89 d0                	mov    %edx,%eax
4000103c:	89 ca                	mov    %ecx,%edx
4000103e:	83 c4 1c             	add    $0x1c,%esp
40001041:	5b                   	pop    %ebx
40001042:	5e                   	pop    %esi
40001043:	5f                   	pop    %edi
40001044:	5d                   	pop    %ebp
40001045:	c3                   	ret    
40001046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000104d:	8d 76 00             	lea    0x0(%esi),%esi
40001050:	89 fd                	mov    %edi,%ebp
40001052:	85 ff                	test   %edi,%edi
40001054:	75 0b                	jne    40001061 <__umoddi3+0x91>
40001056:	b8 01 00 00 00       	mov    $0x1,%eax
4000105b:	31 d2                	xor    %edx,%edx
4000105d:	f7 f7                	div    %edi
4000105f:	89 c5                	mov    %eax,%ebp
40001061:	89 d8                	mov    %ebx,%eax
40001063:	31 d2                	xor    %edx,%edx
40001065:	f7 f5                	div    %ebp
40001067:	89 f0                	mov    %esi,%eax
40001069:	f7 f5                	div    %ebp
4000106b:	89 d0                	mov    %edx,%eax
4000106d:	31 d2                	xor    %edx,%edx
4000106f:	eb 8c                	jmp    40000ffd <__umoddi3+0x2d>
40001071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001078:	89 e9                	mov    %ebp,%ecx
4000107a:	ba 20 00 00 00       	mov    $0x20,%edx
4000107f:	29 ea                	sub    %ebp,%edx
40001081:	d3 e0                	shl    %cl,%eax
40001083:	89 44 24 08          	mov    %eax,0x8(%esp)
40001087:	89 d1                	mov    %edx,%ecx
40001089:	89 f8                	mov    %edi,%eax
4000108b:	d3 e8                	shr    %cl,%eax
4000108d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40001091:	89 54 24 04          	mov    %edx,0x4(%esp)
40001095:	8b 54 24 04          	mov    0x4(%esp),%edx
40001099:	09 c1                	or     %eax,%ecx
4000109b:	89 d8                	mov    %ebx,%eax
4000109d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
400010a1:	89 e9                	mov    %ebp,%ecx
400010a3:	d3 e7                	shl    %cl,%edi
400010a5:	89 d1                	mov    %edx,%ecx
400010a7:	d3 e8                	shr    %cl,%eax
400010a9:	89 e9                	mov    %ebp,%ecx
400010ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
400010af:	d3 e3                	shl    %cl,%ebx
400010b1:	89 c7                	mov    %eax,%edi
400010b3:	89 d1                	mov    %edx,%ecx
400010b5:	89 f0                	mov    %esi,%eax
400010b7:	d3 e8                	shr    %cl,%eax
400010b9:	89 e9                	mov    %ebp,%ecx
400010bb:	89 fa                	mov    %edi,%edx
400010bd:	d3 e6                	shl    %cl,%esi
400010bf:	09 d8                	or     %ebx,%eax
400010c1:	f7 74 24 08          	divl   0x8(%esp)
400010c5:	89 d1                	mov    %edx,%ecx
400010c7:	89 f3                	mov    %esi,%ebx
400010c9:	f7 64 24 0c          	mull   0xc(%esp)
400010cd:	89 c6                	mov    %eax,%esi
400010cf:	89 d7                	mov    %edx,%edi
400010d1:	39 d1                	cmp    %edx,%ecx
400010d3:	72 06                	jb     400010db <__umoddi3+0x10b>
400010d5:	75 10                	jne    400010e7 <__umoddi3+0x117>
400010d7:	39 c3                	cmp    %eax,%ebx
400010d9:	73 0c                	jae    400010e7 <__umoddi3+0x117>
400010db:	2b 44 24 0c          	sub    0xc(%esp),%eax
400010df:	1b 54 24 08          	sbb    0x8(%esp),%edx
400010e3:	89 d7                	mov    %edx,%edi
400010e5:	89 c6                	mov    %eax,%esi
400010e7:	89 ca                	mov    %ecx,%edx
400010e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
400010ee:	29 f3                	sub    %esi,%ebx
400010f0:	19 fa                	sbb    %edi,%edx
400010f2:	89 d0                	mov    %edx,%eax
400010f4:	d3 e0                	shl    %cl,%eax
400010f6:	89 e9                	mov    %ebp,%ecx
400010f8:	d3 eb                	shr    %cl,%ebx
400010fa:	d3 ea                	shr    %cl,%edx
400010fc:	09 d8                	or     %ebx,%eax
400010fe:	83 c4 1c             	add    $0x1c,%esp
40001101:	5b                   	pop    %ebx
40001102:	5e                   	pop    %esi
40001103:	5f                   	pop    %edi
40001104:	5d                   	pop    %ebp
40001105:	c3                   	ret    
40001106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000110d:	8d 76 00             	lea    0x0(%esi),%esi
40001110:	29 fe                	sub    %edi,%esi
40001112:	19 c3                	sbb    %eax,%ebx
40001114:	89 f2                	mov    %esi,%edx
40001116:	89 d9                	mov    %ebx,%ecx
40001118:	e9 1d ff ff ff       	jmp    4000103a <__umoddi3+0x6a>
