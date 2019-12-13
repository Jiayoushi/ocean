
obj/user/idle/idle:     file format elf32-i386


Disassembly of section .text:

40000000 <main>:
#include <syscall.h>
#include <x86.h>

int main(int argc, char **argv)
{
    while (1) {}
40000000:	eb fe                	jmp    40000000 <main>

40000002 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary.
	 */
	testl	$0x0fffffff, %esp
40000002:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
40000008:	75 04                	jne    4000000e <args_exist>

4000000a <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
4000000a:	6a 00                	push   $0x0
	pushl	$0
4000000c:	6a 00                	push   $0x0

4000000e <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
4000000e:	e8 ed ff ff ff       	call   40000000 <main>

	/* When returning, push the return value on the stack. */
	pushl	%eax
40000013:	50                   	push   %eax

40000014 <spin>:
spin:
	jmp	spin
40000014:	eb fe                	jmp    40000014 <spin>
40000016:	66 90                	xchg   %ax,%ax
40000018:	66 90                	xchg   %ax,%ax
4000001a:	66 90                	xchg   %ax,%ax
4000001c:	66 90                	xchg   %ax,%ax
4000001e:	66 90                	xchg   %ax,%ax

40000020 <debug>:
#include <proc.h>
#include <stdarg.h>
#include <stdio.h>

void debug(const char *file, int line, const char *fmt, ...)
{
40000020:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[D] %s:%d: ", file, line);
40000023:	ff 74 24 18          	pushl  0x18(%esp)
40000027:	ff 74 24 18          	pushl  0x18(%esp)
4000002b:	68 00 20 00 40       	push   $0x40002000
40000030:	e8 bb 01 00 00       	call   400001f0 <printf>
    vcprintf(fmt, ap);
40000035:	58                   	pop    %eax
40000036:	5a                   	pop    %edx
40000037:	8d 44 24 24          	lea    0x24(%esp),%eax
4000003b:	50                   	push   %eax
4000003c:	ff 74 24 24          	pushl  0x24(%esp)
40000040:	e8 4b 01 00 00       	call   40000190 <vcprintf>
    va_end(ap);
}
40000045:	83 c4 1c             	add    $0x1c,%esp
40000048:	c3                   	ret    
40000049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000050 <warn>:

void warn(const char *file, int line, const char *fmt, ...)
{
40000050:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[W] %s:%d: ", file, line);
40000053:	ff 74 24 18          	pushl  0x18(%esp)
40000057:	ff 74 24 18          	pushl  0x18(%esp)
4000005b:	68 0c 20 00 40       	push   $0x4000200c
40000060:	e8 8b 01 00 00       	call   400001f0 <printf>
    vcprintf(fmt, ap);
40000065:	58                   	pop    %eax
40000066:	5a                   	pop    %edx
40000067:	8d 44 24 24          	lea    0x24(%esp),%eax
4000006b:	50                   	push   %eax
4000006c:	ff 74 24 24          	pushl  0x24(%esp)
40000070:	e8 1b 01 00 00       	call   40000190 <vcprintf>
    va_end(ap);
}
40000075:	83 c4 1c             	add    $0x1c,%esp
40000078:	c3                   	ret    
40000079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000080 <panic>:

void panic(const char *file, int line, const char *fmt, ...)
{
40000080:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
    printf("[P] %s:%d: ", file, line);
40000083:	ff 74 24 18          	pushl  0x18(%esp)
40000087:	ff 74 24 18          	pushl  0x18(%esp)
4000008b:	68 18 20 00 40       	push   $0x40002018
40000090:	e8 5b 01 00 00       	call   400001f0 <printf>
    vcprintf(fmt, ap);
40000095:	58                   	pop    %eax
40000096:	5a                   	pop    %edx
40000097:	8d 44 24 24          	lea    0x24(%esp),%eax
4000009b:	50                   	push   %eax
4000009c:	ff 74 24 24          	pushl  0x24(%esp)
400000a0:	e8 eb 00 00 00       	call   40000190 <vcprintf>
400000a5:	83 c4 10             	add    $0x10,%esp
400000a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400000af:	90                   	nop
    va_end(ap);

    while (1)
        yield();
400000b0:	e8 6b 08 00 00       	call   40000920 <yield>
    while (1)
400000b5:	eb f9                	jmp    400000b0 <panic+0x30>
400000b7:	66 90                	xchg   %ax,%ax
400000b9:	66 90                	xchg   %ax,%ax
400000bb:	66 90                	xchg   %ax,%ax
400000bd:	66 90                	xchg   %ax,%ax
400000bf:	90                   	nop

400000c0 <atoi>:
#include <stdlib.h>

int atoi(const char *buf, int *i)
{
400000c0:	55                   	push   %ebp
400000c1:	57                   	push   %edi
400000c2:	56                   	push   %esi
400000c3:	53                   	push   %ebx
400000c4:	8b 74 24 14          	mov    0x14(%esp),%esi
    int loc = 0;
    int numstart = 0;
    int acc = 0;
    int negative = 0;
    if (buf[loc] == '+')
400000c8:	0f be 06             	movsbl (%esi),%eax
400000cb:	3c 2b                	cmp    $0x2b,%al
400000cd:	74 71                	je     40000140 <atoi+0x80>
    int negative = 0;
400000cf:	31 ed                	xor    %ebp,%ebp
    int loc = 0;
400000d1:	31 ff                	xor    %edi,%edi
        loc++;
    else if (buf[loc] == '-') {
400000d3:	3c 2d                	cmp    $0x2d,%al
400000d5:	74 49                	je     40000120 <atoi+0x60>
        negative = 1;
        loc++;
    }
    numstart = loc;
    // no grab the numbers
    while ('0' <= buf[loc] && buf[loc] <= '9') {
400000d7:	8d 50 d0             	lea    -0x30(%eax),%edx
400000da:	80 fa 09             	cmp    $0x9,%dl
400000dd:	77 57                	ja     40000136 <atoi+0x76>
400000df:	89 f9                	mov    %edi,%ecx
    int acc = 0;
400000e1:	31 d2                	xor    %edx,%edx
400000e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400000e7:	90                   	nop
        acc = acc * 10 + (buf[loc] - '0');
400000e8:	8d 14 92             	lea    (%edx,%edx,4),%edx
        loc++;
400000eb:	83 c1 01             	add    $0x1,%ecx
        acc = acc * 10 + (buf[loc] - '0');
400000ee:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
    while ('0' <= buf[loc] && buf[loc] <= '9') {
400000f2:	0f be 04 0e          	movsbl (%esi,%ecx,1),%eax
400000f6:	8d 58 d0             	lea    -0x30(%eax),%ebx
400000f9:	80 fb 09             	cmp    $0x9,%bl
400000fc:	76 ea                	jbe    400000e8 <atoi+0x28>
    }
    if (numstart == loc) {
400000fe:	39 cf                	cmp    %ecx,%edi
40000100:	74 34                	je     40000136 <atoi+0x76>
        // no numbers have actually been scanned
        return 0;
    }
    if (negative)
        acc = -acc;
40000102:	89 d0                	mov    %edx,%eax
40000104:	f7 d8                	neg    %eax
40000106:	85 ed                	test   %ebp,%ebp
40000108:	0f 45 d0             	cmovne %eax,%edx
    *i = acc;
4000010b:	8b 44 24 18          	mov    0x18(%esp),%eax
4000010f:	89 10                	mov    %edx,(%eax)
    return loc;
}
40000111:	89 c8                	mov    %ecx,%eax
40000113:	5b                   	pop    %ebx
40000114:	5e                   	pop    %esi
40000115:	5f                   	pop    %edi
40000116:	5d                   	pop    %ebp
40000117:	c3                   	ret    
40000118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000011f:	90                   	nop
        loc++;
40000120:	0f be 46 01          	movsbl 0x1(%esi),%eax
        negative = 1;
40000124:	bd 01 00 00 00       	mov    $0x1,%ebp
        loc++;
40000129:	bf 01 00 00 00       	mov    $0x1,%edi
    while ('0' <= buf[loc] && buf[loc] <= '9') {
4000012e:	8d 50 d0             	lea    -0x30(%eax),%edx
40000131:	80 fa 09             	cmp    $0x9,%dl
40000134:	76 a9                	jbe    400000df <atoi+0x1f>
        return 0;
40000136:	31 c9                	xor    %ecx,%ecx
}
40000138:	5b                   	pop    %ebx
40000139:	5e                   	pop    %esi
4000013a:	89 c8                	mov    %ecx,%eax
4000013c:	5f                   	pop    %edi
4000013d:	5d                   	pop    %ebp
4000013e:	c3                   	ret    
4000013f:	90                   	nop
40000140:	0f be 46 01          	movsbl 0x1(%esi),%eax
    int negative = 0;
40000144:	31 ed                	xor    %ebp,%ebp
        loc++;
40000146:	bf 01 00 00 00       	mov    $0x1,%edi
4000014b:	eb 8a                	jmp    400000d7 <atoi+0x17>
4000014d:	66 90                	xchg   %ax,%ax
4000014f:	90                   	nop

40000150 <putch>:
    int cnt;            // total bytes printed so far
    char buf[MAX_BUF];
};

static void putch(int ch, struct printbuf *b)
{
40000150:	53                   	push   %ebx
40000151:	8b 54 24 0c          	mov    0xc(%esp),%edx
    b->buf[b->idx++] = ch;
40000155:	0f b6 5c 24 08       	movzbl 0x8(%esp),%ebx
4000015a:	8b 02                	mov    (%edx),%eax
4000015c:	8d 48 01             	lea    0x1(%eax),%ecx
4000015f:	89 0a                	mov    %ecx,(%edx)
40000161:	88 5c 02 08          	mov    %bl,0x8(%edx,%eax,1)
    if (b->idx == MAX_BUF - 1) {
40000165:	81 f9 ff 01 00 00    	cmp    $0x1ff,%ecx
4000016b:	75 14                	jne    40000181 <putch+0x31>
        b->buf[b->idx] = 0;
4000016d:	c6 82 07 02 00 00 00 	movb   $0x0,0x207(%edx)
        puts(b->buf, b->idx);
40000174:	8d 5a 08             	lea    0x8(%edx),%ebx

#include "time.h"

static gcc_inline void sys_puts(const char *s, size_t len)
{
    asm volatile ("int %0"
40000177:	31 c0                	xor    %eax,%eax
40000179:	cd 30                	int    $0x30
        b->idx = 0;
4000017b:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    }
    b->cnt++;
40000181:	83 42 04 01          	addl   $0x1,0x4(%edx)
}
40000185:	5b                   	pop    %ebx
40000186:	c3                   	ret    
40000187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000018e:	66 90                	xchg   %ax,%ax

40000190 <vcprintf>:

int vcprintf(const char *fmt, va_list ap)
{
40000190:	53                   	push   %ebx
40000191:	81 ec 18 02 00 00    	sub    $0x218,%esp
    struct printbuf b;

    b.idx = 0;
40000197:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
4000019e:	00 
    b.cnt = 0;
4000019f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400001a6:	00 
    vprintfmt((void *) putch, &b, fmt, ap);
400001a7:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
400001ae:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
400001b5:	8d 44 24 10          	lea    0x10(%esp),%eax
400001b9:	50                   	push   %eax
400001ba:	68 50 01 00 40       	push   $0x40000150
400001bf:	e8 3c 01 00 00       	call   40000300 <vprintfmt>

    b.buf[b.idx] = 0;
400001c4:	8b 4c 24 18          	mov    0x18(%esp),%ecx
400001c8:	8d 5c 24 20          	lea    0x20(%esp),%ebx
400001cc:	31 c0                	xor    %eax,%eax
400001ce:	c6 44 0c 20 00       	movb   $0x0,0x20(%esp,%ecx,1)
400001d3:	cd 30                	int    $0x30
    puts(b.buf, b.idx);

    return b.cnt;
}
400001d5:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400001d9:	81 c4 28 02 00 00    	add    $0x228,%esp
400001df:	5b                   	pop    %ebx
400001e0:	c3                   	ret    
400001e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400001e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400001ef:	90                   	nop

400001f0 <printf>:

int printf(const char *fmt, ...)
{
400001f0:	83 ec 14             	sub    $0x14,%esp
    va_list ap;
    int cnt;

    va_start(ap, fmt);
    cnt = vcprintf(fmt, ap);
400001f3:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400001f7:	50                   	push   %eax
400001f8:	ff 74 24 1c          	pushl  0x1c(%esp)
400001fc:	e8 8f ff ff ff       	call   40000190 <vcprintf>
    va_end(ap);

    return cnt;
}
40000201:	83 c4 1c             	add    $0x1c,%esp
40000204:	c3                   	ret    
40000205:	66 90                	xchg   %ax,%ax
40000207:	66 90                	xchg   %ax,%ax
40000209:	66 90                	xchg   %ax,%ax
4000020b:	66 90                	xchg   %ax,%ax
4000020d:	66 90                	xchg   %ax,%ax
4000020f:	90                   	nop

40000210 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void *), void *putdat,
         unsigned long long num, unsigned base, int width, int padc)
{
40000210:	55                   	push   %ebp
40000211:	57                   	push   %edi
40000212:	56                   	push   %esi
40000213:	89 d6                	mov    %edx,%esi
40000215:	53                   	push   %ebx
40000216:	89 c3                	mov    %eax,%ebx
40000218:	83 ec 1c             	sub    $0x1c,%esp
4000021b:	8b 54 24 30          	mov    0x30(%esp),%edx
4000021f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
40000223:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
4000022a:	00 
{
4000022b:	8b 44 24 38          	mov    0x38(%esp),%eax
    if (num >= base) {
4000022f:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
{
40000233:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
40000237:	8b 7c 24 40          	mov    0x40(%esp),%edi
4000023b:	83 ed 01             	sub    $0x1,%ebp
    if (num >= base) {
4000023e:	39 c2                	cmp    %eax,%edx
40000240:	1b 4c 24 04          	sbb    0x4(%esp),%ecx
{
40000244:	89 54 24 08          	mov    %edx,0x8(%esp)
    if (num >= base) {
40000248:	89 04 24             	mov    %eax,(%esp)
4000024b:	73 53                	jae    400002a0 <printnum+0x90>
        printnum(putch, putdat, num / base, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (--width > 0)
4000024d:	85 ed                	test   %ebp,%ebp
4000024f:	7e 16                	jle    40000267 <printnum+0x57>
40000251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch(padc, putdat);
40000258:	83 ec 08             	sub    $0x8,%esp
4000025b:	56                   	push   %esi
4000025c:	57                   	push   %edi
4000025d:	ff d3                	call   *%ebx
        while (--width > 0)
4000025f:	83 c4 10             	add    $0x10,%esp
40000262:	83 ed 01             	sub    $0x1,%ebp
40000265:	75 f1                	jne    40000258 <printnum+0x48>
    }

    // then print this (the least significant) digit
    putch("0123456789abcdef"[num % base], putdat);
40000267:	89 74 24 34          	mov    %esi,0x34(%esp)
4000026b:	ff 74 24 04          	pushl  0x4(%esp)
4000026f:	ff 74 24 04          	pushl  0x4(%esp)
40000273:	ff 74 24 14          	pushl  0x14(%esp)
40000277:	ff 74 24 14          	pushl  0x14(%esp)
4000027b:	e8 00 0d 00 00       	call   40000f80 <__umoddi3>
40000280:	0f be 80 24 20 00 40 	movsbl 0x40002024(%eax),%eax
40000287:	89 44 24 40          	mov    %eax,0x40(%esp)
}
4000028b:	83 c4 2c             	add    $0x2c,%esp
    putch("0123456789abcdef"[num % base], putdat);
4000028e:	89 d8                	mov    %ebx,%eax
}
40000290:	5b                   	pop    %ebx
40000291:	5e                   	pop    %esi
40000292:	5f                   	pop    %edi
40000293:	5d                   	pop    %ebp
    putch("0123456789abcdef"[num % base], putdat);
40000294:	ff e0                	jmp    *%eax
40000296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000029d:	8d 76 00             	lea    0x0(%esi),%esi
        printnum(putch, putdat, num / base, base, width - 1, padc);
400002a0:	83 ec 0c             	sub    $0xc,%esp
400002a3:	57                   	push   %edi
400002a4:	55                   	push   %ebp
400002a5:	50                   	push   %eax
400002a6:	83 ec 08             	sub    $0x8,%esp
400002a9:	ff 74 24 24          	pushl  0x24(%esp)
400002ad:	ff 74 24 24          	pushl  0x24(%esp)
400002b1:	ff 74 24 34          	pushl  0x34(%esp)
400002b5:	ff 74 24 34          	pushl  0x34(%esp)
400002b9:	e8 b2 0b 00 00       	call   40000e70 <__udivdi3>
400002be:	83 c4 18             	add    $0x18,%esp
400002c1:	52                   	push   %edx
400002c2:	89 f2                	mov    %esi,%edx
400002c4:	50                   	push   %eax
400002c5:	89 d8                	mov    %ebx,%eax
400002c7:	e8 44 ff ff ff       	call   40000210 <printnum>
400002cc:	83 c4 20             	add    $0x20,%esp
400002cf:	eb 96                	jmp    40000267 <printnum+0x57>
400002d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400002d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400002df:	90                   	nop

400002e0 <sprintputch>:
    char *ebuf;
    int cnt;
};

static void sprintputch(int ch, struct sprintbuf *b)
{
400002e0:	8b 44 24 08          	mov    0x8(%esp),%eax
    b->cnt++;
400002e4:	83 40 08 01          	addl   $0x1,0x8(%eax)
    if (b->buf < b->ebuf)
400002e8:	8b 10                	mov    (%eax),%edx
400002ea:	3b 50 04             	cmp    0x4(%eax),%edx
400002ed:	73 0b                	jae    400002fa <sprintputch+0x1a>
        *b->buf++ = ch;
400002ef:	8d 4a 01             	lea    0x1(%edx),%ecx
400002f2:	89 08                	mov    %ecx,(%eax)
400002f4:	8b 44 24 04          	mov    0x4(%esp),%eax
400002f8:	88 02                	mov    %al,(%edx)
}
400002fa:	c3                   	ret    
400002fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400002ff:	90                   	nop

40000300 <vprintfmt>:
{
40000300:	55                   	push   %ebp
40000301:	57                   	push   %edi
40000302:	56                   	push   %esi
40000303:	53                   	push   %ebx
40000304:	83 ec 2c             	sub    $0x2c,%esp
40000307:	8b 74 24 40          	mov    0x40(%esp),%esi
4000030b:	8b 6c 24 44          	mov    0x44(%esp),%ebp
4000030f:	8b 7c 24 48          	mov    0x48(%esp),%edi
        while ((ch = *(unsigned char *) fmt++) != '%') {
40000313:	0f b6 07             	movzbl (%edi),%eax
40000316:	8d 5f 01             	lea    0x1(%edi),%ebx
40000319:	83 f8 25             	cmp    $0x25,%eax
4000031c:	75 18                	jne    40000336 <vprintfmt+0x36>
4000031e:	eb 28                	jmp    40000348 <vprintfmt+0x48>
            putch(ch, putdat);
40000320:	83 ec 08             	sub    $0x8,%esp
        while ((ch = *(unsigned char *) fmt++) != '%') {
40000323:	83 c3 01             	add    $0x1,%ebx
            putch(ch, putdat);
40000326:	55                   	push   %ebp
40000327:	50                   	push   %eax
40000328:	ff d6                	call   *%esi
        while ((ch = *(unsigned char *) fmt++) != '%') {
4000032a:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
4000032e:	83 c4 10             	add    $0x10,%esp
40000331:	83 f8 25             	cmp    $0x25,%eax
40000334:	74 12                	je     40000348 <vprintfmt+0x48>
            if (ch == '\0')
40000336:	85 c0                	test   %eax,%eax
40000338:	75 e6                	jne    40000320 <vprintfmt+0x20>
}
4000033a:	83 c4 2c             	add    $0x2c,%esp
4000033d:	5b                   	pop    %ebx
4000033e:	5e                   	pop    %esi
4000033f:	5f                   	pop    %edi
40000340:	5d                   	pop    %ebp
40000341:	c3                   	ret    
40000342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        padc = ' ';
40000348:	c6 44 24 10 20       	movb   $0x20,0x10(%esp)
        precision = -1;
4000034d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
        altflag = 0;
40000352:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
40000359:	00 
        width = -1;
4000035a:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
40000361:	ff 
        lflag = 0;
40000362:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
40000369:	00 
        switch (ch = *(unsigned char *) fmt++) {
4000036a:	0f b6 0b             	movzbl (%ebx),%ecx
4000036d:	8d 7b 01             	lea    0x1(%ebx),%edi
40000370:	8d 41 dd             	lea    -0x23(%ecx),%eax
40000373:	3c 55                	cmp    $0x55,%al
40000375:	77 11                	ja     40000388 <vprintfmt+0x88>
40000377:	0f b6 c0             	movzbl %al,%eax
4000037a:	ff 24 85 3c 20 00 40 	jmp    *0x4000203c(,%eax,4)
40000381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch('%', putdat);
40000388:	83 ec 08             	sub    $0x8,%esp
            for (fmt--; fmt[-1] != '%'; fmt--)
4000038b:	89 df                	mov    %ebx,%edi
            putch('%', putdat);
4000038d:	55                   	push   %ebp
4000038e:	6a 25                	push   $0x25
40000390:	ff d6                	call   *%esi
            for (fmt--; fmt[-1] != '%'; fmt--)
40000392:	83 c4 10             	add    $0x10,%esp
40000395:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
40000399:	0f 84 74 ff ff ff    	je     40000313 <vprintfmt+0x13>
4000039f:	90                   	nop
400003a0:	83 ef 01             	sub    $0x1,%edi
400003a3:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
400003a7:	75 f7                	jne    400003a0 <vprintfmt+0xa0>
400003a9:	e9 65 ff ff ff       	jmp    40000313 <vprintfmt+0x13>
400003ae:	66 90                	xchg   %ax,%ax
                ch = *fmt;
400003b0:	0f be 43 01          	movsbl 0x1(%ebx),%eax
        switch (ch = *(unsigned char *) fmt++) {
400003b4:	0f b6 d1             	movzbl %cl,%edx
400003b7:	89 fb                	mov    %edi,%ebx
                precision = precision * 10 + ch - '0';
400003b9:	83 ea 30             	sub    $0x30,%edx
                if (ch < '0' || ch > '9')
400003bc:	8d 48 d0             	lea    -0x30(%eax),%ecx
400003bf:	83 f9 09             	cmp    $0x9,%ecx
400003c2:	77 19                	ja     400003dd <vprintfmt+0xdd>
400003c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (precision = 0;; ++fmt) {
400003c8:	83 c3 01             	add    $0x1,%ebx
                precision = precision * 10 + ch - '0';
400003cb:	8d 14 92             	lea    (%edx,%edx,4),%edx
400003ce:	8d 54 50 d0          	lea    -0x30(%eax,%edx,2),%edx
                ch = *fmt;
400003d2:	0f be 03             	movsbl (%ebx),%eax
                if (ch < '0' || ch > '9')
400003d5:	8d 48 d0             	lea    -0x30(%eax),%ecx
400003d8:	83 f9 09             	cmp    $0x9,%ecx
400003db:	76 eb                	jbe    400003c8 <vprintfmt+0xc8>
            if (width < 0)
400003dd:	8b 7c 24 04          	mov    0x4(%esp),%edi
400003e1:	85 ff                	test   %edi,%edi
400003e3:	79 85                	jns    4000036a <vprintfmt+0x6a>
                width = precision, precision = -1;
400003e5:	89 54 24 04          	mov    %edx,0x4(%esp)
400003e9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
400003ee:	e9 77 ff ff ff       	jmp    4000036a <vprintfmt+0x6a>
            altflag = 1;
400003f3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
400003fa:	00 
        switch (ch = *(unsigned char *) fmt++) {
400003fb:	89 fb                	mov    %edi,%ebx
            goto reswitch;
400003fd:	e9 68 ff ff ff       	jmp    4000036a <vprintfmt+0x6a>
            putch(ch, putdat);
40000402:	83 ec 08             	sub    $0x8,%esp
40000405:	55                   	push   %ebp
40000406:	6a 25                	push   $0x25
40000408:	ff d6                	call   *%esi
            break;
4000040a:	83 c4 10             	add    $0x10,%esp
4000040d:	e9 01 ff ff ff       	jmp    40000313 <vprintfmt+0x13>
            precision = va_arg(ap, int);
40000412:	8b 44 24 4c          	mov    0x4c(%esp),%eax
        switch (ch = *(unsigned char *) fmt++) {
40000416:	89 fb                	mov    %edi,%ebx
            precision = va_arg(ap, int);
40000418:	8b 10                	mov    (%eax),%edx
4000041a:	83 c0 04             	add    $0x4,%eax
4000041d:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto process_precision;
40000421:	eb ba                	jmp    400003dd <vprintfmt+0xdd>
            if (width < 0)
40000423:	8b 44 24 04          	mov    0x4(%esp),%eax
40000427:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (ch = *(unsigned char *) fmt++) {
4000042c:	89 fb                	mov    %edi,%ebx
4000042e:	85 c0                	test   %eax,%eax
40000430:	0f 49 c8             	cmovns %eax,%ecx
40000433:	89 4c 24 04          	mov    %ecx,0x4(%esp)
            goto reswitch;
40000437:	e9 2e ff ff ff       	jmp    4000036a <vprintfmt+0x6a>
            putch(va_arg(ap, int), putdat);
4000043c:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000440:	83 ec 08             	sub    $0x8,%esp
40000443:	55                   	push   %ebp
40000444:	8d 58 04             	lea    0x4(%eax),%ebx
40000447:	8b 44 24 58          	mov    0x58(%esp),%eax
4000044b:	ff 30                	pushl  (%eax)
4000044d:	ff d6                	call   *%esi
4000044f:	89 5c 24 5c          	mov    %ebx,0x5c(%esp)
            break;
40000453:	83 c4 10             	add    $0x10,%esp
40000456:	e9 b8 fe ff ff       	jmp    40000313 <vprintfmt+0x13>
        return va_arg(*ap, unsigned long long);
4000045b:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
4000045f:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, unsigned long long);
40000464:	8b 10                	mov    (%eax),%edx
    if (lflag >= 2)
40000466:	0f 8f c1 01 00 00    	jg     4000062d <vprintfmt+0x32d>
        return va_arg(*ap, unsigned long);
4000046c:	83 c0 04             	add    $0x4,%eax
4000046f:	31 c9                	xor    %ecx,%ecx
40000471:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000475:	b8 0a 00 00 00       	mov    $0xa,%eax
4000047a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            printnum(putch, putdat, num, base, width, padc);
40000480:	83 ec 0c             	sub    $0xc,%esp
40000483:	0f be 5c 24 1c       	movsbl 0x1c(%esp),%ebx
40000488:	53                   	push   %ebx
40000489:	ff 74 24 14          	pushl  0x14(%esp)
4000048d:	50                   	push   %eax
4000048e:	89 f0                	mov    %esi,%eax
40000490:	51                   	push   %ecx
40000491:	52                   	push   %edx
40000492:	89 ea                	mov    %ebp,%edx
40000494:	e8 77 fd ff ff       	call   40000210 <printnum>
            break;
40000499:	83 c4 20             	add    $0x20,%esp
4000049c:	e9 72 fe ff ff       	jmp    40000313 <vprintfmt+0x13>
            putch('0', putdat);
400004a1:	83 ec 08             	sub    $0x8,%esp
400004a4:	55                   	push   %ebp
400004a5:	6a 30                	push   $0x30
400004a7:	ff d6                	call   *%esi
            putch('x', putdat);
400004a9:	58                   	pop    %eax
400004aa:	5a                   	pop    %edx
400004ab:	55                   	push   %ebp
400004ac:	6a 78                	push   $0x78
400004ae:	ff d6                	call   *%esi
            num = (unsigned long long)
400004b0:	8b 44 24 5c          	mov    0x5c(%esp),%eax
400004b4:	31 c9                	xor    %ecx,%ecx
            goto number;
400004b6:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)
400004b9:	8b 10                	mov    (%eax),%edx
                (uintptr_t) va_arg(ap, void *);
400004bb:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400004bf:	83 c0 04             	add    $0x4,%eax
400004c2:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto number;
400004c6:	b8 10 00 00 00       	mov    $0x10,%eax
400004cb:	eb b3                	jmp    40000480 <vprintfmt+0x180>
        return va_arg(*ap, unsigned long long);
400004cd:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
400004d1:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, unsigned long long);
400004d6:	8b 10                	mov    (%eax),%edx
    if (lflag >= 2)
400004d8:	0f 8f 63 01 00 00    	jg     40000641 <vprintfmt+0x341>
        return va_arg(*ap, unsigned long);
400004de:	83 c0 04             	add    $0x4,%eax
400004e1:	31 c9                	xor    %ecx,%ecx
400004e3:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400004e7:	b8 10 00 00 00       	mov    $0x10,%eax
400004ec:	eb 92                	jmp    40000480 <vprintfmt+0x180>
    if (lflag >= 2)
400004ee:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
        return va_arg(*ap, long long);
400004f3:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
400004f7:	0f 8f 58 01 00 00    	jg     40000655 <vprintfmt+0x355>
        return va_arg(*ap, long);
400004fd:	8b 4c 24 4c          	mov    0x4c(%esp),%ecx
40000501:	83 c0 04             	add    $0x4,%eax
40000504:	8b 11                	mov    (%ecx),%edx
40000506:	89 44 24 4c          	mov    %eax,0x4c(%esp)
4000050a:	89 d3                	mov    %edx,%ebx
4000050c:	89 d1                	mov    %edx,%ecx
4000050e:	c1 fb 1f             	sar    $0x1f,%ebx
            if ((long long) num < 0) {
40000511:	85 db                	test   %ebx,%ebx
40000513:	0f 88 65 01 00 00    	js     4000067e <vprintfmt+0x37e>
            num = getint(&ap, lflag);
40000519:	89 ca                	mov    %ecx,%edx
4000051b:	b8 0a 00 00 00       	mov    $0xa,%eax
40000520:	89 d9                	mov    %ebx,%ecx
40000522:	e9 59 ff ff ff       	jmp    40000480 <vprintfmt+0x180>
            lflag++;
40000527:	83 44 24 14 01       	addl   $0x1,0x14(%esp)
        switch (ch = *(unsigned char *) fmt++) {
4000052c:	89 fb                	mov    %edi,%ebx
            goto reswitch;
4000052e:	e9 37 fe ff ff       	jmp    4000036a <vprintfmt+0x6a>
            putch('X', putdat);
40000533:	83 ec 08             	sub    $0x8,%esp
40000536:	55                   	push   %ebp
40000537:	6a 58                	push   $0x58
40000539:	ff d6                	call   *%esi
            putch('X', putdat);
4000053b:	59                   	pop    %ecx
4000053c:	5b                   	pop    %ebx
4000053d:	55                   	push   %ebp
4000053e:	6a 58                	push   $0x58
40000540:	ff d6                	call   *%esi
            putch('X', putdat);
40000542:	58                   	pop    %eax
40000543:	5a                   	pop    %edx
40000544:	55                   	push   %ebp
40000545:	6a 58                	push   $0x58
40000547:	ff d6                	call   *%esi
            break;
40000549:	83 c4 10             	add    $0x10,%esp
4000054c:	e9 c2 fd ff ff       	jmp    40000313 <vprintfmt+0x13>
            if ((p = va_arg(ap, char *)) == NULL)
40000551:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000555:	8b 4c 24 04          	mov    0x4(%esp),%ecx
40000559:	83 c0 04             	add    $0x4,%eax
4000055c:	80 7c 24 10 2d       	cmpb   $0x2d,0x10(%esp)
40000561:	89 44 24 14          	mov    %eax,0x14(%esp)
40000565:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000569:	8b 18                	mov    (%eax),%ebx
4000056b:	0f 95 c0             	setne  %al
4000056e:	85 c9                	test   %ecx,%ecx
40000570:	0f 9f c1             	setg   %cl
40000573:	21 c8                	and    %ecx,%eax
40000575:	85 db                	test   %ebx,%ebx
40000577:	0f 84 31 01 00 00    	je     400006ae <vprintfmt+0x3ae>
            if (width > 0 && padc != '-')
4000057d:	8d 4b 01             	lea    0x1(%ebx),%ecx
40000580:	84 c0                	test   %al,%al
40000582:	0f 85 5b 01 00 00    	jne    400006e3 <vprintfmt+0x3e3>
                 (ch = *p++) != '\0' && (precision < 0
40000588:	0f be 1b             	movsbl (%ebx),%ebx
4000058b:	89 d8                	mov    %ebx,%eax
            for (;
4000058d:	85 db                	test   %ebx,%ebx
4000058f:	74 72                	je     40000603 <vprintfmt+0x303>
40000591:	89 5c 24 10          	mov    %ebx,0x10(%esp)
40000595:	89 cb                	mov    %ecx,%ebx
40000597:	8b 4c 24 10          	mov    0x10(%esp),%ecx
4000059b:	89 74 24 40          	mov    %esi,0x40(%esp)
4000059f:	89 d6                	mov    %edx,%esi
400005a1:	89 7c 24 48          	mov    %edi,0x48(%esp)
400005a5:	8b 7c 24 04          	mov    0x4(%esp),%edi
400005a9:	eb 2a                	jmp    400005d5 <vprintfmt+0x2d5>
400005ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400005af:	90                   	nop
                if (altflag && (ch < ' ' || ch > '~'))
400005b0:	83 e8 20             	sub    $0x20,%eax
400005b3:	83 f8 5e             	cmp    $0x5e,%eax
400005b6:	76 31                	jbe    400005e9 <vprintfmt+0x2e9>
                    putch('?', putdat);
400005b8:	83 ec 08             	sub    $0x8,%esp
400005bb:	55                   	push   %ebp
400005bc:	6a 3f                	push   $0x3f
400005be:	ff 54 24 50          	call   *0x50(%esp)
400005c2:	83 c4 10             	add    $0x10,%esp
                 (ch = *p++) != '\0' && (precision < 0
400005c5:	0f be 03             	movsbl (%ebx),%eax
400005c8:	83 c3 01             	add    $0x1,%ebx
                                         || --precision >= 0); width--)
400005cb:	83 ef 01             	sub    $0x1,%edi
                 (ch = *p++) != '\0' && (precision < 0
400005ce:	0f be c8             	movsbl %al,%ecx
            for (;
400005d1:	85 c9                	test   %ecx,%ecx
400005d3:	74 22                	je     400005f7 <vprintfmt+0x2f7>
                 (ch = *p++) != '\0' && (precision < 0
400005d5:	85 f6                	test   %esi,%esi
400005d7:	78 08                	js     400005e1 <vprintfmt+0x2e1>
                                         || --precision >= 0); width--)
400005d9:	83 ee 01             	sub    $0x1,%esi
400005dc:	83 fe ff             	cmp    $0xffffffff,%esi
400005df:	74 16                	je     400005f7 <vprintfmt+0x2f7>
                if (altflag && (ch < ' ' || ch > '~'))
400005e1:	8b 54 24 08          	mov    0x8(%esp),%edx
400005e5:	85 d2                	test   %edx,%edx
400005e7:	75 c7                	jne    400005b0 <vprintfmt+0x2b0>
                    putch(ch, putdat);
400005e9:	83 ec 08             	sub    $0x8,%esp
400005ec:	55                   	push   %ebp
400005ed:	51                   	push   %ecx
400005ee:	ff 54 24 50          	call   *0x50(%esp)
400005f2:	83 c4 10             	add    $0x10,%esp
400005f5:	eb ce                	jmp    400005c5 <vprintfmt+0x2c5>
400005f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
400005fb:	8b 74 24 40          	mov    0x40(%esp),%esi
400005ff:	8b 7c 24 48          	mov    0x48(%esp),%edi
            for (; width > 0; width--)
40000603:	8b 4c 24 04          	mov    0x4(%esp),%ecx
40000607:	8b 5c 24 04          	mov    0x4(%esp),%ebx
4000060b:	85 c9                	test   %ecx,%ecx
4000060d:	7e 11                	jle    40000620 <vprintfmt+0x320>
4000060f:	90                   	nop
                putch(' ', putdat);
40000610:	83 ec 08             	sub    $0x8,%esp
40000613:	55                   	push   %ebp
40000614:	6a 20                	push   $0x20
40000616:	ff d6                	call   *%esi
            for (; width > 0; width--)
40000618:	83 c4 10             	add    $0x10,%esp
4000061b:	83 eb 01             	sub    $0x1,%ebx
4000061e:	75 f0                	jne    40000610 <vprintfmt+0x310>
            if ((p = va_arg(ap, char *)) == NULL)
40000620:	8b 44 24 14          	mov    0x14(%esp),%eax
40000624:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000628:	e9 e6 fc ff ff       	jmp    40000313 <vprintfmt+0x13>
        return va_arg(*ap, unsigned long long);
4000062d:	8b 48 04             	mov    0x4(%eax),%ecx
40000630:	83 c0 08             	add    $0x8,%eax
40000633:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000637:	b8 0a 00 00 00       	mov    $0xa,%eax
4000063c:	e9 3f fe ff ff       	jmp    40000480 <vprintfmt+0x180>
40000641:	8b 48 04             	mov    0x4(%eax),%ecx
40000644:	83 c0 08             	add    $0x8,%eax
40000647:	89 44 24 4c          	mov    %eax,0x4c(%esp)
4000064b:	b8 10 00 00 00       	mov    $0x10,%eax
40000650:	e9 2b fe ff ff       	jmp    40000480 <vprintfmt+0x180>
        return va_arg(*ap, long long);
40000655:	8b 08                	mov    (%eax),%ecx
40000657:	8b 58 04             	mov    0x4(%eax),%ebx
4000065a:	83 c0 08             	add    $0x8,%eax
4000065d:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000661:	e9 ab fe ff ff       	jmp    40000511 <vprintfmt+0x211>
            padc = '-';
40000666:	c6 44 24 10 2d       	movb   $0x2d,0x10(%esp)
        switch (ch = *(unsigned char *) fmt++) {
4000066b:	89 fb                	mov    %edi,%ebx
4000066d:	e9 f8 fc ff ff       	jmp    4000036a <vprintfmt+0x6a>
40000672:	c6 44 24 10 30       	movb   $0x30,0x10(%esp)
40000677:	89 fb                	mov    %edi,%ebx
40000679:	e9 ec fc ff ff       	jmp    4000036a <vprintfmt+0x6a>
4000067e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
                putch('-', putdat);
40000682:	83 ec 08             	sub    $0x8,%esp
40000685:	89 5c 24 14          	mov    %ebx,0x14(%esp)
40000689:	55                   	push   %ebp
4000068a:	6a 2d                	push   $0x2d
4000068c:	ff d6                	call   *%esi
                num = -(long long) num;
4000068e:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000692:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
40000696:	b8 0a 00 00 00       	mov    $0xa,%eax
4000069b:	89 ca                	mov    %ecx,%edx
4000069d:	89 d9                	mov    %ebx,%ecx
4000069f:	f7 da                	neg    %edx
400006a1:	83 d1 00             	adc    $0x0,%ecx
400006a4:	83 c4 10             	add    $0x10,%esp
400006a7:	f7 d9                	neg    %ecx
400006a9:	e9 d2 fd ff ff       	jmp    40000480 <vprintfmt+0x180>
                 (ch = *p++) != '\0' && (precision < 0
400006ae:	bb 28 00 00 00       	mov    $0x28,%ebx
400006b3:	b9 36 20 00 40       	mov    $0x40002036,%ecx
            if (width > 0 && padc != '-')
400006b8:	84 c0                	test   %al,%al
400006ba:	0f 85 9d 00 00 00    	jne    4000075d <vprintfmt+0x45d>
400006c0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
                 (ch = *p++) != '\0' && (precision < 0
400006c4:	b8 28 00 00 00       	mov    $0x28,%eax
400006c9:	89 cb                	mov    %ecx,%ebx
400006cb:	b9 28 00 00 00       	mov    $0x28,%ecx
400006d0:	89 74 24 40          	mov    %esi,0x40(%esp)
400006d4:	89 d6                	mov    %edx,%esi
400006d6:	89 7c 24 48          	mov    %edi,0x48(%esp)
400006da:	8b 7c 24 04          	mov    0x4(%esp),%edi
400006de:	e9 f2 fe ff ff       	jmp    400005d5 <vprintfmt+0x2d5>
400006e3:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
                for (width -= strnlen(p, precision); width > 0; width--)
400006e7:	83 ec 08             	sub    $0x8,%esp
400006ea:	52                   	push   %edx
400006eb:	89 54 24 24          	mov    %edx,0x24(%esp)
400006ef:	53                   	push   %ebx
400006f0:	e8 eb 02 00 00       	call   400009e0 <strnlen>
400006f5:	29 44 24 14          	sub    %eax,0x14(%esp)
400006f9:	8b 4c 24 14          	mov    0x14(%esp),%ecx
400006fd:	83 c4 10             	add    $0x10,%esp
40000700:	8b 54 24 18          	mov    0x18(%esp),%edx
40000704:	85 c9                	test   %ecx,%ecx
40000706:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
4000070a:	7e 3e                	jle    4000074a <vprintfmt+0x44a>
4000070c:	0f be 44 24 10       	movsbl 0x10(%esp),%eax
40000711:	89 4c 24 18          	mov    %ecx,0x18(%esp)
40000715:	89 54 24 10          	mov    %edx,0x10(%esp)
40000719:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
4000071d:	8b 5c 24 04          	mov    0x4(%esp),%ebx
40000721:	89 7c 24 48          	mov    %edi,0x48(%esp)
40000725:	89 c7                	mov    %eax,%edi
                    putch(padc, putdat);
40000727:	83 ec 08             	sub    $0x8,%esp
4000072a:	55                   	push   %ebp
4000072b:	57                   	push   %edi
4000072c:	ff d6                	call   *%esi
                for (width -= strnlen(p, precision); width > 0; width--)
4000072e:	83 c4 10             	add    $0x10,%esp
40000731:	83 eb 01             	sub    $0x1,%ebx
40000734:	75 f1                	jne    40000727 <vprintfmt+0x427>
40000736:	8b 54 24 10          	mov    0x10(%esp),%edx
4000073a:	8b 4c 24 18          	mov    0x18(%esp),%ecx
4000073e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
40000742:	8b 7c 24 48          	mov    0x48(%esp),%edi
40000746:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
                 (ch = *p++) != '\0' && (precision < 0
4000074a:	0f be 03             	movsbl (%ebx),%eax
4000074d:	0f be d8             	movsbl %al,%ebx
            for (;
40000750:	85 db                	test   %ebx,%ebx
40000752:	0f 85 39 fe ff ff    	jne    40000591 <vprintfmt+0x291>
40000758:	e9 c3 fe ff ff       	jmp    40000620 <vprintfmt+0x320>
                for (width -= strnlen(p, precision); width > 0; width--)
4000075d:	83 ec 08             	sub    $0x8,%esp
                p = "(null)";
40000760:	bb 35 20 00 40       	mov    $0x40002035,%ebx
                for (width -= strnlen(p, precision); width > 0; width--)
40000765:	52                   	push   %edx
40000766:	89 54 24 24          	mov    %edx,0x24(%esp)
4000076a:	68 35 20 00 40       	push   $0x40002035
4000076f:	e8 6c 02 00 00       	call   400009e0 <strnlen>
40000774:	29 44 24 14          	sub    %eax,0x14(%esp)
40000778:	8b 44 24 14          	mov    0x14(%esp),%eax
4000077c:	83 c4 10             	add    $0x10,%esp
4000077f:	b9 36 20 00 40       	mov    $0x40002036,%ecx
40000784:	8b 54 24 18          	mov    0x18(%esp),%edx
40000788:	85 c0                	test   %eax,%eax
4000078a:	7f 80                	jg     4000070c <vprintfmt+0x40c>
                 (ch = *p++) != '\0' && (precision < 0
4000078c:	bb 28 00 00 00       	mov    $0x28,%ebx
40000791:	e9 2a ff ff ff       	jmp    400006c0 <vprintfmt+0x3c0>
40000796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000079d:	8d 76 00             	lea    0x0(%esi),%esi

400007a0 <printfmt>:
{
400007a0:	83 ec 0c             	sub    $0xc,%esp
    vprintfmt(putch, putdat, fmt, ap);
400007a3:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400007a7:	50                   	push   %eax
400007a8:	ff 74 24 1c          	pushl  0x1c(%esp)
400007ac:	ff 74 24 1c          	pushl  0x1c(%esp)
400007b0:	ff 74 24 1c          	pushl  0x1c(%esp)
400007b4:	e8 47 fb ff ff       	call   40000300 <vprintfmt>
}
400007b9:	83 c4 1c             	add    $0x1c,%esp
400007bc:	c3                   	ret    
400007bd:	8d 76 00             	lea    0x0(%esi),%esi

400007c0 <vsprintf>:

int vsprintf(char *buf, const char *fmt, va_list ap)
{
400007c0:	83 ec 1c             	sub    $0x1c,%esp
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
400007c3:	8b 44 24 20          	mov    0x20(%esp),%eax
400007c7:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
400007ce:	ff 
400007cf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400007d6:	00 
400007d7:	89 44 24 04          	mov    %eax,0x4(%esp)

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
400007db:	ff 74 24 28          	pushl  0x28(%esp)
400007df:	ff 74 24 28          	pushl  0x28(%esp)
400007e3:	8d 44 24 0c          	lea    0xc(%esp),%eax
400007e7:	50                   	push   %eax
400007e8:	68 e0 02 00 40       	push   $0x400002e0
400007ed:	e8 0e fb ff ff       	call   40000300 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
400007f2:	8b 44 24 14          	mov    0x14(%esp),%eax
400007f6:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
400007f9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400007fd:	83 c4 2c             	add    $0x2c,%esp
40000800:	c3                   	ret    
40000801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000080f:	90                   	nop

40000810 <sprintf>:

int sprintf(char *buf, const char *fmt, ...)
{
40000810:	83 ec 1c             	sub    $0x1c,%esp
    struct sprintbuf b = { buf, (char *) (intptr_t) ~ 0, 0 };
40000813:	8b 44 24 20          	mov    0x20(%esp),%eax
40000817:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
4000081e:	ff 
4000081f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000826:	00 
40000827:	89 44 24 04          	mov    %eax,0x4(%esp)
    vprintfmt((void *) sprintputch, &b, fmt, ap);
4000082b:	8d 44 24 28          	lea    0x28(%esp),%eax
4000082f:	50                   	push   %eax
40000830:	ff 74 24 28          	pushl  0x28(%esp)
40000834:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000838:	50                   	push   %eax
40000839:	68 e0 02 00 40       	push   $0x400002e0
4000083e:	e8 bd fa ff ff       	call   40000300 <vprintfmt>
    *b.buf = '\0';
40000843:	8b 44 24 14          	mov    0x14(%esp),%eax
40000847:	c6 00 00             	movb   $0x0,(%eax)
    va_start(ap, fmt);
    rc = vsprintf(buf, fmt, ap);
    va_end(ap);

    return rc;
}
4000084a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
4000084e:	83 c4 2c             	add    $0x2c,%esp
40000851:	c3                   	ret    
40000852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000860 <vsnprintf>:

int vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
40000860:	83 ec 1c             	sub    $0x1c,%esp
40000863:	8b 44 24 20          	mov    0x20(%esp),%eax
    struct sprintbuf b = { buf, buf + n - 1, 0 };
40000867:	8b 54 24 24          	mov    0x24(%esp),%edx
4000086b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000872:	00 
40000873:	89 44 24 04          	mov    %eax,0x4(%esp)
40000877:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
4000087b:	89 44 24 08          	mov    %eax,0x8(%esp)

    // print the string to the buffer
    vprintfmt((void *) sprintputch, &b, fmt, ap);
4000087f:	ff 74 24 2c          	pushl  0x2c(%esp)
40000883:	ff 74 24 2c          	pushl  0x2c(%esp)
40000887:	8d 44 24 0c          	lea    0xc(%esp),%eax
4000088b:	50                   	push   %eax
4000088c:	68 e0 02 00 40       	push   $0x400002e0
40000891:	e8 6a fa ff ff       	call   40000300 <vprintfmt>

    // null terminate the buffer
    *b.buf = '\0';
40000896:	8b 44 24 14          	mov    0x14(%esp),%eax
4000089a:	c6 00 00             	movb   $0x0,(%eax)

    return b.cnt;
}
4000089d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400008a1:	83 c4 2c             	add    $0x2c,%esp
400008a4:	c3                   	ret    
400008a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400008ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

400008b0 <snprintf>:

int snprintf(char *buf, int n, const char *fmt, ...)
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
    vprintfmt((void *) sprintputch, &b, fmt, ap);
400008cf:	8d 44 24 2c          	lea    0x2c(%esp),%eax
400008d3:	50                   	push   %eax
400008d4:	ff 74 24 2c          	pushl  0x2c(%esp)
400008d8:	8d 44 24 0c          	lea    0xc(%esp),%eax
400008dc:	50                   	push   %eax
400008dd:	68 e0 02 00 40       	push   $0x400002e0
400008e2:	e8 19 fa ff ff       	call   40000300 <vprintfmt>
    *b.buf = '\0';
400008e7:	8b 44 24 14          	mov    0x14(%esp),%eax
400008eb:	c6 00 00             	movb   $0x0,(%eax)
    va_start(ap, fmt);
    rc = vsnprintf(buf, n, fmt, ap);
    va_end(ap);

    return rc;
}
400008ee:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400008f2:	83 c4 2c             	add    $0x2c,%esp
400008f5:	c3                   	ret    
400008f6:	66 90                	xchg   %ax,%ax
400008f8:	66 90                	xchg   %ax,%ax
400008fa:	66 90                	xchg   %ax,%ax
400008fc:	66 90                	xchg   %ax,%ax
400008fe:	66 90                	xchg   %ax,%ax

40000900 <spawn>:
#include <proc.h>
#include <syscall.h>
#include <types.h>

pid_t spawn(uintptr_t exec, unsigned int quota)
{
40000900:	53                   	push   %ebx
static gcc_inline pid_t sys_spawn(unsigned int elf_id, unsigned int quota)
{
    int errno;
    pid_t pid;

    asm volatile ("int %2"
40000901:	b8 01 00 00 00       	mov    $0x1,%eax
40000906:	8b 5c 24 08          	mov    0x8(%esp),%ebx
4000090a:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
4000090e:	cd 30                	int    $0x30
                    "a" (SYS_spawn),
                    "b" (elf_id),
                    "c" (quota)
                  : "cc", "memory");

    return errno ? -1 : pid;
40000910:	85 c0                	test   %eax,%eax
40000912:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000917:	0f 44 c3             	cmove  %ebx,%eax
    return sys_spawn(exec, quota);
}
4000091a:	5b                   	pop    %ebx
4000091b:	c3                   	ret    
4000091c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000920 <yield>:
}

static gcc_inline void sys_yield(void)
{
    asm volatile ("int %0"
40000920:	b8 02 00 00 00       	mov    $0x2,%eax
40000925:	cd 30                	int    $0x30

void yield(void)
{
    sys_yield();
}
40000927:	c3                   	ret    
40000928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000092f:	90                   	nop

40000930 <produce>:

void produce(unsigned int val)
{
40000930:	53                   	push   %ebx
                  : "cc", "memory");
}

static gcc_inline void sys_produce(unsigned int val)
{
    asm volatile ("int %0"
40000931:	b8 03 00 00 00       	mov    $0x3,%eax
40000936:	8b 5c 24 08          	mov    0x8(%esp),%ebx
4000093a:	cd 30                	int    $0x30
    sys_produce(val);
}
4000093c:	5b                   	pop    %ebx
4000093d:	c3                   	ret    
4000093e:	66 90                	xchg   %ax,%ax

40000940 <consume>:

unsigned int consume(void)
{
40000940:	53                   	push   %ebx
}

static gcc_inline unsigned int sys_consume(void)
{
    unsigned int val;
    asm volatile ("int %1"
40000941:	b8 04 00 00 00       	mov    $0x4,%eax
40000946:	cd 30                	int    $0x30
40000948:	89 d8                	mov    %ebx,%eax
    return sys_consume();
}
4000094a:	5b                   	pop    %ebx
4000094b:	c3                   	ret    
4000094c:	66 90                	xchg   %ax,%ax
4000094e:	66 90                	xchg   %ax,%ax

40000950 <spinlock_init>:
    return result;
}

void spinlock_init(spinlock_t *lk)
{
    *lk = 0;
40000950:	8b 44 24 04          	mov    0x4(%esp),%eax
40000954:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
4000095a:	c3                   	ret    
4000095b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000095f:	90                   	nop

40000960 <spinlock_acquire>:

void spinlock_acquire(spinlock_t *lk)
{
40000960:	8b 54 24 04          	mov    0x4(%esp),%edx
    asm volatile ("lock; xchgl %0, %1"
40000964:	b8 01 00 00 00       	mov    $0x1,%eax
40000969:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
4000096c:	85 c0                	test   %eax,%eax
4000096e:	74 13                	je     40000983 <spinlock_acquire+0x23>
    asm volatile ("lock; xchgl %0, %1"
40000970:	b9 01 00 00 00       	mov    $0x1,%ecx
40000975:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("pause");
40000978:	f3 90                	pause  
    asm volatile ("lock; xchgl %0, %1"
4000097a:	89 c8                	mov    %ecx,%eax
4000097c:	f0 87 02             	lock xchg %eax,(%edx)
    while (xchg(lk, 1) != 0)
4000097f:	85 c0                	test   %eax,%eax
40000981:	75 f5                	jne    40000978 <spinlock_acquire+0x18>
}
40000983:	c3                   	ret    
40000984:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
4000098b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
4000098f:	90                   	nop

40000990 <spinlock_release>:

// Release the lock.
void spinlock_release(spinlock_t *lk)
{
40000990:	8b 54 24 04          	mov    0x4(%esp),%edx
}

// Check whether this cpu is holding the lock.
bool spinlock_holding(spinlock_t *lk)
{
    return *lk;
40000994:	8b 02                	mov    (%edx),%eax
    if (spinlock_holding(lk) == FALSE)
40000996:	84 c0                	test   %al,%al
40000998:	74 05                	je     4000099f <spinlock_release+0xf>
    asm volatile ("lock; xchgl %0, %1"
4000099a:	31 c0                	xor    %eax,%eax
4000099c:	f0 87 02             	lock xchg %eax,(%edx)
}
4000099f:	c3                   	ret    

400009a0 <spinlock_holding>:
    return *lk;
400009a0:	8b 44 24 04          	mov    0x4(%esp),%eax
400009a4:	8b 00                	mov    (%eax),%eax
}
400009a6:	c3                   	ret    
400009a7:	66 90                	xchg   %ax,%ax
400009a9:	66 90                	xchg   %ax,%ax
400009ab:	66 90                	xchg   %ax,%ax
400009ad:	66 90                	xchg   %ax,%ax
400009af:	90                   	nop

400009b0 <strlen>:
#include <string.h>
#include <types.h>

int strlen(const char *s)
{
400009b0:	8b 54 24 04          	mov    0x4(%esp),%edx
    int n;

    for (n = 0; *s != '\0'; s++)
400009b4:	31 c0                	xor    %eax,%eax
400009b6:	80 3a 00             	cmpb   $0x0,(%edx)
400009b9:	74 15                	je     400009d0 <strlen+0x20>
400009bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
400009bf:	90                   	nop
        n++;
400009c0:	83 c0 01             	add    $0x1,%eax
    for (n = 0; *s != '\0'; s++)
400009c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
400009c7:	75 f7                	jne    400009c0 <strlen+0x10>
400009c9:	c3                   	ret    
400009ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return n;
}
400009d0:	c3                   	ret    
400009d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400009d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400009df:	90                   	nop

400009e0 <strnlen>:

int strnlen(const char *s, size_t size)
{
400009e0:	8b 54 24 08          	mov    0x8(%esp),%edx
400009e4:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
400009e8:	31 c0                	xor    %eax,%eax
400009ea:	85 d2                	test   %edx,%edx
400009ec:	75 09                	jne    400009f7 <strnlen+0x17>
400009ee:	eb 10                	jmp    40000a00 <strnlen+0x20>
        n++;
400009f0:	83 c0 01             	add    $0x1,%eax
    for (n = 0; size > 0 && *s != '\0'; s++, size--)
400009f3:	39 d0                	cmp    %edx,%eax
400009f5:	74 09                	je     40000a00 <strnlen+0x20>
400009f7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
400009fb:	75 f3                	jne    400009f0 <strnlen+0x10>
400009fd:	c3                   	ret    
400009fe:	66 90                	xchg   %ax,%ax
    return n;
}
40000a00:	c3                   	ret    
40000a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a0f:	90                   	nop

40000a10 <strcpy>:

char *strcpy(char *dst, const char *src)
{
40000a10:	53                   	push   %ebx
40000a11:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    char *ret;

    ret = dst;
    while ((*dst++ = *src++) != '\0')
40000a15:	31 c0                	xor    %eax,%eax
{
40000a17:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
40000a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000a1f:	90                   	nop
    while ((*dst++ = *src++) != '\0')
40000a20:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
40000a24:	88 14 01             	mov    %dl,(%ecx,%eax,1)
40000a27:	83 c0 01             	add    $0x1,%eax
40000a2a:	84 d2                	test   %dl,%dl
40000a2c:	75 f2                	jne    40000a20 <strcpy+0x10>
        /* do nothing */ ;
    return ret;
}
40000a2e:	89 c8                	mov    %ecx,%eax
40000a30:	5b                   	pop    %ebx
40000a31:	c3                   	ret    
40000a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000a40 <strncpy>:

char *strncpy(char *dst, const char *src, size_t size)
{
40000a40:	56                   	push   %esi
40000a41:	53                   	push   %ebx
40000a42:	8b 5c 24 14          	mov    0x14(%esp),%ebx
40000a46:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000a4a:	8b 44 24 10          	mov    0x10(%esp),%eax
    size_t i;
    char *ret;

    ret = dst;
    for (i = 0; i < size; i++) {
40000a4e:	85 db                	test   %ebx,%ebx
40000a50:	74 21                	je     40000a73 <strncpy+0x33>
40000a52:	01 f3                	add    %esi,%ebx
40000a54:	89 f2                	mov    %esi,%edx
40000a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a5d:	8d 76 00             	lea    0x0(%esi),%esi
        *dst++ = *src;
40000a60:	0f b6 08             	movzbl (%eax),%ecx
40000a63:	83 c2 01             	add    $0x1,%edx
40000a66:	88 4a ff             	mov    %cl,-0x1(%edx)
        // If strlen(src) < size, null-pad 'dst' out to 'size' chars
        if (*src != '\0')
            src++;
40000a69:	80 38 01             	cmpb   $0x1,(%eax)
40000a6c:	83 d8 ff             	sbb    $0xffffffff,%eax
    for (i = 0; i < size; i++) {
40000a6f:	39 da                	cmp    %ebx,%edx
40000a71:	75 ed                	jne    40000a60 <strncpy+0x20>
    }
    return ret;
}
40000a73:	89 f0                	mov    %esi,%eax
40000a75:	5b                   	pop    %ebx
40000a76:	5e                   	pop    %esi
40000a77:	c3                   	ret    
40000a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000a7f:	90                   	nop

40000a80 <strlcpy>:

size_t strlcpy(char *dst, const char *src, size_t size)
{
40000a80:	56                   	push   %esi
40000a81:	53                   	push   %ebx
40000a82:	8b 44 24 14          	mov    0x14(%esp),%eax
40000a86:	8b 74 24 0c          	mov    0xc(%esp),%esi
40000a8a:	8b 4c 24 10          	mov    0x10(%esp),%ecx
    char *dst_in;

    dst_in = dst;
    if (size > 0) {
40000a8e:	85 c0                	test   %eax,%eax
40000a90:	74 29                	je     40000abb <strlcpy+0x3b>
        while (--size > 0 && *src != '\0')
40000a92:	89 f2                	mov    %esi,%edx
40000a94:	83 e8 01             	sub    $0x1,%eax
40000a97:	74 1f                	je     40000ab8 <strlcpy+0x38>
40000a99:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
40000a9c:	eb 0f                	jmp    40000aad <strlcpy+0x2d>
40000a9e:	66 90                	xchg   %ax,%ax
            *dst++ = *src++;
40000aa0:	83 c2 01             	add    $0x1,%edx
40000aa3:	83 c1 01             	add    $0x1,%ecx
40000aa6:	88 42 ff             	mov    %al,-0x1(%edx)
        while (--size > 0 && *src != '\0')
40000aa9:	39 da                	cmp    %ebx,%edx
40000aab:	74 07                	je     40000ab4 <strlcpy+0x34>
40000aad:	0f b6 01             	movzbl (%ecx),%eax
40000ab0:	84 c0                	test   %al,%al
40000ab2:	75 ec                	jne    40000aa0 <strlcpy+0x20>
40000ab4:	89 d0                	mov    %edx,%eax
40000ab6:	29 f0                	sub    %esi,%eax
        *dst = '\0';
40000ab8:	c6 02 00             	movb   $0x0,(%edx)
    }
    return dst - dst_in;
}
40000abb:	5b                   	pop    %ebx
40000abc:	5e                   	pop    %esi
40000abd:	c3                   	ret    
40000abe:	66 90                	xchg   %ax,%ax

40000ac0 <strcmp>:

int strcmp(const char *p, const char *q)
{
40000ac0:	53                   	push   %ebx
40000ac1:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000ac5:	8b 54 24 0c          	mov    0xc(%esp),%edx
    while (*p && *p == *q)
40000ac9:	0f b6 01             	movzbl (%ecx),%eax
40000acc:	0f b6 1a             	movzbl (%edx),%ebx
40000acf:	84 c0                	test   %al,%al
40000ad1:	75 16                	jne    40000ae9 <strcmp+0x29>
40000ad3:	eb 23                	jmp    40000af8 <strcmp+0x38>
40000ad5:	8d 76 00             	lea    0x0(%esi),%esi
40000ad8:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        p++, q++;
40000adc:	83 c1 01             	add    $0x1,%ecx
40000adf:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
40000ae2:	0f b6 1a             	movzbl (%edx),%ebx
40000ae5:	84 c0                	test   %al,%al
40000ae7:	74 0f                	je     40000af8 <strcmp+0x38>
40000ae9:	38 d8                	cmp    %bl,%al
40000aeb:	74 eb                	je     40000ad8 <strcmp+0x18>
    return (int) ((unsigned char) *p - (unsigned char) *q);
40000aed:	29 d8                	sub    %ebx,%eax
}
40000aef:	5b                   	pop    %ebx
40000af0:	c3                   	ret    
40000af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000af8:	31 c0                	xor    %eax,%eax
    return (int) ((unsigned char) *p - (unsigned char) *q);
40000afa:	29 d8                	sub    %ebx,%eax
}
40000afc:	5b                   	pop    %ebx
40000afd:	c3                   	ret    
40000afe:	66 90                	xchg   %ax,%ax

40000b00 <strncmp>:

int strncmp(const char *p, const char *q, size_t n)
{
40000b00:	56                   	push   %esi
40000b01:	53                   	push   %ebx
40000b02:	8b 74 24 14          	mov    0x14(%esp),%esi
40000b06:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000b0a:	8b 44 24 10          	mov    0x10(%esp),%eax
    while (n > 0 && *p && *p == *q)
40000b0e:	85 f6                	test   %esi,%esi
40000b10:	74 2e                	je     40000b40 <strncmp+0x40>
40000b12:	01 c6                	add    %eax,%esi
40000b14:	eb 18                	jmp    40000b2e <strncmp+0x2e>
40000b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b1d:	8d 76 00             	lea    0x0(%esi),%esi
40000b20:	38 da                	cmp    %bl,%dl
40000b22:	75 14                	jne    40000b38 <strncmp+0x38>
        n--, p++, q++;
40000b24:	83 c0 01             	add    $0x1,%eax
40000b27:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q)
40000b2a:	39 f0                	cmp    %esi,%eax
40000b2c:	74 12                	je     40000b40 <strncmp+0x40>
40000b2e:	0f b6 11             	movzbl (%ecx),%edx
40000b31:	0f b6 18             	movzbl (%eax),%ebx
40000b34:	84 d2                	test   %dl,%dl
40000b36:	75 e8                	jne    40000b20 <strncmp+0x20>
    if (n == 0)
        return 0;
    else
        return (int) ((unsigned char) *p - (unsigned char) *q);
40000b38:	0f b6 c2             	movzbl %dl,%eax
40000b3b:	29 d8                	sub    %ebx,%eax
}
40000b3d:	5b                   	pop    %ebx
40000b3e:	5e                   	pop    %esi
40000b3f:	c3                   	ret    
        return 0;
40000b40:	31 c0                	xor    %eax,%eax
}
40000b42:	5b                   	pop    %ebx
40000b43:	5e                   	pop    %esi
40000b44:	c3                   	ret    
40000b45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000b50 <strchr>:

char *strchr(const char *s, char c)
{
40000b50:	8b 44 24 04          	mov    0x4(%esp),%eax
40000b54:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
    for (; *s; s++)
40000b59:	0f b6 10             	movzbl (%eax),%edx
40000b5c:	84 d2                	test   %dl,%dl
40000b5e:	75 13                	jne    40000b73 <strchr+0x23>
40000b60:	eb 1e                	jmp    40000b80 <strchr+0x30>
40000b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000b68:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000b6c:	83 c0 01             	add    $0x1,%eax
40000b6f:	84 d2                	test   %dl,%dl
40000b71:	74 0d                	je     40000b80 <strchr+0x30>
        if (*s == c)
40000b73:	38 d1                	cmp    %dl,%cl
40000b75:	75 f1                	jne    40000b68 <strchr+0x18>
            return (char *) s;
    return 0;
}
40000b77:	c3                   	ret    
40000b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b7f:	90                   	nop
    return 0;
40000b80:	31 c0                	xor    %eax,%eax
}
40000b82:	c3                   	ret    
40000b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

40000b90 <strfind>:

char *strfind(const char *s, char c)
{
40000b90:	53                   	push   %ebx
40000b91:	8b 44 24 08          	mov    0x8(%esp),%eax
40000b95:	8b 54 24 0c          	mov    0xc(%esp),%edx
    for (; *s; s++)
40000b99:	0f b6 18             	movzbl (%eax),%ebx
        if (*s == c)
40000b9c:	38 d3                	cmp    %dl,%bl
40000b9e:	74 1f                	je     40000bbf <strfind+0x2f>
40000ba0:	89 d1                	mov    %edx,%ecx
40000ba2:	84 db                	test   %bl,%bl
40000ba4:	75 0e                	jne    40000bb4 <strfind+0x24>
40000ba6:	eb 17                	jmp    40000bbf <strfind+0x2f>
40000ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000baf:	90                   	nop
40000bb0:	84 d2                	test   %dl,%dl
40000bb2:	74 0b                	je     40000bbf <strfind+0x2f>
    for (; *s; s++)
40000bb4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
40000bb8:	83 c0 01             	add    $0x1,%eax
        if (*s == c)
40000bbb:	38 ca                	cmp    %cl,%dl
40000bbd:	75 f1                	jne    40000bb0 <strfind+0x20>
            break;
    return (char *) s;
}
40000bbf:	5b                   	pop    %ebx
40000bc0:	c3                   	ret    
40000bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bcf:	90                   	nop

40000bd0 <strtol>:

long strtol(const char *s, char **endptr, int base)
{
40000bd0:	55                   	push   %ebp
40000bd1:	57                   	push   %edi
40000bd2:	56                   	push   %esi
40000bd3:	53                   	push   %ebx
40000bd4:	83 ec 04             	sub    $0x4,%esp
40000bd7:	8b 44 24 20          	mov    0x20(%esp),%eax
40000bdb:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000bdf:	8b 74 24 1c          	mov    0x1c(%esp),%esi
40000be3:	89 04 24             	mov    %eax,(%esp)
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t')
40000be6:	0f b6 01             	movzbl (%ecx),%eax
40000be9:	3c 09                	cmp    $0x9,%al
40000beb:	74 0b                	je     40000bf8 <strtol+0x28>
40000bed:	3c 20                	cmp    $0x20,%al
40000bef:	75 16                	jne    40000c07 <strtol+0x37>
40000bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bf8:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        s++;
40000bfc:	83 c1 01             	add    $0x1,%ecx
    while (*s == ' ' || *s == '\t')
40000bff:	3c 20                	cmp    $0x20,%al
40000c01:	74 f5                	je     40000bf8 <strtol+0x28>
40000c03:	3c 09                	cmp    $0x9,%al
40000c05:	74 f1                	je     40000bf8 <strtol+0x28>

    // plus/minus sign
    if (*s == '+')
40000c07:	3c 2b                	cmp    $0x2b,%al
40000c09:	0f 84 a1 00 00 00    	je     40000cb0 <strtol+0xe0>
    int neg = 0;
40000c0f:	31 ff                	xor    %edi,%edi
        s++;
    else if (*s == '-')
40000c11:	3c 2d                	cmp    $0x2d,%al
40000c13:	0f 84 87 00 00 00    	je     40000ca0 <strtol+0xd0>
        s++, neg = 1;

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000c19:	0f be 11             	movsbl (%ecx),%edx
40000c1c:	f7 04 24 ef ff ff ff 	testl  $0xffffffef,(%esp)
40000c23:	75 17                	jne    40000c3c <strtol+0x6c>
40000c25:	80 fa 30             	cmp    $0x30,%dl
40000c28:	0f 84 92 00 00 00    	je     40000cc0 <strtol+0xf0>
        s += 2, base = 16;
    else if (base == 0 && s[0] == '0')
40000c2e:	8b 2c 24             	mov    (%esp),%ebp
40000c31:	85 ed                	test   %ebp,%ebp
40000c33:	75 07                	jne    40000c3c <strtol+0x6c>
        s++, base = 8;
    else if (base == 0)
        base = 10;
40000c35:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
40000c3c:	31 c0                	xor    %eax,%eax
40000c3e:	eb 15                	jmp    40000c55 <strtol+0x85>
    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9')
            dig = *s - '0';
40000c40:	83 ea 30             	sub    $0x30,%edx
            dig = *s - 'a' + 10;
        else if (*s >= 'A' && *s <= 'Z')
            dig = *s - 'A' + 10;
        else
            break;
        if (dig >= base)
40000c43:	8b 1c 24             	mov    (%esp),%ebx
40000c46:	39 da                	cmp    %ebx,%edx
40000c48:	7d 29                	jge    40000c73 <strtol+0xa3>
            break;
        s++, val = (val * base) + dig;
40000c4a:	0f af c3             	imul   %ebx,%eax
40000c4d:	83 c1 01             	add    $0x1,%ecx
40000c50:	01 d0                	add    %edx,%eax
    while (1) {
40000c52:	0f be 11             	movsbl (%ecx),%edx
        if (*s >= '0' && *s <= '9')
40000c55:	8d 6a d0             	lea    -0x30(%edx),%ebp
40000c58:	89 eb                	mov    %ebp,%ebx
40000c5a:	80 fb 09             	cmp    $0x9,%bl
40000c5d:	76 e1                	jbe    40000c40 <strtol+0x70>
        else if (*s >= 'a' && *s <= 'z')
40000c5f:	8d 6a 9f             	lea    -0x61(%edx),%ebp
40000c62:	89 eb                	mov    %ebp,%ebx
40000c64:	80 fb 19             	cmp    $0x19,%bl
40000c67:	77 27                	ja     40000c90 <strtol+0xc0>
        if (dig >= base)
40000c69:	8b 1c 24             	mov    (%esp),%ebx
            dig = *s - 'a' + 10;
40000c6c:	83 ea 57             	sub    $0x57,%edx
        if (dig >= base)
40000c6f:	39 da                	cmp    %ebx,%edx
40000c71:	7c d7                	jl     40000c4a <strtol+0x7a>
        // we don't properly detect overflow!
    }

    if (endptr)
40000c73:	85 f6                	test   %esi,%esi
40000c75:	74 02                	je     40000c79 <strtol+0xa9>
        *endptr = (char *) s;
40000c77:	89 0e                	mov    %ecx,(%esi)
    return (neg ? -val : val);
40000c79:	89 c2                	mov    %eax,%edx
40000c7b:	f7 da                	neg    %edx
40000c7d:	85 ff                	test   %edi,%edi
40000c7f:	0f 45 c2             	cmovne %edx,%eax
}
40000c82:	83 c4 04             	add    $0x4,%esp
40000c85:	5b                   	pop    %ebx
40000c86:	5e                   	pop    %esi
40000c87:	5f                   	pop    %edi
40000c88:	5d                   	pop    %ebp
40000c89:	c3                   	ret    
40000c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        else if (*s >= 'A' && *s <= 'Z')
40000c90:	8d 6a bf             	lea    -0x41(%edx),%ebp
40000c93:	89 eb                	mov    %ebp,%ebx
40000c95:	80 fb 19             	cmp    $0x19,%bl
40000c98:	77 d9                	ja     40000c73 <strtol+0xa3>
            dig = *s - 'A' + 10;
40000c9a:	83 ea 37             	sub    $0x37,%edx
40000c9d:	eb a4                	jmp    40000c43 <strtol+0x73>
40000c9f:	90                   	nop
        s++, neg = 1;
40000ca0:	83 c1 01             	add    $0x1,%ecx
40000ca3:	bf 01 00 00 00       	mov    $0x1,%edi
40000ca8:	e9 6c ff ff ff       	jmp    40000c19 <strtol+0x49>
40000cad:	8d 76 00             	lea    0x0(%esi),%esi
        s++;
40000cb0:	83 c1 01             	add    $0x1,%ecx
    int neg = 0;
40000cb3:	31 ff                	xor    %edi,%edi
40000cb5:	e9 5f ff ff ff       	jmp    40000c19 <strtol+0x49>
40000cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
40000cc0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
40000cc4:	3c 78                	cmp    $0x78,%al
40000cc6:	74 1d                	je     40000ce5 <strtol+0x115>
    else if (base == 0 && s[0] == '0')
40000cc8:	8b 1c 24             	mov    (%esp),%ebx
40000ccb:	85 db                	test   %ebx,%ebx
40000ccd:	0f 85 69 ff ff ff    	jne    40000c3c <strtol+0x6c>
        s++, base = 8;
40000cd3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
40000cda:	83 c1 01             	add    $0x1,%ecx
40000cdd:	0f be d0             	movsbl %al,%edx
40000ce0:	e9 57 ff ff ff       	jmp    40000c3c <strtol+0x6c>
        s += 2, base = 16;
40000ce5:	0f be 51 02          	movsbl 0x2(%ecx),%edx
40000ce9:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
40000cf0:	83 c1 02             	add    $0x2,%ecx
40000cf3:	e9 44 ff ff ff       	jmp    40000c3c <strtol+0x6c>
40000cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000cff:	90                   	nop

40000d00 <memset>:

void *memset(void *v, int c, size_t n)
{
40000d00:	57                   	push   %edi
40000d01:	56                   	push   %esi
40000d02:	53                   	push   %ebx
40000d03:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000d07:	8b 7c 24 10          	mov    0x10(%esp),%edi
    if (n == 0)
40000d0b:	85 c9                	test   %ecx,%ecx
40000d0d:	74 28                	je     40000d37 <memset+0x37>
        return v;
    if ((int) v % 4 == 0 && n % 4 == 0) {
40000d0f:	89 f8                	mov    %edi,%eax
40000d11:	09 c8                	or     %ecx,%eax
40000d13:	a8 03                	test   $0x3,%al
40000d15:	75 29                	jne    40000d40 <memset+0x40>
        c &= 0xFF;
40000d17:	0f b6 54 24 14       	movzbl 0x14(%esp),%edx
        c = (c << 24) | (c << 16) | (c << 8) | c;
        asm volatile ("cld; rep stosl\n"
                      :: "D" (v), "a" (c), "c" (n / 4)
40000d1c:	c1 e9 02             	shr    $0x2,%ecx
        c = (c << 24) | (c << 16) | (c << 8) | c;
40000d1f:	89 d0                	mov    %edx,%eax
40000d21:	89 d6                	mov    %edx,%esi
40000d23:	89 d3                	mov    %edx,%ebx
40000d25:	c1 e0 18             	shl    $0x18,%eax
40000d28:	c1 e6 10             	shl    $0x10,%esi
40000d2b:	09 f0                	or     %esi,%eax
40000d2d:	c1 e3 08             	shl    $0x8,%ebx
40000d30:	09 d0                	or     %edx,%eax
40000d32:	09 d8                	or     %ebx,%eax
        asm volatile ("cld; rep stosl\n"
40000d34:	fc                   	cld    
40000d35:	f3 ab                	rep stos %eax,%es:(%edi)
    } else
        asm volatile ("cld; rep stosb\n"
                      :: "D" (v), "a" (c), "c" (n)
                      : "cc", "memory");
    return v;
}
40000d37:	89 f8                	mov    %edi,%eax
40000d39:	5b                   	pop    %ebx
40000d3a:	5e                   	pop    %esi
40000d3b:	5f                   	pop    %edi
40000d3c:	c3                   	ret    
40000d3d:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("cld; rep stosb\n"
40000d40:	8b 44 24 14          	mov    0x14(%esp),%eax
40000d44:	fc                   	cld    
40000d45:	f3 aa                	rep stos %al,%es:(%edi)
}
40000d47:	89 f8                	mov    %edi,%eax
40000d49:	5b                   	pop    %ebx
40000d4a:	5e                   	pop    %esi
40000d4b:	5f                   	pop    %edi
40000d4c:	c3                   	ret    
40000d4d:	8d 76 00             	lea    0x0(%esi),%esi

40000d50 <memmove>:

void *memmove(void *dst, const void *src, size_t n)
{
40000d50:	57                   	push   %edi
40000d51:	56                   	push   %esi
40000d52:	8b 44 24 0c          	mov    0xc(%esp),%eax
40000d56:	8b 74 24 10          	mov    0x10(%esp),%esi
40000d5a:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
40000d5e:	39 c6                	cmp    %eax,%esi
40000d60:	73 26                	jae    40000d88 <memmove+0x38>
40000d62:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
40000d65:	39 c2                	cmp    %eax,%edx
40000d67:	76 1f                	jbe    40000d88 <memmove+0x38>
        s += n;
        d += n;
40000d69:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000d6c:	89 fe                	mov    %edi,%esi
40000d6e:	09 ce                	or     %ecx,%esi
40000d70:	09 d6                	or     %edx,%esi
40000d72:	83 e6 03             	and    $0x3,%esi
40000d75:	74 39                	je     40000db0 <memmove+0x60>
            asm volatile ("std; rep movsl\n"
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
                          : "cc", "memory");
        else
            asm volatile ("std; rep movsb\n"
                          :: "D" (d - 1), "S" (s - 1), "c" (n)
40000d77:	83 ef 01             	sub    $0x1,%edi
40000d7a:	8d 72 ff             	lea    -0x1(%edx),%esi
            asm volatile ("std; rep movsb\n"
40000d7d:	fd                   	std    
40000d7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile ("cld" ::: "cc");
40000d80:	fc                   	cld    
            asm volatile ("cld; rep movsb\n"
                          :: "D" (d), "S" (s), "c" (n)
                          : "cc", "memory");
    }
    return dst;
}
40000d81:	5e                   	pop    %esi
40000d82:	5f                   	pop    %edi
40000d83:	c3                   	ret    
40000d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
40000d88:	89 c2                	mov    %eax,%edx
40000d8a:	09 ca                	or     %ecx,%edx
40000d8c:	09 f2                	or     %esi,%edx
40000d8e:	83 e2 03             	and    $0x3,%edx
40000d91:	74 0d                	je     40000da0 <memmove+0x50>
            asm volatile ("cld; rep movsb\n"
40000d93:	89 c7                	mov    %eax,%edi
40000d95:	fc                   	cld    
40000d96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
40000d98:	5e                   	pop    %esi
40000d99:	5f                   	pop    %edi
40000d9a:	c3                   	ret    
40000d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000d9f:	90                   	nop
                          :: "D" (d), "S" (s), "c" (n / 4)
40000da0:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("cld; rep movsl\n"
40000da3:	89 c7                	mov    %eax,%edi
40000da5:	fc                   	cld    
40000da6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000da8:	eb ee                	jmp    40000d98 <memmove+0x48>
40000daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
40000db0:	83 ef 04             	sub    $0x4,%edi
40000db3:	8d 72 fc             	lea    -0x4(%edx),%esi
40000db6:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("std; rep movsl\n"
40000db9:	fd                   	std    
40000dba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000dbc:	eb c2                	jmp    40000d80 <memmove+0x30>
40000dbe:	66 90                	xchg   %ax,%ax

40000dc0 <memcpy>:

void *memcpy(void *dst, const void *src, size_t n)
{
    return memmove(dst, src, n);
40000dc0:	eb 8e                	jmp    40000d50 <memmove>
40000dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

40000dd0 <memcmp>:
}

int memcmp(const void *v1, const void *v2, size_t n)
{
40000dd0:	56                   	push   %esi
40000dd1:	53                   	push   %ebx
40000dd2:	8b 74 24 14          	mov    0x14(%esp),%esi
40000dd6:	8b 54 24 0c          	mov    0xc(%esp),%edx
40000dda:	8b 44 24 10          	mov    0x10(%esp),%eax
    const uint8_t *s1 = (const uint8_t *) v1;
    const uint8_t *s2 = (const uint8_t *) v2;

    while (n-- > 0) {
40000dde:	85 f6                	test   %esi,%esi
40000de0:	74 2e                	je     40000e10 <memcmp+0x40>
40000de2:	01 c6                	add    %eax,%esi
40000de4:	eb 14                	jmp    40000dfa <memcmp+0x2a>
40000de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000ded:	8d 76 00             	lea    0x0(%esi),%esi
        if (*s1 != *s2)
            return (int) *s1 - (int) *s2;
        s1++, s2++;
40000df0:	83 c0 01             	add    $0x1,%eax
40000df3:	83 c2 01             	add    $0x1,%edx
    while (n-- > 0) {
40000df6:	39 f0                	cmp    %esi,%eax
40000df8:	74 16                	je     40000e10 <memcmp+0x40>
        if (*s1 != *s2)
40000dfa:	0f b6 0a             	movzbl (%edx),%ecx
40000dfd:	0f b6 18             	movzbl (%eax),%ebx
40000e00:	38 d9                	cmp    %bl,%cl
40000e02:	74 ec                	je     40000df0 <memcmp+0x20>
            return (int) *s1 - (int) *s2;
40000e04:	0f b6 c1             	movzbl %cl,%eax
40000e07:	29 d8                	sub    %ebx,%eax
    }

    return 0;
}
40000e09:	5b                   	pop    %ebx
40000e0a:	5e                   	pop    %esi
40000e0b:	c3                   	ret    
40000e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
40000e10:	31 c0                	xor    %eax,%eax
}
40000e12:	5b                   	pop    %ebx
40000e13:	5e                   	pop    %esi
40000e14:	c3                   	ret    
40000e15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

40000e20 <memchr>:

void *memchr(const void *s, int c, size_t n)
{
40000e20:	8b 44 24 04          	mov    0x4(%esp),%eax
    const void *ends = (const char *) s + n;
40000e24:	8b 54 24 0c          	mov    0xc(%esp),%edx
40000e28:	01 c2                	add    %eax,%edx
    for (; s < ends; s++)
40000e2a:	39 d0                	cmp    %edx,%eax
40000e2c:	73 1a                	jae    40000e48 <memchr+0x28>
40000e2e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
40000e33:	eb 0a                	jmp    40000e3f <memchr+0x1f>
40000e35:	8d 76 00             	lea    0x0(%esi),%esi
40000e38:	83 c0 01             	add    $0x1,%eax
40000e3b:	39 c2                	cmp    %eax,%edx
40000e3d:	74 09                	je     40000e48 <memchr+0x28>
        if (*(const unsigned char *) s == (unsigned char) c)
40000e3f:	38 08                	cmp    %cl,(%eax)
40000e41:	75 f5                	jne    40000e38 <memchr+0x18>
            return (void *) s;
    return NULL;
}
40000e43:	c3                   	ret    
40000e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return NULL;
40000e48:	31 c0                	xor    %eax,%eax
}
40000e4a:	c3                   	ret    
40000e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000e4f:	90                   	nop

40000e50 <memzero>:

void *memzero(void *v, size_t n)
{
    return memset(v, 0, n);
40000e50:	ff 74 24 08          	pushl  0x8(%esp)
40000e54:	6a 00                	push   $0x0
40000e56:	ff 74 24 0c          	pushl  0xc(%esp)
40000e5a:	e8 a1 fe ff ff       	call   40000d00 <memset>
40000e5f:	83 c4 0c             	add    $0xc,%esp
}
40000e62:	c3                   	ret    
40000e63:	66 90                	xchg   %ax,%ax
40000e65:	66 90                	xchg   %ax,%ax
40000e67:	66 90                	xchg   %ax,%ax
40000e69:	66 90                	xchg   %ax,%ax
40000e6b:	66 90                	xchg   %ax,%ax
40000e6d:	66 90                	xchg   %ax,%ax
40000e6f:	90                   	nop

40000e70 <__udivdi3>:
40000e70:	f3 0f 1e fb          	endbr32 
40000e74:	55                   	push   %ebp
40000e75:	57                   	push   %edi
40000e76:	56                   	push   %esi
40000e77:	53                   	push   %ebx
40000e78:	83 ec 1c             	sub    $0x1c,%esp
40000e7b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
40000e7f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
40000e83:	8b 74 24 34          	mov    0x34(%esp),%esi
40000e87:	8b 5c 24 38          	mov    0x38(%esp),%ebx
40000e8b:	85 d2                	test   %edx,%edx
40000e8d:	75 19                	jne    40000ea8 <__udivdi3+0x38>
40000e8f:	39 f3                	cmp    %esi,%ebx
40000e91:	76 4d                	jbe    40000ee0 <__udivdi3+0x70>
40000e93:	31 ff                	xor    %edi,%edi
40000e95:	89 e8                	mov    %ebp,%eax
40000e97:	89 f2                	mov    %esi,%edx
40000e99:	f7 f3                	div    %ebx
40000e9b:	89 fa                	mov    %edi,%edx
40000e9d:	83 c4 1c             	add    $0x1c,%esp
40000ea0:	5b                   	pop    %ebx
40000ea1:	5e                   	pop    %esi
40000ea2:	5f                   	pop    %edi
40000ea3:	5d                   	pop    %ebp
40000ea4:	c3                   	ret    
40000ea5:	8d 76 00             	lea    0x0(%esi),%esi
40000ea8:	39 f2                	cmp    %esi,%edx
40000eaa:	76 14                	jbe    40000ec0 <__udivdi3+0x50>
40000eac:	31 ff                	xor    %edi,%edi
40000eae:	31 c0                	xor    %eax,%eax
40000eb0:	89 fa                	mov    %edi,%edx
40000eb2:	83 c4 1c             	add    $0x1c,%esp
40000eb5:	5b                   	pop    %ebx
40000eb6:	5e                   	pop    %esi
40000eb7:	5f                   	pop    %edi
40000eb8:	5d                   	pop    %ebp
40000eb9:	c3                   	ret    
40000eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000ec0:	0f bd fa             	bsr    %edx,%edi
40000ec3:	83 f7 1f             	xor    $0x1f,%edi
40000ec6:	75 48                	jne    40000f10 <__udivdi3+0xa0>
40000ec8:	39 f2                	cmp    %esi,%edx
40000eca:	72 06                	jb     40000ed2 <__udivdi3+0x62>
40000ecc:	31 c0                	xor    %eax,%eax
40000ece:	39 eb                	cmp    %ebp,%ebx
40000ed0:	77 de                	ja     40000eb0 <__udivdi3+0x40>
40000ed2:	b8 01 00 00 00       	mov    $0x1,%eax
40000ed7:	eb d7                	jmp    40000eb0 <__udivdi3+0x40>
40000ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000ee0:	89 d9                	mov    %ebx,%ecx
40000ee2:	85 db                	test   %ebx,%ebx
40000ee4:	75 0b                	jne    40000ef1 <__udivdi3+0x81>
40000ee6:	b8 01 00 00 00       	mov    $0x1,%eax
40000eeb:	31 d2                	xor    %edx,%edx
40000eed:	f7 f3                	div    %ebx
40000eef:	89 c1                	mov    %eax,%ecx
40000ef1:	31 d2                	xor    %edx,%edx
40000ef3:	89 f0                	mov    %esi,%eax
40000ef5:	f7 f1                	div    %ecx
40000ef7:	89 c6                	mov    %eax,%esi
40000ef9:	89 e8                	mov    %ebp,%eax
40000efb:	89 f7                	mov    %esi,%edi
40000efd:	f7 f1                	div    %ecx
40000eff:	89 fa                	mov    %edi,%edx
40000f01:	83 c4 1c             	add    $0x1c,%esp
40000f04:	5b                   	pop    %ebx
40000f05:	5e                   	pop    %esi
40000f06:	5f                   	pop    %edi
40000f07:	5d                   	pop    %ebp
40000f08:	c3                   	ret    
40000f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000f10:	89 f9                	mov    %edi,%ecx
40000f12:	b8 20 00 00 00       	mov    $0x20,%eax
40000f17:	29 f8                	sub    %edi,%eax
40000f19:	d3 e2                	shl    %cl,%edx
40000f1b:	89 54 24 08          	mov    %edx,0x8(%esp)
40000f1f:	89 c1                	mov    %eax,%ecx
40000f21:	89 da                	mov    %ebx,%edx
40000f23:	d3 ea                	shr    %cl,%edx
40000f25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40000f29:	09 d1                	or     %edx,%ecx
40000f2b:	89 f2                	mov    %esi,%edx
40000f2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40000f31:	89 f9                	mov    %edi,%ecx
40000f33:	d3 e3                	shl    %cl,%ebx
40000f35:	89 c1                	mov    %eax,%ecx
40000f37:	d3 ea                	shr    %cl,%edx
40000f39:	89 f9                	mov    %edi,%ecx
40000f3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
40000f3f:	89 eb                	mov    %ebp,%ebx
40000f41:	d3 e6                	shl    %cl,%esi
40000f43:	89 c1                	mov    %eax,%ecx
40000f45:	d3 eb                	shr    %cl,%ebx
40000f47:	09 de                	or     %ebx,%esi
40000f49:	89 f0                	mov    %esi,%eax
40000f4b:	f7 74 24 08          	divl   0x8(%esp)
40000f4f:	89 d6                	mov    %edx,%esi
40000f51:	89 c3                	mov    %eax,%ebx
40000f53:	f7 64 24 0c          	mull   0xc(%esp)
40000f57:	39 d6                	cmp    %edx,%esi
40000f59:	72 15                	jb     40000f70 <__udivdi3+0x100>
40000f5b:	89 f9                	mov    %edi,%ecx
40000f5d:	d3 e5                	shl    %cl,%ebp
40000f5f:	39 c5                	cmp    %eax,%ebp
40000f61:	73 04                	jae    40000f67 <__udivdi3+0xf7>
40000f63:	39 d6                	cmp    %edx,%esi
40000f65:	74 09                	je     40000f70 <__udivdi3+0x100>
40000f67:	89 d8                	mov    %ebx,%eax
40000f69:	31 ff                	xor    %edi,%edi
40000f6b:	e9 40 ff ff ff       	jmp    40000eb0 <__udivdi3+0x40>
40000f70:	8d 43 ff             	lea    -0x1(%ebx),%eax
40000f73:	31 ff                	xor    %edi,%edi
40000f75:	e9 36 ff ff ff       	jmp    40000eb0 <__udivdi3+0x40>
40000f7a:	66 90                	xchg   %ax,%ax
40000f7c:	66 90                	xchg   %ax,%ax
40000f7e:	66 90                	xchg   %ax,%ax

40000f80 <__umoddi3>:
40000f80:	f3 0f 1e fb          	endbr32 
40000f84:	55                   	push   %ebp
40000f85:	57                   	push   %edi
40000f86:	56                   	push   %esi
40000f87:	53                   	push   %ebx
40000f88:	83 ec 1c             	sub    $0x1c,%esp
40000f8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
40000f8f:	8b 74 24 30          	mov    0x30(%esp),%esi
40000f93:	8b 5c 24 34          	mov    0x34(%esp),%ebx
40000f97:	8b 7c 24 38          	mov    0x38(%esp),%edi
40000f9b:	85 c0                	test   %eax,%eax
40000f9d:	75 19                	jne    40000fb8 <__umoddi3+0x38>
40000f9f:	39 df                	cmp    %ebx,%edi
40000fa1:	76 5d                	jbe    40001000 <__umoddi3+0x80>
40000fa3:	89 f0                	mov    %esi,%eax
40000fa5:	89 da                	mov    %ebx,%edx
40000fa7:	f7 f7                	div    %edi
40000fa9:	89 d0                	mov    %edx,%eax
40000fab:	31 d2                	xor    %edx,%edx
40000fad:	83 c4 1c             	add    $0x1c,%esp
40000fb0:	5b                   	pop    %ebx
40000fb1:	5e                   	pop    %esi
40000fb2:	5f                   	pop    %edi
40000fb3:	5d                   	pop    %ebp
40000fb4:	c3                   	ret    
40000fb5:	8d 76 00             	lea    0x0(%esi),%esi
40000fb8:	89 f2                	mov    %esi,%edx
40000fba:	39 d8                	cmp    %ebx,%eax
40000fbc:	76 12                	jbe    40000fd0 <__umoddi3+0x50>
40000fbe:	89 f0                	mov    %esi,%eax
40000fc0:	89 da                	mov    %ebx,%edx
40000fc2:	83 c4 1c             	add    $0x1c,%esp
40000fc5:	5b                   	pop    %ebx
40000fc6:	5e                   	pop    %esi
40000fc7:	5f                   	pop    %edi
40000fc8:	5d                   	pop    %ebp
40000fc9:	c3                   	ret    
40000fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000fd0:	0f bd e8             	bsr    %eax,%ebp
40000fd3:	83 f5 1f             	xor    $0x1f,%ebp
40000fd6:	75 50                	jne    40001028 <__umoddi3+0xa8>
40000fd8:	39 d8                	cmp    %ebx,%eax
40000fda:	0f 82 e0 00 00 00    	jb     400010c0 <__umoddi3+0x140>
40000fe0:	89 d9                	mov    %ebx,%ecx
40000fe2:	39 f7                	cmp    %esi,%edi
40000fe4:	0f 86 d6 00 00 00    	jbe    400010c0 <__umoddi3+0x140>
40000fea:	89 d0                	mov    %edx,%eax
40000fec:	89 ca                	mov    %ecx,%edx
40000fee:	83 c4 1c             	add    $0x1c,%esp
40000ff1:	5b                   	pop    %ebx
40000ff2:	5e                   	pop    %esi
40000ff3:	5f                   	pop    %edi
40000ff4:	5d                   	pop    %ebp
40000ff5:	c3                   	ret    
40000ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000ffd:	8d 76 00             	lea    0x0(%esi),%esi
40001000:	89 fd                	mov    %edi,%ebp
40001002:	85 ff                	test   %edi,%edi
40001004:	75 0b                	jne    40001011 <__umoddi3+0x91>
40001006:	b8 01 00 00 00       	mov    $0x1,%eax
4000100b:	31 d2                	xor    %edx,%edx
4000100d:	f7 f7                	div    %edi
4000100f:	89 c5                	mov    %eax,%ebp
40001011:	89 d8                	mov    %ebx,%eax
40001013:	31 d2                	xor    %edx,%edx
40001015:	f7 f5                	div    %ebp
40001017:	89 f0                	mov    %esi,%eax
40001019:	f7 f5                	div    %ebp
4000101b:	89 d0                	mov    %edx,%eax
4000101d:	31 d2                	xor    %edx,%edx
4000101f:	eb 8c                	jmp    40000fad <__umoddi3+0x2d>
40001021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40001028:	89 e9                	mov    %ebp,%ecx
4000102a:	ba 20 00 00 00       	mov    $0x20,%edx
4000102f:	29 ea                	sub    %ebp,%edx
40001031:	d3 e0                	shl    %cl,%eax
40001033:	89 44 24 08          	mov    %eax,0x8(%esp)
40001037:	89 d1                	mov    %edx,%ecx
40001039:	89 f8                	mov    %edi,%eax
4000103b:	d3 e8                	shr    %cl,%eax
4000103d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
40001041:	89 54 24 04          	mov    %edx,0x4(%esp)
40001045:	8b 54 24 04          	mov    0x4(%esp),%edx
40001049:	09 c1                	or     %eax,%ecx
4000104b:	89 d8                	mov    %ebx,%eax
4000104d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40001051:	89 e9                	mov    %ebp,%ecx
40001053:	d3 e7                	shl    %cl,%edi
40001055:	89 d1                	mov    %edx,%ecx
40001057:	d3 e8                	shr    %cl,%eax
40001059:	89 e9                	mov    %ebp,%ecx
4000105b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
4000105f:	d3 e3                	shl    %cl,%ebx
40001061:	89 c7                	mov    %eax,%edi
40001063:	89 d1                	mov    %edx,%ecx
40001065:	89 f0                	mov    %esi,%eax
40001067:	d3 e8                	shr    %cl,%eax
40001069:	89 e9                	mov    %ebp,%ecx
4000106b:	89 fa                	mov    %edi,%edx
4000106d:	d3 e6                	shl    %cl,%esi
4000106f:	09 d8                	or     %ebx,%eax
40001071:	f7 74 24 08          	divl   0x8(%esp)
40001075:	89 d1                	mov    %edx,%ecx
40001077:	89 f3                	mov    %esi,%ebx
40001079:	f7 64 24 0c          	mull   0xc(%esp)
4000107d:	89 c6                	mov    %eax,%esi
4000107f:	89 d7                	mov    %edx,%edi
40001081:	39 d1                	cmp    %edx,%ecx
40001083:	72 06                	jb     4000108b <__umoddi3+0x10b>
40001085:	75 10                	jne    40001097 <__umoddi3+0x117>
40001087:	39 c3                	cmp    %eax,%ebx
40001089:	73 0c                	jae    40001097 <__umoddi3+0x117>
4000108b:	2b 44 24 0c          	sub    0xc(%esp),%eax
4000108f:	1b 54 24 08          	sbb    0x8(%esp),%edx
40001093:	89 d7                	mov    %edx,%edi
40001095:	89 c6                	mov    %eax,%esi
40001097:	89 ca                	mov    %ecx,%edx
40001099:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
4000109e:	29 f3                	sub    %esi,%ebx
400010a0:	19 fa                	sbb    %edi,%edx
400010a2:	89 d0                	mov    %edx,%eax
400010a4:	d3 e0                	shl    %cl,%eax
400010a6:	89 e9                	mov    %ebp,%ecx
400010a8:	d3 eb                	shr    %cl,%ebx
400010aa:	d3 ea                	shr    %cl,%edx
400010ac:	09 d8                	or     %ebx,%eax
400010ae:	83 c4 1c             	add    $0x1c,%esp
400010b1:	5b                   	pop    %ebx
400010b2:	5e                   	pop    %esi
400010b3:	5f                   	pop    %edi
400010b4:	5d                   	pop    %ebp
400010b5:	c3                   	ret    
400010b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
400010bd:	8d 76 00             	lea    0x0(%esi),%esi
400010c0:	29 fe                	sub    %edi,%esi
400010c2:	19 c3                	sbb    %eax,%ebx
400010c4:	89 f2                	mov    %esi,%edx
400010c6:	89 d9                	mov    %ebx,%ecx
400010c8:	e9 1d ff ff ff       	jmp    40000fea <__umoddi3+0x6a>
