
obj/user/pingpong/ding:     file format elf32-i386


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
4000000d:	51                   	push   %ecx
4000000e:	83 ec 10             	sub    $0x10,%esp
    printf("ding started.\n");
40000011:	68 94 21 00 40       	push   $0x40002194
40000016:	e8 f5 01 00 00       	call   40000210 <printf>
    return 0;
}
4000001b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
4000001e:	83 c4 10             	add    $0x10,%esp
40000021:	31 c0                	xor    %eax,%eax
40000023:	c9                   	leave  
40000024:	8d 61 fc             	lea    -0x4(%ecx),%esp
40000027:	c3                   	ret    

40000028 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary.
	 */
	testl	$0x0fffffff, %esp
40000028:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
4000002e:	75 04                	jne    40000034 <args_exist>

40000030 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
40000030:	6a 00                	push   $0x0
	pushl	$0
40000032:	6a 00                	push   $0x0

40000034 <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
40000034:	e8 c7 ff ff ff       	call   40000000 <main>

	/* When returning, push the return value on the stack. */
	pushl	%eax
40000039:	50                   	push   %eax

4000003a <spin>:
spin:
	jmp	spin
4000003a:	eb fe                	jmp    4000003a <spin>
4000003c:	66 90                	xchg   %ax,%ax
4000003e:	66 90                	xchg   %ax,%ax

40000040 <debug>:
#include <proc.h>
#include <stdarg.h>
#include <stdio.h>

void debug(const char *file, int line, const char *fmt, ...)
{
40000040:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[D] %s:%d: ", file, line);
40000043:	ff 74 24 18          	pushl  0x18(%esp)
40000047:	ff 74 24 18          	pushl  0x18(%esp)
4000004b:	68 00 20 00 40       	push   $0x40002000
40000050:	e8 bb 01 00 00       	call   40000210 <printf>
    vcprintf(fmt, ap);
40000055:	58                   	pop    %eax
40000056:	5a                   	pop    %edx
40000057:	8d 44 24 24          	lea    0x24(%esp),%eax
4000005b:	50                   	push   %eax
4000005c:	ff 74 24 24          	pushl  0x24(%esp)
40000060:	e8 4b 01 00 00       	call   400001b0 <vcprintf>
    va_end(ap);
}
40000065:	83 c4 1c             	add    $0x1c,%esp
40000068:	c3                   	ret    
40000069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000070 <warn>:

void warn(const char *file, int line, const char *fmt, ...)
{
40000070:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[W] %s:%d: ", file, line);
40000073:	ff 74 24 18          	pushl  0x18(%esp)
40000077:	ff 74 24 18          	pushl  0x18(%esp)
4000007b:	68 0c 20 00 40       	push   $0x4000200c
40000080:	e8 8b 01 00 00       	call   40000210 <printf>
    vcprintf(fmt, ap);
40000085:	58                   	pop    %eax
40000086:	5a                   	pop    %edx
40000087:	8d 44 24 24          	lea    0x24(%esp),%eax
4000008b:	50                   	push   %eax
4000008c:	ff 74 24 24          	pushl  0x24(%esp)
40000090:	e8 1b 01 00 00       	call   400001b0 <vcprintf>
    va_end(ap);
}
40000095:	83 c4 1c             	add    $0x1c,%esp
40000098:	c3                   	ret    
40000099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400000a0 <panic>:

