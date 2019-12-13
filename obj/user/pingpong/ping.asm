
obj/user/pingpong/ping:     file format elf32-i386


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
    printf("ping started.\n");

    // fast producing
    for (i = 0; i < 10; i++)
4000000e:	31 db                	xor    %ebx,%ebx
{
40000010:	51                   	push   %ecx
    printf("ping started.\n");
40000011:	83 ec 0c             	sub    $0xc,%esp
40000014:	68 94 21 00 40       	push   $0x40002194
40000019:	e8 42 02 00 00       	call   40000260 <printf>
4000001e:	83 c4 10             	add    $0x10,%esp
40000021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        produce(i);
40000028:	83 ec 0c             	sub    $0xc,%esp
4000002b:	53                   	push   %ebx
    for (i = 0; i < 10; i++)
4000002c:	83 c3 01             	add    $0x1,%ebx
        produce(i);
4000002f:	e8 6c 09 00 00       	call   400009a0 <produce>
    for (i = 0; i < 10; i++)
40000034:	83 c4 10             	add    $0x10,%esp
40000037:	83 fb 0a             	cmp    $0xa,%ebx
4000003a:	75 ec                	jne    40000028 <main+0x28>

    // slow producing
    for (i = 0; i < 40; i++) {
4000003c:	31 db                	xor    %ebx,%ebx
4000003e:	eb 08                	jmp    40000048 <main+0x48>
40000040:	83 c3 01             	add    $0x1,%ebx
40000043:	83 fb 28             	cmp    $0x28,%ebx
40000046:	74 1e                	je     40000066 <main+0x66>
        if (i % 4 == 0)
40000048:	f6 c3 03             	test   $0x3,%bl
4000004b:	75 f3                	jne    40000040 <main+0x40>
            produce(10 * i);
4000004d:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
40000050:	83 ec 0c             	sub    $0xc,%esp
    for (i = 0; i < 40; i++) {
40000053:	83 c3 01             	add    $0x1,%ebx
            produce(10 * i);
40000056:	01 c0                	add    %eax,%eax
40000058:	50                   	push   %eax
40000059:	e8 42 09 00 00       	call   400009a0 <produce>
4000005e:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 40; i++) {
40000061:	83 fb 28             	cmp    $0x28,%ebx
40000064:	75 e2                	jne    40000048 <main+0x48>
    }

    return 0;
}
40000066:	8d 65 f8             	lea    -0x8(%ebp),%esp
40000069:	31 c0                	xor    %eax,%eax
4000006b:	59                   	pop    %ecx
4000006c:	5b                   	pop    %ebx
4000006d:	5d                   	pop    %ebp
4000006e:	8d 61 fc             	lea    -0x4(%ecx),%esp
40000071:	c3                   	ret    

40000072 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary.
	 */
	testl	$0x0fffffff, %esp
40000072:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
40000078:	75 04                	jne    4000007e <args_exist>

4000007a <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
4000007a:	6a 00                	push   $0x0
	pushl	$0
4000007c:	6a 00                	push   $0x0

4000007e <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
4000007e:	e8 7d ff ff ff       	call   40000000 <main>

	/* When returning, push the return value on the stack. */
	pushl	%eax
40000083:	50                   	push   %eax

40000084 <spin>:
spin:
	jmp	spin
40000084:	eb fe                	jmp    40000084 <spin>
40000086:	66 90                	xchg   %ax,%ax
40000088:	66 90                	xchg   %ax,%ax
4000008a:	66 90                	xchg   %ax,%ax
4000008c:	66 90                	xchg   %ax,%ax
4000008e:	66 90                	xchg   %ax,%ax

40000090 <debug>:
#include <proc.h>
#include <stdarg.h>
#include <stdio.h>

void debug(const char *file, int line, const char *fmt, ...)
{
40000090:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[D] %s:%d: ", file, line);
40000093:	ff 74 24 18          	pushl  0x18(%esp)
40000097:	ff 74 24 18          	pushl  0x18(%esp)
4000009b:	68 00 20 00 40       	push   $0x40002000
400000a0:	e8 bb 01 00 00       	call   40000260 <printf>
    vcprintf(fmt, ap);
400000a5:	58                   	pop    %eax
400000a6:	5a                   	pop    %edx
400000a7:	8d 44 24 24          	lea    0x24(%esp),%eax
400000ab:	50                   	push   %eax
400000ac:	ff 74 24 24          	pushl  0x24(%esp)
400000b0:	e8 4b 01 00 00       	call   40000200 <vcprintf>
    va_end(ap);
}
400000b5:	83 c4 1c             	add    $0x1c,%esp
400000b8:	c3                   	ret    
400000b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400000c0 <warn>:

void warn(const char *file, int line, const char *fmt, ...)
{
400000c0:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[W] %s:%d: ", file, line);
400000c3:	ff 74 24 18          	pushl  0x18(%esp)
400000c7:	ff 74 24 18          	pushl  0x18(%esp)
400000cb:	68 0c 20 00 40       	push   $0x4000200c
400000d0:	e8 8b 01 00 00       	call   40000260 <printf>
    vcprintf(fmt, ap);
400000d5:	58                   	pop    %eax
400000d6:	5a                   	pop    %edx
400000d7:	8d 44 24 24          	lea    0x24(%esp),%eax
400000db:	50                   	push   %eax
400000dc:	ff 74 24 24          	pushl  0x24(%esp)
400000e0:	e8 1b 01 00 00       	call   40000200 <vcprintf>
    va_end(ap);
}
400000e5:	83 c4 1c             	add    $0x1c,%esp
400000e8:	c3                   	ret    
400000e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400000f0 <panic>:

void panic(const char *file, int line, const char *fmt, ...)
{
400000f0:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[P] %s:%d: ", file, line);
400000f3:	ff 74 24 18          	pushl  0x18(%esp)
400000f7:	ff 74 24 18          	pushl  0x18(%esp)
400000fb:	68 18 20 00 40       	push   $0x40002018
40000100:	e8 5b 01 00 00       	call   40000260 <printf>
    vcprintf(fmt, ap);
40000105:	58                   	pop    %eax
40000106:	5a                   	pop    %edx
40000107:	8d 44 24 24          	lea    0x24(%esp),%eax
4000010b:	50                   	push   %eax
4000010c:	ff 74 24 24          	pushl  0x24(%esp)
40000110:	e8 eb 00 00 00       	call   40000200 <vcprintf>
40000115:	83 c4 10             	add    $0x10,%esp
40000118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000011f:	90                   	nop
    va_end(ap);

    while (1)
        yield();
40000120:	e8 6b 08 00 00       	call   40000990 <yield>
    while (1)
40000125:	eb f9                	jmp    40000120 <panic+0x30>
40000127:	66 90                	xchg   %ax,%ax
40000129:	66 90                	xchg   %ax,%ax
4000012b:	66 90                	xchg   %ax,%ax
4000012d:	66 90                	xchg   %ax,%ax
4000012f:	90                   	nop

40000130 <atoi>:
#include <stdlib.h>

int atoi(const char *buf, int *i)
{
40000130:	55                   	push   %ebp
40000131:	57                   	push   %edi
40000132:	56                   	push   %esi
40000133:	53                   	push   %ebx
40000134:	8b 74 24 14          	mov    0x14(%esp),%esi
    int loc = 0;
    int numstart = 0;
    int acc = 0;
    int negative = 0;
    if (buf[loc] == '+')
40000138:	0f be 06             	movsbl (%esi),%eax
4000013b:	3c 2b                	cmp    $0x2b,%al
4000013d:	74 71                	je     400001b0 <atoi+0x80>
    int negative = 0;
4000013f:	31 ed                	xor    %ebp,%ebp
    int loc = 0;
40000141:	31 ff                	xor    %edi,%edi
        loc++;
    else if (buf[loc] == '-') {
40000143:	3c 2d                	cmp    $0x2d,%al
40000145:	74 49                	je     40000190 <atoi+0x60>
        negative = 1;
        loc++;
    }
    numstart = loc;
    // no grab the numbers
    while ('0' <= buf[loc] && buf[loc] <= '9') {
40000147:	8d 50 d0             	lea    -0x30(%eax),%edx
4000014a:	80 fa 09             	cmp    $0x9,%dl
4000014d:	77 57                	ja     400001a6 <atoi+0x76>
4000014f:	89 f9                	mov    %edi,%ecx
    int acc = 0;
40000151:	31 d2                	xor    %edx,%edx
40000153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000157:	90                   	nop
        acc = acc * 10 + (buf[loc] - '0');
40000158:	8d 14 92             	lea    (%edx,%edx,4),%edx
        loc++;
4000015b:	83 c1 01             	add    $0x1,%ecx
        acc = acc * 10 + (buf[loc] - '0');
4000015e:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
    while ('0' <= buf[loc] && buf[loc] <= '9') {
40000162:	0f be 04 0e          	movsbl (%esi,%ecx,1),%eax
40000166:	8d 58 d0             	lea    -0x30(%eax),%ebx
40000169:	80 fb 09             	cmp    $0x9,%bl
4000016c:	76 ea                	jbe    40000158 <atoi+0x28>
    }
    if (numstart == loc) {
4000016e:	39 cf                	cmp    %ecx,%edi
40000170:	74 34                	je     400001a6 <atoi+0x76>
        // no numbers have actually been scanned
        return 0;
    }
    if (negative)
        acc = -acc;
40000172:	89 d0                	mov    %edx,%eax
40000174:	f7 d8                	neg    %eax
40000176:	85 ed                	test   %ebp,%ebp
40000178:	0f 45 d0             	cmovne %eax,%edx
    *i = acc;
4000017b:	8b 44 24 18          	mov    0x18(%esp),%eax
4000017f:	89 10                	mov    %edx,(%eax)
    return loc;
}
40000181:	89 c8                	mov    %ecx,%eax
40000183:	5b                   	pop    %ebx
40000184:	5e                   	pop    %esi
40000185:	5f                   	pop    %edi
40000186:	5d                   	pop    %ebp
40000187:	c3                   	ret    
40000188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000018f:	90                   	nop
        loc++;
40000190:	0f be 46 01          	movsbl 0x1(%esi),%eax
        negative = 1;
40000194:	bd 01 00 00 00       	mov    $0x1,%ebp
        loc++;
40000199:	bf 01 00 00 00       	mov    $0x1,%edi
    while ('0' <= buf[loc] && buf[loc] <= '9') {
4000019e:	8d 50 d0             	lea    -0x30(%eax),%edx
400001a1:	80 fa 09             	cmp    $0x9,%dl
400001a4:	76 a9                	jbe    4000014f <atoi+0x1f>
        return 0;
400001a6:	31 c9                	xor    %ecx,%ecx
}
400001a8:	5b                   	pop    %ebx
400001a9:	5e                   	pop    %esi
400001aa:	89 c8                	mov    %ecx,%eax
400001ac:	5f                   	pop    %edi
400001ad:	5d                   	pop    %ebp
400001ae:	c3                   	ret    
400001af:	90                   	nop
400001b0:	0f be 46 01          	movsbl 0x1(%esi),%eax
    int negative = 0;
400001b4:	31 ed                	xor    %ebp,%ebp
        loc++;
400001b6:	bf 01 00 00 00       	mov    $0x1,%edi
400001bb:	eb 8a                	jmp    40000147 <atoi+0x17>
400001bd:	66 90                	xchg   %ax,%ax
400001bf:	90                   	nop

400001c0 <putch>:
    int cnt;            // total bytes printed so far
    char buf[MAX_BUF];
};

static void putch(int ch, struct printbuf *b)
{
400001c0:	53                   	push   %ebx
400001c1:	8b 54 24 0c          	mov    0xc(%esp),%edx
    b->buf[b->idx++] = ch;
400001c5:	0f b6 5c 24 08       	movzbl 0x8(%esp),%ebx
400001ca:	8b 02                	mov    (%edx),%eax
400001cc:	8d 48 01             	lea    0x1(%eax),%ecx
400001cf:	89 0a                	mov    %ecx,(%edx)
400001d1:	88 5c 02 08          	mov    %bl,0x8(%edx,%eax,1)
    if (b->idx == MAX_BUF - 1) {
400001d5:	81 f9 ff 01 00 00    	cmp    $0x1ff,%ecx
400001db:	75 14                	jne    400001f1 <putch+0x31>
        b->buf[b->idx] = 0;
400001dd:	c6 82 07 02 00 00 00 	movb   $0x0,0x207(%edx)
        puts(b->buf, b->idx);
400001e4:	8d 5a 08             	lea    0x8(%edx),%ebx

#include "time.h"

static gcc_inline void sys_puts(const char *s, size_t len)
{
    asm volatile ("int %0"
400001e7:	31 c0                	xor    %eax,%eax
400001e9:	cd 30                	int    $0x30
        b->idx = 0;
400001eb:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    }
    b->cnt++;
400001f1:	83 42 04 01          	addl   $0x1,0x4(%edx)
}
400001f5:	5b                   	pop    %ebx
400001f6:	c3                   	ret    
400001f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400001fe:	66 90                	xchg   %ax,%ax

40000200 <vcprintf>:

int vcprintf(const char *fmt, va_list ap)
{
40000200:	53                   	push   %ebx
40000201:	81 ec 18 02 00 00    	sub    $0x218,%esp
    struct printbuf b;

    b.idx = 0;
40000207:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
4000020e:	00 
    b.cnt = 0;
4000020f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000216:	00 
    vprintfmt((void *) putch, &b, fmt, ap);
40000217:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
4000021e:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
40000225:	8d 44 24 10          	lea    0x10(%esp),%eax
40000229:	50                   	push   %eax
4000022a:	68 c0 01 00 40       	push   $0x400001c0
4000022f:	e8 3c 01 00 00       	call   40000370 <vprintfmt>

    b.buf[b.idx] = 0;
40000234:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000238:	8d 5c 24 20          	lea    0x20(%esp),%ebx
4000023c:	31 c0                	xor    %eax,%eax
4000023e:	c6 44 0c 20 00       	movb   $0x0,0x20(%esp,%ecx,1)
40000243:	cd 30                	int    $0x30
    puts(b.buf, b.idx);

    return b.cnt;
}
40000245:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000249:	81 c4 28 02 00 00    	add    $0x228,%esp
4000024f:	5b                   	pop    %ebx
40000250:	c3                   	ret    
40000251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000025f:	90                   	nop

40000260 <printf>:

int printf(const char *fmt, ...)
{
40000260:	83 ec 14             	sub    $0x14,%esp
    va_list ap;
    int cnt;

    va_start(ap, fmt);
    cnt = vcprintf(fmt, ap);
40000263:	8d 44 24 1c          	lea    0x1c(%esp),%eax
40000267:	50                   	push   %eax
40000268:	ff 74 24 1c          	pushl  0x1c(%esp)
4000026c:	e8 8f ff ff ff       	call   40000200 <vcprintf>
    va_end(ap);

    return cnt;
}
40000271:	83 c4 1c             	add    $0x1c,%esp
40000274:	c3                   	ret    
40000275:	66 90                	xchg   %ax,%ax
40000277:	66 90                	xchg   %ax,%ax
40000279:	66 90                	xchg   %ax,%ax
4000027b:	66 90                	xchg   %ax,%ax
4000027d:	66 90                	xchg   %ax,%ax
4000027f:	90                   	nop

40000280 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
40000280:	55                   	push   %ebp
40000281:	57                   	push   %edi
40000282:	56                   	push   %esi
40000283:	89 d6                	mov    %edx,%esi
40000285:	53                   	push   %ebx
40000286:	89 c3                	mov    %eax,%ebx
40000288:	83 ec 1c             	sub    $0x1c,%esp
4000028b:	8b 54 24 30          	mov    0x30(%esp),%edx
4000028f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
40000293:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
4000029a:	00 
{
4000029b:	8b 44 24 38          	mov    0x38(%esp),%eax
    if (num >= base) {
4000029f:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
{
400002a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
400002a7:	8b 7c 24 40          	mov    0x40(%esp),%edi
400002ab:	83 ed 01             	sub    $0x1,%ebp
    if (num >= base) {
400002ae:	39 c2                	cmp    %eax,%edx
400002b0:	1b 4c 24 04          	sbb    0x4(%esp),%ecx
{
400002b4:	89 54 24 08          	mov    %edx,0x8(%esp)
    if (num >= base) {
400002b8:	89 04 24             	mov    %eax,(%esp)
400002bb:	73 53                	jae    40000310 <printnum+0x90>
        printnum(putch, putdat, num / base, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (--width > 0)
400002bd:	85 ed                	test   %ebp,%ebp
400002bf:	7e 16                	jle    400002d7 <printnum+0x57>
400002c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch(padc, putdat);
400002c8:	83 ec 08             	sub    $0x8,%esp
400002cb:	56                   	push   %esi
400002cc:	57                   	push   %edi
400002cd:	ff d3                	call   *%ebx
        while (--width > 0)
400002cf:	83 c4 10             	add    $0x10,%esp
400002d2:	83 ed 01             	sub    $0x1,%ebp
400002d5:	75 f1                	jne    400002c8 <printnum+0x48>
    }

    // then print this (the least significant) digit
    putch("0123456789abcdef"[num % base], putdat);
400002d7:	89 74 24 34          	mov    %esi,0x34(%esp)
400002db:	ff 74 24 04          	pushl  0x4(%esp)
400002df:	ff 74 24 04          	pushl  0x4(%esp)
400002e3:	ff 74 24 14          	pushl  0x14(%esp)
400002e7:	ff 74 24 14          	pushl  0x14(%esp)
400002eb:	e8 00 0d 00 00       	call   40000ff0 <__umoddi3>
400002f0:	0f be 80 24 20 00 40 	movsbl 0x40002024(%eax),%eax
400002f7:	89 44 24 40          	mov    %eax,0x40(%esp)
}
400002fb:	83 c4 2c             	add    $0x2c,%esp
    putch("0123456789abcdef"[num % base], putdat);
400002fe:	89 d8                	mov    %ebx,%eax
}
40000300:	5b                   	pop    %ebx
40000301:	5e                   	pop    %esi
40000302:	5f                   	pop    %edi
40000303:	5d                   	pop    %ebp
    putch("0123456789abcdef"[num % base], putdat);
40000304:	ff e0                	jmp    *%eax
40000306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000030d:	8d 76 00             	lea    0x0(%esi),%esi
        printnum(putch, putdat, num / base, base, width - 1, padc);
40000310:	83 ec 0c             	sub    $0xc,%esp
40000313:	57                   	push   %edi
40000314:	55                   	push   %ebp
40000315:	50                   	push   %eax
40000316:	83 ec 08             	sub    $0x8,%esp
40000319:	ff 74 24 24          	pushl  0x24(%esp)
4000031d:	ff 74 24 24          	pushl  0x24(%esp)
40000321:	ff 74 24 34          	pushl  0x34(%esp)
40000325:	ff 74 24 34          	pushl  0x34(%esp)
40000329:	e8 b2 0b 00 00       	call   40000ee0 <__udivdi3>
4000032e:	83 c4 18             	add    $0x18,%esp
40000331:	52                   	push   %edx
40000332:	89 f2                	mov    %esi,%edx
40000334:	50                   	push   %eax
40000335:	89 d8                	mov    %ebx,%eax
40000337:	e8 44 ff ff ff       	call   40000280 <printnum>
4000033c:	83 c4 20             	add    $0x20,%esp
4000033f:	eb 96                	jmp    400002d7 <printnum+0x57>
40000341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000034f:	90                   	nop

40000350 <sprintputch>:
    char *ebuf;
    int cnt;
};

static void sprintputch(int ch, struct sprintbuf *b)
{
40000350:	8b 44 24 08          	mov    0x8(%esp),%eax
    b->cnt++;
40000354:	83 40 08 01          	addl   $0x1,0x8(%eax)
    if (b->buf < b->ebuf)
40000358:	8b 10                	mov    (%eax),%edx
4000035a:	3b 50 04             	cmp    0x4(%eax),%edx
4000035d:	73 0b                	jae    4000036a <sprintputch+0x1a>
        *b->buf++ = ch;
4000035f:	8d 4a 01             	lea    0x1(%edx),%ecx
40000362:	89 08                	mov    %ecx,(%eax)
40000364:	8b 44 24 04          	mov    0x4(%esp),%eax
40000368:	88 02                	mov    %al,(%edx)
}
4000036a:	c3                   	ret    
4000036b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000036f:	90                   	nop

40000370 <vprintfmt>:
{
40000370:	55                   	push   %ebp
40000371:	57                   	push   %edi
40000372:	56                   	push   %esi
40000373:	53                   	push   %ebx
40000374:	83 ec 2c             	sub    $0x2c,%esp
40000377:	8b 74 24 40          	mov    0x40(%esp),%esi
4000037b:	8b 6c 24 44          	mov    0x44(%esp),%ebp
4000037f:	8b 7c 24 48          	mov    0x48(%esp),%edi
        while ((ch = *(unsigned char *) fmt++) != '%') {
40000383:	0f b6 07             	movzbl (%edi),%eax
40000386:	8d 5f 01             	lea    0x1(%edi),%ebx
40000389:	83 f8 25             	cmp    $0x25,%eax
4000038c:	75 18                	jne    400003a6 <vprintfmt+0x36>
4000038e:	eb 28                	jmp    400003b8 <vprintfmt+0x48>
            putch(ch, putdat);
40000390:	83 ec 08             	sub    $0x8,%esp
        while ((ch = *(unsigned char *) fmt++) != '%') {
40000393:	83 c3 01             	add    $0x1,%ebx
            putch(ch, putdat);
40000396:	55                   	push   %ebp
40000397:	50                   	push   %eax
40000398:	ff d6                	call   *%esi
        while ((ch = *(unsigned char *) fmt++) != '%') {
4000039a:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
4000039e:	83 c4 10             	add    $0x10,%esp
400003a1:	83 f8 25             	cmp    $0x25,%eax
400003a4:	74 12                	je     400003b8 <vprintfmt+0x48>
            if (ch == '\0')
400003a6:	85 c0                	test   %eax,%eax
400003a8:	75 e6                	jne    40000390 <vprintfmt+0x20>
}
400003aa:	83 c4 2c             	add    $0x2c,%esp
400003ad:	5b                   	pop    %ebx
400003ae:	5e                   	pop    %esi
400003af:	5f                   	pop    %edi
400003b0:	5d                   	pop    %ebp
400003b1:	c3                   	ret    
400003b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        padc = ' ';
400003b8:	c6 44 24 10 20       	movb   $0x20,0x10(%esp)
        precision = -1;
400003bd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
        altflag = 0;
400003c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
400003c9:	00 
        width = -1;
400003ca:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
400003d1:	ff 
        lflag = 0;
400003d2:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
400003d9:	00 
        switch (ch = *(unsigned char *) fmt++) {
400003da:	0f b6 0b             	movzbl (%ebx),%ecx
400003dd:	8d 7b 01             	lea    0x1(%ebx),%edi
400003e0:	8d 41 dd             	lea    -0x23(%ecx),%eax
400003e3:	3c 55                	cmp    $0x55,%al
400003e5:	77 11                	ja     400003f8 <vprintfmt+0x88>
400003e7:	0f b6 c0             	movzbl %al,%eax
400003ea:	ff 24 85 3c 20 00 40 	jmp    *0x4000203c(,%eax,4)
400003f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch('%', putdat);
400003f8:	83 ec 08             	sub    $0x8,%esp
            for (fmt--; fmt[-1] != '%'; fmt--)
400003fb:	89 df                	mov    %ebx,%edi
            putch('%', putdat);
400003fd:	55                   	push   %ebp
400003fe:	6a 25                	push   $0x25
40000400:	ff d6                	call   *%esi
            for (fmt--; fmt[-1] != '%'; fmt--)
40000402:	83 c4 10             	add    $0x10,%esp
40000405:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
40000409:	0f 84 74 ff ff ff    	je     40000383 <vprintfmt+0x13>
4000040f:	90                   	nop
40000410:	83 ef 01             	sub    $0x1,%edi
40000413:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
40000417:	75 f7                	jne    40000410 <vprintfmt+0xa0>
40000419:	e9 65 ff ff ff       	jmp    40000383 <vprintfmt+0x13>
4000041e:	66 90                	xchg   %ax,%ax
                ch = *fmt;
40000420:	0f be 43 01          	movsbl 0x1(%ebx),%eax
        switch (ch = *(unsigned char *) fmt++) {
40000424:	0f b6 d1             	movzbl %cl,%edx
40000427:	89 fb                	mov    %edi,%ebx
                precision = precision * 10 + ch - '0';
40000429:	83 ea 30             	sub    $0x30,%edx
                if (ch < '0' || ch > '9')
4000042c:	8d 48 d0             	lea    -0x30(%eax),%ecx
4000042f:	83 f9 09             	cmp    $0x9,%ecx
40000432:	77 19                	ja     4000044d <vprintfmt+0xdd>
40000434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (precision = 0;; ++fmt) {
40000438:	83 c3 01             	add    $0x1,%ebx
                precision = precision * 10 + ch - '0';
4000043b:	8d 14 92             	lea    (%edx,%edx,4),%edx
4000043e:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
                ch = *fmt;
40000442:	0f be 03             	movsbl (%ebx),%eax
                if (ch < '0' || ch > '9')
40000445:	8d 48 d0             	lea    -0x30(%eax),%ecx
40000448:	83 f9 09             	cmp    $0x9,%ecx
4000044b:	76 eb                	jbe    40000438 <vprintfmt+0xc8>
            if (width < 0)
4000044d:	8b 7c 24 04          	mov    0x4(%esp),%edi
40000451:	85 ff                	test   %edi,%edi
40000453:	79 85                	jns    400003da <vprintfmt+0x6a>
                width = precision, precision = -1;
40000455:	89 54 24 04          	mov    %edx,0x4(%esp)
40000459:	ba ff ff ff ff       	mov    $0xffffffff,%edx
4000045e:	e9 77 ff ff ff       	jmp    400003da <vprintfmt+0x6a>
            altflag = 1;
40000463:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
4000046a:	00 
        switch (ch = *(unsigned char *) fmt++) {
4000046b:	89 fb                	mov    %edi,%ebx
            goto reswitch;
4000046d:	e9 68 ff ff ff       	jmp    400003da <vprintfmt+0x6a>
            putch(ch, putdat);
40000472:	83 ec 08             	sub    $0x8,%esp
40000475:	55                   	push   %ebp
40000476:	6a 25                	push   $0x25
40000478:	ff d6                	call   *%esi
            break;
4000047a:	83 c4 10             	add    $0x10,%esp
4000047d:	e9 01 ff ff ff       	jmp    40000383 <vprintfmt+0x13>
            precision = va_arg(ap, int);
40000482:	8b 44 24 4c          	mov    0x4c(%esp),%eax
        switch (ch = *(unsigned char *) fmt++) {
40000486:	89 fb                	mov    %edi,%ebx
            precision = va_arg(ap, int);
40000488:	8b 10                	mov    (%eax),%edx
4000048a:	83 c0 04             	add    $0x4,%eax
4000048d:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto process_precision;
40000491:	eb ba                	jmp    4000044d <vprintfmt+0xdd>
            if (width < 0)
40000493:	8b 44 24 04          	mov    0x4(%esp),%eax
40000497:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (ch = *(unsigned char *) fmt++) {
4000049c:	89 fb                	mov    %edi,%ebx
4000049e:	85 c0                	test   %eax,%eax
400004a0:	0f 49 c8             	cmovns %eax,%ecx
400004a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
            goto reswitch;
400004a7:	e9 2e ff ff ff       	jmp    400003da <vprintfmt+0x6a>
            putch(va_arg(ap, int), putdat);
400004ac:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400004b0:	83 ec 08             	sub    $0x8,%esp
400004b3:	55                   	push   %ebp
400004b4:	8d 58 04             	lea    0x4(%eax),%ebx
400004b7:	8b 44 24 58          	mov    0x58(%esp),%eax
400004bb:	ff 30                	pushl  (%eax)
400004bd:	ff d6                	call   *%esi
400004bf:	89 5c 24 5c          	mov    %ebx,0x5c(%esp)
            break;
400004c3:	83 c4 10             	add    $0x10,%esp
400004c6:	e9 b8 fe ff ff       	jmp    40000383 <vprintfmt+0x13>
        return va_arg(*ap, unsigned long long);
400004cb:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
400004cf:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, unsigned long long);
400004d4:	8b 10                	mov    (%eax),%edx
    if (lflag >= 2)
400004d6:	0f 8f c1 01 00 00    	jg     4000069d <vprintfmt+0x32d>
        return va_arg(*ap, unsigned long);
400004dc:	83 c0 04             	add    $0x4,%eax
400004df:	31 c9                	xor    %ecx,%ecx
400004e1:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400004e5:	b8 0a 00 00 00       	mov    $0xa,%eax
400004ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            printnum(putch, putdat, num, base, width, padc);
400004f0:	83 ec 0c             	sub    $0xc,%esp
400004f3:	0f be 5c 24 1c       	movsbl 0x1c(%esp),%ebx
400004f8:	53                   	push   %ebx
400004f9:	ff 74 24 14          	pushl  0x14(%esp)
400004fd:	50                   	push   %eax
400004fe:	89 f0                	mov    %esi,%eax
40000500:	51                   	push   %ecx
40000501:	52                   	push   %edx
40000502:	89 ea                	mov    %ebp,%edx
40000504:	e8 77 fd ff ff       	call   40000280 <printnum>
            break;
40000509:	83 c4 20             	add    $0x20,%esp
4000050c:	e9 72 fe ff ff       	jmp    40000383 <vprintfmt+0x13>
            putch('0', putdat);
40000511:	83 ec 08             	sub    $0x8,%esp
40000514:	55                   	push   %ebp
40000515:	6a 30                	push   $0x30
40000517:	ff d6                	call   *%esi
            putch('x', putdat);
40000519:	58                   	pop    %eax
4000051a:	5a                   	pop    %edx
4000051b:	55                   	push   %ebp
4000051c:	6a 78                	push   $0x78
4000051e:	ff d6                	call   *%esi
            num = (unsigned long long)
40000520:	8b 44 24 5c          	mov    0x5c(%esp),%eax
40000524:	31 c9                	xor    %ecx,%ecx
            goto number;
40000526:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)
40000529:	8b 10                	mov    (%eax),%edx
                (uintptr_t) va_arg(ap, void *);
4000052b:	8b 44 24 4c          	mov    0x4c(%esp),%eax
4000052f:	83 c0 04             	add    $0x4,%eax
40000532:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto number;
40000536:	b8 10 00 00 00       	mov    $0x10,%eax
4000053b:	eb b3                	jmp    400004f0 <vprintfmt+0x180>
        return va_arg(*ap, unsigned long long);
4000053d:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
40000541:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, unsigned long long);
40000546:	8b 10                	mov    (%eax),%edx
    if (lflag >= 2)
40000548:	0f 8f 63 01 00 00    	jg     400006b1 <vprintfmt+0x341>
        return va_arg(*ap, unsigned long);
4000054e:	83 c0 04             	add    $0x4,%eax
40000551:	31 c9                	xor    %ecx,%ecx
40000553:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000557:	b8 10 00 00 00       	mov    $0x10,%eax
4000055c:	eb 92                	jmp    400004f0 <vprintfmt+0x180>
    if (lflag >= 2)
4000055e:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, long long);
40000563:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
40000567:	0f 8f 58 01 00 00    	jg     400006c5 <vprintfmt+0x355>
        return va_arg(*ap, long);
4000056d:	8b 4c 24 4c          	mov    0x4c(%esp),%ecx
40000571:	83 c0 04             	add    $0x4,%eax
40000574:	8b 11                	mov    (%ecx),%edx
40000576:	89 44 24 4c          	mov    %eax,0x4c(%esp)
4000057a:	89 d3                	mov    %edx,%ebx
4000057c:	89 d1                	mov    %edx,%ecx
4000057e:	c1 fb 1f             	sar    $0x1f,%ebx
            if ((long long) num < 0) {
40000581:	85 db                	test   %ebx,%ebx
40000583:	0f 88 65 01 00 00    	js     400006ee <vprintfmt+0x37e>
            num = getint(&ap, lflag);
40000589:	89 ca                	mov    %ecx,%edx
4000058b:	b8 0a 00 00 00       	mov    $0xa,%eax
40000590:	89 d9                	mov    %ebx,%ecx
40000592:	e9 59 ff ff ff       	jmp    400004f0 <vprintfmt+0x180>
            lflag++;
40000597:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
        switch (ch = *(unsigned char *) fmt++) {
4000059c:	89 fb                	mov    %edi,%ebx
            goto reswitch;
4000059e:	e9 37 fe ff ff       	jmp    400003da <vprintfmt+0x6a>
            putch('X', putdat);
400005a3:	83 ec 08             	sub    $0x8,%esp
400005a6:	55                   	push   %ebp
400005a7:	6a 58                	push   $0x58
400005a9:	ff d6                	call   *%esi
            putch('X', putdat);
400005ab:	59                   	pop    %ecx
400005ac:	5b                   	pop    %ebx
400005ad:	55                   	push   %ebp
400005ae:	6a 58                	push   $0x58
400005b0:	ff d6                	call   *%esi
            putch('X', putdat);
400005b2:	58                   	pop    %eax
400005b3:	5a                   	pop    %edx
400005b4:	55                   	push   %ebp
400005b5:	6a 58                	push   $0x58
400005b7:	ff d6                	call   *%esi
            break;
400005b9:	83 c4 10             	add    $0x10,%esp
400005bc:	e9 c2 fd ff ff       	jmp    40000383 <vprintfmt+0x13>
            if ((p = va_arg(ap, char *)) == NULL)
400005c1:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400005c5:	8b 4c 24 04          	mov    0x4(%esp),%ecx
400005c9:	83 c0 04             	add    $0x4,%eax
400005cc:	80 7c 24 10 2d       	cmpb   $0x2d,0x10(%esp)
400005d1:	89 44 24 14          	mov    %eax,0x14(%esp)
400005d5:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400005d9:	8b 18                	mov    (%eax),%ebx
400005db:	0f 95 c0             	setne  %al
400005de:	85 c9                	test   %ecx,%ecx
400005e0:	0f 9f c1             	setg   %cl
400005e3:	21 c8                	and    %ecx,%eax
400005e5:	85 db                	test   %ebx,%ebx
400005e7:	0f 84 31 01 00 00    	je     4000071e <vprintfmt+0x3ae>
            if (width > 0 && padc != '-')
400005ed:	8d 4b 01             	lea    0x1(%ebx),%ecx
400005f0:	84 c0                	test   %al,%al
400005f2:	0f 85 5b 01 00 00    	jne    40000753 <vprintfmt+0x3e3>
                 (ch = *p++) != '\0' && (precision < 0
400005f8:	0f be 1b             	movsbl (%ebx),%ebx
400005fb:	89 d8                	mov    %ebx,%eax
            for (;
400005fd:	85 db                	test   %ebx,%ebx
400005ff:	74 72                	je     40000673 <vprintfmt+0x303>
40000601:	89 5c 24 10          	mov    %ebx,0x10(%esp)
40000605:	89 cb                	mov    %ecx,%ebx
40000607:	8b 4c 24 10          	mov    0x10(%esp),%ecx
4000060b:	89 74 24 40          	mov    %esi,0x40(%esp)
4000060f:	89 d6                	mov    %edx,%esi
40000611:	89 7c 24 48          	mov    %edi,0x48(%esp)
40000615:	8b 7c 24 04          	mov    0x4(%esp),%edi
40000619:	eb 2a                	jmp    40000645 <vprintfmt+0x2d5>
4000061b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000061f:	90                   	nop
                if (altflag && (ch < ' ' || ch > '~'))
40000620:	83 e8 20             	sub    $0x20,%eax
40000623:	83 f8 5e             	cmp    $0x5e,%eax
40000626:	76 31                	jbe    40000659 <vprintfmt+0x2e9>
                    putch('?', putdat);
40000628:	83 ec 08             	sub    $0x8,%esp
4000062b:	55                   	push   %ebp
4000062c:	6a 3f                	push   $0x3f
4000062e:	ff 54 24 50          	call   *0x50(%esp)
40000632:	83 c4 10             	add    $0x10,%esp
                 (ch = *p++) != '\0' && (precision < 0
40000635:	0f be 03             	movsbl (%ebx),%eax
40000638:	83 c3 01             	add    $0x1,%ebx
                                         || --precision >= 0); width--)
4000063b:	83 ef 01             	sub    $0x1,%edi
                 (ch = *p++) != '\0' && (precision < 0
4000063e:	0f be c8             	movsbl %al,%ecx
            for (;
40000641:	85 c9                	test   %ecx,%ecx
40000643:	74 22                	je     40000667 <vprintfmt+0x2f7>
                 (ch = *p++) != '\0' && (precision < 0
40000645:	85 f6                	test   %esi,%esi
40000647:	78 08                	js     40000651 <vprintfmt+0x2e1>
                                         || --precision >= 0); width--)
40000649:	83 ee 01             	sub    $0x1,%esi
4000064c:	83 fe ff             	cmp    $0xffffffff,%esi
4000064f:	74 16                	je     40000667 <vprintfmt+0x2f7>
                if (altflag && (ch < ' ' || ch > '~'))
40000651:	8b 54 24 08          	mov    0x8(%esp),%edx
40000655:	85 d2                	test   %edx,%edx
40000657:	75 c7                	jne    40000620 <vprintfmt+0x2b0>
                    putch(ch, putdat);
40000659:	83 ec 08             	sub    $0x8,%esp
4000065c:	55                   	push   %ebp
4000065d:	51                   	push   %ecx
4000065e:	ff 54 24 50          	call   *0x50(%esp)
40000662:	83 c4 10             	add    $0x10,%esp
40000665:	eb ce                	jmp    40000635 <vprintfmt+0x2c5>
40000667:	89 7c 24 04          	mov    %edi,0x4(%esp)
4000066b:	8b 74 24 40          	mov    0x40(%esp),%esi
4000066f:	8b 7c 24 48          	mov    0x48(%esp),%edi
            for (; width > 0; width--)
40000673:	8b 4c 24 04          	mov    0x4(%esp),%ecx
40000677:	8b 5c 24 04          	mov    0x4(%esp),%ebx
4000067b:	85 c9                	test   %ecx,%ecx
4000067d:	7e 11                	jle    40000690 <vprintfmt+0x320>
4000067f:	90                   	nop
                putch(' ', putdat);
40000680:	83 ec 08             	sub    $0x8,%esp
40000683:	55                   	push   %ebp
40000684:	6a 20                	push   $0x20
40000686:	ff d6                	call   *%esi
            for (; width > 0; width--)
40000688:	83 c4 10             	add    $0x10,%esp
4000068b:	83 eb 01             	sub    $0x1,%ebx
4000068e:	75 f0                	jne    40000680 <vprintfmt+0x310>
            if ((p = va_arg(ap, char *)) == NULL)
40000690:	8b 44 24 14          	mov    0x14(%esp),%eax
40000694:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000698:	e9 e6 fc ff ff       	jmp    40000383 <vprintfmt+0x13>
        return va_arg(*ap, unsigned long long);
4000069d:	8b 48 04             	mov    0x4(%eax),%ecx
400006a0:	83 c0 08             	add    $0x8,%eax
400006a3:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400006a7:	b8 0a 00 00 00       	mov    $0xa,%eax
400006ac:	e9 3f fe ff ff       	jmp    400004f0 <vprintfmt+0x180>
400006b1:	8b 48 04             	mov    0x4(%eax),%ecx
400006b4:	83 c0 08             	add    $0x8,%eax
400006b7:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400006bb:	b8 10 00 00 00       	mov    $0x10,%eax
400006c0:	e9 2b fe ff ff       	jmp    400004f0 <vprintfmt+0x180>
        return va_arg(*ap, long long);
400006c5:	8b 08                	mov    (%eax),%ecx
400006c7:	8b 58 04             	mov    0x4(%eax),%ebx
400006ca:	83 c0 08             	add    $0x8,%eax
400006cd:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400006d1:	e9 ab fe ff ff       	jmp    40000581 <vprintfmt+0x211>
            padc = '-';
400006d6:	c6 44 24 10 2d       	movb   $0x2d,0x10(%esp)
        switch (ch = *(unsigned char *) fmt++) {
400006db:	89 fb                	mov    %edi,%ebx
400006dd:	e9 f8 fc ff ff       	jmp    400003da <vprintfmt+0x6a>
400006e2:	c6 44 24 10 30       	movb   $0x30,0x10(%esp)
400006e7:	89 fb                	mov    %edi,%ebx
400006e9:	e9 ec fc ff ff       	jmp    400003da <vprintfmt+0x6a>
400006ee:	89 4c 24 08          	mov    %ecx,0x8(%esp)
                putch('-', putdat);
400006f2:	83 ec 08             	sub    $0x8,%esp
400006f5:	89 5c 24 14          	mov    %ebx,0x14(%esp)
400006f9:	55                   	push   %ebp
400006fa:	6a 2d                	push   $0x2d
400006fc:	ff d6                	call   *%esi
                num = -(long long) num;
400006fe:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000702:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
40000706:	b8 0a 00 00 00       	mov    $0xa,%eax
4000070b:	89 ca                	mov    %ecx,%edx
4000070d:	89 d9                	mov    %ebx,%ecx
4000070f:	f7 da                	neg    %edx
40000711:	83 d1 00             	adc    $0x0,%ecx
40000714:	83 c4 10             	add    $0x10,%esp
40000717:	f7 d9                	neg    %ecx
40000719:	e9 d2 fd ff ff       	jmp    400004f0 <vprintfmt+0x180>
                 (ch = *p++) != '\0' && (precision < 0
4000071e:	bb 28 00 00 00       	mov    $0x28,%ebx
40000723:	b9 36 20 00 40       	mov    $0x40002036,%ecx
            if (width > 0 && padc != '-')
40000728:	84 c0                	test   %al,%al
4000072a:	0f 85 9d 00 00 00    	jne    400007cd <vprintfmt+0x45d>
40000730:	89 5c 24 10          	mov    %ebx,0x10(%esp)
                 (ch = *p++) != '\0' && (precision < 0
40000734:	b8 28 00 00 00       	mov    $0x28,%eax
40000739:	89 cb                	mov    %ecx,%ebx
4000073b:	b9 28 00 00 00       	mov    $0x28,%ecx
40000740:	89 74 24 40          	mov    %esi,0x40(%esp)
40000744:	89 d6                	mov    %edx,%esi
40000746:	89 7c 24 48          	mov    %edi,0x48(%esp)
4000074a:	8b 7c 24 04          	mov    0x4(%esp),%edi
4000074e:	e9 f2 fe ff ff       	jmp    40000645 <vprintfmt+0x2d5>
40000753:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
                for (width -= strnlen(p, precision); width > 0; width--)
40000757:	83 ec 08             	sub    $0x8,%esp
4000075a:	52                   	push   %edx
4000075b:	89 54 24 24          	mov    %edx,0x24(%esp)
4000075f:	53                   	push   %ebx
40000760:	e8 eb 02 00 00       	call   40000a50 <strnlen>
40000765:	29 44 24 14          	sub    %eax,0x14(%esp)
40000769:	8b 4c 24 14          	mov    0x14(%esp),%ecx
4000076d:	83 c4 10             	add    $0x10,%esp
40000770:	8b 54 24 18          	mov    0x18(%esp),%edx
40000774:	85 c9                	test   %ecx,%ecx
40000776:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
4000077a:	7e 3e                	jle    400007ba <vprintfmt+0x44a>
4000077c:	0f be 44 24 10       	movsbl 0x10(%esp),%eax
40000781:	89 4c 24 18          	mov    %ecx,0x18(%esp)
40000785:	89 54 24 10          	mov    %edx,0x10(%esp)
40000789:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
4000078d:	8b 5c 24 04          	mov    0x4(%esp),%ebx
40000791:	89 7c 24 48          	mov    %edi,0x48(%esp)
40000795:	89 c7                	mov    %eax,%edi
                    putch(padc, putdat);
40000797:	83 ec 08             	sub    $0x8,%esp
4000079a:	55                   	push   %ebp
4000079b:	57                   	push   %edi
4000079c:	ff d6                	call   *%esi
                for (width -= strnlen(p, precision); width > 0; width--)
4000079e:	83 c4 10             	add    $0x10,%esp
400007a1:	83 eb 01             	sub    $0x1,%ebx
400007a4:	75 f1                	jne    40000797 <vprintfmt+0x427>
400007a6:	8b 54 24 10          	mov    0x10(%esp),%edx
400007aa:	8b 4c 24 18          	mov    0x18(%esp),%ecx
400007ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
400007b2:	8b 7c 24 48          	mov    0x48(%esp),%edi
400007b6:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
                 (ch = *p++) != '\0' && (precision < 0
400007ba:	0f be 03             	movsbl (%ebx),%eax
400007bd:	0f be d8             	movsbl %al,%ebx
            for (;
400007c0:	85 db                	test   %ebx,%ebx
400007c2:	0f 85 39 fe ff ff    	jne    40000601 <vprintfmt+0x291>
400007c8:	e9 c3 fe ff ff       	jmp    40000690 <vprintfmt+0x320>
                for (width -= strnlen(p, precision); width > 0; width--)
400007cd:	83 ec 08             	sub    $0x8,%esp
                p = "(null)";
400007d0:	bb 35 20 00 40       	mov    $0x40002035,%ebx
                for (width -= strnlen(p, precision); width > 0; width--)
400007d5:	52                   	push   %edx
400007d6:	89 54 24 24          	mov    %edx,0x24(%esp)
400007da:	68 35 20 00 40       	push   $0x40002035
400007df:	e8 6c 02 00 00       	call   40000a50 <strnlen>
400007e4:	29 44 24 14          	sub    %eax,0x14(%esp)
400007e8:	8b 44 24 14          	mov    0x14(%esp),%eax
400007ec:	83 c4 10             	add    $0x10,%esp
400007ef:	b9 36 20 00 40       	mov    $0x40002036,%ecx
400007f4:	8b 54 24 18          	mov    0x18(%esp),%edx
400007f8:	85 c0                	test   %eax,%eax
400007fa:	7f 80                	jg     4000077c <vprintfmt+0x40c>
                 (ch = *p++) != '\0' && (precision < 0
400007fc:	bb 28 00 00 00       	mov    $0x28,%ebx
40000801:	e9 2a ff ff ff       	jmp    40000730 <vprintfmt+0x3c0>
40000806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000080d:	8d 76 00             	lea    0x0(%esi),%esi

40000810 <printfmt>:
{
40000810:	83 ec 0c             	sub    $0xc,%esp
    vprintfmt(putch, putdat, fmt, ap);
40000813:	8d 44 24 1c          	lea    0x1c(%esp),%eax
40000817:	50                   	push   %eax
40000818:	ff 74 24 1c          	pushl  0x1c(%esp)
4000081c:	ff 74 24 1c          	pushl  0x1c(%esp)
40000820:	ff 74 24 1c          	pushl  0x1c(%esp)
40000824:	e8 47 fb ff ff       	call   40000370 <vprintfmt>
}
40000829:	83 c4 1c             	add    $0x1c,%esp
4000082c:	c3                   	ret    
4000082d:	8d 76 00             	lea    0x0(%esi),%esi

40000830 <vsprintf>:

int vsprintf(char *buf, const char *fmt, va_list ap)
{
40000830:	83 ec 1c             	sub    $0x1c,%esp
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
40000833:	8b 44 24 20          	mov    0x20(%esp),%eax
40000837:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
4000083e:	ff 
4000083f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000846:	00 
40000847:	89 44 24 04          	mov    %eax,0x4(%esp)

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
4000084b:	ff 74 24 28          	pushl  0x28(%esp)
4000084f:	ff 74 24 28          	pushl  0x28(%esp)
40000853:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000857:	50                   	push   %eax
40000858:	68 50 03 00 40       	push   $0x40000350
4000085d:	e8 0e fb ff ff       	call   40000370 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
40000862:	8b 44 24 14          	mov    0x14(%esp),%eax
40000866:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
40000869:	8b 44 24 1c          	mov    0x1c(%esp),%eax
4000086d:	83 c4 2c             	add    $0x2c,%esp
40000870:	c3                   	ret    
40000871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000087f:	90                   	nop

40000880 <sprintf>:

int sprintf(char *buf, const char *fmt, ...)
{
40000880:	83 ec 1c             	sub    $0x1c,%esp
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
40000883:	8b 44 24 20          	mov    0x20(%esp),%eax
40000887:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
4000088e:	ff 
4000088f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000896:	00 
40000897:	89 44 24 04          	mov    %eax,0x4(%esp)
    vprintfmt((void *) sprintputch, &b, fmt, ap);
4000089b:	8d 44 24 28          	lea    0x28(%esp),%eax
4000089f:	50                   	push   %eax
400008a0:	ff 74 24 28          	pushl  0x28(%esp)
400008a4:	8d 44 24 0c          	lea    0xc(%esp),%eax
400008a8:	50                   	push   %eax
400008a9:	68 50 03 00 40       	push   $0x40000350
400008ae:	e8 bd fa ff ff       	call   40000370 <vprintfmt>
    *b.buf = '\0';
400008b3:	8b 44 24 14          	mov    0x14(%esp),%eax
400008b7:	c6 00 00             	movb   $0x0,(%eax)
    va_start(ap, fmt);
    rc = vsprintf(buf, fmt, ap);
    va_end(ap);

    return rc;
}
400008ba:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400008be:	83 c4 2c             	add    $0x2c,%esp
400008c1:	c3                   	ret    
400008c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400008c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

400008d0 <vsnprintf>:

int vsnprintf(char *buf, int n, const char *fmt, va_list ap)
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

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
400008ef:	ff 74 24 2c          	pushl  0x2c(%esp)
400008f3:	ff 74 24 2c          	pushl  0x2c(%esp)
400008f7:	8d 44 24 0c          	lea    0xc(%esp),%eax
400008fb:	50                   	push   %eax
400008fc:	68 50 03 00 40       	push   $0x40000350
40000901:	e8 6a fa ff ff       	call   40000370 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
40000906:	8b 44 24 14          	mov    0x14(%esp),%eax
4000090a:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
4000090d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000911:	83 c4 2c             	add    $0x2c,%esp
40000914:	c3                   	ret    
40000915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000091c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000920 <snprintf>:

int snprintf(char *buf, int n, const char *fmt, ...)
{
40000920:	83 ec 1c             	sub    $0x1c,%esp
40000923:	8b 44 24 20          	mov    0x20(%esp),%eax
    struct sprintbuf b = { buf, buf + n - 1, 0 };
40000927:	8b 54 24 24          	mov    0x24(%esp),%edx
4000092b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000932:	00 
40000933:	89 44 24 04          	mov    %eax,0x4(%esp)
40000937:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
4000093b:	89 44 24 08          	mov    %eax,0x8(%esp)
    vprintfmt((void *) sprintputch, &b, fmt, ap);
4000093f:	8d 44 24 2c          	lea    0x2c(%esp),%eax
40000943:	50                   	push   %eax
40000944:	ff 74 24 2c          	pushl  0x2c(%esp)
40000948:	8d 44 24 0c          	lea    0xc(%esp),%eax
4000094c:	50                   	push   %eax
4000094d:	68 50 03 00 40       	push   $0x40000350
40000952:	e8 19 fa ff ff       	call   40000370 <vprintfmt>
    *b.buf = '\0';
40000957:	8b 44 24 14          	mov    0x14(%esp),%eax
4000095b:	c6 00 00             	movb   $0x0,(%eax)
    va_start(ap, fmt);
    rc = vsnprintf(buf, n, fmt, ap);
    va_end(ap);

    return rc;
}
4000095e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000962:	83 c4 2c             	add    $0x2c,%esp
40000965:	c3                   	ret    
40000966:	66 90                	xchg   %ax,%ax
40000968:	66 90                	xchg   %ax,%ax
4000096a:	66 90                	xchg   %ax,%ax
4000096c:	66 90                	xchg   %ax,%ax
4000096e:	66 90                	xchg   %ax,%ax

40000970 <spawn>:
#include <proc.h>
#include <syscall.h>
#include <types.h>

pid_t spawn(uintptr_t exec, unsigned int quota)
{
40000970:	53                   	push   %ebx
static gcc_inline pid_t sys_spawn(unsigned int elf_id, unsigned int quota)
{
    int errno;
    pid_t pid;

    asm volatile ("int %2"
40000971:	b8 01 00 00 00       	mov    $0x1,%eax
40000976:	8b 5c 24 08          	mov    0x8(%esp),%ebx
4000097a:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
4000097e:	cd 30                	int    $0x30
                    "a" (SYS_spawn),
                    "b" (elf_id),
                    "c" (quota)
                  : "cc", "memory");

    return errno ? -1 : pid;
40000980:	85 c0                	test   %eax,%eax
40000982:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000987:	0f 44 c3             	cmove  %ebx,%eax
    return sys_spawn(exec, quota);
}
4000098a:	5b                   	pop    %ebx
4000098b:	c3                   	ret    
4000098c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000990 <yield>:
}

static gcc_inline void sys_yield(void)
{
    asm volatile ("int %0"
40000990:	b8 02 00 00 00       	mov    $0x2,%eax
40000995:	cd 30                	int    $0x30

void yield(void)
{
    sys_yield();
}
40000997:	c3                   	ret    
40000998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000099f:	90                   	nop

400009a0 <produce>:

void produce(unsigned int val)
{
400009a0:	53                   	push   %ebx
                  : "cc", "memory");
}

static gcc_inline void sys_produce(unsigned int val)
{
    asm volatile ("int %0"
400009a1:	b8 03 00 00 00       	mov    $0x3,%eax
400009a6:	8b 5c 24 08          	mov    0x8(%esp),%ebx
400009aa:	cd 30                	int    $0x30
    sys_produce(val);
}
400009ac:	5b                   	pop    %ebx
400009ad:	c3                   	ret    
400009ae:	66 90                	xchg   %ax,%ax

400009b0 <consume>:

unsigned int consume(void)
{
400009b0:	53                   	push   %ebx
}

static gcc_inline unsigned int sys_consume(void)
{
    unsigned int val;
    asm volatile ("int %1"
400009b1:	b8 04 00 00 00       	mov    $0x4,%eax
400009b6:	cd 30                	int    $0x30
400009b8:	89 d8                	mov    %ebx,%eax
    return sys_consume();
}
400009ba:	5b                   	pop    %ebx
400009bb:	c3                   	ret    
400009bc:	66 90                	xchg   %ax,%ax
400009be:	66 90                	xchg   %ax,%ax

400009c0 <spinlock_init>:
    return result;
}

void spinlock_init(spinlock_t *lk)
{
    *lk = 0;
400009c0:	8b 44 24 04          	mov    0x4(%esp),%eax
400009c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
400009ca:	c3                   	ret    
400009cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400009cf:	90                   	nop

400009d0 <spinlock_acquire>:

void spinlock_acquire(spinlock_t *lk)
{
400009d0:	8b 54 24 04          	mov    0x4(%esp),%edx
    asm volatile ("lock; xchgl %0, %1"
400009d4:	b8 01 00 00 00       	mov    $0x1,%eax
400009d9:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
400009dc:	85 c0                	test   %eax,%eax
400009de:	74 13                	je     400009f3 <spinlock_acquire+0x23>
    asm volatile ("lock; xchgl %0, %1"
400009e0:	b9 01 00 00 00       	mov    $0x1,%ecx
400009e5:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("pause");
400009e8:	f3 90                	pause  
    asm volatile ("lock; xchgl %0, %1"
400009ea:	89 c8                	mov    %ecx,%eax
400009ec:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
400009ef:	85 c0                	test   %eax,%eax
400009f1:	75 f5                	jne    400009e8 <spinlock_acquire+0x18>
}
400009f3:	c3                   	ret    
400009f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400009fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400009ff:	90                   	nop

40000a00 <spinlock_release>:

// Release the lock.
void spinlock_release(spinlock_t *lk)
{
40000a00:	8b 54 24 04          	mov    0x4(%esp),%edx
}

// Check whether this cpu is holding the lock.
bool spinlock_holding(spinlock_t *lk)
{
    return *lk;
40000a04:	8b 02                	mov    (%edx),%eax
    if (spinlock_holding(lk) == FALSE)
40000a06:	84 c0                	test   %al,%al
40000a08:	74 05                	je     40000a0f <spinlock_release+0xf>
    asm volatile ("lock; xchgl %0, %1"
40000a0a:	31 c0                	xor    %eax,%eax
40000a0c:	f0 87 02             	lock xchg %eax,(%edx)
}
40000a0f:	c3                   	ret    

40000a10 <spinlock_holding>:
    return *lk;
40000a10:	8b 44 24 04          	mov    0x4(%esp),%eax
40000a14:	8b 00                	mov    (%eax),%eax
}
40000a16:	c3                   	ret    
40000a17:	66 90                	xchg   %ax,%ax
40000a19:	66 90                	xchg   %ax,%ax
40000a1b:	66 90                	xchg   %ax,%ax
40000a1d:	66 90                	xchg   %ax,%ax
40000a1f:	90                   	nop

40000a20 <strlen>:
#include <string.h>
#include <types.h>

int strlen(const char *s)
{
40000a20:	8b 54 24 04          	mov    0x4(%esp),%edx
    int n;

    for (n = 0; *s != '\0'; s++)
40000a24:	31 c0                	xor    %eax,%eax
40000a26:	80 3a 00             	cmpb   $0x0,(%edx)
40000a29:	74 15                	je     40000a40 <strlen+0x20>
40000a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000a2f:	90                   	nop
        n++;
40000a30:	83 c0 01             	add    $0x1,%eax
    for (n = 0; *s != '\0'; s++)
40000a33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
40000a37:	75 f7                	jne    40000a30 <strlen+0x10>
40000a39:	c3                   	ret    
40000a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return n;
}
40000a40:	c3                   	ret    
40000a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a4f:	90                   	nop

40000a50 <strnlen>:

int strnlen(const char *s, size_t size)
{
40000a50:	8b 54 24 08          	mov    0x8(%esp),%edx
40000a54:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a58:	31 c0                	xor    %eax,%eax
40000a5a:	85 d2                	test   %edx,%edx
40000a5c:	75 09                	jne    40000a67 <strnlen+0x17>
40000a5e:	eb 10                	jmp    40000a70 <strnlen+0x20>
        n++;
40000a60:	83 c0 01             	add    $0x1,%eax
    for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000a63:	39 d0                	cmp    %edx,%eax
40000a65:	74 09                	je     40000a70 <strnlen+0x20>
40000a67:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
40000a6b:	75 f3                	jne    40000a60 <strnlen+0x10>
40000a6d:	c3                   	ret    
40000a6e:	66 90                	xchg   %ax,%ax
    return n;
}
40000a70:	c3                   	ret    
40000a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a7f:	90                   	nop

40000a80 <strcpy>:

char *strcpy(char *dst, const char *src)
{
40000a80:	53                   	push   %ebx
40000a81:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    char *ret;

    ret = dst;
    while ((*dst++ = *src++) != '\0')
40000a85:	31 c0                	xor    %eax,%eax
{
40000a87:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
40000a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000a8f:	90                   	nop
    while ((*dst++ = *src++) != '\0')
40000a90:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000a94:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000a97:	83 c0 01             	add    $0x1,%eax
40000a9a:	84 d2                	test   %dl,%dl
40000a9c:	75 f2                	jne    40000a90 <strcpy+0x10>
        /* do nothing */ ;
    return ret;
}
40000a9e:	89 c8                	mov    %ecx,%eax
40000aa0:	5b                   	pop    %ebx
40000aa1:	c3                   	ret    
40000aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000ab0 <strncpy>:

char *strncpy(char *dst, const char *src, size_t size)
{
40000ab0:	56                   	push   %esi
40000ab1:	53                   	push   %ebx
40000ab2:	8b 5c 24 14          	mov    0x14(%esp),%ebx
40000ab6:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000aba:	8b 44 24 10          	mov    0x10(%esp),%eax
    size_t i;
    char *ret;

    ret = dst;
    for (i = 0; i < size; i++) {
40000abe:	85 db                	test   %ebx,%ebx
40000ac0:	74 21                	je     40000ae3 <strncpy+0x33>
40000ac2:	01 f3                	add    %esi,%ebx
40000ac4:	89 f2                	mov    %esi,%edx
40000ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000acd:	8d 76 00             	lea    0x0(%esi),%esi
        *dst++ = *src;
40000ad0:	0f b6 08             	movzbl (%eax),%ecx
40000ad3:	83 c2 01             	add    $0x1,%edx
40000ad6:	88 4a ff             	mov    %cl,-0x1(%edx)
        // If strlen(src) < size, null-pad 'dst' out to 'size' chars
        if (*src != '\0')
            src++;
40000ad9:	80 38 01             	cmpb   $0x1,(%eax)
40000adc:	83 d8 ff             	sbb    $0xffffffff,%eax
    for (i = 0; i < size; i++) {
40000adf:	39 da                	cmp    %ebx,%edx
40000ae1:	75 ed                	jne    40000ad0 <strncpy+0x20>
    }
    return ret;
}
40000ae3:	89 f0                	mov    %esi,%eax
40000ae5:	5b                   	pop    %ebx
40000ae6:	5e                   	pop    %esi
40000ae7:	c3                   	ret    
40000ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000aef:	90                   	nop

40000af0 <strlcpy>:

size_t strlcpy(char *dst, const char *src, size_t size)
{
40000af0:	56                   	push   %esi
40000af1:	53                   	push   %ebx
40000af2:	8b 44 24 14          	mov    0x14(%esp),%eax
40000af6:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000afa:	8b 4c 24 10          	mov    0x10(%esp),%ecx
    char *dst_in;

    dst_in = dst;
    if (size > 0) {
40000afe:	85 c0                	test   %eax,%eax
40000b00:	74 29                	je     40000b2b <strlcpy+0x3b>
        while (--size > 0 && *src != '\0')
40000b02:	89 f2                	mov    %esi,%edx
40000b04:	83 e8 01             	sub    $0x1,%eax
40000b07:	74 1f                	je     40000b28 <strlcpy+0x38>
40000b09:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
40000b0c:	eb 0f                	jmp    40000b1d <strlcpy+0x2d>
40000b0e:	66 90                	xchg   %ax,%ax
            *dst++ = *src++;
40000b10:	83 c2 01             	add    $0x1,%edx
40000b13:	83 c1 01             	add    $0x1,%ecx
40000b16:	88 42 ff             	mov    %al,-0x1(%edx)
        while (--size > 0 && *src != '\0')
40000b19:	39 da                	cmp    %ebx,%edx
40000b1b:	74 07                	je     40000b24 <strlcpy+0x34>
40000b1d:	0f b6 01             	movzbl (%ecx),%eax
40000b20:	84 c0                	test   %al,%al
40000b22:	75 ec                	jne    40000b10 <strlcpy+0x20>
40000b24:	89 d0                	mov    %edx,%eax
40000b26:	29 f0                	sub    %esi,%eax
        *dst = '\0';
40000b28:	c6 02 00             	movb   $0x0,(%edx)
    }
    return dst - dst_in;
}
40000b2b:	5b                   	pop    %ebx
40000b2c:	5e                   	pop    %esi
40000b2d:	c3                   	ret    
40000b2e:	66 90                	xchg   %ax,%ax

40000b30 <strcmp>:

int strcmp(const char *p, const char *q)
{
40000b30:	53                   	push   %ebx
40000b31:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000b35:	8b 54 24 0c          	mov    0xc(%esp),%edx
    while (*p && *p == *q)
40000b39:	0f b6 01             	movzbl (%ecx),%eax
40000b3c:	0f b6 1a             	movzbl (%edx),%ebx
40000b3f:	84 c0                	test   %al,%al
40000b41:	75 16                	jne    40000b59 <strcmp+0x29>
40000b43:	eb 23                	jmp    40000b68 <strcmp+0x38>
40000b45:	8d 76 00             	lea    0x0(%esi),%esi
40000b48:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        p++, q++;
40000b4c:	83 c1 01             	add    $0x1,%ecx
40000b4f:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
40000b52:	0f b6 1a             	movzbl (%edx),%ebx
40000b55:	84 c0                	test   %al,%al
40000b57:	74 0f                	je     40000b68 <strcmp+0x38>
40000b59:	38 d8                	cmp    %bl,%al
40000b5b:	74 eb                	je     40000b48 <strcmp+0x18>
    return (int) ((unsigned char) *p - (unsigned char) *q);
40000b5d:	29 d8                	sub    %ebx,%eax
}
40000b5f:	5b                   	pop    %ebx
40000b60:	c3                   	ret    
40000b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b68:	31 c0                	xor    %eax,%eax
    return (int) ((unsigned char) *p - (unsigned char) *q);
40000b6a:	29 d8                	sub    %ebx,%eax
}
40000b6c:	5b                   	pop    %ebx
40000b6d:	c3                   	ret    
40000b6e:	66 90                	xchg   %ax,%ax

40000b70 <strncmp>:

int strncmp(const char *p, const char *q, size_t n)
{
40000b70:	56                   	push   %esi
40000b71:	53                   	push   %ebx
40000b72:	8b 74 24 14          	mov    0x14(%esp),%esi
40000b76:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000b7a:	8b 44 24 10          	mov    0x10(%esp),%eax
    while (n > 0 && *p && *p == *q)
40000b7e:	85 f6                	test   %esi,%esi
40000b80:	74 2e                	je     40000bb0 <strncmp+0x40>
40000b82:	01 c6                	add    %eax,%esi
40000b84:	eb 18                	jmp    40000b9e <strncmp+0x2e>
40000b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b8d:	8d 76 00             	lea    0x0(%esi),%esi
40000b90:	38 da                	cmp    %bl,%dl
40000b92:	75 14                	jne    40000ba8 <strncmp+0x38>
        n--, p++, q++;
40000b94:	83 c0 01             	add    $0x1,%eax
40000b97:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q)
40000b9a:	39 f0                	cmp    %esi,%eax
40000b9c:	74 12                	je     40000bb0 <strncmp+0x40>
40000b9e:	0f b6 11             	movzbl (%ecx),%edx
40000ba1:	0f b6 18             	movzbl (%eax),%ebx
40000ba4:	84 d2                	test   %dl,%dl
40000ba6:	75 e8                	jne    40000b90 <strncmp+0x20>
    if (n == 0)
        return 0;
    else
        return (int) ((unsigned char) *p - (unsigned char) *q);
40000ba8:	0f b6 c2             	movzbl %dl,%eax
40000bab:	29 d8                	sub    %ebx,%eax
}
40000bad:	5b                   	pop    %ebx
40000bae:	5e                   	pop    %esi
40000baf:	c3                   	ret    
        return 0;
40000bb0:	31 c0                	xor    %eax,%eax
}
40000bb2:	5b                   	pop    %ebx
40000bb3:	5e                   	pop    %esi
40000bb4:	c3                   	ret    
40000bb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000bc0 <strchr>:

char *strchr(const char *s, char c)
{
40000bc0:	8b 44 24 04          	mov    0x4(%esp),%eax
40000bc4:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
    for (; *s; s++)
40000bc9:	0f b6 10             	movzbl (%eax),%edx
40000bcc:	84 d2                	test   %dl,%dl
40000bce:	75 13                	jne    40000be3 <strchr+0x23>
40000bd0:	eb 1e                	jmp    40000bf0 <strchr+0x30>
40000bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000bd8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000bdc:	83 c0 01             	add    $0x1,%eax
40000bdf:	84 d2                	test   %dl,%dl
40000be1:	74 0d                	je     40000bf0 <strchr+0x30>
        if (*s == c)
40000be3:	38 d1                	cmp    %dl,%cl
40000be5:	75 f1                	jne    40000bd8 <strchr+0x18>
            return (char *) s;
    return 0;
}
40000be7:	c3                   	ret    
40000be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bef:	90                   	nop
    return 0;
40000bf0:	31 c0                	xor    %eax,%eax
}
40000bf2:	c3                   	ret    
40000bf3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000c00 <strfind>:

char *strfind(const char *s, char c)
{
40000c00:	53                   	push   %ebx
40000c01:	8b 44 24 08          	mov    0x8(%esp),%eax
40000c05:	8b 54 24 0c          	mov    0xc(%esp),%edx
    for (; *s; s++)
40000c09:	0f b6 18             	movzbl (%eax),%ebx
        if (*s == c)
40000c0c:	38 d3                	cmp    %dl,%bl
40000c0e:	74 1f                	je     40000c2f <strfind+0x2f>
40000c10:	89 d1                	mov    %edx,%ecx
40000c12:	84 db                	test   %bl,%bl
40000c14:	75 0e                	jne    40000c24 <strfind+0x24>
40000c16:	eb 17                	jmp    40000c2f <strfind+0x2f>
40000c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c1f:	90                   	nop
40000c20:	84 d2                	test   %dl,%dl
40000c22:	74 0b                	je     40000c2f <strfind+0x2f>
    for (; *s; s++)
40000c24:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000c28:	83 c0 01             	add    $0x1,%eax
        if (*s == c)
40000c2b:	38 ca                	cmp    %cl,%dl
40000c2d:	75 f1                	jne    40000c20 <strfind+0x20>
            break;
    return (char *) s;
}
40000c2f:	5b                   	pop    %ebx
40000c30:	c3                   	ret    
40000c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c3f:	90                   	nop

40000c40 <strtol>:

long strtol(const char *s, char **endptr, int base)
{
40000c40:	55                   	push   %ebp
40000c41:	57                   	push   %edi
40000c42:	56                   	push   %esi
40000c43:	53                   	push   %ebx
40000c44:	83 ec 04             	sub    $0x4,%esp
40000c47:	8b 44 24 20          	mov    0x20(%esp),%eax
40000c4b:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000c4f:	8b 74 24 1c          	mov    0x1c(%esp),%esi
40000c53:	89 04 24             	mov    %eax,(%esp)
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
40000c56:	0f b6 01             	movzbl (%ecx),%eax
40000c59:	3c 09                	cmp    $0x9,%al
40000c5b:	74 0b                	je     40000c68 <strtol+0x28>
40000c5d:	3c 20                	cmp    $0x20,%al
40000c5f:	75 16                	jne    40000c77 <strtol+0x37>
40000c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c68:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        s++;
40000c6c:	83 c1 01             	add    $0x1,%ecx
    while (*s == ' ' || *s == '\t')
40000c6f:	3c 20                	cmp    $0x20,%al
40000c71:	74 f5                	je     40000c68 <strtol+0x28>
40000c73:	3c 09                	cmp    $0x9,%al
40000c75:	74 f1                	je     40000c68 <strtol+0x28>

    // plus/minus sign
    if (*s == '+')
40000c77:	3c 2b                	cmp    $0x2b,%al
40000c79:	0f 84 a1 00 00 00    	je     40000d20 <strtol+0xe0>
    int neg = 0;
40000c7f:	31 ff                	xor    %edi,%edi
        s++;
    else if (*s == '-')
40000c81:	3c 2d                	cmp    $0x2d,%al
40000c83:	0f 84 87 00 00 00    	je     40000d10 <strtol+0xd0>
        s++, neg = 1;

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000c89:	0f be 11             	movsbl (%ecx),%edx
40000c8c:	f7 04 24 ef ff ff ff 	testl  $0xffffffef,(%esp)
40000c93:	75 17                	jne    40000cac <strtol+0x6c>
40000c95:	80 fa 30             	cmp    $0x30,%dl
40000c98:	0f 84 92 00 00 00    	je     40000d30 <strtol+0xf0>
        s += 2, base = 16;
    else if (base == 0 && s[0] == '0')
40000c9e:	8b 2c 24             	mov    (%esp),%ebp
40000ca1:	85 ed                	test   %ebp,%ebp
40000ca3:	75 07                	jne    40000cac <strtol+0x6c>
        s++, base = 8;
    else if (base == 0)
        base = 10;
40000ca5:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
40000cac:	31 c0                	xor    %eax,%eax
40000cae:	eb 15                	jmp    40000cc5 <strtol+0x85>
    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9')
            dig = *s - '0';
40000cb0:	83 ea 30             	sub    $0x30,%edx
            dig = *s - 'a' + 10;
        else if (*s >= 'A' && *s <= 'Z')
            dig = *s - 'A' + 10;
        else
            break;
        if (dig >= base)
40000cb3:	8b 1c 24             	mov    (%esp),%ebx
40000cb6:	39 da                	cmp    %ebx,%edx
40000cb8:	7d 29                	jge    40000ce3 <strtol+0xa3>
            break;
        s++, val = (val * base) + dig;
40000cba:	0f af c3             	imul   %ebx,%eax
40000cbd:	83 c1 01             	add    $0x1,%ecx
40000cc0:	01 d0                	add    %edx,%eax
    while (1) {
40000cc2:	0f be 11             	movsbl (%ecx),%edx
        if (*s >= '0' && *s <= '9')
40000cc5:	8d 6a d0             	lea    -0x30(%edx),%ebp
40000cc8:	89 eb                	mov    %ebp,%ebx
40000cca:	80 fb 09             	cmp    $0x9,%bl
40000ccd:	76 e1                	jbe    40000cb0 <strtol+0x70>
        else if (*s >= 'a' && *s <= 'z')
40000ccf:	8d 6a 9f             	lea    -0x61(%edx),%ebp
40000cd2:	89 eb                	mov    %ebp,%ebx
40000cd4:	80 fb 19             	cmp    $0x19,%bl
40000cd7:	77 27                	ja     40000d00 <strtol+0xc0>
        if (dig >= base)
40000cd9:	8b 1c 24             	mov    (%esp),%ebx
            dig = *s - 'a' + 10;
40000cdc:	83 ea 57             	sub    $0x57,%edx
        if (dig >= base)
40000cdf:	39 da                	cmp    %ebx,%edx
40000ce1:	7c d7                	jl     40000cba <strtol+0x7a>
        // we don't properly detect overflow!
    }

    if (endptr)
40000ce3:	85 f6                	test   %esi,%esi
40000ce5:	74 02                	je     40000ce9 <strtol+0xa9>
        *endptr = (char *) s;
40000ce7:	89 0e                	mov    %ecx,(%esi)
    return (neg ? -val : val);
40000ce9:	89 c2                	mov    %eax,%edx
40000ceb:	f7 da                	neg    %edx
40000ced:	85 ff                	test   %edi,%edi
40000cef:	0f 45 c2             	cmovne %edx,%eax
}
40000cf2:	83 c4 04             	add    $0x4,%esp
40000cf5:	5b                   	pop    %ebx
40000cf6:	5e                   	pop    %esi
40000cf7:	5f                   	pop    %edi
40000cf8:	5d                   	pop    %ebp
40000cf9:	c3                   	ret    
40000cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        else if (*s >= 'A' && *s <= 'Z')
40000d00:	8d 6a bf             	lea    -0x41(%edx),%ebp
40000d03:	89 eb                	mov    %ebp,%ebx
40000d05:	80 fb 19             	cmp    $0x19,%bl
40000d08:	77 d9                	ja     40000ce3 <strtol+0xa3>
            dig = *s - 'A' + 10;
40000d0a:	83 ea 37             	sub    $0x37,%edx
40000d0d:	eb a4                	jmp    40000cb3 <strtol+0x73>
40000d0f:	90                   	nop
        s++, neg = 1;
40000d10:	83 c1 01             	add    $0x1,%ecx
40000d13:	bf 01 00 00 00       	mov    $0x1,%edi
40000d18:	e9 6c ff ff ff       	jmp    40000c89 <strtol+0x49>
40000d1d:	8d 76 00             	lea    0x0(%esi),%esi
        s++;
40000d20:	83 c1 01             	add    $0x1,%ecx
    int neg = 0;
40000d23:	31 ff                	xor    %edi,%edi
40000d25:	e9 5f ff ff ff       	jmp    40000c89 <strtol+0x49>
40000d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000d30:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
40000d34:	3c 78                	cmp    $0x78,%al
40000d36:	74 1d                	je     40000d55 <strtol+0x115>
    else if (base == 0 && s[0] == '0')
40000d38:	8b 1c 24             	mov    (%esp),%ebx
40000d3b:	85 db                	test   %ebx,%ebx
40000d3d:	0f 85 69 ff ff ff    	jne    40000cac <strtol+0x6c>
        s++, base = 8;
40000d43:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
40000d4a:	83 c1 01             	add    $0x1,%ecx
40000d4d:	0f be d0             	movsbl %al,%edx
40000d50:	e9 57 ff ff ff       	jmp    40000cac <strtol+0x6c>
        s += 2, base = 16;
40000d55:	0f be 51 02          	movsbl 0x2(%ecx),%edx
40000d59:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
40000d60:	83 c1 02             	add    $0x2,%ecx
40000d63:	e9 44 ff ff ff       	jmp    40000cac <strtol+0x6c>
40000d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d6f:	90                   	nop

40000d70 <memset>:

void *memset(void *v, int c, size_t n)
{
40000d70:	57                   	push   %edi
40000d71:	56                   	push   %esi
40000d72:	53                   	push   %ebx
40000d73:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000d77:	8b 7c 24 10          	mov    0x10(%esp),%edi
    if (n == 0)
40000d7b:	85 c9                	test   %ecx,%ecx
40000d7d:	74 28                	je     40000da7 <memset+0x37>
        return v;
    if ((int) v % 4 == 0 && n % 4 == 0) {
40000d7f:	89 f8                	mov    %edi,%eax
40000d81:	09 c8                	or     %ecx,%eax
40000d83:	a8 03                	test   $0x3,%al
40000d85:	75 29                	jne    40000db0 <memset+0x40>
        c &= 0xFF;
40000d87:	0f b6 54 24 14       	movzbl 0x14(%esp),%edx
        c = (c << 24) | (c << 16) | (c << 8) | c;
        asm volatile ("cld; rep stosl\n"
                      :: "D" (v), "a" (c), "c" (n / 4)
40000d8c:	c1 e9 02             	shr    $0x2,%ecx
        c = (c << 24) | (c << 16) | (c << 8) | c;
40000d8f:	89 d0                	mov    %edx,%eax
40000d91:	89 d6                	mov    %edx,%esi
40000d93:	89 d3                	mov    %edx,%ebx
40000d95:	c1 e0 18             	shl    $0x18,%eax
40000d98:	c1 e6 10             	shl    $0x10,%esi
40000d9b:	09 f0                	or     %esi,%eax
40000d9d:	c1 e3 08             	shl    $0x8,%ebx
40000da0:	09 d0                	or     %edx,%eax
40000da2:	09 d8                	or     %ebx,%eax
        asm volatile ("cld; rep stosl\n"
40000da4:	fc                   	cld    
40000da5:	f3 ab                	rep stos %eax,%es:(%edi)
    } else
        asm volatile ("cld; rep stosb\n"
                      :: "D" (v), "a" (c), "c" (n)
                      : "cc", "memory");
    return v;
}
40000da7:	89 f8                	mov    %edi,%eax
40000da9:	5b                   	pop    %ebx
40000daa:	5e                   	pop    %esi
40000dab:	5f                   	pop    %edi
40000dac:	c3                   	ret    
40000dad:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("cld; rep stosb\n"
40000db0:	8b 44 24 14          	mov    0x14(%esp),%eax
40000db4:	fc                   	cld    
40000db5:	f3 aa                	rep stos %al,%es:(%edi)
}
40000db7:	89 f8                	mov    %edi,%eax
40000db9:	5b                   	pop    %ebx
40000dba:	5e                   	pop    %esi
40000dbb:	5f                   	pop    %edi
40000dbc:	c3                   	ret    
40000dbd:	8d 76 00             	lea    0x0(%esi),%esi

40000dc0 <memmove>:

void *memmove(void *dst, const void *src, size_t n)
{
40000dc0:	57                   	push   %edi
40000dc1:	56                   	push   %esi
40000dc2:	8b 44 24 0c          	mov    0xc(%esp),%eax
40000dc6:	8b 74 24 10          	mov    0x10(%esp),%esi
40000dca:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
40000dce:	39 c6                	cmp    %eax,%esi
40000dd0:	73 26                	jae    40000df8 <memmove+0x38>
40000dd2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
40000dd5:	39 c2                	cmp    %eax,%edx
40000dd7:	76 1f                	jbe    40000df8 <memmove+0x38>
        s += n;
        d += n;
40000dd9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000ddc:	89 fe                	mov    %edi,%esi
40000dde:	09 ce                	or     %ecx,%esi
40000de0:	09 d6                	or     %edx,%esi
40000de2:	83 e6 03             	and    $0x3,%esi
40000de5:	74 39                	je     40000e20 <memmove+0x60>
            asm volatile ("std; rep movsl\n"
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
                          : "cc", "memory");
        else
            asm volatile ("std; rep movsb\n"
                          :: "D" (d - 1), "S" (s - 1), "c" (n)
40000de7:	83 ef 01             	sub    $0x1,%edi
40000dea:	8d 72 ff             	lea    -0x1(%edx),%esi
            asm volatile ("std; rep movsb\n"
40000ded:	fd                   	std    
40000dee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile ("cld" ::: "cc");
40000df0:	fc                   	cld    
            asm volatile ("cld; rep movsb\n"
                          :: "D" (d), "S" (s), "c" (n)
                          : "cc", "memory");
    }
    return dst;
}
40000df1:	5e                   	pop    %esi
40000df2:	5f                   	pop    %edi
40000df3:	c3                   	ret    
40000df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000df8:	89 c2                	mov    %eax,%edx
40000dfa:	09 ca                	or     %ecx,%edx
40000dfc:	09 f2                	or     %esi,%edx
40000dfe:	83 e2 03             	and    $0x3,%edx
40000e01:	74 0d                	je     40000e10 <memmove+0x50>
            asm volatile ("cld; rep movsb\n"
40000e03:	89 c7                	mov    %eax,%edi
40000e05:	fc                   	cld    
40000e06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000e08:	5e                   	pop    %esi
40000e09:	5f                   	pop    %edi
40000e0a:	c3                   	ret    
40000e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000e0f:	90                   	nop
                          :: "D" (d), "S" (s), "c" (n / 4)
40000e10:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("cld; rep movsl\n"
40000e13:	89 c7                	mov    %eax,%edi
40000e15:	fc                   	cld    
40000e16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000e18:	eb ee                	jmp    40000e08 <memmove+0x48>
40000e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
40000e20:	83 ef 04             	sub    $0x4,%edi
40000e23:	8d 72 fc             	lea    -0x4(%edx),%esi
40000e26:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("std; rep movsl\n"
40000e29:	fd                   	std    
40000e2a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000e2c:	eb c2                	jmp    40000df0 <memmove+0x30>
40000e2e:	66 90                	xchg   %ax,%ax

40000e30 <memcpy>:

void *memcpy(void *dst, const void *src, size_t n)
{
    return memmove(dst, src, n);
40000e30:	eb 8e                	jmp    40000dc0 <memmove>
40000e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000e40 <memcmp>:
}

int memcmp(const void *v1, const void *v2, size_t n)
{
40000e40:	56                   	push   %esi
40000e41:	53                   	push   %ebx
40000e42:	8b 74 24 14          	mov    0x14(%esp),%esi
40000e46:	8b 54 24 0c          	mov    0xc(%esp),%edx
40000e4a:	8b 44 24 10          	mov    0x10(%esp),%eax
    const uint8_t *s1 = (const uint8_t *) v1;
    const uint8_t *s2 = (const uint8_t *) v2;

    while (n-- > 0) {
40000e4e:	85 f6                	test   %esi,%esi
40000e50:	74 2e                	je     40000e80 <memcmp+0x40>
40000e52:	01 c6                	add    %eax,%esi
40000e54:	eb 14                	jmp    40000e6a <memcmp+0x2a>
40000e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e5d:	8d 76 00             	lea    0x0(%esi),%esi
        if (*s1 != *s2)
            return (int) *s1 - (int) *s2;
        s1++, s2++;
40000e60:	83 c0 01             	add    $0x1,%eax
40000e63:	83 c2 01             	add    $0x1,%edx
    while (n-- > 0) {
40000e66:	39 f0                	cmp    %esi,%eax
40000e68:	74 16                	je     40000e80 <memcmp+0x40>
        if (*s1 != *s2)
40000e6a:	0f b6 0a             	movzbl (%edx),%ecx
40000e6d:	0f b6 18             	movzbl (%eax),%ebx
40000e70:	38 d9                	cmp    %bl,%cl
40000e72:	74 ec                	je     40000e60 <memcmp+0x20>
            return (int) *s1 - (int) *s2;
40000e74:	0f b6 c1             	movzbl %cl,%eax
40000e77:	29 d8                	sub    %ebx,%eax
    }

    return 0;
}
40000e79:	5b                   	pop    %ebx
40000e7a:	5e                   	pop    %esi
40000e7b:	c3                   	ret    
40000e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
40000e80:	31 c0                	xor    %eax,%eax
}
40000e82:	5b                   	pop    %ebx
40000e83:	5e                   	pop    %esi
40000e84:	c3                   	ret    
40000e85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000e90 <memchr>:

void *memchr(const void *s, int c, size_t n)
{
40000e90:	8b 44 24 04          	mov    0x4(%esp),%eax
    const void *ends = (const char *) s + n;
40000e94:	8b 54 24 0c          	mov    0xc(%esp),%edx
40000e98:	01 c2                	add    %eax,%edx
    for (; s < ends; s++)
40000e9a:	39 d0                	cmp    %edx,%eax
40000e9c:	73 1a                	jae    40000eb8 <memchr+0x28>
40000e9e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
40000ea3:	eb 0a                	jmp    40000eaf <memchr+0x1f>
40000ea5:	8d 76 00             	lea    0x0(%esi),%esi
40000ea8:	83 c0 01             	add    $0x1,%eax
40000eab:	39 c2                	cmp    %eax,%edx
40000ead:	74 09                	je     40000eb8 <memchr+0x28>
        if (*(const unsigned char *) s == (unsigned char) c)
40000eaf:	38 08                	cmp    %cl,(%eax)
40000eb1:	75 f5                	jne    40000ea8 <memchr+0x18>
            return (void *) s;
    return NULL;
}
40000eb3:	c3                   	ret    
40000eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return NULL;
40000eb8:	31 c0                	xor    %eax,%eax
}
40000eba:	c3                   	ret    
40000ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000ebf:	90                   	nop

40000ec0 <memzero>:

void *memzero(void *v, size_t n)
{
    return memset(v, 0, n);
40000ec0:	ff 74 24 08          	pushl  0x8(%esp)
40000ec4:	6a 00                	push   $0x0
40000ec6:	ff 74 24 0c          	pushl  0xc(%esp)
40000eca:	e8 a1 fe ff ff       	call   40000d70 <memset>
40000ecf:	83 c4 0c             	add    $0xc,%esp
}
40000ed2:	c3                   	ret    
40000ed3:	66 90                	xchg   %ax,%ax
40000ed5:	66 90                	xchg   %ax,%ax
40000ed7:	66 90                	xchg   %ax,%ax
40000ed9:	66 90                	xchg   %ax,%ax
40000edb:	66 90                	xchg   %ax,%ax
40000edd:	66 90                	xchg   %ax,%ax
40000edf:	90                   	nop

40000ee0 <__udivdi3>:
40000ee0:	f3 0f 1e fb          	endbr32 
40000ee4:	55                   	push   %ebp
40000ee5:	57                   	push   %edi
40000ee6:	56                   	push   %esi
40000ee7:	53                   	push   %ebx
40000ee8:	83 ec 1c             	sub    $0x1c,%esp
40000eeb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
40000eef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
40000ef3:	8b 74 24 34          	mov    0x34(%esp),%esi
40000ef7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
40000efb:	85 d2                	test   %edx,%edx
40000efd:	75 19                	jne    40000f18 <__udivdi3+0x38>
40000eff:	39 f3                	cmp    %esi,%ebx
40000f01:	76 4d                	jbe    40000f50 <__udivdi3+0x70>
40000f03:	31 ff                	xor    %edi,%edi
40000f05:	89 e8                	mov    %ebp,%eax
40000f07:	89 f2                	mov    %esi,%edx
40000f09:	f7 f3                	div    %ebx
40000f0b:	89 fa                	mov    %edi,%edx
40000f0d:	83 c4 1c             	add    $0x1c,%esp
40000f10:	5b                   	pop    %ebx
40000f11:	5e                   	pop    %esi
40000f12:	5f                   	pop    %edi
40000f13:	5d                   	pop    %ebp
40000f14:	c3                   	ret    
40000f15:	8d 76 00             	lea    0x0(%esi),%esi
40000f18:	39 f2                	cmp    %esi,%edx
40000f1a:	76 14                	jbe    40000f30 <__udivdi3+0x50>
40000f1c:	31 ff                	xor    %edi,%edi
40000f1e:	31 c0                	xor    %eax,%eax
40000f20:	89 fa                	mov    %edi,%edx
40000f22:	83 c4 1c             	add    $0x1c,%esp
40000f25:	5b                   	pop    %ebx
40000f26:	5e                   	pop    %esi
40000f27:	5f                   	pop    %edi
40000f28:	5d                   	pop    %ebp
40000f29:	c3                   	ret    
40000f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000f30:	0f bd fa             	bsr    %edx,%edi
40000f33:	83 f7 1f             	xor    $0x1f,%edi
40000f36:	75 48                	jne    40000f80 <__udivdi3+0xa0>
40000f38:	39 f2                	cmp    %esi,%edx
40000f3a:	72 06                	jb     40000f42 <__udivdi3+0x62>
40000f3c:	31 c0                	xor    %eax,%eax
40000f3e:	39 eb                	cmp    %ebp,%ebx
40000f40:	77 de                	ja     40000f20 <__udivdi3+0x40>
40000f42:	b8 01 00 00 00       	mov    $0x1,%eax
40000f47:	eb d7                	jmp    40000f20 <__udivdi3+0x40>
40000f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000f50:	89 d9                	mov    %ebx,%ecx
40000f52:	85 db                	test   %ebx,%ebx
40000f54:	75 0b                	jne    40000f61 <__udivdi3+0x81>
40000f56:	b8 01 00 00 00       	mov    $0x1,%eax
40000f5b:	31 d2                	xor    %edx,%edx
40000f5d:	f7 f3                	div    %ebx
40000f5f:	89 c1                	mov    %eax,%ecx
40000f61:	31 d2                	xor    %edx,%edx
40000f63:	89 f0                	mov    %esi,%eax
40000f65:	f7 f1                	div    %ecx
40000f67:	89 c6                	mov    %eax,%esi
40000f69:	89 e8                	mov    %ebp,%eax
40000f6b:	89 f7                	mov    %esi,%edi
40000f6d:	f7 f1                	div    %ecx
40000f6f:	89 fa                	mov    %edi,%edx
40000f71:	83 c4 1c             	add    $0x1c,%esp
40000f74:	5b                   	pop    %ebx
40000f75:	5e                   	pop    %esi
40000f76:	5f                   	pop    %edi
40000f77:	5d                   	pop    %ebp
40000f78:	c3                   	ret    
40000f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000f80:	89 f9                	mov    %edi,%ecx
40000f82:	b8 20 00 00 00       	mov    $0x20,%eax
40000f87:	29 f8                	sub    %edi,%eax
40000f89:	d3 e2                	shl    %cl,%edx
40000f8b:	89 54 24 08          	mov    %edx,0x8(%esp)
40000f8f:	89 c1                	mov    %eax,%ecx
40000f91:	89 da                	mov    %ebx,%edx
40000f93:	d3 ea                	shr    %cl,%edx
40000f95:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000f99:	09 d1                	or     %edx,%ecx
40000f9b:	89 f2                	mov    %esi,%edx
40000f9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40000fa1:	89 f9                	mov    %edi,%ecx
40000fa3:	d3 e3                	shl    %cl,%ebx
40000fa5:	89 c1                	mov    %eax,%ecx
40000fa7:	d3 ea                	shr    %cl,%edx
40000fa9:	89 f9                	mov    %edi,%ecx
40000fab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
40000faf:	89 eb                	mov    %ebp,%ebx
40000fb1:	d3 e6                	shl    %cl,%esi
40000fb3:	89 c1                	mov    %eax,%ecx
40000fb5:	d3 eb                	shr    %cl,%ebx
40000fb7:	09 de                	or     %ebx,%esi
40000fb9:	89 f0                	mov    %esi,%eax
40000fbb:	f7 74 24 08          	divl   0x8(%esp)
40000fbf:	89 d6                	mov    %edx,%esi
40000fc1:	89 c3                	mov    %eax,%ebx
40000fc3:	f7 64 24 0c          	mull   0xc(%esp)
40000fc7:	39 d6                	cmp    %edx,%esi
40000fc9:	72 15                	jb     40000fe0 <__udivdi3+0x100>
40000fcb:	89 f9                	mov    %edi,%ecx
40000fcd:	d3 e5                	shl    %cl,%ebp
40000fcf:	39 c5                	cmp    %eax,%ebp
40000fd1:	73 04                	jae    40000fd7 <__udivdi3+0xf7>
40000fd3:	39 d6                	cmp    %edx,%esi
40000fd5:	74 09                	je     40000fe0 <__udivdi3+0x100>
40000fd7:	89 d8                	mov    %ebx,%eax
40000fd9:	31 ff                	xor    %edi,%edi
40000fdb:	e9 40 ff ff ff       	jmp    40000f20 <__udivdi3+0x40>
40000fe0:	8d 43 ff             	lea    -0x1(%ebx),%eax
40000fe3:	31 ff                	xor    %edi,%edi
40000fe5:	e9 36 ff ff ff       	jmp    40000f20 <__udivdi3+0x40>
40000fea:	66 90                	xchg   %ax,%ax
40000fec:	66 90                	xchg   %ax,%ax
40000fee:	66 90                	xchg   %ax,%ax

40000ff0 <__umoddi3>:
40000ff0:	f3 0f 1e fb          	endbr32 
40000ff4:	55                   	push   %ebp
40000ff5:	57                   	push   %edi
40000ff6:	56                   	push   %esi
40000ff7:	53                   	push   %ebx
40000ff8:	83 ec 1c             	sub    $0x1c,%esp
40000ffb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
40000fff:	8b 74 24 30          	mov    0x30(%esp),%esi
40001003:	8b 5c 24 34          	mov    0x34(%esp),%ebx
40001007:	8b 7c 24 38          	mov    0x38(%esp),%edi
4000100b:	85 c0                	test   %eax,%eax
4000100d:	75 19                	jne    40001028 <__umoddi3+0x38>
4000100f:	39 df                	cmp    %ebx,%edi
40001011:	76 5d                	jbe    40001070 <__umoddi3+0x80>
40001013:	89 f0                	mov    %esi,%eax
40001015:	89 da                	mov    %ebx,%edx
40001017:	f7 f7                	div    %edi
40001019:	89 d0                	mov    %edx,%eax
4000101b:	31 d2                	xor    %edx,%edx
4000101d:	83 c4 1c             	add    $0x1c,%esp
40001020:	5b                   	pop    %ebx
40001021:	5e                   	pop    %esi
40001022:	5f                   	pop    %edi
40001023:	5d                   	pop    %ebp
40001024:	c3                   	ret    
40001025:	8d 76 00             	lea    0x0(%esi),%esi
40001028:	89 f2                	mov    %esi,%edx
4000102a:	39 d8                	cmp    %ebx,%eax
4000102c:	76 12                	jbe    40001040 <__umoddi3+0x50>
4000102e:	89 f0                	mov    %esi,%eax
40001030:	89 da                	mov    %ebx,%edx
40001032:	83 c4 1c             	add    $0x1c,%esp
40001035:	5b                   	pop    %ebx
40001036:	5e                   	pop    %esi
40001037:	5f                   	pop    %edi
40001038:	5d                   	pop    %ebp
40001039:	c3                   	ret    
4000103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40001040:	0f bd e8             	bsr    %eax,%ebp
40001043:	83 f5 1f             	xor    $0x1f,%ebp
40001046:	75 50                	jne    40001098 <__umoddi3+0xa8>
40001048:	39 d8                	cmp    %ebx,%eax
4000104a:	0f 82 e0 00 00 00    	jb     40001130 <__umoddi3+0x140>
40001050:	89 d9                	mov    %ebx,%ecx
40001052:	39 f7                	cmp    %esi,%edi
40001054:	0f 86 d6 00 00 00    	jbe    40001130 <__umoddi3+0x140>
4000105a:	89 d0                	mov    %edx,%eax
4000105c:	89 ca                	mov    %ecx,%edx
4000105e:	83 c4 1c             	add    $0x1c,%esp
40001061:	5b                   	pop    %ebx
40001062:	5e                   	pop    %esi
40001063:	5f                   	pop    %edi
40001064:	5d                   	pop    %ebp
40001065:	c3                   	ret    
40001066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000106d:	8d 76 00             	lea    0x0(%esi),%esi
40001070:	89 fd                	mov    %edi,%ebp
40001072:	85 ff                	test   %edi,%edi
40001074:	75 0b                	jne    40001081 <__umoddi3+0x91>
40001076:	b8 01 00 00 00       	mov    $0x1,%eax
4000107b:	31 d2                	xor    %edx,%edx
4000107d:	f7 f7                	div    %edi
4000107f:	89 c5                	mov    %eax,%ebp
40001081:	89 d8                	mov    %ebx,%eax
40001083:	31 d2                	xor    %edx,%edx
40001085:	f7 f5                	div    %ebp
40001087:	89 f0                	mov    %esi,%eax
40001089:	f7 f5                	div    %ebp
4000108b:	89 d0                	mov    %edx,%eax
4000108d:	31 d2                	xor    %edx,%edx
4000108f:	eb 8c                	jmp    4000101d <__umoddi3+0x2d>
40001091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001098:	89 e9                	mov    %ebp,%ecx
4000109a:	ba 20 00 00 00       	mov    $0x20,%edx
4000109f:	29 ea                	sub    %ebp,%edx
400010a1:	d3 e0                	shl    %cl,%eax
400010a3:	89 44 24 08          	mov    %eax,0x8(%esp)
400010a7:	89 d1                	mov    %edx,%ecx
400010a9:	89 f8                	mov    %edi,%eax
400010ab:	d3 e8                	shr    %cl,%eax
400010ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
400010b1:	89 54 24 04          	mov    %edx,0x4(%esp)
400010b5:	8b 54 24 04          	mov    0x4(%esp),%edx
400010b9:	09 c1                	or     %eax,%ecx
400010bb:	89 d8                	mov    %ebx,%eax
400010bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
400010c1:	89 e9                	mov    %ebp,%ecx
400010c3:	d3 e7                	shl    %cl,%edi
400010c5:	89 d1                	mov    %edx,%ecx
400010c7:	d3 e8                	shr    %cl,%eax
400010c9:	89 e9                	mov    %ebp,%ecx
400010cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
400010cf:	d3 e3                	shl    %cl,%ebx
400010d1:	89 c7                	mov    %eax,%edi
400010d3:	89 d1                	mov    %edx,%ecx
400010d5:	89 f0                	mov    %esi,%eax
400010d7:	d3 e8                	shr    %cl,%eax
400010d9:	89 e9                	mov    %ebp,%ecx
400010db:	89 fa                	mov    %edi,%edx
400010dd:	d3 e6                	shl    %cl,%esi
400010df:	09 d8                	or     %ebx,%eax
400010e1:	f7 74 24 08          	divl   0x8(%esp)
400010e5:	89 d1                	mov    %edx,%ecx
400010e7:	89 f3                	mov    %esi,%ebx
400010e9:	f7 64 24 0c          	mull   0xc(%esp)
400010ed:	89 c6                	mov    %eax,%esi
400010ef:	89 d7                	mov    %edx,%edi
400010f1:	39 d1                	cmp    %edx,%ecx
400010f3:	72 06                	jb     400010fb <__umoddi3+0x10b>
400010f5:	75 10                	jne    40001107 <__umoddi3+0x117>
400010f7:	39 c3                	cmp    %eax,%ebx
400010f9:	73 0c                	jae    40001107 <__umoddi3+0x117>
400010fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
400010ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
40001103:	89 d7                	mov    %edx,%edi
40001105:	89 c6                	mov    %eax,%esi
40001107:	89 ca                	mov    %ecx,%edx
40001109:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
4000110e:	29 f3                	sub    %esi,%ebx
40001110:	19 fa                	sbb    %edi,%edx
40001112:	89 d0                	mov    %edx,%eax
40001114:	d3 e0                	shl    %cl,%eax
40001116:	89 e9                	mov    %ebp,%ecx
40001118:	d3 eb                	shr    %cl,%ebx
4000111a:	d3 ea                	shr    %cl,%edx
4000111c:	09 d8                	or     %ebx,%eax
4000111e:	83 c4 1c             	add    $0x1c,%esp
40001121:	5b                   	pop    %ebx
40001122:	5e                   	pop    %esi
40001123:	5f                   	pop    %edi
40001124:	5d                   	pop    %ebp
40001125:	c3                   	ret    
40001126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000112d:	8d 76 00             	lea    0x0(%esi),%esi
40001130:	29 fe                	sub    %edi,%esi
40001132:	19 c3                	sbb    %eax,%ebx
40001134:	89 f2                	mov    %esi,%edx
40001136:	89 d9                	mov    %ebx,%ecx
40001138:	e9 1d ff ff ff       	jmp    4000105a <__umoddi3+0x6a>