void panic(const char *file, int line, const char *fmt, ...)
{
400000a0:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[P] %s:%d: ", file, line);
400000a3:	ff 74 24 18          	pushl  0x18(%esp)
400000a7:	ff 74 24 18          	pushl  0x18(%esp)
400000ab:	68 18 20 00 40       	push   $0x40002018
400000b0:	e8 5b 01 00 00       	call   40000210 <printf>
    vcprintf(fmt, ap);
400000b5:	58                   	pop    %eax
400000b6:	5a                   	pop    %edx
400000b7:	8d 44 24 24          	lea    0x24(%esp),%eax
400000bb:	50                   	push   %eax
400000bc:	ff 74 24 24          	pushl  0x24(%esp)
400000c0:	e8 eb 00 00 00       	call   400001b0 <vcprintf>
400000c5:	83 c4 10             	add    $0x10,%esp
400000c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400000cf:	90                   	nop
    va_end(ap);

    while (1)
        yield();
400000d0:	e8 6b 08 00 00       	call   40000940 <yield>
    while (1)
400000d5:	eb f9                	jmp    400000d0 <panic+0x30>
400000d7:	66 90                	xchg   %ax,%ax
400000d9:	66 90                	xchg   %ax,%ax
400000db:	66 90                	xchg   %ax,%ax
400000dd:	66 90                	xchg   %ax,%ax
400000df:	90                   	nop

400000e0 <atoi>:
#include <stdlib.h>

int atoi(const char *buf, int *i)
{
400000e0:	55                   	push   %ebp
400000e1:	57                   	push   %edi
400000e2:	56                   	push   %esi
400000e3:	53                   	push   %ebx
400000e4:	8b 74 24 14          	mov    0x14(%esp),%esi
    int loc = 0;
    int numstart = 0;
    int acc = 0;
    int negative = 0;
    if (buf[loc] == '+')
400000e8:	0f be 06             	movsbl (%esi),%eax
400000eb:	3c 2b                	cmp    $0x2b,%al
400000ed:	74 71                	je     40000160 <atoi+0x80>
    int negative = 0;
400000ef:	31 ed                	xor    %ebp,%ebp
    int loc = 0;
400000f1:	31 ff                	xor    %edi,%edi
        loc++;
    else if (buf[loc] == '-') {
400000f3:	3c 2d                	cmp    $0x2d,%al
400000f5:	74 49                	je     40000140 <atoi+0x60>
        negative = 1;
        loc++;
    }
    numstart = loc;
    // no grab the numbers
    while ('0' <= buf[loc] && buf[loc] <= '9') {
400000f7:	8d 50 d0             	lea    -0x30(%eax),%edx
400000fa:	80 fa 09             	cmp    $0x9,%dl
400000fd:	77 57                	ja     40000156 <atoi+0x76>
400000ff:	89 f9                	mov    %edi,%ecx
    int acc = 0;
40000101:	31 d2                	xor    %edx,%edx
40000103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000107:	90                   	nop
        acc = acc * 10 + (buf[loc] - '0');
40000108:	8d 14 92             	lea    (%edx,%edx,4),%edx
        loc++;
4000010b:	83 c1 01             	add    $0x1,%ecx
        acc = acc * 10 + (buf[loc] - '0');
4000010e:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
    while ('0' <= buf[loc] && buf[loc] <= '9') {
40000112:	0f be 04 0e          	movsbl (%esi,%ecx,1),%eax
40000116:	8d 58 d0             	lea    -0x30(%eax),%ebx
40000119:	80 fb 09             	cmp    $0x9,%bl
4000011c:	76 ea                	jbe    40000108 <atoi+0x28>
    }
    if (numstart == loc) {
4000011e:	39 cf                	cmp    %ecx,%edi
40000120:	74 34                	je     40000156 <atoi+0x76>
        // no numbers have actually been scanned
        return 0;
    }
    if (negative)
        acc = -acc;
40000122:	89 d0                	mov    %edx,%eax
40000124:	f7 d8                	neg    %eax
40000126:	85 ed                	test   %ebp,%ebp
40000128:	0f 45 d0             	cmovne %eax,%edx
    *i = acc;
4000012b:	8b 44 24 18          	mov    0x18(%esp),%eax
4000012f:	89 10                	mov    %edx,(%eax)
    return loc;
}
40000131:	89 c8                	mov    %ecx,%eax
40000133:	5b                   	pop    %ebx
40000134:	5e                   	pop    %esi
40000135:	5f                   	pop    %edi
40000136:	5d                   	pop    %ebp
40000137:	c3                   	ret    
40000138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000013f:	90                   	nop
        loc++;
40000140:	0f be 46 01          	movsbl 0x1(%esi),%eax
        negative = 1;
40000144:	bd 01 00 00 00       	mov    $0x1,%ebp
        loc++;
40000149:	bf 01 00 00 00       	mov    $0x1,%edi
    while ('0' <= buf[loc] && buf[loc] <= '9') {
4000014e:	8d 50 d0             	lea    -0x30(%eax),%edx
40000151:	80 fa 09             	cmp    $0x9,%dl
40000154:	76 a9                	jbe    400000ff <atoi+0x1f>
        return 0;
40000156:	31 c9                	xor    %ecx,%ecx
}
40000158:	5b                   	pop    %ebx
40000159:	5e                   	pop    %esi
4000015a:	89 c8                	mov    %ecx,%eax
4000015c:	5f                   	pop    %edi
4000015d:	5d                   	pop    %ebp
4000015e:	c3                   	ret    
4000015f:	90                   	nop
40000160:	0f be 46 01          	movsbl 0x1(%esi),%eax
    int negative = 0;
40000164:	31 ed                	xor    %ebp,%ebp
        loc++;
40000166:	bf 01 00 00 00       	mov    $0x1,%edi
4000016b:	eb 8a                	jmp    400000f7 <atoi+0x17>
4000016d:	66 90                	xchg   %ax,%ax
4000016f:	90                   	nop

40000170 <putch>:
    int cnt;            // total bytes printed so far
    char buf[MAX_BUF];
};

static void putch(int ch, struct printbuf *b)
{
40000170:	53                   	push   %ebx
40000171:	8b 54 24 0c          	mov    0xc(%esp),%edx
    b->buf[b->idx++] = ch;
40000175:	0f b6 5c 24 08       	movzbl 0x8(%esp),%ebx
4000017a:	8b 02                	mov    (%edx),%eax
4000017c:	8d 48 01             	lea    0x1(%eax),%ecx
4000017f:	89 0a                	mov    %ecx,(%edx)
40000181:	88 5c 02 08          	mov    %bl,0x8(%edx,%eax,1)
    if (b->idx == MAX_BUF - 1) {
40000185:	81 f9 ff 01 00 00    	cmp    $0x1ff,%ecx
4000018b:	75 14                	jne    400001a1 <putch+0x31>
        b->buf[b->idx] = 0;
4000018d:	c6 82 07 02 00 00 00 	movb   $0x0,0x207(%edx)
        puts(b->buf, b->idx);
40000194:	8d 5a 08             	lea    0x8(%edx),%ebx

#include "time.h"

static gcc_inline void sys_puts(const char *s, size_t len)
{
    asm volatile ("int %0"
40000197:	31 c0                	xor    %eax,%eax
40000199:	cd 30                	int    $0x30
        b->idx = 0;
4000019b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    }
    b->cnt++;
400001a1:	83 42 04 01          	addl   $0x1,0x4(%edx)
}
400001a5:	5b                   	pop    %ebx
400001a6:	c3                   	ret    
400001a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400001ae:	66 90                	xchg   %ax,%ax

400001b0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap)
{
400001b0:	53                   	push   %ebx
400001b1:	81 ec 18 02 00 00    	sub    $0x218,%esp
    struct printbuf b;

    b.idx = 0;
400001b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
400001be:	00 
    b.cnt = 0;
400001bf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400001c6:	00 
    vprintfmt((void *) putch, &b, fmt, ap);
400001c7:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
400001ce:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
400001d5:	8d 44 24 10          	lea    0x10(%esp),%eax
400001d9:	50                   	push   %eax
400001da:	68 70 01 00 40       	push   $0x40000170
400001df:	e8 3c 01 00 00       	call   40000320 <vprintfmt>

    b.buf[b.idx] = 0;
400001e4:	8b 4c 24 18          	mov    0x18(%esp),%ecx
400001e8:	8d 5c 24 20          	lea    0x20(%esp),%ebx
400001ec:	31 c0                	xor    %eax,%eax
400001ee:	c6 44 0c 20 00       	movb   $0x0,0x20(%esp,%ecx,1)
400001f3:	cd 30                	int    $0x30
    puts(b.buf, b.idx);

    return b.cnt;
}
400001f5:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400001f9:	81 c4 28 02 00 00    	add    $0x228,%esp
400001ff:	5b                   	pop    %ebx
40000200:	c3                   	ret    
40000201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000020f:	90                   	nop

40000210 <printf>:

int printf(const char *fmt, ...)
{
40000210:	83 ec 14             	sub    $0x14,%esp
    va_list ap;
    int cnt;

    va_start(ap, fmt);
    cnt = vcprintf(fmt, ap);
40000213:	8d 44 24 1c          	lea    0x1c(%esp),%eax
40000217:	50                   	push   %eax
40000218:	ff 74 24 1c          	pushl  0x1c(%esp)
4000021c:	e8 8f ff ff ff       	call   400001b0 <vcprintf>
    va_end(ap);

    return cnt;
}
40000221:	83 c4 1c             	add    $0x1c,%esp
40000224:	c3                   	ret    
40000225:	66 90                	xchg   %ax,%ax
40000227:	66 90                	xchg   %ax,%ax
40000229:	66 90                	xchg   %ax,%ax
4000022b:	66 90                	xchg   %ax,%ax
4000022d:	66 90                	xchg   %ax,%ax
4000022f:	90                   	nop

40000230 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
40000230:	55                   	push   %ebp
40000231:	57                   	push   %edi
40000232:	56                   	push   %esi
40000233:	89 d6                	mov    %edx,%esi
40000235:	53                   	push   %ebx
40000236:	89 c3                	mov    %eax,%ebx
40000238:	83 ec 1c             	sub    $0x1c,%esp
4000023b:	8b 54 24 30          	mov    0x30(%esp),%edx
4000023f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
40000243:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
4000024a:	00 
{
4000024b:	8b 44 24 38          	mov    0x38(%esp),%eax
    if (num >= base) {
4000024f:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
{
40000253:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
40000257:	8b 7c 24 40          	mov    0x40(%esp),%edi
4000025b:	83 ed 01             	sub    $0x1,%ebp
    if (num >= base) {
4000025e:	39 c2                	cmp    %eax,%edx
40000260:	1b 4c 24 04          	sbb    0x4(%esp),%ecx
{
40000264:	89 54 24 08          	mov    %edx,0x8(%esp)
    if (num >= base) {
40000268:	89 04 24             	mov    %eax,(%esp)
4000026b:	73 53                	jae    400002c0 <printnum+0x90>
        printnum(putch, putdat, num / base, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (--width > 0)
4000026d:	85 ed                	test   %ebp,%ebp
4000026f:	7e 16                	jle    40000287 <printnum+0x57>
40000271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch(padc, putdat);
40000278:	83 ec 08             	sub    $0x8,%esp
4000027b:	56                   	push   %esi
4000027c:	57                   	push   %edi
4000027d:	ff d3                	call   *%ebx
        while (--width > 0)
4000027f:	83 c4 10             	add    $0x10,%esp
40000282:	83 ed 01             	sub    $0x1,%ebp
40000285:	75 f1                	jne    40000278 <printnum+0x48>
    }

    // then print this (the least significant) digit
    putch("0123456789abcdef"[num % base], putdat);
40000287:	89 74 24 34          	mov    %esi,0x34(%esp)
4000028b:	ff 74 24 04          	pushl  0x4(%esp)
4000028f:	ff 74 24 04          	pushl  0x4(%esp)
40000293:	ff 74 24 14          	pushl  0x14(%esp)
40000297:	ff 74 24 14          	pushl  0x14(%esp)
4000029b:	e8 00 0d 00 00       	call   40000fa0 <__umoddi3>
400002a0:	0f be 80 24 20 00 40 	movsbl 0x40002024(%eax),%eax
400002a7:	89 44 24 40          	mov    %eax,0x40(%esp)
}
400002ab:	83 c4 2c             	add    $0x2c,%esp
    putch("0123456789abcdef"[num % base], putdat);
400002ae:	89 d8                	mov    %ebx,%eax
}
400002b0:	5b                   	pop    %ebx
400002b1:	5e                   	pop    %esi
400002b2:	5f                   	pop    %edi
400002b3:	5d                   	pop    %ebp
    putch("0123456789abcdef"[num % base], putdat);
400002b4:	ff e0                	jmp    *%eax
400002b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400002bd:	8d 76 00             	lea    0x0(%esi),%esi
        printnum(putch, putdat, num / base, base, width - 1, padc);
400002c0:	83 ec 0c             	sub    $0xc,%esp
400002c3:	57                   	push   %edi
400002c4:	55                   	push   %ebp
400002c5:	50                   	push   %eax
400002c6:	83 ec 08             	sub    $0x8,%esp
400002c9:	ff 74 24 24          	pushl  0x24(%esp)
400002cd:	ff 74 24 24          	pushl  0x24(%esp)
400002d1:	ff 74 24 34          	pushl  0x34(%esp)
400002d5:	ff 74 24 34          	pushl  0x34(%esp)
400002d9:	e8 b2 0b 00 00       	call   40000e90 <__udivdi3>
400002de:	83 c4 18             	add    $0x18,%esp
400002e1:	52                   	push   %edx
400002e2:	89 f2                	mov    %esi,%edx
400002e4:	50                   	push   %eax
400002e5:	89 d8                	mov    %ebx,%eax
400002e7:	e8 44 ff ff ff       	call   40000230 <printnum>
400002ec:	83 c4 20             	add    $0x20,%esp
400002ef:	eb 96                	jmp    40000287 <printnum+0x57>
400002f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400002f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400002ff:	90                   	nop

40000300 <sprintputch>:
    char *ebuf;
    int cnt;
};

static void sprintputch(int ch, struct sprintbuf *b)
{
40000300:	8b 44 24 08          	mov    0x8(%esp),%eax
    b->cnt++;
40000304:	83 40 08 01          	addl   $0x1,0x8(%eax)
    if (b->buf < b->ebuf)
40000308:	8b 10                	mov    (%eax),%edx
4000030a:	3b 50 04             	cmp    0x4(%eax),%edx
4000030d:	73 0b                	jae    4000031a <sprintputch+0x1a>
        *b->buf++ = ch;
4000030f:	8d 4a 01             	lea    0x1(%edx),%ecx
40000312:	89 08                	mov    %ecx,(%eax)
40000314:	8b 44 24 04          	mov    0x4(%esp),%eax
40000318:	88 02                	mov    %al,(%edx)
}
4000031a:	c3                   	ret    
4000031b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000031f:	90                   	nop

40000320 <vprintfmt>:
{
40000320:	55                   	push   %ebp
40000321:	57                   	push   %edi
40000322:	56                   	push   %esi
40000323:	53                   	push   %ebx
40000324:	83 ec 2c             	sub    $0x2c,%esp
40000327:	8b 74 24 40          	mov    0x40(%esp),%esi
4000032b:	8b 6c 24 44          	mov    0x44(%esp),%ebp
4000032f:	8b 7c 24 48          	mov    0x48(%esp),%edi
        while ((ch = *(unsigned char *) fmt++) != '%') {
40000333:	0f b6 07             	movzbl (%edi),%eax
40000336:	8d 5f 01             	lea    0x1(%edi),%ebx
40000339:	83 f8 25             	cmp    $0x25,%eax
4000033c:	75 18                	jne    40000356 <vprintfmt+0x36>
4000033e:	eb 28                	jmp    40000368 <vprintfmt+0x48>
            putch(ch, putdat);
40000340:	83 ec 08             	sub    $0x8,%esp
        while ((ch = *(unsigned char *) fmt++) != '%') {
40000343:	83 c3 01             	add    $0x1,%ebx
            putch(ch, putdat);
40000346:	55                   	push   %ebp
40000347:	50                   	push   %eax
40000348:	ff d6                	call   *%esi
        while ((ch = *(unsigned char *) fmt++) != '%') {
4000034a:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
4000034e:	83 c4 10             	add    $0x10,%esp
40000351:	83 f8 25             	cmp    $0x25,%eax
40000354:	74 12                	je     40000368 <vprintfmt+0x48>
            if (ch == '\0')
40000356:	85 c0                	test   %eax,%eax
40000358:	75 e6                	jne    40000340 <vprintfmt+0x20>
}
4000035a:	83 c4 2c             	add    $0x2c,%esp
4000035d:	5b                   	pop    %ebx
4000035e:	5e                   	pop    %esi
4000035f:	5f                   	pop    %edi
40000360:	5d                   	pop    %ebp
40000361:	c3                   	ret    
40000362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        padc = ' ';
40000368:	c6 44 24 10 20       	movb   $0x20,0x10(%esp)
        precision = -1;
4000036d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
        altflag = 0;
40000372:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
40000379:	00 
        width = -1;
4000037a:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
40000381:	ff 
        lflag = 0;
40000382:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
40000389:	00 
        switch (ch = *(unsigned char *) fmt++) {
4000038a:	0f b6 0b             	movzbl (%ebx),%ecx
4000038d:	8d 7b 01             	lea    0x1(%ebx),%edi
40000390:	8d 41 dd             	lea    -0x23(%ecx),%eax
40000393:	3c 55                	cmp    $0x55,%al
40000395:	77 11                	ja     400003a8 <vprintfmt+0x88>
40000397:	0f b6 c0             	movzbl %al,%eax
4000039a:	ff 24 85 3c 20 00 40 	jmp    *0x4000203c(,%eax,4)
400003a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch('%', putdat);
400003a8:	83 ec 08             	sub    $0x8,%esp
            for (fmt--; fmt[-1] != '%'; fmt--)
400003ab:	89 df                	mov    %ebx,%edi
            putch('%', putdat);
400003ad:	55                   	push   %ebp
400003ae:	6a 25                	push   $0x25
400003b0:	ff d6                	call   *%esi
            for (fmt--; fmt[-1] != '%'; fmt--)
400003b2:	83 c4 10             	add    $0x10,%esp
400003b5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
400003b9:	0f 84 74 ff ff ff    	je     40000333 <vprintfmt+0x13>
400003bf:	90                   	nop
400003c0:	83 ef 01             	sub    $0x1,%edi
400003c3:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
400003c7:	75 f7                	jne    400003c0 <vprintfmt+0xa0>
400003c9:	e9 65 ff ff ff       	jmp    40000333 <vprintfmt+0x13>
400003ce:	66 90                	xchg   %ax,%ax
                ch = *fmt;
400003d0:	0f be 43 01          	movsbl 0x1(%ebx),%eax
        switch (ch = *(unsigned char *) fmt++) {
400003d4:	0f b6 d1             	movzbl %cl,%edx
400003d7:	89 fb                	mov    %edi,%ebx
                precision = precision * 10 + ch - '0';
400003d9:	83 ea 30             	sub    $0x30,%edx
                if (ch < '0' || ch > '9')
400003dc:	8d 48 d0             	lea    -0x30(%eax),%ecx
400003df:	83 f9 09             	cmp    $0x9,%ecx
400003e2:	77 19                	ja     400003fd <vprintfmt+0xdd>
400003e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (precision = 0;; ++fmt) {
400003e8:	83 c3 01             	add    $0x1,%ebx
                precision = precision * 10 + ch - '0';
400003eb:	8d 14 92             	lea    (%edx,%edx,4),%edx
400003ee:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
                ch = *fmt;
400003f2:	0f be 03             	movsbl (%ebx),%eax
                if (ch < '0' || ch > '9')
400003f5:	8d 48 d0             	lea    -0x30(%eax),%ecx
400003f8:	83 f9 09             	cmp    $0x9,%ecx
400003fb:	76 eb                	jbe    400003e8 <vprintfmt+0xc8>
            if (width < 0)
400003fd:	8b 7c 24 04          	mov    0x4(%esp),%edi
40000401:	85 ff                	test   %edi,%edi
40000403:	79 85                	jns    4000038a <vprintfmt+0x6a>
                width = precision, precision = -1;
40000405:	89 54 24 04          	mov    %edx,0x4(%esp)
40000409:	ba ff ff ff ff       	mov    $0xffffffff,%edx
4000040e:	e9 77 ff ff ff       	jmp    4000038a <vprintfmt+0x6a>
            altflag = 1;
40000413:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
4000041a:	00 
        switch (ch = *(unsigned char *) fmt++) {
4000041b:	89 fb                	mov    %edi,%ebx
            goto reswitch;
4000041d:	e9 68 ff ff ff       	jmp    4000038a <vprintfmt+0x6a>
            putch(ch, putdat);
40000422:	83 ec 08             	sub    $0x8,%esp
40000425:	55                   	push   %ebp
40000426:	6a 25                	push   $0x25
40000428:	ff d6                	call   *%esi
            break;
4000042a:	83 c4 10             	add    $0x10,%esp
4000042d:	e9 01 ff ff ff       	jmp    40000333 <vprintfmt+0x13>
            precision = va_arg(ap, int);
40000432:	8b 44 24 4c          	mov    0x4c(%esp),%eax
        switch (ch = *(unsigned char *) fmt++) {
40000436:	89 fb                	mov    %edi,%ebx
            precision = va_arg(ap, int);
40000438:	8b 10                	mov    (%eax),%edx
4000043a:	83 c0 04             	add    $0x4,%eax
4000043d:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto process_precision;
40000441:	eb ba                	jmp    400003fd <vprintfmt+0xdd>
            if (width < 0)
40000443:	8b 44 24 04          	mov    0x4(%esp),%eax
40000447:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (ch = *(unsigned char *) fmt++) {
4000044c:	89 fb                	mov    %edi,%ebx
4000044e:	85 c0                	test   %eax,%eax
40000450:	0f 49 c8             	cmovns %eax,%ecx
40000453:	89 4c 24 04          	mov    %ecx,0x4(%esp)
            goto reswitch;
40000457:	e9 2e ff ff ff       	jmp    4000038a <vprintfmt+0x6a>
            putch(va_arg(ap, int), putdat);
4000045c:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000460:	83 ec 08             	sub    $0x8,%esp
40000463:	55                   	push   %ebp
40000464:	8d 58 04             	lea    0x4(%eax),%ebx
40000467:	8b 44 24 58          	mov    0x58(%esp),%eax
4000046b:	ff 30                	pushl  (%eax)
4000046d:	ff d6                	call   *%esi
4000046f:	89 5c 24 5c          	mov    %ebx,0x5c(%esp)
            break;
40000473:	83 c4 10             	add    $0x10,%esp
40000476:	e9 b8 fe ff ff       	jmp    40000333 <vprintfmt+0x13>
        return va_arg(*ap, unsigned long long);
4000047b:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
4000047f:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, unsigned long long);
40000484:	8b 10                	mov    (%eax),%edx
    if (lflag >= 2)
40000486:	0f 8f c1 01 00 00    	jg     4000064d <vprintfmt+0x32d>
        return va_arg(*ap, unsigned long);
4000048c:	83 c0 04             	add    $0x4,%eax
4000048f:	31 c9                	xor    %ecx,%ecx
40000491:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000495:	b8 0a 00 00 00       	mov    $0xa,%eax
4000049a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            printnum(putch, putdat, num, base, width, padc);
400004a0:	83 ec 0c             	sub    $0xc,%esp
400004a3:	0f be 5c 24 1c       	movsbl 0x1c(%esp),%ebx
400004a8:	53                   	push   %ebx
400004a9:	ff 74 24 14          	pushl  0x14(%esp)
400004ad:	50                   	push   %eax
400004ae:	89 f0                	mov    %esi,%eax
400004b0:	51                   	push   %ecx
400004b1:	52                   	push   %edx
400004b2:	89 ea                	mov    %ebp,%edx
400004b4:	e8 77 fd ff ff       	call   40000230 <printnum>
            break;
400004b9:	83 c4 20             	add    $0x20,%esp
400004bc:	e9 72 fe ff ff       	jmp    40000333 <vprintfmt+0x13>
            putch('0', putdat);
400004c1:	83 ec 08             	sub    $0x8,%esp
400004c4:	55                   	push   %ebp
400004c5:	6a 30                	push   $0x30
400004c7:	ff d6                	call   *%esi
            putch('x', putdat);
400004c9:	58                   	pop    %eax
400004ca:	5a                   	pop    %edx
400004cb:	55                   	push   %ebp
400004cc:	6a 78                	push   $0x78
400004ce:	ff d6                	call   *%esi
            num = (unsigned long long)
400004d0:	8b 44 24 5c          	mov    0x5c(%esp),%eax
400004d4:	31 c9                	xor    %ecx,%ecx
            goto number;
400004d6:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)
400004d9:	8b 10                	mov    (%eax),%edx
                (uintptr_t) va_arg(ap, void *);
400004db:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400004df:	83 c0 04             	add    $0x4,%eax
400004e2:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto number;
400004e6:	b8 10 00 00 00       	mov    $0x10,%eax
400004eb:	eb b3                	jmp    400004a0 <vprintfmt+0x180>
        return va_arg(*ap, unsigned long long);
400004ed:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
400004f1:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, unsigned long long);
400004f6:	8b 10                	mov    (%eax),%edx
    if (lflag >= 2)
400004f8:	0f 8f 63 01 00 00    	jg     40000661 <vprintfmt+0x341>
        return va_arg(*ap, unsigned long);
400004fe:	83 c0 04             	add    $0x4,%eax
40000501:	31 c9                	xor    %ecx,%ecx
40000503:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000507:	b8 10 00 00 00       	mov    $0x10,%eax
4000050c:	eb 92                	jmp    400004a0 <vprintfmt+0x180>
    if (lflag >= 2)
4000050e:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, long long);
40000513:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
40000517:	0f 8f 58 01 00 00    	jg     40000675 <vprintfmt+0x355>
        return va_arg(*ap, long);
4000051d:	8b 4c 24 4c          	mov    0x4c(%esp),%ecx
40000521:	83 c0 04             	add    $0x4,%eax
40000524:	8b 11                	mov    (%ecx),%edx
40000526:	89 44 24 4c          	mov    %eax,0x4c(%esp)
4000052a:	89 d3                	mov    %edx,%ebx
4000052c:	89 d1                	mov    %edx,%ecx
4000052e:	c1 fb 1f             	sar    $0x1f,%ebx
            if ((long long) num < 0) {
40000531:	85 db                	test   %ebx,%ebx
40000533:	0f 88 65 01 00 00    	js     4000069e <vprintfmt+0x37e>
            num = getint(&ap, lflag);
40000539:	89 ca                	mov    %ecx,%edx
4000053b:	b8 0a 00 00 00       	mov    $0xa,%eax
40000540:	89 d9                	mov    %ebx,%ecx
40000542:	e9 59 ff ff ff       	jmp    400004a0 <vprintfmt+0x180>
            lflag++;
40000547:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
        switch (ch = *(unsigned char *) fmt++) {
4000054c:	89 fb                	mov    %edi,%ebx
            goto reswitch;
4000054e:	e9 37 fe ff ff       	jmp    4000038a <vprintfmt+0x6a>
            putch('X', putdat);
40000553:	83 ec 08             	sub    $0x8,%esp
40000556:	55                   	push   %ebp
40000557:	6a 58                	push   $0x58
40000559:	ff d6                	call   *%esi
            putch('X', putdat);
4000055b:	59                   	pop    %ecx
4000055c:	5b                   	pop    %ebx
4000055d:	55                   	push   %ebp
4000055e:	6a 58                	push   $0x58
40000560:	ff d6                	call   *%esi
            putch('X', putdat);
40000562:	58                   	pop    %eax
40000563:	5a                   	pop    %edx
40000564:	55                   	push   %ebp
40000565:	6a 58                	push   $0x58
40000567:	ff d6                	call   *%esi
            break;
40000569:	83 c4 10             	add    $0x10,%esp
4000056c:	e9 c2 fd ff ff       	jmp    40000333 <vprintfmt+0x13>
            if ((p = va_arg(ap, char *)) == NULL)
40000571:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000575:	8b 4c 24 04          	mov    0x4(%esp),%ecx
40000579:	83 c0 04             	add    $0x4,%eax
4000057c:	80 7c 24 10 2d       	cmpb   $0x2d,0x10(%esp)
40000581:	89 44 24 14          	mov    %eax,0x14(%esp)
40000585:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000589:	8b 18                	mov    (%eax),%ebx
4000058b:	0f 95 c0             	setne  %al
4000058e:	85 c9                	test   %ecx,%ecx
40000590:	0f 9f c1             	setg   %cl
40000593:	21 c8                	and    %ecx,%eax
40000595:	85 db                	test   %ebx,%ebx
40000597:	0f 84 31 01 00 00    	je     400006ce <vprintfmt+0x3ae>
            if (width > 0 && padc != '-')
4000059d:	8d 4b 01             	lea    0x1(%ebx),%ecx
400005a0:	84 c0                	test   %al,%al
400005a2:	0f 85 5b 01 00 00    	jne    40000703 <vprintfmt+0x3e3>
                 (ch = *p++) != '\0' && (precision < 0
400005a8:	0f be 1b             	movsbl (%ebx),%ebx
400005ab:	89 d8                	mov    %ebx,%eax
            for (;
400005ad:	85 db                	test   %ebx,%ebx
400005af:	74 72                	je     40000623 <vprintfmt+0x303>
400005b1:	89 5c 24 10          	mov    %ebx,0x10(%esp)
400005b5:	89 cb                	mov    %ecx,%ebx
400005b7:	8b 4c 24 10          	mov    0x10(%esp),%ecx
400005bb:	89 74 24 40          	mov    %esi,0x40(%esp)
400005bf:	89 d6                	mov    %edx,%esi
400005c1:	89 7c 24 48          	mov    %edi,0x48(%esp)
400005c5:	8b 7c 24 04          	mov    0x4(%esp),%edi
400005c9:	eb 2a                	jmp    400005f5 <vprintfmt+0x2d5>
400005cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400005cf:	90                   	nop
                if (altflag && (ch < ' ' || ch > '~'))
400005d0:	83 e8 20             	sub    $0x20,%eax
400005d3:	83 f8 5e             	cmp    $0x5e,%eax
400005d6:	76 31                	jbe    40000609 <vprintfmt+0x2e9>
                    putch('?', putdat);
400005d8:	83 ec 08             	sub    $0x8,%esp
400005db:	55                   	push   %ebp
400005dc:	6a 3f                	push   $0x3f
400005de:	ff 54 24 50          	call   *0x50(%esp)
400005e2:	83 c4 10             	add    $0x10,%esp
                 (ch = *p++) != '\0' && (precision < 0
400005e5:	0f be 03             	movsbl (%ebx),%eax
400005e8:	83 c3 01             	add    $0x1,%ebx
                                         || --precision >= 0); width--)
400005eb:	83 ef 01             	sub    $0x1,%edi
                 (ch = *p++) != '\0' && (precision < 0
400005ee:	0f be c8             	movsbl %al,%ecx
            for (;
400005f1:	85 c9                	test   %ecx,%ecx
400005f3:	74 22                	je     40000617 <vprintfmt+0x2f7>
                 (ch = *p++) != '\0' && (precision < 0
400005f5:	85 f6                	test   %esi,%esi
400005f7:	78 08                	js     40000601 <vprintfmt+0x2e1>
                                         || --precision >= 0); width--)
400005f9:	83 ee 01             	sub    $0x1,%esi
400005fc:	83 fe ff             	cmp    $0xffffffff,%esi
400005ff:	74 16                	je     40000617 <vprintfmt+0x2f7>
                if (altflag && (ch < ' ' || ch > '~'))
40000601:	8b 54 24 08          	mov    0x8(%esp),%edx
40000605:	85 d2                	test   %edx,%edx
40000607:	75 c7                	jne    400005d0 <vprintfmt+0x2b0>
                    putch(ch, putdat);
40000609:	83 ec 08             	sub    $0x8,%esp
4000060c:	55                   	push   %ebp
4000060d:	51                   	push   %ecx
4000060e:	ff 54 24 50          	call   *0x50(%esp)
40000612:	83 c4 10             	add    $0x10,%esp
40000615:	eb ce                	jmp    400005e5 <vprintfmt+0x2c5>
40000617:	89 7c 24 04          	mov    %edi,0x4(%esp)
4000061b:	8b 74 24 40          	mov    0x40(%esp),%esi
4000061f:	8b 7c 24 48          	mov    0x48(%esp),%edi
            for (; width > 0; width--)
40000623:	8b 4c 24 04          	mov    0x4(%esp),%ecx
40000627:	8b 5c 24 04          	mov    0x4(%esp),%ebx
4000062b:	85 c9                	test   %ecx,%ecx
4000062d:	7e 11                	jle    40000640 <vprintfmt+0x320>
4000062f:	90                   	nop
                putch(' ', putdat);
40000630:	83 ec 08             	sub    $0x8,%esp
40000633:	55                   	push   %ebp
40000634:	6a 20                	push   $0x20
40000636:	ff d6                	call   *%esi
            for (; width > 0; width--)
40000638:	83 c4 10             	add    $0x10,%esp
4000063b:	83 eb 01             	sub    $0x1,%ebx
4000063e:	75 f0                	jne    40000630 <vprintfmt+0x310>
            if ((p = va_arg(ap, char *)) == NULL)
40000640:	8b 44 24 14          	mov    0x14(%esp),%eax
40000644:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000648:	e9 e6 fc ff ff       	jmp    40000333 <vprintfmt+0x13>
        return va_arg(*ap, unsigned long long);
4000064d:	8b 48 04             	mov    0x4(%eax),%ecx
40000650:	83 c0 08             	add    $0x8,%eax
40000653:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000657:	b8 0a 00 00 00       	mov    $0xa,%eax
4000065c:	e9 3f fe ff ff       	jmp    400004a0 <vprintfmt+0x180>
40000661:	8b 48 04             	mov    0x4(%eax),%ecx
40000664:	83 c0 08             	add    $0x8,%eax
40000667:	89 44 24 4c          	mov    %eax,0x4c(%esp)
4000066b:	b8 10 00 00 00       	mov    $0x10,%eax
40000670:	e9 2b fe ff ff       	jmp    400004a0 <vprintfmt+0x180>
        return va_arg(*ap, long long);
40000675:	8b 08                	mov    (%eax),%ecx
40000677:	8b 58 04             	mov    0x4(%eax),%ebx
4000067a:	83 c0 08             	add    $0x8,%eax
4000067d:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000681:	e9 ab fe ff ff       	jmp    40000531 <vprintfmt+0x211>
            padc = '-';
40000686:	c6 44 24 10 2d       	movb   $0x2d,0x10(%esp)
        switch (ch = *(unsigned char *) fmt++) {
4000068b:	89 fb                	mov    %edi,%ebx
4000068d:	e9 f8 fc ff ff       	jmp    4000038a <vprintfmt+0x6a>
40000692:	c6 44 24 10 30       	movb   $0x30,0x10(%esp)
40000697:	89 fb                	mov    %edi,%ebx
40000699:	e9 ec fc ff ff       	jmp    4000038a <vprintfmt+0x6a>
4000069e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
                putch('-', putdat);
400006a2:	83 ec 08             	sub    $0x8,%esp
400006a5:	89 5c 24 14          	mov    %ebx,0x14(%esp)
400006a9:	55                   	push   %ebp
400006aa:	6a 2d                	push   $0x2d
400006ac:	ff d6                	call   *%esi
                num = -(long long) num;
400006ae:	8b 4c 24 18          	mov    0x18(%esp),%ecx
400006b2:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
400006b6:	b8 0a 00 00 00       	mov    $0xa,%eax
400006bb:	89 ca                	mov    %ecx,%edx
400006bd:	89 d9                	mov    %ebx,%ecx
400006bf:	f7 da                	neg    %edx
400006c1:	83 d1 00             	adc    $0x0,%ecx
400006c4:	83 c4 10             	add    $0x10,%esp
400006c7:	f7 d9                	neg    %ecx
400006c9:	e9 d2 fd ff ff       	jmp    400004a0 <vprintfmt+0x180>
                 (ch = *p++) != '\0' && (precision < 0
400006ce:	bb 28 00 00 00       	mov    $0x28,%ebx
400006d3:	b9 36 20 00 40       	mov    $0x40002036,%ecx
            if (width > 0 && padc != '-')
400006d8:	84 c0                	test   %al,%al
400006da:	0f 85 9d 00 00 00    	jne    4000077d <vprintfmt+0x45d>
400006e0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
                 (ch = *p++) != '\0' && (precision < 0
400006e4:	b8 28 00 00 00       	mov    $0x28,%eax
400006e9:	89 cb                	mov    %ecx,%ebx
400006eb:	b9 28 00 00 00       	mov    $0x28,%ecx
400006f0:	89 74 24 40          	mov    %esi,0x40(%esp)
400006f4:	89 d6                	mov    %edx,%esi
400006f6:	89 7c 24 48          	mov    %edi,0x48(%esp)
400006fa:	8b 7c 24 04          	mov    0x4(%esp),%edi
400006fe:	e9 f2 fe ff ff       	jmp    400005f5 <vprintfmt+0x2d5>
40000703:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
                for (width -= strnlen(p, precision); width > 0; width--)
40000707:	83 ec 08             	sub    $0x8,%esp
4000070a:	52                   	push   %edx
4000070b:	89 54 24 24          	mov    %edx,0x24(%esp)
4000070f:	53                   	push   %ebx
40000710:	e8 eb 02 00 00       	call   40000a00 <strnlen>
40000715:	29 44 24 14          	sub    %eax,0x14(%esp)
40000719:	8b 4c 24 14          	mov    0x14(%esp),%ecx
4000071d:	83 c4 10             	add    $0x10,%esp
40000720:	8b 54 24 18          	mov    0x18(%esp),%edx
40000724:	85 c9                	test   %ecx,%ecx
40000726:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
4000072a:	7e 3e                	jle    4000076a <vprintfmt+0x44a>
4000072c:	0f be 44 24 10       	movsbl 0x10(%esp),%eax
40000731:	89 4c 24 18          	mov    %ecx,0x18(%esp)
40000735:	89 54 24 10          	mov    %edx,0x10(%esp)
40000739:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
4000073d:	8b 5c 24 04          	mov    0x4(%esp),%ebx
40000741:	89 7c 24 48          	mov    %edi,0x48(%esp)
40000745:	89 c7                	mov    %eax,%edi
                    putch(padc, putdat);
40000747:	83 ec 08             	sub    $0x8,%esp
4000074a:	55                   	push   %ebp
4000074b:	57                   	push   %edi
4000074c:	ff d6                	call   *%esi
                for (width -= strnlen(p, precision); width > 0; width--)
4000074e:	83 c4 10             	add    $0x10,%esp
40000751:	83 eb 01             	sub    $0x1,%ebx
40000754:	75 f1                	jne    40000747 <vprintfmt+0x427>
40000756:	8b 54 24 10          	mov    0x10(%esp),%edx
4000075a:	8b 4c 24 18          	mov    0x18(%esp),%ecx
4000075e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
40000762:	8b 7c 24 48          	mov    0x48(%esp),%edi
40000766:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
                 (ch = *p++) != '\0' && (precision < 0
4000076a:	0f be 03             	movsbl (%ebx),%eax
4000076d:	0f be d8             	movsbl %al,%ebx
            for (;
40000770:	85 db                	test   %ebx,%ebx
40000772:	0f 85 39 fe ff ff    	jne    400005b1 <vprintfmt+0x291>
40000778:	e9 c3 fe ff ff       	jmp    40000640 <vprintfmt+0x320>
                for (width -= strnlen(p, precision); width > 0; width--)
4000077d:	83 ec 08             	sub    $0x8,%esp
                p = "(null)";
40000780:	bb 35 20 00 40       	mov    $0x40002035,%ebx
                for (width -= strnlen(p, precision); width > 0; width--)
40000785:	52                   	push   %edx
40000786:	89 54 24 24          	mov    %edx,0x24(%esp)
4000078a:	68 35 20 00 40       	push   $0x40002035
4000078f:	e8 6c 02 00 00       	call   40000a00 <strnlen>
40000794:	29 44 24 14          	sub    %eax,0x14(%esp)
40000798:	8b 44 24 14          	mov    0x14(%esp),%eax
4000079c:	83 c4 10             	add    $0x10,%esp
4000079f:	b9 36 20 00 40       	mov    $0x40002036,%ecx
400007a4:	8b 54 24 18          	mov    0x18(%esp),%edx
400007a8:	85 c0                	test   %eax,%eax
400007aa:	7f 80                	jg     4000072c <vprintfmt+0x40c>
                 (ch = *p++) != '\0' && (precision < 0
400007ac:	bb 28 00 00 00       	mov    $0x28,%ebx
400007b1:	e9 2a ff ff ff       	jmp    400006e0 <vprintfmt+0x3c0>
400007b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400007bd:	8d 76 00             	lea    0x0(%esi),%esi

400007c0 <printfmt>:
{
400007c0:	83 ec 0c             	sub    $0xc,%esp
    vprintfmt(putch, putdat, fmt, ap);
400007c3:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400007c7:	50                   	push   %eax
400007c8:	ff 74 24 1c          	pushl  0x1c(%esp)
400007cc:	ff 74 24 1c          	pushl  0x1c(%esp)
400007d0:	ff 74 24 1c          	pushl  0x1c(%esp)
400007d4:	e8 47 fb ff ff       	call   40000320 <vprintfmt>
}
400007d9:	83 c4 1c             	add    $0x1c,%esp
400007dc:	c3                   	ret    
400007dd:	8d 76 00             	lea    0x0(%esi),%esi

400007e0 <vsprintf>:

int vsprintf(char *buf, const char *fmt, va_list ap)
{
400007e0:	83 ec 1c             	sub    $0x1c,%esp
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
400007e3:	8b 44 24 20          	mov    0x20(%esp),%eax
400007e7:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
400007ee:	ff 
400007ef:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400007f6:	00 
400007f7:	89 44 24 04          	mov    %eax,0x4(%esp)

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
400007fb:	ff 74 24 28          	pushl  0x28(%esp)
400007ff:	ff 74 24 28          	pushl  0x28(%esp)
40000803:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000807:	50                   	push   %eax
40000808:	68 00 03 00 40       	push   $0x40000300
4000080d:	e8 0e fb ff ff       	call   40000320 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
40000812:	8b 44 24 14          	mov    0x14(%esp),%eax
40000816:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
40000819:	8b 44 24 1c          	mov    0x1c(%esp),%eax
4000081d:	83 c4 2c             	add    $0x2c,%esp
40000820:	c3                   	ret    
40000821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000082f:	90                   	nop

40000830 <sprintf>:

int sprintf(char *buf, const char *fmt, ...)
{
40000830:	83 ec 1c             	sub    $0x1c,%esp
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
40000833:	8b 44 24 20          	mov    0x20(%esp),%eax
40000837:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
4000083e:	ff 
4000083f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000846:	00 
40000847:	89 44 24 04          	mov    %eax,0x4(%esp)
    vprintfmt((void *) sprintputch, &b, fmt, ap);
4000084b:	8d 44 24 28          	lea    0x28(%esp),%eax
4000084f:	50                   	push   %eax
40000850:	ff 74 24 28          	pushl  0x28(%esp)
40000854:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000858:	50                   	push   %eax
40000859:	68 00 03 00 40       	push   $0x40000300
4000085e:	e8 bd fa ff ff       	call   40000320 <vprintfmt>
    *b.buf = '\0';
40000863:	8b 44 24 14          	mov    0x14(%esp),%eax
40000867:	c6 00 00             	movb   $0x0,(%eax)
    va_start(ap, fmt);
    rc = vsprintf(buf, fmt, ap);
    va_end(ap);

    return rc;
}
4000086a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
4000086e:	83 c4 2c             	add    $0x2c,%esp
40000871:	c3                   	ret    
40000872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000880 <vsnprintf>:

int vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000880:	83 ec 1c             	sub    $0x1c,%esp
40000883:	8b 44 24 20          	mov    0x20(%esp),%eax
    struct sprintbuf b = { buf, buf + n - 1, 0 };
40000887:	8b 54 24 24          	mov    0x24(%esp),%edx
4000088b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000892:	00 
40000893:	89 44 24 04          	mov    %eax,0x4(%esp)
40000897:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
4000089b:	89 44 24 08          	mov    %eax,0x8(%esp)

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
4000089f:	ff 74 24 2c          	pushl  0x2c(%esp)
400008a3:	ff 74 24 2c          	pushl  0x2c(%esp)
400008a7:	8d 44 24 0c          	lea    0xc(%esp),%eax
400008ab:	50                   	push   %eax
400008ac:	68 00 03 00 40       	push   $0x40000300
400008b1:	e8 6a fa ff ff       	call   40000320 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
400008b6:	8b 44 24 14          	mov    0x14(%esp),%eax
400008ba:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
400008bd:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400008c1:	83 c4 2c             	add    $0x2c,%esp
400008c4:	c3                   	ret    
400008c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400008cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

400008d0 <snprintf>:

int snprintf(char *buf, int n, const char *fmt, ...)
{
400008d0:	83 ec 1c             	sub    $0x1c,%esp
400008d3:	8b 44 24 20          	mov    0x20(%esp),%eax
    struct sprintbuf b = { buf, buf + n - 1, 0 };
400008d7:	8b 54 24 24          	mov    0x24(%esp),%edx
400008db:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400008e2:	00 
400008e3:	89 44 24 04          	mov    %eax,0x4(%esp)
400008e7:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
400008eb:	89 44 24 08          	mov    %eax,0x8(%esp)
    vprintfmt((void *) sprintputch, &b, fmt, ap);
400008ef:	8d 44 24 2c          	lea    0x2c(%esp),%eax
400008f3:	50                   	push   %eax
400008f4:	ff 74 24 2c          	pushl  0x2c(%esp)
400008f8:	8d 44 24 0c          	lea    0xc(%esp),%eax
400008fc:	50                   	push   %eax
400008fd:	68 00 03 00 40       	push   $0x40000300
40000902:	e8 19 fa ff ff       	call   40000320 <vprintfmt>
    *b.buf = '\0';
40000907:	8b 44 24 14          	mov    0x14(%esp),%eax
4000090b:	c6 00 00             	movb   $0x0,(%eax)
    va_start(ap, fmt);
    rc = vsnprintf(buf, n, fmt, ap);
    va_end(ap);

    return rc;
}
4000090e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000912:	83 c4 2c             	add    $0x2c,%esp
40000915:	c3                   	ret    
40000916:	66 90                	xchg   %ax,%ax
40000918:	66 90                	xchg   %ax,%ax
4000091a:	66 90                	xchg   %ax,%ax
4000091c:	66 90                	xchg   %ax,%ax
4000091e:	66 90                	xchg   %ax,%ax

40000920 <spawn>:
#include <proc.h>
#include <syscall.h>
#include <types.h>

pid_t spawn(uintptr_t exec, unsigned int quota)
{
40000920:	53                   	push   %ebx
static gcc_inline pid_t sys_spawn(unsigned int elf_id, unsigned int quota)
{
    int errno;
    pid_t pid;

    asm volatile ("int %2"
40000921:	b8 01 00 00 00       	mov    $0x1,%eax
40000926:	8b 5c 24 08          	mov    0x8(%esp),%ebx
4000092a:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
4000092e:	cd 30                	int    $0x30
                    "a" (SYS_spawn),
                    "b" (elf_id),
                    "c" (quota)
                  : "cc", "memory");

    return errno ? -1 : pid;
40000930:	85 c0                	test   %eax,%eax
40000932:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000937:	0f 44 c3             	cmove  %ebx,%eax
    return sys_spawn(exec, quota);
}
4000093a:	5b                   	pop    %ebx
4000093b:	c3                   	ret    
4000093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000940 <yield>:
}

static gcc_inline void sys_yield(void)
{
    asm volatile ("int %0"
40000940:	b8 02 00 00 00       	mov    $0x2,%eax
40000945:	cd 30                	int    $0x30

void yield(void)
{
    sys_yield();
}
40000947:	c3                   	ret    
40000948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000094f:	90                   	nop

40000950 <produce>:

void produce(unsigned int val)
{
40000950:	53                   	push   %ebx
                  : "cc", "memory");
}

static gcc_inline void sys_produce(unsigned int val)
{
    asm volatile ("int %0"
40000951:	b8 03 00 00 00       	mov    $0x3,%eax
40000956:	8b 5c 24 08          	mov    0x8(%esp),%ebx
4000095a:	cd 30                	int    $0x30
    sys_produce(val);
}
4000095c:	5b                   	pop    %ebx
4000095d:	c3                   	ret    
4000095e:	66 90                	xchg   %ax,%ax

40000960 <consume>:

unsigned int consume(void)
{
40000960:	53                   	push   %ebx
}

static gcc_inline unsigned int sys_consume(void)
{
    unsigned int val;
    asm volatile ("int %1"
40000961:	b8 04 00 00 00       	mov    $0x4,%eax
40000966:	cd 30                	int    $0x30
40000968:	89 d8                	mov    %ebx,%eax
    return sys_consume();
}
4000096a:	5b                   	pop    %ebx
4000096b:	c3                   	ret    
4000096c:	66 90                	xchg   %ax,%ax
4000096e:	66 90                	xchg   %ax,%ax

40000970 <spinlock_init>:
    return result;
}

void spinlock_init(spinlock_t *lk)
{
    *lk = 0;
40000970:	8b 44 24 04          	mov    0x4(%esp),%eax
40000974:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
4000097a:	c3                   	ret    
4000097b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000097f:	90                   	nop

40000980 <spinlock_acquire>:

void spinlock_acquire(spinlock_t *lk)
{
40000980:	8b 54 24 04          	mov    0x4(%esp),%edx
    asm volatile ("lock; xchgl %0, %1"
40000984:	b8 01 00 00 00       	mov    $0x1,%eax
40000989:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
4000098c:	85 c0                	test   %eax,%eax
4000098e:	74 13                	je     400009a3 <spinlock_acquire+0x23>
    asm volatile ("lock; xchgl %0, %1"
40000990:	b9 01 00 00 00       	mov    $0x1,%ecx
40000995:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("pause");
40000998:	f3 90                	pause  
    asm volatile ("lock; xchgl %0, %1"
4000099a:	89 c8                	mov    %ecx,%eax
4000099c:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
4000099f:	85 c0                	test   %eax,%eax
400009a1:	75 f5                	jne    40000998 <spinlock_acquire+0x18>
}
400009a3:	c3                   	ret    
400009a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400009ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400009af:	90                   	nop

400009b0 <spinlock_release>:

// Release the lock.
void spinlock_release(spinlock_t *lk)
{
400009b0:	8b 54 24 04          	mov    0x4(%esp),%edx
}

// Check whether this cpu is holding the lock.
bool spinlock_holding(spinlock_t *lk)
{
    return *lk;
400009b4:	8b 02                	mov    (%edx),%eax
    if (spinlock_holding(lk) == FALSE)
400009b6:	84 c0                	test   %al,%al
400009b8:	74 05                	je     400009bf <spinlock_release+0xf>
    asm volatile ("lock; xchgl %0, %1"
400009ba:	31 c0                	xor    %eax,%eax
400009bc:	f0 87 02             	lock xchg %eax,(%edx)
}
400009bf:	c3                   	ret    

400009c0 <spinlock_holding>:
    return *lk;
400009c0:	8b 44 24 04          	mov    0x4(%esp),%eax
400009c4:	8b 00                	mov    (%eax),%eax
}
400009c6:	c3                   	ret    
400009c7:	66 90                	xchg   %ax,%ax
400009c9:	66 90                	xchg   %ax,%ax
400009cb:	66 90                	xchg   %ax,%ax
400009cd:	66 90                	xchg   %ax,%ax
400009cf:	90                   	nop

400009d0 <strlen>:
#include <string.h>
#include <types.h>

int strlen(const char *s)
{
400009d0:	8b 54 24 04          	mov    0x4(%esp),%edx
    int n;

    for (n = 0; *s != '\0'; s++)
400009d4:	31 c0                	xor    %eax,%eax
400009d6:	80 3a 00             	cmpb   $0x0,(%edx)
400009d9:	74 15                	je     400009f0 <strlen+0x20>
400009db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400009df:	90                   	nop
        n++;
400009e0:	83 c0 01             	add    $0x1,%eax
    for (n = 0; *s != '\0'; s++)
400009e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
400009e7:	75 f7                	jne    400009e0 <strlen+0x10>
400009e9:	c3                   	ret    
400009ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return n;
}
400009f0:	c3                   	ret    
400009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400009f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400009ff:	90                   	nop

40000a00 <strnlen>:

int strnlen(const char *s, size_t size)
{
40000a00:	8b 54 24 08          	mov    0x8(%esp),%edx
40000a04:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a08:	31 c0                	xor    %eax,%eax
40000a0a:	85 d2                	test   %edx,%edx
40000a0c:	75 09                	jne    40000a17 <strnlen+0x17>
40000a0e:	eb 10                	jmp    40000a20 <strnlen+0x20>
        n++;
40000a10:	83 c0 01             	add    $0x1,%eax
    for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a13:	39 d0                	cmp    %edx,%eax
40000a15:	74 09                	je     40000a20 <strnlen+0x20>
40000a17:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000a1b:	75 f3                	jne    40000a10 <strnlen+0x10>
40000a1d:	c3                   	ret    
40000a1e:	66 90                	xchg   %ax,%ax
    return n;
}
40000a20:	c3                   	ret    
40000a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a2f:	90                   	nop

40000a30 <strcpy>:

char *strcpy(char *dst, const char *src)
{
40000a30:	53                   	push   %ebx
40000a31:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    char *ret;

    ret = dst;
    while ((*dst++ = *src++) != '\0')
40000a35:	31 c0                	xor    %eax,%eax
{
40000a37:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
40000a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000a3f:	90                   	nop
    while ((*dst++ = *src++) != '\0')
40000a40:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000a44:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000a47:	83 c0 01             	add    $0x1,%eax
40000a4a:	84 d2                	test   %dl,%dl
40000a4c:	75 f2                	jne    40000a40 <strcpy+0x10>
        /* do nothing */ ;
    return ret;
}
40000a4e:	89 c8                	mov    %ecx,%eax
40000a50:	5b                   	pop    %ebx
40000a51:	c3                   	ret    
40000a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000a60 <strncpy>:

char *strncpy(char *dst, const char *src, size_t size)
{
40000a60:	56                   	push   %esi
40000a61:	53                   	push   %ebx
40000a62:	8b 5c 24 14          	mov    0x14(%esp),%ebx
40000a66:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000a6a:	8b 44 24 10          	mov    0x10(%esp),%eax
    size_t i;
    char *ret;

    ret = dst;
    for (i = 0; i < size; i++) {
40000a6e:	85 db                	test   %ebx,%ebx
40000a70:	74 21                	je     40000a93 <strncpy+0x33>
40000a72:	01 f3                	add    %esi,%ebx
40000a74:	89 f2                	mov    %esi,%edx
40000a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a7d:	8d 76 00             	lea    0x0(%esi),%esi
        *dst++ = *src;
40000a80:	0f b6 08             	movzbl (%eax),%ecx
40000a83:	83 c2 01             	add    $0x1,%edx
40000a86:	88 4a ff             	mov    %cl,-0x1(%edx)
        // If strlen(src) < size, null-pad 'dst' out to 'size' chars
        if (*src != '\0')
            src++;
40000a89:	80 38 01             	cmpb   $0x1,(%eax)
40000a8c:	83 d8 ff             	sbb    $0xffffffff,%eax
    for (i = 0; i < size; i++) {
40000a8f:	39 da                	cmp    %ebx,%edx
40000a91:	75 ed                	jne    40000a80 <strncpy+0x20>
    }
    return ret;
}
40000a93:	89 f0                	mov    %esi,%eax
40000a95:	5b                   	pop    %ebx
40000a96:	5e                   	pop    %esi
40000a97:	c3                   	ret    
40000a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a9f:	90                   	nop

40000aa0 <strlcpy>:

size_t strlcpy(char *dst, const char *src, size_t size)
{
40000aa0:	56                   	push   %esi
40000aa1:	53                   	push   %ebx
40000aa2:	8b 44 24 14          	mov    0x14(%esp),%eax
40000aa6:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000aaa:	8b 4c 24 10          	mov    0x10(%esp),%ecx
    char *dst_in;

    dst_in = dst;
    if (size > 0) {
40000aae:	85 c0                	test   %eax,%eax
40000ab0:	74 29                	je     40000adb <strlcpy+0x3b>
        while (--size > 0 && *src != '\0')
40000ab2:	89 f2                	mov    %esi,%edx
40000ab4:	83 e8 01             	sub    $0x1,%eax
40000ab7:	74 1f                	je     40000ad8 <strlcpy+0x38>
40000ab9:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
40000abc:	eb 0f                	jmp    40000acd <strlcpy+0x2d>
40000abe:	66 90                	xchg   %ax,%ax
            *dst++ = *src++;
40000ac0:	83 c2 01             	add    $0x1,%edx
40000ac3:	83 c1 01             	add    $0x1,%ecx
40000ac6:	88 42 ff             	mov    %al,-0x1(%edx)
        while (--size > 0 && *src != '\0')
40000ac9:	39 da                	cmp    %ebx,%edx
40000acb:	74 07                	je     40000ad4 <strlcpy+0x34>
40000acd:	0f b6 01             	movzbl (%ecx),%eax
40000ad0:	84 c0                	test   %al,%al
40000ad2:	75 ec                	jne    40000ac0 <strlcpy+0x20>
40000ad4:	89 d0                	mov    %edx,%eax
40000ad6:	29 f0                	sub    %esi,%eax
        *dst = '\0';
40000ad8:	c6 02 00             	movb   $0x0,(%edx)
    }
    return dst - dst_in;
}
40000adb:	5b                   	pop    %ebx
40000adc:	5e                   	pop    %esi
40000add:	c3                   	ret    
40000ade:	66 90                	xchg   %ax,%ax

40000ae0 <strcmp>:

int strcmp(const char *p, const char *q)
{
40000ae0:	53                   	push   %ebx
40000ae1:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000ae5:	8b 54 24 0c          	mov    0xc(%esp),%edx
    while (*p && *p == *q)
40000ae9:	0f b6 01             	movzbl (%ecx),%eax
40000aec:	0f b6 1a             	movzbl (%edx),%ebx
40000aef:	84 c0                	test   %al,%al
40000af1:	75 16                	jne    40000b09 <strcmp+0x29>
40000af3:	eb 23                	jmp    40000b18 <strcmp+0x38>
40000af5:	8d 76 00             	lea    0x0(%esi),%esi
40000af8:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        p++, q++;
40000afc:	83 c1 01             	add    $0x1,%ecx
40000aff:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
40000b02:	0f b6 1a             	movzbl (%edx),%ebx
40000b05:	84 c0                	test   %al,%al
40000b07:	74 0f                	je     40000b18 <strcmp+0x38>
40000b09:	38 d8                	cmp    %bl,%al
40000b0b:	74 eb                	je     40000af8 <strcmp+0x18>
    return (int) ((unsigned char) *p - (unsigned char) *q);
40000b0d:	29 d8                	sub    %ebx,%eax
}
40000b0f:	5b                   	pop    %ebx
40000b10:	c3                   	ret    
40000b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b18:	31 c0                	xor    %eax,%eax
    return (int) ((unsigned char) *p - (unsigned char) *q);
40000b1a:	29 d8                	sub    %ebx,%eax
}
40000b1c:	5b                   	pop    %ebx
40000b1d:	c3                   	ret    
40000b1e:	66 90                	xchg   %ax,%ax

40000b20 <strncmp>:

int strncmp(const char *p, const char *q, size_t n)
{
40000b20:	56                   	push   %esi
40000b21:	53                   	push   %ebx
40000b22:	8b 74 24 14          	mov    0x14(%esp),%esi
40000b26:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000b2a:	8b 44 24 10          	mov    0x10(%esp),%eax
    while (n > 0 && *p && *p == *q)
40000b2e:	85 f6                	test   %esi,%esi
40000b30:	74 2e                	je     40000b60 <strncmp+0x40>
40000b32:	01 c6                	add    %eax,%esi
40000b34:	eb 18                	jmp    40000b4e <strncmp+0x2e>
40000b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b3d:	8d 76 00             	lea    0x0(%esi),%esi
40000b40:	38 da                	cmp    %bl,%dl
40000b42:	75 14                	jne    40000b58 <strncmp+0x38>
        n--, p++, q++;
40000b44:	83 c0 01             	add    $0x1,%eax
40000b47:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q)
40000b4a:	39 f0                	cmp    %esi,%eax
40000b4c:	74 12                	je     40000b60 <strncmp+0x40>
40000b4e:	0f b6 11             	movzbl (%ecx),%edx
40000b51:	0f b6 18             	movzbl (%eax),%ebx
40000b54:	84 d2                	test   %dl,%dl
40000b56:	75 e8                	jne    40000b40 <strncmp+0x20>
    if (n == 0)
        return 0;
    else
        return (int) ((unsigned char) *p - (unsigned char) *q);
40000b58:	0f b6 c2             	movzbl %dl,%eax
40000b5b:	29 d8                	sub    %ebx,%eax
}
40000b5d:	5b                   	pop    %ebx
40000b5e:	5e                   	pop    %esi
40000b5f:	c3                   	ret    
        return 0;
40000b60:	31 c0                	xor    %eax,%eax
}
40000b62:	5b                   	pop    %ebx
40000b63:	5e                   	pop    %esi
40000b64:	c3                   	ret    
40000b65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000b70 <strchr>:

char *strchr(const char *s, char c)
{
40000b70:	8b 44 24 04          	mov    0x4(%esp),%eax
40000b74:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
    for (; *s; s++)
40000b79:	0f b6 10             	movzbl (%eax),%edx
40000b7c:	84 d2                	test   %dl,%dl
40000b7e:	75 13                	jne    40000b93 <strchr+0x23>
40000b80:	eb 1e                	jmp    40000ba0 <strchr+0x30>
40000b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000b88:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000b8c:	83 c0 01             	add    $0x1,%eax
40000b8f:	84 d2                	test   %dl,%dl
40000b91:	74 0d                	je     40000ba0 <strchr+0x30>
        if (*s == c)
40000b93:	38 d1                	cmp    %dl,%cl
40000b95:	75 f1                	jne    40000b88 <strchr+0x18>
            return (char *) s;
    return 0;
}
40000b97:	c3                   	ret    
40000b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b9f:	90                   	nop
    return 0;
40000ba0:	31 c0                	xor    %eax,%eax
}
40000ba2:	c3                   	ret    
40000ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000bb0 <strfind>:

char *strfind(const char *s, char c)
{
40000bb0:	53                   	push   %ebx
40000bb1:	8b 44 24 08          	mov    0x8(%esp),%eax
40000bb5:	8b 54 24 0c          	mov    0xc(%esp),%edx
    for (; *s; s++)
40000bb9:	0f b6 18             	movzbl (%eax),%ebx
        if (*s == c)
40000bbc:	38 d3                	cmp    %dl,%bl
40000bbe:	74 1f                	je     40000bdf <strfind+0x2f>
40000bc0:	89 d1                	mov    %edx,%ecx
40000bc2:	84 db                	test   %bl,%bl
40000bc4:	75 0e                	jne    40000bd4 <strfind+0x24>
40000bc6:	eb 17                	jmp    40000bdf <strfind+0x2f>
40000bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bcf:	90                   	nop
40000bd0:	84 d2                	test   %dl,%dl
40000bd2:	74 0b                	je     40000bdf <strfind+0x2f>
    for (; *s; s++)
40000bd4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000bd8:	83 c0 01             	add    $0x1,%eax
        if (*s == c)
40000bdb:	38 ca                	cmp    %cl,%dl
40000bdd:	75 f1                	jne    40000bd0 <strfind+0x20>
            break;
    return (char *) s;
}
40000bdf:	5b                   	pop    %ebx
40000be0:	c3                   	ret    
40000be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bef:	90                   	nop

40000bf0 <strtol>:

long strtol(const char *s, char **endptr, int base)
{
40000bf0:	55                   	push   %ebp
40000bf1:	57                   	push   %edi
40000bf2:	56                   	push   %esi
40000bf3:	53                   	push   %ebx
40000bf4:	83 ec 04             	sub    $0x4,%esp
40000bf7:	8b 44 24 20          	mov    0x20(%esp),%eax
40000bfb:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000bff:	8b 74 24 1c          	mov    0x1c(%esp),%esi
40000c03:	89 04 24             	mov    %eax,(%esp)
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
40000c06:	0f b6 01             	movzbl (%ecx),%eax
40000c09:	3c 09                	cmp    $0x9,%al
40000c0b:	74 0b                	je     40000c18 <strtol+0x28>
40000c0d:	3c 20                	cmp    $0x20,%al
40000c0f:	75 16                	jne    40000c27 <strtol+0x37>
40000c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c18:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        s++;
40000c1c:	83 c1 01             	add    $0x1,%ecx
    while (*s == ' ' || *s == '\t')
40000c1f:	3c 20                	cmp    $0x20,%al
40000c21:	74 f5                	je     40000c18 <strtol+0x28>
40000c23:	3c 09                	cmp    $0x9,%al
40000c25:	74 f1                	je     40000c18 <strtol+0x28>

    // plus/minus sign
    if (*s == '+')
40000c27:	3c 2b                	cmp    $0x2b,%al
40000c29:	0f 84 a1 00 00 00    	je     40000cd0 <strtol+0xe0>
    int neg = 0;
40000c2f:	31 ff                	xor    %edi,%edi
        s++;
    else if (*s == '-')
40000c31:	3c 2d                	cmp    $0x2d,%al
40000c33:	0f 84 87 00 00 00    	je     40000cc0 <strtol+0xd0>
        s++, neg = 1;

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000c39:	0f be 11             	movsbl (%ecx),%edx
40000c3c:	f7 04 24 ef ff ff ff 	testl  $0xffffffef,(%esp)
40000c43:	75 17                	jne    40000c5c <strtol+0x6c>
40000c45:	80 fa 30             	cmp    $0x30,%dl
40000c48:	0f 84 92 00 00 00    	je     40000ce0 <strtol+0xf0>
        s += 2, base = 16;
    else if (base == 0 && s[0] == '0')
40000c4e:	8b 2c 24             	mov    (%esp),%ebp
40000c51:	85 ed                	test   %ebp,%ebp
40000c53:	75 07                	jne    40000c5c <strtol+0x6c>
        s++, base = 8;
    else if (base == 0)
        base = 10;
40000c55:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
40000c5c:	31 c0                	xor    %eax,%eax
40000c5e:	eb 15                	jmp    40000c75 <strtol+0x85>
    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9')
            dig = *s - '0';
40000c60:	83 ea 30             	sub    $0x30,%edx
            dig = *s - 'a' + 10;
        else if (*s >= 'A' && *s <= 'Z')
            dig = *s - 'A' + 10;
        else
            break;
        if (dig >= base)
40000c63:	8b 1c 24             	mov    (%esp),%ebx
40000c66:	39 da                	cmp    %ebx,%edx
40000c68:	7d 29                	jge    40000c93 <strtol+0xa3>
            break;
        s++, val = (val * base) + dig;
40000c6a:	0f af c3             	imul   %ebx,%eax
40000c6d:	83 c1 01             	add    $0x1,%ecx
40000c70:	01 d0                	add    %edx,%eax
    while (1) {
40000c72:	0f be 11             	movsbl (%ecx),%edx
        if (*s >= '0' && *s <= '9')
40000c75:	8d 6a d0             	lea    -0x30(%edx),%ebp
40000c78:	89 eb                	mov    %ebp,%ebx
40000c7a:	80 fb 09             	cmp    $0x9,%bl
40000c7d:	76 e1                	jbe    40000c60 <strtol+0x70>
        else if (*s >= 'a' && *s <= 'z')
40000c7f:	8d 6a 9f             	lea    -0x61(%edx),%ebp
40000c82:	89 eb                	mov    %ebp,%ebx
40000c84:	80 fb 19             	cmp    $0x19,%bl
40000c87:	77 27                	ja     40000cb0 <strtol+0xc0>
        if (dig >= base)
40000c89:	8b 1c 24             	mov    (%esp),%ebx
            dig = *s - 'a' + 10;
40000c8c:	83 ea 57             	sub    $0x57,%edx
        if (dig >= base)
40000c8f:	39 da                	cmp    %ebx,%edx
40000c91:	7c d7                	jl     40000c6a <strtol+0x7a>
        // we don't properly detect overflow!
    }

    if (endptr)
40000c93:	85 f6                	test   %esi,%esi
40000c95:	74 02                	je     40000c99 <strtol+0xa9>
        *endptr = (char *) s;
40000c97:	89 0e                	mov    %ecx,(%esi)
    return (neg ? -val : val);
40000c99:	89 c2                	mov    %eax,%edx
40000c9b:	f7 da                	neg    %edx
40000c9d:	85 ff                	test   %edi,%edi
40000c9f:	0f 45 c2             	cmovne %edx,%eax
}
40000ca2:	83 c4 04             	add    $0x4,%esp
40000ca5:	5b                   	pop    %ebx
40000ca6:	5e                   	pop    %esi
40000ca7:	5f                   	pop    %edi
40000ca8:	5d                   	pop    %ebp
40000ca9:	c3                   	ret    
40000caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        else if (*s >= 'A' && *s <= 'Z')
40000cb0:	8d 6a bf             	lea    -0x41(%edx),%ebp
40000cb3:	89 eb                	mov    %ebp,%ebx
40000cb5:	80 fb 19             	cmp    $0x19,%bl
40000cb8:	77 d9                	ja     40000c93 <strtol+0xa3>
            dig = *s - 'A' + 10;
40000cba:	83 ea 37             	sub    $0x37,%edx
40000cbd:	eb a4                	jmp    40000c63 <strtol+0x73>
40000cbf:	90                   	nop
        s++, neg = 1;
40000cc0:	83 c1 01             	add    $0x1,%ecx
40000cc3:	bf 01 00 00 00       	mov    $0x1,%edi
40000cc8:	e9 6c ff ff ff       	jmp    40000c39 <strtol+0x49>
40000ccd:	8d 76 00             	lea    0x0(%esi),%esi
        s++;
40000cd0:	83 c1 01             	add    $0x1,%ecx
    int neg = 0;
40000cd3:	31 ff                	xor    %edi,%edi
40000cd5:	e9 5f ff ff ff       	jmp    40000c39 <strtol+0x49>
40000cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000ce0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
40000ce4:	3c 78                	cmp    $0x78,%al
40000ce6:	74 1d                	je     40000d05 <strtol+0x115>
    else if (base == 0 && s[0] == '0')
40000ce8:	8b 1c 24             	mov    (%esp),%ebx
40000ceb:	85 db                	test   %ebx,%ebx
40000ced:	0f 85 69 ff ff ff    	jne    40000c5c <strtol+0x6c>
        s++, base = 8;
40000cf3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
40000cfa:	83 c1 01             	add    $0x1,%ecx
40000cfd:	0f be d0             	movsbl %al,%edx
40000d00:	e9 57 ff ff ff       	jmp    40000c5c <strtol+0x6c>
        s += 2, base = 16;
40000d05:	0f be 51 02          	movsbl 0x2(%ecx),%edx
40000d09:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
40000d10:	83 c1 02             	add    $0x2,%ecx
40000d13:	e9 44 ff ff ff       	jmp    40000c5c <strtol+0x6c>
40000d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d1f:	90                   	nop

40000d20 <memset>:

void *memset(void *v, int c, size_t n)
{
40000d20:	57                   	push   %edi
40000d21:	56                   	push   %esi
40000d22:	53                   	push   %ebx
40000d23:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000d27:	8b 7c 24 10          	mov    0x10(%esp),%edi
    if (n == 0)
40000d2b:	85 c9                	test   %ecx,%ecx
40000d2d:	74 28                	je     40000d57 <memset+0x37>
        return v;
    if ((int) v % 4 == 0 && n % 4 == 0) {
40000d2f:	89 f8                	mov    %edi,%eax
40000d31:	09 c8                	or     %ecx,%eax
40000d33:	a8 03                	test   $0x3,%al
40000d35:	75 29                	jne    40000d60 <memset+0x40>
        c &= 0xFF;
40000d37:	0f b6 54 24 14       	movzbl 0x14(%esp),%edx
        c = (c << 24) | (c << 16) | (c << 8) | c;
        asm volatile ("cld; rep stosl\n"
                      :: "D" (v), "a" (c), "c" (n / 4)
40000d3c:	c1 e9 02             	shr    $0x2,%ecx
        c = (c << 24) | (c << 16) | (c << 8) | c;
40000d3f:	89 d0                	mov    %edx,%eax
40000d41:	89 d6                	mov    %edx,%esi
40000d43:	89 d3                	mov    %edx,%ebx
40000d45:	c1 e0 18             	shl    $0x18,%eax
40000d48:	c1 e6 10             	shl    $0x10,%esi
40000d4b:	09 f0                	or     %esi,%eax
40000d4d:	c1 e3 08             	shl    $0x8,%ebx
40000d50:	09 d0                	or     %edx,%eax
40000d52:	09 d8                	or     %ebx,%eax
        asm volatile ("cld; rep stosl\n"
40000d54:	fc                   	cld    
40000d55:	f3 ab                	rep stos %eax,%es:(%edi)
    } else
        asm volatile ("cld; rep stosb\n"
                      :: "D" (v), "a" (c), "c" (n)
                      : "cc", "memory");
    return v;
}
40000d57:	89 f8                	mov    %edi,%eax
40000d59:	5b                   	pop    %ebx
40000d5a:	5e                   	pop    %esi
40000d5b:	5f                   	pop    %edi
40000d5c:	c3                   	ret    
40000d5d:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("cld; rep stosb\n"
40000d60:	8b 44 24 14          	mov    0x14(%esp),%eax
40000d64:	fc                   	cld    
40000d65:	f3 aa                	rep stos %al,%es:(%edi)
}
40000d67:	89 f8                	mov    %edi,%eax
40000d69:	5b                   	pop    %ebx
40000d6a:	5e                   	pop    %esi
40000d6b:	5f                   	pop    %edi
40000d6c:	c3                   	ret    
40000d6d:	8d 76 00             	lea    0x0(%esi),%esi

40000d70 <memmove>:

void *memmove(void *dst, const void *src, size_t n)
{
40000d70:	57                   	push   %edi
40000d71:	56                   	push   %esi
40000d72:	8b 44 24 0c          	mov    0xc(%esp),%eax
40000d76:	8b 74 24 10          	mov    0x10(%esp),%esi
40000d7a:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
40000d7e:	39 c6                	cmp    %eax,%esi
40000d80:	73 26                	jae    40000da8 <memmove+0x38>
40000d82:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
40000d85:	39 c2                	cmp    %eax,%edx
40000d87:	76 1f                	jbe    40000da8 <memmove+0x38>
        s += n;
        d += n;
40000d89:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000d8c:	89 fe                	mov    %edi,%esi
40000d8e:	09 ce                	or     %ecx,%esi
40000d90:	09 d6                	or     %edx,%esi
40000d92:	83 e6 03             	and    $0x3,%esi
40000d95:	74 39                	je     40000dd0 <memmove+0x60>
            asm volatile ("std; rep movsl\n"
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
                          : "cc", "memory");
        else
            asm volatile ("std; rep movsb\n"
                          :: "D" (d - 1), "S" (s - 1), "c" (n)
40000d97:	83 ef 01             	sub    $0x1,%edi
40000d9a:	8d 72 ff             	lea    -0x1(%edx),%esi
            asm volatile ("std; rep movsb\n"
40000d9d:	fd                   	std    
40000d9e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile ("cld" ::: "cc");
40000da0:	fc                   	cld    
            asm volatile ("cld; rep movsb\n"
                          :: "D" (d), "S" (s), "c" (n)
                          : "cc", "memory");
    }
    return dst;
}
40000da1:	5e                   	pop    %esi
40000da2:	5f                   	pop    %edi
40000da3:	c3                   	ret    
40000da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000da8:	89 c2                	mov    %eax,%edx
40000daa:	09 ca                	or     %ecx,%edx
40000dac:	09 f2                	or     %esi,%edx
40000dae:	83 e2 03             	and    $0x3,%edx
40000db1:	74 0d                	je     40000dc0 <memmove+0x50>
            asm volatile ("cld; rep movsb\n"
40000db3:	89 c7                	mov    %eax,%edi
40000db5:	fc                   	cld    
40000db6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000db8:	5e                   	pop    %esi
40000db9:	5f                   	pop    %edi
40000dba:	c3                   	ret    
40000dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000dbf:	90                   	nop
                          :: "D" (d), "S" (s), "c" (n / 4)
40000dc0:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("cld; rep movsl\n"
40000dc3:	89 c7                	mov    %eax,%edi
40000dc5:	fc                   	cld    
40000dc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000dc8:	eb ee                	jmp    40000db8 <memmove+0x48>
40000dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
40000dd0:	83 ef 04             	sub    $0x4,%edi
40000dd3:	8d 72 fc             	lea    -0x4(%edx),%esi
40000dd6:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("std; rep movsl\n"
40000dd9:	fd                   	std    
40000dda:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000ddc:	eb c2                	jmp    40000da0 <memmove+0x30>
40000dde:	66 90                	xchg   %ax,%ax

40000de0 <memcpy>:

void *memcpy(void *dst, const void *src, size_t n)
{
    return memmove(dst, src, n);
40000de0:	eb 8e                	jmp    40000d70 <memmove>
40000de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000df0 <memcmp>:
}

int memcmp(const void *v1, const void *v2, size_t n)
{
40000df0:	56                   	push   %esi
40000df1:	53                   	push   %ebx
40000df2:	8b 74 24 14          	mov    0x14(%esp),%esi
40000df6:	8b 54 24 0c          	mov    0xc(%esp),%edx
40000dfa:	8b 44 24 10          	mov    0x10(%esp),%eax
    const uint8_t *s1 = (const uint8_t *) v1;
    const uint8_t *s2 = (const uint8_t *) v2;

    while (n-- > 0) {
40000dfe:	85 f6                	test   %esi,%esi
40000e00:	74 2e                	je     40000e30 <memcmp+0x40>
40000e02:	01 c6                	add    %eax,%esi
40000e04:	eb 14                	jmp    40000e1a <memcmp+0x2a>
40000e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e0d:	8d 76 00             	lea    0x0(%esi),%esi
        if (*s1 != *s2)
            return (int) *s1 - (int) *s2;
        s1++, s2++;
40000e10:	83 c0 01             	add    $0x1,%eax
40000e13:	83 c2 01             	add    $0x1,%edx
    while (n-- > 0) {
40000e16:	39 f0                	cmp    %esi,%eax
40000e18:	74 16                	je     40000e30 <memcmp+0x40>
        if (*s1 != *s2)
40000e1a:	0f b6 0a             	movzbl (%edx),%ecx
40000e1d:	0f b6 18             	movzbl (%eax),%ebx
40000e20:	38 d9                	cmp    %bl,%cl
40000e22:	74 ec                	je     40000e10 <memcmp+0x20>
            return (int) *s1 - (int) *s2;
40000e24:	0f b6 c1             	movzbl %cl,%eax
40000e27:	29 d8                	sub    %ebx,%eax
    }

    return 0;
}
40000e29:	5b                   	pop    %ebx
40000e2a:	5e                   	pop    %esi
40000e2b:	c3                   	ret    
40000e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
40000e30:	31 c0                	xor    %eax,%eax
}
40000e32:	5b                   	pop    %ebx
40000e33:	5e                   	pop    %esi
40000e34:	c3                   	ret    
40000e35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000e40 <memchr>:

void *memchr(const void *s, int c, size_t n)
{
40000e40:	8b 44 24 04          	mov    0x4(%esp),%eax
    const void *ends = (const char *) s + n;
40000e44:	8b 54 24 0c          	mov    0xc(%esp),%edx
40000e48:	01 c2                	add    %eax,%edx
    for (; s < ends; s++)
40000e4a:	39 d0                	cmp    %edx,%eax
40000e4c:	73 1a                	jae    40000e68 <memchr+0x28>
40000e4e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
40000e53:	eb 0a                	jmp    40000e5f <memchr+0x1f>
40000e55:	8d 76 00             	lea    0x0(%esi),%esi
40000e58:	83 c0 01             	add    $0x1,%eax
40000e5b:	39 c2                	cmp    %eax,%edx
40000e5d:	74 09                	je     40000e68 <memchr+0x28>
        if (*(const unsigned char *) s == (unsigned char) c)
40000e5f:	38 08                	cmp    %cl,(%eax)
40000e61:	75 f5                	jne    40000e58 <memchr+0x18>
            return (void *) s;
    return NULL;
}
40000e63:	c3                   	ret    
40000e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return NULL;
40000e68:	31 c0                	xor    %eax,%eax
}
40000e6a:	c3                   	ret    
40000e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000e6f:	90                   	nop

40000e70 <memzero>:

void *memzero(void *v, size_t n)
{
    return memset(v, 0, n);
40000e70:	ff 74 24 08          	pushl  0x8(%esp)
40000e74:	6a 00                	push   $0x0
40000e76:	ff 74 24 0c          	pushl  0xc(%esp)
40000e7a:	e8 a1 fe ff ff       	call   40000d20 <memset>
40000e7f:	83 c4 0c             	add    $0xc,%esp
}
40000e82:	c3                   	ret    
40000e83:	66 90                	xchg   %ax,%ax
40000e85:	66 90                	xchg   %ax,%ax
40000e87:	66 90                	xchg   %ax,%ax
40000e89:	66 90                	xchg   %ax,%ax
40000e8b:	66 90                	xchg   %ax,%ax
40000e8d:	66 90                	xchg   %ax,%ax
40000e8f:	90                   	nop

40000e90 <__udivdi3>:
40000e90:	f3 0f 1e fb          	endbr32 
40000e94:	55                   	push   %ebp
40000e95:	57                   	push   %edi
40000e96:	56                   	push   %esi
40000e97:	53                   	push   %ebx
40000e98:	83 ec 1c             	sub    $0x1c,%esp
40000e9b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
40000e9f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
40000ea3:	8b 74 24 34          	mov    0x34(%esp),%esi
40000ea7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
40000eab:	85 d2                	test   %edx,%edx
40000ead:	75 19                	jne    40000ec8 <__udivdi3+0x38>
40000eaf:	39 f3                	cmp    %esi,%ebx
40000eb1:	76 4d                	jbe    40000f00 <__udivdi3+0x70>
40000eb3:	31 ff                	xor    %edi,%edi
40000eb5:	89 e8                	mov    %ebp,%eax
40000eb7:	89 f2                	mov    %esi,%edx
40000eb9:	f7 f3                	div    %ebx
40000ebb:	89 fa                	mov    %edi,%edx
40000ebd:	83 c4 1c             	add    $0x1c,%esp
40000ec0:	5b                   	pop    %ebx
40000ec1:	5e                   	pop    %esi
40000ec2:	5f                   	pop    %edi
40000ec3:	5d                   	pop    %ebp
40000ec4:	c3                   	ret    
40000ec5:	8d 76 00             	lea    0x0(%esi),%esi
40000ec8:	39 f2                	cmp    %esi,%edx
40000eca:	76 14                	jbe    40000ee0 <__udivdi3+0x50>
40000ecc:	31 ff                	xor    %edi,%edi
40000ece:	31 c0                	xor    %eax,%eax
40000ed0:	89 fa                	mov    %edi,%edx
40000ed2:	83 c4 1c             	add    $0x1c,%esp
40000ed5:	5b                   	pop    %ebx
40000ed6:	5e                   	pop    %esi
40000ed7:	5f                   	pop    %edi
40000ed8:	5d                   	pop    %ebp
40000ed9:	c3                   	ret    
40000eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000ee0:	0f bd fa             	bsr    %edx,%edi
40000ee3:	83 f7 1f             	xor    $0x1f,%edi
40000ee6:	75 48                	jne    40000f30 <__udivdi3+0xa0>
40000ee8:	39 f2                	cmp    %esi,%edx
40000eea:	72 06                	jb     40000ef2 <__udivdi3+0x62>
40000eec:	31 c0                	xor    %eax,%eax
40000eee:	39 eb                	cmp    %ebp,%ebx
40000ef0:	77 de                	ja     40000ed0 <__udivdi3+0x40>
40000ef2:	b8 01 00 00 00       	mov    $0x1,%eax
40000ef7:	eb d7                	jmp    40000ed0 <__udivdi3+0x40>
40000ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000f00:	89 d9                	mov    %ebx,%ecx
40000f02:	85 db                	test   %ebx,%ebx
40000f04:	75 0b                	jne    40000f11 <__udivdi3+0x81>
40000f06:	b8 01 00 00 00       	mov    $0x1,%eax
40000f0b:	31 d2                	xor    %edx,%edx
40000f0d:	f7 f3                	div    %ebx
40000f0f:	89 c1                	mov    %eax,%ecx
40000f11:	31 d2                	xor    %edx,%edx
40000f13:	89 f0                	mov    %esi,%eax
40000f15:	f7 f1                	div    %ecx
40000f17:	89 c6                	mov    %eax,%esi
40000f19:	89 e8                	mov    %ebp,%eax
40000f1b:	89 f7                	mov    %esi,%edi
40000f1d:	f7 f1                	div    %ecx
40000f1f:	89 fa                	mov    %edi,%edx
40000f21:	83 c4 1c             	add    $0x1c,%esp
40000f24:	5b                   	pop    %ebx
40000f25:	5e                   	pop    %esi
40000f26:	5f                   	pop    %edi
40000f27:	5d                   	pop    %ebp
40000f28:	c3                   	ret    
40000f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000f30:	89 f9                	mov    %edi,%ecx
40000f32:	b8 20 00 00 00       	mov    $0x20,%eax
40000f37:	29 f8                	sub    %edi,%eax
40000f39:	d3 e2                	shl    %cl,%edx
40000f3b:	89 54 24 08          	mov    %edx,0x8(%esp)
40000f3f:	89 c1                	mov    %eax,%ecx
40000f41:	89 da                	mov    %ebx,%edx
40000f43:	d3 ea                	shr    %cl,%edx
40000f45:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000f49:	09 d1                	or     %edx,%ecx
40000f4b:	89 f2                	mov    %esi,%edx
40000f4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40000f51:	89 f9                	mov    %edi,%ecx
40000f53:	d3 e3                	shl    %cl,%ebx
40000f55:	89 c1                	mov    %eax,%ecx
40000f57:	d3 ea                	shr    %cl,%edx
40000f59:	89 f9                	mov    %edi,%ecx
40000f5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
40000f5f:	89 eb                	mov    %ebp,%ebx
40000f61:	d3 e6                	shl    %cl,%esi
40000f63:	89 c1                	mov    %eax,%ecx
40000f65:	d3 eb                	shr    %cl,%ebx
40000f67:	09 de                	or     %ebx,%esi
40000f69:	89 f0                	mov    %esi,%eax
40000f6b:	f7 74 24 08          	divl   0x8(%esp)
40000f6f:	89 d6                	mov    %edx,%esi
40000f71:	89 c3                	mov    %eax,%ebx
40000f73:	f7 64 24 0c          	mull   0xc(%esp)
40000f77:	39 d6                	cmp    %edx,%esi
40000f79:	72 15                	jb     40000f90 <__udivdi3+0x100>
40000f7b:	89 f9                	mov    %edi,%ecx
40000f7d:	d3 e5                	shl    %cl,%ebp
40000f7f:	39 c5                	cmp    %eax,%ebp
40000f81:	73 04                	jae    40000f87 <__udivdi3+0xf7>
40000f83:	39 d6                	cmp    %edx,%esi
40000f85:	74 09                	je     40000f90 <__udivdi3+0x100>
40000f87:	89 d8                	mov    %ebx,%eax
40000f89:	31 ff                	xor    %edi,%edi
40000f8b:	e9 40 ff ff ff       	jmp    40000ed0 <__udivdi3+0x40>
40000f90:	8d 43 ff             	lea    -0x1(%ebx),%eax
40000f93:	31 ff                	xor    %edi,%edi
40000f95:	e9 36 ff ff ff       	jmp    40000ed0 <__udivdi3+0x40>
40000f9a:	66 90                	xchg   %ax,%ax
40000f9c:	66 90                	xchg   %ax,%ax
40000f9e:	66 90                	xchg   %ax,%ax

40000fa0 <__umoddi3>:
40000fa0:	f3 0f 1e fb          	endbr32 
40000fa4:	55                   	push   %ebp
40000fa5:	57                   	push   %edi
40000fa6:	56                   	push   %esi
40000fa7:	53                   	push   %ebx
40000fa8:	83 ec 1c             	sub    $0x1c,%esp
40000fab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
40000faf:	8b 74 24 30          	mov    0x30(%esp),%esi
40000fb3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
40000fb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
40000fbb:	85 c0                	test   %eax,%eax
40000fbd:	75 19                	jne    40000fd8 <__umoddi3+0x38>
40000fbf:	39 df                	cmp    %ebx,%edi
40000fc1:	76 5d                	jbe    40001020 <__umoddi3+0x80>
40000fc3:	89 f0                	mov    %esi,%eax
40000fc5:	89 da                	mov    %ebx,%edx
40000fc7:	f7 f7                	div    %edi
40000fc9:	89 d0                	mov    %edx,%eax
40000fcb:	31 d2                	xor    %edx,%edx
40000fcd:	83 c4 1c             	add    $0x1c,%esp
40000fd0:	5b                   	pop    %ebx
40000fd1:	5e                   	pop    %esi
40000fd2:	5f                   	pop    %edi
40000fd3:	5d                   	pop    %ebp
40000fd4:	c3                   	ret    
40000fd5:	8d 76 00             	lea    0x0(%esi),%esi
40000fd8:	89 f2                	mov    %esi,%edx
40000fda:	39 d8                	cmp    %ebx,%eax
40000fdc:	76 12                	jbe    40000ff0 <__umoddi3+0x50>
40000fde:	89 f0                	mov    %esi,%eax
40000fe0:	89 da                	mov    %ebx,%edx
40000fe2:	83 c4 1c             	add    $0x1c,%esp
40000fe5:	5b                   	pop    %ebx
40000fe6:	5e                   	pop    %esi
40000fe7:	5f                   	pop    %edi
40000fe8:	5d                   	pop    %ebp
40000fe9:	c3                   	ret    
40000fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000ff0:	0f bd e8             	bsr    %eax,%ebp
40000ff3:	83 f5 1f             	xor    $0x1f,%ebp
40000ff6:	75 50                	jne    40001048 <__umoddi3+0xa8>
40000ff8:	39 d8                	cmp    %ebx,%eax
40000ffa:	0f 82 e0 00 00 00    	jb     400010e0 <__umoddi3+0x140>
40001000:	89 d9                	mov    %ebx,%ecx
40001002:	39 f7                	cmp    %esi,%edi
40001004:	0f 86 d6 00 00 00    	jbe    400010e0 <__umoddi3+0x140>
4000100a:	89 d0                	mov    %edx,%eax
4000100c:	89 ca                	mov    %ecx,%edx
4000100e:	83 c4 1c             	add    $0x1c,%esp
40001011:	5b                   	pop    %ebx
40001012:	5e                   	pop    %esi
40001013:	5f                   	pop    %edi
40001014:	5d                   	pop    %ebp
40001015:	c3                   	ret    
40001016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000101d:	8d 76 00             	lea    0x0(%esi),%esi
40001020:	89 fd                	mov    %edi,%ebp
40001022:	85 ff                	test   %edi,%edi
40001024:	75 0b                	jne    40001031 <__umoddi3+0x91>
40001026:	b8 01 00 00 00       	mov    $0x1,%eax
4000102b:	31 d2                	xor    %edx,%edx
4000102d:	f7 f7                	div    %edi
4000102f:	89 c5                	mov    %eax,%ebp
40001031:	89 d8                	mov    %ebx,%eax
40001033:	31 d2                	xor    %edx,%edx
40001035:	f7 f5                	div    %ebp
40001037:	89 f0                	mov    %esi,%eax
40001039:	f7 f5                	div    %ebp
4000103b:	89 d0                	mov    %edx,%eax
4000103d:	31 d2                	xor    %edx,%edx
4000103f:	eb 8c                	jmp    40000fcd <__umoddi3+0x2d>
40001041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001048:	89 e9                	mov    %ebp,%ecx
4000104a:	ba 20 00 00 00       	mov    $0x20,%edx
4000104f:	29 ea                	sub    %ebp,%edx
40001051:	d3 e0                	shl    %cl,%eax
40001053:	89 44 24 08          	mov    %eax,0x8(%esp)
40001057:	89 d1                	mov    %edx,%ecx
40001059:	89 f8                	mov    %edi,%eax
4000105b:	d3 e8                	shr    %cl,%eax
4000105d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40001061:	89 54 24 04          	mov    %edx,0x4(%esp)
40001065:	8b 54 24 04          	mov    0x4(%esp),%edx
40001069:	09 c1                	or     %eax,%ecx
4000106b:	89 d8                	mov    %ebx,%eax
4000106d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40001071:	89 e9                	mov    %ebp,%ecx
40001073:	d3 e7                	shl    %cl,%edi
40001075:	89 d1                	mov    %edx,%ecx
40001077:	d3 e8                	shr    %cl,%eax
40001079:	89 e9                	mov    %ebp,%ecx
4000107b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
4000107f:	d3 e3                	shl    %cl,%ebx
40001081:	89 c7                	mov    %eax,%edi
40001083:	89 d1                	mov    %edx,%ecx
40001085:	89 f0                	mov    %esi,%eax
40001087:	d3 e8                	shr    %cl,%eax
40001089:	89 e9                	mov    %ebp,%ecx
4000108b:	89 fa                	mov    %edi,%edx
4000108d:	d3 e6                	shl    %cl,%esi
4000108f:	09 d8                	or     %ebx,%eax
40001091:	f7 74 24 08          	divl   0x8(%esp)
40001095:	89 d1                	mov    %edx,%ecx
40001097:	89 f3                	mov    %esi,%ebx
40001099:	f7 64 24 0c          	mull   0xc(%esp)
4000109d:	89 c6                	mov    %eax,%esi
4000109f:	89 d7                	mov    %edx,%edi
400010a1:	39 d1                	cmp    %edx,%ecx
400010a3:	72 06                	jb     400010ab <__umoddi3+0x10b>
400010a5:	75 10                	jne    400010b7 <__umoddi3+0x117>
400010a7:	39 c3                	cmp    %eax,%ebx
400010a9:	73 0c                	jae    400010b7 <__umoddi3+0x117>
400010ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
400010af:	1b 54 24 08          	sbb    0x8(%esp),%edx
400010b3:	89 d7                	mov    %edx,%edi
400010b5:	89 c6                	mov    %eax,%esi
400010b7:	89 ca                	mov    %ecx,%edx
400010b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
400010be:	29 f3                	sub    %esi,%ebx
400010c0:	19 fa                	sbb    %edi,%edx
400010c2:	89 d0                	mov    %edx,%eax
400010c4:	d3 e0                	shl    %cl,%eax
400010c6:	89 e9                	mov    %ebp,%ecx
400010c8:	d3 eb                	shr    %cl,%ebx
400010ca:	d3 ea                	shr    %cl,%edx
400010cc:	09 d8                	or     %ebx,%eax
400010ce:	83 c4 1c             	add    $0x1c,%esp
400010d1:	5b                   	pop    %ebx
400010d2:	5e                   	pop    %esi
400010d3:	5f                   	pop    %edi
400010d4:	5d                   	pop    %ebp
400010d5:	c3                   	ret    
400010d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400010dd:	8d 76 00             	lea    0x0(%esi),%esi
400010e0:	29 fe                	sub    %edi,%esi
400010e2:	19 c3                	sbb    %eax,%ebx
400010e4:	89 f2                	mov    %esi,%edx
400010e6:	89 d9                	mov    %ebx,%ecx
400010e8:	e9 1d ff ff ff       	jmp    4000100a <__umoddi3+0x6a>
