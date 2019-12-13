
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <pmmap_init.cold>:
  100000:	89 f0                	mov    %esi,%eax
    }

    if (last_slot == NULL) {
        SLIST_INSERT_HEAD(&pmmap_list, free_slot, next);
    } else {
        SLIST_INSERT_AFTER(last_slot, free_slot, next);
  100002:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  100006:	84 c0                	test   %al,%al
  100008:	74 0a                	je     100014 <pmmap_init.cold+0x14>
  10000a:	c7 05 5c c4 14 00 80 	movl   $0x80,0x14c45c
  100011:	00 00 00 
  100014:	80 7c 24 1f 00       	cmpb   $0x0,0x1f(%esp)
  100019:	74 06                	je     100021 <pmmap_init.cold+0x21>
  10001b:	89 1d 58 c4 14 00    	mov    %ebx,0x14c458
        KERN_PANIC("More than 128 E820 entries.\n");
  100021:	50                   	push   %eax
  100022:	68 c2 93 10 00       	push   $0x1093c2
  100027:	6a 3c                	push   $0x3c
  100029:	68 df 93 10 00       	push   $0x1093df
  10002e:	e8 1d 38 00 00       	call   103850 <debug_panic>
    free_slot->start = start;
  100033:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  10003a:	00 00 00 
  10003d:	0f 0b                	ud2    
  10003f:	90                   	nop

00100040 <video_init>:
#include <lib/debug.h>

#include "video.h"

void video_init(void)
{
  100040:	56                   	push   %esi
    unsigned pos;

    /* Get a pointer to the memory-mapped text display buffer. */
    cp = (uint16_t *) CGA_BUF;
    was = *cp;
    *cp = (uint16_t) 0xA55A;
  100041:	b9 5a a5 ff ff       	mov    $0xffffa55a,%ecx
{
  100046:	53                   	push   %ebx
  100047:	83 ec 04             	sub    $0x4,%esp
    was = *cp;
  10004a:	0f b7 15 00 80 0b 00 	movzwl 0xb8000,%edx
    *cp = (uint16_t) 0xA55A;
  100051:	66 89 0d 00 80 0b 00 	mov    %cx,0xb8000
    if (*cp != 0xA55A) {
  100058:	0f b7 05 00 80 0b 00 	movzwl 0xb8000,%eax
  10005f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100063:	0f 84 8f 00 00 00    	je     1000f8 <video_init+0xb8>
        cp = (uint16_t *) MONO_BUF;
        addr_6845 = MONO_BASE;
        dprintf("addr_6845:%x\n", addr_6845);
  100069:	83 ec 08             	sub    $0x8,%esp
        cp = (uint16_t *) MONO_BUF;
  10006c:	be 00 00 0b 00       	mov    $0xb0000,%esi
        addr_6845 = MONO_BASE;
  100071:	c7 05 50 28 99 00 b4 	movl   $0x3b4,0x992850
  100078:	03 00 00 
        dprintf("addr_6845:%x\n", addr_6845);
  10007b:	68 b4 03 00 00       	push   $0x3b4
  100080:	68 00 90 10 00       	push   $0x109000
  100085:	e8 d6 39 00 00       	call   103a60 <dprintf>
  10008a:	83 c4 10             	add    $0x10,%esp
        addr_6845 = CGA_BASE;
        dprintf("addr_6845:%x\n", addr_6845);
    }

    /* Extract cursor location */
    outb(addr_6845, 14);
  10008d:	83 ec 08             	sub    $0x8,%esp
  100090:	6a 0e                	push   $0xe
  100092:	ff 35 50 28 99 00    	pushl  0x992850
  100098:	e8 f3 44 00 00       	call   104590 <outb>
    pos = inb(addr_6845 + 1) << 8;
  10009d:	a1 50 28 99 00       	mov    0x992850,%eax
  1000a2:	83 c0 01             	add    $0x1,%eax
  1000a5:	89 04 24             	mov    %eax,(%esp)
  1000a8:	e8 b3 44 00 00       	call   104560 <inb>
  1000ad:	0f b6 c0             	movzbl %al,%eax
  1000b0:	c1 e0 08             	shl    $0x8,%eax
  1000b3:	89 c3                	mov    %eax,%ebx
    outb(addr_6845, 15);
  1000b5:	58                   	pop    %eax
  1000b6:	5a                   	pop    %edx
  1000b7:	6a 0f                	push   $0xf
  1000b9:	ff 35 50 28 99 00    	pushl  0x992850
  1000bf:	e8 cc 44 00 00       	call   104590 <outb>
    pos |= inb(addr_6845 + 1);
  1000c4:	a1 50 28 99 00       	mov    0x992850,%eax
  1000c9:	83 c0 01             	add    $0x1,%eax
  1000cc:	89 04 24             	mov    %eax,(%esp)
  1000cf:	e8 8c 44 00 00       	call   104560 <inb>

    terminal.crt_buf = (uint16_t *) cp;
  1000d4:	89 35 44 28 99 00    	mov    %esi,0x992844
    terminal.crt_pos = pos;
    terminal.active_console = 0;
  1000da:	c7 05 4c 28 99 00 00 	movl   $0x0,0x99284c
  1000e1:	00 00 00 
    pos |= inb(addr_6845 + 1);
  1000e4:	0f b6 c0             	movzbl %al,%eax
  1000e7:	09 d8                	or     %ebx,%eax
    terminal.crt_pos = pos;
  1000e9:	66 a3 48 28 99 00    	mov    %ax,0x992848
}
  1000ef:	83 c4 14             	add    $0x14,%esp
  1000f2:	5b                   	pop    %ebx
  1000f3:	5e                   	pop    %esi
  1000f4:	c3                   	ret    
  1000f5:	8d 76 00             	lea    0x0(%esi),%esi
        dprintf("addr_6845:%x\n", addr_6845);
  1000f8:	83 ec 08             	sub    $0x8,%esp
        *cp = was;
  1000fb:	66 89 15 00 80 0b 00 	mov    %dx,0xb8000
    cp = (uint16_t *) CGA_BUF;
  100102:	be 00 80 0b 00       	mov    $0xb8000,%esi
        dprintf("addr_6845:%x\n", addr_6845);
  100107:	68 d4 03 00 00       	push   $0x3d4
  10010c:	68 00 90 10 00       	push   $0x109000
        addr_6845 = CGA_BASE;
  100111:	c7 05 50 28 99 00 d4 	movl   $0x3d4,0x992850
  100118:	03 00 00 
        dprintf("addr_6845:%x\n", addr_6845);
  10011b:	e8 40 39 00 00       	call   103a60 <dprintf>
  100120:	83 c4 10             	add    $0x10,%esp
  100123:	e9 65 ff ff ff       	jmp    10008d <video_init+0x4d>
  100128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10012f:	90                   	nop

00100130 <video_putc>:

void video_putc(int c)
{
  100130:	83 ec 0c             	sub    $0xc,%esp
  100133:	8b 44 24 10          	mov    0x10(%esp),%eax
    // if no attribute given, then use black on white
    if (!(c & ~0xFF))
        c |= 0x0700;
  100137:	89 c2                	mov    %eax,%edx
  100139:	80 ce 07             	or     $0x7,%dh
  10013c:	a9 00 ff ff ff       	test   $0xffffff00,%eax
  100141:	0f 44 c2             	cmove  %edx,%eax

    switch (c & 0xff) {
  100144:	0f b6 d0             	movzbl %al,%edx
  100147:	83 fa 0a             	cmp    $0xa,%edx
  10014a:	0f 84 a8 01 00 00    	je     1002f8 <video_putc+0x1c8>
  100150:	0f 8f ba 00 00 00    	jg     100210 <video_putc+0xe0>
  100156:	83 fa 08             	cmp    $0x8,%edx
  100159:	0f 84 61 01 00 00    	je     1002c0 <video_putc+0x190>
  10015f:	83 fa 09             	cmp    $0x9,%edx
  100162:	0f 85 28 01 00 00    	jne    100290 <video_putc+0x160>
        /* fallthru */
    case '\r':
        terminal.crt_pos -= (terminal.crt_pos % CRT_COLS);
        break;
    case '\t':
        video_putc(' ');
  100168:	83 ec 0c             	sub    $0xc,%esp
  10016b:	6a 20                	push   $0x20
  10016d:	e8 be ff ff ff       	call   100130 <video_putc>
        video_putc(' ');
  100172:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100179:	e8 b2 ff ff ff       	call   100130 <video_putc>
        video_putc(' ');
  10017e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100185:	e8 a6 ff ff ff       	call   100130 <video_putc>
        video_putc(' ');
  10018a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100191:	e8 9a ff ff ff       	call   100130 <video_putc>
        video_putc(' ');
  100196:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10019d:	e8 8e ff ff ff       	call   100130 <video_putc>
        break;
  1001a2:	0f b7 05 48 28 99 00 	movzwl 0x992848,%eax
  1001a9:	83 c4 10             	add    $0x10,%esp
    default:
        terminal.crt_buf[terminal.crt_pos++] = c;  /* write the character */
        break;
    }

    if (terminal.crt_pos >= CRT_SIZE) {
  1001ac:	66 3d cf 07          	cmp    $0x7cf,%ax
  1001b0:	0f 87 88 00 00 00    	ja     10023e <video_putc+0x10e>
            terminal.crt_buf[i] = 0x0700 | ' ';
        terminal.crt_pos -= CRT_COLS;
    }

    /* move that little blinky thing */
    outb(addr_6845, 14);
  1001b6:	83 ec 08             	sub    $0x8,%esp
  1001b9:	6a 0e                	push   $0xe
  1001bb:	ff 35 50 28 99 00    	pushl  0x992850
  1001c1:	e8 ca 43 00 00       	call   104590 <outb>
    outb(addr_6845 + 1, terminal.crt_pos >> 8);
  1001c6:	58                   	pop    %eax
  1001c7:	0f b6 05 49 28 99 00 	movzbl 0x992849,%eax
  1001ce:	5a                   	pop    %edx
  1001cf:	50                   	push   %eax
  1001d0:	a1 50 28 99 00       	mov    0x992850,%eax
  1001d5:	83 c0 01             	add    $0x1,%eax
  1001d8:	50                   	push   %eax
  1001d9:	e8 b2 43 00 00       	call   104590 <outb>
    outb(addr_6845, 15);
  1001de:	59                   	pop    %ecx
  1001df:	58                   	pop    %eax
  1001e0:	6a 0f                	push   $0xf
  1001e2:	ff 35 50 28 99 00    	pushl  0x992850
  1001e8:	e8 a3 43 00 00       	call   104590 <outb>
    outb(addr_6845 + 1, terminal.crt_pos);
  1001ed:	58                   	pop    %eax
  1001ee:	0f b6 05 48 28 99 00 	movzbl 0x992848,%eax
  1001f5:	5a                   	pop    %edx
  1001f6:	50                   	push   %eax
  1001f7:	a1 50 28 99 00       	mov    0x992850,%eax
  1001fc:	83 c0 01             	add    $0x1,%eax
  1001ff:	50                   	push   %eax
  100200:	e8 8b 43 00 00       	call   104590 <outb>
}
  100205:	83 c4 1c             	add    $0x1c,%esp
  100208:	c3                   	ret    
  100209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch (c & 0xff) {
  100210:	83 fa 0d             	cmp    $0xd,%edx
  100213:	75 7b                	jne    100290 <video_putc+0x160>
  100215:	0f b7 05 48 28 99 00 	movzwl 0x992848,%eax
        terminal.crt_pos -= (terminal.crt_pos % CRT_COLS);
  10021c:	0f b7 c0             	movzwl %ax,%eax
  10021f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  100225:	c1 e8 16             	shr    $0x16,%eax
  100228:	8d 04 80             	lea    (%eax,%eax,4),%eax
  10022b:	c1 e0 04             	shl    $0x4,%eax
  10022e:	66 a3 48 28 99 00    	mov    %ax,0x992848
    if (terminal.crt_pos >= CRT_SIZE) {
  100234:	66 3d cf 07          	cmp    $0x7cf,%ax
  100238:	0f 86 78 ff ff ff    	jbe    1001b6 <video_putc+0x86>
        memmove(terminal.crt_buf, terminal.crt_buf + CRT_COLS,
  10023e:	a1 44 28 99 00       	mov    0x992844,%eax
  100243:	83 ec 04             	sub    $0x4,%esp
  100246:	68 00 0f 00 00       	push   $0xf00
  10024b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  100251:	52                   	push   %edx
  100252:	50                   	push   %eax
  100253:	e8 28 33 00 00       	call   103580 <memmove>
            terminal.crt_buf[i] = 0x0700 | ' ';
  100258:	8b 15 44 28 99 00    	mov    0x992844,%edx
  10025e:	83 c4 10             	add    $0x10,%esp
  100261:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
  100267:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
  10026d:	8d 76 00             	lea    0x0(%esi),%esi
  100270:	b9 20 07 00 00       	mov    $0x720,%ecx
  100275:	83 c0 02             	add    $0x2,%eax
  100278:	66 89 48 fe          	mov    %cx,-0x2(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  10027c:	39 d0                	cmp    %edx,%eax
  10027e:	75 f0                	jne    100270 <video_putc+0x140>
        terminal.crt_pos -= CRT_COLS;
  100280:	66 83 2d 48 28 99 00 	subw   $0x50,0x992848
  100287:	50 
  100288:	e9 29 ff ff ff       	jmp    1001b6 <video_putc+0x86>
  10028d:	8d 76 00             	lea    0x0(%esi),%esi
        terminal.crt_buf[terminal.crt_pos++] = c;  /* write the character */
  100290:	0f b7 15 48 28 99 00 	movzwl 0x992848,%edx
  100297:	8d 4a 01             	lea    0x1(%edx),%ecx
  10029a:	66 89 0d 48 28 99 00 	mov    %cx,0x992848
  1002a1:	8b 0d 44 28 99 00    	mov    0x992844,%ecx
  1002a7:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
        break;
  1002ab:	0f b7 05 48 28 99 00 	movzwl 0x992848,%eax
  1002b2:	e9 f5 fe ff ff       	jmp    1001ac <video_putc+0x7c>
  1002b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1002be:	66 90                	xchg   %ax,%ax
        if (terminal.crt_pos > 0) {
  1002c0:	0f b7 15 48 28 99 00 	movzwl 0x992848,%edx
  1002c7:	66 85 d2             	test   %dx,%dx
  1002ca:	0f 84 e6 fe ff ff    	je     1001b6 <video_putc+0x86>
            terminal.crt_pos--;
  1002d0:	83 ea 01             	sub    $0x1,%edx
            terminal.crt_buf[terminal.crt_pos] = (c & ~0xff) | ' ';
  1002d3:	8b 0d 44 28 99 00    	mov    0x992844,%ecx
  1002d9:	30 c0                	xor    %al,%al
            terminal.crt_pos--;
  1002db:	66 89 15 48 28 99 00 	mov    %dx,0x992848
            terminal.crt_buf[terminal.crt_pos] = (c & ~0xff) | ' ';
  1002e2:	83 c8 20             	or     $0x20,%eax
  1002e5:	0f b7 d2             	movzwl %dx,%edx
  1002e8:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
  1002ec:	0f b7 05 48 28 99 00 	movzwl 0x992848,%eax
  1002f3:	e9 b4 fe ff ff       	jmp    1001ac <video_putc+0x7c>
        terminal.crt_pos += CRT_COLS;
  1002f8:	0f b7 05 48 28 99 00 	movzwl 0x992848,%eax
  1002ff:	83 c0 50             	add    $0x50,%eax
  100302:	e9 15 ff ff ff       	jmp    10021c <video_putc+0xec>
  100307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10030e:	66 90                	xchg   %ax,%ax

00100310 <video_set_cursor>:

void video_set_cursor(int x, int y)
{
  100310:	8b 44 24 04          	mov    0x4(%esp),%eax
    terminal.crt_pos = x * CRT_COLS + y;
  100314:	8d 04 80             	lea    (%eax,%eax,4),%eax
  100317:	c1 e0 04             	shl    $0x4,%eax
  10031a:	66 03 44 24 08       	add    0x8(%esp),%ax
  10031f:	66 a3 48 28 99 00    	mov    %ax,0x992848
}
  100325:	c3                   	ret    
  100326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10032d:	8d 76 00             	lea    0x0(%esi),%esi

00100330 <video_clear_screen>:

void video_clear_screen()
{
    int i;
    for (i = 0; i < CRT_SIZE; i++) {
  100330:	a1 44 28 99 00       	mov    0x992844,%eax
  100335:	8d 90 a0 0f 00 00    	lea    0xfa0(%eax),%edx
  10033b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10033f:	90                   	nop
        terminal.crt_buf[i] = ' ';
  100340:	b9 20 00 00 00       	mov    $0x20,%ecx
  100345:	83 c0 02             	add    $0x2,%eax
  100348:	66 89 48 fe          	mov    %cx,-0x2(%eax)
    for (i = 0; i < CRT_SIZE; i++) {
  10034c:	39 d0                	cmp    %edx,%eax
  10034e:	75 f0                	jne    100340 <video_clear_screen+0x10>
    }
}
  100350:	c3                   	ret    
  100351:	66 90                	xchg   %ax,%ax
  100353:	66 90                	xchg   %ax,%ax
  100355:	66 90                	xchg   %ax,%ax
  100357:	66 90                	xchg   %ax,%ax
  100359:	66 90                	xchg   %ax,%ax
  10035b:	66 90                	xchg   %ax,%ax
  10035d:	66 90                	xchg   %ax,%ax
  10035f:	90                   	nop

00100360 <cons_init>:
    char buf[CONSOLE_BUFFER_SIZE];
    uint32_t rpos, wpos;
} cons;

void cons_init()
{
  100360:	83 ec 10             	sub    $0x10,%esp
    memset(&cons, 0x0, sizeof(cons));
  100363:	68 08 02 00 00       	push   $0x208
  100368:	6a 00                	push   $0x0
  10036a:	68 60 28 99 00       	push   $0x992860
  10036f:	e8 bc 31 00 00       	call   103530 <memset>
    serial_init();
  100374:	e8 77 03 00 00       	call   1006f0 <serial_init>
    video_init();
  100379:	e8 c2 fc ff ff       	call   100040 <video_init>
    spinlock_init(&cons_lk);
  10037e:	c7 04 24 00 c0 14 00 	movl   $0x14c000,(%esp)
  100385:	e8 86 49 00 00       	call   104d10 <spinlock_init>
}
  10038a:	83 c4 1c             	add    $0x1c,%esp
  10038d:	c3                   	ret    
  10038e:	66 90                	xchg   %ax,%ax

00100390 <cons_intr>:

void cons_intr(int (*proc)(void))
{
  100390:	53                   	push   %ebx
  100391:	83 ec 14             	sub    $0x14,%esp
  100394:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    int c;

    spinlock_acquire(&cons_lk);
  100398:	68 00 c0 14 00       	push   $0x14c000
  10039d:	e8 fe 49 00 00       	call   104da0 <spinlock_acquire>
    while ((c = (*proc)()) != -1) {
  1003a2:	83 c4 10             	add    $0x10,%esp
  1003a5:	ff d3                	call   *%ebx
  1003a7:	83 f8 ff             	cmp    $0xffffffff,%eax
  1003aa:	74 2e                	je     1003da <cons_intr+0x4a>
        if (c == 0)
  1003ac:	85 c0                	test   %eax,%eax
  1003ae:	74 f5                	je     1003a5 <cons_intr+0x15>
            continue;
        cons.buf[cons.wpos++] = c;
  1003b0:	8b 0d 64 2a 99 00    	mov    0x992a64,%ecx
  1003b6:	8d 51 01             	lea    0x1(%ecx),%edx
  1003b9:	88 81 60 28 99 00    	mov    %al,0x992860(%ecx)
        if (cons.wpos == CONSOLE_BUFFER_SIZE)
            cons.wpos = 0;
  1003bf:	b8 00 00 00 00       	mov    $0x0,%eax
        if (cons.wpos == CONSOLE_BUFFER_SIZE)
  1003c4:	81 fa 00 02 00 00    	cmp    $0x200,%edx
            cons.wpos = 0;
  1003ca:	0f 44 d0             	cmove  %eax,%edx
  1003cd:	89 15 64 2a 99 00    	mov    %edx,0x992a64
    while ((c = (*proc)()) != -1) {
  1003d3:	ff d3                	call   *%ebx
  1003d5:	83 f8 ff             	cmp    $0xffffffff,%eax
  1003d8:	75 d2                	jne    1003ac <cons_intr+0x1c>
    }
    spinlock_release(&cons_lk);
  1003da:	c7 44 24 10 00 c0 14 	movl   $0x14c000,0x10(%esp)
  1003e1:	00 
}
  1003e2:	83 c4 08             	add    $0x8,%esp
  1003e5:	5b                   	pop    %ebx
    spinlock_release(&cons_lk);
  1003e6:	e9 25 4a 00 00       	jmp    104e10 <spinlock_release>
  1003eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1003ef:	90                   	nop

001003f0 <cons_getc>:

char cons_getc(void)
{
  1003f0:	53                   	push   %ebx
  1003f1:	83 ec 08             	sub    $0x8,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1003f4:	e8 07 02 00 00       	call   100600 <serial_intr>
    keyboard_intr();
  1003f9:	e8 22 05 00 00       	call   100920 <keyboard_intr>
    spinlock_acquire(&cons_lk);
  1003fe:	83 ec 0c             	sub    $0xc,%esp
  100401:	68 00 c0 14 00       	push   $0x14c000
  100406:	e8 95 49 00 00       	call   104da0 <spinlock_acquire>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10040b:	a1 60 2a 99 00       	mov    0x992a60,%eax
  100410:	83 c4 10             	add    $0x10,%esp
  100413:	3b 05 64 2a 99 00    	cmp    0x992a64,%eax
  100419:	74 35                	je     100450 <cons_getc+0x60>
        c = cons.buf[cons.rpos++];
        if (cons.rpos == CONSOLE_BUFFER_SIZE)
            cons.rpos = 0;
  10041b:	3d ff 01 00 00       	cmp    $0x1ff,%eax
        c = cons.buf[cons.rpos++];
  100420:	0f b6 98 60 28 99 00 	movzbl 0x992860(%eax),%ebx
  100427:	8d 50 01             	lea    0x1(%eax),%edx
            cons.rpos = 0;
  10042a:	b8 00 00 00 00       	mov    $0x0,%eax
  10042f:	0f 45 c2             	cmovne %edx,%eax
        spinlock_release(&cons_lk);
  100432:	83 ec 0c             	sub    $0xc,%esp
  100435:	68 00 c0 14 00       	push   $0x14c000
            cons.rpos = 0;
  10043a:	a3 60 2a 99 00       	mov    %eax,0x992a60
        spinlock_release(&cons_lk);
  10043f:	e8 cc 49 00 00       	call   104e10 <spinlock_release>
        return c;
  100444:	83 c4 10             	add    $0x10,%esp
    }
    spinlock_release(&cons_lk);
    return 0;
}
  100447:	89 d8                	mov    %ebx,%eax
  100449:	83 c4 08             	add    $0x8,%esp
  10044c:	5b                   	pop    %ebx
  10044d:	c3                   	ret    
  10044e:	66 90                	xchg   %ax,%ax
    spinlock_release(&cons_lk);
  100450:	83 ec 0c             	sub    $0xc,%esp
    return 0;
  100453:	31 db                	xor    %ebx,%ebx
    spinlock_release(&cons_lk);
  100455:	68 00 c0 14 00       	push   $0x14c000
  10045a:	e8 b1 49 00 00       	call   104e10 <spinlock_release>
    return 0;
  10045f:	83 c4 10             	add    $0x10,%esp
}
  100462:	89 d8                	mov    %ebx,%eax
  100464:	83 c4 08             	add    $0x8,%esp
  100467:	5b                   	pop    %ebx
  100468:	c3                   	ret    
  100469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00100470 <cons_putc>:

void cons_putc(char c)
{
  100470:	53                   	push   %ebx
  100471:	83 ec 14             	sub    $0x14,%esp
    serial_putc(c);
  100474:	0f be 5c 24 1c       	movsbl 0x1c(%esp),%ebx
  100479:	53                   	push   %ebx
  10047a:	e8 b1 01 00 00       	call   100630 <serial_putc>
    video_putc(c);
  10047f:	89 5c 24 20          	mov    %ebx,0x20(%esp)
}
  100483:	83 c4 18             	add    $0x18,%esp
  100486:	5b                   	pop    %ebx
    video_putc(c);
  100487:	e9 a4 fc ff ff       	jmp    100130 <video_putc>
  10048c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100490 <getchar>:

char getchar(void)
{
  100490:	83 ec 0c             	sub    $0xc,%esp
  100493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100497:	90                   	nop
    char c;

    while ((c = cons_getc()) == 0)
  100498:	e8 53 ff ff ff       	call   1003f0 <cons_getc>
  10049d:	84 c0                	test   %al,%al
  10049f:	74 f7                	je     100498 <getchar+0x8>
        /* do nothing */ ;
    return c;
}
  1004a1:	83 c4 0c             	add    $0xc,%esp
  1004a4:	c3                   	ret    
  1004a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1004ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001004b0 <putchar>:
  1004b0:	eb be                	jmp    100470 <cons_putc>
  1004b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1004b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001004c0 <readline>:
{
    cons_putc(c);
}

char *readline(const char *prompt)
{
  1004c0:	56                   	push   %esi
  1004c1:	53                   	push   %ebx
  1004c2:	83 ec 14             	sub    $0x14,%esp
  1004c5:	8b 44 24 20          	mov    0x20(%esp),%eax
    int i;
    char c;

    if (prompt != NULL)
  1004c9:	85 c0                	test   %eax,%eax
  1004cb:	74 11                	je     1004de <readline+0x1e>
        dprintf("%s", prompt);
  1004cd:	83 ec 08             	sub    $0x8,%esp
  1004d0:	50                   	push   %eax
  1004d1:	68 02 a9 10 00       	push   $0x10a902
  1004d6:	e8 85 35 00 00       	call   103a60 <dprintf>
  1004db:	83 c4 10             	add    $0x10,%esp
        } else if ((c == '\b' || c == '\x7f') && i > 0) {
            putchar('\b');
            i--;
        } else if (c >= ' ' && i < BUFLEN - 1) {
            putchar(c);
            linebuf[i++] = c;
  1004de:	31 db                	xor    %ebx,%ebx
    while ((c = cons_getc()) == 0)
  1004e0:	e8 0b ff ff ff       	call   1003f0 <cons_getc>
  1004e5:	84 c0                	test   %al,%al
  1004e7:	74 f7                	je     1004e0 <readline+0x20>
        if (c < 0) {
  1004e9:	0f 88 aa 00 00 00    	js     100599 <readline+0xd9>
        } else if ((c == '\b' || c == '\x7f') && i > 0) {
  1004ef:	3c 08                	cmp    $0x8,%al
  1004f1:	0f 94 c1             	sete   %cl
  1004f4:	3c 7f                	cmp    $0x7f,%al
  1004f6:	0f 94 c2             	sete   %dl
  1004f9:	08 d1                	or     %dl,%cl
  1004fb:	74 04                	je     100501 <readline+0x41>
  1004fd:	85 db                	test   %ebx,%ebx
  1004ff:	75 77                	jne    100578 <readline+0xb8>
        } else if (c >= ' ' && i < BUFLEN - 1) {
  100501:	3c 1f                	cmp    $0x1f,%al
  100503:	7e 3b                	jle    100540 <readline+0x80>
  100505:	81 fb fe 03 00 00    	cmp    $0x3fe,%ebx
  10050b:	7f 33                	jg     100540 <readline+0x80>
            putchar(c);
  10050d:	88 44 24 0f          	mov    %al,0xf(%esp)
  100511:	0f be f0             	movsbl %al,%esi
    serial_putc(c);
  100514:	83 ec 0c             	sub    $0xc,%esp
            linebuf[i++] = c;
  100517:	83 c3 01             	add    $0x1,%ebx
    serial_putc(c);
  10051a:	56                   	push   %esi
  10051b:	e8 10 01 00 00       	call   100630 <serial_putc>
    video_putc(c);
  100520:	89 34 24             	mov    %esi,(%esp)
  100523:	e8 08 fc ff ff       	call   100130 <video_putc>
            linebuf[i++] = c;
  100528:	0f b6 44 24 1f       	movzbl 0x1f(%esp),%eax
  10052d:	83 c4 10             	add    $0x10,%esp
  100530:	88 83 1f c0 14 00    	mov    %al,0x14c01f(%ebx)
  100536:	eb a8                	jmp    1004e0 <readline+0x20>
  100538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10053f:	90                   	nop
        } else if (c == '\n' || c == '\r') {
  100540:	3c 0a                	cmp    $0xa,%al
  100542:	74 04                	je     100548 <readline+0x88>
  100544:	3c 0d                	cmp    $0xd,%al
  100546:	75 98                	jne    1004e0 <readline+0x20>
    serial_putc(c);
  100548:	83 ec 0c             	sub    $0xc,%esp
  10054b:	6a 0a                	push   $0xa
  10054d:	e8 de 00 00 00       	call   100630 <serial_putc>
    video_putc(c);
  100552:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100559:	e8 d2 fb ff ff       	call   100130 <video_putc>
            putchar('\n');
            linebuf[i] = 0;
            return linebuf;
  10055e:	83 c4 10             	add    $0x10,%esp
  100561:	b8 20 c0 14 00       	mov    $0x14c020,%eax
            linebuf[i] = 0;
  100566:	c6 83 20 c0 14 00 00 	movb   $0x0,0x14c020(%ebx)
        }
    }
}
  10056d:	83 c4 14             	add    $0x14,%esp
  100570:	5b                   	pop    %ebx
  100571:	5e                   	pop    %esi
  100572:	c3                   	ret    
  100573:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100577:	90                   	nop
    serial_putc(c);
  100578:	83 ec 0c             	sub    $0xc,%esp
            i--;
  10057b:	83 eb 01             	sub    $0x1,%ebx
    serial_putc(c);
  10057e:	6a 08                	push   $0x8
  100580:	e8 ab 00 00 00       	call   100630 <serial_putc>
    video_putc(c);
  100585:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10058c:	e8 9f fb ff ff       	call   100130 <video_putc>
            i--;
  100591:	83 c4 10             	add    $0x10,%esp
  100594:	e9 47 ff ff ff       	jmp    1004e0 <readline+0x20>
            dprintf("read error: %e\n", c);
  100599:	83 ec 08             	sub    $0x8,%esp
  10059c:	0f be c0             	movsbl %al,%eax
  10059f:	50                   	push   %eax
  1005a0:	68 0e 90 10 00       	push   $0x10900e
  1005a5:	e8 b6 34 00 00       	call   103a60 <dprintf>
            return NULL;
  1005aa:	83 c4 10             	add    $0x10,%esp
  1005ad:	31 c0                	xor    %eax,%eax
}
  1005af:	83 c4 14             	add    $0x14,%esp
  1005b2:	5b                   	pop    %ebx
  1005b3:	5e                   	pop    %esi
  1005b4:	c3                   	ret    
  1005b5:	66 90                	xchg   %ax,%ax
  1005b7:	66 90                	xchg   %ax,%ax
  1005b9:	66 90                	xchg   %ax,%ax
  1005bb:	66 90                	xchg   %ax,%ax
  1005bd:	66 90                	xchg   %ax,%ax
  1005bf:	90                   	nop

001005c0 <serial_proc_data>:
    inb(0x84);
    inb(0x84);
}

static int serial_proc_data(void)
{
  1005c0:	83 ec 18             	sub    $0x18,%esp
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA))
  1005c3:	68 fd 03 00 00       	push   $0x3fd
  1005c8:	e8 93 3f 00 00       	call   104560 <inb>
  1005cd:	83 c4 10             	add    $0x10,%esp
  1005d0:	a8 01                	test   $0x1,%al
  1005d2:	74 1c                	je     1005f0 <serial_proc_data+0x30>
        return -1;
    return inb(COM1 + COM_RX);
  1005d4:	83 ec 0c             	sub    $0xc,%esp
  1005d7:	68 f8 03 00 00       	push   $0x3f8
  1005dc:	e8 7f 3f 00 00       	call   104560 <inb>
  1005e1:	83 c4 10             	add    $0x10,%esp
  1005e4:	0f b6 c0             	movzbl %al,%eax
}
  1005e7:	83 c4 0c             	add    $0xc,%esp
  1005ea:	c3                   	ret    
  1005eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1005ef:	90                   	nop
        return -1;
  1005f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005f5:	eb f0                	jmp    1005e7 <serial_proc_data+0x27>
  1005f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1005fe:	66 90                	xchg   %ax,%ax

00100600 <serial_intr>:

void serial_intr(void)
{
    if (serial_exists)
  100600:	80 3d 68 2a 99 00 00 	cmpb   $0x0,0x992a68
  100607:	75 07                	jne    100610 <serial_intr+0x10>
  100609:	c3                   	ret    
  10060a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  100610:	83 ec 18             	sub    $0x18,%esp
        cons_intr(serial_proc_data);
  100613:	68 c0 05 10 00       	push   $0x1005c0
  100618:	e8 73 fd ff ff       	call   100390 <cons_intr>
}
  10061d:	83 c4 1c             	add    $0x1c,%esp
  100620:	c3                   	ret    
  100621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10062f:	90                   	nop

00100630 <serial_putc>:
    } else
        return 0;
}

void serial_putc(char c)
{
  100630:	56                   	push   %esi
  100631:	53                   	push   %ebx
    if (!serial_exists)
        return;

    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  100632:	31 db                	xor    %ebx,%ebx
{
  100634:	83 ec 04             	sub    $0x4,%esp
    if (!serial_exists)
  100637:	80 3d 68 2a 99 00 00 	cmpb   $0x0,0x992a68
{
  10063e:	8b 74 24 10          	mov    0x10(%esp),%esi
    if (!serial_exists)
  100642:	75 4b                	jne    10068f <serial_putc+0x5f>
  100644:	eb 77                	jmp    1006bd <serial_putc+0x8d>
  100646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10064d:	8d 76 00             	lea    0x0(%esi),%esi
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  100650:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
  100656:	74 4b                	je     1006a3 <serial_putc+0x73>
    inb(0x84);
  100658:	83 ec 0c             	sub    $0xc,%esp
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  10065b:	83 c3 01             	add    $0x1,%ebx
    inb(0x84);
  10065e:	68 84 00 00 00       	push   $0x84
  100663:	e8 f8 3e 00 00       	call   104560 <inb>
    inb(0x84);
  100668:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  10066f:	e8 ec 3e 00 00       	call   104560 <inb>
    inb(0x84);
  100674:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  10067b:	e8 e0 3e 00 00       	call   104560 <inb>
    inb(0x84);
  100680:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  100687:	e8 d4 3e 00 00       	call   104560 <inb>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i++)
  10068c:	83 c4 10             	add    $0x10,%esp
  10068f:	83 ec 0c             	sub    $0xc,%esp
  100692:	68 fd 03 00 00       	push   $0x3fd
  100697:	e8 c4 3e 00 00       	call   104560 <inb>
  10069c:	83 c4 10             	add    $0x10,%esp
  10069f:	a8 20                	test   $0x20,%al
  1006a1:	74 ad                	je     100650 <serial_putc+0x20>
    if (c == nl) {
  1006a3:	89 f0                	mov    %esi,%eax
  1006a5:	3c 0a                	cmp    $0xa,%al
  1006a7:	74 1f                	je     1006c8 <serial_putc+0x98>
        delay();

    if (!serial_reformatnewline(c, COM1 + COM_TX))
        outb(COM1 + COM_TX, c);
  1006a9:	83 ec 08             	sub    $0x8,%esp
  1006ac:	0f b6 f0             	movzbl %al,%esi
  1006af:	56                   	push   %esi
  1006b0:	68 f8 03 00 00       	push   $0x3f8
  1006b5:	e8 d6 3e 00 00       	call   104590 <outb>
  1006ba:	83 c4 10             	add    $0x10,%esp
}
  1006bd:	83 c4 04             	add    $0x4,%esp
  1006c0:	5b                   	pop    %ebx
  1006c1:	5e                   	pop    %esi
  1006c2:	c3                   	ret    
  1006c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1006c7:	90                   	nop
        outb(p, cr);
  1006c8:	83 ec 08             	sub    $0x8,%esp
  1006cb:	6a 0d                	push   $0xd
  1006cd:	68 f8 03 00 00       	push   $0x3f8
  1006d2:	e8 b9 3e 00 00       	call   104590 <outb>
        outb(p, nl);
  1006d7:	58                   	pop    %eax
  1006d8:	5a                   	pop    %edx
  1006d9:	6a 0a                	push   $0xa
  1006db:	68 f8 03 00 00       	push   $0x3f8
  1006e0:	e8 ab 3e 00 00       	call   104590 <outb>
  1006e5:	83 c4 10             	add    $0x10,%esp
}
  1006e8:	83 c4 04             	add    $0x4,%esp
  1006eb:	5b                   	pop    %ebx
  1006ec:	5e                   	pop    %esi
  1006ed:	c3                   	ret    
  1006ee:	66 90                	xchg   %ax,%ax

001006f0 <serial_init>:

void serial_init(void)
{
  1006f0:	83 ec 14             	sub    $0x14,%esp
    /* turn off interrupt */
    outb(COM1 + COM_IER, 0);
  1006f3:	6a 00                	push   $0x0
  1006f5:	68 f9 03 00 00       	push   $0x3f9
  1006fa:	e8 91 3e 00 00       	call   104590 <outb>

    /* set DLAB */
    outb(COM1 + COM_LCR, COM_LCR_DLAB);
  1006ff:	58                   	pop    %eax
  100700:	5a                   	pop    %edx
  100701:	68 80 00 00 00       	push   $0x80
  100706:	68 fb 03 00 00       	push   $0x3fb
  10070b:	e8 80 3e 00 00       	call   104590 <outb>

    /* set baud rate */
    outb(COM1 + COM_DLL, 0x0001 & 0xff);
  100710:	59                   	pop    %ecx
  100711:	58                   	pop    %eax
  100712:	6a 01                	push   $0x1
  100714:	68 f8 03 00 00       	push   $0x3f8
  100719:	e8 72 3e 00 00       	call   104590 <outb>
    outb(COM1 + COM_DLM, 0x0001 >> 8);
  10071e:	58                   	pop    %eax
  10071f:	5a                   	pop    %edx
  100720:	6a 00                	push   $0x0
  100722:	68 f9 03 00 00       	push   $0x3f9
  100727:	e8 64 3e 00 00       	call   104590 <outb>

    /* Set the line status. */
    outb(COM1 + COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);
  10072c:	59                   	pop    %ecx
  10072d:	58                   	pop    %eax
  10072e:	6a 03                	push   $0x3
  100730:	68 fb 03 00 00       	push   $0x3fb
  100735:	e8 56 3e 00 00       	call   104590 <outb>

    /* Enable the FIFO. */
    outb(COM1 + COM_FCR, 0xc7);
  10073a:	58                   	pop    %eax
  10073b:	5a                   	pop    %edx
  10073c:	68 c7 00 00 00       	push   $0xc7
  100741:	68 fa 03 00 00       	push   $0x3fa
  100746:	e8 45 3e 00 00       	call   104590 <outb>

    /* Turn on DTR, RTS, and OUT2. */
    outb(COM1 + COM_MCR, 0x0b);
  10074b:	59                   	pop    %ecx
  10074c:	58                   	pop    %eax
  10074d:	6a 0b                	push   $0xb
  10074f:	68 fc 03 00 00       	push   $0x3fc
  100754:	e8 37 3e 00 00       	call   104590 <outb>

    // Clear any preexisting overrun indications and interrupts
    // Serial COM1 doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100759:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
  100760:	e8 fb 3d 00 00       	call   104560 <inb>
    (void) inb(COM1 + COM_IIR);
  100765:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10076c:	3c ff                	cmp    $0xff,%al
  10076e:	0f 95 05 68 2a 99 00 	setne  0x992a68
    (void) inb(COM1 + COM_IIR);
  100775:	e8 e6 3d 00 00       	call   104560 <inb>
    (void) inb(COM1 + COM_RX);
  10077a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
  100781:	e8 da 3d 00 00       	call   104560 <inb>
}
  100786:	83 c4 1c             	add    $0x1c,%esp
  100789:	c3                   	ret    
  10078a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100790 <serial_intenable>:

void serial_intenable(void)
{
    if (serial_exists) {
  100790:	80 3d 68 2a 99 00 00 	cmpb   $0x0,0x992a68
  100797:	75 07                	jne    1007a0 <serial_intenable+0x10>
  100799:	c3                   	ret    
  10079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  1007a0:	83 ec 14             	sub    $0x14,%esp
        outb(COM1 + COM_IER, 1);
  1007a3:	6a 01                	push   $0x1
  1007a5:	68 f9 03 00 00       	push   $0x3f9
  1007aa:	e8 e1 3d 00 00       	call   104590 <outb>
    if (serial_exists)
  1007af:	83 c4 10             	add    $0x10,%esp
  1007b2:	80 3d 68 2a 99 00 00 	cmpb   $0x0,0x992a68
  1007b9:	75 05                	jne    1007c0 <serial_intenable+0x30>
        serial_intr();
    }
}
  1007bb:	83 c4 0c             	add    $0xc,%esp
  1007be:	c3                   	ret    
  1007bf:	90                   	nop
        cons_intr(serial_proc_data);
  1007c0:	83 ec 0c             	sub    $0xc,%esp
  1007c3:	68 c0 05 10 00       	push   $0x1005c0
  1007c8:	e8 c3 fb ff ff       	call   100390 <cons_intr>
  1007cd:	83 c4 10             	add    $0x10,%esp
}
  1007d0:	83 c4 0c             	add    $0xc,%esp
  1007d3:	c3                   	ret    
  1007d4:	66 90                	xchg   %ax,%ax
  1007d6:	66 90                	xchg   %ax,%ax
  1007d8:	66 90                	xchg   %ax,%ax
  1007da:	66 90                	xchg   %ax,%ax
  1007dc:	66 90                	xchg   %ax,%ax
  1007de:	66 90                	xchg   %ax,%ax

001007e0 <kbd_proc_data>:
/*
 * Get data from the keyboard. If we finish a character, return it. Else 0.
 * Return -1 if no data.
 */
static int kbd_proc_data(void)
{
  1007e0:	53                   	push   %ebx
  1007e1:	83 ec 14             	sub    $0x14,%esp
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0)
  1007e4:	6a 64                	push   $0x64
  1007e6:	e8 75 3d 00 00       	call   104560 <inb>
  1007eb:	83 c4 10             	add    $0x10,%esp
  1007ee:	a8 01                	test   $0x1,%al
  1007f0:	0f 84 1a 01 00 00    	je     100910 <kbd_proc_data+0x130>
        return -1;

    data = inb(KBDATAP);
  1007f6:	83 ec 0c             	sub    $0xc,%esp
  1007f9:	6a 60                	push   $0x60
  1007fb:	e8 60 3d 00 00       	call   104560 <inb>

    if (data == 0xE0) {
  100800:	83 c4 10             	add    $0x10,%esp
  100803:	3c e0                	cmp    $0xe0,%al
  100805:	0f 84 85 00 00 00    	je     100890 <kbd_proc_data+0xb0>
        // E0 escape character
        shift |= E0ESC;
        return 0;
    } else if (data & 0x80) {
  10080b:	8b 0d 20 c4 14 00    	mov    0x14c420,%ecx
  100811:	89 ca                	mov    %ecx,%edx
  100813:	83 e2 40             	and    $0x40,%edx
  100816:	84 c0                	test   %al,%al
  100818:	0f 88 82 00 00 00    	js     1008a0 <kbd_proc_data+0xc0>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    } else if (shift & E0ESC) {
  10081e:	85 d2                	test   %edx,%edx
  100820:	74 06                	je     100828 <kbd_proc_data+0x48>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  100822:	83 c8 80             	or     $0xffffff80,%eax
        shift &= ~E0ESC;
  100825:	83 e1 bf             	and    $0xffffffbf,%ecx
    }

    shift |= shiftcode[data];
  100828:	0f b6 c0             	movzbl %al,%eax
  10082b:	0f b6 90 60 91 10 00 	movzbl 0x109160(%eax),%edx
  100832:	09 ca                	or     %ecx,%edx
    shift ^= togglecode[data];
  100834:	0f b6 88 60 90 10 00 	movzbl 0x109060(%eax),%ecx
  10083b:	31 ca                	xor    %ecx,%edx

    c = charcode[shift & (CTL | SHIFT)][data];
  10083d:	89 d1                	mov    %edx,%ecx
    shift ^= togglecode[data];
  10083f:	89 15 20 c4 14 00    	mov    %edx,0x14c420
    c = charcode[shift & (CTL | SHIFT)][data];
  100845:	83 e1 03             	and    $0x3,%ecx
  100848:	8b 0c 8d 40 90 10 00 	mov    0x109040(,%ecx,4),%ecx
  10084f:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
    if (shift & CAPSLOCK) {
  100853:	f6 c2 08             	test   $0x8,%dl
  100856:	75 20                	jne    100878 <kbd_proc_data+0x98>
        else if ('A' <= c && c <= 'Z')
            c += 'a' - 'A';
    }
    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  100858:	f7 d2                	not    %edx
  10085a:	83 e2 06             	and    $0x6,%edx
  10085d:	75 0c                	jne    10086b <kbd_proc_data+0x8b>
  10085f:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
  100865:	0f 84 7d 00 00 00    	je     1008e8 <kbd_proc_data+0x108>
        dprintf("Rebooting!\n");
        outb(0x92, 0x3);  // courtesy of Chris Frost
    }

    return c;
}
  10086b:	83 c4 08             	add    $0x8,%esp
  10086e:	89 d8                	mov    %ebx,%eax
  100870:	5b                   	pop    %ebx
  100871:	c3                   	ret    
  100872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if ('a' <= c && c <= 'z')
  100878:	8d 43 9f             	lea    -0x61(%ebx),%eax
  10087b:	83 f8 19             	cmp    $0x19,%eax
  10087e:	77 50                	ja     1008d0 <kbd_proc_data+0xf0>
            c += 'A' - 'a';
  100880:	83 eb 20             	sub    $0x20,%ebx
}
  100883:	83 c4 08             	add    $0x8,%esp
  100886:	89 d8                	mov    %ebx,%eax
  100888:	5b                   	pop    %ebx
  100889:	c3                   	ret    
  10088a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return 0;
  100890:	31 db                	xor    %ebx,%ebx
        shift |= E0ESC;
  100892:	83 0d 20 c4 14 00 40 	orl    $0x40,0x14c420
}
  100899:	83 c4 08             	add    $0x8,%esp
  10089c:	89 d8                	mov    %ebx,%eax
  10089e:	5b                   	pop    %ebx
  10089f:	c3                   	ret    
        data = (shift & E0ESC ? data : data & 0x7F);
  1008a0:	89 c3                	mov    %eax,%ebx
  1008a2:	83 e3 7f             	and    $0x7f,%ebx
  1008a5:	85 d2                	test   %edx,%edx
  1008a7:	0f 44 c3             	cmove  %ebx,%eax
        return 0;
  1008aa:	31 db                	xor    %ebx,%ebx
        shift &= ~(shiftcode[data] | E0ESC);
  1008ac:	0f b6 c0             	movzbl %al,%eax
  1008af:	0f b6 90 60 91 10 00 	movzbl 0x109160(%eax),%edx
}
  1008b6:	89 d8                	mov    %ebx,%eax
        shift &= ~(shiftcode[data] | E0ESC);
  1008b8:	83 ca 40             	or     $0x40,%edx
  1008bb:	0f b6 d2             	movzbl %dl,%edx
  1008be:	f7 d2                	not    %edx
  1008c0:	21 ca                	and    %ecx,%edx
  1008c2:	89 15 20 c4 14 00    	mov    %edx,0x14c420
}
  1008c8:	83 c4 08             	add    $0x8,%esp
  1008cb:	5b                   	pop    %ebx
  1008cc:	c3                   	ret    
  1008cd:	8d 76 00             	lea    0x0(%esi),%esi
        else if ('A' <= c && c <= 'Z')
  1008d0:	8d 4b bf             	lea    -0x41(%ebx),%ecx
            c += 'a' - 'A';
  1008d3:	8d 43 20             	lea    0x20(%ebx),%eax
  1008d6:	83 f9 1a             	cmp    $0x1a,%ecx
  1008d9:	0f 42 d8             	cmovb  %eax,%ebx
  1008dc:	e9 77 ff ff ff       	jmp    100858 <kbd_proc_data+0x78>
  1008e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        dprintf("Rebooting!\n");
  1008e8:	83 ec 0c             	sub    $0xc,%esp
  1008eb:	68 1e 90 10 00       	push   $0x10901e
  1008f0:	e8 6b 31 00 00       	call   103a60 <dprintf>
        outb(0x92, 0x3);  // courtesy of Chris Frost
  1008f5:	58                   	pop    %eax
  1008f6:	5a                   	pop    %edx
  1008f7:	6a 03                	push   $0x3
  1008f9:	68 92 00 00 00       	push   $0x92
  1008fe:	e8 8d 3c 00 00       	call   104590 <outb>
  100903:	83 c4 10             	add    $0x10,%esp
  100906:	e9 60 ff ff ff       	jmp    10086b <kbd_proc_data+0x8b>
  10090b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10090f:	90                   	nop
        return -1;
  100910:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  100915:	e9 51 ff ff ff       	jmp    10086b <kbd_proc_data+0x8b>
  10091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100920 <keyboard_intr>:

void keyboard_intr(void)
{
  100920:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  100923:	68 e0 07 10 00       	push   $0x1007e0
  100928:	e8 63 fa ff ff       	call   100390 <cons_intr>
}
  10092d:	83 c4 1c             	add    $0x1c,%esp
  100930:	c3                   	ret    
  100931:	66 90                	xchg   %ax,%ax
  100933:	66 90                	xchg   %ax,%ax
  100935:	66 90                	xchg   %ax,%ax
  100937:	66 90                	xchg   %ax,%ax
  100939:	66 90                	xchg   %ax,%ax
  10093b:	66 90                	xchg   %ax,%ax
  10093d:	66 90                	xchg   %ax,%ax
  10093f:	90                   	nop

00100940 <devinit>:
#include "tsc.h"

void intr_init(void);

void devinit(uintptr_t mbi_addr)
{
  100940:	53                   	push   %ebx
  100941:	83 ec 14             	sub    $0x14,%esp
  100944:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    seg_init(0);
  100948:	6a 00                	push   $0x0
  10094a:	e8 d1 36 00 00       	call   104020 <seg_init>

    enable_sse();
  10094f:	e8 bc 3a 00 00       	call   104410 <enable_sse>

    cons_init();
  100954:	e8 07 fa ff ff       	call   100360 <cons_init>

    debug_init();
  100959:	e8 12 2e 00 00       	call   103770 <debug_init>
    KERN_INFO("[BSP KERN] cons initialized.\n");
  10095e:	c7 04 24 60 92 10 00 	movl   $0x109260,(%esp)
  100965:	e8 66 2e 00 00       	call   1037d0 <debug_info>
    KERN_INFO("[BSP KERN] devinit mbi_addr: %d\n", mbi_addr);
  10096a:	58                   	pop    %eax
  10096b:	5a                   	pop    %edx
  10096c:	53                   	push   %ebx
  10096d:	68 30 93 10 00       	push   $0x109330
  100972:	e8 59 2e 00 00       	call   1037d0 <debug_info>

    /* pcpu init codes */
    pcpu_init();
  100977:	e8 d4 51 00 00       	call   105b50 <pcpu_init>
    KERN_INFO("[BSP KERN] PCPU initialized\n");
  10097c:	c7 04 24 7e 92 10 00 	movl   $0x10927e,(%esp)
  100983:	e8 48 2e 00 00       	call   1037d0 <debug_info>

    tsc_init();
  100988:	e8 03 0f 00 00       	call   101890 <tsc_init>
    KERN_INFO("[BSP KERN] TSC initialized\n");
  10098d:	c7 04 24 9b 92 10 00 	movl   $0x10929b,(%esp)
  100994:	e8 37 2e 00 00       	call   1037d0 <debug_info>

    intr_init();
  100999:	e8 d2 05 00 00       	call   100f70 <intr_init>
    KERN_INFO("[BSP KERN] INTR initialized\n");
  10099e:	c7 04 24 b7 92 10 00 	movl   $0x1092b7,(%esp)
  1009a5:	e8 26 2e 00 00       	call   1037d0 <debug_info>

    trap_init(0);
  1009aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1009b1:	e8 6a 76 00 00       	call   108020 <trap_init>

    pmmap_init(mbi_addr);
  1009b6:	89 5c 24 20          	mov    %ebx,0x20(%esp)
}
  1009ba:	83 c4 18             	add    $0x18,%esp
  1009bd:	5b                   	pop    %ebx
    pmmap_init(mbi_addr);
  1009be:	e9 fd 00 00 00       	jmp    100ac0 <pmmap_init>
  1009c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1009ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001009d0 <devinit_ap>:

void devinit_ap(void)
{
  1009d0:	53                   	push   %ebx
  1009d1:	83 ec 08             	sub    $0x8,%esp
    /* Figure out the current (booting) kernel stack) */
    struct kstack *ks = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  1009d4:	e8 67 39 00 00       	call   104340 <read_esp>

    KERN_ASSERT(ks != NULL);
  1009d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1009de:	89 c3                	mov    %eax,%ebx
  1009e0:	74 5e                	je     100a40 <devinit_ap+0x70>
    KERN_ASSERT(1 <= ks->cpu_idx && ks->cpu_idx < 8);
  1009e2:	8b 83 1c 01 00 00    	mov    0x11c(%ebx),%eax
  1009e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1009eb:	83 fa 06             	cmp    $0x6,%edx
  1009ee:	77 77                	ja     100a67 <devinit_ap+0x97>

    /* kernel stack for this cpu initialized */
    seg_init(ks->cpu_idx);
  1009f0:	83 ec 0c             	sub    $0xc,%esp
  1009f3:	50                   	push   %eax
  1009f4:	e8 27 36 00 00       	call   104020 <seg_init>

    pcpu_init();
  1009f9:	e8 52 51 00 00       	call   105b50 <pcpu_init>
    KERN_INFO("[AP%d KERN] PCPU initialized\n", ks->cpu_idx);
  1009fe:	58                   	pop    %eax
  1009ff:	5a                   	pop    %edx
  100a00:	ff b3 1c 01 00 00    	pushl  0x11c(%ebx)
  100a06:	68 0f 93 10 00       	push   $0x10930f
  100a0b:	e8 c0 2d 00 00       	call   1037d0 <debug_info>

    intr_init();
  100a10:	e8 5b 05 00 00       	call   100f70 <intr_init>
    KERN_INFO("[AP%d KERN] INTR initialized.\n", ks->cpu_idx);
  100a15:	59                   	pop    %ecx
  100a16:	58                   	pop    %eax
  100a17:	ff b3 1c 01 00 00    	pushl  0x11c(%ebx)
  100a1d:	68 78 93 10 00       	push   $0x109378
  100a22:	e8 a9 2d 00 00       	call   1037d0 <debug_info>

    trap_init(ks->cpu_idx);
  100a27:	58                   	pop    %eax
  100a28:	ff b3 1c 01 00 00    	pushl  0x11c(%ebx)
  100a2e:	e8 ed 75 00 00       	call   108020 <trap_init>

    paging_init_ap();
}
  100a33:	83 c4 18             	add    $0x18,%esp
  100a36:	5b                   	pop    %ebx
    paging_init_ap();
  100a37:	e9 04 60 00 00       	jmp    106a40 <paging_init_ap>
  100a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    KERN_ASSERT(ks != NULL);
  100a40:	68 d4 92 10 00       	push   $0x1092d4
  100a45:	68 df 92 10 00       	push   $0x1092df
  100a4a:	6a 31                	push   $0x31
  100a4c:	68 fc 92 10 00       	push   $0x1092fc
  100a51:	e8 fa 2d 00 00       	call   103850 <debug_panic>
    KERN_ASSERT(1 <= ks->cpu_idx && ks->cpu_idx < 8);
  100a56:	8b 83 1c 01 00 00    	mov    0x11c(%ebx),%eax
    KERN_ASSERT(ks != NULL);
  100a5c:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(1 <= ks->cpu_idx && ks->cpu_idx < 8);
  100a5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  100a62:	83 fa 06             	cmp    $0x6,%edx
  100a65:	76 89                	jbe    1009f0 <devinit_ap+0x20>
  100a67:	68 54 93 10 00       	push   $0x109354
  100a6c:	68 df 92 10 00       	push   $0x1092df
  100a71:	6a 32                	push   $0x32
  100a73:	68 fc 92 10 00       	push   $0x1092fc
  100a78:	e8 d3 2d 00 00       	call   103850 <debug_panic>
  100a7d:	8b 83 1c 01 00 00    	mov    0x11c(%ebx),%eax
  100a83:	83 c4 10             	add    $0x10,%esp
  100a86:	e9 65 ff ff ff       	jmp    1009f0 <devinit_ap+0x20>
  100a8b:	66 90                	xchg   %ax,%ax
  100a8d:	66 90                	xchg   %ax,%ax
  100a8f:	90                   	nop

00100a90 <pmmap_alloc_slot>:
    if (unlikely(pmmap_slots_next_free == 128))
  100a90:	a1 5c c4 14 00       	mov    0x14c45c,%eax
  100a95:	3d 80 00 00 00       	cmp    $0x80,%eax
  100a9a:	74 14                	je     100ab0 <pmmap_alloc_slot+0x20>
    return &pmmap_slots[pmmap_slots_next_free++];
  100a9c:	8d 50 01             	lea    0x1(%eax),%edx
  100a9f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  100aa2:	89 15 5c c4 14 00    	mov    %edx,0x14c45c
  100aa8:	8d 04 85 60 c4 14 00 	lea    0x14c460(,%eax,4),%eax
  100aaf:	c3                   	ret    
        return NULL;
  100ab0:	31 c0                	xor    %eax,%eax
}
  100ab2:	c3                   	ret    
  100ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100ac0 <pmmap_init>:
                  (slot->type == MEM_NVS) ? "ACPI NVS" : "unknown");
    }
}

void pmmap_init(uintptr_t mbi_addr)
{
  100ac0:	55                   	push   %ebp
  100ac1:	57                   	push   %edi
  100ac2:	56                   	push   %esi
  100ac3:	53                   	push   %ebx
  100ac4:	83 ec 48             	sub    $0x48,%esp
  100ac7:	8b 5c 24 5c          	mov    0x5c(%esp),%ebx
    KERN_INFO("\n");
  100acb:	68 70 a7 10 00       	push   $0x10a770
  100ad0:	e8 fb 2c 00 00       	call   1037d0 <debug_info>
    SLIST_INIT(&pmmap_sublist[PMMAP_NVS]);

    /*
     * Copy memory map information from multiboot information mbi to pmmap.
     */
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100ad5:	8b 73 2c             	mov    0x2c(%ebx),%esi
    mboot_mmap_t *p = (mboot_mmap_t *) mbi->mmap_addr;
  100ad8:	8b 43 30             	mov    0x30(%ebx),%eax
    SLIST_INIT(&pmmap_list);
  100adb:	c7 05 58 c4 14 00 00 	movl   $0x0,0x14c458
  100ae2:	00 00 00 
    SLIST_INIT(&pmmap_sublist[PMMAP_USABLE]);
  100ae5:	c7 05 48 c4 14 00 00 	movl   $0x0,0x14c448
  100aec:	00 00 00 
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100aef:	89 74 24 24          	mov    %esi,0x24(%esp)
  100af3:	83 c4 10             	add    $0x10,%esp
    SLIST_INIT(&pmmap_sublist[PMMAP_RESV]);
  100af6:	c7 05 4c c4 14 00 00 	movl   $0x0,0x14c44c
  100afd:	00 00 00 
    SLIST_INIT(&pmmap_sublist[PMMAP_ACPI]);
  100b00:	c7 05 50 c4 14 00 00 	movl   $0x0,0x14c450
  100b07:	00 00 00 
    SLIST_INIT(&pmmap_sublist[PMMAP_NVS]);
  100b0a:	c7 05 54 c4 14 00 00 	movl   $0x0,0x14c454
  100b11:	00 00 00 
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100b14:	85 f6                	test   %esi,%esi
  100b16:	0f 84 a6 02 00 00    	je     100dc2 <pmmap_init+0x302>
  100b1c:	ba e8 ff ff ff       	mov    $0xffffffe8,%edx
  100b21:	31 db                	xor    %ebx,%ebx
  100b23:	c6 44 24 1f 00       	movb   $0x0,0x1f(%esp)
  100b28:	8d 48 18             	lea    0x18(%eax),%ecx
  100b2b:	29 c2                	sub    %eax,%edx
  100b2d:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b31:	8b 2d 5c c4 14 00    	mov    0x14c45c,%ebp
  100b37:	31 f6                	xor    %esi,%esi
  100b39:	89 54 24 18          	mov    %edx,0x18(%esp)
  100b3d:	8d 76 00             	lea    0x0(%esi),%esi
        uintptr_t start, end;
        uint32_t type;

        if (p->base_addr_high != 0)  /* ignore address above 4G */
  100b40:	8b 50 08             	mov    0x8(%eax),%edx
  100b43:	85 d2                	test   %edx,%edx
  100b45:	0f 85 a5 00 00 00    	jne    100bf0 <pmmap_init+0x130>
            goto next;
        else
            start = p->base_addr_low;

        if (p->length_high != 0 || p->length_low >= 0xffffffff - start)
  100b4b:	8b 78 10             	mov    0x10(%eax),%edi
            start = p->base_addr_low;
  100b4e:	8b 50 04             	mov    0x4(%eax),%edx
            end = 0xffffffff;
  100b51:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
        if (p->length_high != 0 || p->length_low >= 0xffffffff - start)
  100b56:	85 ff                	test   %edi,%edi
  100b58:	75 15                	jne    100b6f <pmmap_init+0xaf>
        else
            end = start + p->length_low;
  100b5a:	8b 78 0c             	mov    0xc(%eax),%edi
  100b5d:	01 d7                	add    %edx,%edi
  100b5f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100b63:	89 d7                	mov    %edx,%edi
  100b65:	f7 d7                	not    %edi
  100b67:	39 78 0c             	cmp    %edi,0xc(%eax)
  100b6a:	0f 42 5c 24 0c       	cmovb  0xc(%esp),%ebx

        type = p->type;
  100b6f:	8b 40 14             	mov    0x14(%eax),%eax
    if (unlikely(pmmap_slots_next_free == 128))
  100b72:	81 fd 80 00 00 00    	cmp    $0x80,%ebp
  100b78:	0f 84 82 f4 ff ff    	je     100000 <pmmap_init.cold>
    return &pmmap_slots[pmmap_slots_next_free++];
  100b7e:	8d 75 01             	lea    0x1(%ebp),%esi
  100b81:	8d 7c ad 00          	lea    0x0(%ebp,%ebp,4),%edi
  100b85:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100b89:	8d 34 bd 60 c4 14 00 	lea    0x14c460(,%edi,4),%esi
    free_slot->type = type;
  100b90:	89 46 08             	mov    %eax,0x8(%esi)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100b93:	8b 44 24 10          	mov    0x10(%esp),%eax
    free_slot->start = start;
  100b97:	89 14 bd 60 c4 14 00 	mov    %edx,0x14c460(,%edi,4)
    free_slot->end = end;
  100b9e:	89 5e 04             	mov    %ebx,0x4(%esi)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100ba1:	85 c0                	test   %eax,%eax
  100ba3:	74 28                	je     100bcd <pmmap_init+0x10d>
    last_slot = NULL;
  100ba5:	31 ff                	xor    %edi,%edi
  100ba7:	eb 16                	jmp    100bbf <pmmap_init+0xff>
  100ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100bb0:	8b 58 0c             	mov    0xc(%eax),%ebx
  100bb3:	89 c7                	mov    %eax,%edi
  100bb5:	85 db                	test   %ebx,%ebx
  100bb7:	0f 84 23 02 00 00    	je     100de0 <pmmap_init+0x320>
  100bbd:	89 d8                	mov    %ebx,%eax
        if (start < slot->start)
  100bbf:	3b 10                	cmp    (%eax),%edx
  100bc1:	73 ed                	jae    100bb0 <pmmap_init+0xf0>
    if (last_slot == NULL) {
  100bc3:	89 f8                	mov    %edi,%eax
  100bc5:	85 ff                	test   %edi,%edi
  100bc7:	0f 85 13 02 00 00    	jne    100de0 <pmmap_init+0x320>
        SLIST_INSERT_HEAD(&pmmap_list, free_slot, next);
  100bcd:	8b 7c 24 10          	mov    0x10(%esp),%edi
  100bd1:	8d 44 ad 00          	lea    0x0(%ebp,%ebp,4),%eax
    return &pmmap_slots[pmmap_slots_next_free++];
  100bd5:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
        SLIST_INSERT_HEAD(&pmmap_list, free_slot, next);
  100bd9:	89 74 24 10          	mov    %esi,0x10(%esp)
  100bdd:	c6 44 24 1f 01       	movb   $0x1,0x1f(%esp)
  100be2:	be 01 00 00 00       	mov    $0x1,%esi
  100be7:	89 3c 85 6c c4 14 00 	mov    %edi,0x14c46c(,%eax,4)
  100bee:	66 90                	xchg   %ax,%ax
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100bf0:	8b 7c 24 18          	mov    0x18(%esp),%edi

        pmmap_insert(start, end, type);

      next:
        p = (mboot_mmap_t *) (((uint32_t) p) + sizeof(mboot_mmap_t) /* p->size */);
  100bf4:	89 c8                	mov    %ecx,%eax
    while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  100bf6:	83 c1 18             	add    $0x18,%ecx
  100bf9:	8d 14 0f             	lea    (%edi,%ecx,1),%edx
  100bfc:	39 54 24 14          	cmp    %edx,0x14(%esp)
  100c00:	0f 87 3a ff ff ff    	ja     100b40 <pmmap_init+0x80>
  100c06:	89 f0                	mov    %esi,%eax
  100c08:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  100c0c:	84 c0                	test   %al,%al
  100c0e:	74 06                	je     100c16 <pmmap_init+0x156>
  100c10:	89 2d 5c c4 14 00    	mov    %ebp,0x14c45c
  100c16:	80 7c 24 1f 00       	cmpb   $0x0,0x1f(%esp)
  100c1b:	0f 84 a1 01 00 00    	je     100dc2 <pmmap_init+0x302>
  100c21:	89 1d 58 c4 14 00    	mov    %ebx,0x14c458
    struct pmmap *last_slot[4] = { NULL, NULL, NULL, NULL };
  100c27:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
  100c2e:	00 
  100c2f:	c7 44 24 24 00 00 00 	movl   $0x0,0x24(%esp)
  100c36:	00 
  100c37:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  100c3e:	00 
  100c3f:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  100c46:	00 
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100c47:	85 db                	test   %ebx,%ebx
  100c49:	0f 84 73 01 00 00    	je     100dc2 <pmmap_init+0x302>
        if ((next_slot = SLIST_NEXT(slot, next)) == NULL)
  100c4f:	8b 43 0c             	mov    0xc(%ebx),%eax
  100c52:	85 c0                	test   %eax,%eax
  100c54:	74 2c                	je     100c82 <pmmap_init+0x1c2>
  100c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100c5d:	8d 76 00             	lea    0x0(%esi),%esi
        if (slot->start <= next_slot->start &&
  100c60:	8b 10                	mov    (%eax),%edx
  100c62:	39 13                	cmp    %edx,(%ebx)
  100c64:	77 13                	ja     100c79 <pmmap_init+0x1b9>
            slot->end >= next_slot->start &&
  100c66:	8b 4b 04             	mov    0x4(%ebx),%ecx
        if (slot->start <= next_slot->start &&
  100c69:	39 ca                	cmp    %ecx,%edx
  100c6b:	77 0c                	ja     100c79 <pmmap_init+0x1b9>
            slot->end >= next_slot->start &&
  100c6d:	8b 70 08             	mov    0x8(%eax),%esi
  100c70:	39 73 08             	cmp    %esi,0x8(%ebx)
  100c73:	0f 84 87 01 00 00    	je     100e00 <pmmap_init+0x340>
        SLIST_INSERT_AFTER(last_slot, free_slot, next);
  100c79:	89 c3                	mov    %eax,%ebx
        if ((next_slot = SLIST_NEXT(slot, next)) == NULL)
  100c7b:	8b 43 0c             	mov    0xc(%ebx),%eax
  100c7e:	85 c0                	test   %eax,%eax
  100c80:	75 de                	jne    100c60 <pmmap_init+0x1a0>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100c82:	8b 1d 58 c4 14 00    	mov    0x14c458,%ebx
  100c88:	85 db                	test   %ebx,%ebx
  100c8a:	75 20                	jne    100cac <pmmap_init+0x1ec>
  100c8c:	e9 31 01 00 00       	jmp    100dc2 <pmmap_init+0x302>
  100c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            SLIST_INSERT_AFTER(last_slot[sublist_nr], slot, type_next);
  100c98:	8b 4a 10             	mov    0x10(%edx),%ecx
        last_slot[sublist_nr] = slot;
  100c9b:	89 5c 84 20          	mov    %ebx,0x20(%esp,%eax,4)
            SLIST_INSERT_AFTER(last_slot[sublist_nr], slot, type_next);
  100c9f:	89 4b 10             	mov    %ecx,0x10(%ebx)
  100ca2:	89 5a 10             	mov    %ebx,0x10(%edx)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100ca5:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  100ca8:	85 db                	test   %ebx,%ebx
  100caa:	74 70                	je     100d1c <pmmap_init+0x25c>
        sublist_nr = PMMAP_SUBLIST_NR(slot->type);
  100cac:	8b 53 08             	mov    0x8(%ebx),%edx
  100caf:	31 c0                	xor    %eax,%eax
  100cb1:	83 fa 01             	cmp    $0x1,%edx
  100cb4:	74 42                	je     100cf8 <pmmap_init+0x238>
  100cb6:	b8 01 00 00 00       	mov    $0x1,%eax
  100cbb:	83 fa 02             	cmp    $0x2,%edx
  100cbe:	74 38                	je     100cf8 <pmmap_init+0x238>
  100cc0:	b8 02 00 00 00       	mov    $0x2,%eax
  100cc5:	83 fa 03             	cmp    $0x3,%edx
  100cc8:	74 2e                	je     100cf8 <pmmap_init+0x238>
  100cca:	b8 03 00 00 00       	mov    $0x3,%eax
  100ccf:	83 fa 04             	cmp    $0x4,%edx
  100cd2:	74 24                	je     100cf8 <pmmap_init+0x238>
        KERN_ASSERT(sublist_nr != -1);
  100cd4:	68 f0 93 10 00       	push   $0x1093f0
  100cd9:	68 df 92 10 00       	push   $0x1092df
  100cde:	6a 6b                	push   $0x6b
  100ce0:	68 df 93 10 00       	push   $0x1093df
  100ce5:	e8 66 2b 00 00       	call   103850 <debug_panic>
  100cea:	83 c4 10             	add    $0x10,%esp
        sublist_nr = PMMAP_SUBLIST_NR(slot->type);
  100ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (last_slot[sublist_nr] != NULL)
  100cf8:	8b 54 84 20          	mov    0x20(%esp,%eax,4),%edx
  100cfc:	85 d2                	test   %edx,%edx
  100cfe:	75 98                	jne    100c98 <pmmap_init+0x1d8>
            SLIST_INSERT_HEAD(&pmmap_sublist[sublist_nr], slot, type_next);
  100d00:	8b 14 85 48 c4 14 00 	mov    0x14c448(,%eax,4),%edx
        last_slot[sublist_nr] = slot;
  100d07:	89 5c 84 20          	mov    %ebx,0x20(%esp,%eax,4)
            SLIST_INSERT_HEAD(&pmmap_sublist[sublist_nr], slot, type_next);
  100d0b:	89 1c 85 48 c4 14 00 	mov    %ebx,0x14c448(,%eax,4)
  100d12:	89 53 10             	mov    %edx,0x10(%ebx)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d15:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  100d18:	85 db                	test   %ebx,%ebx
  100d1a:	75 90                	jne    100cac <pmmap_init+0x1ec>
    if (last_slot[PMMAP_USABLE] != NULL)
  100d1c:	8b 44 24 20          	mov    0x20(%esp),%eax
  100d20:	8b 1d 58 c4 14 00    	mov    0x14c458,%ebx
  100d26:	85 c0                	test   %eax,%eax
  100d28:	74 08                	je     100d32 <pmmap_init+0x272>
        max_usable_memory = last_slot[PMMAP_USABLE]->end;
  100d2a:	8b 40 04             	mov    0x4(%eax),%eax
  100d2d:	a3 44 c4 14 00       	mov    %eax,0x14c444
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d32:	85 db                	test   %ebx,%ebx
  100d34:	0f 84 88 00 00 00    	je     100dc2 <pmmap_init+0x302>
  100d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        KERN_INFO("BIOS-e820: 0x%08x - 0x%08x (%s)\n",
  100d40:	8b 43 08             	mov    0x8(%ebx),%eax
  100d43:	ba 97 93 10 00       	mov    $0x109397,%edx
  100d48:	83 f8 01             	cmp    $0x1,%eax
  100d4b:	74 24                	je     100d71 <pmmap_init+0x2b1>
  100d4d:	ba 9e 93 10 00       	mov    $0x10939e,%edx
  100d52:	83 f8 02             	cmp    $0x2,%eax
  100d55:	74 1a                	je     100d71 <pmmap_init+0x2b1>
  100d57:	ba a7 93 10 00       	mov    $0x1093a7,%edx
  100d5c:	83 f8 03             	cmp    $0x3,%eax
  100d5f:	74 10                	je     100d71 <pmmap_init+0x2b1>
  100d61:	83 f8 04             	cmp    $0x4,%eax
  100d64:	ba b1 93 10 00       	mov    $0x1093b1,%edx
  100d69:	b8 ba 93 10 00       	mov    $0x1093ba,%eax
  100d6e:	0f 45 d0             	cmovne %eax,%edx
  100d71:	8b 3b                	mov    (%ebx),%edi
  100d73:	8b 43 04             	mov    0x4(%ebx),%eax
  100d76:	39 c7                	cmp    %eax,%edi
  100d78:	74 0c                	je     100d86 <pmmap_init+0x2c6>
  100d7a:	31 c9                	xor    %ecx,%ecx
  100d7c:	83 f8 ff             	cmp    $0xffffffff,%eax
  100d7f:	0f 95 c1             	setne  %cl
  100d82:	89 ce                	mov    %ecx,%esi
  100d84:	29 f0                	sub    %esi,%eax
  100d86:	52                   	push   %edx
  100d87:	50                   	push   %eax
  100d88:	57                   	push   %edi
  100d89:	68 04 94 10 00       	push   $0x109404
  100d8e:	e8 3d 2a 00 00       	call   1037d0 <debug_info>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d93:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  100d96:	83 c4 10             	add    $0x10,%esp
  100d99:	85 db                	test   %ebx,%ebx
  100d9b:	75 a3                	jne    100d40 <pmmap_init+0x280>
    pmmap_merge();
    pmmap_dump();

    /* count the number of pmmap entries */
    struct pmmap *slot;
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100d9d:	8b 15 58 c4 14 00    	mov    0x14c458,%edx
  100da3:	85 d2                	test   %edx,%edx
  100da5:	74 1b                	je     100dc2 <pmmap_init+0x302>
  100da7:	a1 40 c4 14 00       	mov    0x14c440,%eax
  100dac:	83 c0 01             	add    $0x1,%eax
  100daf:	90                   	nop
  100db0:	8b 52 0c             	mov    0xc(%edx),%edx
        pmmap_nentries++;
  100db3:	89 c1                	mov    %eax,%ecx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100db5:	83 c0 01             	add    $0x1,%eax
  100db8:	85 d2                	test   %edx,%edx
  100dba:	75 f4                	jne    100db0 <pmmap_init+0x2f0>
  100dbc:	89 0d 40 c4 14 00    	mov    %ecx,0x14c440
    }

    /* Calculate the maximum page number */
    mem_npages = rounddown(max_usable_memory, PAGESIZE) / PAGESIZE;
  100dc2:	83 ec 08             	sub    $0x8,%esp
  100dc5:	68 00 10 00 00       	push   $0x1000
  100dca:	ff 35 44 c4 14 00    	pushl  0x14c444
  100dd0:	e8 2b 35 00 00       	call   104300 <rounddown>
}
  100dd5:	83 c4 4c             	add    $0x4c,%esp
  100dd8:	5b                   	pop    %ebx
  100dd9:	5e                   	pop    %esi
  100dda:	5f                   	pop    %edi
  100ddb:	5d                   	pop    %ebp
  100ddc:	c3                   	ret    
  100ddd:	8d 76 00             	lea    0x0(%esi),%esi
        SLIST_INSERT_AFTER(last_slot, free_slot, next);
  100de0:	8b 58 0c             	mov    0xc(%eax),%ebx
  100de3:	8d 54 ad 00          	lea    0x0(%ebp,%ebp,4),%edx
    return &pmmap_slots[pmmap_slots_next_free++];
  100de7:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
        SLIST_INSERT_AFTER(last_slot, free_slot, next);
  100deb:	89 1c 95 6c c4 14 00 	mov    %ebx,0x14c46c(,%edx,4)
  100df2:	89 70 0c             	mov    %esi,0xc(%eax)
  100df5:	be 01 00 00 00       	mov    $0x1,%esi
  100dfa:	e9 f1 fd ff ff       	jmp    100bf0 <pmmap_init+0x130>
  100dff:	90                   	nop
            slot->end = max(slot->end, next_slot->end);
  100e00:	83 ec 08             	sub    $0x8,%esp
  100e03:	ff 70 04             	pushl  0x4(%eax)
  100e06:	51                   	push   %ecx
  100e07:	e8 d4 34 00 00       	call   1042e0 <max>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e0c:	83 c4 10             	add    $0x10,%esp
            slot->end = max(slot->end, next_slot->end);
  100e0f:	89 43 04             	mov    %eax,0x4(%ebx)
            SLIST_REMOVE_AFTER(slot, next);
  100e12:	8b 43 0c             	mov    0xc(%ebx),%eax
  100e15:	8b 40 0c             	mov    0xc(%eax),%eax
  100e18:	89 43 0c             	mov    %eax,0xc(%ebx)
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e1b:	85 c0                	test   %eax,%eax
  100e1d:	0f 84 5f fe ff ff    	je     100c82 <pmmap_init+0x1c2>
        SLIST_INSERT_AFTER(last_slot, free_slot, next);
  100e23:	89 c3                	mov    %eax,%ebx
  100e25:	e9 51 fe ff ff       	jmp    100c7b <pmmap_init+0x1bb>
  100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100e30 <get_size>:

int get_size(void)
{
    return pmmap_nentries;
}
  100e30:	a1 40 c4 14 00       	mov    0x14c440,%eax
  100e35:	c3                   	ret    
  100e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100e3d:	8d 76 00             	lea    0x0(%esi),%esi

00100e40 <get_mms>:
uint32_t get_mms(int idx)
{
    int i = 0;
    struct pmmap *slot = NULL;

    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e40:	a1 58 c4 14 00       	mov    0x14c458,%eax
{
  100e45:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e49:	85 c0                	test   %eax,%eax
  100e4b:	74 19                	je     100e66 <get_mms+0x26>
    int i = 0;
  100e4d:	31 d2                	xor    %edx,%edx
        if (i == idx)
  100e4f:	85 c9                	test   %ecx,%ecx
  100e51:	75 09                	jne    100e5c <get_mms+0x1c>
  100e53:	eb 1b                	jmp    100e70 <get_mms+0x30>
  100e55:	8d 76 00             	lea    0x0(%esi),%esi
  100e58:	39 d1                	cmp    %edx,%ecx
  100e5a:	74 14                	je     100e70 <get_mms+0x30>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e5c:	8b 40 0c             	mov    0xc(%eax),%eax
            break;
        i++;
  100e5f:	83 c2 01             	add    $0x1,%edx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e62:	85 c0                	test   %eax,%eax
  100e64:	75 f2                	jne    100e58 <get_mms+0x18>
    }

    if (slot == NULL || i == pmmap_nentries)
        return 0;
  100e66:	31 c9                	xor    %ecx,%ecx

    return slot->start;
}
  100e68:	89 c8                	mov    %ecx,%eax
  100e6a:	c3                   	ret    
  100e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100e6f:	90                   	nop
        return 0;
  100e70:	31 c9                	xor    %ecx,%ecx
    if (slot == NULL || i == pmmap_nentries)
  100e72:	39 15 40 c4 14 00    	cmp    %edx,0x14c440
  100e78:	74 ee                	je     100e68 <get_mms+0x28>
    return slot->start;
  100e7a:	8b 08                	mov    (%eax),%ecx
}
  100e7c:	89 c8                	mov    %ecx,%eax
  100e7e:	c3                   	ret    
  100e7f:	90                   	nop

00100e80 <get_mml>:
uint32_t get_mml(int idx)
{
    int i = 0;
    struct pmmap *slot = NULL;

    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e80:	8b 15 58 c4 14 00    	mov    0x14c458,%edx
{
  100e86:	8b 44 24 04          	mov    0x4(%esp),%eax
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100e8a:	85 d2                	test   %edx,%edx
  100e8c:	74 20                	je     100eae <get_mml+0x2e>
    int i = 0;
  100e8e:	31 c9                	xor    %ecx,%ecx
        if (i == idx)
  100e90:	85 c0                	test   %eax,%eax
  100e92:	75 10                	jne    100ea4 <get_mml+0x24>
  100e94:	eb 22                	jmp    100eb8 <get_mml+0x38>
  100e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100e9d:	8d 76 00             	lea    0x0(%esi),%esi
  100ea0:	39 c8                	cmp    %ecx,%eax
  100ea2:	74 14                	je     100eb8 <get_mml+0x38>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100ea4:	8b 52 0c             	mov    0xc(%edx),%edx
            break;
        i++;
  100ea7:	83 c1 01             	add    $0x1,%ecx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100eaa:	85 d2                	test   %edx,%edx
  100eac:	75 f2                	jne    100ea0 <get_mml+0x20>
    }

    if (slot == NULL || i == pmmap_nentries)
        return 0;
  100eae:	31 c0                	xor    %eax,%eax
  100eb0:	c3                   	ret    
  100eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100eb8:	31 c0                	xor    %eax,%eax
    if (slot == NULL || i == pmmap_nentries)
  100eba:	39 0d 40 c4 14 00    	cmp    %ecx,0x14c440
  100ec0:	74 0e                	je     100ed0 <get_mml+0x50>

    return slot->end - slot->start;
  100ec2:	8b 42 04             	mov    0x4(%edx),%eax
  100ec5:	2b 02                	sub    (%edx),%eax
  100ec7:	c3                   	ret    
  100ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100ecf:	90                   	nop
}
  100ed0:	c3                   	ret    
  100ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100edf:	90                   	nop

00100ee0 <is_usable>:
int is_usable(int idx)
{
    int i = 0;
    struct pmmap *slot = NULL;

    SLIST_FOREACH(slot, &pmmap_list, next) {
  100ee0:	a1 58 c4 14 00       	mov    0x14c458,%eax
{
  100ee5:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100ee9:	85 c0                	test   %eax,%eax
  100eeb:	74 19                	je     100f06 <is_usable+0x26>
    int i = 0;
  100eed:	31 d2                	xor    %edx,%edx
        if (i == idx)
  100eef:	85 c9                	test   %ecx,%ecx
  100ef1:	75 09                	jne    100efc <is_usable+0x1c>
  100ef3:	eb 1b                	jmp    100f10 <is_usable+0x30>
  100ef5:	8d 76 00             	lea    0x0(%esi),%esi
  100ef8:	39 d1                	cmp    %edx,%ecx
  100efa:	74 14                	je     100f10 <is_usable+0x30>
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100efc:	8b 40 0c             	mov    0xc(%eax),%eax
            break;
        i++;
  100eff:	83 c2 01             	add    $0x1,%edx
    SLIST_FOREACH(slot, &pmmap_list, next) {
  100f02:	85 c0                	test   %eax,%eax
  100f04:	75 f2                	jne    100ef8 <is_usable+0x18>
    }

    if (slot == NULL || i == pmmap_nentries)
        return 0;
  100f06:	31 c9                	xor    %ecx,%ecx

    return slot->type == MEM_RAM;
}
  100f08:	89 c8                	mov    %ecx,%eax
  100f0a:	c3                   	ret    
  100f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100f0f:	90                   	nop
        return 0;
  100f10:	31 c9                	xor    %ecx,%ecx
    if (slot == NULL || i == pmmap_nentries)
  100f12:	39 15 40 c4 14 00    	cmp    %edx,0x14c440
  100f18:	74 ee                	je     100f08 <is_usable+0x28>
    return slot->type == MEM_RAM;
  100f1a:	31 c9                	xor    %ecx,%ecx
  100f1c:	83 78 08 01          	cmpl   $0x1,0x8(%eax)
  100f20:	0f 94 c1             	sete   %cl
}
  100f23:	89 c8                	mov    %ecx,%eax
  100f25:	c3                   	ret    
  100f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100f2d:	8d 76 00             	lea    0x0(%esi),%esi

00100f30 <set_cr3>:

void set_cr3(unsigned int **pdir)
{
    lcr3((uint32_t) pdir);
  100f30:	e9 fb 35 00 00       	jmp    104530 <lcr3>
  100f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00100f40 <enable_paging>:
}

void enable_paging(void)
{
  100f40:	83 ec 0c             	sub    $0xc,%esp
    /* enable global pages (Sec 4.10.2.4, Intel ASDM Vol3) */
    uint32_t cr4 = rcr4();
  100f43:	e8 08 36 00 00       	call   104550 <rcr4>
    cr4 |= CR4_PGE;
    lcr4(cr4);
  100f48:	83 ec 0c             	sub    $0xc,%esp
    cr4 |= CR4_PGE;
  100f4b:	0c 80                	or     $0x80,%al
    lcr4(cr4);
  100f4d:	50                   	push   %eax
  100f4e:	e8 ed 35 00 00       	call   104540 <lcr4>

    /* turn on paging */
    uint32_t cr0 = rcr0();
  100f53:	e8 b8 35 00 00       	call   104510 <rcr0>
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_MP;
    cr0 &= ~(CR0_EM | CR0_TS);
  100f58:	83 e0 f3             	and    $0xfffffff3,%eax
  100f5b:	0d 23 00 05 80       	or     $0x80050023,%eax
    lcr0(cr0);
  100f60:	89 04 24             	mov    %eax,(%esp)
  100f63:	e8 98 35 00 00       	call   104500 <lcr0>
}
  100f68:	83 c4 1c             	add    $0x1c,%esp
  100f6b:	c3                   	ret    
  100f6c:	66 90                	xchg   %ax,%ax
  100f6e:	66 90                	xchg   %ax,%ax

00100f70 <intr_init>:
{
    asm volatile ("lidt %0" :: "m" (idt_pd));
}

void intr_init(void)
{
  100f70:	56                   	push   %esi
  100f71:	53                   	push   %ebx
  100f72:	83 ec 20             	sub    $0x20,%esp
    uint32_t dummy, edx;

    cpuid(0x00000001, &dummy, &dummy, &dummy, &edx);
  100f75:	8d 44 24 18          	lea    0x18(%esp),%eax
  100f79:	50                   	push   %eax
  100f7a:	8d 44 24 18          	lea    0x18(%esp),%eax
  100f7e:	50                   	push   %eax
  100f7f:	50                   	push   %eax
  100f80:	50                   	push   %eax
  100f81:	6a 01                	push   $0x1
  100f83:	e8 a8 34 00 00       	call   104430 <cpuid>
    using_apic = (edx & CPUID_FEATURE_APIC) ? TRUE : FALSE;
  100f88:	8b 44 24 2c          	mov    0x2c(%esp),%eax
    KERN_ASSERT(using_apic == TRUE);
  100f8c:	83 c4 20             	add    $0x20,%esp
    using_apic = (edx & CPUID_FEATURE_APIC) ? TRUE : FALSE;
  100f8f:	c1 e8 09             	shr    $0x9,%eax
  100f92:	83 e0 01             	and    $0x1,%eax
  100f95:	a2 60 ce 14 00       	mov    %al,0x14ce60
    KERN_ASSERT(using_apic == TRUE);
  100f9a:	0f b6 05 60 ce 14 00 	movzbl 0x14ce60,%eax
  100fa1:	3c 01                	cmp    $0x1,%al
  100fa3:	74 19                	je     100fbe <intr_init+0x4e>
  100fa5:	68 25 94 10 00       	push   $0x109425
  100faa:	68 df 92 10 00       	push   $0x1092df
  100faf:	6a 63                	push   $0x63
  100fb1:	68 38 94 10 00       	push   $0x109438
  100fb6:	e8 95 28 00 00       	call   103850 <debug_panic>
  100fbb:	83 c4 10             	add    $0x10,%esp

    if (pcpu_onboot())
  100fbe:	e8 ed 21 00 00       	call   1031b0 <pcpu_onboot>
  100fc3:	84 c0                	test   %al,%al
  100fc5:	75 21                	jne    100fe8 <intr_init+0x78>
            intr_init_idt();
        }
    }

    /* all processors */
    if (using_apic)
  100fc7:	0f b6 05 60 ce 14 00 	movzbl 0x14ce60,%eax
  100fce:	84 c0                	test   %al,%al
  100fd0:	0f 85 ba 04 00 00    	jne    101490 <intr_init+0x520>
    asm volatile ("lidt %0" :: "m" (idt_pd));
  100fd6:	0f 01 1d 00 13 11 00 	lidtl  0x111300
    {
        lapic_init();
    }
    intr_install_idt();
}
  100fdd:	83 c4 14             	add    $0x14,%esp
  100fe0:	5b                   	pop    %ebx
  100fe1:	5e                   	pop    %esi
  100fe2:	c3                   	ret    
  100fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100fe7:	90                   	nop
        pic_init();
  100fe8:	e8 43 06 00 00       	call   101630 <pic_init>
        if (using_apic)
  100fed:	0f b6 05 60 ce 14 00 	movzbl 0x14ce60,%eax
  100ff4:	84 c0                	test   %al,%al
  100ff6:	74 cf                	je     100fc7 <intr_init+0x57>
            ioapic_init();
  100ff8:	e8 63 15 00 00       	call   102560 <ioapic_init>
        SETGATE(idt[i], 0, CPU_GDT_KCODE, &Xdefault, 0);
  100ffd:	bb 7e 1d 10 00       	mov    $0x101d7e,%ebx
    for (i = 0; i < sizeof(idt) / sizeof(idt[0]); i++)
  101002:	31 c0                	xor    %eax,%eax
        SETGATE(idt[i], 0, CPU_GDT_KCODE, &Xdefault, 0);
  101004:	89 de                	mov    %ebx,%esi
  101006:	89 da                	mov    %ebx,%edx
  101008:	c1 ee 10             	shr    $0x10,%esi
  10100b:	89 f1                	mov    %esi,%ecx
  10100d:	8d 76 00             	lea    0x0(%esi),%esi
  101010:	66 89 14 c5 00 d0 9d 	mov    %dx,0x9dd000(,%eax,8)
  101017:	00 
  101018:	c7 04 c5 02 d0 9d 00 	movl   $0x8e000008,0x9dd002(,%eax,8)
  10101f:	08 00 00 8e 
  101023:	66 89 0c c5 06 d0 9d 	mov    %cx,0x9dd006(,%eax,8)
  10102a:	00 
    for (i = 0; i < sizeof(idt) / sizeof(idt[0]); i++)
  10102b:	83 c0 01             	add    $0x1,%eax
  10102e:	3d 00 01 00 00       	cmp    $0x100,%eax
  101033:	75 db                	jne    101010 <intr_init+0xa0>
    SETGATE(idt[T_DIVIDE],                  0, CPU_GDT_KCODE, &Xdivide,         0);
  101035:	b8 70 1c 10 00       	mov    $0x101c70,%eax
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  10103a:	ba 08 00 00 00       	mov    $0x8,%edx
    SETGATE(idt[T_DIVIDE],                  0, CPU_GDT_KCODE, &Xdivide,         0);
  10103f:	c7 05 02 d0 9d 00 08 	movl   $0x8e000008,0x9dd002
  101046:	00 00 8e 
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  101049:	b9 00 8e ff ff       	mov    $0xffff8e00,%ecx
    SETGATE(idt[T_DIVIDE],                  0, CPU_GDT_KCODE, &Xdivide,         0);
  10104e:	66 a3 00 d0 9d 00    	mov    %ax,0x9dd000
  101054:	c1 e8 10             	shr    $0x10,%eax
  101057:	66 a3 06 d0 9d 00    	mov    %ax,0x9dd006
    SETGATE(idt[T_DEBUG],                   0, CPU_GDT_KCODE, &Xdebug,          0);
  10105d:	b8 7a 1c 10 00       	mov    $0x101c7a,%eax
  101062:	66 a3 08 d0 9d 00    	mov    %ax,0x9dd008
  101068:	c1 e8 10             	shr    $0x10,%eax
  10106b:	66 a3 0e d0 9d 00    	mov    %ax,0x9dd00e
    SETGATE(idt[T_NMI],                     0, CPU_GDT_KCODE, &Xnmi,            0);
  101071:	b8 84 1c 10 00       	mov    $0x101c84,%eax
  101076:	66 a3 10 d0 9d 00    	mov    %ax,0x9dd010
  10107c:	c1 e8 10             	shr    $0x10,%eax
  10107f:	66 a3 16 d0 9d 00    	mov    %ax,0x9dd016
    SETGATE(idt[T_BRKPT],                   0, CPU_GDT_KCODE, &Xbrkpt,          3);
  101085:	b8 8e 1c 10 00       	mov    $0x101c8e,%eax
  10108a:	66 a3 18 d0 9d 00    	mov    %ax,0x9dd018
  101090:	c1 e8 10             	shr    $0x10,%eax
  101093:	66 a3 1e d0 9d 00    	mov    %ax,0x9dd01e
    SETGATE(idt[T_OFLOW],                   0, CPU_GDT_KCODE, &Xoflow,          3);
  101099:	b8 98 1c 10 00       	mov    $0x101c98,%eax
  10109e:	66 a3 20 d0 9d 00    	mov    %ax,0x9dd020
  1010a4:	c1 e8 10             	shr    $0x10,%eax
  1010a7:	66 a3 26 d0 9d 00    	mov    %ax,0x9dd026
    SETGATE(idt[T_BOUND],                   0, CPU_GDT_KCODE, &Xbound,          0);
  1010ad:	b8 a2 1c 10 00       	mov    $0x101ca2,%eax
  1010b2:	66 a3 28 d0 9d 00    	mov    %ax,0x9dd028
  1010b8:	c1 e8 10             	shr    $0x10,%eax
  1010bb:	66 a3 2e d0 9d 00    	mov    %ax,0x9dd02e
    SETGATE(idt[T_ILLOP],                   0, CPU_GDT_KCODE, &Xillop,          0);
  1010c1:	b8 ac 1c 10 00       	mov    $0x101cac,%eax
  1010c6:	66 a3 30 d0 9d 00    	mov    %ax,0x9dd030
  1010cc:	c1 e8 10             	shr    $0x10,%eax
  1010cf:	66 a3 36 d0 9d 00    	mov    %ax,0x9dd036
    SETGATE(idt[T_DEVICE],                  0, CPU_GDT_KCODE, &Xdevice,         0);
  1010d5:	b8 b6 1c 10 00       	mov    $0x101cb6,%eax
  1010da:	66 a3 38 d0 9d 00    	mov    %ax,0x9dd038
  1010e0:	c1 e8 10             	shr    $0x10,%eax
  1010e3:	66 a3 3e d0 9d 00    	mov    %ax,0x9dd03e
    SETGATE(idt[T_DBLFLT],                  0, CPU_GDT_KCODE, &Xdblflt,         0);
  1010e9:	b8 c0 1c 10 00       	mov    $0x101cc0,%eax
  1010ee:	66 a3 40 d0 9d 00    	mov    %ax,0x9dd040
  1010f4:	c1 e8 10             	shr    $0x10,%eax
  1010f7:	66 a3 46 d0 9d 00    	mov    %ax,0x9dd046
    SETGATE(idt[T_TSS],                     0, CPU_GDT_KCODE, &Xtss,            0);
  1010fd:	b8 d2 1c 10 00       	mov    $0x101cd2,%eax
  101102:	66 a3 50 d0 9d 00    	mov    %ax,0x9dd050
  101108:	c1 e8 10             	shr    $0x10,%eax
  10110b:	66 a3 56 d0 9d 00    	mov    %ax,0x9dd056
    SETGATE(idt[T_SEGNP],                   0, CPU_GDT_KCODE, &Xsegnp,          0);
  101111:	b8 da 1c 10 00       	mov    $0x101cda,%eax
  101116:	66 a3 58 d0 9d 00    	mov    %ax,0x9dd058
  10111c:	c1 e8 10             	shr    $0x10,%eax
    SETGATE(idt[T_DEBUG],                   0, CPU_GDT_KCODE, &Xdebug,          0);
  10111f:	c7 05 0a d0 9d 00 08 	movl   $0x8e000008,0x9dd00a
  101126:	00 00 8e 
    SETGATE(idt[T_NMI],                     0, CPU_GDT_KCODE, &Xnmi,            0);
  101129:	c7 05 12 d0 9d 00 08 	movl   $0x8e000008,0x9dd012
  101130:	00 00 8e 
    SETGATE(idt[T_BRKPT],                   0, CPU_GDT_KCODE, &Xbrkpt,          3);
  101133:	c7 05 1a d0 9d 00 08 	movl   $0xee000008,0x9dd01a
  10113a:	00 00 ee 
    SETGATE(idt[T_OFLOW],                   0, CPU_GDT_KCODE, &Xoflow,          3);
  10113d:	c7 05 22 d0 9d 00 08 	movl   $0xee000008,0x9dd022
  101144:	00 00 ee 
    SETGATE(idt[T_BOUND],                   0, CPU_GDT_KCODE, &Xbound,          0);
  101147:	c7 05 2a d0 9d 00 08 	movl   $0x8e000008,0x9dd02a
  10114e:	00 00 8e 
    SETGATE(idt[T_ILLOP],                   0, CPU_GDT_KCODE, &Xillop,          0);
  101151:	c7 05 32 d0 9d 00 08 	movl   $0x8e000008,0x9dd032
  101158:	00 00 8e 
    SETGATE(idt[T_DEVICE],                  0, CPU_GDT_KCODE, &Xdevice,         0);
  10115b:	c7 05 3a d0 9d 00 08 	movl   $0x8e000008,0x9dd03a
  101162:	00 00 8e 
    SETGATE(idt[T_DBLFLT],                  0, CPU_GDT_KCODE, &Xdblflt,         0);
  101165:	c7 05 42 d0 9d 00 08 	movl   $0x8e000008,0x9dd042
  10116c:	00 00 8e 
    SETGATE(idt[T_TSS],                     0, CPU_GDT_KCODE, &Xtss,            0);
  10116f:	c7 05 52 d0 9d 00 08 	movl   $0x8e000008,0x9dd052
  101176:	00 00 8e 
    SETGATE(idt[T_SEGNP],                   0, CPU_GDT_KCODE, &Xsegnp,          0);
  101179:	c7 05 5a d0 9d 00 08 	movl   $0x8e000008,0x9dd05a
  101180:	00 00 8e 
  101183:	66 a3 5e d0 9d 00    	mov    %ax,0x9dd05e
    SETGATE(idt[T_STACK],                   0, CPU_GDT_KCODE, &Xstack,          0);
  101189:	b8 e2 1c 10 00       	mov    $0x101ce2,%eax
  10118e:	66 a3 60 d0 9d 00    	mov    %ax,0x9dd060
  101194:	c1 e8 10             	shr    $0x10,%eax
  101197:	66 a3 66 d0 9d 00    	mov    %ax,0x9dd066
    SETGATE(idt[T_GPFLT],                   0, CPU_GDT_KCODE, &Xgpflt,          0);
  10119d:	b8 ea 1c 10 00       	mov    $0x101cea,%eax
  1011a2:	66 a3 68 d0 9d 00    	mov    %ax,0x9dd068
  1011a8:	c1 e8 10             	shr    $0x10,%eax
  1011ab:	66 a3 6e d0 9d 00    	mov    %ax,0x9dd06e
    SETGATE(idt[T_PGFLT],                   0, CPU_GDT_KCODE, &Xpgflt,          0);
  1011b1:	b8 f2 1c 10 00       	mov    $0x101cf2,%eax
  1011b6:	66 a3 70 d0 9d 00    	mov    %ax,0x9dd070
  1011bc:	c1 e8 10             	shr    $0x10,%eax
  1011bf:	66 a3 76 d0 9d 00    	mov    %ax,0x9dd076
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  1011c5:	b8 04 1d 10 00       	mov    $0x101d04,%eax
  1011ca:	66 a3 80 d0 9d 00    	mov    %ax,0x9dd080
  1011d0:	c1 e8 10             	shr    $0x10,%eax
  1011d3:	66 a3 86 d0 9d 00    	mov    %ax,0x9dd086
    SETGATE(idt[T_ALIGN],                   0, CPU_GDT_KCODE, &Xalign,          0);
  1011d9:	b8 0e 1d 10 00       	mov    $0x101d0e,%eax
  1011de:	66 a3 88 d0 9d 00    	mov    %ax,0x9dd088
  1011e4:	c1 e8 10             	shr    $0x10,%eax
  1011e7:	66 a3 8e d0 9d 00    	mov    %ax,0x9dd08e
    SETGATE(idt[T_MCHK],                    0, CPU_GDT_KCODE, &Xmchk,           0);
  1011ed:	b8 12 1d 10 00       	mov    $0x101d12,%eax
  1011f2:	66 a3 90 d0 9d 00    	mov    %ax,0x9dd090
  1011f8:	c1 e8 10             	shr    $0x10,%eax
  1011fb:	66 a3 96 d0 9d 00    	mov    %ax,0x9dd096
    SETGATE(idt[T_IRQ0 + IRQ_TIMER],        0, CPU_GDT_KCODE, &Xirq_timer,      0);
  101201:	b8 18 1d 10 00       	mov    $0x101d18,%eax
  101206:	66 a3 00 d1 9d 00    	mov    %ax,0x9dd100
  10120c:	c1 e8 10             	shr    $0x10,%eax
  10120f:	66 a3 06 d1 9d 00    	mov    %ax,0x9dd106
    SETGATE(idt[T_IRQ0 + IRQ_KBD],          0, CPU_GDT_KCODE, &Xirq_kbd,        0);
  101215:	b8 1e 1d 10 00       	mov    $0x101d1e,%eax
  10121a:	66 a3 08 d1 9d 00    	mov    %ax,0x9dd108
  101220:	c1 e8 10             	shr    $0x10,%eax
  101223:	66 a3 0e d1 9d 00    	mov    %ax,0x9dd10e
    SETGATE(idt[T_IRQ0 + IRQ_SLAVE],        0, CPU_GDT_KCODE, &Xirq_slave,      0);
  101229:	b8 24 1d 10 00       	mov    $0x101d24,%eax
  10122e:	66 a3 10 d1 9d 00    	mov    %ax,0x9dd110
  101234:	c1 e8 10             	shr    $0x10,%eax
  101237:	66 a3 16 d1 9d 00    	mov    %ax,0x9dd116
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL24],     0, CPU_GDT_KCODE, &Xirq_serial2,    0);
  10123d:	b8 2a 1d 10 00       	mov    $0x101d2a,%eax
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  101242:	66 89 15 82 d0 9d 00 	mov    %dx,0x9dd082
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  101249:	ba 30 1d 10 00       	mov    $0x101d30,%edx
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL24],     0, CPU_GDT_KCODE, &Xirq_serial2,    0);
  10124e:	66 a3 18 d1 9d 00    	mov    %ax,0x9dd118
  101254:	c1 e8 10             	shr    $0x10,%eax
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  101257:	66 89 15 20 d1 9d 00 	mov    %dx,0x9dd120
  10125e:	c1 ea 10             	shr    $0x10,%edx
    SETGATE(idt[T_STACK],                   0, CPU_GDT_KCODE, &Xstack,          0);
  101261:	c7 05 62 d0 9d 00 08 	movl   $0x8e000008,0x9dd062
  101268:	00 00 8e 
    SETGATE(idt[T_GPFLT],                   0, CPU_GDT_KCODE, &Xgpflt,          0);
  10126b:	c7 05 6a d0 9d 00 08 	movl   $0x8e000008,0x9dd06a
  101272:	00 00 8e 
    SETGATE(idt[T_PGFLT],                   0, CPU_GDT_KCODE, &Xpgflt,          0);
  101275:	c7 05 72 d0 9d 00 08 	movl   $0x8e000008,0x9dd072
  10127c:	00 00 8e 
    SETGATE(idt[T_FPERR],                   0, CPU_GDT_KCODE, &Xfperr,          0);
  10127f:	66 89 0d 84 d0 9d 00 	mov    %cx,0x9dd084
    SETGATE(idt[T_ALIGN],                   0, CPU_GDT_KCODE, &Xalign,          0);
  101286:	c7 05 8a d0 9d 00 08 	movl   $0x8e000008,0x9dd08a
  10128d:	00 00 8e 
    SETGATE(idt[T_MCHK],                    0, CPU_GDT_KCODE, &Xmchk,           0);
  101290:	c7 05 92 d0 9d 00 08 	movl   $0x8e000008,0x9dd092
  101297:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_TIMER],        0, CPU_GDT_KCODE, &Xirq_timer,      0);
  10129a:	c7 05 02 d1 9d 00 08 	movl   $0x8e000008,0x9dd102
  1012a1:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_KBD],          0, CPU_GDT_KCODE, &Xirq_kbd,        0);
  1012a4:	c7 05 0a d1 9d 00 08 	movl   $0x8e000008,0x9dd10a
  1012ab:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_SLAVE],        0, CPU_GDT_KCODE, &Xirq_slave,      0);
  1012ae:	c7 05 12 d1 9d 00 08 	movl   $0x8e000008,0x9dd112
  1012b5:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL24],     0, CPU_GDT_KCODE, &Xirq_serial2,    0);
  1012b8:	c7 05 1a d1 9d 00 08 	movl   $0x8e000008,0x9dd11a
  1012bf:	00 00 8e 
  1012c2:	66 a3 1e d1 9d 00    	mov    %ax,0x9dd11e
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  1012c8:	a1 22 d1 9d 00       	mov    0x9dd122,%eax
  1012cd:	66 89 15 26 d1 9d 00 	mov    %dx,0x9dd126
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  1012d4:	ba 5a 1d 10 00       	mov    $0x101d5a,%edx
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  1012d9:	25 00 00 e0 ff       	and    $0xffe00000,%eax
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  1012de:	66 89 15 58 d1 9d 00 	mov    %dx,0x9dd158
    SETGATE(idt[T_IRQ0 + IRQ_LPT2],         0, CPU_GDT_KCODE, &Xirq_lpt,        0);
  1012e5:	c7 05 2a d1 9d 00 08 	movl   $0x8e000008,0x9dd12a
  1012ec:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_SERIAL13],     0, CPU_GDT_KCODE, &Xirq_serial1,    0);
  1012ef:	83 c8 08             	or     $0x8,%eax
  1012f2:	a3 22 d1 9d 00       	mov    %eax,0x9dd122
  1012f7:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
  1012fc:	66 a3 24 d1 9d 00    	mov    %ax,0x9dd124
    SETGATE(idt[T_IRQ0 + IRQ_LPT2],         0, CPU_GDT_KCODE, &Xirq_lpt,        0);
  101302:	b8 36 1d 10 00       	mov    $0x101d36,%eax
  101307:	66 a3 28 d1 9d 00    	mov    %ax,0x9dd128
  10130d:	c1 e8 10             	shr    $0x10,%eax
  101310:	66 a3 2e d1 9d 00    	mov    %ax,0x9dd12e
    SETGATE(idt[T_IRQ0 + IRQ_FLOPPY],       0, CPU_GDT_KCODE, &Xirq_floppy,     0);
  101316:	b8 3c 1d 10 00       	mov    $0x101d3c,%eax
  10131b:	66 a3 30 d1 9d 00    	mov    %ax,0x9dd130
  101321:	c1 e8 10             	shr    $0x10,%eax
  101324:	66 a3 36 d1 9d 00    	mov    %ax,0x9dd136
    SETGATE(idt[T_IRQ0 + IRQ_SPURIOUS],     0, CPU_GDT_KCODE, &Xirq_spurious,   0);
  10132a:	b8 42 1d 10 00       	mov    $0x101d42,%eax
  10132f:	66 a3 38 d1 9d 00    	mov    %ax,0x9dd138
  101335:	c1 e8 10             	shr    $0x10,%eax
  101338:	66 a3 3e d1 9d 00    	mov    %ax,0x9dd13e
    SETGATE(idt[T_IRQ0 + IRQ_RTC],          0, CPU_GDT_KCODE, &Xirq_rtc,        0);
  10133e:	b8 48 1d 10 00       	mov    $0x101d48,%eax
  101343:	66 a3 40 d1 9d 00    	mov    %ax,0x9dd140
  101349:	c1 e8 10             	shr    $0x10,%eax
  10134c:	66 a3 46 d1 9d 00    	mov    %ax,0x9dd146
    SETGATE(idt[T_IRQ0 + 9],                0, CPU_GDT_KCODE, &Xirq9,           0);
  101352:	b8 4e 1d 10 00       	mov    $0x101d4e,%eax
  101357:	66 a3 48 d1 9d 00    	mov    %ax,0x9dd148
  10135d:	c1 e8 10             	shr    $0x10,%eax
  101360:	66 a3 4e d1 9d 00    	mov    %ax,0x9dd14e
    SETGATE(idt[T_IRQ0 + 10],               0, CPU_GDT_KCODE, &Xirq10,          0);
  101366:	b8 54 1d 10 00       	mov    $0x101d54,%eax
  10136b:	66 a3 50 d1 9d 00    	mov    %ax,0x9dd150
  101371:	c1 e8 10             	shr    $0x10,%eax
  101374:	66 a3 56 d1 9d 00    	mov    %ax,0x9dd156
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  10137a:	a1 5a d1 9d 00       	mov    0x9dd15a,%eax
    SETGATE(idt[T_IRQ0 + IRQ_FLOPPY],       0, CPU_GDT_KCODE, &Xirq_floppy,     0);
  10137f:	c7 05 32 d1 9d 00 08 	movl   $0x8e000008,0x9dd132
  101386:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_SPURIOUS],     0, CPU_GDT_KCODE, &Xirq_spurious,   0);
  101389:	c7 05 3a d1 9d 00 08 	movl   $0x8e000008,0x9dd13a
  101390:	00 00 8e 
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  101393:	25 00 00 00 ff       	and    $0xff000000,%eax
    SETGATE(idt[T_IRQ0 + IRQ_RTC],          0, CPU_GDT_KCODE, &Xirq_rtc,        0);
  101398:	c7 05 42 d1 9d 00 08 	movl   $0x8e000008,0x9dd142
  10139f:	00 00 8e 
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  1013a2:	83 c8 08             	or     $0x8,%eax
  1013a5:	c1 ea 10             	shr    $0x10,%edx
  1013a8:	a3 5a d1 9d 00       	mov    %eax,0x9dd15a
    SETGATE(idt[T_IRQ0 + IRQ_MOUSE],        0, CPU_GDT_KCODE, &Xirq_mouse,      0);
  1013ad:	b8 60 1d 10 00       	mov    $0x101d60,%eax
  1013b2:	66 a3 60 d1 9d 00    	mov    %ax,0x9dd160
  1013b8:	c1 e8 10             	shr    $0x10,%eax
  1013bb:	66 a3 66 d1 9d 00    	mov    %ax,0x9dd166
    SETGATE(idt[T_IRQ0 + IRQ_COPROCESSOR],  0, CPU_GDT_KCODE, &Xirq_coproc,     0);
  1013c1:	b8 66 1d 10 00       	mov    $0x101d66,%eax
  1013c6:	66 a3 68 d1 9d 00    	mov    %ax,0x9dd168
  1013cc:	c1 e8 10             	shr    $0x10,%eax
    SETGATE(idt[T_IRQ0 + 9],                0, CPU_GDT_KCODE, &Xirq9,           0);
  1013cf:	c7 05 4a d1 9d 00 08 	movl   $0x8e000008,0x9dd14a
  1013d6:	00 00 8e 
    SETGATE(idt[T_IRQ0 + 10],               0, CPU_GDT_KCODE, &Xirq10,          0);
  1013d9:	c7 05 52 d1 9d 00 08 	movl   $0x8e000008,0x9dd152
  1013e0:	00 00 8e 
    SETGATE(idt[T_IRQ0 + 11],               0, CPU_GDT_KCODE, &Xirq11,          0);
  1013e3:	c6 05 5d d1 9d 00 8e 	movb   $0x8e,0x9dd15d
  1013ea:	66 89 15 5e d1 9d 00 	mov    %dx,0x9dd15e
    SETGATE(idt[T_IRQ0 + IRQ_MOUSE],        0, CPU_GDT_KCODE, &Xirq_mouse,      0);
  1013f1:	c7 05 62 d1 9d 00 08 	movl   $0x8e000008,0x9dd162
  1013f8:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_COPROCESSOR],  0, CPU_GDT_KCODE, &Xirq_coproc,     0);
  1013fb:	c7 05 6a d1 9d 00 08 	movl   $0x8e000008,0x9dd16a
  101402:	00 00 8e 
  101405:	66 a3 6e d1 9d 00    	mov    %ax,0x9dd16e
    SETGATE(idt[T_IRQ0 + IRQ_IDE1],         0, CPU_GDT_KCODE, &Xirq_ide1,       0);
  10140b:	b8 6c 1d 10 00       	mov    $0x101d6c,%eax
  101410:	66 a3 70 d1 9d 00    	mov    %ax,0x9dd170
  101416:	c1 e8 10             	shr    $0x10,%eax
  101419:	66 a3 76 d1 9d 00    	mov    %ax,0x9dd176
    SETGATE(idt[T_IRQ0 + IRQ_IDE2],         0, CPU_GDT_KCODE, &Xirq_ide2,       0);
  10141f:	b8 72 1d 10 00       	mov    $0x101d72,%eax
  101424:	66 a3 78 d1 9d 00    	mov    %ax,0x9dd178
  10142a:	c1 e8 10             	shr    $0x10,%eax
  10142d:	66 a3 7e d1 9d 00    	mov    %ax,0x9dd17e
    SETGATE(idt[T_SYSCALL], 0, CPU_GDT_KCODE, &Xsyscall, 3);
  101433:	b8 78 1d 10 00       	mov    $0x101d78,%eax
  101438:	66 a3 80 d1 9d 00    	mov    %ax,0x9dd180
  10143e:	c1 e8 10             	shr    $0x10,%eax
  101441:	66 a3 86 d1 9d 00    	mov    %ax,0x9dd186
    if (using_apic)
  101447:	0f b6 05 60 ce 14 00 	movzbl 0x14ce60,%eax
    SETGATE(idt[T_IRQ0 + IRQ_IDE1],         0, CPU_GDT_KCODE, &Xirq_ide1,       0);
  10144e:	c7 05 72 d1 9d 00 08 	movl   $0x8e000008,0x9dd172
  101455:	00 00 8e 
    SETGATE(idt[T_IRQ0 + IRQ_IDE2],         0, CPU_GDT_KCODE, &Xirq_ide2,       0);
  101458:	c7 05 7a d1 9d 00 08 	movl   $0x8e000008,0x9dd17a
  10145f:	00 00 8e 
    SETGATE(idt[T_SYSCALL], 0, CPU_GDT_KCODE, &Xsyscall, 3);
  101462:	c7 05 82 d1 9d 00 08 	movl   $0xee000008,0x9dd182
  101469:	00 00 ee 
    SETGATE(idt[T_DEFAULT], 0, CPU_GDT_KCODE, &Xdefault, 0);
  10146c:	66 89 1d f0 d7 9d 00 	mov    %bx,0x9dd7f0
  101473:	c7 05 f2 d7 9d 00 08 	movl   $0x8e000008,0x9dd7f2
  10147a:	00 00 8e 
  10147d:	66 89 35 f6 d7 9d 00 	mov    %si,0x9dd7f6
    if (using_apic)
  101484:	84 c0                	test   %al,%al
  101486:	0f 84 4a fb ff ff    	je     100fd6 <intr_init+0x66>
  10148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        lapic_init();
  101490:	e8 1b 0c 00 00       	call   1020b0 <lapic_init>
  101495:	e9 3c fb ff ff       	jmp    100fd6 <intr_init+0x66>
  10149a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001014a0 <intr_enable>:

void intr_enable(uint8_t irq, int cpunum)
{
  1014a0:	56                   	push   %esi
  1014a1:	53                   	push   %ebx
  1014a2:	83 ec 04             	sub    $0x4,%esp
  1014a5:	8b 74 24 14          	mov    0x14(%esp),%esi
  1014a9:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    KERN_ASSERT(cpunum == 0xff || (0 <= cpunum && cpunum < pcpu_ncpu()));
  1014ad:	81 fe ff 00 00 00    	cmp    $0xff,%esi
  1014b3:	74 13                	je     1014c8 <intr_enable+0x28>
  1014b5:	85 f6                	test   %esi,%esi
  1014b7:	78 67                	js     101520 <intr_enable+0x80>
  1014b9:	e8 d2 1c 00 00       	call   103190 <pcpu_ncpu>
  1014be:	39 f0                	cmp    %esi,%eax
  1014c0:	76 5e                	jbe    101520 <intr_enable+0x80>
  1014c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    if (irq >= 24)
  1014c8:	80 fb 17             	cmp    $0x17,%bl
  1014cb:	77 4b                	ja     101518 <intr_enable+0x78>
        return;

    if (using_apic == TRUE) {
  1014cd:	0f b6 05 60 ce 14 00 	movzbl 0x14ce60,%eax
  1014d4:	3c 01                	cmp    $0x1,%al
  1014d6:	74 18                	je     1014f0 <intr_enable+0x50>
        ioapic_enable(irq, (cpunum == 0xff) ?  0xff : pcpu_cpu_lapicid(cpunum), 0, 0);
    } else {
        KERN_ASSERT(irq < 16);
  1014d8:	80 fb 0f             	cmp    $0xf,%bl
  1014db:	77 63                	ja     101540 <intr_enable+0xa0>
        pic_enable(irq);
  1014dd:	0f b6 db             	movzbl %bl,%ebx
  1014e0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
    }
}
  1014e4:	83 c4 04             	add    $0x4,%esp
  1014e7:	5b                   	pop    %ebx
  1014e8:	5e                   	pop    %esi
        pic_enable(irq);
  1014e9:	e9 72 02 00 00       	jmp    101760 <pic_enable>
  1014ee:	66 90                	xchg   %ax,%ax
        ioapic_enable(irq, (cpunum == 0xff) ?  0xff : pcpu_cpu_lapicid(cpunum), 0, 0);
  1014f0:	81 fe ff 00 00 00    	cmp    $0xff,%esi
  1014f6:	74 0f                	je     101507 <intr_enable+0x67>
  1014f8:	83 ec 0c             	sub    $0xc,%esp
  1014fb:	56                   	push   %esi
  1014fc:	e8 ef 1c 00 00       	call   1031f0 <pcpu_cpu_lapicid>
  101501:	83 c4 10             	add    $0x10,%esp
  101504:	0f b6 f0             	movzbl %al,%esi
  101507:	0f b6 db             	movzbl %bl,%ebx
  10150a:	6a 00                	push   $0x0
  10150c:	6a 00                	push   $0x0
  10150e:	56                   	push   %esi
  10150f:	53                   	push   %ebx
  101510:	e8 4b 11 00 00       	call   102660 <ioapic_enable>
  101515:	83 c4 10             	add    $0x10,%esp
}
  101518:	83 c4 04             	add    $0x4,%esp
  10151b:	5b                   	pop    %ebx
  10151c:	5e                   	pop    %esi
  10151d:	c3                   	ret    
  10151e:	66 90                	xchg   %ax,%ax
    KERN_ASSERT(cpunum == 0xff || (0 <= cpunum && cpunum < pcpu_ncpu()));
  101520:	68 54 94 10 00       	push   $0x109454
  101525:	68 df 92 10 00       	push   $0x1092df
  10152a:	6a 7a                	push   $0x7a
  10152c:	68 38 94 10 00       	push   $0x109438
  101531:	e8 1a 23 00 00       	call   103850 <debug_panic>
  101536:	83 c4 10             	add    $0x10,%esp
  101539:	eb 8d                	jmp    1014c8 <intr_enable+0x28>
  10153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10153f:	90                   	nop
        KERN_ASSERT(irq < 16);
  101540:	68 48 94 10 00       	push   $0x109448
  101545:	68 df 92 10 00       	push   $0x1092df
  10154a:	68 82 00 00 00       	push   $0x82
  10154f:	68 38 94 10 00       	push   $0x109438
  101554:	e8 f7 22 00 00       	call   103850 <debug_panic>
  101559:	83 c4 10             	add    $0x10,%esp
  10155c:	e9 7c ff ff ff       	jmp    1014dd <intr_enable+0x3d>
  101561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10156f:	90                   	nop

00101570 <intr_enable_lapicid>:

void intr_enable_lapicid(uint8_t irq, int lapic_id)
{
  101570:	53                   	push   %ebx
  101571:	83 ec 08             	sub    $0x8,%esp
  101574:	8b 44 24 10          	mov    0x10(%esp),%eax
  101578:	8b 54 24 14          	mov    0x14(%esp),%edx
    if (irq > 24)
  10157c:	3c 18                	cmp    $0x18,%al
  10157e:	77 31                	ja     1015b1 <intr_enable_lapicid+0x41>
        return;

    if (using_apic == TRUE) {
  101580:	0f b6 0d 60 ce 14 00 	movzbl 0x14ce60,%ecx
  101587:	0f b6 d8             	movzbl %al,%ebx
  10158a:	80 f9 01             	cmp    $0x1,%cl
  10158d:	74 11                	je     1015a0 <intr_enable_lapicid+0x30>
        ioapic_enable(irq, (lapic_id == 0xff) ?  0xff : lapic_id, 0, 0);
    } else {
        KERN_ASSERT(irq < 16);
  10158f:	3c 0f                	cmp    $0xf,%al
  101591:	77 2d                	ja     1015c0 <intr_enable_lapicid+0x50>
        pic_enable(irq);
  101593:	89 5c 24 10          	mov    %ebx,0x10(%esp)
    }
}
  101597:	83 c4 08             	add    $0x8,%esp
  10159a:	5b                   	pop    %ebx
        pic_enable(irq);
  10159b:	e9 c0 01 00 00       	jmp    101760 <pic_enable>
        ioapic_enable(irq, (lapic_id == 0xff) ?  0xff : lapic_id, 0, 0);
  1015a0:	0f b6 d2             	movzbl %dl,%edx
  1015a3:	6a 00                	push   $0x0
  1015a5:	6a 00                	push   $0x0
  1015a7:	52                   	push   %edx
  1015a8:	53                   	push   %ebx
  1015a9:	e8 b2 10 00 00       	call   102660 <ioapic_enable>
  1015ae:	83 c4 10             	add    $0x10,%esp
}
  1015b1:	83 c4 08             	add    $0x8,%esp
  1015b4:	5b                   	pop    %ebx
  1015b5:	c3                   	ret    
  1015b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1015bd:	8d 76 00             	lea    0x0(%esi),%esi
        KERN_ASSERT(irq < 16);
  1015c0:	68 48 94 10 00       	push   $0x109448
  1015c5:	68 df 92 10 00       	push   $0x1092df
  1015ca:	68 8f 00 00 00       	push   $0x8f
  1015cf:	68 38 94 10 00       	push   $0x109438
  1015d4:	e8 77 22 00 00       	call   103850 <debug_panic>
  1015d9:	83 c4 10             	add    $0x10,%esp
        pic_enable(irq);
  1015dc:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
  1015e0:	83 c4 08             	add    $0x8,%esp
  1015e3:	5b                   	pop    %ebx
        pic_enable(irq);
  1015e4:	e9 77 01 00 00       	jmp    101760 <pic_enable>
  1015e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001015f0 <intr_eoi>:

void intr_eoi(void)
{
    if (using_apic == TRUE)
  1015f0:	0f b6 05 60 ce 14 00 	movzbl 0x14ce60,%eax
  1015f7:	3c 01                	cmp    $0x1,%al
  1015f9:	74 05                	je     101600 <intr_eoi+0x10>
        lapic_eoi();
    else
        pic_eoi();
  1015fb:	e9 80 01 00 00       	jmp    101780 <pic_eoi>
        lapic_eoi();
  101600:	e9 7b 0d 00 00       	jmp    102380 <lapic_eoi>
  101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101610 <intr_local_enable>:
}

void intr_local_enable(void)
{
    sti();
  101610:	e9 6b 2d 00 00       	jmp    104380 <sti>
  101615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101620 <intr_local_disable>:
}

void intr_local_disable(void)
{
    cli();
  101620:	e9 4b 2d 00 00       	jmp    104370 <cli>
  101625:	66 90                	xchg   %ax,%ax
  101627:	66 90                	xchg   %ax,%ax
  101629:	66 90                	xchg   %ax,%ax
  10162b:	66 90                	xchg   %ax,%ax
  10162d:	66 90                	xchg   %ax,%ax
  10162f:	90                   	nop

00101630 <pic_init>:
static bool pic_inited = FALSE;

/* Initialize the 8259A interrupt controllers. */
void pic_init(void)
{
    if (pic_inited == TRUE)  // only do once on bootstrap CPU
  101630:	80 3d 61 ce 14 00 01 	cmpb   $0x1,0x14ce61
  101637:	0f 84 e3 00 00 00    	je     101720 <pic_init+0xf0>
{
  10163d:	83 ec 14             	sub    $0x14,%esp
        return;
    pic_inited = TRUE;
  101640:	c6 05 61 ce 14 00 01 	movb   $0x1,0x14ce61

    /* mask all interrupts */
    outb(IO_PIC1 + 1, 0xff);
  101647:	68 ff 00 00 00       	push   $0xff
  10164c:	6a 21                	push   $0x21
  10164e:	e8 3d 2f 00 00       	call   104590 <outb>
    outb(IO_PIC2 + 1, 0xff);
  101653:	58                   	pop    %eax
  101654:	5a                   	pop    %edx
  101655:	68 ff 00 00 00       	push   $0xff
  10165a:	68 a1 00 00 00       	push   $0xa1
  10165f:	e8 2c 2f 00 00       	call   104590 <outb>

    // ICW1:  0001g0hi
    //    g:  0 = edge triggering, 1 = level triggering
    //    h:  0 = cascaded PICs, 1 = master only
    //    i:  0 = no ICW4, 1 = ICW4 required
    outb(IO_PIC1, 0x11);
  101664:	59                   	pop    %ecx
  101665:	58                   	pop    %eax
  101666:	6a 11                	push   $0x11
  101668:	6a 20                	push   $0x20
  10166a:	e8 21 2f 00 00       	call   104590 <outb>

    // ICW2:  Vector offset
    outb(IO_PIC1 + 1, T_IRQ0);
  10166f:	58                   	pop    %eax
  101670:	5a                   	pop    %edx
  101671:	6a 20                	push   $0x20
  101673:	6a 21                	push   $0x21
  101675:	e8 16 2f 00 00       	call   104590 <outb>

    // ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
    //        3-bit No of IR line at which slave connects to master (slave PIC).
    outb(IO_PIC1 + 1, 1 << IRQ_SLAVE);
  10167a:	59                   	pop    %ecx
  10167b:	58                   	pop    %eax
  10167c:	6a 04                	push   $0x4
  10167e:	6a 21                	push   $0x21
  101680:	e8 0b 2f 00 00       	call   104590 <outb>
    //    m:  0 = slave PIC, 1 = master PIC
    //        (ignored when b is 0, as the master/slave role
    //        can be hardwired).
    //    a:  1 = Automatic EOI mode
    //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
    outb(IO_PIC1 + 1, 0x1);
  101685:	58                   	pop    %eax
  101686:	5a                   	pop    %edx
  101687:	6a 01                	push   $0x1
  101689:	6a 21                	push   $0x21
  10168b:	e8 00 2f 00 00       	call   104590 <outb>

    // Set up slave (8259A-2)
    outb(IO_PIC2, 0x11);            // ICW1
  101690:	59                   	pop    %ecx
  101691:	58                   	pop    %eax
  101692:	6a 11                	push   $0x11
  101694:	68 a0 00 00 00       	push   $0xa0
  101699:	e8 f2 2e 00 00       	call   104590 <outb>
    outb(IO_PIC2 + 1, T_IRQ0 + 8);  // ICW2
  10169e:	58                   	pop    %eax
  10169f:	5a                   	pop    %edx
  1016a0:	6a 28                	push   $0x28
  1016a2:	68 a1 00 00 00       	push   $0xa1
  1016a7:	e8 e4 2e 00 00       	call   104590 <outb>
    outb(IO_PIC2 + 1, IRQ_SLAVE);   // ICW3
  1016ac:	59                   	pop    %ecx
  1016ad:	58                   	pop    %eax
  1016ae:	6a 02                	push   $0x2
  1016b0:	68 a1 00 00 00       	push   $0xa1
  1016b5:	e8 d6 2e 00 00       	call   104590 <outb>
    // NB Automatic EOI mode doesn't tend to work on the slave.
    // Linux source code says it's "to be investigated".
    outb(IO_PIC2 + 1, 0x01);        // ICW4
  1016ba:	58                   	pop    %eax
  1016bb:	5a                   	pop    %edx
  1016bc:	6a 01                	push   $0x1
  1016be:	68 a1 00 00 00       	push   $0xa1
  1016c3:	e8 c8 2e 00 00       	call   104590 <outb>

    // OCW3:  0ef01prs
    //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
    //    p:  0 = no polling, 1 = polling mode
    //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
    outb(IO_PIC1, 0x68);  /* clear specific mask */
  1016c8:	59                   	pop    %ecx
  1016c9:	58                   	pop    %eax
  1016ca:	6a 68                	push   $0x68
  1016cc:	6a 20                	push   $0x20
  1016ce:	e8 bd 2e 00 00       	call   104590 <outb>
    outb(IO_PIC1, 0x0a);  /* read IRR by default */
  1016d3:	58                   	pop    %eax
  1016d4:	5a                   	pop    %edx
  1016d5:	6a 0a                	push   $0xa
  1016d7:	6a 20                	push   $0x20
  1016d9:	e8 b2 2e 00 00       	call   104590 <outb>

    outb(IO_PIC2, 0x68);  /* OCW3 */
  1016de:	59                   	pop    %ecx
  1016df:	58                   	pop    %eax
  1016e0:	6a 68                	push   $0x68
  1016e2:	68 a0 00 00 00       	push   $0xa0
  1016e7:	e8 a4 2e 00 00       	call   104590 <outb>
    outb(IO_PIC2, 0x0a);  /* OCW3 */
  1016ec:	58                   	pop    %eax
  1016ed:	5a                   	pop    %edx
  1016ee:	6a 0a                	push   $0xa
  1016f0:	68 a0 00 00 00       	push   $0xa0
  1016f5:	e8 96 2e 00 00       	call   104590 <outb>

    // mask all interrupts
    outb(IO_PIC1 + 1, 0xFF);
  1016fa:	59                   	pop    %ecx
  1016fb:	58                   	pop    %eax
  1016fc:	68 ff 00 00 00       	push   $0xff
  101701:	6a 21                	push   $0x21
  101703:	e8 88 2e 00 00       	call   104590 <outb>
    outb(IO_PIC2 + 1, 0xFF);
  101708:	58                   	pop    %eax
  101709:	5a                   	pop    %edx
  10170a:	68 ff 00 00 00       	push   $0xff
  10170f:	68 a1 00 00 00       	push   $0xa1
  101714:	e8 77 2e 00 00       	call   104590 <outb>
}
  101719:	83 c4 1c             	add    $0x1c,%esp
  10171c:	c3                   	ret    
  10171d:	8d 76 00             	lea    0x0(%esi),%esi
  101720:	c3                   	ret    
  101721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10172f:	90                   	nop

00101730 <pic_setmask>:

void pic_setmask(uint16_t mask)
{
  101730:	53                   	push   %ebx
  101731:	83 ec 10             	sub    $0x10,%esp
  101734:	8b 5c 24 18          	mov    0x18(%esp),%ebx
    irqmask = mask;
    outb(IO_PIC1 + 1, (char) mask);
  101738:	0f b6 c3             	movzbl %bl,%eax
    irqmask = mask;
  10173b:	66 89 1d 06 13 11 00 	mov    %bx,0x111306
    outb(IO_PIC2 + 1, (char) (mask >> 8));
  101742:	0f b6 df             	movzbl %bh,%ebx
    outb(IO_PIC1 + 1, (char) mask);
  101745:	50                   	push   %eax
  101746:	6a 21                	push   $0x21
  101748:	e8 43 2e 00 00       	call   104590 <outb>
    outb(IO_PIC2 + 1, (char) (mask >> 8));
  10174d:	58                   	pop    %eax
  10174e:	5a                   	pop    %edx
  10174f:	53                   	push   %ebx
  101750:	68 a1 00 00 00       	push   $0xa1
  101755:	e8 36 2e 00 00       	call   104590 <outb>
}
  10175a:	83 c4 18             	add    $0x18,%esp
  10175d:	5b                   	pop    %ebx
  10175e:	c3                   	ret    
  10175f:	90                   	nop

00101760 <pic_enable>:

void pic_enable(int irq)
{
    pic_setmask(irqmask & ~(1 << irq));
  101760:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  101764:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  101769:	d3 c0                	rol    %cl,%eax
  10176b:	66 23 05 06 13 11 00 	and    0x111306,%ax
  101772:	0f b7 c0             	movzwl %ax,%eax
  101775:	89 44 24 04          	mov    %eax,0x4(%esp)
  101779:	eb b5                	jmp    101730 <pic_setmask>
  10177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10177f:	90                   	nop

00101780 <pic_eoi>:
}

void pic_eoi(void)
{
  101780:	83 ec 14             	sub    $0x14,%esp
    // OCW2: rse00xxx
    //   r: rotate
    //   s: specific
    //   e: end-of-interrupt
    // xxx: specific interrupt line
    outb(IO_PIC1, 0x20);
  101783:	6a 20                	push   $0x20
  101785:	6a 20                	push   $0x20
  101787:	e8 04 2e 00 00       	call   104590 <outb>
    outb(IO_PIC2, 0x20);
  10178c:	58                   	pop    %eax
  10178d:	5a                   	pop    %edx
  10178e:	6a 20                	push   $0x20
  101790:	68 a0 00 00 00       	push   $0xa0
  101795:	e8 f6 2d 00 00       	call   104590 <outb>
}
  10179a:	83 c4 1c             	add    $0x1c,%esp
  10179d:	c3                   	ret    
  10179e:	66 90                	xchg   %ax,%ax

001017a0 <pic_reset>:

void pic_reset(void)
{
  1017a0:	83 ec 14             	sub    $0x14,%esp
    // mask all interrupts
    outb(IO_PIC1 + 1, 0x00);
  1017a3:	6a 00                	push   $0x0
  1017a5:	6a 21                	push   $0x21
  1017a7:	e8 e4 2d 00 00       	call   104590 <outb>
    outb(IO_PIC2 + 1, 0x00);
  1017ac:	58                   	pop    %eax
  1017ad:	5a                   	pop    %edx
  1017ae:	6a 00                	push   $0x0
  1017b0:	68 a1 00 00 00       	push   $0xa1
  1017b5:	e8 d6 2d 00 00       	call   104590 <outb>

    // ICW1:  0001g0hi
    //    g:  0 = edge triggering, 1 = level triggering
    //    h:  0 = cascaded PICs, 1 = master only
    //    i:  0 = no ICW4, 1 = ICW4 required
    outb(IO_PIC1, 0x11);
  1017ba:	59                   	pop    %ecx
  1017bb:	58                   	pop    %eax
  1017bc:	6a 11                	push   $0x11
  1017be:	6a 20                	push   $0x20
  1017c0:	e8 cb 2d 00 00       	call   104590 <outb>

    // ICW2:  Vector offset
    outb(IO_PIC1 + 1, T_IRQ0);
  1017c5:	58                   	pop    %eax
  1017c6:	5a                   	pop    %edx
  1017c7:	6a 20                	push   $0x20
  1017c9:	6a 21                	push   $0x21
  1017cb:	e8 c0 2d 00 00       	call   104590 <outb>

    // ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
    //        3-bit No of IR line at which slave connects to master(slave PIC).
    outb(IO_PIC1 + 1, 1 << IRQ_SLAVE);
  1017d0:	59                   	pop    %ecx
  1017d1:	58                   	pop    %eax
  1017d2:	6a 04                	push   $0x4
  1017d4:	6a 21                	push   $0x21
  1017d6:	e8 b5 2d 00 00       	call   104590 <outb>
    //    m:  0 = slave PIC, 1 = master PIC
    //        (ignored when b is 0, as the master/slave role
    //        can be hardwired).
    //    a:  1 = Automatic EOI mode
    //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
    outb(IO_PIC1 + 1, 0x3);
  1017db:	58                   	pop    %eax
  1017dc:	5a                   	pop    %edx
  1017dd:	6a 03                	push   $0x3
  1017df:	6a 21                	push   $0x21
  1017e1:	e8 aa 2d 00 00       	call   104590 <outb>

    // Set up slave (8259A-2)
    outb(IO_PIC2, 0x11);            // ICW1
  1017e6:	59                   	pop    %ecx
  1017e7:	58                   	pop    %eax
  1017e8:	6a 11                	push   $0x11
  1017ea:	68 a0 00 00 00       	push   $0xa0
  1017ef:	e8 9c 2d 00 00       	call   104590 <outb>
    outb(IO_PIC2 + 1, T_IRQ0 + 8);  // ICW2
  1017f4:	58                   	pop    %eax
  1017f5:	5a                   	pop    %edx
  1017f6:	6a 28                	push   $0x28
  1017f8:	68 a1 00 00 00       	push   $0xa1
  1017fd:	e8 8e 2d 00 00       	call   104590 <outb>
    outb(IO_PIC2 + 1, IRQ_SLAVE);   // ICW3
  101802:	59                   	pop    %ecx
  101803:	58                   	pop    %eax
  101804:	6a 02                	push   $0x2
  101806:	68 a1 00 00 00       	push   $0xa1
  10180b:	e8 80 2d 00 00       	call   104590 <outb>
    // NB Automatic EOI mode doesn't tend to work on the slave.
    // Linux source code says it's "to be investigated".
    outb(IO_PIC2 + 1, 0x01);        // ICW4
  101810:	58                   	pop    %eax
  101811:	5a                   	pop    %edx
  101812:	6a 01                	push   $0x1
  101814:	68 a1 00 00 00       	push   $0xa1
  101819:	e8 72 2d 00 00       	call   104590 <outb>

    // OCW3:  0ef01prs
    //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
    //    p:  0 = no polling, 1 = polling mode
    //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
    outb(IO_PIC1, 0x68);  /* clear specific mask */
  10181e:	59                   	pop    %ecx
  10181f:	58                   	pop    %eax
  101820:	6a 68                	push   $0x68
  101822:	6a 20                	push   $0x20
  101824:	e8 67 2d 00 00       	call   104590 <outb>
    outb(IO_PIC1, 0x0a);  /* read IRR by default */
  101829:	58                   	pop    %eax
  10182a:	5a                   	pop    %edx
  10182b:	6a 0a                	push   $0xa
  10182d:	6a 20                	push   $0x20
  10182f:	e8 5c 2d 00 00       	call   104590 <outb>

    outb(IO_PIC2, 0x68);  /* OCW3 */
  101834:	59                   	pop    %ecx
  101835:	58                   	pop    %eax
  101836:	6a 68                	push   $0x68
  101838:	68 a0 00 00 00       	push   $0xa0
  10183d:	e8 4e 2d 00 00       	call   104590 <outb>
    outb(IO_PIC2, 0x0a);  /* OCW3 */
  101842:	58                   	pop    %eax
  101843:	5a                   	pop    %edx
  101844:	6a 0a                	push   $0xa
  101846:	68 a0 00 00 00       	push   $0xa0
  10184b:	e8 40 2d 00 00       	call   104590 <outb>
}
  101850:	83 c4 1c             	add    $0x1c,%esp
  101853:	c3                   	ret    
  101854:	66 90                	xchg   %ax,%ax
  101856:	66 90                	xchg   %ax,%ax
  101858:	66 90                	xchg   %ax,%ax
  10185a:	66 90                	xchg   %ax,%ax
  10185c:	66 90                	xchg   %ax,%ax
  10185e:	66 90                	xchg   %ax,%ax

00101860 <timer_hw_init>:
#define TIMER_16BIT   0x30  /* r/w counter 16 bits, LSB first */

// Initialize the programmable interval timer.

void timer_hw_init(void)
{
  101860:	83 ec 14             	sub    $0x14,%esp
    outb(PIT_CONTROL, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  101863:	6a 34                	push   $0x34
  101865:	6a 43                	push   $0x43
  101867:	e8 24 2d 00 00       	call   104590 <outb>
    outb(PIT_CHANNEL0, LOW8(LATCH));
  10186c:	58                   	pop    %eax
  10186d:	5a                   	pop    %edx
  10186e:	68 9c 00 00 00       	push   $0x9c
  101873:	6a 40                	push   $0x40
  101875:	e8 16 2d 00 00       	call   104590 <outb>
    outb(PIT_CHANNEL0, HIGH8(LATCH));
  10187a:	59                   	pop    %ecx
  10187b:	58                   	pop    %eax
  10187c:	6a 2e                	push   $0x2e
  10187e:	6a 40                	push   $0x40
  101880:	e8 0b 2d 00 00       	call   104590 <outb>
}
  101885:	83 c4 1c             	add    $0x1c,%esp
  101888:	c3                   	ret    
  101889:	66 90                	xchg   %ax,%ax
  10188b:	66 90                	xchg   %ax,%ax
  10188d:	66 90                	xchg   %ax,%ax
  10188f:	90                   	nop

00101890 <tsc_init>:
    delta = t2 - t1;
    return delta / ms;
}

int tsc_init(void)
{
  101890:	55                   	push   %ebp
  101891:	57                   	push   %edi
  101892:	56                   	push   %esi
  101893:	53                   	push   %ebx
  101894:	83 ec 3c             	sub    $0x3c,%esp
    uint64_t ret;
    int i;

    timer_hw_init();
  101897:	e8 c4 ff ff ff       	call   101860 <timer_hw_init>

    tsc_per_ms = 0;
  10189c:	c7 05 00 d8 9d 00 00 	movl   $0x0,0x9dd800
  1018a3:	00 00 00 
  1018a6:	c7 05 04 d8 9d 00 00 	movl   $0x0,0x9dd804
  1018ad:	00 00 00 

    if (detect_kvm())
  1018b0:	e8 eb 1a 00 00       	call   1033a0 <detect_kvm>

    /*
     * XXX: If TSC calibration fails frequently, try to increase the
     *      upper bound of loop condition, e.g. alternating 3 to 10.
     */
    for (i = 0; i < 10; i++) {
  1018b5:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  1018bc:	00 
    if (detect_kvm())
  1018bd:	89 44 24 2c          	mov    %eax,0x2c(%esp)
  1018c1:	85 c0                	test   %eax,%eax
  1018c3:	0f 85 37 02 00 00    	jne    101b00 <tsc_init+0x270>
  1018c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    outb(0x61, (inb(0x61) & ~0x02) | 0x01);
  1018d0:	83 ec 0c             	sub    $0xc,%esp
  1018d3:	6a 61                	push   $0x61
  1018d5:	e8 86 2c 00 00       	call   104560 <inb>
  1018da:	5a                   	pop    %edx
  1018db:	59                   	pop    %ecx
  1018dc:	25 fc 00 00 00       	and    $0xfc,%eax
  1018e1:	83 c8 01             	or     $0x1,%eax
  1018e4:	50                   	push   %eax
  1018e5:	6a 61                	push   $0x61
  1018e7:	e8 a4 2c 00 00       	call   104590 <outb>
    outb(0x43, 0xb0);
  1018ec:	5b                   	pop    %ebx
  1018ed:	5e                   	pop    %esi
  1018ee:	68 b0 00 00 00       	push   $0xb0
  1018f3:	6a 43                	push   $0x43
    pitcnt = 0;
  1018f5:	31 f6                	xor    %esi,%esi
    outb(0x43, 0xb0);
  1018f7:	e8 94 2c 00 00       	call   104590 <outb>
    outb(0x42, latch & 0xff);
  1018fc:	5f                   	pop    %edi
  1018fd:	5d                   	pop    %ebp
  1018fe:	68 9b 00 00 00       	push   $0x9b
  101903:	6a 42                	push   $0x42
    tscmax = 0;
  101905:	31 ff                	xor    %edi,%edi
  101907:	31 ed                	xor    %ebp,%ebp
    outb(0x42, latch & 0xff);
  101909:	e8 82 2c 00 00       	call   104590 <outb>
    outb(0x42, latch >> 8);
  10190e:	58                   	pop    %eax
  10190f:	5a                   	pop    %edx
  101910:	6a 2e                	push   $0x2e
  101912:	6a 42                	push   $0x42
  101914:	e8 77 2c 00 00       	call   104590 <outb>
    tsc = t1 = t2 = rdtsc();
  101919:	e8 e2 2a 00 00       	call   104400 <rdtsc>
  10191e:	89 44 24 30          	mov    %eax,0x30(%esp)
  101922:	89 54 24 34          	mov    %edx,0x34(%esp)
    while ((inb(0x61) & 0x20) == 0) {
  101926:	83 c4 10             	add    $0x10,%esp
    tsc = t1 = t2 = rdtsc();
  101929:	89 44 24 10          	mov    %eax,0x10(%esp)
  10192d:	89 54 24 14          	mov    %edx,0x14(%esp)
    tscmin = ~(uint64_t) 0x0;
  101931:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
  101938:	ff 
  101939:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  101940:	ff 
    while ((inb(0x61) & 0x20) == 0) {
  101941:	eb 51                	jmp    101994 <tsc_init+0x104>
  101943:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101947:	90                   	nop
        t2 = rdtsc();
  101948:	e8 b3 2a 00 00       	call   104400 <rdtsc>
        delta = t2 - tsc;
  10194d:	89 c1                	mov    %eax,%ecx
  10194f:	89 d3                	mov    %edx,%ebx
  101951:	2b 4c 24 10          	sub    0x10(%esp),%ecx
  101955:	1b 5c 24 14          	sbb    0x14(%esp),%ebx
        t2 = rdtsc();
  101959:	89 44 24 18          	mov    %eax,0x18(%esp)
  10195d:	3b 4c 24 08          	cmp    0x8(%esp),%ecx
  101961:	89 d8                	mov    %ebx,%eax
  101963:	1b 44 24 0c          	sbb    0xc(%esp),%eax
  101967:	89 54 24 1c          	mov    %edx,0x1c(%esp)
        if (delta < tscmin)
  10196b:	73 08                	jae    101975 <tsc_init+0xe5>
  10196d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  101971:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
        if (delta > tscmax)
  101975:	39 cf                	cmp    %ecx,%edi
  101977:	89 e8                	mov    %ebp,%eax
  101979:	19 d8                	sbb    %ebx,%eax
  10197b:	73 04                	jae    101981 <tsc_init+0xf1>
  10197d:	89 cf                	mov    %ecx,%edi
  10197f:	89 dd                	mov    %ebx,%ebp
        tsc = t2;
  101981:	8b 44 24 18          	mov    0x18(%esp),%eax
  101985:	8b 54 24 1c          	mov    0x1c(%esp),%edx
        pitcnt++;
  101989:	83 c6 01             	add    $0x1,%esi
        tsc = t2;
  10198c:	89 44 24 10          	mov    %eax,0x10(%esp)
  101990:	89 54 24 14          	mov    %edx,0x14(%esp)
    while ((inb(0x61) & 0x20) == 0) {
  101994:	83 ec 0c             	sub    $0xc,%esp
  101997:	6a 61                	push   $0x61
  101999:	e8 c2 2b 00 00       	call   104560 <inb>
  10199e:	83 c4 10             	add    $0x10,%esp
  1019a1:	a8 20                	test   $0x20,%al
  1019a3:	74 a3                	je     101948 <tsc_init+0xb8>
    KERN_DEBUG("pitcnt=%u, tscmin=%llu, tscmax=%llu\n",
  1019a5:	55                   	push   %ebp
  1019a6:	57                   	push   %edi
  1019a7:	ff 74 24 14          	pushl  0x14(%esp)
  1019ab:	ff 74 24 14          	pushl  0x14(%esp)
  1019af:	56                   	push   %esi
  1019b0:	68 b0 94 10 00       	push   $0x1094b0
  1019b5:	6a 39                	push   $0x39
  1019b7:	68 d5 94 10 00       	push   $0x1094d5
  1019bc:	e8 3f 1e 00 00       	call   103800 <debug_normal>
    if (pitcnt < loopmin || tscmax > 10 * tscmin)
  1019c1:	83 c4 20             	add    $0x20,%esp
  1019c4:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
  1019ca:	0f 8e b0 00 00 00    	jle    101a80 <tsc_init+0x1f0>
  1019d0:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  1019d4:	8b 74 24 0c          	mov    0xc(%esp),%esi
  1019d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  1019dd:	f7 e3                	mul    %ebx
  1019df:	6b ce 0a             	imul   $0xa,%esi,%ecx
  1019e2:	01 ca                	add    %ecx,%edx
  1019e4:	39 f8                	cmp    %edi,%eax
  1019e6:	89 d0                	mov    %edx,%eax
  1019e8:	19 e8                	sbb    %ebp,%eax
  1019ea:	0f 82 90 00 00 00    	jb     101a80 <tsc_init+0x1f0>
    delta = t2 - t1;
  1019f0:	8b 44 24 10          	mov    0x10(%esp),%eax
  1019f4:	8b 54 24 14          	mov    0x14(%esp),%edx
  1019f8:	2b 44 24 20          	sub    0x20(%esp),%eax
  1019fc:	1b 54 24 24          	sbb    0x24(%esp),%edx
    return delta / ms;
  101a00:	6a 00                	push   $0x0
  101a02:	6a 0a                	push   $0xa
  101a04:	52                   	push   %edx
  101a05:	50                   	push   %eax
  101a06:	e8 b5 67 00 00       	call   1081c0 <__udivdi3>

        timer_hw_init();
        return 1;
    } else {
        tsc_per_ms = ret;
        KERN_DEBUG("TSC freq = %u.%03u MHz.\n",tsc_per_ms / 1000, tsc_per_ms % 1000);
  101a0b:	6a 00                	push   $0x0
        tsc_per_ms = ret;
  101a0d:	a3 00 d8 9d 00       	mov    %eax,0x9dd800
  101a12:	89 15 04 d8 9d 00    	mov    %edx,0x9dd804
        KERN_DEBUG("TSC freq = %u.%03u MHz.\n",tsc_per_ms / 1000, tsc_per_ms % 1000);
  101a18:	a1 00 d8 9d 00       	mov    0x9dd800,%eax
  101a1d:	8b 15 04 d8 9d 00    	mov    0x9dd804,%edx
  101a23:	68 e8 03 00 00       	push   $0x3e8
  101a28:	8b 35 00 d8 9d 00    	mov    0x9dd800,%esi
  101a2e:	8b 3d 04 d8 9d 00    	mov    0x9dd804,%edi
  101a34:	52                   	push   %edx
  101a35:	50                   	push   %eax
  101a36:	e8 95 68 00 00       	call   1082d0 <__umoddi3>
  101a3b:	83 c4 1c             	add    $0x1c,%esp
  101a3e:	52                   	push   %edx
  101a3f:	50                   	push   %eax
  101a40:	83 ec 04             	sub    $0x4,%esp
  101a43:	6a 00                	push   $0x0
  101a45:	68 e8 03 00 00       	push   $0x3e8
  101a4a:	57                   	push   %edi
  101a4b:	56                   	push   %esi
  101a4c:	e8 6f 67 00 00       	call   1081c0 <__udivdi3>
  101a51:	83 c4 14             	add    $0x14,%esp
  101a54:	52                   	push   %edx
  101a55:	50                   	push   %eax
  101a56:	68 e4 94 10 00       	push   $0x1094e4
  101a5b:	6a 68                	push   $0x68
  101a5d:	68 d5 94 10 00       	push   $0x1094d5
  101a62:	e8 99 1d 00 00       	call   103800 <debug_normal>

        timer_hw_init();
  101a67:	83 c4 20             	add    $0x20,%esp
  101a6a:	e8 f1 fd ff ff       	call   101860 <timer_hw_init>
        return 0;
    }
}
  101a6f:	8b 44 24 2c          	mov    0x2c(%esp),%eax
  101a73:	83 c4 3c             	add    $0x3c,%esp
  101a76:	5b                   	pop    %ebx
  101a77:	5e                   	pop    %esi
  101a78:	5f                   	pop    %edi
  101a79:	5d                   	pop    %ebp
  101a7a:	c3                   	ret    
  101a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101a7f:	90                   	nop
        KERN_DEBUG("[%d] Retry to calibrate TSC.\n", i + 1);
  101a80:	83 44 24 28 01       	addl   $0x1,0x28(%esp)
  101a85:	8b 5c 24 28          	mov    0x28(%esp),%ebx
  101a89:	53                   	push   %ebx
  101a8a:	68 fd 94 10 00       	push   $0x1094fd
  101a8f:	6a 5c                	push   $0x5c
  101a91:	68 d5 94 10 00       	push   $0x1094d5
  101a96:	e8 65 1d 00 00       	call   103800 <debug_normal>
    for (i = 0; i < 10; i++) {
  101a9b:	83 c4 10             	add    $0x10,%esp
  101a9e:	83 fb 0a             	cmp    $0xa,%ebx
  101aa1:	0f 85 29 fe ff ff    	jne    1018d0 <tsc_init+0x40>
        KERN_DEBUG("TSC calibration failed.\n");
  101aa7:	83 ec 04             	sub    $0x4,%esp
  101aaa:	68 1b 95 10 00       	push   $0x10951b
  101aaf:	6a 60                	push   $0x60
  101ab1:	68 d5 94 10 00       	push   $0x1094d5
  101ab6:	e8 45 1d 00 00       	call   103800 <debug_normal>
        KERN_DEBUG("Assume TSC freq = 1 GHz.\n");
  101abb:	83 c4 0c             	add    $0xc,%esp
  101abe:	68 34 95 10 00       	push   $0x109534
  101ac3:	6a 61                	push   $0x61
  101ac5:	68 d5 94 10 00       	push   $0x1094d5
  101aca:	e8 31 1d 00 00       	call   103800 <debug_normal>
        tsc_per_ms = 1000000;
  101acf:	c7 05 00 d8 9d 00 40 	movl   $0xf4240,0x9dd800
  101ad6:	42 0f 00 
  101ad9:	c7 05 04 d8 9d 00 00 	movl   $0x0,0x9dd804
  101ae0:	00 00 00 
        timer_hw_init();
  101ae3:	e8 78 fd ff ff       	call   101860 <timer_hw_init>
        return 1;
  101ae8:	83 c4 10             	add    $0x10,%esp
  101aeb:	c7 44 24 2c 01 00 00 	movl   $0x1,0x2c(%esp)
  101af2:	00 
}
  101af3:	8b 44 24 2c          	mov    0x2c(%esp),%eax
  101af7:	83 c4 3c             	add    $0x3c,%esp
  101afa:	5b                   	pop    %ebx
  101afb:	5e                   	pop    %esi
  101afc:	5f                   	pop    %edi
  101afd:	5d                   	pop    %ebp
  101afe:	c3                   	ret    
  101aff:	90                   	nop
		tsc_per_ms = kvm_get_tsc_hz() / 1000llu;
  101b00:	e8 ab 19 00 00       	call   1034b0 <kvm_get_tsc_hz>
  101b05:	6a 00                	push   $0x0
  101b07:	68 e8 03 00 00       	push   $0x3e8
  101b0c:	52                   	push   %edx
  101b0d:	50                   	push   %eax
  101b0e:	e8 ad 66 00 00       	call   1081c0 <__udivdi3>
		KERN_INFO ("TSC read from KVM: %u.%03u MHz.\n",
  101b13:	6a 00                	push   $0x0
		tsc_per_ms = kvm_get_tsc_hz() / 1000llu;
  101b15:	a3 00 d8 9d 00       	mov    %eax,0x9dd800
  101b1a:	89 15 04 d8 9d 00    	mov    %edx,0x9dd804
		KERN_INFO ("TSC read from KVM: %u.%03u MHz.\n",
  101b20:	a1 00 d8 9d 00       	mov    0x9dd800,%eax
  101b25:	8b 15 04 d8 9d 00    	mov    0x9dd804,%edx
  101b2b:	68 e8 03 00 00       	push   $0x3e8
  101b30:	8b 35 00 d8 9d 00    	mov    0x9dd800,%esi
  101b36:	8b 3d 04 d8 9d 00    	mov    0x9dd804,%edi
  101b3c:	52                   	push   %edx
  101b3d:	50                   	push   %eax
  101b3e:	e8 8d 67 00 00       	call   1082d0 <__umoddi3>
  101b43:	83 c4 14             	add    $0x14,%esp
  101b46:	52                   	push   %edx
  101b47:	50                   	push   %eax
  101b48:	83 ec 0c             	sub    $0xc,%esp
  101b4b:	6a 00                	push   $0x0
  101b4d:	68 e8 03 00 00       	push   $0x3e8
  101b52:	57                   	push   %edi
  101b53:	56                   	push   %esi
  101b54:	e8 67 66 00 00       	call   1081c0 <__udivdi3>
  101b59:	83 c4 1c             	add    $0x1c,%esp
  101b5c:	52                   	push   %edx
  101b5d:	50                   	push   %eax
  101b5e:	68 8c 94 10 00       	push   $0x10948c
  101b63:	e8 68 1c 00 00       	call   1037d0 <debug_info>
		return (0);
  101b68:	83 c4 20             	add    $0x20,%esp
  101b6b:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  101b72:	00 
}
  101b73:	8b 44 24 2c          	mov    0x2c(%esp),%eax
  101b77:	83 c4 3c             	add    $0x3c,%esp
  101b7a:	5b                   	pop    %ebx
  101b7b:	5e                   	pop    %esi
  101b7c:	5f                   	pop    %edi
  101b7d:	5d                   	pop    %ebp
  101b7e:	c3                   	ret    
  101b7f:	90                   	nop

00101b80 <delay>:

/*
 * Wait for ms millisecond.
 */
void delay(uint32_t ms)
{
  101b80:	57                   	push   %edi
  101b81:	56                   	push   %esi
  101b82:	53                   	push   %ebx
  101b83:	83 ec 10             	sub    $0x10,%esp
    volatile uint64_t ticks = tsc_per_ms * ms;
  101b86:	8b 35 00 d8 9d 00    	mov    0x9dd800,%esi
  101b8c:	8b 3d 04 d8 9d 00    	mov    0x9dd804,%edi
{
  101b92:	8b 44 24 20          	mov    0x20(%esp),%eax
    volatile uint64_t ticks = tsc_per_ms * ms;
  101b96:	89 fb                	mov    %edi,%ebx
  101b98:	0f af d8             	imul   %eax,%ebx
  101b9b:	f7 e6                	mul    %esi
  101b9d:	01 da                	add    %ebx,%edx
  101b9f:	89 04 24             	mov    %eax,(%esp)
  101ba2:	89 54 24 04          	mov    %edx,0x4(%esp)
    volatile uint64_t start = rdtsc();
  101ba6:	e8 55 28 00 00       	call   104400 <rdtsc>
  101bab:	89 44 24 08          	mov    %eax,0x8(%esp)
  101baf:	89 54 24 0c          	mov    %edx,0xc(%esp)
    while (rdtsc() < start + ticks);
  101bb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101bb7:	90                   	nop
  101bb8:	e8 43 28 00 00       	call   104400 <rdtsc>
  101bbd:	89 c3                	mov    %eax,%ebx
  101bbf:	89 d1                	mov    %edx,%ecx
  101bc1:	8b 44 24 08          	mov    0x8(%esp),%eax
  101bc5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  101bc9:	8b 34 24             	mov    (%esp),%esi
  101bcc:	8b 7c 24 04          	mov    0x4(%esp),%edi
  101bd0:	01 f0                	add    %esi,%eax
  101bd2:	11 fa                	adc    %edi,%edx
  101bd4:	39 c3                	cmp    %eax,%ebx
  101bd6:	19 d1                	sbb    %edx,%ecx
  101bd8:	72 de                	jb     101bb8 <delay+0x38>
}
  101bda:	83 c4 10             	add    $0x10,%esp
  101bdd:	5b                   	pop    %ebx
  101bde:	5e                   	pop    %esi
  101bdf:	5f                   	pop    %edi
  101be0:	c3                   	ret    
  101be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101bef:	90                   	nop

00101bf0 <udelay>:

/*
 * Wait for us microsecond.
 */
void udelay(uint32_t us)
{
  101bf0:	57                   	push   %edi
  101bf1:	56                   	push   %esi
  101bf2:	53                   	push   %ebx
  101bf3:	83 ec 10             	sub    $0x10,%esp
    volatile uint64_t ticks = tsc_per_ms / 1000 * us;
  101bf6:	a1 00 d8 9d 00       	mov    0x9dd800,%eax
  101bfb:	8b 15 04 d8 9d 00    	mov    0x9dd804,%edx
{
  101c01:	8b 5c 24 20          	mov    0x20(%esp),%ebx
    volatile uint64_t ticks = tsc_per_ms / 1000 * us;
  101c05:	6a 00                	push   $0x0
  101c07:	68 e8 03 00 00       	push   $0x3e8
  101c0c:	52                   	push   %edx
  101c0d:	50                   	push   %eax
  101c0e:	e8 ad 65 00 00       	call   1081c0 <__udivdi3>
  101c13:	83 c4 10             	add    $0x10,%esp
  101c16:	0f af d3             	imul   %ebx,%edx
  101c19:	89 d1                	mov    %edx,%ecx
  101c1b:	f7 e3                	mul    %ebx
  101c1d:	01 ca                	add    %ecx,%edx
  101c1f:	89 04 24             	mov    %eax,(%esp)
  101c22:	89 54 24 04          	mov    %edx,0x4(%esp)
    volatile uint64_t start = rdtsc();
  101c26:	e8 d5 27 00 00       	call   104400 <rdtsc>
  101c2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  101c2f:	89 54 24 0c          	mov    %edx,0xc(%esp)
    while (rdtsc() < start + ticks);
  101c33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101c37:	90                   	nop
  101c38:	e8 c3 27 00 00       	call   104400 <rdtsc>
  101c3d:	89 c3                	mov    %eax,%ebx
  101c3f:	89 d1                	mov    %edx,%ecx
  101c41:	8b 44 24 08          	mov    0x8(%esp),%eax
  101c45:	8b 54 24 0c          	mov    0xc(%esp),%edx
  101c49:	8b 34 24             	mov    (%esp),%esi
  101c4c:	8b 7c 24 04          	mov    0x4(%esp),%edi
  101c50:	01 f0                	add    %esi,%eax
  101c52:	11 fa                	adc    %edi,%edx
  101c54:	39 c3                	cmp    %eax,%ebx
  101c56:	19 d1                	sbb    %edx,%ecx
  101c58:	72 de                	jb     101c38 <udelay+0x48>
}
  101c5a:	83 c4 10             	add    $0x10,%esp
  101c5d:	5b                   	pop    %ebx
  101c5e:	5e                   	pop    %esi
  101c5f:	5f                   	pop    %edi
  101c60:	c3                   	ret    
  101c61:	66 90                	xchg   %ax,%ax
  101c63:	66 90                	xchg   %ax,%ax
  101c65:	66 90                	xchg   %ax,%ax
  101c67:	66 90                	xchg   %ax,%ax
  101c69:	66 90                	xchg   %ax,%ax
  101c6b:	66 90                	xchg   %ax,%ax
  101c6d:	66 90                	xchg   %ax,%ax
  101c6f:	90                   	nop

00101c70 <Xdivide>:
	jmp	_alltraps

.text

/* exceptions  */
TRAPHANDLER_NOEC(Xdivide,	T_DIVIDE)
  101c70:	6a 00                	push   $0x0
  101c72:	6a 00                	push   $0x0
  101c74:	e9 17 01 00 00       	jmp    101d90 <_alltraps>
  101c79:	90                   	nop

00101c7a <Xdebug>:
TRAPHANDLER_NOEC(Xdebug,	T_DEBUG)
  101c7a:	6a 00                	push   $0x0
  101c7c:	6a 01                	push   $0x1
  101c7e:	e9 0d 01 00 00       	jmp    101d90 <_alltraps>
  101c83:	90                   	nop

00101c84 <Xnmi>:
TRAPHANDLER_NOEC(Xnmi,		T_NMI)
  101c84:	6a 00                	push   $0x0
  101c86:	6a 02                	push   $0x2
  101c88:	e9 03 01 00 00       	jmp    101d90 <_alltraps>
  101c8d:	90                   	nop

00101c8e <Xbrkpt>:
TRAPHANDLER_NOEC(Xbrkpt,	T_BRKPT)
  101c8e:	6a 00                	push   $0x0
  101c90:	6a 03                	push   $0x3
  101c92:	e9 f9 00 00 00       	jmp    101d90 <_alltraps>
  101c97:	90                   	nop

00101c98 <Xoflow>:
TRAPHANDLER_NOEC(Xoflow,	T_OFLOW)
  101c98:	6a 00                	push   $0x0
  101c9a:	6a 04                	push   $0x4
  101c9c:	e9 ef 00 00 00       	jmp    101d90 <_alltraps>
  101ca1:	90                   	nop

00101ca2 <Xbound>:
TRAPHANDLER_NOEC(Xbound,	T_BOUND)
  101ca2:	6a 00                	push   $0x0
  101ca4:	6a 05                	push   $0x5
  101ca6:	e9 e5 00 00 00       	jmp    101d90 <_alltraps>
  101cab:	90                   	nop

00101cac <Xillop>:
TRAPHANDLER_NOEC(Xillop,	T_ILLOP)
  101cac:	6a 00                	push   $0x0
  101cae:	6a 06                	push   $0x6
  101cb0:	e9 db 00 00 00       	jmp    101d90 <_alltraps>
  101cb5:	90                   	nop

00101cb6 <Xdevice>:
TRAPHANDLER_NOEC(Xdevice,	T_DEVICE)
  101cb6:	6a 00                	push   $0x0
  101cb8:	6a 07                	push   $0x7
  101cba:	e9 d1 00 00 00       	jmp    101d90 <_alltraps>
  101cbf:	90                   	nop

00101cc0 <Xdblflt>:
TRAPHANDLER     (Xdblflt,	T_DBLFLT)
  101cc0:	6a 08                	push   $0x8
  101cc2:	e9 c9 00 00 00       	jmp    101d90 <_alltraps>
  101cc7:	90                   	nop

00101cc8 <Xcoproc>:
TRAPHANDLER_NOEC(Xcoproc,	T_COPROC)
  101cc8:	6a 00                	push   $0x0
  101cca:	6a 09                	push   $0x9
  101ccc:	e9 bf 00 00 00       	jmp    101d90 <_alltraps>
  101cd1:	90                   	nop

00101cd2 <Xtss>:
TRAPHANDLER     (Xtss,		T_TSS)
  101cd2:	6a 0a                	push   $0xa
  101cd4:	e9 b7 00 00 00       	jmp    101d90 <_alltraps>
  101cd9:	90                   	nop

00101cda <Xsegnp>:
TRAPHANDLER     (Xsegnp,	T_SEGNP)
  101cda:	6a 0b                	push   $0xb
  101cdc:	e9 af 00 00 00       	jmp    101d90 <_alltraps>
  101ce1:	90                   	nop

00101ce2 <Xstack>:
TRAPHANDLER     (Xstack,	T_STACK)
  101ce2:	6a 0c                	push   $0xc
  101ce4:	e9 a7 00 00 00       	jmp    101d90 <_alltraps>
  101ce9:	90                   	nop

00101cea <Xgpflt>:
TRAPHANDLER     (Xgpflt,	T_GPFLT)
  101cea:	6a 0d                	push   $0xd
  101cec:	e9 9f 00 00 00       	jmp    101d90 <_alltraps>
  101cf1:	90                   	nop

00101cf2 <Xpgflt>:
TRAPHANDLER     (Xpgflt,	T_PGFLT)
  101cf2:	6a 0e                	push   $0xe
  101cf4:	e9 97 00 00 00       	jmp    101d90 <_alltraps>
  101cf9:	90                   	nop

00101cfa <Xres>:
TRAPHANDLER_NOEC(Xres,		T_RES)
  101cfa:	6a 00                	push   $0x0
  101cfc:	6a 0f                	push   $0xf
  101cfe:	e9 8d 00 00 00       	jmp    101d90 <_alltraps>
  101d03:	90                   	nop

00101d04 <Xfperr>:
TRAPHANDLER_NOEC(Xfperr,	T_FPERR)
  101d04:	6a 00                	push   $0x0
  101d06:	6a 10                	push   $0x10
  101d08:	e9 83 00 00 00       	jmp    101d90 <_alltraps>
  101d0d:	90                   	nop

00101d0e <Xalign>:
TRAPHANDLER     (Xalign,	T_ALIGN)
  101d0e:	6a 11                	push   $0x11
  101d10:	eb 7e                	jmp    101d90 <_alltraps>

00101d12 <Xmchk>:
TRAPHANDLER_NOEC(Xmchk,		T_MCHK)
  101d12:	6a 00                	push   $0x0
  101d14:	6a 12                	push   $0x12
  101d16:	eb 78                	jmp    101d90 <_alltraps>

00101d18 <Xirq_timer>:

/* ISA interrupts  */
TRAPHANDLER_NOEC(Xirq_timer,	T_IRQ0 + IRQ_TIMER)
  101d18:	6a 00                	push   $0x0
  101d1a:	6a 20                	push   $0x20
  101d1c:	eb 72                	jmp    101d90 <_alltraps>

00101d1e <Xirq_kbd>:
TRAPHANDLER_NOEC(Xirq_kbd,	T_IRQ0 + IRQ_KBD)
  101d1e:	6a 00                	push   $0x0
  101d20:	6a 21                	push   $0x21
  101d22:	eb 6c                	jmp    101d90 <_alltraps>

00101d24 <Xirq_slave>:
TRAPHANDLER_NOEC(Xirq_slave,	T_IRQ0 + IRQ_SLAVE)
  101d24:	6a 00                	push   $0x0
  101d26:	6a 22                	push   $0x22
  101d28:	eb 66                	jmp    101d90 <_alltraps>

00101d2a <Xirq_serial2>:
TRAPHANDLER_NOEC(Xirq_serial2,	T_IRQ0 + IRQ_SERIAL24)
  101d2a:	6a 00                	push   $0x0
  101d2c:	6a 23                	push   $0x23
  101d2e:	eb 60                	jmp    101d90 <_alltraps>

00101d30 <Xirq_serial1>:
TRAPHANDLER_NOEC(Xirq_serial1,	T_IRQ0 + IRQ_SERIAL13)
  101d30:	6a 00                	push   $0x0
  101d32:	6a 24                	push   $0x24
  101d34:	eb 5a                	jmp    101d90 <_alltraps>

00101d36 <Xirq_lpt>:
TRAPHANDLER_NOEC(Xirq_lpt,	T_IRQ0 + IRQ_LPT2)
  101d36:	6a 00                	push   $0x0
  101d38:	6a 25                	push   $0x25
  101d3a:	eb 54                	jmp    101d90 <_alltraps>

00101d3c <Xirq_floppy>:
TRAPHANDLER_NOEC(Xirq_floppy,	T_IRQ0 + IRQ_FLOPPY)
  101d3c:	6a 00                	push   $0x0
  101d3e:	6a 26                	push   $0x26
  101d40:	eb 4e                	jmp    101d90 <_alltraps>

00101d42 <Xirq_spurious>:
TRAPHANDLER_NOEC(Xirq_spurious,	T_IRQ0 + IRQ_SPURIOUS)
  101d42:	6a 00                	push   $0x0
  101d44:	6a 27                	push   $0x27
  101d46:	eb 48                	jmp    101d90 <_alltraps>

00101d48 <Xirq_rtc>:
TRAPHANDLER_NOEC(Xirq_rtc,	T_IRQ0 + IRQ_RTC)
  101d48:	6a 00                	push   $0x0
  101d4a:	6a 28                	push   $0x28
  101d4c:	eb 42                	jmp    101d90 <_alltraps>

00101d4e <Xirq9>:
TRAPHANDLER_NOEC(Xirq9,		T_IRQ0 + 9)
  101d4e:	6a 00                	push   $0x0
  101d50:	6a 29                	push   $0x29
  101d52:	eb 3c                	jmp    101d90 <_alltraps>

00101d54 <Xirq10>:
TRAPHANDLER_NOEC(Xirq10,	T_IRQ0 + 10)
  101d54:	6a 00                	push   $0x0
  101d56:	6a 2a                	push   $0x2a
  101d58:	eb 36                	jmp    101d90 <_alltraps>

00101d5a <Xirq11>:
TRAPHANDLER_NOEC(Xirq11,	T_IRQ0 + 11)
  101d5a:	6a 00                	push   $0x0
  101d5c:	6a 2b                	push   $0x2b
  101d5e:	eb 30                	jmp    101d90 <_alltraps>

00101d60 <Xirq_mouse>:
TRAPHANDLER_NOEC(Xirq_mouse,	T_IRQ0 + IRQ_MOUSE)
  101d60:	6a 00                	push   $0x0
  101d62:	6a 2c                	push   $0x2c
  101d64:	eb 2a                	jmp    101d90 <_alltraps>

00101d66 <Xirq_coproc>:
TRAPHANDLER_NOEC(Xirq_coproc,	T_IRQ0 + IRQ_COPROCESSOR)
  101d66:	6a 00                	push   $0x0
  101d68:	6a 2d                	push   $0x2d
  101d6a:	eb 24                	jmp    101d90 <_alltraps>

00101d6c <Xirq_ide1>:
TRAPHANDLER_NOEC(Xirq_ide1,	T_IRQ0 + IRQ_IDE1)
  101d6c:	6a 00                	push   $0x0
  101d6e:	6a 2e                	push   $0x2e
  101d70:	eb 1e                	jmp    101d90 <_alltraps>

00101d72 <Xirq_ide2>:
TRAPHANDLER_NOEC(Xirq_ide2,	T_IRQ0 + IRQ_IDE2)
  101d72:	6a 00                	push   $0x0
  101d74:	6a 2f                	push   $0x2f
  101d76:	eb 18                	jmp    101d90 <_alltraps>

00101d78 <Xsyscall>:

/* syscall */
TRAPHANDLER_NOEC(Xsyscall,	T_SYSCALL)
  101d78:	6a 00                	push   $0x0
  101d7a:	6a 30                	push   $0x30
  101d7c:	eb 12                	jmp    101d90 <_alltraps>

00101d7e <Xdefault>:

/* default ? */
TRAPHANDLER     (Xdefault,	T_DEFAULT)
  101d7e:	68 fe 00 00 00       	push   $0xfe
  101d83:	eb 0b                	jmp    101d90 <_alltraps>
  101d85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101d90 <_alltraps>:

	.globl _alltraps
	.type _alltraps, @function
	.p2align 4, 0x90	/* 16-byte alignment, nop filled */
_alltraps:
	cli			# make sure there is no nested trap
  101d90:	fa                   	cli    
	cld
  101d91:	fc                   	cld    

	pushl	%ds		# build context
  101d92:	1e                   	push   %ds
	pushl	%es
  101d93:	06                   	push   %es
	pushal
  101d94:	60                   	pusha  

	movl	$CPU_GDT_KDATA, %eax	# load kernel's data segment
  101d95:	b8 10 00 00 00       	mov    $0x10,%eax
	movw	%ax, %ds
  101d9a:	8e d8                	mov    %eax,%ds
	movw	%ax, %es
  101d9c:	8e c0                	mov    %eax,%es

	pushl	%esp		# pass pointer to this trapframe
  101d9e:	54                   	push   %esp

	call	trap		# and call trap (does not return)
  101d9f:	e8 dc 60 00 00       	call   107e80 <trap>

1:	hlt			# should never get here; just spin...
  101da4:	f4                   	hlt    
  101da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101db0 <trap_return>:
//
	.globl trap_return
	.type trap_return, @function
	.p2align 4, 0x90	/* 16-byte alignment, nop filled */
trap_return:
	movl	4(%esp), %esp	// reset stack pointer to point to trap frame
  101db0:	8b 64 24 04          	mov    0x4(%esp),%esp
	popal			// restore general-purpose registers except esp
  101db4:	61                   	popa   
	popl	%es		// restore data segment registers
  101db5:	07                   	pop    %es
	popl	%ds
  101db6:	1f                   	pop    %ds
	addl	$8, %esp	// skip tf_trapno and tf_errcode
  101db7:	83 c4 08             	add    $0x8,%esp
	iret			// return from trap handler
  101dba:	cf                   	iret   
  101dbb:	66 90                	xchg   %ax,%ax
  101dbd:	66 90                	xchg   %ax,%ax
  101dbf:	90                   	nop

00101dc0 <acpi_probe_rsdp>:

    return NULL;
}

acpi_rsdp_t *acpi_probe_rsdp(void)
{
  101dc0:	57                   	push   %edi
  101dc1:	56                   	push   %esi
  101dc2:	53                   	push   %ebx
    uint8_t *bda;
    uint32_t p;
    acpi_rsdp_t *rsdp;

    bda = (uint8_t *) 0x400;
    if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
  101dc3:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  101dca:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  101dd1:	c1 e0 08             	shl    $0x8,%eax
  101dd4:	09 d0                	or     %edx,%eax
  101dd6:	c1 e0 04             	shl    $0x4,%eax
  101dd9:	74 4d                	je     101e28 <acpi_probe_rsdp+0x68>
    e = addr + length;
  101ddb:	8d 88 00 04 00 00    	lea    0x400(%eax),%ecx
    for (p = addr; p < e; p += 16) {
  101de1:	eb 0c                	jmp    101def <acpi_probe_rsdp+0x2f>
  101de3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101de7:	90                   	nop
  101de8:	83 c0 10             	add    $0x10,%eax
  101deb:	39 c1                	cmp    %eax,%ecx
  101ded:	76 39                	jbe    101e28 <acpi_probe_rsdp+0x68>
        if (*(uint32_t *) p == ACPI_RSDP_SIG1 &&
  101def:	81 38 52 53 44 20    	cmpl   $0x20445352,(%eax)
  101df5:	75 f1                	jne    101de8 <acpi_probe_rsdp+0x28>
  101df7:	81 78 04 50 54 52 20 	cmpl   $0x20525450,0x4(%eax)
  101dfe:	75 e8                	jne    101de8 <acpi_probe_rsdp+0x28>
  101e00:	89 c2                	mov    %eax,%edx
    sum = 0;
  101e02:	31 db                	xor    %ebx,%ebx
  101e04:	8d 70 24             	lea    0x24(%eax),%esi
  101e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101e0e:	66 90                	xchg   %ax,%ax
        sum += addr[i];
  101e10:	0f b6 3a             	movzbl (%edx),%edi
  101e13:	83 c2 01             	add    $0x1,%edx
  101e16:	01 fb                	add    %edi,%ebx
    for (i = 0; i < len; i++) {
  101e18:	39 f2                	cmp    %esi,%edx
  101e1a:	75 f4                	jne    101e10 <acpi_probe_rsdp+0x50>
            *(uint32_t *) (p + 4) == ACPI_RSDP_SIG2 &&
  101e1c:	84 db                	test   %bl,%bl
  101e1e:	75 c8                	jne    101de8 <acpi_probe_rsdp+0x28>
        if ((rsdp = acpi_probe_rsdp_aux((uint8_t *) p, 1024)))
            return rsdp;
    }

    return acpi_probe_rsdp_aux((uint8_t *) 0xE0000, 0x1FFFF);
}
  101e20:	5b                   	pop    %ebx
  101e21:	5e                   	pop    %esi
  101e22:	5f                   	pop    %edi
  101e23:	c3                   	ret    
  101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101e28:	b8 00 00 0e 00       	mov    $0xe0000,%eax
  101e2d:	eb 0b                	jmp    101e3a <acpi_probe_rsdp+0x7a>
  101e2f:	90                   	nop
    for (p = addr; p < e; p += 16) {
  101e30:	83 c0 10             	add    $0x10,%eax
  101e33:	3d 00 00 10 00       	cmp    $0x100000,%eax
  101e38:	74 38                	je     101e72 <acpi_probe_rsdp+0xb2>
        if (*(uint32_t *) p == ACPI_RSDP_SIG1 &&
  101e3a:	81 38 52 53 44 20    	cmpl   $0x20445352,(%eax)
  101e40:	75 ee                	jne    101e30 <acpi_probe_rsdp+0x70>
  101e42:	81 78 04 50 54 52 20 	cmpl   $0x20525450,0x4(%eax)
  101e49:	75 e5                	jne    101e30 <acpi_probe_rsdp+0x70>
  101e4b:	89 c2                	mov    %eax,%edx
    sum = 0;
  101e4d:	31 c9                	xor    %ecx,%ecx
  101e4f:	8d 70 24             	lea    0x24(%eax),%esi
  101e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += addr[i];
  101e58:	0f b6 1a             	movzbl (%edx),%ebx
  101e5b:	83 c2 01             	add    $0x1,%edx
  101e5e:	01 d9                	add    %ebx,%ecx
    for (i = 0; i < len; i++) {
  101e60:	39 d6                	cmp    %edx,%esi
  101e62:	75 f4                	jne    101e58 <acpi_probe_rsdp+0x98>
            *(uint32_t *) (p + 4) == ACPI_RSDP_SIG2 &&
  101e64:	84 c9                	test   %cl,%cl
  101e66:	74 b8                	je     101e20 <acpi_probe_rsdp+0x60>
    for (p = addr; p < e; p += 16) {
  101e68:	83 c0 10             	add    $0x10,%eax
  101e6b:	3d 00 00 10 00       	cmp    $0x100000,%eax
  101e70:	75 c8                	jne    101e3a <acpi_probe_rsdp+0x7a>
}
  101e72:	5b                   	pop    %ebx
    return NULL;
  101e73:	31 c0                	xor    %eax,%eax
}
  101e75:	5e                   	pop    %esi
  101e76:	5f                   	pop    %edi
  101e77:	c3                   	ret    
  101e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101e7f:	90                   	nop

00101e80 <acpi_probe_rsdt>:

acpi_rsdt_t *acpi_probe_rsdt(acpi_rsdp_t *rsdp)
{
  101e80:	56                   	push   %esi
  101e81:	53                   	push   %ebx
  101e82:	83 ec 04             	sub    $0x4,%esp
  101e85:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    KERN_ASSERT(rsdp != NULL);
  101e89:	85 db                	test   %ebx,%ebx
  101e8b:	74 53                	je     101ee0 <acpi_probe_rsdt+0x60>

    acpi_rsdt_t *rsdt = (acpi_rsdt_t *) (rsdp->rsdt_addr);
  101e8d:	8b 5b 10             	mov    0x10(%ebx),%ebx
  101e90:	89 d8                	mov    %ebx,%eax
    if (rsdt == NULL)
  101e92:	85 db                	test   %ebx,%ebx
  101e94:	74 30                	je     101ec6 <acpi_probe_rsdt+0x46>
        return NULL;
    if (rsdt->sig == ACPI_RSDT_SIG && sum((uint8_t *) rsdt, rsdt->length) == 0) {
  101e96:	81 3b 52 53 44 54    	cmpl   $0x54445352,(%ebx)
  101e9c:	75 32                	jne    101ed0 <acpi_probe_rsdt+0x50>
  101e9e:	8b 73 04             	mov    0x4(%ebx),%esi
    for (i = 0; i < len; i++) {
  101ea1:	85 f6                	test   %esi,%esi
  101ea3:	7e 21                	jle    101ec6 <acpi_probe_rsdt+0x46>
  101ea5:	01 de                	add    %ebx,%esi
    sum = 0;
  101ea7:	31 d2                	xor    %edx,%edx
  101ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        sum += addr[i];
  101eb0:	0f b6 08             	movzbl (%eax),%ecx
  101eb3:	83 c0 01             	add    $0x1,%eax
  101eb6:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++) {
  101eb8:	39 c6                	cmp    %eax,%esi
  101eba:	75 f4                	jne    101eb0 <acpi_probe_rsdt+0x30>
        return NULL;
  101ebc:	84 d2                	test   %dl,%dl
  101ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  101ec3:	0f 45 d8             	cmovne %eax,%ebx
        return rsdt;
    }

    return NULL;
}
  101ec6:	83 c4 04             	add    $0x4,%esp
  101ec9:	89 d8                	mov    %ebx,%eax
  101ecb:	5b                   	pop    %ebx
  101ecc:	5e                   	pop    %esi
  101ecd:	c3                   	ret    
  101ece:	66 90                	xchg   %ax,%ax
        return NULL;
  101ed0:	31 db                	xor    %ebx,%ebx
}
  101ed2:	83 c4 04             	add    $0x4,%esp
  101ed5:	89 d8                	mov    %ebx,%eax
  101ed7:	5b                   	pop    %ebx
  101ed8:	5e                   	pop    %esi
  101ed9:	c3                   	ret    
  101eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    KERN_ASSERT(rsdp != NULL);
  101ee0:	68 4e 95 10 00       	push   $0x10954e
  101ee5:	68 df 92 10 00       	push   $0x1092df
  101eea:	6a 33                	push   $0x33
  101eec:	68 5b 95 10 00       	push   $0x10955b
  101ef1:	e8 5a 19 00 00       	call   103850 <debug_panic>
  101ef6:	83 c4 10             	add    $0x10,%esp
  101ef9:	eb 92                	jmp    101e8d <acpi_probe_rsdt+0xd>
  101efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101eff:	90                   	nop

00101f00 <acpi_probe_rsdt_ent>:

acpi_sdt_hdr_t *acpi_probe_rsdt_ent(acpi_rsdt_t *rsdt, const uint32_t sig)
{
  101f00:	55                   	push   %ebp
  101f01:	57                   	push   %edi
  101f02:	56                   	push   %esi
  101f03:	53                   	push   %ebx
  101f04:	83 ec 1c             	sub    $0x1c,%esp
  101f07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
    KERN_ASSERT(rsdt != NULL);
  101f0b:	85 db                	test   %ebx,%ebx
  101f0d:	74 65                	je     101f74 <acpi_probe_rsdt_ent+0x74>

    uint8_t *p = (uint8_t *) &rsdt->ent[0];
    uint8_t *e = (uint8_t *) rsdt + rsdt->length;
  101f0f:	8b 7b 04             	mov    0x4(%ebx),%edi
    uint8_t *p = (uint8_t *) &rsdt->ent[0];
  101f12:	8d 53 24             	lea    0x24(%ebx),%edx
    uint8_t *e = (uint8_t *) rsdt + rsdt->length;
  101f15:	01 df                	add    %ebx,%edi

    int i;
    for (i = 0; p < e; i++) {
  101f17:	39 d7                	cmp    %edx,%edi
  101f19:	76 4d                	jbe    101f68 <acpi_probe_rsdt_ent+0x68>
  101f1b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  101f1f:	8b 7c 24 34          	mov    0x34(%esp),%edi
  101f23:	eb 0c                	jmp    101f31 <acpi_probe_rsdt_ent+0x31>
  101f25:	8d 76 00             	lea    0x0(%esi),%esi
  101f28:	83 c2 04             	add    $0x4,%edx
  101f2b:	39 54 24 0c          	cmp    %edx,0xc(%esp)
  101f2f:	76 37                	jbe    101f68 <acpi_probe_rsdt_ent+0x68>
        acpi_sdt_hdr_t *hdr = (acpi_sdt_hdr_t *) (rsdt->ent[i]);
  101f31:	8b 02                	mov    (%edx),%eax
  101f33:	89 c5                	mov    %eax,%ebp
        if (hdr->sig == sig && sum((uint8_t *) hdr, hdr->length) == 0) {
  101f35:	39 38                	cmp    %edi,(%eax)
  101f37:	75 ef                	jne    101f28 <acpi_probe_rsdt_ent+0x28>
  101f39:	8b 70 04             	mov    0x4(%eax),%esi
    for (i = 0; i < len; i++) {
  101f3c:	85 f6                	test   %esi,%esi
  101f3e:	7e 18                	jle    101f58 <acpi_probe_rsdt_ent+0x58>
  101f40:	01 c6                	add    %eax,%esi
    sum = 0;
  101f42:	31 c9                	xor    %ecx,%ecx
  101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sum += addr[i];
  101f48:	0f b6 18             	movzbl (%eax),%ebx
  101f4b:	83 c0 01             	add    $0x1,%eax
  101f4e:	01 d9                	add    %ebx,%ecx
    for (i = 0; i < len; i++) {
  101f50:	39 c6                	cmp    %eax,%esi
  101f52:	75 f4                	jne    101f48 <acpi_probe_rsdt_ent+0x48>
        if (hdr->sig == sig && sum((uint8_t *) hdr, hdr->length) == 0) {
  101f54:	84 c9                	test   %cl,%cl
  101f56:	75 d0                	jne    101f28 <acpi_probe_rsdt_ent+0x28>
        }
        p = (uint8_t *) &rsdt->ent[i + 1];
    }

    return NULL;
}
  101f58:	83 c4 1c             	add    $0x1c,%esp
  101f5b:	89 e8                	mov    %ebp,%eax
  101f5d:	5b                   	pop    %ebx
  101f5e:	5e                   	pop    %esi
  101f5f:	5f                   	pop    %edi
  101f60:	5d                   	pop    %ebp
  101f61:	c3                   	ret    
  101f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101f68:	83 c4 1c             	add    $0x1c,%esp
    return NULL;
  101f6b:	31 ed                	xor    %ebp,%ebp
}
  101f6d:	5b                   	pop    %ebx
  101f6e:	89 e8                	mov    %ebp,%eax
  101f70:	5e                   	pop    %esi
  101f71:	5f                   	pop    %edi
  101f72:	5d                   	pop    %ebp
  101f73:	c3                   	ret    
    KERN_ASSERT(rsdt != NULL);
  101f74:	68 6b 95 10 00       	push   $0x10956b
  101f79:	68 df 92 10 00       	push   $0x1092df
  101f7e:	6a 41                	push   $0x41
  101f80:	68 5b 95 10 00       	push   $0x10955b
  101f85:	e8 c6 18 00 00       	call   103850 <debug_panic>
  101f8a:	83 c4 10             	add    $0x10,%esp
  101f8d:	eb 80                	jmp    101f0f <acpi_probe_rsdt_ent+0xf>
  101f8f:	90                   	nop

00101f90 <acpi_probe_xsdt>:

acpi_xsdt_t *acpi_probe_xsdt(acpi_rsdp_t *rsdp)
{
  101f90:	56                   	push   %esi
  101f91:	53                   	push   %ebx
  101f92:	83 ec 04             	sub    $0x4,%esp
  101f95:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    KERN_ASSERT(rsdp != NULL);
  101f99:	85 db                	test   %ebx,%ebx
  101f9b:	74 53                	je     101ff0 <acpi_probe_xsdt+0x60>

    acpi_xsdt_t *xsdt = (acpi_xsdt_t *) (uintptr_t) rsdp->xsdt_addr;
  101f9d:	8b 5b 18             	mov    0x18(%ebx),%ebx
  101fa0:	89 d8                	mov    %ebx,%eax
    if (xsdt == NULL)
  101fa2:	85 db                	test   %ebx,%ebx
  101fa4:	74 30                	je     101fd6 <acpi_probe_xsdt+0x46>
        return NULL;
    if (xsdt->sig == ACPI_XSDT_SIG && sum((uint8_t *) xsdt, xsdt->length) == 0) {
  101fa6:	81 3b 58 53 44 54    	cmpl   $0x54445358,(%ebx)
  101fac:	75 32                	jne    101fe0 <acpi_probe_xsdt+0x50>
  101fae:	8b 73 04             	mov    0x4(%ebx),%esi
    for (i = 0; i < len; i++) {
  101fb1:	85 f6                	test   %esi,%esi
  101fb3:	7e 21                	jle    101fd6 <acpi_probe_xsdt+0x46>
  101fb5:	01 de                	add    %ebx,%esi
    sum = 0;
  101fb7:	31 d2                	xor    %edx,%edx
  101fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        sum += addr[i];
  101fc0:	0f b6 08             	movzbl (%eax),%ecx
  101fc3:	83 c0 01             	add    $0x1,%eax
  101fc6:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++) {
  101fc8:	39 c6                	cmp    %eax,%esi
  101fca:	75 f4                	jne    101fc0 <acpi_probe_xsdt+0x30>
        return NULL;
  101fcc:	84 d2                	test   %dl,%dl
  101fce:	b8 00 00 00 00       	mov    $0x0,%eax
  101fd3:	0f 45 d8             	cmovne %eax,%ebx
        return xsdt;
    }

    return NULL;
}
  101fd6:	83 c4 04             	add    $0x4,%esp
  101fd9:	89 d8                	mov    %ebx,%eax
  101fdb:	5b                   	pop    %ebx
  101fdc:	5e                   	pop    %esi
  101fdd:	c3                   	ret    
  101fde:	66 90                	xchg   %ax,%ax
        return NULL;
  101fe0:	31 db                	xor    %ebx,%ebx
}
  101fe2:	83 c4 04             	add    $0x4,%esp
  101fe5:	89 d8                	mov    %ebx,%eax
  101fe7:	5b                   	pop    %ebx
  101fe8:	5e                   	pop    %esi
  101fe9:	c3                   	ret    
  101fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    KERN_ASSERT(rsdp != NULL);
  101ff0:	68 4e 95 10 00       	push   $0x10954e
  101ff5:	68 df 92 10 00       	push   $0x1092df
  101ffa:	6a 54                	push   $0x54
  101ffc:	68 5b 95 10 00       	push   $0x10955b
  102001:	e8 4a 18 00 00       	call   103850 <debug_panic>
  102006:	83 c4 10             	add    $0x10,%esp
  102009:	eb 92                	jmp    101f9d <acpi_probe_xsdt+0xd>
  10200b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10200f:	90                   	nop

00102010 <acpi_probe_xsdt_ent>:

acpi_sdt_hdr_t *acpi_probe_xsdt_ent(acpi_xsdt_t *xsdt, const uint32_t sig)
{
  102010:	55                   	push   %ebp
  102011:	57                   	push   %edi
  102012:	56                   	push   %esi
  102013:	53                   	push   %ebx
  102014:	83 ec 1c             	sub    $0x1c,%esp
  102017:	8b 5c 24 30          	mov    0x30(%esp),%ebx
    KERN_ASSERT(xsdt != NULL);
  10201b:	85 db                	test   %ebx,%ebx
  10201d:	74 65                	je     102084 <acpi_probe_xsdt_ent+0x74>

    uint8_t *p = (uint8_t *) &xsdt->ent[0];
    uint8_t *e = (uint8_t *) xsdt + xsdt->length;
  10201f:	8b 7b 04             	mov    0x4(%ebx),%edi
    uint8_t *p = (uint8_t *) &xsdt->ent[0];
  102022:	8d 53 24             	lea    0x24(%ebx),%edx
    uint8_t *e = (uint8_t *) xsdt + xsdt->length;
  102025:	01 df                	add    %ebx,%edi

    int i;
    for (i = 0; p < e; i++) {
  102027:	39 d7                	cmp    %edx,%edi
  102029:	76 4d                	jbe    102078 <acpi_probe_xsdt_ent+0x68>
  10202b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  10202f:	8b 7c 24 34          	mov    0x34(%esp),%edi
  102033:	eb 0c                	jmp    102041 <acpi_probe_xsdt_ent+0x31>
  102035:	8d 76 00             	lea    0x0(%esi),%esi
  102038:	83 c2 08             	add    $0x8,%edx
  10203b:	39 54 24 0c          	cmp    %edx,0xc(%esp)
  10203f:	76 37                	jbe    102078 <acpi_probe_xsdt_ent+0x68>
        acpi_sdt_hdr_t *hdr = (acpi_sdt_hdr_t *) (uintptr_t) xsdt->ent[i];
  102041:	8b 02                	mov    (%edx),%eax
  102043:	89 c5                	mov    %eax,%ebp
        if (hdr->sig == sig && sum((uint8_t *) hdr, hdr->length) == 0) {
  102045:	39 38                	cmp    %edi,(%eax)
  102047:	75 ef                	jne    102038 <acpi_probe_xsdt_ent+0x28>
  102049:	8b 70 04             	mov    0x4(%eax),%esi
    for (i = 0; i < len; i++) {
  10204c:	85 f6                	test   %esi,%esi
  10204e:	7e 18                	jle    102068 <acpi_probe_xsdt_ent+0x58>
  102050:	01 c6                	add    %eax,%esi
    sum = 0;
  102052:	31 c9                	xor    %ecx,%ecx
  102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sum += addr[i];
  102058:	0f b6 18             	movzbl (%eax),%ebx
  10205b:	83 c0 01             	add    $0x1,%eax
  10205e:	01 d9                	add    %ebx,%ecx
    for (i = 0; i < len; i++) {
  102060:	39 c6                	cmp    %eax,%esi
  102062:	75 f4                	jne    102058 <acpi_probe_xsdt_ent+0x48>
        if (hdr->sig == sig && sum((uint8_t *) hdr, hdr->length) == 0) {
  102064:	84 c9                	test   %cl,%cl
  102066:	75 d0                	jne    102038 <acpi_probe_xsdt_ent+0x28>
        }
        p = (uint8_t *) &xsdt->ent[i + 1];
    }

    return NULL;
}
  102068:	83 c4 1c             	add    $0x1c,%esp
  10206b:	89 e8                	mov    %ebp,%eax
  10206d:	5b                   	pop    %ebx
  10206e:	5e                   	pop    %esi
  10206f:	5f                   	pop    %edi
  102070:	5d                   	pop    %ebp
  102071:	c3                   	ret    
  102072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102078:	83 c4 1c             	add    $0x1c,%esp
    return NULL;
  10207b:	31 ed                	xor    %ebp,%ebp
}
  10207d:	5b                   	pop    %ebx
  10207e:	89 e8                	mov    %ebp,%eax
  102080:	5e                   	pop    %esi
  102081:	5f                   	pop    %edi
  102082:	5d                   	pop    %ebp
  102083:	c3                   	ret    
    KERN_ASSERT(xsdt != NULL);
  102084:	68 78 95 10 00       	push   $0x109578
  102089:	68 df 92 10 00       	push   $0x1092df
  10208e:	6a 62                	push   $0x62
  102090:	68 5b 95 10 00       	push   $0x10955b
  102095:	e8 b6 17 00 00       	call   103850 <debug_panic>
  10209a:	83 c4 10             	add    $0x10,%esp
  10209d:	eb 80                	jmp    10201f <acpi_probe_xsdt_ent+0xf>
  10209f:	90                   	nop

001020a0 <lapic_register>:
{
}

void lapic_register(uintptr_t lapic_addr)
{
    lapic = (lapic_t *) lapic_addr;
  1020a0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1020a4:	a3 08 d8 9d 00       	mov    %eax,0x9dd808
}
  1020a9:	c3                   	ret    
  1020aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001020b0 <lapic_init>:

/*
 * Initialize local APIC.
 */
void lapic_init()
{
  1020b0:	55                   	push   %ebp
  1020b1:	57                   	push   %edi
  1020b2:	56                   	push   %esi
  1020b3:	53                   	push   %ebx
  1020b4:	83 ec 1c             	sub    $0x1c,%esp
    if (!lapic)
  1020b7:	a1 08 d8 9d 00       	mov    0x9dd808,%eax
  1020bc:	85 c0                	test   %eax,%eax
  1020be:	0f 84 8c 02 00 00    	je     102350 <lapic_init+0x2a0>
     * Calibrate the internal timer of LAPIC using TSC.
     * XXX: TSC should be already calibrated before here.
     */
    uint32_t lapic_ticks_per_ms;
    int i;
    for (i = 0; i < 5; i++) {
  1020c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1020cb:	00 
    lapic[index] = value;
  1020cc:	c7 80 f0 00 00 00 27 	movl   $0x127,0xf0(%eax)
  1020d3:	01 00 00 
    lapic[LAPIC_ID];
  1020d6:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  1020d9:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  1020e0:	00 00 00 
    lapic[LAPIC_ID];
  1020e3:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  1020e6:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  1020ed:	00 02 00 
    lapic[LAPIC_ID];
  1020f0:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  1020f3:	c7 80 80 03 00 00 ff 	movl   $0xffffffff,0x380(%eax)
  1020fa:	ff ff ff 
    outb(0x61, (inb(0x61) & ~0x02) | 0x01);
  1020fd:	83 ec 0c             	sub    $0xc,%esp
    lapic[LAPIC_ID];
  102100:	8b 40 20             	mov    0x20(%eax),%eax
    outb(0x61, (inb(0x61) & ~0x02) | 0x01);
  102103:	6a 61                	push   $0x61
  102105:	e8 56 24 00 00       	call   104560 <inb>
  10210a:	5a                   	pop    %edx
  10210b:	59                   	pop    %ecx
  10210c:	25 fc 00 00 00       	and    $0xfc,%eax
  102111:	83 c8 01             	or     $0x1,%eax
  102114:	50                   	push   %eax
  102115:	6a 61                	push   $0x61
  102117:	e8 74 24 00 00       	call   104590 <outb>
    outb(0x43, 0xb0);
  10211c:	5b                   	pop    %ebx
  10211d:	5e                   	pop    %esi
  10211e:	68 b0 00 00 00       	push   $0xb0
  102123:	6a 43                	push   $0x43
    timermax = 0;
  102125:	31 f6                	xor    %esi,%esi
    outb(0x43, 0xb0);
  102127:	e8 64 24 00 00       	call   104590 <outb>
    outb(0x42, latch & 0xff);
  10212c:	5f                   	pop    %edi
  10212d:	5d                   	pop    %ebp
  10212e:	68 9b 00 00 00       	push   $0x9b
  102133:	6a 42                	push   $0x42
    pitcnt = 0;
  102135:	31 ed                	xor    %ebp,%ebp
    timermin = ~(uint32_t) 0x0;
  102137:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    outb(0x42, latch & 0xff);
  10213c:	e8 4f 24 00 00       	call   104590 <outb>
    outb(0x42, latch >> 8);
  102141:	58                   	pop    %eax
  102142:	5a                   	pop    %edx
  102143:	6a 2e                	push   $0x2e
  102145:	6a 42                	push   $0x42
  102147:	e8 44 24 00 00       	call   104590 <outb>
    return lapic[index];
  10214c:	a1 08 d8 9d 00       	mov    0x9dd808,%eax
  102151:	8b 80 90 03 00 00    	mov    0x390(%eax),%eax
  102157:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  10215b:	89 c3                	mov    %eax,%ebx
    while ((inb(0x61) & 0x20) == 0) {
  10215d:	83 c4 10             	add    $0x10,%esp
  102160:	eb 22                	jmp    102184 <lapic_init+0xd4>
  102162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return lapic[index];
  102168:	a1 08 d8 9d 00       	mov    0x9dd808,%eax
  10216d:	8b 80 90 03 00 00    	mov    0x390(%eax),%eax
        delta = timer - timer2;
  102173:	29 c3                	sub    %eax,%ebx
        if (delta < timermin)
  102175:	39 df                	cmp    %ebx,%edi
  102177:	0f 47 fb             	cmova  %ebx,%edi
        if (delta > timermax)
  10217a:	39 de                	cmp    %ebx,%esi
  10217c:	0f 42 f3             	cmovb  %ebx,%esi
        pitcnt++;
  10217f:	83 c5 01             	add    $0x1,%ebp
        timer = timer2;
  102182:	89 c3                	mov    %eax,%ebx
    while ((inb(0x61) & 0x20) == 0) {
  102184:	83 ec 0c             	sub    $0xc,%esp
  102187:	6a 61                	push   $0x61
  102189:	e8 d2 23 00 00       	call   104560 <inb>
  10218e:	83 c4 10             	add    $0x10,%esp
  102191:	a8 20                	test   $0x20,%al
  102193:	74 d3                	je     102168 <lapic_init+0xb8>
    if (pitcnt < loopmin || timermax > 10 * timermin)
  102195:	81 fd e7 03 00 00    	cmp    $0x3e7,%ebp
  10219b:	0f 8e 3f 01 00 00    	jle    1022e0 <lapic_init+0x230>
  1021a1:	8d 04 bf             	lea    (%edi,%edi,4),%eax
  1021a4:	01 c0                	add    %eax,%eax
  1021a6:	39 c6                	cmp    %eax,%esi
  1021a8:	0f 87 32 01 00 00    	ja     1022e0 <lapic_init+0x230>
    delta = timer1 - timer2;
  1021ae:	8b 74 24 0c          	mov    0xc(%esp),%esi
    return delta / ms;
  1021b2:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    if (lapic_ticks_per_ms == ~(uint32_t) 0x0) {
        KERN_WARN("Failed to calibrate internal timer of LAPIC.\n");
        KERN_DEBUG("Assume LAPIC timer freq = 0.5 GHz.\n");
        lapic_ticks_per_ms = 500000;
    } else
        KERN_DEBUG("LAPIC timer freq = %llu Hz.\n",
  1021b7:	83 ec 0c             	sub    $0xc,%esp
    delta = timer1 - timer2;
  1021ba:	29 de                	sub    %ebx,%esi
    return delta / ms;
  1021bc:	89 f0                	mov    %esi,%eax
  1021be:	f7 e2                	mul    %edx
        KERN_DEBUG("LAPIC timer freq = %llu Hz.\n",
  1021c0:	b8 e8 03 00 00       	mov    $0x3e8,%eax
    return delta / ms;
  1021c5:	89 d6                	mov    %edx,%esi
  1021c7:	c1 ee 03             	shr    $0x3,%esi
        KERN_DEBUG("LAPIC timer freq = %llu Hz.\n",
  1021ca:	f7 e6                	mul    %esi
  1021cc:	52                   	push   %edx
  1021cd:	50                   	push   %eax
  1021ce:	68 9f 95 10 00       	push   $0x10959f
  1021d3:	6a 7d                	push   $0x7d
  1021d5:	68 8e 95 10 00       	push   $0x10958e
  1021da:	e8 21 16 00 00       	call   103800 <debug_normal>
  1021df:	69 d6 e8 03 00 00    	imul   $0x3e8,%esi,%edx
  1021e5:	be d3 4d 62 10       	mov    $0x10624dd3,%esi
  1021ea:	83 c4 20             	add    $0x20,%esp
  1021ed:	89 d0                	mov    %edx,%eax
  1021ef:	f7 e6                	mul    %esi
  1021f1:	c1 ea 06             	shr    $0x6,%edx
  1021f4:	89 d6                	mov    %edx,%esi
                   (uint64_t) lapic_ticks_per_ms * 1000);

    uint32_t ticr = lapic_ticks_per_ms * 1000 / LAPIC_TIMER_INTR_FREQ;
    KERN_DEBUG("Set LAPIC TICR = %x.\n", ticr);
  1021f6:	56                   	push   %esi
  1021f7:	68 bc 95 10 00       	push   $0x1095bc
  1021fc:	68 81 00 00 00       	push   $0x81
  102201:	68 8e 95 10 00       	push   $0x10958e
  102206:	e8 f5 15 00 00       	call   103800 <debug_normal>
    lapic[index] = value;
  10220b:	a1 08 d8 9d 00       	mov    0x9dd808,%eax
    lapic_write(LAPIC_LINT0, LAPIC_LINT_MASKED);
    lapic_write(LAPIC_LINT1, LAPIC_LINT_MASKED);

    // Disable performance counter overflow interrupts
    // on machines that provide that interrupt entry.
    if (((lapic_read(LAPIC_VER) >> 16) & 0xFF) >= 4)
  102210:	83 c4 10             	add    $0x10,%esp
    lapic[index] = value;
  102213:	89 b0 80 03 00 00    	mov    %esi,0x380(%eax)
    lapic[LAPIC_ID];
  102219:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  10221c:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  102223:	00 01 00 
    lapic[LAPIC_ID];
  102226:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102229:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  102230:	00 01 00 
    lapic[LAPIC_ID];
  102233:	8b 50 20             	mov    0x20(%eax),%edx
    return lapic[index];
  102236:	8b 50 30             	mov    0x30(%eax),%edx
    if (((lapic_read(LAPIC_VER) >> 16) & 0xFF) >= 4)
  102239:	c1 ea 10             	shr    $0x10,%edx
  10223c:	81 e2 fc 00 00 00    	and    $0xfc,%edx
  102242:	74 0d                	je     102251 <lapic_init+0x1a1>
    lapic[index] = value;
  102244:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  10224b:	00 01 00 
    lapic[LAPIC_ID];
  10224e:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102251:	c7 80 e0 00 00 00 00 	movl   $0xf0000000,0xe0(%eax)
  102258:	00 00 f0 
    lapic[LAPIC_ID];
  10225b:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  10225e:	c7 80 d0 00 00 00 00 	movl   $0x0,0xd0(%eax)
  102265:	00 00 00 
    lapic[LAPIC_ID];
  102268:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  10226b:	c7 80 70 03 00 00 32 	movl   $0x32,0x370(%eax)
  102272:	00 00 00 
    lapic[LAPIC_ID];
  102275:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102278:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  10227f:	00 00 00 
    lapic[LAPIC_ID];
  102282:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102285:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  10228c:	00 00 00 
    lapic[LAPIC_ID];
  10228f:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102292:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102299:	00 00 00 
    lapic[LAPIC_ID];
  10229c:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  10229f:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  1022a6:	00 00 00 
    lapic[LAPIC_ID];
  1022a9:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  1022ac:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  1022b3:	85 08 00 
    lapic[LAPIC_ID];
  1022b6:	8b 50 20             	mov    0x20(%eax),%edx
  1022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return lapic[index];
  1022c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx

    // Send an Init Level De-Assert to synchronise arbitration ID's.
    lapic_write(LAPIC_ICRHI, 0);
    lapic_write(LAPIC_ICRLO,
                LAPIC_ICRLO_BCAST | LAPIC_ICRLO_INIT | LAPIC_ICRLO_LEVEL);
    while (lapic_read(LAPIC_ICRLO) & LAPIC_ICRLO_DELIVS);
  1022c6:	80 e6 10             	and    $0x10,%dh
  1022c9:	75 f5                	jne    1022c0 <lapic_init+0x210>
    lapic[index] = value;
  1022cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  1022d2:	00 00 00 
    lapic[LAPIC_ID];
  1022d5:	8b 40 20             	mov    0x20(%eax),%eax

    // Enable interrupts on the APIC (but not on the processor).
    lapic_write(LAPIC_TPR, 0);
}
  1022d8:	83 c4 1c             	add    $0x1c,%esp
  1022db:	5b                   	pop    %ebx
  1022dc:	5e                   	pop    %esi
  1022dd:	5f                   	pop    %edi
  1022de:	5d                   	pop    %ebp
  1022df:	c3                   	ret    
        KERN_DEBUG("[%d] Retry to calibrate internal timer of LAPIC.\n", i);
  1022e0:	8b 7c 24 08          	mov    0x8(%esp),%edi
  1022e4:	57                   	push   %edi
  1022e5:	68 e4 95 10 00       	push   $0x1095e4
  1022ea:	6a 75                	push   $0x75
  1022ec:	68 8e 95 10 00       	push   $0x10958e
  1022f1:	e8 0a 15 00 00       	call   103800 <debug_normal>
    for (i = 0; i < 5; i++) {
  1022f6:	89 f8                	mov    %edi,%eax
  1022f8:	83 c0 01             	add    $0x1,%eax
  1022fb:	89 44 24 18          	mov    %eax,0x18(%esp)
  1022ff:	83 c4 10             	add    $0x10,%esp
  102302:	83 f8 05             	cmp    $0x5,%eax
  102305:	74 11                	je     102318 <lapic_init+0x268>
  102307:	a1 08 d8 9d 00       	mov    0x9dd808,%eax
  10230c:	e9 e2 fd ff ff       	jmp    1020f3 <lapic_init+0x43>
  102311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        KERN_WARN("Failed to calibrate internal timer of LAPIC.\n");
  102318:	83 ec 04             	sub    $0x4,%esp
  10231b:	be 20 a1 07 00       	mov    $0x7a120,%esi
  102320:	68 18 96 10 00       	push   $0x109618
  102325:	6a 79                	push   $0x79
  102327:	68 8e 95 10 00       	push   $0x10958e
  10232c:	e8 ef 15 00 00       	call   103920 <debug_warn>
        KERN_DEBUG("Assume LAPIC timer freq = 0.5 GHz.\n");
  102331:	83 c4 0c             	add    $0xc,%esp
  102334:	68 48 96 10 00       	push   $0x109648
  102339:	6a 7a                	push   $0x7a
  10233b:	68 8e 95 10 00       	push   $0x10958e
  102340:	e8 bb 14 00 00       	call   103800 <debug_normal>
        lapic_ticks_per_ms = 500000;
  102345:	83 c4 10             	add    $0x10,%esp
  102348:	e9 a9 fe ff ff       	jmp    1021f6 <lapic_init+0x146>
  10234d:	8d 76 00             	lea    0x0(%esi),%esi
        KERN_PANIC("NO LAPIC");
  102350:	83 ec 04             	sub    $0x4,%esp
  102353:	68 85 95 10 00       	push   $0x109585
  102358:	6a 62                	push   $0x62
  10235a:	68 8e 95 10 00       	push   $0x10958e
  10235f:	e8 ec 14 00 00       	call   103850 <debug_panic>
  102364:	a1 08 d8 9d 00       	mov    0x9dd808,%eax
  102369:	83 c4 10             	add    $0x10,%esp
  10236c:	e9 53 fd ff ff       	jmp    1020c4 <lapic_init+0x14>
  102371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10237f:	90                   	nop

00102380 <lapic_eoi>:
/*
 * Acknowledge the end of interrupts.
 */
void lapic_eoi(void)
{
    if (lapic)
  102380:	a1 08 d8 9d 00       	mov    0x9dd808,%eax
  102385:	85 c0                	test   %eax,%eax
  102387:	74 0d                	je     102396 <lapic_eoi+0x16>
    lapic[index] = value;
  102389:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102390:	00 00 00 
    lapic[LAPIC_ID];
  102393:	8b 40 20             	mov    0x20(%eax),%eax
        lapic_write(LAPIC_EOI, 0);
}
  102396:	c3                   	ret    
  102397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10239e:	66 90                	xchg   %ax,%ax

001023a0 <lapic_startcpu>:
/*
 * Start additional processor running bootstrap code at addr.
 * See Appendix B of MultiProcessor Specification.
 */
void lapic_startcpu(lapicid_t apicid, uintptr_t addr)
{
  1023a0:	56                   	push   %esi
  1023a1:	53                   	push   %ebx
  1023a2:	83 ec 0c             	sub    $0xc,%esp
  1023a5:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
  1023a9:	8b 74 24 18          	mov    0x18(%esp),%esi
    uint16_t *wrv;

    // "The BSP must initialize CMOS shutdown code to 0AH
    // and the warm reset vector (DWORD based at 40:67) to point at
    // the AP startup code prior to the [universal startup algorithm]."
    outb(IO_RTC, 0xF);                      // offset 0xF is shutdown code
  1023ad:	6a 0f                	push   $0xf
  1023af:	6a 70                	push   $0x70
    wrv[0] = 0;
    wrv[1] = addr >> 4;

    // "Universal startup algorithm."
    // Send INIT (level-triggered) interrupt to reset other CPU.
    lapic_write(LAPIC_ICRHI, apicid << 24);
  1023b1:	c1 e6 18             	shl    $0x18,%esi
    outb(IO_RTC, 0xF);                      // offset 0xF is shutdown code
  1023b4:	e8 d7 21 00 00       	call   104590 <outb>
    outb(IO_RTC + 1, 0x0A);
  1023b9:	58                   	pop    %eax
  1023ba:	5a                   	pop    %edx
  1023bb:	6a 0a                	push   $0xa
  1023bd:	6a 71                	push   $0x71
  1023bf:	e8 cc 21 00 00       	call   104590 <outb>
    wrv[1] = addr >> 4;
  1023c4:	89 d8                	mov    %ebx,%eax
    wrv[0] = 0;
  1023c6:	31 c9                	xor    %ecx,%ecx
    // when it is in the halted state due to an INIT. So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one. Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapic_write(LAPIC_ICRHI, apicid << 24);
        lapic_write(LAPIC_ICRLO, LAPIC_ICRLO_STARTUP | (addr >> 12));
  1023c8:	c1 eb 0c             	shr    $0xc,%ebx
    wrv[1] = addr >> 4;
  1023cb:	c1 e8 04             	shr    $0x4,%eax
    wrv[0] = 0;
  1023ce:	66 89 0d 67 04 00 00 	mov    %cx,0x467
        lapic_write(LAPIC_ICRLO, LAPIC_ICRLO_STARTUP | (addr >> 12));
  1023d5:	80 cf 06             	or     $0x6,%bh
    wrv[1] = addr >> 4;
  1023d8:	66 a3 69 04 00 00    	mov    %ax,0x469
    lapic[index] = value;
  1023de:	a1 08 d8 9d 00       	mov    0x9dd808,%eax
  1023e3:	89 b0 10 03 00 00    	mov    %esi,0x310(%eax)
    lapic[LAPIC_ID];
  1023e9:	8b 48 20             	mov    0x20(%eax),%ecx
    lapic[index] = value;
  1023ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
  1023f3:	c5 00 00 
    lapic[LAPIC_ID];
  1023f6:	8b 48 20             	mov    0x20(%eax),%ecx
    lapic[index] = value;
  1023f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
  102400:	85 00 00 
    lapic[LAPIC_ID];
  102403:	8b 48 20             	mov    0x20(%eax),%ecx
    lapic[index] = value;
  102406:	89 b0 10 03 00 00    	mov    %esi,0x310(%eax)
    lapic[LAPIC_ID];
  10240c:	8b 48 20             	mov    0x20(%eax),%ecx
    lapic[index] = value;
  10240f:	89 98 00 03 00 00    	mov    %ebx,0x300(%eax)
    lapic[LAPIC_ID];
  102415:	8b 48 20             	mov    0x20(%eax),%ecx
    lapic[index] = value;
  102418:	89 b0 10 03 00 00    	mov    %esi,0x310(%eax)
    lapic[LAPIC_ID];
  10241e:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
  102421:	89 98 00 03 00 00    	mov    %ebx,0x300(%eax)
    lapic[LAPIC_ID];
  102427:	8b 40 20             	mov    0x20(%eax),%eax
        microdelay(200);
    }
}
  10242a:	83 c4 14             	add    $0x14,%esp
  10242d:	5b                   	pop    %ebx
  10242e:	5e                   	pop    %esi
  10242f:	c3                   	ret    

00102430 <lapic_read_debug>:
    return lapic[index];
  102430:	8b 54 24 04          	mov    0x4(%esp),%edx
  102434:	a1 08 d8 9d 00       	mov    0x9dd808,%eax
  102439:	8d 04 90             	lea    (%eax,%edx,4),%eax
  10243c:	8b 00                	mov    (%eax),%eax

uint32_t lapic_read_debug(int index)
{
    return lapic_read(index);
}
  10243e:	c3                   	ret    
  10243f:	90                   	nop

00102440 <lapic_send_ipi>:
/*
 * Send an IPI.
 */
void lapic_send_ipi(lapicid_t apicid, uint8_t vector,
                    uint32_t deliver_mode, uint32_t shorthand_mode)
{
  102440:	55                   	push   %ebp
  102441:	57                   	push   %edi
  102442:	56                   	push   %esi
  102443:	53                   	push   %ebx
  102444:	83 ec 0c             	sub    $0xc,%esp
  102447:	8b 74 24 28          	mov    0x28(%esp),%esi
  10244b:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  10244f:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  102453:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
    KERN_ASSERT(deliver_mode != LAPIC_ICRLO_INIT &&
  102457:	8d 86 00 fb ff ff    	lea    -0x500(%esi),%eax
  10245d:	a9 ff fe ff ff       	test   $0xfffffeff,%eax
  102462:	74 4c                	je     1024b0 <lapic_send_ipi+0x70>
                deliver_mode != LAPIC_ICRLO_STARTUP);
    KERN_ASSERT(vector >= T_IPI0);
  102464:	80 fb 3e             	cmp    $0x3e,%bl
  102467:	77 0c                	ja     102475 <lapic_send_ipi+0x35>
  102469:	eb 66                	jmp    1024d1 <lapic_send_ipi+0x91>
  10246b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10246f:	90                   	nop

    while (lapic_read(LAPIC_ICRLO) & LAPIC_ICRLO_DELIVS)
        pause();
  102470:	e8 4b 1f 00 00       	call   1043c0 <pause>
    return lapic[index];
  102475:	a1 08 d8 9d 00       	mov    0x9dd808,%eax
  10247a:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
    while (lapic_read(LAPIC_ICRLO) & LAPIC_ICRLO_DELIVS)
  102480:	80 e6 10             	and    $0x10,%dh
  102483:	75 eb                	jne    102470 <lapic_send_ipi+0x30>

    if (shorthand_mode == LAPIC_ICRLO_NOBCAST)
  102485:	85 ff                	test   %edi,%edi
  102487:	75 0c                	jne    102495 <lapic_send_ipi+0x55>
        lapic_write(LAPIC_ICRHI,
  102489:	c1 e5 18             	shl    $0x18,%ebp
    lapic[index] = value;
  10248c:	89 a8 10 03 00 00    	mov    %ebp,0x310(%eax)
    lapic[LAPIC_ID];
  102492:	8b 50 20             	mov    0x20(%eax),%edx
                    (apicid << LAPIC_ICRHI_DEST_SHIFT) & LAPIC_ICRHI_DEST_MASK);

    lapic_write(LAPIC_ICRLO,
                shorthand_mode |  /* LAPIC_ICRLO_LEVEL | */
                deliver_mode | (vector & LAPIC_ICRLO_VECTOR));
  102495:	0f b6 db             	movzbl %bl,%ebx
  102498:	09 df                	or     %ebx,%edi
  10249a:	09 fe                	or     %edi,%esi
    lapic[index] = value;
  10249c:	89 b0 00 03 00 00    	mov    %esi,0x300(%eax)
    lapic[LAPIC_ID];
  1024a2:	8b 40 20             	mov    0x20(%eax),%eax
}
  1024a5:	83 c4 0c             	add    $0xc,%esp
  1024a8:	5b                   	pop    %ebx
  1024a9:	5e                   	pop    %esi
  1024aa:	5f                   	pop    %edi
  1024ab:	5d                   	pop    %ebp
  1024ac:	c3                   	ret    
  1024ad:	8d 76 00             	lea    0x0(%esi),%esi
    KERN_ASSERT(deliver_mode != LAPIC_ICRLO_INIT &&
  1024b0:	68 6c 96 10 00       	push   $0x10966c
  1024b5:	68 df 92 10 00       	push   $0x1092df
  1024ba:	68 e4 00 00 00       	push   $0xe4
  1024bf:	68 8e 95 10 00       	push   $0x10958e
  1024c4:	e8 87 13 00 00       	call   103850 <debug_panic>
  1024c9:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(vector >= T_IPI0);
  1024cc:	80 fb 3e             	cmp    $0x3e,%bl
  1024cf:	77 a4                	ja     102475 <lapic_send_ipi+0x35>
  1024d1:	68 d2 95 10 00       	push   $0x1095d2
  1024d6:	68 df 92 10 00       	push   $0x1092df
  1024db:	68 e6 00 00 00       	push   $0xe6
  1024e0:	68 8e 95 10 00       	push   $0x10958e
  1024e5:	e8 66 13 00 00       	call   103850 <debug_panic>
  1024ea:	83 c4 10             	add    $0x10,%esp
    return lapic[index];
  1024ed:	eb 86                	jmp    102475 <lapic_send_ipi+0x35>
  1024ef:	90                   	nop

001024f0 <ioapic_register>:
    base->reg = reg;
    base->data = data;
}

void ioapic_register(uintptr_t addr, lapicid_t id, int g)
{
  1024f0:	83 ec 0c             	sub    $0xc,%esp
    if (ioapic_num >= MAX_IOAPIC) {
  1024f3:	a1 64 ce 14 00       	mov    0x14ce64,%eax
{
  1024f8:	8b 54 24 14          	mov    0x14(%esp),%edx
    if (ioapic_num >= MAX_IOAPIC) {
  1024fc:	83 f8 0f             	cmp    $0xf,%eax
  1024ff:	7f 3f                	jg     102540 <ioapic_register+0x50>
        KERN_WARN("CertiKOS cannot manipulate more than %d IOAPICs.\n", MAX_IOAPIC);
        return;
    }

    ioapics[ioapic_num] = (ioapic_t *) addr;
  102501:	a1 64 ce 14 00       	mov    0x14ce64,%eax
  102506:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  10250a:	89 0c 85 80 d8 9d 00 	mov    %ecx,0x9dd880(,%eax,4)
    ioapicid[ioapic_num] = id;
  102511:	a1 64 ce 14 00       	mov    0x14ce64,%eax
  102516:	88 90 20 d8 9d 00    	mov    %dl,0x9dd820(%eax)
    gsi[ioapic_num] = g;
  10251c:	8b 54 24 18          	mov    0x18(%esp),%edx
  102520:	a1 64 ce 14 00       	mov    0x14ce64,%eax
  102525:	89 14 85 40 d8 9d 00 	mov    %edx,0x9dd840(,%eax,4)

    ioapic_num++;
  10252c:	a1 64 ce 14 00       	mov    0x14ce64,%eax
  102531:	83 c0 01             	add    $0x1,%eax
  102534:	a3 64 ce 14 00       	mov    %eax,0x14ce64
}
  102539:	83 c4 0c             	add    $0xc,%esp
  10253c:	c3                   	ret    
  10253d:	8d 76 00             	lea    0x0(%esi),%esi
        KERN_WARN("CertiKOS cannot manipulate more than %d IOAPICs.\n", MAX_IOAPIC);
  102540:	6a 10                	push   $0x10
  102542:	68 b4 96 10 00       	push   $0x1096b4
  102547:	6a 1f                	push   $0x1f
  102549:	68 2d 97 10 00       	push   $0x10972d
  10254e:	e8 cd 13 00 00       	call   103920 <debug_warn>
        return;
  102553:	83 c4 10             	add    $0x10,%esp
}
  102556:	83 c4 0c             	add    $0xc,%esp
  102559:	c3                   	ret    
  10255a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102560 <ioapic_init>:

void ioapic_init(void)
{
    int i;
    for (i = 0; i < ioapic_num; i++) {
  102560:	a1 64 ce 14 00       	mov    0x14ce64,%eax
  102565:	85 c0                	test   %eax,%eax
  102567:	0f 8e f1 00 00 00    	jle    10265e <ioapic_init+0xfe>
{
  10256d:	55                   	push   %ebp
  10256e:	57                   	push   %edi
    for (i = 0; i < ioapic_num; i++) {
  10256f:	31 ff                	xor    %edi,%edi
{
  102571:	56                   	push   %esi
  102572:	53                   	push   %ebx
  102573:	83 ec 0c             	sub    $0xc,%esp
  102576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10257d:	8d 76 00             	lea    0x0(%esi),%esi
        volatile ioapic_t *ioapic = ioapics[i];
  102580:	8b 1c bd 80 d8 9d 00 	mov    0x9dd880(,%edi,4),%ebx
        KERN_ASSERT(ioapic != NULL);
  102587:	85 db                	test   %ebx,%ebx
  102589:	0f 84 b1 00 00 00    	je     102640 <ioapic_init+0xe0>
    base->reg = reg;
  10258f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    return base->data;
  102595:	8b 43 10             	mov    0x10(%ebx),%eax

        lapicid_t id = ioapic_read(ioapic, IOAPIC_ID) >> 24;
        if (id == 0) {
  102598:	c1 e8 18             	shr    $0x18,%eax
  10259b:	75 1a                	jne    1025b7 <ioapic_init+0x57>
            // I/O APIC ID not initialized yet - have to do it ourselves.
            ioapic_write(ioapic, IOAPIC_ID, ioapicid[i] << 24);
  10259d:	0f b6 87 20 d8 9d 00 	movzbl 0x9dd820(%edi),%eax
    base->reg = reg;
  1025a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
            ioapic_write(ioapic, IOAPIC_ID, ioapicid[i] << 24);
  1025aa:	c1 e0 18             	shl    $0x18,%eax
    base->data = data;
  1025ad:	89 43 10             	mov    %eax,0x10(%ebx)
            id = ioapicid[i];
  1025b0:	0f b6 87 20 d8 9d 00 	movzbl 0x9dd820(%edi),%eax
        }

        if (id != ioapicid[i])
  1025b7:	0f b6 97 20 d8 9d 00 	movzbl 0x9dd820(%edi),%edx
  1025be:	38 c2                	cmp    %al,%dl
  1025c0:	74 23                	je     1025e5 <ioapic_init+0x85>
            KERN_WARN("ioapic_init: id %d != ioapicid %d\n", id, ioapicid[i]);
  1025c2:	0f b6 97 20 d8 9d 00 	movzbl 0x9dd820(%edi),%edx
  1025c9:	83 ec 0c             	sub    $0xc,%esp
  1025cc:	0f b6 c0             	movzbl %al,%eax
  1025cf:	52                   	push   %edx
  1025d0:	50                   	push   %eax
  1025d1:	68 e8 96 10 00       	push   $0x1096e8
  1025d6:	6a 39                	push   $0x39
  1025d8:	68 2d 97 10 00       	push   $0x10972d
  1025dd:	e8 3e 13 00 00       	call   103920 <debug_warn>
  1025e2:	83 c4 20             	add    $0x20,%esp
    base->reg = reg;
  1025e5:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    return base->data;
  1025eb:	8b 73 10             	mov    0x10(%ebx),%esi

        int maxintr = (ioapic_read(ioapic, IOAPIC_VER) >> 16) & 0xFF;
  1025ee:	c1 ee 10             	shr    $0x10,%esi
  1025f1:	89 f0                	mov    %esi,%eax
  1025f3:	0f b6 f0             	movzbl %al,%esi
  1025f6:	b8 20 00 00 00       	mov    $0x20,%eax
  1025fb:	83 c6 21             	add    $0x21,%esi
  1025fe:	66 90                	xchg   %ax,%ax

        // Mark all interrupts edge-triggered, active high, disabled,
        // and not routed to any CPUs.
        int j;
        for (j = 0; j <= maxintr; j++) {
            ioapic_write(ioapic, IOAPIC_TABLE + 2 * j,
  102600:	8d 14 00             	lea    (%eax,%eax,1),%edx
                         IOAPIC_INT_DISABLED | (T_IRQ0 + j));
  102603:	89 c1                	mov    %eax,%ecx
  102605:	83 c0 01             	add    $0x1,%eax
  102608:	8d 6a d0             	lea    -0x30(%edx),%ebp
  10260b:	81 c9 00 00 01 00    	or     $0x10000,%ecx
    base->reg = reg;
  102611:	83 ea 2f             	sub    $0x2f,%edx
  102614:	89 2b                	mov    %ebp,(%ebx)
    base->data = data;
  102616:	89 4b 10             	mov    %ecx,0x10(%ebx)
    base->reg = reg;
  102619:	89 13                	mov    %edx,(%ebx)
    base->data = data;
  10261b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        for (j = 0; j <= maxintr; j++) {
  102622:	39 c6                	cmp    %eax,%esi
  102624:	75 da                	jne    102600 <ioapic_init+0xa0>
    for (i = 0; i < ioapic_num; i++) {
  102626:	a1 64 ce 14 00       	mov    0x14ce64,%eax
  10262b:	83 c7 01             	add    $0x1,%edi
  10262e:	39 f8                	cmp    %edi,%eax
  102630:	0f 8f 4a ff ff ff    	jg     102580 <ioapic_init+0x20>
            ioapic_write(ioapic, IOAPIC_TABLE + 2 * j + 1, 0);
        }
    }
}
  102636:	83 c4 0c             	add    $0xc,%esp
  102639:	5b                   	pop    %ebx
  10263a:	5e                   	pop    %esi
  10263b:	5f                   	pop    %edi
  10263c:	5d                   	pop    %ebp
  10263d:	c3                   	ret    
  10263e:	66 90                	xchg   %ax,%ax
        KERN_ASSERT(ioapic != NULL);
  102640:	68 3f 97 10 00       	push   $0x10973f
  102645:	68 df 92 10 00       	push   $0x1092df
  10264a:	6a 2f                	push   $0x2f
  10264c:	68 2d 97 10 00       	push   $0x10972d
  102651:	e8 fa 11 00 00       	call   103850 <debug_panic>
  102656:	83 c4 10             	add    $0x10,%esp
  102659:	e9 31 ff ff ff       	jmp    10258f <ioapic_init+0x2f>
  10265e:	c3                   	ret    
  10265f:	90                   	nop

00102660 <ioapic_enable>:

void ioapic_enable(uint8_t irq, lapicid_t apicid, bool trigger_mode, bool polarity)
{
  102660:	55                   	push   %ebp
  102661:	57                   	push   %edi
  102662:	56                   	push   %esi
  102663:	53                   	push   %ebx
  102664:	83 ec 1c             	sub    $0x1c,%esp
  102667:	8b 44 24 34          	mov    0x34(%esp),%eax
  10266b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  10266f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  102673:	89 44 24 08          	mov    %eax,0x8(%esp)
  102677:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  10267b:	89 44 24 0c          	mov    %eax,0xc(%esp)
    // Mark interrupt edge-triggered, active high,
    // enabled, and routed to the given APIC ID,
    int i;
    for (i = 0; i < ioapic_num; i++) {
  10267f:	a1 64 ce 14 00       	mov    0x14ce64,%eax
  102684:	85 c0                	test   %eax,%eax
  102686:	0f 8e d7 00 00 00    	jle    102763 <ioapic_enable+0x103>
  10268c:	89 e8                	mov    %ebp,%eax
  10268e:	0f b6 d8             	movzbl %al,%ebx
  102691:	31 c0                	xor    %eax,%eax
  102693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102697:	90                   	nop
        ioapic_t *ioapic = ioapics[i];
  102698:	8b 0c 85 80 d8 9d 00 	mov    0x9dd880(,%eax,4),%ecx
    base->reg = reg;
  10269f:	c7 01 01 00 00 00    	movl   $0x1,(%ecx)
    return base->data;
  1026a5:	8b 51 10             	mov    0x10(%ecx),%edx
        int maxintr = (ioapic_read(ioapic, IOAPIC_VER) >> 16) & 0xFF;

        if (irq >= gsi[i] && irq <= gsi[i] + maxintr) {
  1026a8:	8b 34 85 40 d8 9d 00 	mov    0x9dd840(,%eax,4),%esi
  1026af:	39 de                	cmp    %ebx,%esi
  1026b1:	7f 13                	jg     1026c6 <ioapic_enable+0x66>
  1026b3:	8b 34 85 40 d8 9d 00 	mov    0x9dd840(,%eax,4),%esi
        int maxintr = (ioapic_read(ioapic, IOAPIC_VER) >> 16) & 0xFF;
  1026ba:	c1 ea 10             	shr    $0x10,%edx
  1026bd:	0f b6 d2             	movzbl %dl,%edx
        if (irq >= gsi[i] && irq <= gsi[i] + maxintr) {
  1026c0:	01 f2                	add    %esi,%edx
  1026c2:	39 da                	cmp    %ebx,%edx
  1026c4:	7d 22                	jge    1026e8 <ioapic_enable+0x88>
    for (i = 0; i < ioapic_num; i++) {
  1026c6:	8b 15 64 ce 14 00    	mov    0x14ce64,%edx
  1026cc:	83 c0 01             	add    $0x1,%eax
  1026cf:	39 c2                	cmp    %eax,%edx
  1026d1:	7f c5                	jg     102698 <ioapic_enable+0x38>
                         apicid << 24);
            break;
        }
    }

    if (i == ioapic_num)
  1026d3:	8b 15 64 ce 14 00    	mov    0x14ce64,%edx
  1026d9:	39 c2                	cmp    %eax,%edx
  1026db:	74 59                	je     102736 <ioapic_enable+0xd6>
        KERN_PANIC("Cannot enable IRQ %d on IOAPIC.\n", irq);
}
  1026dd:	83 c4 1c             	add    $0x1c,%esp
  1026e0:	5b                   	pop    %ebx
  1026e1:	5e                   	pop    %esi
  1026e2:	5f                   	pop    %edi
  1026e3:	5d                   	pop    %ebp
  1026e4:	c3                   	ret    
  1026e5:	8d 76 00             	lea    0x0(%esi),%esi
                         ((trigger_mode << 15) | (polarity << 13) | (T_IRQ0 + irq)));
  1026e8:	89 fa                	mov    %edi,%edx
                         IOAPIC_TABLE + 2 * (irq - gsi[i]),
  1026ea:	89 de                	mov    %ebx,%esi
                         ((trigger_mode << 15) | (polarity << 13) | (T_IRQ0 + irq)));
  1026ec:	0f b6 fa             	movzbl %dl,%edi
  1026ef:	0f b6 54 24 0c       	movzbl 0xc(%esp),%edx
  1026f4:	c1 e7 0f             	shl    $0xf,%edi
  1026f7:	c1 e2 0d             	shl    $0xd,%edx
  1026fa:	09 d7                	or     %edx,%edi
  1026fc:	8d 53 20             	lea    0x20(%ebx),%edx
  1026ff:	09 d7                	or     %edx,%edi
                         IOAPIC_TABLE + 2 * (irq - gsi[i]),
  102701:	8b 14 85 40 d8 9d 00 	mov    0x9dd840(,%eax,4),%edx
  102708:	29 d6                	sub    %edx,%esi
            ioapic_write(ioapic,
  10270a:	8d 54 36 10          	lea    0x10(%esi,%esi,1),%edx
    base->reg = reg;
  10270e:	89 11                	mov    %edx,(%ecx)
                         apicid << 24);
  102710:	8b 54 24 08          	mov    0x8(%esp),%edx
    base->data = data;
  102714:	89 79 10             	mov    %edi,0x10(%ecx)
                         IOAPIC_TABLE + 2 * (irq - gsi[i]) + 1,
  102717:	8b 34 85 40 d8 9d 00 	mov    0x9dd840(,%eax,4),%esi
                         apicid << 24);
  10271e:	c1 e2 18             	shl    $0x18,%edx
                         IOAPIC_TABLE + 2 * (irq - gsi[i]) + 1,
  102721:	29 f3                	sub    %esi,%ebx
            ioapic_write(ioapic,
  102723:	8d 5c 1b 11          	lea    0x11(%ebx,%ebx,1),%ebx
    base->reg = reg;
  102727:	89 19                	mov    %ebx,(%ecx)
    base->data = data;
  102729:	89 51 10             	mov    %edx,0x10(%ecx)
    if (i == ioapic_num)
  10272c:	8b 15 64 ce 14 00    	mov    0x14ce64,%edx
  102732:	39 c2                	cmp    %eax,%edx
  102734:	75 a7                	jne    1026dd <ioapic_enable+0x7d>
        KERN_PANIC("Cannot enable IRQ %d on IOAPIC.\n", irq);
  102736:	89 e8                	mov    %ebp,%eax
  102738:	c7 44 24 38 0c 97 10 	movl   $0x10970c,0x38(%esp)
  10273f:	00 
  102740:	0f b6 e8             	movzbl %al,%ebp
  102743:	c7 44 24 34 5d 00 00 	movl   $0x5d,0x34(%esp)
  10274a:	00 
  10274b:	89 6c 24 3c          	mov    %ebp,0x3c(%esp)
  10274f:	c7 44 24 30 2d 97 10 	movl   $0x10972d,0x30(%esp)
  102756:	00 
}
  102757:	83 c4 1c             	add    $0x1c,%esp
  10275a:	5b                   	pop    %ebx
  10275b:	5e                   	pop    %esi
  10275c:	5f                   	pop    %edi
  10275d:	5d                   	pop    %ebp
        KERN_PANIC("Cannot enable IRQ %d on IOAPIC.\n", irq);
  10275e:	e9 ed 10 00 00       	jmp    103850 <debug_panic>
    for (i = 0; i < ioapic_num; i++) {
  102763:	31 c0                	xor    %eax,%eax
  102765:	e9 69 ff ff ff       	jmp    1026d3 <ioapic_enable+0x73>
  10276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102770 <ioapic_number>:

int ioapic_number(void)
{
    return ioapic_num;
  102770:	a1 64 ce 14 00       	mov    0x14ce64,%eax
}
  102775:	c3                   	ret    
  102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10277d:	8d 76 00             	lea    0x0(%esi),%esi

00102780 <ioapic_get>:

ioapic_t *ioapic_get(uint32_t idx)
{
  102780:	8b 44 24 04          	mov    0x4(%esp),%eax
    if (idx >= ioapic_num)
  102784:	8b 15 64 ce 14 00    	mov    0x14ce64,%edx
  10278a:	39 c2                	cmp    %eax,%edx
  10278c:	76 12                	jbe    1027a0 <ioapic_get+0x20>
        return NULL;
    return ioapics[idx];
  10278e:	8b 04 85 80 d8 9d 00 	mov    0x9dd880(,%eax,4),%eax
  102795:	c3                   	ret    
  102796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10279d:	8d 76 00             	lea    0x0(%esi),%esi
        return NULL;
  1027a0:	31 c0                	xor    %eax,%eax
}
  1027a2:	c3                   	ret    
  1027a3:	66 90                	xchg   %ax,%ax
  1027a5:	66 90                	xchg   %ax,%ax
  1027a7:	66 90                	xchg   %ax,%ax
  1027a9:	66 90                	xchg   %ax,%ax
  1027ab:	66 90                	xchg   %ax,%ax
  1027ad:	66 90                	xchg   %ax,%ax
  1027af:	90                   	nop

001027b0 <pcpu_mp_init_cpu>:

    pcpu_print_cpuinfo(get_pcpu_idx(), cpuinfo);
}

static void pcpu_mp_init_cpu(uint32_t idx, uint8_t lapic_id, bool is_bsp)
{
  1027b0:	57                   	push   %edi
  1027b1:	89 d7                	mov    %edx,%edi
  1027b3:	53                   	push   %ebx
  1027b4:	89 cb                	mov    %ecx,%ebx
  1027b6:	83 ec 14             	sub    $0x14,%esp
    KERN_ASSERT((is_bsp == TRUE && idx == 0) || (is_bsp == FALSE));
  1027b9:	83 e1 01             	and    $0x1,%ecx
  1027bc:	74 22                	je     1027e0 <pcpu_mp_init_cpu+0x30>
  1027be:	85 c0                	test   %eax,%eax
  1027c0:	75 1e                	jne    1027e0 <pcpu_mp_init_cpu+0x30>

    if (idx >= NUM_CPUS)
        return;

    struct pcpuinfo *info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(idx);
  1027c2:	83 ec 0c             	sub    $0xc,%esp
  1027c5:	50                   	push   %eax
  1027c6:	e8 55 33 00 00       	call   105b20 <get_pcpu_arch_info_pointer>

    info->lapicid = lapic_id;
  1027cb:	89 fa                	mov    %edi,%edx
    info->bsp = is_bsp;
  1027cd:	83 c4 10             	add    $0x10,%esp
    info->lapicid = lapic_id;
  1027d0:	0f b6 fa             	movzbl %dl,%edi
    info->bsp = is_bsp;
  1027d3:	88 58 04             	mov    %bl,0x4(%eax)
    info->lapicid = lapic_id;
  1027d6:	89 38                	mov    %edi,(%eax)
}
  1027d8:	83 c4 14             	add    $0x14,%esp
  1027db:	5b                   	pop    %ebx
  1027dc:	5f                   	pop    %edi
  1027dd:	c3                   	ret    
  1027de:	66 90                	xchg   %ax,%ax
    KERN_ASSERT((is_bsp == TRUE && idx == 0) || (is_bsp == FALSE));
  1027e0:	84 db                	test   %bl,%bl
  1027e2:	75 0c                	jne    1027f0 <pcpu_mp_init_cpu+0x40>
    if (idx >= NUM_CPUS)
  1027e4:	83 f8 07             	cmp    $0x7,%eax
  1027e7:	76 d9                	jbe    1027c2 <pcpu_mp_init_cpu+0x12>
}
  1027e9:	83 c4 14             	add    $0x14,%esp
  1027ec:	5b                   	pop    %ebx
  1027ed:	5f                   	pop    %edi
  1027ee:	c3                   	ret    
  1027ef:	90                   	nop
  1027f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
    KERN_ASSERT((is_bsp == TRUE && idx == 0) || (is_bsp == FALSE));
  1027f4:	68 50 97 10 00       	push   $0x109750
  1027f9:	68 df 92 10 00       	push   $0x1092df
  1027fe:	68 9b 00 00 00       	push   $0x9b
  102803:	68 68 99 10 00       	push   $0x109968
  102808:	e8 43 10 00 00       	call   103850 <debug_panic>
  10280d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  102811:	83 c4 10             	add    $0x10,%esp
    if (idx >= NUM_CPUS)
  102814:	83 f8 07             	cmp    $0x7,%eax
  102817:	77 d0                	ja     1027e9 <pcpu_mp_init_cpu+0x39>
  102819:	eb a7                	jmp    1027c2 <pcpu_mp_init_cpu+0x12>
  10281b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10281f:	90                   	nop

00102820 <mpsearch1>:
    return sum;
}

/* Look for an MP structure in the len bytes at addr. */
static struct mp *mpsearch1(uint8_t *addr, int len)
{
  102820:	57                   	push   %edi
  102821:	56                   	push   %esi
  102822:	53                   	push   %ebx
    uint8_t *e, *p;

    e = addr + len;
  102823:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
    for (p = addr; p < e; p += sizeof(struct mp))
  102826:	39 d8                	cmp    %ebx,%eax
  102828:	73 46                	jae    102870 <mpsearch1+0x50>
  10282a:	89 c6                	mov    %eax,%esi
  10282c:	eb 08                	jmp    102836 <mpsearch1+0x16>
  10282e:	66 90                	xchg   %ax,%ax
  102830:	89 fe                	mov    %edi,%esi
  102832:	39 fb                	cmp    %edi,%ebx
  102834:	76 3a                	jbe    102870 <mpsearch1+0x50>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102836:	83 ec 04             	sub    $0x4,%esp
  102839:	8d 7e 10             	lea    0x10(%esi),%edi
  10283c:	6a 04                	push   $0x4
  10283e:	68 7b 99 10 00       	push   $0x10997b
  102843:	56                   	push   %esi
  102844:	e8 d7 0e 00 00       	call   103720 <memcmp>
  102849:	83 c4 10             	add    $0x10,%esp
  10284c:	85 c0                	test   %eax,%eax
  10284e:	75 e0                	jne    102830 <mpsearch1+0x10>
  102850:	89 f2                	mov    %esi,%edx
  102852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += addr[i];
  102858:	0f b6 0a             	movzbl (%edx),%ecx
  10285b:	83 c2 01             	add    $0x1,%edx
  10285e:	01 c8                	add    %ecx,%eax
    for (i = 0; i < len; i++)
  102860:	39 fa                	cmp    %edi,%edx
  102862:	75 f4                	jne    102858 <mpsearch1+0x38>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102864:	84 c0                	test   %al,%al
  102866:	75 c8                	jne    102830 <mpsearch1+0x10>
  102868:	89 f0                	mov    %esi,%eax
            return (struct mp *) p;
    return 0;
}
  10286a:	5b                   	pop    %ebx
  10286b:	5e                   	pop    %esi
  10286c:	5f                   	pop    %edi
  10286d:	c3                   	ret    
  10286e:	66 90                	xchg   %ax,%ax
  102870:	5b                   	pop    %ebx
    return 0;
  102871:	31 c0                	xor    %eax,%eax
}
  102873:	5e                   	pop    %esi
  102874:	5f                   	pop    %edi
  102875:	c3                   	ret    
  102876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10287d:	8d 76 00             	lea    0x0(%esi),%esi

00102880 <pcpu_mp_init>:
    acpi_xsdt_t *xsdt;
    acpi_madt_t *madt;
    uint32_t ap_idx = 1;
    bool found_bsp = FALSE;

    if (mp_inited == TRUE)
  102880:	80 3d 69 ce 14 00 01 	cmpb   $0x1,0x14ce69
  102887:	0f 84 eb 01 00 00    	je     102a78 <pcpu_mp_init+0x1f8>
{
  10288d:	55                   	push   %ebp
  10288e:	57                   	push   %edi
  10288f:	56                   	push   %esi
  102890:	53                   	push   %ebx
  102891:	83 ec 28             	sub    $0x28,%esp
        return TRUE;

    KERN_INFO("\n");
  102894:	68 70 a7 10 00       	push   $0x10a770
  102899:	e8 32 0f 00 00       	call   1037d0 <debug_info>

    if ((rsdp = acpi_probe_rsdp()) == NULL) {
  10289e:	e8 1d f5 ff ff       	call   101dc0 <acpi_probe_rsdp>
  1028a3:	83 c4 10             	add    $0x10,%esp
  1028a6:	89 c3                	mov    %eax,%ebx
  1028a8:	85 c0                	test   %eax,%eax
  1028aa:	0f 84 00 02 00 00    	je     102ab0 <pcpu_mp_init+0x230>
        KERN_DEBUG("Not found RSDP.\n");
        goto fallback;
    }

    xsdt = NULL;
    if ((xsdt = acpi_probe_xsdt(rsdp)) == NULL &&
  1028b0:	83 ec 0c             	sub    $0xc,%esp
  1028b3:	50                   	push   %eax
  1028b4:	e8 d7 f6 ff ff       	call   101f90 <acpi_probe_xsdt>
  1028b9:	83 c4 10             	add    $0x10,%esp
  1028bc:	85 c0                	test   %eax,%eax
  1028be:	0f 84 84 01 00 00    	je     102a48 <pcpu_mp_init+0x1c8>
        goto fallback;
    }

    if ((madt =
         (xsdt != NULL) ?
         (acpi_madt_t *) acpi_probe_xsdt_ent(xsdt, ACPI_MADT_SIG) :
  1028c4:	83 ec 08             	sub    $0x8,%esp
  1028c7:	68 41 50 49 43       	push   $0x43495041
  1028cc:	50                   	push   %eax
  1028cd:	e8 3e f7 ff ff       	call   102010 <acpi_probe_xsdt_ent>
  1028d2:	83 c4 10             	add    $0x10,%esp
  1028d5:	89 c7                	mov    %eax,%edi
    if ((madt =
  1028d7:	85 ff                	test   %edi,%edi
  1028d9:	0f 84 f9 03 00 00    	je     102cd8 <pcpu_mp_init+0x458>
        KERN_DEBUG("Not found MADT.\n");
        goto fallback;
    }

    ismp = TRUE;
    lapic_register(madt->lapic_addr);
  1028df:	83 ec 0c             	sub    $0xc,%esp
  1028e2:	ff 77 24             	pushl  0x24(%edi)
    ncpu = 0;

    p = (uint8_t *) madt->ent;
  1028e5:	8d 5f 2c             	lea    0x2c(%edi),%ebx
    ismp = TRUE;
  1028e8:	c6 05 68 ce 14 00 01 	movb   $0x1,0x14ce68
    lapic_register(madt->lapic_addr);
  1028ef:	e8 ac f7 ff ff       	call   1020a0 <lapic_register>
    e = (uint8_t *) madt + madt->length;
  1028f4:	8b 77 04             	mov    0x4(%edi),%esi

    while (p < e) {
  1028f7:	83 c4 10             	add    $0x10,%esp
    ncpu = 0;
  1028fa:	c7 05 6c ce 14 00 00 	movl   $0x0,0x14ce6c
  102901:	00 00 00 
    e = (uint8_t *) madt + madt->length;
  102904:	01 fe                	add    %edi,%esi
    while (p < e) {
  102906:	39 f3                	cmp    %esi,%ebx
  102908:	73 71                	jae    10297b <pcpu_mp_init+0xfb>
    uint32_t ap_idx = 1;
  10290a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  102911:	00 
    bool found_bsp = FALSE;
  102912:	31 ed                	xor    %ebp,%ebp
  102914:	eb 25                	jmp    10293b <pcpu_mp_init+0xbb>
  102916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10291d:	8d 76 00             	lea    0x0(%esi),%esi

            ioapic_register(ioapic_ent->ioapic_addr, ioapic_ent->ioapic_id,
                            ioapic_ent->gsi);
            break;
        default:
            KERN_INFO("\tUnhandled ACPI entry (type=%x)\n", hdr->type);
  102920:	83 ec 08             	sub    $0x8,%esp
  102923:	50                   	push   %eax
  102924:	68 c8 97 10 00       	push   $0x1097c8
  102929:	e8 a2 0e 00 00       	call   1037d0 <debug_info>
            break;
  10292e:	83 c4 10             	add    $0x10,%esp
        }

        p += hdr->length;
  102931:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  102935:	01 c3                	add    %eax,%ebx
    while (p < e) {
  102937:	39 de                	cmp    %ebx,%esi
  102939:	76 40                	jbe    10297b <pcpu_mp_init+0xfb>
        switch (hdr->type) {
  10293b:	0f b6 03             	movzbl (%ebx),%eax
  10293e:	84 c0                	test   %al,%al
  102940:	74 76                	je     1029b8 <pcpu_mp_init+0x138>
  102942:	3c 01                	cmp    $0x1,%al
  102944:	75 da                	jne    102920 <pcpu_mp_init+0xa0>
            KERN_INFO("\tIOAPIC: APIC id = %x, base = %x\n",
  102946:	83 ec 04             	sub    $0x4,%esp
  102949:	ff 73 04             	pushl  0x4(%ebx)
  10294c:	0f b6 43 02          	movzbl 0x2(%ebx),%eax
  102950:	50                   	push   %eax
  102951:	68 a4 97 10 00       	push   $0x1097a4
  102956:	e8 75 0e 00 00       	call   1037d0 <debug_info>
            ioapic_register(ioapic_ent->ioapic_addr, ioapic_ent->ioapic_id,
  10295b:	83 c4 0c             	add    $0xc,%esp
  10295e:	ff 73 08             	pushl  0x8(%ebx)
  102961:	0f b6 43 02          	movzbl 0x2(%ebx),%eax
  102965:	50                   	push   %eax
  102966:	ff 73 04             	pushl  0x4(%ebx)
  102969:	e8 82 fb ff ff       	call   1024f0 <ioapic_register>
        p += hdr->length;
  10296e:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
            break;
  102972:	83 c4 10             	add    $0x10,%esp
        p += hdr->length;
  102975:	01 c3                	add    %eax,%ebx
    while (p < e) {
  102977:	39 de                	cmp    %ebx,%esi
  102979:	77 c0                	ja     10293b <pcpu_mp_init+0xbb>
    /*
     * Force NMI and 8259 signals to APIC when PIC mode
     * is not implemented.
     *
     */
    if ((madt->flags & APIC_MADT_PCAT_COMPAT) == 0) {
  10297b:	f6 47 28 01          	testb  $0x1,0x28(%edi)
  10297f:	0f 84 fb 00 00 00    	je     102a80 <pcpu_mp_init+0x200>
    }

    /*
     * Copy AP boot code to 0x8000.
     */
    memmove((uint8_t *) 0x8000,
  102985:	83 ec 04             	sub    $0x4,%esp
  102988:	68 62 00 00 00       	push   $0x62
  10298d:	68 10 13 11 00       	push   $0x111310
  102992:	68 00 80 00 00       	push   $0x8000
  102997:	e8 e4 0b 00 00       	call   103580 <memmove>
            _binary___obj_kern_init_boot_ap_start,
            (size_t) _binary___obj_kern_init_boot_ap_size);

    mp_inited = TRUE;
    return TRUE;
  10299c:	83 c4 10             	add    $0x10,%esp
  10299f:	b8 01 00 00 00       	mov    $0x1,%eax
    mp_inited = TRUE;
  1029a4:	c6 05 69 ce 14 00 01 	movb   $0x1,0x14ce69
        ismp = 0;
        ncpu = 1;
        return FALSE;
    } else
        return TRUE;
}
  1029ab:	83 c4 1c             	add    $0x1c,%esp
  1029ae:	5b                   	pop    %ebx
  1029af:	5e                   	pop    %esi
  1029b0:	5f                   	pop    %edi
  1029b1:	5d                   	pop    %ebp
  1029b2:	c3                   	ret    
  1029b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1029b7:	90                   	nop
            if (!(lapic_ent->flags & ACPI_APIC_ENABLED)) {
  1029b8:	f6 43 04 01          	testb  $0x1,0x4(%ebx)
  1029bc:	0f 84 6f ff ff ff    	je     102931 <pcpu_mp_init+0xb1>
            KERN_INFO("\tCPU%d: APIC id = %x, ", ncpu, lapic_ent->lapic_id);
  1029c2:	0f b6 43 03          	movzbl 0x3(%ebx),%eax
  1029c6:	83 ec 04             	sub    $0x4,%esp
  1029c9:	50                   	push   %eax
  1029ca:	ff 35 6c ce 14 00    	pushl  0x14ce6c
  1029d0:	68 a2 99 10 00       	push   $0x1099a2
  1029d5:	e8 f6 0d 00 00       	call   1037d0 <debug_info>
            if (!found_bsp) {
  1029da:	89 e8                	mov    %ebp,%eax
  1029dc:	83 c4 10             	add    $0x10,%esp
  1029df:	84 c0                	test   %al,%al
  1029e1:	74 3d                	je     102a20 <pcpu_mp_init+0x1a0>
                KERN_INFO("AP\n");
  1029e3:	83 ec 0c             	sub    $0xc,%esp
  1029e6:	68 be 99 10 00       	push   $0x1099be
  1029eb:	e8 e0 0d 00 00       	call   1037d0 <debug_info>
                pcpu_mp_init_cpu(ap_idx, lapic_ent->lapic_id, FALSE);
  1029f0:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
  1029f4:	0f b6 53 03          	movzbl 0x3(%ebx),%edx
  1029f8:	31 c9                	xor    %ecx,%ecx
  1029fa:	89 e8                	mov    %ebp,%eax
  1029fc:	e8 af fd ff ff       	call   1027b0 <pcpu_mp_init_cpu>
                ap_idx++;
  102a01:	89 e8                	mov    %ebp,%eax
  102a03:	83 c0 01             	add    $0x1,%eax
  102a06:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  102a0a:	83 c4 10             	add    $0x10,%esp
            ncpu++;
  102a0d:	83 05 6c ce 14 00 01 	addl   $0x1,0x14ce6c
            break;
  102a14:	bd 01 00 00 00       	mov    $0x1,%ebp
  102a19:	e9 13 ff ff ff       	jmp    102931 <pcpu_mp_init+0xb1>
  102a1e:	66 90                	xchg   %ax,%ax
                KERN_INFO("BSP\n");
  102a20:	83 ec 0c             	sub    $0xc,%esp
  102a23:	68 b9 99 10 00       	push   $0x1099b9
  102a28:	e8 a3 0d 00 00       	call   1037d0 <debug_info>
                pcpu_mp_init_cpu(0, lapic_ent->lapic_id, TRUE);
  102a2d:	0f b6 53 03          	movzbl 0x3(%ebx),%edx
  102a31:	b9 01 00 00 00       	mov    $0x1,%ecx
  102a36:	31 c0                	xor    %eax,%eax
  102a38:	e8 73 fd ff ff       	call   1027b0 <pcpu_mp_init_cpu>
  102a3d:	83 c4 10             	add    $0x10,%esp
  102a40:	eb cb                	jmp    102a0d <pcpu_mp_init+0x18d>
  102a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        (rsdt = acpi_probe_rsdt(rsdp)) == NULL) {
  102a48:	83 ec 0c             	sub    $0xc,%esp
  102a4b:	53                   	push   %ebx
  102a4c:	e8 2f f4 ff ff       	call   101e80 <acpi_probe_rsdt>
    if ((xsdt = acpi_probe_xsdt(rsdp)) == NULL &&
  102a51:	83 c4 10             	add    $0x10,%esp
  102a54:	85 c0                	test   %eax,%eax
  102a56:	0f 84 4f 03 00 00    	je     102dab <pcpu_mp_init+0x52b>
         (acpi_madt_t *) acpi_probe_rsdt_ent(rsdt, ACPI_MADT_SIG)) == NULL) {
  102a5c:	83 ec 08             	sub    $0x8,%esp
  102a5f:	68 41 50 49 43       	push   $0x43495041
  102a64:	50                   	push   %eax
  102a65:	e8 96 f4 ff ff       	call   101f00 <acpi_probe_rsdt_ent>
  102a6a:	83 c4 10             	add    $0x10,%esp
  102a6d:	89 c7                	mov    %eax,%edi
  102a6f:	e9 63 fe ff ff       	jmp    1028d7 <pcpu_mp_init+0x57>
  102a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return TRUE;
  102a78:	b8 01 00 00 00       	mov    $0x1,%eax
}
  102a7d:	c3                   	ret    
  102a7e:	66 90                	xchg   %ax,%ax
        outb(0x22, 0x70);
  102a80:	83 ec 08             	sub    $0x8,%esp
  102a83:	6a 70                	push   $0x70
  102a85:	6a 22                	push   $0x22
  102a87:	e8 04 1b 00 00       	call   104590 <outb>
        outb(0x23, inb(0x23) | 1);
  102a8c:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
  102a93:	e8 c8 1a 00 00       	call   104560 <inb>
  102a98:	5b                   	pop    %ebx
  102a99:	5e                   	pop    %esi
  102a9a:	83 c8 01             	or     $0x1,%eax
  102a9d:	0f b6 c0             	movzbl %al,%eax
  102aa0:	50                   	push   %eax
  102aa1:	6a 23                	push   $0x23
  102aa3:	e8 e8 1a 00 00       	call   104590 <outb>
  102aa8:	83 c4 10             	add    $0x10,%esp
  102aab:	e9 d5 fe ff ff       	jmp    102985 <pcpu_mp_init+0x105>
        KERN_DEBUG("Not found RSDP.\n");
  102ab0:	83 ec 04             	sub    $0x4,%esp
  102ab3:	68 80 99 10 00       	push   $0x109980
  102ab8:	68 4f 01 00 00       	push   $0x14f
  102abd:	68 68 99 10 00       	push   $0x109968
  102ac2:	e8 39 0d 00 00       	call   103800 <debug_normal>
        goto fallback;
  102ac7:	83 c4 10             	add    $0x10,%esp
    KERN_DEBUG("Use the fallback multiprocessor initialization.\n");
  102aca:	83 ec 04             	sub    $0x4,%esp
  102acd:	68 ec 97 10 00       	push   $0x1097ec
  102ad2:	68 ac 01 00 00       	push   $0x1ac
  102ad7:	68 68 99 10 00       	push   $0x109968
  102adc:	e8 1f 0d 00 00       	call   103800 <debug_normal>
    if (mp_inited == TRUE)
  102ae1:	83 c4 10             	add    $0x10,%esp
  102ae4:	80 3d 69 ce 14 00 01 	cmpb   $0x1,0x14ce69
  102aeb:	0f 84 9a 01 00 00    	je     102c8b <pcpu_mp_init+0x40b>
    if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
  102af1:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  102af8:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  102aff:	c1 e0 08             	shl    $0x8,%eax
  102b02:	09 d0                	or     %edx,%eax
  102b04:	c1 e0 04             	shl    $0x4,%eax
  102b07:	75 1b                	jne    102b24 <pcpu_mp_init+0x2a4>
        p = ((bda[0x14] << 8) | bda[0x13]) * 1024;
  102b09:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102b10:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102b17:	c1 e0 08             	shl    $0x8,%eax
  102b1a:	09 d0                	or     %edx,%eax
  102b1c:	c1 e0 0a             	shl    $0xa,%eax
        if ((mp = mpsearch1((uint8_t *) p - 1024, 1024)))
  102b1f:	2d 00 04 00 00       	sub    $0x400,%eax
        if ((mp = mpsearch1((uint8_t *) p, 1024)))
  102b24:	ba 00 04 00 00       	mov    $0x400,%edx
  102b29:	e8 f2 fc ff ff       	call   102820 <mpsearch1>
  102b2e:	89 c6                	mov    %eax,%esi
  102b30:	85 c0                	test   %eax,%eax
  102b32:	0f 84 c8 00 00 00    	je     102c00 <pcpu_mp_init+0x380>
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102b38:	8b 5e 04             	mov    0x4(%esi),%ebx
  102b3b:	85 db                	test   %ebx,%ebx
  102b3d:	0f 84 d6 00 00 00    	je     102c19 <pcpu_mp_init+0x399>
    if (memcmp(conf, "PCMP", 4) != 0)
  102b43:	83 ec 04             	sub    $0x4,%esp
  102b46:	6a 04                	push   $0x4
  102b48:	68 c2 99 10 00       	push   $0x1099c2
  102b4d:	53                   	push   %ebx
  102b4e:	e8 cd 0b 00 00       	call   103720 <memcmp>
  102b53:	83 c4 10             	add    $0x10,%esp
  102b56:	85 c0                	test   %eax,%eax
  102b58:	0f 85 bb 00 00 00    	jne    102c19 <pcpu_mp_init+0x399>
    if (conf->version != 1 && conf->version != 4)
  102b5e:	0f b6 53 06          	movzbl 0x6(%ebx),%edx
  102b62:	80 fa 01             	cmp    $0x1,%dl
  102b65:	74 09                	je     102b70 <pcpu_mp_init+0x2f0>
  102b67:	80 fa 04             	cmp    $0x4,%dl
  102b6a:	0f 85 a9 00 00 00    	jne    102c19 <pcpu_mp_init+0x399>
    if (sum((uint8_t *) conf, conf->length) != 0)
  102b70:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
    for (i = 0; i < len; i++)
  102b74:	66 85 ff             	test   %di,%di
  102b77:	74 1b                	je     102b94 <pcpu_mp_init+0x314>
  102b79:	89 da                	mov    %ebx,%edx
  102b7b:	01 df                	add    %ebx,%edi
  102b7d:	8d 76 00             	lea    0x0(%esi),%esi
        sum += addr[i];
  102b80:	0f b6 0a             	movzbl (%edx),%ecx
  102b83:	83 c2 01             	add    $0x1,%edx
  102b86:	01 c8                	add    %ecx,%eax
    for (i = 0; i < len; i++)
  102b88:	39 fa                	cmp    %edi,%edx
  102b8a:	75 f4                	jne    102b80 <pcpu_mp_init+0x300>
    if (sum((uint8_t *) conf, conf->length) != 0)
  102b8c:	84 c0                	test   %al,%al
  102b8e:	0f 85 85 00 00 00    	jne    102c19 <pcpu_mp_init+0x399>
    lapic_register((uintptr_t) conf->lapicaddr);
  102b94:	83 ec 0c             	sub    $0xc,%esp
  102b97:	ff 73 24             	pushl  0x24(%ebx)
    for (p = (uint8_t *) (conf + 1), e = (uint8_t *) conf + conf->length; p < e;) {
  102b9a:	8d 6b 2c             	lea    0x2c(%ebx),%ebp
    ismp = 1;
  102b9d:	c6 05 68 ce 14 00 01 	movb   $0x1,0x14ce68
    ncpu = 0;
  102ba4:	c7 05 6c ce 14 00 00 	movl   $0x0,0x14ce6c
  102bab:	00 00 00 
    lapic_register((uintptr_t) conf->lapicaddr);
  102bae:	e8 ed f4 ff ff       	call   1020a0 <lapic_register>
    for (p = (uint8_t *) (conf + 1), e = (uint8_t *) conf + conf->length; p < e;) {
  102bb3:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  102bb7:	83 c4 10             	add    $0x10,%esp
  102bba:	01 d3                	add    %edx,%ebx
  102bbc:	39 dd                	cmp    %ebx,%ebp
  102bbe:	0f 83 9c 00 00 00    	jae    102c60 <pcpu_mp_init+0x3e0>
    uint32_t ap_idx = 1;
  102bc4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  102bcb:	00 
  102bcc:	eb 0d                	jmp    102bdb <pcpu_mp_init+0x35b>
  102bce:	66 90                	xchg   %ax,%ax
            p += 8;
  102bd0:	83 c5 08             	add    $0x8,%ebp
    for (p = (uint8_t *) (conf + 1), e = (uint8_t *) conf + conf->length; p < e;) {
  102bd3:	39 eb                	cmp    %ebp,%ebx
  102bd5:	0f 86 85 00 00 00    	jbe    102c60 <pcpu_mp_init+0x3e0>
        switch (*p) {
  102bdb:	0f b6 55 00          	movzbl 0x0(%ebp),%edx
  102bdf:	80 fa 02             	cmp    $0x2,%dl
  102be2:	0f 84 b8 00 00 00    	je     102ca0 <pcpu_mp_init+0x420>
  102be8:	77 4e                	ja     102c38 <pcpu_mp_init+0x3b8>
  102bea:	84 d2                	test   %dl,%dl
  102bec:	75 e2                	jne    102bd0 <pcpu_mp_init+0x350>
            p += sizeof(struct mpproc);
  102bee:	8d 7d 14             	lea    0x14(%ebp),%edi
            if (!(proc->flags & MPENAB))
  102bf1:	f6 45 03 01          	testb  $0x1,0x3(%ebp)
  102bf5:	0f 85 05 01 00 00    	jne    102d00 <pcpu_mp_init+0x480>
            p += sizeof(struct mpproc);
  102bfb:	89 fd                	mov    %edi,%ebp
  102bfd:	eb d4                	jmp    102bd3 <pcpu_mp_init+0x353>
  102bff:	90                   	nop
    return mpsearch1((uint8_t *) 0xF0000, 0x10000);
  102c00:	ba 00 00 01 00       	mov    $0x10000,%edx
  102c05:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102c0a:	e8 11 fc ff ff       	call   102820 <mpsearch1>
  102c0f:	89 c6                	mov    %eax,%esi
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102c11:	85 c0                	test   %eax,%eax
  102c13:	0f 85 1f ff ff ff    	jne    102b38 <pcpu_mp_init+0x2b8>
        ismp = 0;
  102c19:	c6 05 68 ce 14 00 00 	movb   $0x0,0x14ce68
        return FALSE;
  102c20:	31 c0                	xor    %eax,%eax
        ncpu = 1;
  102c22:	c7 05 6c ce 14 00 01 	movl   $0x1,0x14ce6c
  102c29:	00 00 00 
}
  102c2c:	83 c4 1c             	add    $0x1c,%esp
  102c2f:	5b                   	pop    %ebx
  102c30:	5e                   	pop    %esi
  102c31:	5f                   	pop    %edi
  102c32:	5d                   	pop    %ebp
  102c33:	c3                   	ret    
  102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        switch (*p) {
  102c38:	8d 4a fd             	lea    -0x3(%edx),%ecx
  102c3b:	80 f9 01             	cmp    $0x1,%cl
  102c3e:	76 90                	jbe    102bd0 <pcpu_mp_init+0x350>
            KERN_WARN("mpinit: unknown config type %x\n", *p);
  102c40:	52                   	push   %edx
  102c41:	68 20 98 10 00       	push   $0x109820
  102c46:	68 28 01 00 00       	push   $0x128
  102c4b:	68 68 99 10 00       	push   $0x109968
  102c50:	e8 cb 0c 00 00       	call   103920 <debug_warn>
  102c55:	83 c4 10             	add    $0x10,%esp
  102c58:	e9 76 ff ff ff       	jmp    102bd3 <pcpu_mp_init+0x353>
  102c5d:	8d 76 00             	lea    0x0(%esi),%esi
    if (mp->imcrp) {
  102c60:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  102c64:	0f 85 11 01 00 00    	jne    102d7b <pcpu_mp_init+0x4fb>
    memcpy((uint8_t *) 0x8000,
  102c6a:	83 ec 04             	sub    $0x4,%esp
  102c6d:	68 62 00 00 00       	push   $0x62
  102c72:	68 10 13 11 00       	push   $0x111310
  102c77:	68 00 80 00 00       	push   $0x8000
  102c7c:	e8 6f 09 00 00       	call   1035f0 <memcpy>
    mp_inited = TRUE;
  102c81:	c6 05 69 ce 14 00 01 	movb   $0x1,0x14ce69
  102c88:	83 c4 10             	add    $0x10,%esp
}
  102c8b:	83 c4 1c             	add    $0x1c,%esp
        return TRUE;
  102c8e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  102c93:	5b                   	pop    %ebx
  102c94:	5e                   	pop    %esi
  102c95:	5f                   	pop    %edi
  102c96:	5d                   	pop    %ebp
  102c97:	c3                   	ret    
  102c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102c9f:	90                   	nop
            KERN_INFO("\tIOAPIC: APIC id = %x, base = %x\n",
  102ca0:	83 ec 04             	sub    $0x4,%esp
  102ca3:	ff 75 04             	pushl  0x4(%ebp)
  102ca6:	0f b6 55 01          	movzbl 0x1(%ebp),%edx
            p += sizeof(struct mpioapic);
  102caa:	8d 7d 08             	lea    0x8(%ebp),%edi
            KERN_INFO("\tIOAPIC: APIC id = %x, base = %x\n",
  102cad:	52                   	push   %edx
  102cae:	68 a4 97 10 00       	push   $0x1097a4
  102cb3:	e8 18 0b 00 00       	call   1037d0 <debug_info>
            ioapic_register((uintptr_t) mpio->addr, mpio->apicno, 0);
  102cb8:	83 c4 0c             	add    $0xc,%esp
  102cbb:	6a 00                	push   $0x0
  102cbd:	0f b6 55 01          	movzbl 0x1(%ebp),%edx
  102cc1:	52                   	push   %edx
  102cc2:	ff 75 04             	pushl  0x4(%ebp)
            p += sizeof(struct mpioapic);
  102cc5:	89 fd                	mov    %edi,%ebp
            ioapic_register((uintptr_t) mpio->addr, mpio->apicno, 0);
  102cc7:	e8 24 f8 ff ff       	call   1024f0 <ioapic_register>
            continue;
  102ccc:	83 c4 10             	add    $0x10,%esp
  102ccf:	e9 ff fe ff ff       	jmp    102bd3 <pcpu_mp_init+0x353>
  102cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        KERN_DEBUG("Not found MADT.\n");
  102cd8:	83 ec 04             	sub    $0x4,%esp
  102cdb:	68 91 99 10 00       	push   $0x109991
  102ce0:	68 5e 01 00 00       	push   $0x15e
  102ce5:	68 68 99 10 00       	push   $0x109968
  102cea:	e8 11 0b 00 00       	call   103800 <debug_normal>
        goto fallback;
  102cef:	83 c4 10             	add    $0x10,%esp
  102cf2:	e9 d3 fd ff ff       	jmp    102aca <pcpu_mp_init+0x24a>
  102cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102cfe:	66 90                	xchg   %ax,%ax
            KERN_INFO("\tCPU%d: APIC id = %x, ", ncpu, proc->apicid);
  102d00:	0f b6 55 01          	movzbl 0x1(%ebp),%edx
  102d04:	83 ec 04             	sub    $0x4,%esp
  102d07:	52                   	push   %edx
  102d08:	ff 35 6c ce 14 00    	pushl  0x14ce6c
  102d0e:	68 a2 99 10 00       	push   $0x1099a2
  102d13:	e8 b8 0a 00 00       	call   1037d0 <debug_info>
            if (proc->flags & MPBOOT) {
  102d18:	83 c4 10             	add    $0x10,%esp
  102d1b:	f6 45 03 02          	testb  $0x2,0x3(%ebp)
  102d1f:	75 38                	jne    102d59 <pcpu_mp_init+0x4d9>
                KERN_INFO("AP.\n");
  102d21:	83 ec 0c             	sub    $0xc,%esp
  102d24:	68 cd 99 10 00       	push   $0x1099cd
  102d29:	e8 a2 0a 00 00       	call   1037d0 <debug_info>
                pcpu_mp_init_cpu(ap_idx, proc->apicid, FALSE);
  102d2e:	0f b6 55 01          	movzbl 0x1(%ebp),%edx
  102d32:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
  102d36:	31 c9                	xor    %ecx,%ecx
  102d38:	89 e8                	mov    %ebp,%eax
  102d3a:	e8 71 fa ff ff       	call   1027b0 <pcpu_mp_init_cpu>
                ap_idx++;
  102d3f:	89 e8                	mov    %ebp,%eax
  102d41:	83 c0 01             	add    $0x1,%eax
  102d44:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  102d48:	83 c4 10             	add    $0x10,%esp
            ncpu++;
  102d4b:	83 05 6c ce 14 00 01 	addl   $0x1,0x14ce6c
            p += sizeof(struct mpproc);
  102d52:	89 fd                	mov    %edi,%ebp
            continue;
  102d54:	e9 7a fe ff ff       	jmp    102bd3 <pcpu_mp_init+0x353>
                KERN_INFO("BSP.\n");
  102d59:	83 ec 0c             	sub    $0xc,%esp
  102d5c:	68 c7 99 10 00       	push   $0x1099c7
  102d61:	e8 6a 0a 00 00       	call   1037d0 <debug_info>
                pcpu_mp_init_cpu(0, proc->apicid, TRUE);
  102d66:	0f b6 55 01          	movzbl 0x1(%ebp),%edx
  102d6a:	b9 01 00 00 00       	mov    $0x1,%ecx
  102d6f:	31 c0                	xor    %eax,%eax
  102d71:	e8 3a fa ff ff       	call   1027b0 <pcpu_mp_init_cpu>
  102d76:	83 c4 10             	add    $0x10,%esp
  102d79:	eb d0                	jmp    102d4b <pcpu_mp_init+0x4cb>
        outb(0x22, 0x70);
  102d7b:	83 ec 08             	sub    $0x8,%esp
  102d7e:	6a 70                	push   $0x70
  102d80:	6a 22                	push   $0x22
  102d82:	e8 09 18 00 00       	call   104590 <outb>
        outb(0x23, inb(0x23) | 1);
  102d87:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
  102d8e:	e8 cd 17 00 00       	call   104560 <inb>
  102d93:	5a                   	pop    %edx
  102d94:	59                   	pop    %ecx
  102d95:	83 c8 01             	or     $0x1,%eax
  102d98:	0f b6 c0             	movzbl %al,%eax
  102d9b:	50                   	push   %eax
  102d9c:	6a 23                	push   $0x23
  102d9e:	e8 ed 17 00 00       	call   104590 <outb>
  102da3:	83 c4 10             	add    $0x10,%esp
  102da6:	e9 bf fe ff ff       	jmp    102c6a <pcpu_mp_init+0x3ea>
        KERN_DEBUG("Not found either RSDT or XSDT.\n");
  102dab:	83 ec 04             	sub    $0x4,%esp
  102dae:	68 84 97 10 00       	push   $0x109784
  102db3:	68 56 01 00 00       	push   $0x156
  102db8:	68 68 99 10 00       	push   $0x109968
  102dbd:	e8 3e 0a 00 00       	call   103800 <debug_normal>
        goto fallback;
  102dc2:	83 c4 10             	add    $0x10,%esp
  102dc5:	e9 00 fd ff ff       	jmp    102aca <pcpu_mp_init+0x24a>
  102dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102dd0 <pcpu_init_cpu>:
    KERN_ASSERT(get_pcpu_boot_info(cpu_idx) == TRUE);
    return 0;
}

void pcpu_init_cpu(void)
{
  102dd0:	55                   	push   %ebp
  102dd1:	57                   	push   %edi
  102dd2:	56                   	push   %esi
  102dd3:	53                   	push   %ebx
  102dd4:	83 ec 4c             	sub    $0x4c,%esp
    int cpu_idx = get_pcpu_idx();
  102dd7:	e8 54 2c 00 00       	call   105a30 <get_pcpu_idx>
    struct pcpuinfo *cpuinfo = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  102ddc:	83 ec 0c             	sub    $0xc,%esp
  102ddf:	50                   	push   %eax
  102de0:	e8 3b 2d 00 00       	call   105b20 <get_pcpu_arch_info_pointer>
    uint32_t *regs[4] = { &eax, &ebx, &ecx, &edx };
  102de5:	8d 74 24 3c          	lea    0x3c(%esp),%esi
  102de9:	8d 6c 24 34          	lea    0x34(%esp),%ebp
    struct pcpuinfo *cpuinfo = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  102ded:	89 c3                	mov    %eax,%ebx
    uint32_t *regs[4] = { &eax, &ebx, &ecx, &edx };
  102def:	8d 44 24 38          	lea    0x38(%esp),%eax
  102df3:	89 6c 24 44          	mov    %ebp,0x44(%esp)
  102df7:	89 44 24 48          	mov    %eax,0x48(%esp)
    cpuid(0x0, &eax, &ebx, &ecx, &edx);
  102dfb:	8d 44 24 38          	lea    0x38(%esp),%eax
    uint32_t *regs[4] = { &eax, &ebx, &ecx, &edx };
  102dff:	89 74 24 4c          	mov    %esi,0x4c(%esp)
    cpuid(0x0, &eax, &ebx, &ecx, &edx);
  102e03:	89 34 24             	mov    %esi,(%esp)
  102e06:	50                   	push   %eax
  102e07:	55                   	push   %ebp
  102e08:	8d 44 24 38          	lea    0x38(%esp),%eax
  102e0c:	50                   	push   %eax
  102e0d:	6a 00                	push   $0x0
  102e0f:	e8 1c 16 00 00       	call   104430 <cpuid>
    cpuinfo->cpuid_high = eax;
  102e14:	8b 44 24 40          	mov    0x40(%esp),%eax
    cpuinfo->vendor[12] = '\0';
  102e18:	c6 43 18 00          	movb   $0x0,0x18(%ebx)
    cpuinfo->cpuid_high = eax;
  102e1c:	89 43 08             	mov    %eax,0x8(%ebx)
    ((uint32_t *) cpuinfo->vendor)[0] = ebx;
  102e1f:	8b 44 24 44          	mov    0x44(%esp),%eax
  102e23:	89 43 0c             	mov    %eax,0xc(%ebx)
    ((uint32_t *) cpuinfo->vendor)[1] = edx;
  102e26:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  102e2a:	89 43 10             	mov    %eax,0x10(%ebx)
    ((uint32_t *) cpuinfo->vendor)[2] = ecx;
  102e2d:	8b 44 24 48          	mov    0x48(%esp),%eax
  102e31:	89 43 14             	mov    %eax,0x14(%ebx)
    if (strncmp(cpuinfo->vendor, "GenuineIntel", 20) == 0)
  102e34:	8d 43 0c             	lea    0xc(%ebx),%eax
  102e37:	89 44 24 24          	mov    %eax,0x24(%esp)
  102e3b:	83 c4 1c             	add    $0x1c,%esp
  102e3e:	6a 14                	push   $0x14
  102e40:	68 07 9a 10 00       	push   $0x109a07
  102e45:	50                   	push   %eax
  102e46:	e8 b5 07 00 00       	call   103600 <strncmp>
  102e4b:	83 c4 10             	add    $0x10,%esp
  102e4e:	85 c0                	test   %eax,%eax
  102e50:	0f 85 aa 02 00 00    	jne    103100 <pcpu_init_cpu+0x330>
        cpuinfo->cpu_vendor = INTEL;
  102e56:	c7 43 20 01 00 00 00 	movl   $0x1,0x20(%ebx)
    cpuid(0x1, &eax, &ebx, &ecx, &edx);
  102e5d:	83 ec 0c             	sub    $0xc,%esp
  102e60:	56                   	push   %esi
  102e61:	8d 44 24 38          	lea    0x38(%esp),%eax
  102e65:	50                   	push   %eax
  102e66:	55                   	push   %ebp
  102e67:	8d 44 24 38          	lea    0x38(%esp),%eax
  102e6b:	50                   	push   %eax
  102e6c:	6a 01                	push   $0x1
  102e6e:	e8 bd 15 00 00       	call   104430 <cpuid>
    cpuinfo->family = (eax >> 8) & 0xf;
  102e73:	8b 44 24 40          	mov    0x40(%esp),%eax
  102e77:	89 c2                	mov    %eax,%edx
  102e79:	c1 ea 08             	shr    $0x8,%edx
  102e7c:	83 e2 0f             	and    $0xf,%edx
  102e7f:	88 53 24             	mov    %dl,0x24(%ebx)
    cpuinfo->model = (eax >> 4) & 0xf;
  102e82:	89 c2                	mov    %eax,%edx
  102e84:	c0 ea 04             	shr    $0x4,%dl
  102e87:	88 53 25             	mov    %dl,0x25(%ebx)
    cpuinfo->step = eax & 0xf;
  102e8a:	89 c2                	mov    %eax,%edx
  102e8c:	83 e2 0f             	and    $0xf,%edx
  102e8f:	88 53 26             	mov    %dl,0x26(%ebx)
    cpuinfo->ext_family = (eax >> 20) & 0xff;
  102e92:	89 c2                	mov    %eax,%edx
    cpuinfo->ext_model = (eax >> 16) & 0xff;
  102e94:	c1 e8 10             	shr    $0x10,%eax
  102e97:	88 43 28             	mov    %al,0x28(%ebx)
    cpuinfo->brand_idx = ebx & 0xff;
  102e9a:	8b 44 24 44          	mov    0x44(%esp),%eax
    cpuinfo->ext_family = (eax >> 20) & 0xff;
  102e9e:	c1 ea 14             	shr    $0x14,%edx
  102ea1:	88 53 27             	mov    %dl,0x27(%ebx)
    cpuinfo->brand_idx = ebx & 0xff;
  102ea4:	89 43 29             	mov    %eax,0x29(%ebx)
    cpuinfo->feature1 = ecx;
  102ea7:	8b 44 24 48          	mov    0x48(%esp),%eax
  102eab:	89 43 30             	mov    %eax,0x30(%ebx)
    cpuinfo->feature2 = edx;
  102eae:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    switch (cpuinfo->cpu_vendor) {
  102eb2:	83 c4 20             	add    $0x20,%esp
    cpuinfo->feature2 = edx;
  102eb5:	89 43 34             	mov    %eax,0x34(%ebx)
    switch (cpuinfo->cpu_vendor) {
  102eb8:	8b 43 20             	mov    0x20(%ebx),%eax
  102ebb:	83 f8 01             	cmp    $0x1,%eax
  102ebe:	0f 84 1c 01 00 00    	je     102fe0 <pcpu_init_cpu+0x210>
  102ec4:	83 f8 02             	cmp    $0x2,%eax
  102ec7:	0f 84 a3 01 00 00    	je     103070 <pcpu_init_cpu+0x2a0>
        cpuinfo->l1_cache_size = 0;
  102ecd:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
        cpuinfo->l1_cache_line_size = 0;
  102ed4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    cpuid(0x80000000, &eax, &ebx, &ecx, &edx);
  102edb:	83 ec 0c             	sub    $0xc,%esp
  102ede:	56                   	push   %esi
    KERN_INFO("CPU%d: %s, FAMILY %d(%d), MODEL %d(%d), STEP %d, "
  102edf:	be 01 9a 10 00       	mov    $0x109a01,%esi
    cpuid(0x80000000, &eax, &ebx, &ecx, &edx);
  102ee4:	8d 44 24 38          	lea    0x38(%esp),%eax
  102ee8:	50                   	push   %eax
  102ee9:	55                   	push   %ebp
  102eea:	8d 44 24 38          	lea    0x38(%esp),%eax
  102eee:	50                   	push   %eax
  102eef:	68 00 00 00 80       	push   $0x80000000
  102ef4:	e8 37 15 00 00       	call   104430 <cpuid>
    cpuinfo->cpuid_exthigh = eax;
  102ef9:	8b 44 24 40          	mov    0x40(%esp),%eax
    pcpu_print_cpuinfo(get_pcpu_idx(), cpuinfo);
  102efd:	83 c4 20             	add    $0x20,%esp
    cpuinfo->cpuid_exthigh = eax;
  102f00:	89 43 40             	mov    %eax,0x40(%ebx)
    pcpu_print_cpuinfo(get_pcpu_idx(), cpuinfo);
  102f03:	e8 28 2b 00 00       	call   105a30 <get_pcpu_idx>
    KERN_INFO("CPU%d: %s, FAMILY %d(%d), MODEL %d(%d), STEP %d, "
  102f08:	8b 53 30             	mov    0x30(%ebx),%edx
  102f0b:	b9 d2 99 10 00       	mov    $0x1099d2,%ecx
    pcpu_print_cpuinfo(get_pcpu_idx(), cpuinfo);
  102f10:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    KERN_INFO("CPU%d: %s, FAMILY %d(%d), MODEL %d(%d), STEP %d, "
  102f14:	8b 43 38             	mov    0x38(%ebx),%eax
  102f17:	f7 c2 00 00 80 00    	test   $0x800000,%edx
  102f1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f21:	b8 71 a7 10 00       	mov    $0x10a771,%eax
  102f26:	0f 44 c8             	cmove  %eax,%ecx
  102f29:	f7 c2 00 00 10 00    	test   $0x100000,%edx
  102f2f:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  102f33:	b9 db 99 10 00       	mov    $0x1099db,%ecx
  102f38:	89 cf                	mov    %ecx,%edi
  102f3a:	b9 e3 99 10 00       	mov    $0x1099e3,%ecx
  102f3f:	0f 44 f8             	cmove  %eax,%edi
  102f42:	f7 c2 00 00 08 00    	test   $0x80000,%edx
  102f48:	0f 44 c8             	cmove  %eax,%ecx
  102f4b:	f6 c6 02             	test   $0x2,%dh
  102f4e:	89 7c 24 14          	mov    %edi,0x14(%esp)
  102f52:	bf fa 99 10 00       	mov    $0x1099fa,%edi
  102f57:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  102f5b:	b9 eb 99 10 00       	mov    $0x1099eb,%ecx
  102f60:	89 cd                	mov    %ecx,%ebp
  102f62:	8b 4b 34             	mov    0x34(%ebx),%ecx
  102f65:	0f 44 e8             	cmove  %eax,%ebp
  102f68:	f6 c2 01             	test   $0x1,%dl
  102f6b:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
  102f6f:	bd f3 99 10 00       	mov    $0x1099f3,%ebp
  102f74:	0f 44 e8             	cmove  %eax,%ebp
  102f77:	f7 c1 00 00 00 04    	test   $0x4000000,%ecx
  102f7d:	0f 44 f8             	cmove  %eax,%edi
  102f80:	f7 c1 00 00 00 02    	test   $0x2000000,%ecx
  102f86:	0f 45 c6             	cmovne %esi,%eax
  102f89:	83 ec 04             	sub    $0x4,%esp
  102f8c:	ff 73 3c             	pushl  0x3c(%ebx)
  102f8f:	ff 74 24 10          	pushl  0x10(%esp)
  102f93:	ff 74 24 24          	pushl  0x24(%esp)
  102f97:	ff 74 24 24          	pushl  0x24(%esp)
  102f9b:	ff 74 24 24          	pushl  0x24(%esp)
  102f9f:	ff 74 24 24          	pushl  0x24(%esp)
  102fa3:	55                   	push   %ebp
  102fa4:	57                   	push   %edi
  102fa5:	50                   	push   %eax
  102fa6:	51                   	push   %ecx
  102fa7:	52                   	push   %edx
  102fa8:	0f b6 43 26          	movzbl 0x26(%ebx),%eax
  102fac:	50                   	push   %eax
  102fad:	0f b6 43 28          	movzbl 0x28(%ebx),%eax
  102fb1:	50                   	push   %eax
  102fb2:	0f b6 43 25          	movzbl 0x25(%ebx),%eax
  102fb6:	50                   	push   %eax
  102fb7:	0f b6 43 27          	movzbl 0x27(%ebx),%eax
  102fbb:	50                   	push   %eax
  102fbc:	0f b6 43 24          	movzbl 0x24(%ebx),%eax
  102fc0:	50                   	push   %eax
  102fc1:	ff 74 24 48          	pushl  0x48(%esp)
  102fc5:	ff 74 24 64          	pushl  0x64(%esp)
  102fc9:	68 40 98 10 00       	push   $0x109840
  102fce:	e8 fd 07 00 00       	call   1037d0 <debug_info>
    pcpu_identify();
}
  102fd3:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  102fd9:	5b                   	pop    %ebx
  102fda:	5e                   	pop    %esi
  102fdb:	5f                   	pop    %edi
  102fdc:	5d                   	pop    %ebp
  102fdd:	c3                   	ret    
  102fde:	66 90                	xchg   %ax,%ax
        cpuid(0x00000002, &eax, &ebx, &ecx, &edx);
  102fe0:	83 ec 0c             	sub    $0xc,%esp
  102fe3:	56                   	push   %esi
  102fe4:	8d 44 24 38          	lea    0x38(%esp),%eax
  102fe8:	50                   	push   %eax
  102fe9:	55                   	push   %ebp
  102fea:	8d 44 24 38          	lea    0x38(%esp),%eax
  102fee:	50                   	push   %eax
  102fef:	6a 02                	push   $0x2
  102ff1:	e8 3a 14 00 00       	call   104430 <cpuid>
        i = eax & 0x000000ff;
  102ff6:	0f b6 44 24 40       	movzbl 0x40(%esp),%eax
        while (i--)
  102ffb:	83 c4 20             	add    $0x20,%esp
  102ffe:	8d 78 ff             	lea    -0x1(%eax),%edi
  103001:	85 c0                	test   %eax,%eax
  103003:	74 24                	je     103029 <pcpu_init_cpu+0x259>
  103005:	8d 76 00             	lea    0x0(%esi),%esi
            cpuid(0x00000002, &eax, &ebx, &ecx, &edx);
  103008:	83 ec 0c             	sub    $0xc,%esp
        while (i--)
  10300b:	83 ef 01             	sub    $0x1,%edi
            cpuid(0x00000002, &eax, &ebx, &ecx, &edx);
  10300e:	56                   	push   %esi
  10300f:	8d 44 24 38          	lea    0x38(%esp),%eax
  103013:	50                   	push   %eax
  103014:	55                   	push   %ebp
  103015:	8d 44 24 38          	lea    0x38(%esp),%eax
  103019:	50                   	push   %eax
  10301a:	6a 02                	push   $0x2
  10301c:	e8 0f 14 00 00       	call   104430 <cpuid>
        while (i--)
  103021:	83 c4 20             	add    $0x20,%esp
  103024:	83 ff ff             	cmp    $0xffffffff,%edi
  103027:	75 df                	jne    103008 <pcpu_init_cpu+0x238>
  103029:	8d 54 24 30          	lea    0x30(%esp),%edx
{
  10302d:	8d 44 24 20          	lea    0x20(%esp),%eax
            for (j = 0; j < 4; j++) {
  103031:	8d 78 04             	lea    0x4(%eax),%edi
  103034:	89 7c 24 08          	mov    %edi,0x8(%esp)
                cpuinfo->l1_cache_size = intel_cache_info[desc[j]][0];
  103038:	0f b6 08             	movzbl (%eax),%ecx
  10303b:	83 c0 01             	add    $0x1,%eax
  10303e:	8b 0c cd 40 9a 10 00 	mov    0x109a40(,%ecx,8),%ecx
  103045:	89 4b 38             	mov    %ecx,0x38(%ebx)
                cpuinfo->l1_cache_line_size = intel_cache_info[desc[j]][1];
  103048:	0f b6 78 ff          	movzbl -0x1(%eax),%edi
  10304c:	8b 3c fd 44 9a 10 00 	mov    0x109a44(,%edi,8),%edi
  103053:	89 7b 3c             	mov    %edi,0x3c(%ebx)
            for (j = 0; j < 4; j++) {
  103056:	39 44 24 08          	cmp    %eax,0x8(%esp)
  10305a:	75 dc                	jne    103038 <pcpu_init_cpu+0x268>
        for (i = 0; i < 4; i++) {
  10305c:	83 c2 04             	add    $0x4,%edx
  10305f:	8d 44 24 40          	lea    0x40(%esp),%eax
  103063:	39 c2                	cmp    %eax,%edx
  103065:	74 41                	je     1030a8 <pcpu_init_cpu+0x2d8>
  103067:	8b 02                	mov    (%edx),%eax
  103069:	eb c6                	jmp    103031 <pcpu_init_cpu+0x261>
  10306b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10306f:	90                   	nop
        cpuid(0x80000005, &eax, &ebx, &ecx, &edx);
  103070:	83 ec 0c             	sub    $0xc,%esp
  103073:	56                   	push   %esi
  103074:	8d 44 24 38          	lea    0x38(%esp),%eax
  103078:	50                   	push   %eax
  103079:	55                   	push   %ebp
  10307a:	8d 44 24 38          	lea    0x38(%esp),%eax
  10307e:	50                   	push   %eax
  10307f:	68 05 00 00 80       	push   $0x80000005
  103084:	e8 a7 13 00 00       	call   104430 <cpuid>
        cpuinfo->l1_cache_size = (ecx & 0xff000000) >> 24;
  103089:	8b 44 24 48          	mov    0x48(%esp),%eax
        break;
  10308d:	83 c4 20             	add    $0x20,%esp
        cpuinfo->l1_cache_size = (ecx & 0xff000000) >> 24;
  103090:	89 c2                	mov    %eax,%edx
        cpuinfo->l1_cache_line_size = (ecx & 0x000000ff);
  103092:	25 ff 00 00 00       	and    $0xff,%eax
        cpuinfo->l1_cache_size = (ecx & 0xff000000) >> 24;
  103097:	c1 ea 18             	shr    $0x18,%edx
        cpuinfo->l1_cache_line_size = (ecx & 0x000000ff);
  10309a:	89 43 3c             	mov    %eax,0x3c(%ebx)
        cpuinfo->l1_cache_size = (ecx & 0xff000000) >> 24;
  10309d:	89 53 38             	mov    %edx,0x38(%ebx)
        break;
  1030a0:	e9 36 fe ff ff       	jmp    102edb <pcpu_init_cpu+0x10b>
  1030a5:	8d 76 00             	lea    0x0(%esi),%esi
        if (cpuinfo->l1_cache_size && cpuinfo->l1_cache_line_size)
  1030a8:	85 c9                	test   %ecx,%ecx
  1030aa:	0f 85 80 00 00 00    	jne    103130 <pcpu_init_cpu+0x360>
  1030b0:	31 ff                	xor    %edi,%edi
            cpuid_subleaf(0x00000004, i, &eax, &ebx, &ecx, &edx);
  1030b2:	83 ec 08             	sub    $0x8,%esp
  1030b5:	56                   	push   %esi
  1030b6:	8d 44 24 34          	lea    0x34(%esp),%eax
  1030ba:	50                   	push   %eax
  1030bb:	55                   	push   %ebp
  1030bc:	8d 44 24 34          	lea    0x34(%esp),%eax
  1030c0:	50                   	push   %eax
  1030c1:	57                   	push   %edi
  1030c2:	6a 04                	push   $0x4
  1030c4:	e8 a7 13 00 00       	call   104470 <cpuid_subleaf>
            if ((eax & 0xf) == 1 && ((eax & 0xe0) >> 5) == 1)
  1030c9:	8b 44 24 40          	mov    0x40(%esp),%eax
  1030cd:	83 c4 20             	add    $0x20,%esp
  1030d0:	89 c2                	mov    %eax,%edx
  1030d2:	83 e2 0f             	and    $0xf,%edx
  1030d5:	83 fa 01             	cmp    $0x1,%edx
  1030d8:	74 66                	je     103140 <pcpu_init_cpu+0x370>
        for (i = 0; i < 3; i++) {
  1030da:	83 c7 01             	add    $0x1,%edi
  1030dd:	83 ff 03             	cmp    $0x3,%edi
  1030e0:	75 d0                	jne    1030b2 <pcpu_init_cpu+0x2e2>
            KERN_WARN("Cannot determine L1 cache size.\n");
  1030e2:	83 ec 04             	sub    $0x4,%esp
  1030e5:	68 b0 98 10 00       	push   $0x1098b0
  1030ea:	6a 7c                	push   $0x7c
  1030ec:	68 68 99 10 00       	push   $0x109968
  1030f1:	e8 2a 08 00 00       	call   103920 <debug_warn>
            break;
  1030f6:	83 c4 10             	add    $0x10,%esp
  1030f9:	e9 dd fd ff ff       	jmp    102edb <pcpu_init_cpu+0x10b>
  1030fe:	66 90                	xchg   %ax,%ax
    else if (strncmp(cpuinfo->vendor, "AuthenticAMD", 20) == 0)
  103100:	83 ec 04             	sub    $0x4,%esp
  103103:	6a 14                	push   $0x14
  103105:	68 14 9a 10 00       	push   $0x109a14
  10310a:	ff 74 24 10          	pushl  0x10(%esp)
  10310e:	e8 ed 04 00 00       	call   103600 <strncmp>
  103113:	83 c4 10             	add    $0x10,%esp
        cpuinfo->cpu_vendor = AMD;
  103116:	85 c0                	test   %eax,%eax
  103118:	0f 94 c0             	sete   %al
  10311b:	0f b6 c0             	movzbl %al,%eax
  10311e:	01 c0                	add    %eax,%eax
  103120:	89 43 20             	mov    %eax,0x20(%ebx)
  103123:	e9 35 fd ff ff       	jmp    102e5d <pcpu_init_cpu+0x8d>
  103128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10312f:	90                   	nop
        if (cpuinfo->l1_cache_size && cpuinfo->l1_cache_line_size)
  103130:	85 ff                	test   %edi,%edi
  103132:	0f 85 a3 fd ff ff    	jne    102edb <pcpu_init_cpu+0x10b>
  103138:	e9 75 ff ff ff       	jmp    1030b2 <pcpu_init_cpu+0x2e2>
  10313d:	8d 76 00             	lea    0x0(%esi),%esi
            if ((eax & 0xf) == 1 && ((eax & 0xe0) >> 5) == 1)
  103140:	c1 e8 05             	shr    $0x5,%eax
  103143:	83 e0 07             	and    $0x7,%eax
  103146:	83 f8 01             	cmp    $0x1,%eax
  103149:	75 8f                	jne    1030da <pcpu_init_cpu+0x30a>
            (((ebx & 0xffc00000) >> 22) + 1) *  /* ways */
  10314b:	8b 7c 24 24          	mov    0x24(%esp),%edi
            (ecx + 1) /                         /* sets */
  10314f:	8b 54 24 28          	mov    0x28(%esp),%edx
            (((ebx & 0x00000fff)) + 1) *        /* line size */
  103153:	89 f9                	mov    %edi,%ecx
            (((ebx & 0xffc00000) >> 22) + 1) *  /* ways */
  103155:	89 f8                	mov    %edi,%eax
            (ecx + 1) /                         /* sets */
  103157:	83 c2 01             	add    $0x1,%edx
            (((ebx & 0x003ff000) >> 12) + 1) *  /* partitions */
  10315a:	c1 ef 0c             	shr    $0xc,%edi
            (((ebx & 0x00000fff)) + 1) *        /* line size */
  10315d:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
            (((ebx & 0xffc00000) >> 22) + 1) *  /* ways */
  103163:	c1 e8 16             	shr    $0x16,%eax
            (((ebx & 0x00000fff)) + 1) *        /* line size */
  103166:	83 c1 01             	add    $0x1,%ecx
            (((ebx & 0xffc00000) >> 22) + 1) *  /* ways */
  103169:	83 c0 01             	add    $0x1,%eax
            (((ebx & 0x00000fff)) + 1) *        /* line size */
  10316c:	0f af c1             	imul   %ecx,%eax
        cpuinfo->l1_cache_line_size = ((ebx & 0x00000fff)) + 1;
  10316f:	89 4b 3c             	mov    %ecx,0x3c(%ebx)
            (((ebx & 0x00000fff)) + 1) *        /* line size */
  103172:	0f af c2             	imul   %edx,%eax
            (((ebx & 0x003ff000) >> 12) + 1) *  /* partitions */
  103175:	89 fa                	mov    %edi,%edx
  103177:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  10317d:	83 c2 01             	add    $0x1,%edx
            (((ebx & 0x00000fff)) + 1) *        /* line size */
  103180:	0f af c2             	imul   %edx,%eax
            (ecx + 1) /                         /* sets */
  103183:	c1 e8 0a             	shr    $0xa,%eax
  103186:	89 43 38             	mov    %eax,0x38(%ebx)
        break;
  103189:	e9 4d fd ff ff       	jmp    102edb <pcpu_init_cpu+0x10b>
  10318e:	66 90                	xchg   %ax,%ax

00103190 <pcpu_ncpu>:

uint32_t pcpu_ncpu(void)
{
    return ncpu;
}
  103190:	a1 6c ce 14 00       	mov    0x14ce6c,%eax
  103195:	c3                   	ret    
  103196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10319d:	8d 76 00             	lea    0x0(%esi),%esi

001031a0 <pcpu_is_smp>:

bool pcpu_is_smp(void)
{
    return ismp;
}
  1031a0:	0f b6 05 68 ce 14 00 	movzbl 0x14ce68,%eax
  1031a7:	c3                   	ret    
  1031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1031af:	90                   	nop

001031b0 <pcpu_onboot>:

bool pcpu_onboot(void)
{
  1031b0:	83 ec 0c             	sub    $0xc,%esp
    int cpu_idx = get_pcpu_idx();
  1031b3:	e8 78 28 00 00       	call   105a30 <get_pcpu_idx>
    struct pcpuinfo *arch_info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  1031b8:	83 ec 0c             	sub    $0xc,%esp
  1031bb:	50                   	push   %eax
  1031bc:	e8 5f 29 00 00       	call   105b20 <get_pcpu_arch_info_pointer>
    return (mp_inited == TRUE) ? arch_info->bsp : (get_pcpu_idx() == 0);
  1031c1:	83 c4 10             	add    $0x10,%esp
  1031c4:	80 3d 69 ce 14 00 01 	cmpb   $0x1,0x14ce69
  1031cb:	75 0b                	jne    1031d8 <pcpu_onboot+0x28>
  1031cd:	0f b6 40 04          	movzbl 0x4(%eax),%eax
}
  1031d1:	83 c4 0c             	add    $0xc,%esp
  1031d4:	c3                   	ret    
  1031d5:	8d 76 00             	lea    0x0(%esi),%esi
    return (mp_inited == TRUE) ? arch_info->bsp : (get_pcpu_idx() == 0);
  1031d8:	e8 53 28 00 00       	call   105a30 <get_pcpu_idx>
  1031dd:	85 c0                	test   %eax,%eax
  1031df:	0f 94 c0             	sete   %al
}
  1031e2:	83 c4 0c             	add    $0xc,%esp
  1031e5:	c3                   	ret    
  1031e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1031ed:	8d 76 00             	lea    0x0(%esi),%esi

001031f0 <pcpu_cpu_lapicid>:

lapicid_t pcpu_cpu_lapicid(int cpu_idx)
{
  1031f0:	56                   	push   %esi
  1031f1:	53                   	push   %ebx
  1031f2:	83 ec 10             	sub    $0x10,%esp
  1031f5:	8b 74 24 1c          	mov    0x1c(%esp),%esi
    struct pcpuinfo *arch_info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  1031f9:	56                   	push   %esi
  1031fa:	e8 21 29 00 00       	call   105b20 <get_pcpu_arch_info_pointer>
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < ncpu);
  1031ff:	83 c4 10             	add    $0x10,%esp
    struct pcpuinfo *arch_info = (struct pcpuinfo *) get_pcpu_arch_info_pointer(cpu_idx);
  103202:	89 c3                	mov    %eax,%ebx
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < ncpu);
  103204:	85 f6                	test   %esi,%esi
  103206:	78 08                	js     103210 <pcpu_cpu_lapicid+0x20>
  103208:	3b 35 6c ce 14 00    	cmp    0x14ce6c,%esi
  10320e:	72 1c                	jb     10322c <pcpu_cpu_lapicid+0x3c>
  103210:	68 d4 98 10 00       	push   $0x1098d4
  103215:	68 df 92 10 00       	push   $0x1092df
  10321a:	68 ea 01 00 00       	push   $0x1ea
  10321f:	68 68 99 10 00       	push   $0x109968
  103224:	e8 27 06 00 00       	call   103850 <debug_panic>
  103229:	83 c4 10             	add    $0x10,%esp
    return arch_info->lapicid;
  10322c:	8b 03                	mov    (%ebx),%eax
}
  10322e:	83 c4 04             	add    $0x4,%esp
  103231:	5b                   	pop    %ebx
  103232:	5e                   	pop    %esi
  103233:	c3                   	ret    
  103234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10323b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10323f:	90                   	nop

00103240 <pcpu_boot_ap>:
{
  103240:	56                   	push   %esi
  103241:	53                   	push   %ebx
  103242:	83 ec 04             	sub    $0x4,%esp
  103245:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  103249:	8b 74 24 14          	mov    0x14(%esp),%esi
    KERN_ASSERT(cpu_idx > 0 && cpu_idx < pcpu_ncpu());
  10324d:	85 db                	test   %ebx,%ebx
  10324f:	74 57                	je     1032a8 <pcpu_boot_ap+0x68>
  103251:	3b 1d 6c ce 14 00    	cmp    0x14ce6c,%ebx
  103257:	73 4f                	jae    1032a8 <pcpu_boot_ap+0x68>
    KERN_ASSERT(get_pcpu_inited_info(cpu_idx) == TRUE);
  103259:	83 ec 0c             	sub    $0xc,%esp
  10325c:	53                   	push   %ebx
  10325d:	e8 ce 28 00 00       	call   105b30 <get_pcpu_inited_info>
  103262:	83 c4 10             	add    $0x10,%esp
  103265:	3c 01                	cmp    $0x1,%al
  103267:	74 1c                	je     103285 <pcpu_boot_ap+0x45>
  103269:	68 1c 99 10 00       	push   $0x10991c
  10326e:	68 df 92 10 00       	push   $0x1092df
  103273:	68 b8 01 00 00       	push   $0x1b8
  103278:	68 68 99 10 00       	push   $0x109968
  10327d:	e8 ce 05 00 00       	call   103850 <debug_panic>
  103282:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(f != NULL);
  103285:	85 f6                	test   %esi,%esi
  103287:	0f 84 e3 00 00 00    	je     103370 <pcpu_boot_ap+0x130>
    if (pcpu_onboot() == FALSE)
  10328d:	e8 1e ff ff ff       	call   1031b0 <pcpu_onboot>
  103292:	89 c2                	mov    %eax,%edx
        return 1;
  103294:	b8 01 00 00 00       	mov    $0x1,%eax
    if (pcpu_onboot() == FALSE)
  103299:	84 d2                	test   %dl,%dl
  10329b:	75 33                	jne    1032d0 <pcpu_boot_ap+0x90>
}
  10329d:	83 c4 04             	add    $0x4,%esp
  1032a0:	5b                   	pop    %ebx
  1032a1:	5e                   	pop    %esi
  1032a2:	c3                   	ret    
  1032a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1032a7:	90                   	nop
    KERN_ASSERT(cpu_idx > 0 && cpu_idx < pcpu_ncpu());
  1032a8:	68 f4 98 10 00       	push   $0x1098f4
  1032ad:	68 df 92 10 00       	push   $0x1092df
  1032b2:	68 b7 01 00 00       	push   $0x1b7
  1032b7:	68 68 99 10 00       	push   $0x109968
  1032bc:	e8 8f 05 00 00       	call   103850 <debug_panic>
  1032c1:	83 c4 10             	add    $0x10,%esp
  1032c4:	eb 93                	jmp    103259 <pcpu_boot_ap+0x19>
  1032c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1032cd:	8d 76 00             	lea    0x0(%esi),%esi
    if (get_pcpu_boot_info(cpu_idx) == TRUE)
  1032d0:	83 ec 0c             	sub    $0xc,%esp
  1032d3:	53                   	push   %ebx
  1032d4:	e8 d7 27 00 00       	call   105ab0 <get_pcpu_boot_info>
  1032d9:	83 c4 10             	add    $0x10,%esp
  1032dc:	3c 01                	cmp    $0x1,%al
  1032de:	74 65                	je     103345 <pcpu_boot_ap+0x105>
    *(uintptr_t *) (boot - 4) = stack_addr + PAGE_SIZE;
  1032e0:	8b 44 24 18          	mov    0x18(%esp),%eax
    lapic_startcpu(pcpu_cpu_lapicid(cpu_idx), (uintptr_t) boot);
  1032e4:	83 ec 0c             	sub    $0xc,%esp
    *(uintptr_t *) (boot - 8) = (uintptr_t) f;
  1032e7:	89 35 f8 7f 00 00    	mov    %esi,0x7ff8
    *(uintptr_t *) (boot - 12) = (uintptr_t) kern_init_ap;
  1032ed:	c7 05 f4 7f 00 00 d0 	movl   $0x105dd0,0x7ff4
  1032f4:	5d 10 00 
    *(uintptr_t *) (boot - 4) = stack_addr + PAGE_SIZE;
  1032f7:	05 00 10 00 00       	add    $0x1000,%eax
  1032fc:	a3 fc 7f 00 00       	mov    %eax,0x7ffc
    lapic_startcpu(pcpu_cpu_lapicid(cpu_idx), (uintptr_t) boot);
  103301:	53                   	push   %ebx
  103302:	e8 e9 fe ff ff       	call   1031f0 <pcpu_cpu_lapicid>
  103307:	5a                   	pop    %edx
  103308:	59                   	pop    %ecx
  103309:	68 00 80 00 00       	push   $0x8000
  10330e:	0f b6 c0             	movzbl %al,%eax
  103311:	50                   	push   %eax
  103312:	e8 89 f0 ff ff       	call   1023a0 <lapic_startcpu>
    while (get_pcpu_boot_info(cpu_idx) == FALSE)
  103317:	83 c4 10             	add    $0x10,%esp
  10331a:	eb 09                	jmp    103325 <pcpu_boot_ap+0xe5>
  10331c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        pause();
  103320:	e8 9b 10 00 00       	call   1043c0 <pause>
    while (get_pcpu_boot_info(cpu_idx) == FALSE)
  103325:	83 ec 0c             	sub    $0xc,%esp
  103328:	53                   	push   %ebx
  103329:	e8 82 27 00 00       	call   105ab0 <get_pcpu_boot_info>
  10332e:	83 c4 10             	add    $0x10,%esp
  103331:	84 c0                	test   %al,%al
  103333:	74 eb                	je     103320 <pcpu_boot_ap+0xe0>
    KERN_ASSERT(get_pcpu_boot_info(cpu_idx) == TRUE);
  103335:	83 ec 0c             	sub    $0xc,%esp
  103338:	53                   	push   %ebx
  103339:	e8 72 27 00 00       	call   105ab0 <get_pcpu_boot_info>
  10333e:	83 c4 10             	add    $0x10,%esp
  103341:	3c 01                	cmp    $0x1,%al
  103343:	75 0b                	jne    103350 <pcpu_boot_ap+0x110>
    return 0;
  103345:	31 c0                	xor    %eax,%eax
}
  103347:	83 c4 04             	add    $0x4,%esp
  10334a:	5b                   	pop    %ebx
  10334b:	5e                   	pop    %esi
  10334c:	c3                   	ret    
  10334d:	8d 76 00             	lea    0x0(%esi),%esi
    KERN_ASSERT(get_pcpu_boot_info(cpu_idx) == TRUE);
  103350:	68 44 99 10 00       	push   $0x109944
  103355:	68 df 92 10 00       	push   $0x1092df
  10335a:	68 cd 01 00 00       	push   $0x1cd
  10335f:	68 68 99 10 00       	push   $0x109968
  103364:	e8 e7 04 00 00       	call   103850 <debug_panic>
  103369:	83 c4 10             	add    $0x10,%esp
    return 0;
  10336c:	31 c0                	xor    %eax,%eax
  10336e:	eb d7                	jmp    103347 <pcpu_boot_ap+0x107>
    KERN_ASSERT(f != NULL);
  103370:	68 21 9a 10 00       	push   $0x109a21
  103375:	68 df 92 10 00       	push   $0x1092df
  10337a:	68 b9 01 00 00       	push   $0x1b9
  10337f:	68 68 99 10 00       	push   $0x109968
  103384:	e8 c7 04 00 00       	call   103850 <debug_panic>
  103389:	83 c4 10             	add    $0x10,%esp
  10338c:	e9 fc fe ff ff       	jmp    10328d <pcpu_boot_ap+0x4d>
  103391:	66 90                	xchg   %ax,%ax
  103393:	66 90                	xchg   %ax,%ax
  103395:	66 90                	xchg   %ax,%ax
  103397:	66 90                	xchg   %ax,%ax
  103399:	66 90                	xchg   %ax,%ax
  10339b:	66 90                	xchg   %ax,%ax
  10339d:	66 90                	xchg   %ax,%ax
  10339f:	90                   	nop

001033a0 <detect_kvm>:
}

#define CPUID_FEATURE_HYPERVISOR	(1<<31) /* Running on a hypervisor */

int detect_kvm(void)
{
  1033a0:	57                   	push   %edi
	__asm __volatile("cpuid"
  1033a1:	b8 01 00 00 00       	mov    $0x1,%eax
{
  1033a6:	56                   	push   %esi
	__asm __volatile("cpuid"
  1033a7:	31 f6                	xor    %esi,%esi
{
  1033a9:	53                   	push   %ebx
	__asm __volatile("cpuid"
  1033aa:	89 f1                	mov    %esi,%ecx
{
  1033ac:	83 ec 10             	sub    $0x10,%esp
	__asm __volatile("cpuid"
  1033af:	0f a2                	cpuid  
	uint32_t eax;

	if (cpu_has (CPUID_FEATURE_HYPERVISOR))
  1033b1:	83 e2 01             	and    $0x1,%edx
  1033b4:	89 d3                	mov    %edx,%ebx
  1033b6:	75 10                	jne    1033c8 <detect_kvm+0x28>
		{
			return 1;
		}
	}
	return 0;
}
  1033b8:	83 c4 10             	add    $0x10,%esp
  1033bb:	89 d8                	mov    %ebx,%eax
  1033bd:	5b                   	pop    %ebx
  1033be:	5e                   	pop    %esi
  1033bf:	5f                   	pop    %edi
  1033c0:	c3                   	ret    
  1033c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		cpuid (CPUID_KVM_SIGNATURE, &eax, &hyper_vendor_id[0],
  1033c8:	83 ec 0c             	sub    $0xc,%esp
  1033cb:	8d 44 24 18          	lea    0x18(%esp),%eax
  1033cf:	8d 7c 24 10          	lea    0x10(%esp),%edi
  1033d3:	50                   	push   %eax
  1033d4:	8d 44 24 18          	lea    0x18(%esp),%eax
  1033d8:	50                   	push   %eax
  1033d9:	57                   	push   %edi
  1033da:	8d 44 24 18          	lea    0x18(%esp),%eax
  1033de:	50                   	push   %eax
  1033df:	68 00 00 00 40       	push   $0x40000000
  1033e4:	e8 47 10 00 00       	call   104430 <cpuid>
		if (!strncmp ("KVMKVMKVM", (const char *) hyper_vendor_id, 9))
  1033e9:	83 c4 1c             	add    $0x1c,%esp
  1033ec:	6a 09                	push   $0x9
  1033ee:	57                   	push   %edi
  1033ef:	68 38 a2 10 00       	push   $0x10a238
  1033f4:	e8 07 02 00 00       	call   103600 <strncmp>
  1033f9:	83 c4 10             	add    $0x10,%esp
	return 0;
  1033fc:	85 c0                	test   %eax,%eax
  1033fe:	0f 45 de             	cmovne %esi,%ebx
}
  103401:	83 c4 10             	add    $0x10,%esp
  103404:	89 d8                	mov    %ebx,%eax
  103406:	5b                   	pop    %ebx
  103407:	5e                   	pop    %esi
  103408:	5f                   	pop    %edi
  103409:	c3                   	ret    
  10340a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103410 <kvm_has_feature>:

int
kvm_has_feature(uint32_t feature)
{
  103410:	83 ec 28             	sub    $0x28,%esp
	uint32_t eax, ebx, ecx, edx;
	eax = 0; edx = 0;
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103413:	8d 44 24 18          	lea    0x18(%esp),%eax
	eax = 0; edx = 0;
  103417:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10341e:	00 
  10341f:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  103426:	00 
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  103427:	50                   	push   %eax
  103428:	8d 44 24 18          	lea    0x18(%esp),%eax
  10342c:	50                   	push   %eax
  10342d:	8d 44 24 18          	lea    0x18(%esp),%eax
  103431:	50                   	push   %eax
  103432:	8d 44 24 18          	lea    0x18(%esp),%eax
  103436:	50                   	push   %eax
  103437:	68 01 00 00 40       	push   $0x40000001
  10343c:	e8 ef 0f 00 00       	call   104430 <cpuid>

	return ((eax & feature) != 0 ? 1 : 0);
  103441:	8b 44 24 40          	mov    0x40(%esp),%eax
  103445:	85 44 24 20          	test   %eax,0x20(%esp)
  103449:	0f 95 c0             	setne  %al
}
  10344c:	83 c4 3c             	add    $0x3c,%esp
	return ((eax & feature) != 0 ? 1 : 0);
  10344f:	0f b6 c0             	movzbl %al,%eax
}
  103452:	c3                   	ret    
  103453:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103460 <kvm_enable_feature>:

int
kvm_enable_feature(uint32_t feature)
{
  103460:	83 ec 28             	sub    $0x28,%esp
	uint32_t eax, ebx, ecx, edx;
	eax = 1 << feature; edx = 0;
  103463:	b8 01 00 00 00       	mov    $0x1,%eax
  103468:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
  10346c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  103473:	00 
  103474:	d3 e0                	shl    %cl,%eax
  103476:	89 44 24 0c          	mov    %eax,0xc(%esp)
	cpuid(CPUID_KVM_FEATURES, &eax, &ebx, &ecx, &edx);
  10347a:	8d 44 24 18          	lea    0x18(%esp),%eax
  10347e:	50                   	push   %eax
  10347f:	8d 44 24 18          	lea    0x18(%esp),%eax
  103483:	50                   	push   %eax
  103484:	8d 44 24 18          	lea    0x18(%esp),%eax
  103488:	50                   	push   %eax
  103489:	8d 44 24 18          	lea    0x18(%esp),%eax
  10348d:	50                   	push   %eax
  10348e:	68 01 00 00 40       	push   $0x40000001
  103493:	e8 98 0f 00 00       	call   104430 <cpuid>

	return (ebx == 0 ? 1 : 0);
  103498:	8b 54 24 24          	mov    0x24(%esp),%edx
  10349c:	31 c0                	xor    %eax,%eax
  10349e:	85 d2                	test   %edx,%edx
  1034a0:	0f 94 c0             	sete   %al
}
  1034a3:	83 c4 3c             	add    $0x3c,%esp
  1034a6:	c3                   	ret    
  1034a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1034ae:	66 90                	xchg   %ax,%ax

001034b0 <kvm_get_tsc_hz>:

uint64_t
kvm_get_tsc_hz(void)
{
  1034b0:	55                   	push   %ebp
  1034b1:	57                   	push   %edi
  1034b2:	56                   	push   %esi
  1034b3:	53                   	push   %ebx
  1034b4:	83 ec 18             	sub    $0x18,%esp
	uint64_t tsc_hz = 0llu;
	uint32_t msr_sys_time;

	if (kvm_has_feature(KVM_FEATURE_CLOCKSOURCE2))
  1034b7:	6a 03                	push   $0x3
  1034b9:	e8 52 ff ff ff       	call   103410 <kvm_has_feature>
  1034be:	83 c4 10             	add    $0x10,%esp
  1034c1:	85 c0                	test   %eax,%eax
  1034c3:	75 5b                	jne    103520 <kvm_get_tsc_hz+0x70>
	{
		msr_sys_time = MSR_KVM_SYSTEM_TIME_NEW;
	}
	else if (kvm_has_feature(KVM_FEATURE_CLOCKSOURCE))
  1034c5:	83 ec 0c             	sub    $0xc,%esp
	{
		msr_sys_time = MSR_KVM_SYSTEM_TIME;
	}
	else
	{
		return (0llu);
  1034c8:	31 f6                	xor    %esi,%esi
  1034ca:	31 ff                	xor    %edi,%edi
		msr_sys_time = MSR_KVM_SYSTEM_TIME;
  1034cc:	bd 12 00 00 00       	mov    $0x12,%ebp
	else if (kvm_has_feature(KVM_FEATURE_CLOCKSOURCE))
  1034d1:	6a 00                	push   $0x0
  1034d3:	e8 38 ff ff ff       	call   103410 <kvm_has_feature>
  1034d8:	83 c4 10             	add    $0x10,%esp
  1034db:	85 c0                	test   %eax,%eax
  1034dd:	74 31                	je     103510 <kvm_get_tsc_hz+0x60>
	}

	/* bit0 == 1 means enable, kvm will update this memory periodically */
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock) | 0x1llu);
  1034df:	bb c0 d8 9d 00       	mov    $0x9dd8c0,%ebx
  1034e4:	83 ec 04             	sub    $0x4,%esp
  1034e7:	31 d2                	xor    %edx,%edx

	tsc_hz = (uint64_t) pvclock.tsc_to_system_mul;
  1034e9:	31 ff                	xor    %edi,%edi
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock) | 0x1llu);
  1034eb:	89 d8                	mov    %ebx,%eax
  1034ed:	52                   	push   %edx
  1034ee:	83 c8 01             	or     $0x1,%eax
  1034f1:	50                   	push   %eax
  1034f2:	55                   	push   %ebp
  1034f3:	e8 a8 0e 00 00       	call   1043a0 <wrmsr>

	/* disable update */
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock));
  1034f8:	83 c4 0c             	add    $0xc,%esp
  1034fb:	89 d9                	mov    %ebx,%ecx
  1034fd:	31 db                	xor    %ebx,%ebx
  1034ff:	53                   	push   %ebx
	tsc_hz = (uint64_t) pvclock.tsc_to_system_mul;
  103500:	8b 35 d8 d8 9d 00    	mov    0x9dd8d8,%esi
	wrmsr(msr_sys_time, (uint64_t) ((uint32_t) &pvclock));
  103506:	51                   	push   %ecx
  103507:	55                   	push   %ebp
  103508:	e8 93 0e 00 00       	call   1043a0 <wrmsr>

	return tsc_hz;
  10350d:	83 c4 10             	add    $0x10,%esp
}
  103510:	83 c4 0c             	add    $0xc,%esp
  103513:	89 f0                	mov    %esi,%eax
  103515:	89 fa                	mov    %edi,%edx
  103517:	5b                   	pop    %ebx
  103518:	5e                   	pop    %esi
  103519:	5f                   	pop    %edi
  10351a:	5d                   	pop    %ebp
  10351b:	c3                   	ret    
  10351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		msr_sys_time = MSR_KVM_SYSTEM_TIME_NEW;
  103520:	bd 01 4d 56 4b       	mov    $0x4b564d01,%ebp
  103525:	eb b8                	jmp    1034df <kvm_get_tsc_hz+0x2f>
  103527:	66 90                	xchg   %ax,%ax
  103529:	66 90                	xchg   %ax,%ax
  10352b:	66 90                	xchg   %ax,%ax
  10352d:	66 90                	xchg   %ax,%ax
  10352f:	90                   	nop

00103530 <memset>:
#include "string.h"
#include "types.h"

void *memset(void *v, int c, size_t n)
{
  103530:	57                   	push   %edi
  103531:	56                   	push   %esi
  103532:	53                   	push   %ebx
  103533:	8b 4c 24 18          	mov    0x18(%esp),%ecx
  103537:	8b 7c 24 10          	mov    0x10(%esp),%edi
    if (n == 0)
  10353b:	85 c9                	test   %ecx,%ecx
  10353d:	74 28                	je     103567 <memset+0x37>
        return v;
    if ((int) v % 4 == 0 && n % 4 == 0) {
  10353f:	89 f8                	mov    %edi,%eax
  103541:	09 c8                	or     %ecx,%eax
  103543:	a8 03                	test   $0x3,%al
  103545:	75 29                	jne    103570 <memset+0x40>
        c &= 0xFF;
  103547:	0f b6 54 24 14       	movzbl 0x14(%esp),%edx
        c = (c << 24) | (c << 16) | (c << 8) | c;
        asm volatile ("cld; rep stosl\n"
                      :: "D" (v), "a" (c), "c" (n / 4)
  10354c:	c1 e9 02             	shr    $0x2,%ecx
        c = (c << 24) | (c << 16) | (c << 8) | c;
  10354f:	89 d0                	mov    %edx,%eax
  103551:	89 d6                	mov    %edx,%esi
  103553:	89 d3                	mov    %edx,%ebx
  103555:	c1 e0 18             	shl    $0x18,%eax
  103558:	c1 e6 10             	shl    $0x10,%esi
  10355b:	09 f0                	or     %esi,%eax
  10355d:	c1 e3 08             	shl    $0x8,%ebx
  103560:	09 d0                	or     %edx,%eax
  103562:	09 d8                	or     %ebx,%eax
        asm volatile ("cld; rep stosl\n"
  103564:	fc                   	cld    
  103565:	f3 ab                	rep stos %eax,%es:(%edi)
    } else
        asm volatile ("cld; rep stosb\n"
                      :: "D" (v), "a" (c), "c" (n)
                      : "cc", "memory");
    return v;
}
  103567:	89 f8                	mov    %edi,%eax
  103569:	5b                   	pop    %ebx
  10356a:	5e                   	pop    %esi
  10356b:	5f                   	pop    %edi
  10356c:	c3                   	ret    
  10356d:	8d 76 00             	lea    0x0(%esi),%esi
        asm volatile ("cld; rep stosb\n"
  103570:	8b 44 24 14          	mov    0x14(%esp),%eax
  103574:	fc                   	cld    
  103575:	f3 aa                	rep stos %al,%es:(%edi)
}
  103577:	89 f8                	mov    %edi,%eax
  103579:	5b                   	pop    %ebx
  10357a:	5e                   	pop    %esi
  10357b:	5f                   	pop    %edi
  10357c:	c3                   	ret    
  10357d:	8d 76 00             	lea    0x0(%esi),%esi

00103580 <memmove>:

void *memmove(void *dst, const void *src, size_t n)
{
  103580:	57                   	push   %edi
  103581:	56                   	push   %esi
  103582:	8b 44 24 0c          	mov    0xc(%esp),%eax
  103586:	8b 74 24 10          	mov    0x10(%esp),%esi
  10358a:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
  10358e:	39 c6                	cmp    %eax,%esi
  103590:	73 26                	jae    1035b8 <memmove+0x38>
  103592:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  103595:	39 c2                	cmp    %eax,%edx
  103597:	76 1f                	jbe    1035b8 <memmove+0x38>
        s += n;
        d += n;
  103599:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
  10359c:	89 fe                	mov    %edi,%esi
  10359e:	09 ce                	or     %ecx,%esi
  1035a0:	09 d6                	or     %edx,%esi
  1035a2:	83 e6 03             	and    $0x3,%esi
  1035a5:	74 39                	je     1035e0 <memmove+0x60>
            asm volatile ("std; rep movsl\n"
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
                          : "cc", "memory");
        else
            asm volatile ("std; rep movsb\n"
                          :: "D" (d - 1), "S" (s - 1), "c" (n)
  1035a7:	83 ef 01             	sub    $0x1,%edi
  1035aa:	8d 72 ff             	lea    -0x1(%edx),%esi
            asm volatile ("std; rep movsb\n"
  1035ad:	fd                   	std    
  1035ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                          : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile ("cld" ::: "cc");
  1035b0:	fc                   	cld    
            asm volatile ("cld; rep movsb\n"
                          :: "D" (d), "S" (s), "c" (n)
                          : "cc", "memory");
    }
    return dst;
}
  1035b1:	5e                   	pop    %esi
  1035b2:	5f                   	pop    %edi
  1035b3:	c3                   	ret    
  1035b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((int) s % 4 == 0 && (int) d % 4 == 0 && n % 4 == 0)
  1035b8:	89 c2                	mov    %eax,%edx
  1035ba:	09 ca                	or     %ecx,%edx
  1035bc:	09 f2                	or     %esi,%edx
  1035be:	83 e2 03             	and    $0x3,%edx
  1035c1:	74 0d                	je     1035d0 <memmove+0x50>
            asm volatile ("cld; rep movsb\n"
  1035c3:	89 c7                	mov    %eax,%edi
  1035c5:	fc                   	cld    
  1035c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
}
  1035c8:	5e                   	pop    %esi
  1035c9:	5f                   	pop    %edi
  1035ca:	c3                   	ret    
  1035cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1035cf:	90                   	nop
                          :: "D" (d), "S" (s), "c" (n / 4)
  1035d0:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("cld; rep movsl\n"
  1035d3:	89 c7                	mov    %eax,%edi
  1035d5:	fc                   	cld    
  1035d6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1035d8:	eb ee                	jmp    1035c8 <memmove+0x48>
  1035da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                          :: "D" (d - 4), "S" (s - 4), "c" (n / 4)
  1035e0:	83 ef 04             	sub    $0x4,%edi
  1035e3:	8d 72 fc             	lea    -0x4(%edx),%esi
  1035e6:	c1 e9 02             	shr    $0x2,%ecx
            asm volatile ("std; rep movsl\n"
  1035e9:	fd                   	std    
  1035ea:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1035ec:	eb c2                	jmp    1035b0 <memmove+0x30>
  1035ee:	66 90                	xchg   %ax,%ax

001035f0 <memcpy>:

void *memcpy(void *dst, const void *src, size_t n)
{
    return memmove(dst, src, n);
  1035f0:	eb 8e                	jmp    103580 <memmove>
  1035f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1035f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103600 <strncmp>:
}

int strncmp(const char *p, const char *q, size_t n)
{
  103600:	56                   	push   %esi
  103601:	53                   	push   %ebx
  103602:	8b 74 24 14          	mov    0x14(%esp),%esi
  103606:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  10360a:	8b 44 24 10          	mov    0x10(%esp),%eax
    while (n > 0 && *p && *p == *q)
  10360e:	85 f6                	test   %esi,%esi
  103610:	74 2e                	je     103640 <strncmp+0x40>
  103612:	01 c6                	add    %eax,%esi
  103614:	eb 18                	jmp    10362e <strncmp+0x2e>
  103616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10361d:	8d 76 00             	lea    0x0(%esi),%esi
  103620:	38 da                	cmp    %bl,%dl
  103622:	75 14                	jne    103638 <strncmp+0x38>
        n--, p++, q++;
  103624:	83 c0 01             	add    $0x1,%eax
  103627:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q)
  10362a:	39 f0                	cmp    %esi,%eax
  10362c:	74 12                	je     103640 <strncmp+0x40>
  10362e:	0f b6 11             	movzbl (%ecx),%edx
  103631:	0f b6 18             	movzbl (%eax),%ebx
  103634:	84 d2                	test   %dl,%dl
  103636:	75 e8                	jne    103620 <strncmp+0x20>
    if (n == 0)
        return 0;
    else
        return (int) ((unsigned char) *p - (unsigned char) *q);
  103638:	0f b6 c2             	movzbl %dl,%eax
  10363b:	29 d8                	sub    %ebx,%eax
}
  10363d:	5b                   	pop    %ebx
  10363e:	5e                   	pop    %esi
  10363f:	c3                   	ret    
        return 0;
  103640:	31 c0                	xor    %eax,%eax
}
  103642:	5b                   	pop    %ebx
  103643:	5e                   	pop    %esi
  103644:	c3                   	ret    
  103645:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103650 <strnlen>:

int strnlen(const char *s, size_t size)
{
  103650:	8b 54 24 08          	mov    0x8(%esp),%edx
  103654:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    int n;

    for (n = 0; size > 0 && *s != '\0'; s++, size--)
  103658:	31 c0                	xor    %eax,%eax
  10365a:	85 d2                	test   %edx,%edx
  10365c:	75 09                	jne    103667 <strnlen+0x17>
  10365e:	eb 10                	jmp    103670 <strnlen+0x20>
        n++;
  103660:	83 c0 01             	add    $0x1,%eax
    for (n = 0; size > 0 && *s != '\0'; s++, size--)
  103663:	39 d0                	cmp    %edx,%eax
  103665:	74 09                	je     103670 <strnlen+0x20>
  103667:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  10366b:	75 f3                	jne    103660 <strnlen+0x10>
  10366d:	c3                   	ret    
  10366e:	66 90                	xchg   %ax,%ax
    return n;
}
  103670:	c3                   	ret    
  103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10367f:	90                   	nop

00103680 <strcmp>:

int strcmp(const char *p, const char *q)
{
  103680:	53                   	push   %ebx
  103681:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  103685:	8b 54 24 0c          	mov    0xc(%esp),%edx
    while (*p && *p == *q)
  103689:	0f b6 01             	movzbl (%ecx),%eax
  10368c:	0f b6 1a             	movzbl (%edx),%ebx
  10368f:	84 c0                	test   %al,%al
  103691:	75 16                	jne    1036a9 <strcmp+0x29>
  103693:	eb 23                	jmp    1036b8 <strcmp+0x38>
  103695:	8d 76 00             	lea    0x0(%esi),%esi
  103698:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        p++, q++;
  10369c:	83 c1 01             	add    $0x1,%ecx
  10369f:	83 c2 01             	add    $0x1,%edx
    while (*p && *p == *q)
  1036a2:	0f b6 1a             	movzbl (%edx),%ebx
  1036a5:	84 c0                	test   %al,%al
  1036a7:	74 0f                	je     1036b8 <strcmp+0x38>
  1036a9:	38 d8                	cmp    %bl,%al
  1036ab:	74 eb                	je     103698 <strcmp+0x18>
    return (int) ((unsigned char) *p - (unsigned char) *q);
  1036ad:	29 d8                	sub    %ebx,%eax
}
  1036af:	5b                   	pop    %ebx
  1036b0:	c3                   	ret    
  1036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1036b8:	31 c0                	xor    %eax,%eax
    return (int) ((unsigned char) *p - (unsigned char) *q);
  1036ba:	29 d8                	sub    %ebx,%eax
}
  1036bc:	5b                   	pop    %ebx
  1036bd:	c3                   	ret    
  1036be:	66 90                	xchg   %ax,%ax

001036c0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *strchr(const char *s, char c)
{
  1036c0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1036c4:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
    for (; *s; s++)
  1036c9:	0f b6 10             	movzbl (%eax),%edx
  1036cc:	84 d2                	test   %dl,%dl
  1036ce:	75 13                	jne    1036e3 <strchr+0x23>
  1036d0:	eb 1e                	jmp    1036f0 <strchr+0x30>
  1036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1036d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
  1036dc:	83 c0 01             	add    $0x1,%eax
  1036df:	84 d2                	test   %dl,%dl
  1036e1:	74 0d                	je     1036f0 <strchr+0x30>
        if (*s == c)
  1036e3:	38 d1                	cmp    %dl,%cl
  1036e5:	75 f1                	jne    1036d8 <strchr+0x18>
            return (char *) s;
    return 0;
}
  1036e7:	c3                   	ret    
  1036e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1036ef:	90                   	nop
    return 0;
  1036f0:	31 c0                	xor    %eax,%eax
}
  1036f2:	c3                   	ret    
  1036f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1036fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103700 <memzero>:

void *memzero(void *v, size_t n)
{
    return memset(v, 0, n);
  103700:	ff 74 24 08          	pushl  0x8(%esp)
  103704:	6a 00                	push   $0x0
  103706:	ff 74 24 0c          	pushl  0xc(%esp)
  10370a:	e8 21 fe ff ff       	call   103530 <memset>
  10370f:	83 c4 0c             	add    $0xc,%esp
}
  103712:	c3                   	ret    
  103713:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103720 <memcmp>:

int memcmp(const void *v1, const void *v2, size_t n)
{
  103720:	56                   	push   %esi
  103721:	53                   	push   %ebx
  103722:	8b 74 24 14          	mov    0x14(%esp),%esi
  103726:	8b 54 24 0c          	mov    0xc(%esp),%edx
  10372a:	8b 44 24 10          	mov    0x10(%esp),%eax
    const uint8_t *s1 = (const uint8_t *) v1;
    const uint8_t *s2 = (const uint8_t *) v2;

    while (n-- > 0) {
  10372e:	85 f6                	test   %esi,%esi
  103730:	74 2e                	je     103760 <memcmp+0x40>
  103732:	01 c6                	add    %eax,%esi
  103734:	eb 14                	jmp    10374a <memcmp+0x2a>
  103736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10373d:	8d 76 00             	lea    0x0(%esi),%esi
        if (*s1 != *s2)
            return (int) *s1 - (int) *s2;
        s1++, s2++;
  103740:	83 c0 01             	add    $0x1,%eax
  103743:	83 c2 01             	add    $0x1,%edx
    while (n-- > 0) {
  103746:	39 f0                	cmp    %esi,%eax
  103748:	74 16                	je     103760 <memcmp+0x40>
        if (*s1 != *s2)
  10374a:	0f b6 0a             	movzbl (%edx),%ecx
  10374d:	0f b6 18             	movzbl (%eax),%ebx
  103750:	38 d9                	cmp    %bl,%cl
  103752:	74 ec                	je     103740 <memcmp+0x20>
            return (int) *s1 - (int) *s2;
  103754:	0f b6 c1             	movzbl %cl,%eax
  103757:	29 d8                	sub    %ebx,%eax
    }

    return 0;
}
  103759:	5b                   	pop    %ebx
  10375a:	5e                   	pop    %esi
  10375b:	c3                   	ret    
  10375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
  103760:	31 c0                	xor    %eax,%eax
}
  103762:	5b                   	pop    %ebx
  103763:	5e                   	pop    %esi
  103764:	c3                   	ret    
  103765:	66 90                	xchg   %ax,%ax
  103767:	66 90                	xchg   %ax,%ax
  103769:	66 90                	xchg   %ax,%ax
  10376b:	66 90                	xchg   %ax,%ax
  10376d:	66 90                	xchg   %ax,%ax
  10376f:	90                   	nop

00103770 <debug_init>:
#include <lib/reentrant_lock.h>

static reentrantlock debug_lk;

void debug_init(void)
{
  103770:	83 ec 18             	sub    $0x18,%esp
    reentrantlock_init(&debug_lk);
  103773:	68 70 ce 14 00       	push   $0x14ce70
  103778:	e8 33 17 00 00       	call   104eb0 <reentrantlock_init>
}
  10377d:	83 c4 1c             	add    $0x1c,%esp
  103780:	c3                   	ret    
  103781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10378f:	90                   	nop

00103790 <debug_lock>:

void debug_lock(void)
{
  103790:	83 ec 18             	sub    $0x18,%esp
    reentrantlock_acquire(&debug_lk);
  103793:	68 70 ce 14 00       	push   $0x14ce70
  103798:	e8 43 17 00 00       	call   104ee0 <reentrantlock_acquire>
}
  10379d:	83 c4 1c             	add    $0x1c,%esp
  1037a0:	c3                   	ret    
  1037a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1037a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1037af:	90                   	nop

001037b0 <debug_unlock>:

void debug_unlock(void)
{
  1037b0:	83 ec 18             	sub    $0x18,%esp
    reentrantlock_release(&debug_lk);
  1037b3:	68 70 ce 14 00       	push   $0x14ce70
  1037b8:	e8 b3 17 00 00       	call   104f70 <reentrantlock_release>
}
  1037bd:	83 c4 1c             	add    $0x1c,%esp
  1037c0:	c3                   	ret    
  1037c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1037c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1037cf:	90                   	nop

001037d0 <debug_info>:

extern int vdprintf(const char *fmt, va_list ap);

void debug_info(const char *fmt, ...)
{
  1037d0:	83 ec 18             	sub    $0x18,%esp
    reentrantlock_acquire(&debug_lk);
  1037d3:	68 70 ce 14 00       	push   $0x14ce70
  1037d8:	e8 03 17 00 00       	call   104ee0 <reentrantlock_acquire>
#ifdef DEBUG_MSG
    debug_lock();
    va_list ap;
    va_start(ap, fmt);
  1037dd:	8d 44 24 24          	lea    0x24(%esp),%eax
    vdprintf(fmt, ap);
  1037e1:	5a                   	pop    %edx
  1037e2:	59                   	pop    %ecx
  1037e3:	50                   	push   %eax
  1037e4:	ff 74 24 1c          	pushl  0x1c(%esp)
  1037e8:	e8 f3 01 00 00       	call   1039e0 <vdprintf>
    reentrantlock_release(&debug_lk);
  1037ed:	c7 04 24 70 ce 14 00 	movl   $0x14ce70,(%esp)
  1037f4:	e8 77 17 00 00       	call   104f70 <reentrantlock_release>
    va_end(ap);
    debug_unlock();
#endif
}
  1037f9:	83 c4 1c             	add    $0x1c,%esp
  1037fc:	c3                   	ret    
  1037fd:	8d 76 00             	lea    0x0(%esi),%esi

00103800 <debug_normal>:

#ifdef DEBUG_MSG

void debug_normal(const char *file, int line, const char *fmt, ...)
{
  103800:	83 ec 18             	sub    $0x18,%esp
    reentrantlock_acquire(&debug_lk);
  103803:	68 70 ce 14 00       	push   $0x14ce70
  103808:	e8 d3 16 00 00       	call   104ee0 <reentrantlock_acquire>
    debug_lock();
    dprintf("[D] %s:%d: ", file, line);
  10380d:	83 c4 0c             	add    $0xc,%esp
  103810:	ff 74 24 18          	pushl  0x18(%esp)
  103814:	ff 74 24 18          	pushl  0x18(%esp)
  103818:	68 42 a2 10 00       	push   $0x10a242
  10381d:	e8 3e 02 00 00       	call   103a60 <dprintf>

    va_list ap;
    va_start(ap, fmt);
  103822:	8d 44 24 2c          	lea    0x2c(%esp),%eax
    vdprintf(fmt, ap);
  103826:	5a                   	pop    %edx
  103827:	59                   	pop    %ecx
  103828:	50                   	push   %eax
  103829:	ff 74 24 24          	pushl  0x24(%esp)
  10382d:	e8 ae 01 00 00       	call   1039e0 <vdprintf>
    reentrantlock_release(&debug_lk);
  103832:	c7 04 24 70 ce 14 00 	movl   $0x14ce70,(%esp)
  103839:	e8 32 17 00 00       	call   104f70 <reentrantlock_release>
    va_end(ap);
    debug_unlock();
}
  10383e:	83 c4 1c             	add    $0x1c,%esp
  103841:	c3                   	ret    
  103842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103850 <debug_panic>:
    for (; i < DEBUG_TRACEFRAMES; i++)
        eips[i] = 0;
}

gcc_noinline void debug_panic(const char *file, int line, const char *fmt, ...)
{
  103850:	56                   	push   %esi
  103851:	53                   	push   %ebx
  103852:	83 ec 40             	sub    $0x40,%esp
    reentrantlock_acquire(&debug_lk);
  103855:	68 70 ce 14 00       	push   $0x14ce70
  10385a:	e8 81 16 00 00       	call   104ee0 <reentrantlock_acquire>
    int i;
    uintptr_t eips[DEBUG_TRACEFRAMES];
    va_list ap;

    debug_lock();
    dprintf("[P] %s:%d: ", file, line);
  10385f:	83 c4 0c             	add    $0xc,%esp
  103862:	ff 74 24 48          	pushl  0x48(%esp)
  103866:	ff 74 24 48          	pushl  0x48(%esp)
  10386a:	68 4e a2 10 00       	push   $0x10a24e
  10386f:	e8 ec 01 00 00       	call   103a60 <dprintf>

    va_start(ap, fmt);
  103874:	8d 44 24 5c          	lea    0x5c(%esp),%eax
    vdprintf(fmt, ap);
  103878:	5a                   	pop    %edx
  103879:	59                   	pop    %ecx
  10387a:	50                   	push   %eax
  10387b:	ff 74 24 54          	pushl  0x54(%esp)
  10387f:	e8 5c 01 00 00       	call   1039e0 <vdprintf>
    va_end(ap);

    debug_trace(read_ebp(), eips);
  103884:	e8 c7 0a 00 00       	call   104350 <read_ebp>
    for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
  103889:	83 c4 10             	add    $0x10,%esp
  10388c:	31 d2                	xor    %edx,%edx
  10388e:	8d 5c 24 08          	lea    0x8(%esp),%ebx
  103892:	85 c0                	test   %eax,%eax
  103894:	74 2a                	je     1038c0 <debug_panic+0x70>
  103896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10389d:	8d 76 00             	lea    0x0(%esi),%esi
        eips[i] = frame[1];              /* saved %eip */
  1038a0:	8b 48 04             	mov    0x4(%eax),%ecx
        frame = (uintptr_t *) frame[0];  /* saved %ebp */
  1038a3:	8b 00                	mov    (%eax),%eax
        eips[i] = frame[1];              /* saved %eip */
  1038a5:	89 0c 93             	mov    %ecx,(%ebx,%edx,4)
    for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
  1038a8:	83 c2 01             	add    $0x1,%edx
  1038ab:	83 fa 09             	cmp    $0x9,%edx
  1038ae:	7f 1f                	jg     1038cf <debug_panic+0x7f>
  1038b0:	85 c0                	test   %eax,%eax
  1038b2:	75 ec                	jne    1038a0 <debug_panic+0x50>
    for (; i < DEBUG_TRACEFRAMES; i++)
  1038b4:	83 fa 09             	cmp    $0x9,%edx
  1038b7:	7f 16                	jg     1038cf <debug_panic+0x7f>
  1038b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        eips[i] = 0;
  1038c0:	c7 04 93 00 00 00 00 	movl   $0x0,(%ebx,%edx,4)
    for (; i < DEBUG_TRACEFRAMES; i++)
  1038c7:	83 c2 01             	add    $0x1,%edx
  1038ca:	83 fa 0a             	cmp    $0xa,%edx
  1038cd:	75 f1                	jne    1038c0 <debug_panic+0x70>
  1038cf:	8d 74 24 30          	lea    0x30(%esp),%esi
  1038d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1038d7:	90                   	nop
    for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  1038d8:	8b 03                	mov    (%ebx),%eax
  1038da:	85 c0                	test   %eax,%eax
  1038dc:	74 18                	je     1038f6 <debug_panic+0xa6>
        dprintf("\tfrom 0x%08x\n", eips[i]);
  1038de:	83 ec 08             	sub    $0x8,%esp
  1038e1:	83 c3 04             	add    $0x4,%ebx
  1038e4:	50                   	push   %eax
  1038e5:	68 5a a2 10 00       	push   $0x10a25a
  1038ea:	e8 71 01 00 00       	call   103a60 <dprintf>
    for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  1038ef:	83 c4 10             	add    $0x10,%esp
  1038f2:	39 de                	cmp    %ebx,%esi
  1038f4:	75 e2                	jne    1038d8 <debug_panic+0x88>

    dprintf("Kernel Panic !!!\n");
  1038f6:	83 ec 0c             	sub    $0xc,%esp
  1038f9:	68 68 a2 10 00       	push   $0x10a268
  1038fe:	e8 5d 01 00 00       	call   103a60 <dprintf>
    reentrantlock_release(&debug_lk);
  103903:	c7 04 24 70 ce 14 00 	movl   $0x14ce70,(%esp)
  10390a:	e8 61 16 00 00       	call   104f70 <reentrantlock_release>

    debug_unlock();
    halt();
  10390f:	e8 9c 0a 00 00       	call   1043b0 <halt>
}
  103914:	83 c4 44             	add    $0x44,%esp
  103917:	5b                   	pop    %ebx
  103918:	5e                   	pop    %esi
  103919:	c3                   	ret    
  10391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103920 <debug_warn>:

void debug_warn(const char *file, int line, const char *fmt, ...)
{
  103920:	83 ec 18             	sub    $0x18,%esp
    reentrantlock_acquire(&debug_lk);
  103923:	68 70 ce 14 00       	push   $0x14ce70
  103928:	e8 b3 15 00 00       	call   104ee0 <reentrantlock_acquire>
    debug_lock();
    dprintf("[W] %s:%d: ", file, line);
  10392d:	83 c4 0c             	add    $0xc,%esp
  103930:	ff 74 24 18          	pushl  0x18(%esp)
  103934:	ff 74 24 18          	pushl  0x18(%esp)
  103938:	68 7a a2 10 00       	push   $0x10a27a
  10393d:	e8 1e 01 00 00       	call   103a60 <dprintf>

    va_list ap;
    va_start(ap, fmt);
  103942:	8d 44 24 2c          	lea    0x2c(%esp),%eax
    vdprintf(fmt, ap);
  103946:	5a                   	pop    %edx
  103947:	59                   	pop    %ecx
  103948:	50                   	push   %eax
  103949:	ff 74 24 24          	pushl  0x24(%esp)
  10394d:	e8 8e 00 00 00       	call   1039e0 <vdprintf>
    reentrantlock_release(&debug_lk);
  103952:	c7 04 24 70 ce 14 00 	movl   $0x14ce70,(%esp)
  103959:	e8 12 16 00 00       	call   104f70 <reentrantlock_release>
    va_end(ap);
    debug_unlock();
}
  10395e:	83 c4 1c             	add    $0x1c,%esp
  103961:	c3                   	ret    
  103962:	66 90                	xchg   %ax,%ax
  103964:	66 90                	xchg   %ax,%ax
  103966:	66 90                	xchg   %ax,%ax
  103968:	66 90                	xchg   %ax,%ax
  10396a:	66 90                	xchg   %ax,%ax
  10396c:	66 90                	xchg   %ax,%ax
  10396e:	66 90                	xchg   %ax,%ax

00103970 <putch>:
        str += 1;
    }
}

static void putch(int ch, struct dprintbuf *b)
{
  103970:	56                   	push   %esi
  103971:	53                   	push   %ebx
  103972:	83 ec 04             	sub    $0x4,%esp
  103975:	8b 74 24 14          	mov    0x14(%esp),%esi
    b->buf[b->idx++] = ch;
  103979:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  10397d:	8b 16                	mov    (%esi),%edx
  10397f:	8d 42 01             	lea    0x1(%edx),%eax
  103982:	89 06                	mov    %eax,(%esi)
  103984:	88 4c 16 08          	mov    %cl,0x8(%esi,%edx,1)
    if (b->idx == CONSOLE_BUFFER_SIZE - 1) {
  103988:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  10398d:	74 11                	je     1039a0 <putch+0x30>
        b->buf[b->idx] = 0;
        cputs(b->buf);
        b->idx = 0;
    }
    b->cnt++;
  10398f:	83 46 04 01          	addl   $0x1,0x4(%esi)
}
  103993:	83 c4 04             	add    $0x4,%esp
  103996:	5b                   	pop    %ebx
  103997:	5e                   	pop    %esi
  103998:	c3                   	ret    
  103999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while (*str) {
  1039a0:	0f be 46 08          	movsbl 0x8(%esi),%eax
        b->buf[b->idx] = 0;
  1039a4:	c6 86 07 02 00 00 00 	movb   $0x0,0x207(%esi)
        cputs(b->buf);
  1039ab:	8d 5e 08             	lea    0x8(%esi),%ebx
    while (*str) {
  1039ae:	84 c0                	test   %al,%al
  1039b0:	74 1c                	je     1039ce <putch+0x5e>
  1039b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cons_putc(*str);
  1039b8:	83 ec 0c             	sub    $0xc,%esp
        str += 1;
  1039bb:	83 c3 01             	add    $0x1,%ebx
        cons_putc(*str);
  1039be:	50                   	push   %eax
  1039bf:	e8 ac ca ff ff       	call   100470 <cons_putc>
    while (*str) {
  1039c4:	0f be 03             	movsbl (%ebx),%eax
  1039c7:	83 c4 10             	add    $0x10,%esp
  1039ca:	84 c0                	test   %al,%al
  1039cc:	75 ea                	jne    1039b8 <putch+0x48>
    b->cnt++;
  1039ce:	83 46 04 01          	addl   $0x1,0x4(%esi)
        b->idx = 0;
  1039d2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
}
  1039d8:	83 c4 04             	add    $0x4,%esp
  1039db:	5b                   	pop    %ebx
  1039dc:	5e                   	pop    %esi
  1039dd:	c3                   	ret    
  1039de:	66 90                	xchg   %ax,%ax

001039e0 <vdprintf>:

int vdprintf(const char *fmt, va_list ap)
{
  1039e0:	53                   	push   %ebx
  1039e1:	81 ec 18 02 00 00    	sub    $0x218,%esp
    struct dprintbuf b;

    debug_lock();
  1039e7:	e8 a4 fd ff ff       	call   103790 <debug_lock>
    b.idx = 0;
  1039ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039f3:	00 
    b.cnt = 0;
  1039f4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1039fb:	00 
    vprintfmt((void *) putch, &b, fmt, ap);
  1039fc:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
  103a03:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
  103a0a:	8d 44 24 10          	lea    0x10(%esp),%eax
  103a0e:	50                   	push   %eax
  103a0f:	68 70 39 10 00       	push   $0x103970
  103a14:	e8 37 01 00 00       	call   103b50 <vprintfmt>

    b.buf[b.idx] = 0;
  103a19:	8b 44 24 18          	mov    0x18(%esp),%eax
  103a1d:	c6 44 04 20 00       	movb   $0x0,0x20(%esp,%eax,1)
    while (*str) {
  103a22:	0f be 44 24 20       	movsbl 0x20(%esp),%eax
  103a27:	83 c4 10             	add    $0x10,%esp
  103a2a:	84 c0                	test   %al,%al
  103a2c:	74 20                	je     103a4e <vdprintf+0x6e>
  103a2e:	8d 5c 24 10          	lea    0x10(%esp),%ebx
  103a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cons_putc(*str);
  103a38:	83 ec 0c             	sub    $0xc,%esp
        str += 1;
  103a3b:	83 c3 01             	add    $0x1,%ebx
        cons_putc(*str);
  103a3e:	50                   	push   %eax
  103a3f:	e8 2c ca ff ff       	call   100470 <cons_putc>
    while (*str) {
  103a44:	0f be 03             	movsbl (%ebx),%eax
  103a47:	83 c4 10             	add    $0x10,%esp
  103a4a:	84 c0                	test   %al,%al
  103a4c:	75 ea                	jne    103a38 <vdprintf+0x58>
    cputs(b.buf);
    debug_unlock();
  103a4e:	e8 5d fd ff ff       	call   1037b0 <debug_unlock>

    return b.cnt;
}
  103a53:	8b 44 24 0c          	mov    0xc(%esp),%eax
  103a57:	81 c4 18 02 00 00    	add    $0x218,%esp
  103a5d:	5b                   	pop    %ebx
  103a5e:	c3                   	ret    
  103a5f:	90                   	nop

00103a60 <dprintf>:

int dprintf(const char *fmt, ...)
{
  103a60:	83 ec 0c             	sub    $0xc,%esp
    va_list ap;
    int cnt;

    va_start(ap, fmt);
  103a63:	8d 44 24 14          	lea    0x14(%esp),%eax
    cnt = vdprintf(fmt, ap);
  103a67:	83 ec 08             	sub    $0x8,%esp
  103a6a:	50                   	push   %eax
  103a6b:	ff 74 24 1c          	pushl  0x1c(%esp)
  103a6f:	e8 6c ff ff ff       	call   1039e0 <vdprintf>
    va_end(ap);

    return cnt;
}
  103a74:	83 c4 1c             	add    $0x1c,%esp
  103a77:	c3                   	ret    
  103a78:	66 90                	xchg   %ax,%ax
  103a7a:	66 90                	xchg   %ax,%ax
  103a7c:	66 90                	xchg   %ax,%ax
  103a7e:	66 90                	xchg   %ax,%ax

00103a80 <printnum>:
 * Print a number (base <= 16) in reverse order,
 * using specified putch function and associated pointer putdat.
 */
static void printnum(putch_t putch, void *putdat, unsigned long long num,
                     unsigned base, int width, int padc)
{
  103a80:	55                   	push   %ebp
  103a81:	57                   	push   %edi
  103a82:	56                   	push   %esi
  103a83:	89 d6                	mov    %edx,%esi
  103a85:	53                   	push   %ebx
  103a86:	89 c3                	mov    %eax,%ebx
  103a88:	83 ec 1c             	sub    $0x1c,%esp
  103a8b:	8b 54 24 30          	mov    0x30(%esp),%edx
  103a8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
    /* first recursively print all preceding (more significant) digits */
    if (num >= base) {
  103a93:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103a9a:	00 
{
  103a9b:	8b 44 24 38          	mov    0x38(%esp),%eax
    if (num >= base) {
  103a9f:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
{
  103aa3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  103aa7:	8b 7c 24 40          	mov    0x40(%esp),%edi
  103aab:	83 ed 01             	sub    $0x1,%ebp
    if (num >= base) {
  103aae:	39 c2                	cmp    %eax,%edx
  103ab0:	1b 4c 24 04          	sbb    0x4(%esp),%ecx
{
  103ab4:	89 54 24 08          	mov    %edx,0x8(%esp)
    if (num >= base) {
  103ab8:	89 04 24             	mov    %eax,(%esp)
  103abb:	73 53                	jae    103b10 <printnum+0x90>
        printnum(putch, putdat, num / base, base, width - 1, padc);
    } else {
        /* print any needed pad characters before first digit */
        while (--width > 0)
  103abd:	85 ed                	test   %ebp,%ebp
  103abf:	7e 16                	jle    103ad7 <printnum+0x57>
  103ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch(padc, putdat);
  103ac8:	83 ec 08             	sub    $0x8,%esp
  103acb:	56                   	push   %esi
  103acc:	57                   	push   %edi
  103acd:	ff d3                	call   *%ebx
        while (--width > 0)
  103acf:	83 c4 10             	add    $0x10,%esp
  103ad2:	83 ed 01             	sub    $0x1,%ebp
  103ad5:	75 f1                	jne    103ac8 <printnum+0x48>
    }

    // then print this (the least significant) digit
    putch("0123456789abcdef"[num % base], putdat);
  103ad7:	89 74 24 34          	mov    %esi,0x34(%esp)
  103adb:	ff 74 24 04          	pushl  0x4(%esp)
  103adf:	ff 74 24 04          	pushl  0x4(%esp)
  103ae3:	ff 74 24 14          	pushl  0x14(%esp)
  103ae7:	ff 74 24 14          	pushl  0x14(%esp)
  103aeb:	e8 e0 47 00 00       	call   1082d0 <__umoddi3>
  103af0:	0f be 80 86 a2 10 00 	movsbl 0x10a286(%eax),%eax
  103af7:	89 44 24 40          	mov    %eax,0x40(%esp)
}
  103afb:	83 c4 2c             	add    $0x2c,%esp
    putch("0123456789abcdef"[num % base], putdat);
  103afe:	89 d8                	mov    %ebx,%eax
}
  103b00:	5b                   	pop    %ebx
  103b01:	5e                   	pop    %esi
  103b02:	5f                   	pop    %edi
  103b03:	5d                   	pop    %ebp
    putch("0123456789abcdef"[num % base], putdat);
  103b04:	ff e0                	jmp    *%eax
  103b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103b0d:	8d 76 00             	lea    0x0(%esi),%esi
        printnum(putch, putdat, num / base, base, width - 1, padc);
  103b10:	83 ec 0c             	sub    $0xc,%esp
  103b13:	57                   	push   %edi
  103b14:	55                   	push   %ebp
  103b15:	50                   	push   %eax
  103b16:	83 ec 08             	sub    $0x8,%esp
  103b19:	ff 74 24 24          	pushl  0x24(%esp)
  103b1d:	ff 74 24 24          	pushl  0x24(%esp)
  103b21:	ff 74 24 34          	pushl  0x34(%esp)
  103b25:	ff 74 24 34          	pushl  0x34(%esp)
  103b29:	e8 92 46 00 00       	call   1081c0 <__udivdi3>
  103b2e:	83 c4 18             	add    $0x18,%esp
  103b31:	52                   	push   %edx
  103b32:	89 f2                	mov    %esi,%edx
  103b34:	50                   	push   %eax
  103b35:	89 d8                	mov    %ebx,%eax
  103b37:	e8 44 ff ff ff       	call   103a80 <printnum>
  103b3c:	83 c4 20             	add    $0x20,%esp
  103b3f:	eb 96                	jmp    103ad7 <printnum+0x57>
  103b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103b4f:	90                   	nop

00103b50 <vprintfmt>:
    else
        return va_arg(*ap, int);
}

void vprintfmt(putch_t putch, void *putdat, const char *fmt, va_list ap)
{
  103b50:	55                   	push   %ebp
  103b51:	57                   	push   %edi
  103b52:	56                   	push   %esi
  103b53:	53                   	push   %ebx
  103b54:	83 ec 2c             	sub    $0x2c,%esp
  103b57:	8b 6c 24 40          	mov    0x40(%esp),%ebp
  103b5b:	8b 7c 24 44          	mov    0x44(%esp),%edi
    unsigned long long num;
    int base, lflag, width, precision, altflag;
    char padc;

    while (1) {
        while ((ch = *(unsigned char *) fmt++) != '%') {
  103b5f:	8b 44 24 48          	mov    0x48(%esp),%eax
  103b63:	8d 58 01             	lea    0x1(%eax),%ebx
  103b66:	0f b6 00             	movzbl (%eax),%eax
  103b69:	83 f8 25             	cmp    $0x25,%eax
  103b6c:	75 18                	jne    103b86 <vprintfmt+0x36>
  103b6e:	eb 28                	jmp    103b98 <vprintfmt+0x48>
            if (ch == '\0')
                return;
            putch(ch, putdat);
  103b70:	83 ec 08             	sub    $0x8,%esp
        while ((ch = *(unsigned char *) fmt++) != '%') {
  103b73:	83 c3 01             	add    $0x1,%ebx
            putch(ch, putdat);
  103b76:	57                   	push   %edi
  103b77:	50                   	push   %eax
  103b78:	ff d5                	call   *%ebp
        while ((ch = *(unsigned char *) fmt++) != '%') {
  103b7a:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
  103b7e:	83 c4 10             	add    $0x10,%esp
  103b81:	83 f8 25             	cmp    $0x25,%eax
  103b84:	74 12                	je     103b98 <vprintfmt+0x48>
            if (ch == '\0')
  103b86:	85 c0                	test   %eax,%eax
  103b88:	75 e6                	jne    103b70 <vprintfmt+0x20>
            for (fmt--; fmt[-1] != '%'; fmt--)
                /* do nothing */ ;
            break;
        }
    }
}
  103b8a:	83 c4 2c             	add    $0x2c,%esp
  103b8d:	5b                   	pop    %ebx
  103b8e:	5e                   	pop    %esi
  103b8f:	5f                   	pop    %edi
  103b90:	5d                   	pop    %ebp
  103b91:	c3                   	ret    
  103b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        padc = ' ';
  103b98:	c6 44 24 10 20       	movb   $0x20,0x10(%esp)
        lflag = 0;
  103b9d:	31 d2                	xor    %edx,%edx
        precision = -1;
  103b9f:	be ff ff ff ff       	mov    $0xffffffff,%esi
        altflag = 0;
  103ba4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103bab:	00 
  103bac:	89 d1                	mov    %edx,%ecx
        width = -1;
  103bae:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
  103bb5:	ff 
        switch (ch = *(unsigned char *) fmt++) {
  103bb6:	0f b6 13             	movzbl (%ebx),%edx
  103bb9:	8d 43 01             	lea    0x1(%ebx),%eax
  103bbc:	89 44 24 48          	mov    %eax,0x48(%esp)
  103bc0:	8d 42 dd             	lea    -0x23(%edx),%eax
  103bc3:	3c 55                	cmp    $0x55,%al
  103bc5:	77 11                	ja     103bd8 <vprintfmt+0x88>
  103bc7:	0f b6 c0             	movzbl %al,%eax
  103bca:	ff 24 85 a0 a2 10 00 	jmp    *0x10a2a0(,%eax,4)
  103bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            putch('%', putdat);
  103bd8:	83 ec 08             	sub    $0x8,%esp
  103bdb:	57                   	push   %edi
  103bdc:	6a 25                	push   $0x25
  103bde:	ff d5                	call   *%ebp
            for (fmt--; fmt[-1] != '%'; fmt--)
  103be0:	83 c4 10             	add    $0x10,%esp
  103be3:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  103be7:	89 5c 24 48          	mov    %ebx,0x48(%esp)
  103beb:	0f 84 6e ff ff ff    	je     103b5f <vprintfmt+0xf>
  103bf1:	89 d8                	mov    %ebx,%eax
  103bf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103bf7:	90                   	nop
  103bf8:	83 e8 01             	sub    $0x1,%eax
  103bfb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  103bff:	75 f7                	jne    103bf8 <vprintfmt+0xa8>
  103c01:	89 44 24 48          	mov    %eax,0x48(%esp)
  103c05:	e9 55 ff ff ff       	jmp    103b5f <vprintfmt+0xf>
  103c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                ch = *fmt;
  103c10:	0f be 43 01          	movsbl 0x1(%ebx),%eax
                precision = precision * 10 + ch - '0';
  103c14:	8d 72 d0             	lea    -0x30(%edx),%esi
        switch (ch = *(unsigned char *) fmt++) {
  103c17:	8b 5c 24 48          	mov    0x48(%esp),%ebx
                if (ch < '0' || ch > '9')
  103c1b:	8d 50 d0             	lea    -0x30(%eax),%edx
  103c1e:	83 fa 09             	cmp    $0x9,%edx
  103c21:	77 1a                	ja     103c3d <vprintfmt+0xed>
  103c23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103c27:	90                   	nop
                precision = precision * 10 + ch - '0';
  103c28:	8d 14 b6             	lea    (%esi,%esi,4),%edx
            for (precision = 0;; ++fmt) {
  103c2b:	83 c3 01             	add    $0x1,%ebx
                precision = precision * 10 + ch - '0';
  103c2e:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
                ch = *fmt;
  103c32:	0f be 03             	movsbl (%ebx),%eax
                if (ch < '0' || ch > '9')
  103c35:	8d 50 d0             	lea    -0x30(%eax),%edx
  103c38:	83 fa 09             	cmp    $0x9,%edx
  103c3b:	76 eb                	jbe    103c28 <vprintfmt+0xd8>
            if (width < 0)
  103c3d:	8b 44 24 08          	mov    0x8(%esp),%eax
  103c41:	85 c0                	test   %eax,%eax
  103c43:	0f 89 6d ff ff ff    	jns    103bb6 <vprintfmt+0x66>
                width = precision, precision = -1;
  103c49:	89 74 24 08          	mov    %esi,0x8(%esp)
  103c4d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  103c52:	e9 5f ff ff ff       	jmp    103bb6 <vprintfmt+0x66>
            putch('0', putdat);
  103c57:	83 ec 08             	sub    $0x8,%esp
            num = (unsigned long long) (uintptr_t) va_arg(ap, void *);
  103c5a:	31 db                	xor    %ebx,%ebx
            putch('0', putdat);
  103c5c:	57                   	push   %edi
  103c5d:	6a 30                	push   $0x30
  103c5f:	ff d5                	call   *%ebp
            putch('x', putdat);
  103c61:	58                   	pop    %eax
  103c62:	5a                   	pop    %edx
  103c63:	57                   	push   %edi
  103c64:	6a 78                	push   $0x78
  103c66:	ff d5                	call   *%ebp
            num = (unsigned long long) (uintptr_t) va_arg(ap, void *);
  103c68:	8b 44 24 5c          	mov    0x5c(%esp),%eax
            goto number;
  103c6c:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long) (uintptr_t) va_arg(ap, void *);
  103c6f:	8b 08                	mov    (%eax),%ecx
  103c71:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  103c75:	83 c0 04             	add    $0x4,%eax
  103c78:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto number;
  103c7c:	b8 10 00 00 00       	mov    $0x10,%eax
            printnum(putch, putdat, num, base, width, padc);
  103c81:	83 ec 0c             	sub    $0xc,%esp
  103c84:	0f be 54 24 1c       	movsbl 0x1c(%esp),%edx
  103c89:	52                   	push   %edx
  103c8a:	89 fa                	mov    %edi,%edx
  103c8c:	ff 74 24 18          	pushl  0x18(%esp)
  103c90:	50                   	push   %eax
  103c91:	89 e8                	mov    %ebp,%eax
  103c93:	53                   	push   %ebx
  103c94:	51                   	push   %ecx
  103c95:	e8 e6 fd ff ff       	call   103a80 <printnum>
            break;
  103c9a:	83 c4 20             	add    $0x20,%esp
  103c9d:	e9 bd fe ff ff       	jmp    103b5f <vprintfmt+0xf>
            altflag = 1;
  103ca2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
  103ca9:	00 
        switch (ch = *(unsigned char *) fmt++) {
  103caa:	8b 5c 24 48          	mov    0x48(%esp),%ebx
            goto reswitch;
  103cae:	e9 03 ff ff ff       	jmp    103bb6 <vprintfmt+0x66>
            putch(ch, putdat);
  103cb3:	83 ec 08             	sub    $0x8,%esp
  103cb6:	57                   	push   %edi
  103cb7:	6a 25                	push   $0x25
  103cb9:	ff d5                	call   *%ebp
            break;
  103cbb:	83 c4 10             	add    $0x10,%esp
  103cbe:	e9 9c fe ff ff       	jmp    103b5f <vprintfmt+0xf>
            precision = va_arg(ap, int);
  103cc3:	8b 44 24 4c          	mov    0x4c(%esp),%eax
        switch (ch = *(unsigned char *) fmt++) {
  103cc7:	8b 5c 24 48          	mov    0x48(%esp),%ebx
            precision = va_arg(ap, int);
  103ccb:	8b 30                	mov    (%eax),%esi
  103ccd:	83 c0 04             	add    $0x4,%eax
  103cd0:	89 44 24 4c          	mov    %eax,0x4c(%esp)
            goto process_precision;
  103cd4:	e9 64 ff ff ff       	jmp    103c3d <vprintfmt+0xed>
            if (width < 0)
  103cd9:	8b 44 24 08          	mov    0x8(%esp),%eax
  103cdd:	ba 00 00 00 00       	mov    $0x0,%edx
        switch (ch = *(unsigned char *) fmt++) {
  103ce2:	8b 5c 24 48          	mov    0x48(%esp),%ebx
  103ce6:	85 c0                	test   %eax,%eax
  103ce8:	0f 49 d0             	cmovns %eax,%edx
  103ceb:	89 54 24 08          	mov    %edx,0x8(%esp)
            goto reswitch;
  103cef:	e9 c2 fe ff ff       	jmp    103bb6 <vprintfmt+0x66>
            if ((p = va_arg(ap, char *)) == NULL)
  103cf4:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  103cf8:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  103cfc:	83 c0 04             	add    $0x4,%eax
  103cff:	80 7c 24 10 2d       	cmpb   $0x2d,0x10(%esp)
  103d04:	89 44 24 14          	mov    %eax,0x14(%esp)
  103d08:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  103d0c:	8b 18                	mov    (%eax),%ebx
  103d0e:	0f 95 c0             	setne  %al
  103d11:	85 c9                	test   %ecx,%ecx
  103d13:	0f 9f c1             	setg   %cl
  103d16:	21 c8                	and    %ecx,%eax
  103d18:	85 db                	test   %ebx,%ebx
  103d1a:	0f 84 d2 01 00 00    	je     103ef2 <vprintfmt+0x3a2>
            if (width > 0 && padc != '-')
  103d20:	8d 4b 01             	lea    0x1(%ebx),%ecx
  103d23:	84 c0                	test   %al,%al
  103d25:	0f 85 df 01 00 00    	jne    103f0a <vprintfmt+0x3ba>
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  103d2b:	0f be 1b             	movsbl (%ebx),%ebx
  103d2e:	89 d8                	mov    %ebx,%eax
            for (;
  103d30:	85 db                	test   %ebx,%ebx
  103d32:	0f 84 15 01 00 00    	je     103e4d <vprintfmt+0x2fd>
  103d38:	89 7c 24 44          	mov    %edi,0x44(%esp)
  103d3c:	89 f7                	mov    %esi,%edi
  103d3e:	89 ce                	mov    %ecx,%esi
  103d40:	89 d9                	mov    %ebx,%ecx
  103d42:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  103d46:	eb 32                	jmp    103d7a <vprintfmt+0x22a>
  103d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103d4f:	90                   	nop
                if (altflag && (ch < ' ' || ch > '~'))
  103d50:	83 e8 20             	sub    $0x20,%eax
  103d53:	83 f8 5e             	cmp    $0x5e,%eax
  103d56:	76 3a                	jbe    103d92 <vprintfmt+0x242>
                    putch('?', putdat);
  103d58:	83 ec 08             	sub    $0x8,%esp
  103d5b:	ff 74 24 4c          	pushl  0x4c(%esp)
  103d5f:	6a 3f                	push   $0x3f
  103d61:	ff d5                	call   *%ebp
  103d63:	83 c4 10             	add    $0x10,%esp
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  103d66:	0f be 06             	movsbl (%esi),%eax
  103d69:	83 c6 01             	add    $0x1,%esi
                 width--)
  103d6c:	83 eb 01             	sub    $0x1,%ebx
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  103d6f:	0f be c8             	movsbl %al,%ecx
            for (;
  103d72:	85 c9                	test   %ecx,%ecx
  103d74:	0f 84 cb 00 00 00    	je     103e45 <vprintfmt+0x2f5>
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  103d7a:	85 ff                	test   %edi,%edi
  103d7c:	78 0c                	js     103d8a <vprintfmt+0x23a>
  103d7e:	83 ef 01             	sub    $0x1,%edi
  103d81:	83 ff ff             	cmp    $0xffffffff,%edi
  103d84:	0f 84 bb 00 00 00    	je     103e45 <vprintfmt+0x2f5>
                if (altflag && (ch < ' ' || ch > '~'))
  103d8a:	8b 54 24 0c          	mov    0xc(%esp),%edx
  103d8e:	85 d2                	test   %edx,%edx
  103d90:	75 be                	jne    103d50 <vprintfmt+0x200>
                    putch(ch, putdat);
  103d92:	83 ec 08             	sub    $0x8,%esp
  103d95:	ff 74 24 4c          	pushl  0x4c(%esp)
  103d99:	51                   	push   %ecx
  103d9a:	ff d5                	call   *%ebp
  103d9c:	83 c4 10             	add    $0x10,%esp
  103d9f:	eb c5                	jmp    103d66 <vprintfmt+0x216>
        return va_arg(*ap, unsigned long long);
  103da1:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  103da5:	89 ca                	mov    %ecx,%edx
  103da7:	8b 08                	mov    (%eax),%ecx
    if (lflag >= 2)
  103da9:	83 fa 01             	cmp    $0x1,%edx
  103dac:	0f 8f cb 00 00 00    	jg     103e7d <vprintfmt+0x32d>
    else if (lflag)
  103db2:	83 44 24 4c 04       	addl   $0x4,0x4c(%esp)
  103db7:	31 db                	xor    %ebx,%ebx
  103db9:	b8 0a 00 00 00       	mov    $0xa,%eax
  103dbe:	e9 be fe ff ff       	jmp    103c81 <vprintfmt+0x131>
        return va_arg(*ap, unsigned long long);
  103dc3:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  103dc7:	89 ca                	mov    %ecx,%edx
  103dc9:	8b 08                	mov    (%eax),%ecx
    if (lflag >= 2)
  103dcb:	83 fa 01             	cmp    $0x1,%edx
  103dce:	0f 8f bd 00 00 00    	jg     103e91 <vprintfmt+0x341>
    else if (lflag)
  103dd4:	83 44 24 4c 04       	addl   $0x4,0x4c(%esp)
  103dd9:	31 db                	xor    %ebx,%ebx
  103ddb:	b8 10 00 00 00       	mov    $0x10,%eax
  103de0:	e9 9c fe ff ff       	jmp    103c81 <vprintfmt+0x131>
            putch(va_arg(ap, int), putdat);
  103de5:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  103de9:	83 ec 08             	sub    $0x8,%esp
  103dec:	57                   	push   %edi
  103ded:	8d 58 04             	lea    0x4(%eax),%ebx
  103df0:	8b 44 24 58          	mov    0x58(%esp),%eax
  103df4:	ff 30                	pushl  (%eax)
  103df6:	ff d5                	call   *%ebp
  103df8:	89 5c 24 5c          	mov    %ebx,0x5c(%esp)
            break;
  103dfc:	83 c4 10             	add    $0x10,%esp
  103dff:	e9 5b fd ff ff       	jmp    103b5f <vprintfmt+0xf>
        return va_arg(*ap, long long);
  103e04:	8b 44 24 4c          	mov    0x4c(%esp),%eax
    if (lflag >= 2)
  103e08:	83 f9 01             	cmp    $0x1,%ecx
  103e0b:	0f 8f 94 00 00 00    	jg     103ea5 <vprintfmt+0x355>
        return va_arg(*ap, long);
  103e11:	8b 4c 24 4c          	mov    0x4c(%esp),%ecx
  103e15:	83 c0 04             	add    $0x4,%eax
  103e18:	8b 19                	mov    (%ecx),%ebx
  103e1a:	89 44 24 4c          	mov    %eax,0x4c(%esp)
  103e1e:	89 de                	mov    %ebx,%esi
  103e20:	c1 fe 1f             	sar    $0x1f,%esi
            if ((long long) num < 0) {
  103e23:	85 f6                	test   %esi,%esi
  103e25:	0f 88 8b 00 00 00    	js     103eb6 <vprintfmt+0x366>
            num = getint(&ap, lflag);
  103e2b:	89 d9                	mov    %ebx,%ecx
  103e2d:	b8 0a 00 00 00       	mov    $0xa,%eax
  103e32:	89 f3                	mov    %esi,%ebx
  103e34:	e9 48 fe ff ff       	jmp    103c81 <vprintfmt+0x131>
        switch (ch = *(unsigned char *) fmt++) {
  103e39:	8b 5c 24 48          	mov    0x48(%esp),%ebx
            lflag++;
  103e3d:	83 c1 01             	add    $0x1,%ecx
            goto reswitch;
  103e40:	e9 71 fd ff ff       	jmp    103bb6 <vprintfmt+0x66>
  103e45:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e49:	8b 7c 24 44          	mov    0x44(%esp),%edi
            for (; width > 0; width--)
  103e4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  103e51:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  103e55:	85 c9                	test   %ecx,%ecx
  103e57:	7e 17                	jle    103e70 <vprintfmt+0x320>
  103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                putch(' ', putdat);
  103e60:	83 ec 08             	sub    $0x8,%esp
  103e63:	57                   	push   %edi
  103e64:	6a 20                	push   $0x20
  103e66:	ff d5                	call   *%ebp
            for (; width > 0; width--)
  103e68:	83 c4 10             	add    $0x10,%esp
  103e6b:	83 eb 01             	sub    $0x1,%ebx
  103e6e:	75 f0                	jne    103e60 <vprintfmt+0x310>
            if ((p = va_arg(ap, char *)) == NULL)
  103e70:	8b 44 24 14          	mov    0x14(%esp),%eax
  103e74:	89 44 24 4c          	mov    %eax,0x4c(%esp)
  103e78:	e9 e2 fc ff ff       	jmp    103b5f <vprintfmt+0xf>
        return va_arg(*ap, unsigned long long);
  103e7d:	8b 58 04             	mov    0x4(%eax),%ebx
  103e80:	83 c0 08             	add    $0x8,%eax
  103e83:	89 44 24 4c          	mov    %eax,0x4c(%esp)
  103e87:	b8 0a 00 00 00       	mov    $0xa,%eax
  103e8c:	e9 f0 fd ff ff       	jmp    103c81 <vprintfmt+0x131>
  103e91:	8b 58 04             	mov    0x4(%eax),%ebx
  103e94:	83 c0 08             	add    $0x8,%eax
  103e97:	89 44 24 4c          	mov    %eax,0x4c(%esp)
  103e9b:	b8 10 00 00 00       	mov    $0x10,%eax
  103ea0:	e9 dc fd ff ff       	jmp    103c81 <vprintfmt+0x131>
        return va_arg(*ap, long long);
  103ea5:	8b 18                	mov    (%eax),%ebx
  103ea7:	8b 70 04             	mov    0x4(%eax),%esi
  103eaa:	83 c0 08             	add    $0x8,%eax
  103ead:	89 44 24 4c          	mov    %eax,0x4c(%esp)
  103eb1:	e9 6d ff ff ff       	jmp    103e23 <vprintfmt+0x2d3>
                putch('-', putdat);
  103eb6:	83 ec 08             	sub    $0x8,%esp
  103eb9:	57                   	push   %edi
  103eba:	6a 2d                	push   $0x2d
  103ebc:	ff d5                	call   *%ebp
                num = -(long long) num;
  103ebe:	89 d9                	mov    %ebx,%ecx
  103ec0:	89 f3                	mov    %esi,%ebx
  103ec2:	b8 0a 00 00 00       	mov    $0xa,%eax
  103ec7:	f7 d9                	neg    %ecx
  103ec9:	83 d3 00             	adc    $0x0,%ebx
  103ecc:	83 c4 10             	add    $0x10,%esp
  103ecf:	f7 db                	neg    %ebx
  103ed1:	e9 ab fd ff ff       	jmp    103c81 <vprintfmt+0x131>
            padc = '-';
  103ed6:	c6 44 24 10 2d       	movb   $0x2d,0x10(%esp)
        switch (ch = *(unsigned char *) fmt++) {
  103edb:	8b 5c 24 48          	mov    0x48(%esp),%ebx
  103edf:	e9 d2 fc ff ff       	jmp    103bb6 <vprintfmt+0x66>
  103ee4:	c6 44 24 10 30       	movb   $0x30,0x10(%esp)
  103ee9:	8b 5c 24 48          	mov    0x48(%esp),%ebx
  103eed:	e9 c4 fc ff ff       	jmp    103bb6 <vprintfmt+0x66>
            if (width > 0 && padc != '-')
  103ef2:	84 c0                	test   %al,%al
  103ef4:	75 7e                	jne    103f74 <vprintfmt+0x424>
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  103ef6:	bb 28 00 00 00       	mov    $0x28,%ebx
  103efb:	b9 98 a2 10 00       	mov    $0x10a298,%ecx
  103f00:	b8 28 00 00 00       	mov    $0x28,%eax
  103f05:	e9 2e fe ff ff       	jmp    103d38 <vprintfmt+0x1e8>
  103f0a:	89 4c 24 18          	mov    %ecx,0x18(%esp)
                for (width -= strnlen(p, precision); width > 0; width--)
  103f0e:	83 ec 08             	sub    $0x8,%esp
  103f11:	56                   	push   %esi
  103f12:	53                   	push   %ebx
  103f13:	e8 38 f7 ff ff       	call   103650 <strnlen>
  103f18:	29 44 24 18          	sub    %eax,0x18(%esp)
  103f1c:	8b 4c 24 18          	mov    0x18(%esp),%ecx
  103f20:	83 c4 10             	add    $0x10,%esp
  103f23:	85 c9                	test   %ecx,%ecx
  103f25:	8b 4c 24 18          	mov    0x18(%esp),%ecx
  103f29:	7e 36                	jle    103f61 <vprintfmt+0x411>
  103f2b:	0f be 44 24 10       	movsbl 0x10(%esp),%eax
  103f30:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  103f34:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
  103f38:	8b 5c 24 08          	mov    0x8(%esp),%ebx
  103f3c:	89 74 24 10          	mov    %esi,0x10(%esp)
  103f40:	89 c6                	mov    %eax,%esi
                    putch(padc, putdat);
  103f42:	83 ec 08             	sub    $0x8,%esp
  103f45:	57                   	push   %edi
  103f46:	56                   	push   %esi
  103f47:	ff d5                	call   *%ebp
                for (width -= strnlen(p, precision); width > 0; width--)
  103f49:	83 c4 10             	add    $0x10,%esp
  103f4c:	83 eb 01             	sub    $0x1,%ebx
  103f4f:	75 f1                	jne    103f42 <vprintfmt+0x3f2>
  103f51:	8b 74 24 10          	mov    0x10(%esp),%esi
  103f55:	8b 4c 24 18          	mov    0x18(%esp),%ecx
  103f59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103f5d:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  103f61:	0f be 03             	movsbl (%ebx),%eax
  103f64:	0f be d8             	movsbl %al,%ebx
            for (;
  103f67:	85 db                	test   %ebx,%ebx
  103f69:	0f 85 c9 fd ff ff    	jne    103d38 <vprintfmt+0x1e8>
  103f6f:	e9 fc fe ff ff       	jmp    103e70 <vprintfmt+0x320>
                for (width -= strnlen(p, precision); width > 0; width--)
  103f74:	83 ec 08             	sub    $0x8,%esp
                p = "(null)";
  103f77:	bb 97 a2 10 00       	mov    $0x10a297,%ebx
                for (width -= strnlen(p, precision); width > 0; width--)
  103f7c:	56                   	push   %esi
  103f7d:	68 97 a2 10 00       	push   $0x10a297
  103f82:	e8 c9 f6 ff ff       	call   103650 <strnlen>
  103f87:	29 44 24 18          	sub    %eax,0x18(%esp)
  103f8b:	8b 44 24 18          	mov    0x18(%esp),%eax
  103f8f:	b9 98 a2 10 00       	mov    $0x10a298,%ecx
  103f94:	83 c4 10             	add    $0x10,%esp
  103f97:	85 c0                	test   %eax,%eax
  103f99:	7f 90                	jg     103f2b <vprintfmt+0x3db>
                 (ch = *p++) != '\0' && (precision < 0 || --precision >= 0);
  103f9b:	bb 28 00 00 00       	mov    $0x28,%ebx
  103fa0:	b8 28 00 00 00       	mov    $0x28,%eax
  103fa5:	e9 8e fd ff ff       	jmp    103d38 <vprintfmt+0x1e8>
  103faa:	66 90                	xchg   %ax,%ax
  103fac:	66 90                	xchg   %ax,%ax
  103fae:	66 90                	xchg   %ax,%ax

00103fb0 <kstack_switch>:
#include "seg.h"

#define offsetof(type, member) __builtin_offsetof(type, member)

void kstack_switch(uint32_t pid)
{
  103fb0:	53                   	push   %ebx
  103fb1:	83 ec 08             	sub    $0x8,%esp
  103fb4:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    int cpu_idx = get_pcpu_idx();
  103fb8:	e8 73 1a 00 00       	call   105a30 <get_pcpu_idx>
    struct kstack *ks = (struct kstack *) get_pcpu_kstack_pointer(cpu_idx);
  103fbd:	83 ec 0c             	sub    $0xc,%esp
  103fc0:	50                   	push   %eax
  103fc1:	e8 aa 1a 00 00       	call   105a70 <get_pcpu_kstack_pointer>

    /*
     * Switch to the new TSS.
     */
    ks->tss.ts_esp0 = (uint32_t) proc_kstack[pid].kstack_hi;
  103fc6:	8d 53 01             	lea    0x1(%ebx),%edx
    ks->tss.ts_ss0 = CPU_GDT_KDATA;
    ks->gdt[CPU_GDT_TSS >> 3] =
  103fc9:	bb eb 00 00 00       	mov    $0xeb,%ebx
  103fce:	c1 e2 0c             	shl    $0xc,%edx
  103fd1:	66 89 58 28          	mov    %bx,0x28(%eax)
    ks->tss.ts_esp0 = (uint32_t) proc_kstack[pid].kstack_hi;
  103fd5:	8d 8a 00 b0 99 00    	lea    0x99b000(%edx),%ecx
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  103fdb:	81 c2 30 a0 99 00    	add    $0x99a030,%edx
    ks->tss.ts_esp0 = (uint32_t) proc_kstack[pid].kstack_hi;
  103fe1:	89 48 34             	mov    %ecx,0x34(%eax)
    ks->tss.ts_ss0 = CPU_GDT_KDATA;
  103fe4:	b9 10 00 00 00       	mov    $0x10,%ecx
  103fe9:	66 89 48 38          	mov    %cx,0x38(%eax)
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  103fed:	89 d1                	mov    %edx,%ecx
    ks->gdt[CPU_GDT_TSS >> 3] =
  103fef:	66 89 50 2a          	mov    %dx,0x2a(%eax)
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  103ff3:	c1 ea 18             	shr    $0x18,%edx
  103ff6:	c1 e9 10             	shr    $0x10,%ecx
    ks->gdt[CPU_GDT_TSS >> 3] =
  103ff9:	88 50 2f             	mov    %dl,0x2f(%eax)
  103ffc:	ba 89 40 00 00       	mov    $0x4089,%edx
  104001:	88 48 2c             	mov    %cl,0x2c(%eax)
  104004:	66 89 50 2d          	mov    %dx,0x2d(%eax)
    ks->gdt[CPU_GDT_TSS >> 3].sd_s = 0;
    ltr(CPU_GDT_TSS);
  104008:	c7 44 24 20 28 00 00 	movl   $0x28,0x20(%esp)
  10400f:	00 
}
  104010:	83 c4 18             	add    $0x18,%esp
  104013:	5b                   	pop    %ebx
    ltr(CPU_GDT_TSS);
  104014:	e9 d7 04 00 00       	jmp    1044f0 <ltr>
  104019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104020 <seg_init>:

void seg_init(int cpu_idx)
{
  104020:	55                   	push   %ebp
  104021:	57                   	push   %edi
  104022:	56                   	push   %esi
  104023:	53                   	push   %ebx
  104024:	83 ec 1c             	sub    $0x1c,%esp
  104027:	8b 5c 24 30          	mov    0x30(%esp),%ebx
    /* clear BSS */
    if (cpu_idx == 0) {
  10402b:	85 db                	test   %ebx,%ebx
  10402d:	0f 84 2d 01 00 00    	je     104160 <seg_init+0x140>
        memzero(edata, ((uint8_t *) &bsp_kstack[0]) - edata);
        memzero(((uint8_t *) &bsp_kstack[0]) + 4096, end - ((uint8_t *) &bsp_kstack[0]) - 4096);
    }

    /* setup GDT */
    bsp_kstack[cpu_idx].gdt[0] = SEGDESC_NULL;
  104033:	8d 53 01             	lea    0x1(%ebx),%edx
  104036:	89 d8                	mov    %ebx,%eax
        SEGDESC32(STA_W, 0x00000000, 0xffffffff, 3);

    /* setup TSS */
    bsp_kstack[cpu_idx].tss.ts_esp0 = (uint32_t) bsp_kstack[cpu_idx].kstack_hi;
    bsp_kstack[cpu_idx].tss.ts_ss0 = CPU_GDT_KDATA;
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  104038:	bf eb 00 00 00       	mov    $0xeb,%edi
    bsp_kstack[cpu_idx].tss.ts_ss0 = CPU_GDT_KDATA;
  10403d:	b9 10 00 00 00       	mov    $0x10,%ecx
  104042:	c1 e2 0c             	shl    $0xc,%edx
    bsp_kstack[cpu_idx].gdt[0] = SEGDESC_NULL;
  104045:	c1 e0 0c             	shl    $0xc,%eax
    bsp_kstack[cpu_idx].tss.ts_esp0 = (uint32_t) bsp_kstack[cpu_idx].kstack_hi;
  104048:	8d b2 00 30 99 00    	lea    0x993000(%edx),%esi
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  10404e:	66 89 b8 28 30 99 00 	mov    %di,0x993028(%eax)
  104055:	89 d5                	mov    %edx,%ebp
    bsp_kstack[cpu_idx].tss.ts_esp0 = (uint32_t) bsp_kstack[cpu_idx].kstack_hi;
  104057:	89 b0 34 30 99 00    	mov    %esi,0x993034(%eax)
        SEGDESC16(STS_T32A, (uint32_t) &bsp_kstack[cpu_idx].tss, sizeof(tss_t) - 1, 0);
  10405d:	8d b2 30 20 99 00    	lea    0x992030(%edx),%esi
  104063:	89 f7                	mov    %esi,%edi
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  104065:	66 89 b0 2a 30 99 00 	mov    %si,0x99302a(%eax)
        SEGDESC16(STS_T32A, (uint32_t) &bsp_kstack[cpu_idx].tss, sizeof(tss_t) - 1, 0);
  10406c:	c1 ee 18             	shr    $0x18,%esi
  10406f:	c1 ef 10             	shr    $0x10,%edi
    bsp_kstack[cpu_idx].tss.ts_ss0 = CPU_GDT_KDATA;
  104072:	66 89 88 38 30 99 00 	mov    %cx,0x993038(%eax)

    /* other fields */
    /* Set the KSTACK_MAGIC value when we initialize the kstack */
    bsp_kstack[cpu_idx].magic = KSTACK_MAGIC;

    pseudodesc_t gdt_desc = {
  104079:	b9 2f 00 00 00       	mov    $0x2f,%ecx
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  10407e:	89 fa                	mov    %edi,%edx
    pseudodesc_t gdt_desc = {
  104080:	66 89 4c 24 0a       	mov    %cx,0xa(%esp)
    bsp_kstack[cpu_idx].gdt[CPU_GDT_TSS >> 3] =
  104085:	88 90 2c 30 99 00    	mov    %dl,0x99302c(%eax)
  10408b:	89 f2                	mov    %esi,%edx
  10408d:	88 90 2f 30 99 00    	mov    %dl,0x99302f(%eax)
  104093:	ba 89 40 00 00       	mov    $0x4089,%edx
  104098:	66 89 90 2d 30 99 00 	mov    %dx,0x99302d(%eax)
        .pd_lim   = sizeof(bsp_kstack[cpu_idx].gdt) - 1,
        .pd_base  = (uint32_t) bsp_kstack[cpu_idx].gdt
  10409f:	8d 95 00 20 99 00    	lea    0x992000(%ebp),%edx
    bsp_kstack[cpu_idx].gdt[0] = SEGDESC_NULL;
  1040a5:	c7 80 00 30 99 00 00 	movl   $0x0,0x993000(%eax)
  1040ac:	00 00 00 
  1040af:	c7 80 04 30 99 00 00 	movl   $0x0,0x993004(%eax)
  1040b6:	00 00 00 
    bsp_kstack[cpu_idx].gdt[CPU_GDT_KCODE >> 3] =
  1040b9:	c7 80 08 30 99 00 ff 	movl   $0xffff,0x993008(%eax)
  1040c0:	ff 00 00 
  1040c3:	c7 80 0c 30 99 00 00 	movl   $0xcf9a00,0x99300c(%eax)
  1040ca:	9a cf 00 
    bsp_kstack[cpu_idx].gdt[CPU_GDT_KDATA >> 3] =
  1040cd:	c7 80 10 30 99 00 ff 	movl   $0xffff,0x993010(%eax)
  1040d4:	ff 00 00 
  1040d7:	c7 80 14 30 99 00 00 	movl   $0xcf9200,0x993014(%eax)
  1040de:	92 cf 00 
    bsp_kstack[cpu_idx].gdt[CPU_GDT_UCODE >> 3] =
  1040e1:	c7 80 18 30 99 00 ff 	movl   $0xffff,0x993018(%eax)
  1040e8:	ff 00 00 
  1040eb:	c7 80 1c 30 99 00 00 	movl   $0xcffa00,0x99301c(%eax)
  1040f2:	fa cf 00 
    bsp_kstack[cpu_idx].gdt[CPU_GDT_UDATA >> 3] =
  1040f5:	c7 80 20 30 99 00 ff 	movl   $0xffff,0x993020(%eax)
  1040fc:	ff 00 00 
  1040ff:	c7 80 24 30 99 00 00 	movl   $0xcff200,0x993024(%eax)
  104106:	f2 cf 00 
    bsp_kstack[cpu_idx].magic = KSTACK_MAGIC;
  104109:	c7 80 20 31 99 00 32 	movl   $0x98765432,0x993120(%eax)
  104110:	54 76 98 
        .pd_base  = (uint32_t) bsp_kstack[cpu_idx].gdt
  104113:	89 54 24 0c          	mov    %edx,0xc(%esp)
    };
    asm volatile ("lgdt %0" :: "m" (gdt_desc));
  104117:	0f 01 54 24 0a       	lgdtl  0xa(%esp)
    asm volatile ("movw %%ax,%%gs" :: "a" (CPU_GDT_KDATA));
  10411c:	b8 10 00 00 00       	mov    $0x10,%eax
  104121:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax,%%fs" :: "a" (CPU_GDT_KDATA));
  104123:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax,%%es" :: "a" (CPU_GDT_KDATA));
  104125:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax,%%ds" :: "a" (CPU_GDT_KDATA));
  104127:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax,%%ss" :: "a" (CPU_GDT_KDATA));
  104129:	8e d0                	mov    %eax,%ss
    /* reload %cs */
    asm volatile ("ljmp %0,$1f\n 1:\n" :: "i" (CPU_GDT_KCODE));
  10412b:	ea 32 41 10 00 08 00 	ljmp   $0x8,$0x104132

    /*
     * Load a null LDT.
     */
    lldt(0);
  104132:	83 ec 0c             	sub    $0xc,%esp
  104135:	6a 00                	push   $0x0
  104137:	e8 24 02 00 00       	call   104360 <lldt>

    /*
     * Load the bootstrap TSS.
     */
    ltr(CPU_GDT_TSS);
  10413c:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
  104143:	e8 a8 03 00 00       	call   1044f0 <ltr>

    /*
     * Load IDT.
     */
    extern pseudodesc_t idt_pd;
    asm volatile ("lidt %0" :: "m" (idt_pd));
  104148:	0f 01 1d 00 13 11 00 	lidtl  0x111300

    /*
     * Initialize all TSS structures for processes.
     */
    if (cpu_idx == 0) {
  10414f:	83 c4 10             	add    $0x10,%esp
  104152:	85 db                	test   %ebx,%ebx
  104154:	74 4a                	je     1041a0 <seg_init+0x180>
        memzero(&bsp_kstack[1], sizeof(struct kstack) * 7);
        memzero(proc_kstack, sizeof(struct kstack) * 64);
    }
}
  104156:	83 c4 1c             	add    $0x1c,%esp
  104159:	5b                   	pop    %ebx
  10415a:	5e                   	pop    %esi
  10415b:	5f                   	pop    %edi
  10415c:	5d                   	pop    %ebp
  10415d:	c3                   	ret    
  10415e:	66 90                	xchg   %ax,%ax
        memzero(edata, ((uint8_t *) &bsp_kstack[0]) - edata);
  104160:	b8 00 30 99 00       	mov    $0x993000,%eax
  104165:	83 ec 08             	sub    $0x8,%esp
  104168:	2d da ba 14 00       	sub    $0x14bada,%eax
  10416d:	50                   	push   %eax
  10416e:	68 da ba 14 00       	push   $0x14bada
  104173:	e8 88 f5 ff ff       	call   103700 <memzero>
        memzero(((uint8_t *) &bsp_kstack[0]) + 4096, end - ((uint8_t *) &bsp_kstack[0]) - 4096);
  104178:	b8 e0 ff e1 00       	mov    $0xe1ffe0,%eax
  10417d:	5e                   	pop    %esi
  10417e:	5f                   	pop    %edi
  10417f:	2d 00 40 99 00       	sub    $0x994000,%eax
  104184:	50                   	push   %eax
  104185:	68 00 40 99 00       	push   $0x994000
  10418a:	e8 71 f5 ff ff       	call   103700 <memzero>
  10418f:	83 c4 10             	add    $0x10,%esp
  104192:	e9 9c fe ff ff       	jmp    104033 <seg_init+0x13>
  104197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10419e:	66 90                	xchg   %ax,%ax
        memzero(&bsp_kstack[1], sizeof(struct kstack) * 7);
  1041a0:	83 ec 08             	sub    $0x8,%esp
  1041a3:	68 00 70 00 00       	push   $0x7000
  1041a8:	68 00 40 99 00       	push   $0x994000
  1041ad:	e8 4e f5 ff ff       	call   103700 <memzero>
        memzero(proc_kstack, sizeof(struct kstack) * 64);
  1041b2:	58                   	pop    %eax
  1041b3:	5a                   	pop    %edx
  1041b4:	68 00 00 04 00       	push   $0x40000
  1041b9:	68 00 b0 99 00       	push   $0x99b000
  1041be:	e8 3d f5 ff ff       	call   103700 <memzero>
  1041c3:	83 c4 10             	add    $0x10,%esp
}
  1041c6:	83 c4 1c             	add    $0x1c,%esp
  1041c9:	5b                   	pop    %ebx
  1041ca:	5e                   	pop    %esi
  1041cb:	5f                   	pop    %edi
  1041cc:	5d                   	pop    %ebp
  1041cd:	c3                   	ret    
  1041ce:	66 90                	xchg   %ax,%ax

001041d0 <seg_init_proc>:

/* initialize the kernel stack for each process */
void seg_init_proc(int cpu_idx, int pid)
{
  1041d0:	57                   	push   %edi
        SEGDESC32(STA_W, 0x00000000, 0xffffffff, 3);

    /* setup TSS */
    proc_kstack[pid].tss.ts_esp0 = (uint32_t) proc_kstack[pid].kstack_hi;
    proc_kstack[pid].tss.ts_ss0 = CPU_GDT_KDATA;
    proc_kstack[pid].tss.ts_iomb = offsetof(tss_t, ts_iopm);
  1041d1:	ba 68 00 00 00       	mov    $0x68,%edx
{
  1041d6:	56                   	push   %esi
  1041d7:	53                   	push   %ebx
  1041d8:	8b 5c 24 14          	mov    0x14(%esp),%ebx
    proc_kstack[pid].gdt[0] = SEGDESC_NULL;
  1041dc:	89 de                	mov    %ebx,%esi
  1041de:	83 c3 01             	add    $0x1,%ebx
  1041e1:	c1 e3 0c             	shl    $0xc,%ebx
  1041e4:	c1 e6 0c             	shl    $0xc,%esi
    memzero (proc_kstack[pid].tss.ts_iopm, sizeof(uint8_t) * 128);
  1041e7:	83 ec 08             	sub    $0x8,%esp
    proc_kstack[pid].tss.ts_esp0 = (uint32_t) proc_kstack[pid].kstack_hi;
  1041ea:	8d 83 00 b0 99 00    	lea    0x99b000(%ebx),%eax
    memzero (proc_kstack[pid].tss.ts_iopm, sizeof(uint8_t) * 128);
  1041f0:	68 80 00 00 00       	push   $0x80
    proc_kstack[pid].tss.ts_esp0 = (uint32_t) proc_kstack[pid].kstack_hi;
  1041f5:	89 86 34 b0 99 00    	mov    %eax,0x99b034(%esi)
    proc_kstack[pid].tss.ts_ss0 = CPU_GDT_KDATA;
  1041fb:	b8 10 00 00 00       	mov    $0x10,%eax
  104200:	66 89 86 38 b0 99 00 	mov    %ax,0x99b038(%esi)
    memzero (proc_kstack[pid].tss.ts_iopm, sizeof(uint8_t) * 128);
  104207:	8d 83 98 a0 99 00    	lea    0x99a098(%ebx),%eax
    proc_kstack[pid].tss.ts_iopm[128] = 0xff;

    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3] =
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  10420d:	81 c3 30 a0 99 00    	add    $0x99a030,%ebx
    memzero (proc_kstack[pid].tss.ts_iopm, sizeof(uint8_t) * 128);
  104213:	50                   	push   %eax
    proc_kstack[pid].gdt[0] = SEGDESC_NULL;
  104214:	c7 86 00 b0 99 00 00 	movl   $0x0,0x99b000(%esi)
  10421b:	00 00 00 
  10421e:	c7 86 04 b0 99 00 00 	movl   $0x0,0x99b004(%esi)
  104225:	00 00 00 
    proc_kstack[pid].gdt[CPU_GDT_KCODE >> 3] =
  104228:	c7 86 08 b0 99 00 ff 	movl   $0xffff,0x99b008(%esi)
  10422f:	ff 00 00 
  104232:	c7 86 0c b0 99 00 00 	movl   $0xcf9a00,0x99b00c(%esi)
  104239:	9a cf 00 
    proc_kstack[pid].gdt[CPU_GDT_KDATA >> 3] =
  10423c:	c7 86 10 b0 99 00 ff 	movl   $0xffff,0x99b010(%esi)
  104243:	ff 00 00 
  104246:	c7 86 14 b0 99 00 00 	movl   $0xcf9200,0x99b014(%esi)
  10424d:	92 cf 00 
    proc_kstack[pid].gdt[CPU_GDT_UCODE >> 3] =
  104250:	c7 86 18 b0 99 00 ff 	movl   $0xffff,0x99b018(%esi)
  104257:	ff 00 00 
  10425a:	c7 86 1c b0 99 00 00 	movl   $0xcffa00,0x99b01c(%esi)
  104261:	fa cf 00 
    proc_kstack[pid].gdt[CPU_GDT_UDATA >> 3] =
  104264:	c7 86 20 b0 99 00 ff 	movl   $0xffff,0x99b020(%esi)
  10426b:	ff 00 00 
  10426e:	c7 86 24 b0 99 00 00 	movl   $0xcff200,0x99b024(%esi)
  104275:	f2 cf 00 
    proc_kstack[pid].tss.ts_iomb = offsetof(tss_t, ts_iopm);
  104278:	66 89 96 96 b0 99 00 	mov    %dx,0x99b096(%esi)
    memzero (proc_kstack[pid].tss.ts_iopm, sizeof(uint8_t) * 128);
  10427f:	e8 7c f4 ff ff       	call   103700 <memzero>
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  104284:	89 d8                	mov    %ebx,%eax
    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3] =
  104286:	66 89 9e 2a b0 99 00 	mov    %bx,0x99b02a(%esi)
        SEGDESC16(STS_T32A, (uint32_t) &proc_kstack[pid].tss, sizeof(tss_t) - 1, 0);
  10428d:	c1 eb 18             	shr    $0x18,%ebx
  104290:	c1 e8 10             	shr    $0x10,%eax
    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3] =
  104293:	88 9e 2f b0 99 00    	mov    %bl,0x99b02f(%esi)
  104299:	b9 eb 00 00 00       	mov    $0xeb,%ecx
  10429e:	bb 89 40 00 00       	mov    $0x4089,%ebx
  1042a3:	88 86 2c b0 99 00    	mov    %al,0x99b02c(%esi)
    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3].sd_s = 0;

    /* other fields */
    proc_kstack[pid].magic = KSTACK_MAGIC;
    proc_kstack[pid].cpu_idx = cpu_idx;
  1042a9:	8b 44 24 20          	mov    0x20(%esp),%eax
}
  1042ad:	83 c4 10             	add    $0x10,%esp
    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3] =
  1042b0:	66 89 9e 2d b0 99 00 	mov    %bx,0x99b02d(%esi)
}
  1042b7:	5b                   	pop    %ebx
    proc_kstack[pid].tss.ts_iopm[128] = 0xff;
  1042b8:	c6 86 18 b1 99 00 ff 	movb   $0xff,0x99b118(%esi)
    proc_kstack[pid].gdt[CPU_GDT_TSS >> 3] =
  1042bf:	66 89 8e 28 b0 99 00 	mov    %cx,0x99b028(%esi)
    proc_kstack[pid].magic = KSTACK_MAGIC;
  1042c6:	c7 86 20 b1 99 00 32 	movl   $0x98765432,0x99b120(%esi)
  1042cd:	54 76 98 
    proc_kstack[pid].cpu_idx = cpu_idx;
  1042d0:	89 86 1c b1 99 00    	mov    %eax,0x99b11c(%esi)
}
  1042d6:	5e                   	pop    %esi
  1042d7:	5f                   	pop    %edi
  1042d8:	c3                   	ret    
  1042d9:	66 90                	xchg   %ax,%ax
  1042db:	66 90                	xchg   %ax,%ax
  1042dd:	66 90                	xchg   %ax,%ax
  1042df:	90                   	nop

001042e0 <max>:
#include "types.h"

uint32_t max(uint32_t a, uint32_t b)
{
  1042e0:	8b 54 24 04          	mov    0x4(%esp),%edx
  1042e4:	8b 44 24 08          	mov    0x8(%esp),%eax
    return (a > b) ? a : b;
  1042e8:	39 d0                	cmp    %edx,%eax
  1042ea:	0f 42 c2             	cmovb  %edx,%eax
}
  1042ed:	c3                   	ret    
  1042ee:	66 90                	xchg   %ax,%ax

001042f0 <min>:

uint32_t min(uint32_t a, uint32_t b)
{
  1042f0:	8b 54 24 04          	mov    0x4(%esp),%edx
  1042f4:	8b 44 24 08          	mov    0x8(%esp),%eax
    return (a < b) ? a : b;
  1042f8:	39 d0                	cmp    %edx,%eax
  1042fa:	0f 47 c2             	cmova  %edx,%eax
}
  1042fd:	c3                   	ret    
  1042fe:	66 90                	xchg   %ax,%ax

00104300 <rounddown>:

uint32_t rounddown(uint32_t a, uint32_t n)
{
  104300:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    return a - a % n;
  104304:	31 d2                	xor    %edx,%edx
  104306:	89 c8                	mov    %ecx,%eax
  104308:	f7 74 24 08          	divl   0x8(%esp)
  10430c:	89 c8                	mov    %ecx,%eax
  10430e:	29 d0                	sub    %edx,%eax
}
  104310:	c3                   	ret    
  104311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10431f:	90                   	nop

00104320 <roundup>:

uint32_t roundup(uint32_t a, uint32_t n)
{
  104320:	53                   	push   %ebx
  104321:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
    return a - a % n;
  104325:	31 d2                	xor    %edx,%edx
    return rounddown(a + n - 1, n);
  104327:	8d 4b ff             	lea    -0x1(%ebx),%ecx
  10432a:	03 4c 24 08          	add    0x8(%esp),%ecx
    return a - a % n;
  10432e:	89 c8                	mov    %ecx,%eax
  104330:	f7 f3                	div    %ebx
  104332:	89 c8                	mov    %ecx,%eax
}
  104334:	5b                   	pop    %ebx
    return a - a % n;
  104335:	29 d0                	sub    %edx,%eax
}
  104337:	c3                   	ret    
  104338:	66 90                	xchg   %ax,%ax
  10433a:	66 90                	xchg   %ax,%ax
  10433c:	66 90                	xchg   %ax,%ax
  10433e:	66 90                	xchg   %ax,%ax

00104340 <read_esp>:
#include "x86.h"

gcc_inline uintptr_t read_esp(void)
{
    uint32_t esp;
    __asm __volatile ("movl %%esp,%0" : "=rm" (esp));
  104340:	89 e0                	mov    %esp,%eax
    return esp;
}
  104342:	c3                   	ret    
  104343:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104350 <read_ebp>:

gcc_inline uint32_t read_ebp(void)
{
    uint32_t ebp;
    __asm __volatile ("movl %%ebp,%0" : "=rm" (ebp));
  104350:	89 e8                	mov    %ebp,%eax
    return ebp;
}
  104352:	c3                   	ret    
  104353:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10435a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104360 <lldt>:

gcc_inline void lldt(uint16_t sel)
{
    __asm __volatile ("lldt %0" :: "r" (sel));
  104360:	8b 44 24 04          	mov    0x4(%esp),%eax
  104364:	0f 00 d0             	lldt   %ax
}
  104367:	c3                   	ret    
  104368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10436f:	90                   	nop

00104370 <cli>:

gcc_inline void cli(void)
{
    __asm __volatile ("cli" ::: "memory");
  104370:	fa                   	cli    
}
  104371:	c3                   	ret    
  104372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104380 <sti>:

gcc_inline void sti(void)
{
    __asm __volatile ("sti; nop");
  104380:	fb                   	sti    
  104381:	90                   	nop
}
  104382:	c3                   	ret    
  104383:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104390 <rdmsr>:

gcc_inline uint64_t rdmsr(uint32_t msr)
{
    uint64_t rv;
    __asm __volatile ("rdmsr"
  104390:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  104394:	0f 32                	rdmsr  
                      : "=A" (rv)
                      : "c" (msr));
    return rv;
}
  104396:	c3                   	ret    
  104397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10439e:	66 90                	xchg   %ax,%ax

001043a0 <wrmsr>:

gcc_inline void wrmsr(uint32_t msr, uint64_t newval)
{
    __asm __volatile ("wrmsr" :: "A" (newval), "c" (msr));
  1043a0:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  1043a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  1043a8:	8b 54 24 0c          	mov    0xc(%esp),%edx
  1043ac:	0f 30                	wrmsr  
}
  1043ae:	c3                   	ret    
  1043af:	90                   	nop

001043b0 <halt>:

gcc_inline void halt(void)
{
    __asm __volatile ("hlt");
  1043b0:	f4                   	hlt    
}
  1043b1:	c3                   	ret    
  1043b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1043b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001043c0 <pause>:

gcc_inline void pause(void)
{
    __asm __volatile ("pause" ::: "memory");
  1043c0:	f3 90                	pause  
}
  1043c2:	c3                   	ret    
  1043c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001043d0 <xchg>:

gcc_inline uint32_t xchg(volatile uint32_t *addr, uint32_t newval)
{
  1043d0:	8b 54 24 04          	mov    0x4(%esp),%edx
    uint32_t result;

    __asm __volatile ("lock; xchgl %0, %1"
  1043d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  1043d8:	f0 87 02             	lock xchg %eax,(%edx)
                      : "+m" (*addr), "=a" (result)
                      : "1" (newval)
                      : "cc");

    return result;
}
  1043db:	c3                   	ret    
  1043dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001043e0 <cmpxchg>:

gcc_inline uint32_t cmpxchg(volatile uint32_t *addr, uint32_t oldval, uint32_t newval)
{
  1043e0:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    uint32_t result;

    __asm __volatile ("lock; cmpxchgl %2, %0"
  1043e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  1043e8:	8b 54 24 0c          	mov    0xc(%esp),%edx
  1043ec:	f0 0f b1 11          	lock cmpxchg %edx,(%ecx)
                      : "+m" (*addr), "=a" (result)
                      : "r" (newval), "a" (oldval)
                      : "memory", "cc");

    return result;
}
  1043f0:	c3                   	ret    
  1043f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1043f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1043ff:	90                   	nop

00104400 <rdtsc>:

gcc_inline uint64_t rdtsc(void)
{
    uint64_t rv;

    __asm __volatile ("rdtsc" : "=A" (rv));
  104400:	0f 31                	rdtsc  
    return (rv);
}
  104402:	c3                   	ret    
  104403:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104410 <enable_sse>:
}

gcc_inline uint32_t rcr4(void)
{
    uint32_t cr4;
    __asm __volatile ("movl %%cr4,%0" : "=r" (cr4));
  104410:	0f 20 e0             	mov    %cr4,%eax
    FENCE();
  104413:	0f ae f0             	mfence 
    cr4 = rcr4() | CR4_OSFXSR | CR4_OSXMMEXCPT;
  104416:	80 cc 06             	or     $0x6,%ah
    __asm __volatile ("movl %0,%%cr4" :: "r" (val));
  104419:	0f 22 e0             	mov    %eax,%cr4
    __asm __volatile ("movl %%cr0,%0" : "=r" (val));
  10441c:	0f 20 c0             	mov    %cr0,%eax
    FENCE();
  10441f:	0f ae f0             	mfence 
}
  104422:	c3                   	ret    
  104423:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104430 <cpuid>:
{
  104430:	55                   	push   %ebp
  104431:	57                   	push   %edi
  104432:	56                   	push   %esi
  104433:	53                   	push   %ebx
  104434:	8b 44 24 14          	mov    0x14(%esp),%eax
  104438:	8b 74 24 18          	mov    0x18(%esp),%esi
  10443c:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  104440:	8b 6c 24 20          	mov    0x20(%esp),%ebp
    __asm __volatile ("cpuid"
  104444:	0f a2                	cpuid  
    if (eaxp)
  104446:	85 f6                	test   %esi,%esi
  104448:	74 02                	je     10444c <cpuid+0x1c>
        *eaxp = eax;
  10444a:	89 06                	mov    %eax,(%esi)
    if (ebxp)
  10444c:	85 ff                	test   %edi,%edi
  10444e:	74 02                	je     104452 <cpuid+0x22>
        *ebxp = ebx;
  104450:	89 1f                	mov    %ebx,(%edi)
    if (ecxp)
  104452:	85 ed                	test   %ebp,%ebp
  104454:	74 03                	je     104459 <cpuid+0x29>
        *ecxp = ecx;
  104456:	89 4d 00             	mov    %ecx,0x0(%ebp)
    if (edxp)
  104459:	8b 44 24 24          	mov    0x24(%esp),%eax
  10445d:	85 c0                	test   %eax,%eax
  10445f:	74 06                	je     104467 <cpuid+0x37>
        *edxp = edx;
  104461:	8b 44 24 24          	mov    0x24(%esp),%eax
  104465:	89 10                	mov    %edx,(%eax)
}
  104467:	5b                   	pop    %ebx
  104468:	5e                   	pop    %esi
  104469:	5f                   	pop    %edi
  10446a:	5d                   	pop    %ebp
  10446b:	c3                   	ret    
  10446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104470 <cpuid_subleaf>:
{
  104470:	55                   	push   %ebp
  104471:	57                   	push   %edi
  104472:	56                   	push   %esi
  104473:	53                   	push   %ebx
  104474:	8b 74 24 1c          	mov    0x1c(%esp),%esi
  104478:	8b 7c 24 20          	mov    0x20(%esp),%edi
  10447c:	8b 6c 24 24          	mov    0x24(%esp),%ebp
    asm volatile ("cpuid"
  104480:	8b 44 24 14          	mov    0x14(%esp),%eax
  104484:	8b 4c 24 18          	mov    0x18(%esp),%ecx
  104488:	0f a2                	cpuid  
    if (eaxp)
  10448a:	85 f6                	test   %esi,%esi
  10448c:	74 02                	je     104490 <cpuid_subleaf+0x20>
        *eaxp = eax;
  10448e:	89 06                	mov    %eax,(%esi)
    if (ebxp)
  104490:	85 ff                	test   %edi,%edi
  104492:	74 02                	je     104496 <cpuid_subleaf+0x26>
        *ebxp = ebx;
  104494:	89 1f                	mov    %ebx,(%edi)
    if (ecxp)
  104496:	85 ed                	test   %ebp,%ebp
  104498:	74 03                	je     10449d <cpuid_subleaf+0x2d>
        *ecxp = ecx;
  10449a:	89 4d 00             	mov    %ecx,0x0(%ebp)
    if (edxp)
  10449d:	8b 44 24 28          	mov    0x28(%esp),%eax
  1044a1:	85 c0                	test   %eax,%eax
  1044a3:	74 06                	je     1044ab <cpuid_subleaf+0x3b>
        *edxp = edx;
  1044a5:	8b 44 24 28          	mov    0x28(%esp),%eax
  1044a9:	89 10                	mov    %edx,(%eax)
}
  1044ab:	5b                   	pop    %ebx
  1044ac:	5e                   	pop    %esi
  1044ad:	5f                   	pop    %edi
  1044ae:	5d                   	pop    %ebp
  1044af:	c3                   	ret    

001044b0 <rcr3>:
    __asm __volatile ("movl %%cr3,%0" : "=r" (val));
  1044b0:	0f 20 d8             	mov    %cr3,%eax
}
  1044b3:	c3                   	ret    
  1044b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1044bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1044bf:	90                   	nop

001044c0 <outl>:
    __asm __volatile ("outl %0,%w1" :: "a" (data), "d" (port));
  1044c0:	8b 54 24 04          	mov    0x4(%esp),%edx
  1044c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  1044c8:	ef                   	out    %eax,(%dx)
}
  1044c9:	c3                   	ret    
  1044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001044d0 <inl>:
    __asm __volatile ("inl %w1,%0" : "=a" (data) : "d" (port));
  1044d0:	8b 54 24 04          	mov    0x4(%esp),%edx
  1044d4:	ed                   	in     (%dx),%eax
}
  1044d5:	c3                   	ret    
  1044d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1044dd:	8d 76 00             	lea    0x0(%esi),%esi

001044e0 <smp_wmb>:
}
  1044e0:	c3                   	ret    
  1044e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1044e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1044ef:	90                   	nop

001044f0 <ltr>:
    __asm __volatile ("ltr %0" :: "r" (sel));
  1044f0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1044f4:	0f 00 d8             	ltr    %ax
}
  1044f7:	c3                   	ret    
  1044f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1044ff:	90                   	nop

00104500 <lcr0>:
    __asm __volatile ("movl %0,%%cr0" :: "r" (val));
  104500:	8b 44 24 04          	mov    0x4(%esp),%eax
  104504:	0f 22 c0             	mov    %eax,%cr0
}
  104507:	c3                   	ret    
  104508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10450f:	90                   	nop

00104510 <rcr0>:
    __asm __volatile ("movl %%cr0,%0" : "=r" (val));
  104510:	0f 20 c0             	mov    %cr0,%eax
}
  104513:	c3                   	ret    
  104514:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10451b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10451f:	90                   	nop

00104520 <rcr2>:
    __asm __volatile ("movl %%cr2,%0" : "=r" (val));
  104520:	0f 20 d0             	mov    %cr2,%eax
}
  104523:	c3                   	ret    
  104524:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10452b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10452f:	90                   	nop

00104530 <lcr3>:
    __asm __volatile ("movl %0,%%cr3" :: "r" (val));
  104530:	8b 44 24 04          	mov    0x4(%esp),%eax
  104534:	0f 22 d8             	mov    %eax,%cr3
}
  104537:	c3                   	ret    
  104538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10453f:	90                   	nop

00104540 <lcr4>:
    __asm __volatile ("movl %0,%%cr4" :: "r" (val));
  104540:	8b 44 24 04          	mov    0x4(%esp),%eax
  104544:	0f 22 e0             	mov    %eax,%cr4
}
  104547:	c3                   	ret    
  104548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10454f:	90                   	nop

00104550 <rcr4>:
    __asm __volatile ("movl %%cr4,%0" : "=r" (cr4));
  104550:	0f 20 e0             	mov    %cr4,%eax
    return cr4;
}
  104553:	c3                   	ret    
  104554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10455b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10455f:	90                   	nop

00104560 <inb>:

gcc_inline uint8_t inb(int port)
{
    uint8_t data;
    __asm __volatile ("inb %w1,%0"
  104560:	8b 54 24 04          	mov    0x4(%esp),%edx
  104564:	ec                   	in     (%dx),%al
                      : "=a" (data)
                      : "d" (port));
    return data;
}
  104565:	c3                   	ret    
  104566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10456d:	8d 76 00             	lea    0x0(%esi),%esi

00104570 <insl>:

gcc_inline void insl(int port, void *addr, int cnt)
{
  104570:	57                   	push   %edi
    __asm __volatile ("cld\n\trepne\n\tinsl"
  104571:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  104575:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  104579:	8b 54 24 08          	mov    0x8(%esp),%edx
  10457d:	fc                   	cld    
  10457e:	f2 6d                	repnz insl (%dx),%es:(%edi)
                      : "=D" (addr), "=c" (cnt)
                      : "d" (port), "0" (addr), "1" (cnt)
                      : "memory", "cc");
}
  104580:	5f                   	pop    %edi
  104581:	c3                   	ret    
  104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104590 <outb>:

gcc_inline void outb(int port, uint8_t data)
{
    __asm __volatile ("outb %0,%w1" :: "a" (data), "d" (port));
  104590:	8b 54 24 04          	mov    0x4(%esp),%edx
  104594:	8b 44 24 08          	mov    0x8(%esp),%eax
  104598:	ee                   	out    %al,(%dx)
}
  104599:	c3                   	ret    
  10459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001045a0 <outsw>:

gcc_inline void outsw(int port, const void *addr, int cnt)
{
  1045a0:	56                   	push   %esi
    __asm __volatile ("cld\n\trepne\n\toutsw"
  1045a1:	8b 74 24 0c          	mov    0xc(%esp),%esi
  1045a5:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  1045a9:	8b 54 24 08          	mov    0x8(%esp),%edx
  1045ad:	fc                   	cld    
  1045ae:	f2 66 6f             	repnz outsw %ds:(%esi),(%dx)
                      : "=S" (addr), "=c" (cnt)
                      : "d" (port), "0" (addr), "1" (cnt)
                      : "cc");
}
  1045b1:	5e                   	pop    %esi
  1045b2:	c3                   	ret    
  1045b3:	66 90                	xchg   %ax,%ax
  1045b5:	66 90                	xchg   %ax,%ax
  1045b7:	66 90                	xchg   %ax,%ax
  1045b9:	66 90                	xchg   %ax,%ax
  1045bb:	66 90                	xchg   %ax,%ax
  1045bd:	66 90                	xchg   %ax,%ax
  1045bf:	90                   	nop

001045c0 <mon_help>:

#define NCOMMANDS (sizeof(commands) / sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/
int mon_help(int argc, char **argv, struct Trapframe *tf)
{
  1045c0:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < NCOMMANDS; i++)
        dprintf("%s - %s\n", commands[i].name, commands[i].desc);
  1045c3:	68 f8 a3 10 00       	push   $0x10a3f8
  1045c8:	68 16 a4 10 00       	push   $0x10a416
  1045cd:	68 1b a4 10 00       	push   $0x10a41b
  1045d2:	e8 89 f4 ff ff       	call   103a60 <dprintf>
  1045d7:	83 c4 0c             	add    $0xc,%esp
  1045da:	68 c0 a4 10 00       	push   $0x10a4c0
  1045df:	68 24 a4 10 00       	push   $0x10a424
  1045e4:	68 1b a4 10 00       	push   $0x10a41b
  1045e9:	e8 72 f4 ff ff       	call   103a60 <dprintf>
    return 0;
}
  1045ee:	31 c0                	xor    %eax,%eax
  1045f0:	83 c4 1c             	add    $0x1c,%esp
  1045f3:	c3                   	ret    
  1045f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1045fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1045ff:	90                   	nop

00104600 <mon_kerninfo>:

int mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
  104600:	83 ec 18             	sub    $0x18,%esp
    extern uint8_t start[], etext[], edata[], end[];

    dprintf("Special kernel symbols:\n");
  104603:	68 2d a4 10 00       	push   $0x10a42d
  104608:	e8 53 f4 ff ff       	call   103a60 <dprintf>
    dprintf("  start  %08x\n", start);
  10460d:	58                   	pop    %eax
  10460e:	5a                   	pop    %edx
  10460f:	68 f4 5d 10 00       	push   $0x105df4
  104614:	68 46 a4 10 00       	push   $0x10a446
  104619:	e8 42 f4 ff ff       	call   103a60 <dprintf>
    dprintf("  etext  %08x\n", etext);
  10461e:	59                   	pop    %ecx
  10461f:	58                   	pop    %eax
  104620:	68 1d 84 10 00       	push   $0x10841d
  104625:	68 55 a4 10 00       	push   $0x10a455
  10462a:	e8 31 f4 ff ff       	call   103a60 <dprintf>
    dprintf("  edata  %08x\n", edata);
  10462f:	58                   	pop    %eax
  104630:	5a                   	pop    %edx
  104631:	68 da ba 14 00       	push   $0x14bada
  104636:	68 64 a4 10 00       	push   $0x10a464
  10463b:	e8 20 f4 ff ff       	call   103a60 <dprintf>
    dprintf("  end    %08x\n", end);
  104640:	59                   	pop    %ecx
  104641:	58                   	pop    %eax
  104642:	68 e0 ff e1 00       	push   $0xe1ffe0
  104647:	68 73 a4 10 00       	push   $0x10a473
  10464c:	e8 0f f4 ff ff       	call   103a60 <dprintf>
    dprintf("Kernel executable memory footprint: %dKB\n",
            ROUNDUP(end - start, 1024) / 1024);
  104651:	b8 e0 ff e1 00       	mov    $0xe1ffe0,%eax
    dprintf("Kernel executable memory footprint: %dKB\n",
  104656:	5a                   	pop    %edx
  104657:	59                   	pop    %ecx
            ROUNDUP(end - start, 1024) / 1024);
  104658:	2d f5 59 10 00       	sub    $0x1059f5,%eax
  10465d:	89 c1                	mov    %eax,%ecx
  10465f:	c1 f9 1f             	sar    $0x1f,%ecx
  104662:	c1 e9 16             	shr    $0x16,%ecx
  104665:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  104668:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  10466e:	29 ca                	sub    %ecx,%edx
  104670:	29 d0                	sub    %edx,%eax
    dprintf("Kernel executable memory footprint: %dKB\n",
  104672:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  104678:	0f 48 c2             	cmovs  %edx,%eax
  10467b:	c1 f8 0a             	sar    $0xa,%eax
  10467e:	50                   	push   %eax
  10467f:	68 e8 a4 10 00       	push   $0x10a4e8
  104684:	e8 d7 f3 ff ff       	call   103a60 <dprintf>
    return 0;
}
  104689:	31 c0                	xor    %eax,%eax
  10468b:	83 c4 1c             	add    $0x1c,%esp
  10468e:	c3                   	ret    
  10468f:	90                   	nop

00104690 <monitor>:
    dprintf("Unknown command '%s'\n", argv[0]);
    return 0;
}

void monitor(struct Trapframe *tf)
{
  104690:	57                   	push   %edi
  104691:	56                   	push   %esi
  104692:	53                   	push   %ebx
  104693:	83 ec 4c             	sub    $0x4c,%esp
    char *buf;

    dprintf("\n****************************************\n\n");
  104696:	68 14 a5 10 00       	push   $0x10a514
  10469b:	e8 c0 f3 ff ff       	call   103a60 <dprintf>
    dprintf("Welcome to the mCertiKOS kernel monitor!\n");
  1046a0:	c7 04 24 40 a5 10 00 	movl   $0x10a540,(%esp)
  1046a7:	e8 b4 f3 ff ff       	call   103a60 <dprintf>
    dprintf("\n****************************************\n\n");
  1046ac:	c7 04 24 14 a5 10 00 	movl   $0x10a514,(%esp)
  1046b3:	e8 a8 f3 ff ff       	call   103a60 <dprintf>
    dprintf("Type 'help' for a list of commands.\n");
  1046b8:	c7 04 24 6c a5 10 00 	movl   $0x10a56c,(%esp)
  1046bf:	e8 9c f3 ff ff       	call   103a60 <dprintf>
  1046c4:	83 c4 10             	add    $0x10,%esp
  1046c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1046ce:	66 90                	xchg   %ax,%ax

    while (1) {
        buf = (char *) readline("$> ");
  1046d0:	83 ec 0c             	sub    $0xc,%esp
  1046d3:	68 82 a4 10 00       	push   $0x10a482
  1046d8:	e8 e3 bd ff ff       	call   1004c0 <readline>
        if (buf != NULL)
  1046dd:	83 c4 10             	add    $0x10,%esp
        buf = (char *) readline("$> ");
  1046e0:	89 c3                	mov    %eax,%ebx
        if (buf != NULL)
  1046e2:	85 c0                	test   %eax,%eax
  1046e4:	74 ea                	je     1046d0 <monitor+0x40>
    argv[argc] = 0;
  1046e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1046ed:	0f be 00             	movsbl (%eax),%eax
    argc = 0;
  1046f0:	31 ff                	xor    %edi,%edi
  1046f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        while (*buf && strchr(WHITESPACE, *buf))
  1046f8:	84 c0                	test   %al,%al
  1046fa:	75 64                	jne    104760 <monitor+0xd0>
    argv[argc] = 0;
  1046fc:	c7 04 bc 00 00 00 00 	movl   $0x0,(%esp,%edi,4)
    if (argc == 0)
  104703:	85 ff                	test   %edi,%edi
  104705:	74 c9                	je     1046d0 <monitor+0x40>
        if (strcmp(argv[0], commands[i].name) == 0)
  104707:	83 ec 08             	sub    $0x8,%esp
  10470a:	68 16 a4 10 00       	push   $0x10a416
  10470f:	ff 74 24 0c          	pushl  0xc(%esp)
  104713:	e8 68 ef ff ff       	call   103680 <strcmp>
  104718:	83 c4 10             	add    $0x10,%esp
  10471b:	85 c0                	test   %eax,%eax
  10471d:	0f 84 eb 00 00 00    	je     10480e <monitor+0x17e>
  104723:	83 ec 08             	sub    $0x8,%esp
  104726:	68 24 a4 10 00       	push   $0x10a424
  10472b:	ff 74 24 0c          	pushl  0xc(%esp)
  10472f:	e8 4c ef ff ff       	call   103680 <strcmp>
  104734:	83 c4 10             	add    $0x10,%esp
  104737:	85 c0                	test   %eax,%eax
  104739:	0f 84 f5 00 00 00    	je     104834 <monitor+0x1a4>
    dprintf("Unknown command '%s'\n", argv[0]);
  10473f:	83 ec 08             	sub    $0x8,%esp
  104742:	ff 74 24 08          	pushl  0x8(%esp)
  104746:	68 a8 a4 10 00       	push   $0x10a4a8
  10474b:	e8 10 f3 ff ff       	call   103a60 <dprintf>
    return 0;
  104750:	83 c4 10             	add    $0x10,%esp
  104753:	e9 78 ff ff ff       	jmp    1046d0 <monitor+0x40>
  104758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10475f:	90                   	nop
        while (*buf && strchr(WHITESPACE, *buf))
  104760:	83 ec 08             	sub    $0x8,%esp
  104763:	50                   	push   %eax
  104764:	68 86 a4 10 00       	push   $0x10a486
  104769:	e8 52 ef ff ff       	call   1036c0 <strchr>
  10476e:	83 c4 10             	add    $0x10,%esp
  104771:	85 c0                	test   %eax,%eax
  104773:	74 13                	je     104788 <monitor+0xf8>
            *buf++ = 0;
  104775:	c6 03 00             	movb   $0x0,(%ebx)
  104778:	0f be 43 01          	movsbl 0x1(%ebx),%eax
  10477c:	83 c3 01             	add    $0x1,%ebx
  10477f:	e9 74 ff ff ff       	jmp    1046f8 <monitor+0x68>
  104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (*buf == 0)
  104788:	80 3b 00             	cmpb   $0x0,(%ebx)
  10478b:	0f 84 6b ff ff ff    	je     1046fc <monitor+0x6c>
        if (argc == MAXARGS - 1) {
  104791:	83 ff 0f             	cmp    $0xf,%edi
  104794:	74 4a                	je     1047e0 <monitor+0x150>
        argv[argc++] = buf;
  104796:	89 1c bc             	mov    %ebx,(%esp,%edi,4)
        while (*buf && !strchr(WHITESPACE, *buf))
  104799:	0f be 03             	movsbl (%ebx),%eax
        argv[argc++] = buf;
  10479c:	8d 77 01             	lea    0x1(%edi),%esi
        while (*buf && !strchr(WHITESPACE, *buf))
  10479f:	84 c0                	test   %al,%al
  1047a1:	75 10                	jne    1047b3 <monitor+0x123>
  1047a3:	eb 5b                	jmp    104800 <monitor+0x170>
  1047a5:	8d 76 00             	lea    0x0(%esi),%esi
  1047a8:	0f be 43 01          	movsbl 0x1(%ebx),%eax
            buf++;
  1047ac:	83 c3 01             	add    $0x1,%ebx
        while (*buf && !strchr(WHITESPACE, *buf))
  1047af:	84 c0                	test   %al,%al
  1047b1:	74 25                	je     1047d8 <monitor+0x148>
  1047b3:	83 ec 08             	sub    $0x8,%esp
  1047b6:	50                   	push   %eax
  1047b7:	68 86 a4 10 00       	push   $0x10a486
  1047bc:	e8 ff ee ff ff       	call   1036c0 <strchr>
  1047c1:	83 c4 10             	add    $0x10,%esp
  1047c4:	85 c0                	test   %eax,%eax
  1047c6:	74 e0                	je     1047a8 <monitor+0x118>
  1047c8:	0f be 03             	movsbl (%ebx),%eax
        argv[argc++] = buf;
  1047cb:	89 f7                	mov    %esi,%edi
  1047cd:	e9 26 ff ff ff       	jmp    1046f8 <monitor+0x68>
  1047d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1047d8:	89 f7                	mov    %esi,%edi
  1047da:	e9 1d ff ff ff       	jmp    1046fc <monitor+0x6c>
  1047df:	90                   	nop
            dprintf("Too many arguments (max %d)\n", MAXARGS);
  1047e0:	83 ec 08             	sub    $0x8,%esp
  1047e3:	6a 10                	push   $0x10
  1047e5:	68 8b a4 10 00       	push   $0x10a48b
  1047ea:	e8 71 f2 ff ff       	call   103a60 <dprintf>
            return 0;
  1047ef:	83 c4 10             	add    $0x10,%esp
  1047f2:	e9 d9 fe ff ff       	jmp    1046d0 <monitor+0x40>
  1047f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1047fe:	66 90                	xchg   %ax,%ax
    argv[argc] = 0;
  104800:	c7 04 b4 00 00 00 00 	movl   $0x0,(%esp,%esi,4)
        argv[argc++] = buf;
  104807:	89 f7                	mov    %esi,%edi
  104809:	e9 f9 fe ff ff       	jmp    104707 <monitor+0x77>
        if (strcmp(argv[0], commands[i].name) == 0)
  10480e:	b8 c0 45 10 00       	mov    $0x1045c0,%eax
            return commands[i].func(argc, argv, tf);
  104813:	83 ec 04             	sub    $0x4,%esp
  104816:	ff 74 24 54          	pushl  0x54(%esp)
  10481a:	8d 54 24 08          	lea    0x8(%esp),%edx
  10481e:	52                   	push   %edx
  10481f:	57                   	push   %edi
  104820:	ff d0                	call   *%eax
            if (runcmd(buf, tf) < 0)
  104822:	83 c4 10             	add    $0x10,%esp
  104825:	85 c0                	test   %eax,%eax
  104827:	0f 89 a3 fe ff ff    	jns    1046d0 <monitor+0x40>
                break;
    }
}
  10482d:	83 c4 40             	add    $0x40,%esp
  104830:	5b                   	pop    %ebx
  104831:	5e                   	pop    %esi
  104832:	5f                   	pop    %edi
  104833:	c3                   	ret    
        if (strcmp(argv[0], commands[i].name) == 0)
  104834:	b8 00 46 10 00       	mov    $0x104600,%eax
  104839:	eb d8                	jmp    104813 <monitor+0x183>
  10483b:	66 90                	xchg   %ax,%ax
  10483d:	66 90                	xchg   %ax,%ax
  10483f:	90                   	nop

00104840 <pt_copyin>:
                       unsigned int perm);
extern unsigned int get_ptbl_entry_by_va(unsigned int pid,
                                         unsigned int vaddr);

size_t pt_copyin(uint32_t pmap_id, uintptr_t uva, void *kva, size_t len)
{
  104840:	55                   	push   %ebp
    if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
        return 0;
  104841:	31 ed                	xor    %ebp,%ebp
{
  104843:	57                   	push   %edi
  104844:	56                   	push   %esi
  104845:	53                   	push   %ebx
  104846:	83 ec 1c             	sub    $0x1c,%esp
  104849:	8b 74 24 34          	mov    0x34(%esp),%esi
  10484d:	8b 7c 24 38          	mov    0x38(%esp),%edi
  104851:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
    if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
  104855:	81 fe ff ff ff 3f    	cmp    $0x3fffffff,%esi
  10485b:	0f 86 a3 00 00 00    	jbe    104904 <pt_copyin+0xc4>
  104861:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  104864:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  104869:	0f 87 95 00 00 00    	ja     104904 <pt_copyin+0xc4>

    if ((uintptr_t) kva + len > VM_USERHI)
  10486f:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  104872:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  104877:	0f 87 87 00 00 00    	ja     104904 <pt_copyin+0xc4>
        return 0;

    size_t copied = 0;

    while (len) {
  10487d:	85 db                	test   %ebx,%ebx
  10487f:	0f 84 7f 00 00 00    	je     104904 <pt_copyin+0xc4>
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
        }

        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);

        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  104885:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
  104889:	eb 3e                	jmp    1048c9 <pt_copyin+0x89>
  10488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10488f:	90                   	nop
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  104890:	89 f2                	mov    %esi,%edx
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  104892:	b9 00 10 00 00       	mov    $0x1000,%ecx
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  104897:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10489c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1048a2:	29 d1                	sub    %edx,%ecx
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  1048a4:	09 d0                	or     %edx,%eax
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1048a6:	39 d9                	cmp    %ebx,%ecx
  1048a8:	89 ca                	mov    %ecx,%edx
  1048aa:	0f 47 d3             	cmova  %ebx,%edx
            len : PAGESIZE - uva_pa % PAGESIZE;

        memcpy(kva, (void *) uva_pa, size);
  1048ad:	83 ec 04             	sub    $0x4,%esp
  1048b0:	52                   	push   %edx
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1048b1:	89 d5                	mov    %edx,%ebp
        memcpy(kva, (void *) uva_pa, size);
  1048b3:	50                   	push   %eax

        len -= size;
        uva += size;
  1048b4:	01 ee                	add    %ebp,%esi
        memcpy(kva, (void *) uva_pa, size);
  1048b6:	57                   	push   %edi
        kva += size;
  1048b7:	01 ef                	add    %ebp,%edi
        memcpy(kva, (void *) uva_pa, size);
  1048b9:	e8 32 ed ff ff       	call   1035f0 <memcpy>
        copied += size;
  1048be:	01 6c 24 1c          	add    %ebp,0x1c(%esp)
    while (len) {
  1048c2:	83 c4 10             	add    $0x10,%esp
  1048c5:	29 eb                	sub    %ebp,%ebx
  1048c7:	74 37                	je     104900 <pt_copyin+0xc0>
        uintptr_t uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  1048c9:	83 ec 08             	sub    $0x8,%esp
  1048cc:	56                   	push   %esi
  1048cd:	ff 74 24 3c          	pushl  0x3c(%esp)
  1048d1:	e8 ea 1d 00 00       	call   1066c0 <get_ptbl_entry_by_va>
        if ((uva_pa & PTE_P) == 0) {
  1048d6:	83 c4 10             	add    $0x10,%esp
  1048d9:	a8 01                	test   $0x1,%al
  1048db:	75 b3                	jne    104890 <pt_copyin+0x50>
            alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
  1048dd:	83 ec 04             	sub    $0x4,%esp
  1048e0:	6a 07                	push   $0x7
  1048e2:	56                   	push   %esi
  1048e3:	ff 74 24 3c          	pushl  0x3c(%esp)
  1048e7:	e8 74 21 00 00       	call   106a60 <alloc_page>
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  1048ec:	58                   	pop    %eax
  1048ed:	5a                   	pop    %edx
  1048ee:	56                   	push   %esi
  1048ef:	ff 74 24 3c          	pushl  0x3c(%esp)
  1048f3:	e8 c8 1d 00 00       	call   1066c0 <get_ptbl_entry_by_va>
  1048f8:	83 c4 10             	add    $0x10,%esp
  1048fb:	eb 93                	jmp    104890 <pt_copyin+0x50>
  1048fd:	8d 76 00             	lea    0x0(%esi),%esi
  104900:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
    }

    return copied;
}
  104904:	83 c4 1c             	add    $0x1c,%esp
  104907:	89 e8                	mov    %ebp,%eax
  104909:	5b                   	pop    %ebx
  10490a:	5e                   	pop    %esi
  10490b:	5f                   	pop    %edi
  10490c:	5d                   	pop    %ebp
  10490d:	c3                   	ret    
  10490e:	66 90                	xchg   %ax,%ax

00104910 <pt_copyout>:

size_t pt_copyout(void *kva, uint32_t pmap_id, uintptr_t uva, size_t len)
{
  104910:	55                   	push   %ebp
    if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
        return 0;
  104911:	31 ed                	xor    %ebp,%ebp
{
  104913:	57                   	push   %edi
  104914:	56                   	push   %esi
  104915:	53                   	push   %ebx
  104916:	83 ec 1c             	sub    $0x1c,%esp
  104919:	8b 74 24 38          	mov    0x38(%esp),%esi
  10491d:	8b 7c 24 30          	mov    0x30(%esp),%edi
  104921:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
    if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
  104925:	81 fe ff ff ff 3f    	cmp    $0x3fffffff,%esi
  10492b:	0f 86 a3 00 00 00    	jbe    1049d4 <pt_copyout+0xc4>
  104931:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  104934:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  104939:	0f 87 95 00 00 00    	ja     1049d4 <pt_copyout+0xc4>

    if ((uintptr_t) kva + len > VM_USERHI)
  10493f:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  104942:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  104947:	0f 87 87 00 00 00    	ja     1049d4 <pt_copyout+0xc4>
        return 0;

    size_t copied = 0;

    while (len) {
  10494d:	85 db                	test   %ebx,%ebx
  10494f:	0f 84 7f 00 00 00    	je     1049d4 <pt_copyout+0xc4>
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
        }

        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);

        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  104955:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
  104959:	eb 3e                	jmp    104999 <pt_copyout+0x89>
  10495b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10495f:	90                   	nop
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  104960:	89 f2                	mov    %esi,%edx
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  104962:	b9 00 10 00 00       	mov    $0x1000,%ecx
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  104967:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10496c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  104972:	29 d1                	sub    %edx,%ecx
        uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  104974:	09 d0                	or     %edx,%eax
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  104976:	39 d9                	cmp    %ebx,%ecx
  104978:	89 ca                	mov    %ecx,%edx
  10497a:	0f 47 d3             	cmova  %ebx,%edx
            len : PAGESIZE - uva_pa % PAGESIZE;

        memcpy((void *) uva_pa, kva, size);
  10497d:	83 ec 04             	sub    $0x4,%esp
  104980:	52                   	push   %edx
        size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  104981:	89 d5                	mov    %edx,%ebp
        memcpy((void *) uva_pa, kva, size);
  104983:	57                   	push   %edi

        len -= size;
        uva += size;
  104984:	01 ee                	add    %ebp,%esi
        kva += size;
  104986:	01 ef                	add    %ebp,%edi
        memcpy((void *) uva_pa, kva, size);
  104988:	50                   	push   %eax
  104989:	e8 62 ec ff ff       	call   1035f0 <memcpy>
        copied += size;
  10498e:	01 6c 24 1c          	add    %ebp,0x1c(%esp)
    while (len) {
  104992:	83 c4 10             	add    $0x10,%esp
  104995:	29 eb                	sub    %ebp,%ebx
  104997:	74 37                	je     1049d0 <pt_copyout+0xc0>
        uintptr_t uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  104999:	83 ec 08             	sub    $0x8,%esp
  10499c:	56                   	push   %esi
  10499d:	ff 74 24 40          	pushl  0x40(%esp)
  1049a1:	e8 1a 1d 00 00       	call   1066c0 <get_ptbl_entry_by_va>
        if ((uva_pa & PTE_P) == 0) {
  1049a6:	83 c4 10             	add    $0x10,%esp
  1049a9:	a8 01                	test   $0x1,%al
  1049ab:	75 b3                	jne    104960 <pt_copyout+0x50>
            alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
  1049ad:	83 ec 04             	sub    $0x4,%esp
  1049b0:	6a 07                	push   $0x7
  1049b2:	56                   	push   %esi
  1049b3:	ff 74 24 40          	pushl  0x40(%esp)
  1049b7:	e8 a4 20 00 00       	call   106a60 <alloc_page>
            uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  1049bc:	58                   	pop    %eax
  1049bd:	5a                   	pop    %edx
  1049be:	56                   	push   %esi
  1049bf:	ff 74 24 40          	pushl  0x40(%esp)
  1049c3:	e8 f8 1c 00 00       	call   1066c0 <get_ptbl_entry_by_va>
  1049c8:	83 c4 10             	add    $0x10,%esp
  1049cb:	eb 93                	jmp    104960 <pt_copyout+0x50>
  1049cd:	8d 76 00             	lea    0x0(%esi),%esi
  1049d0:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
    }

    return copied;
}
  1049d4:	83 c4 1c             	add    $0x1c,%esp
  1049d7:	89 e8                	mov    %ebp,%eax
  1049d9:	5b                   	pop    %ebx
  1049da:	5e                   	pop    %esi
  1049db:	5f                   	pop    %edi
  1049dc:	5d                   	pop    %ebp
  1049dd:	c3                   	ret    
  1049de:	66 90                	xchg   %ax,%ax

001049e0 <pt_memset>:

size_t pt_memset(uint32_t pmap_id, uintptr_t va, char c, size_t len)
{
  1049e0:	55                   	push   %ebp
  1049e1:	57                   	push   %edi
  1049e2:	56                   	push   %esi
  1049e3:	53                   	push   %ebx
  1049e4:	83 ec 1c             	sub    $0x1c,%esp
  1049e7:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
  1049eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  1049ef:	8b 44 24 38          	mov    0x38(%esp),%eax
    size_t set = 0;

    while (len) {
  1049f3:	85 db                	test   %ebx,%ebx
  1049f5:	0f 84 85 00 00 00    	je     104a80 <pt_memset+0xa0>
  1049fb:	0f be c0             	movsbl %al,%eax
    size_t set = 0;
  1049fe:	31 ff                	xor    %edi,%edi
  104a00:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a04:	eb 42                	jmp    104a48 <pt_memset+0x68>
  104a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104a0d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((pa & PTE_P) == 0) {
            alloc_page(pmap_id, va, PTE_P | PTE_U | PTE_W);
            pa = get_ptbl_entry_by_va(pmap_id, va);
        }

        pa = (pa & 0xfffff000) + (va % PAGESIZE);
  104a10:	89 f2                	mov    %esi,%edx

        size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  104a12:	b9 00 10 00 00       	mov    $0x1000,%ecx
        pa = (pa & 0xfffff000) + (va % PAGESIZE);
  104a17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104a1c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  104a22:	29 d1                	sub    %edx,%ecx
        pa = (pa & 0xfffff000) + (va % PAGESIZE);
  104a24:	09 d0                	or     %edx,%eax
        size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  104a26:	39 d9                	cmp    %ebx,%ecx
  104a28:	89 ca                	mov    %ecx,%edx
  104a2a:	0f 47 d3             	cmova  %ebx,%edx
            len : PAGESIZE - pa % PAGESIZE;

        memset((void *) pa, c, size);
  104a2d:	83 ec 04             	sub    $0x4,%esp
  104a30:	52                   	push   %edx
        size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  104a31:	89 d5                	mov    %edx,%ebp
        memset((void *) pa, c, size);
  104a33:	ff 74 24 14          	pushl  0x14(%esp)

        len -= size;
        va += size;
  104a37:	01 ee                	add    %ebp,%esi
        set += size;
  104a39:	01 ef                	add    %ebp,%edi
        memset((void *) pa, c, size);
  104a3b:	50                   	push   %eax
  104a3c:	e8 ef ea ff ff       	call   103530 <memset>
    while (len) {
  104a41:	83 c4 10             	add    $0x10,%esp
  104a44:	29 eb                	sub    %ebp,%ebx
  104a46:	74 3a                	je     104a82 <pt_memset+0xa2>
        uintptr_t pa = get_ptbl_entry_by_va(pmap_id, va);
  104a48:	83 ec 08             	sub    $0x8,%esp
  104a4b:	56                   	push   %esi
  104a4c:	ff 74 24 3c          	pushl  0x3c(%esp)
  104a50:	e8 6b 1c 00 00       	call   1066c0 <get_ptbl_entry_by_va>
        if ((pa & PTE_P) == 0) {
  104a55:	83 c4 10             	add    $0x10,%esp
  104a58:	a8 01                	test   $0x1,%al
  104a5a:	75 b4                	jne    104a10 <pt_memset+0x30>
            alloc_page(pmap_id, va, PTE_P | PTE_U | PTE_W);
  104a5c:	83 ec 04             	sub    $0x4,%esp
  104a5f:	6a 07                	push   $0x7
  104a61:	56                   	push   %esi
  104a62:	ff 74 24 3c          	pushl  0x3c(%esp)
  104a66:	e8 f5 1f 00 00       	call   106a60 <alloc_page>
            pa = get_ptbl_entry_by_va(pmap_id, va);
  104a6b:	58                   	pop    %eax
  104a6c:	5a                   	pop    %edx
  104a6d:	56                   	push   %esi
  104a6e:	ff 74 24 3c          	pushl  0x3c(%esp)
  104a72:	e8 49 1c 00 00       	call   1066c0 <get_ptbl_entry_by_va>
  104a77:	83 c4 10             	add    $0x10,%esp
  104a7a:	eb 94                	jmp    104a10 <pt_memset+0x30>
  104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    size_t set = 0;
  104a80:	31 ff                	xor    %edi,%edi
    }

    return set;
}
  104a82:	83 c4 1c             	add    $0x1c,%esp
  104a85:	89 f8                	mov    %edi,%eax
  104a87:	5b                   	pop    %ebx
  104a88:	5e                   	pop    %esi
  104a89:	5f                   	pop    %edi
  104a8a:	5d                   	pop    %ebp
  104a8b:	c3                   	ret    
  104a8c:	66 90                	xchg   %ax,%ax
  104a8e:	66 90                	xchg   %ax,%ax

00104a90 <elf_load>:

/*
 * Load elf execution file exe to the virtual address space pmap.
 */
void elf_load(void *exe_ptr, int pid)
{
  104a90:	55                   	push   %ebp
  104a91:	57                   	push   %edi
  104a92:	56                   	push   %esi
  104a93:	53                   	push   %ebx
  104a94:	83 ec 1c             	sub    $0x1c,%esp
    char *strtab __attribute__((unused));
    uintptr_t exe = (uintptr_t) exe_ptr;

    eh = (elfhdr *) exe;

    KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  104a97:	8b 44 24 30          	mov    0x30(%esp),%eax
{
  104a9b:	8b 6c 24 34          	mov    0x34(%esp),%ebp
    KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  104a9f:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
  104aa5:	74 19                	je     104ac0 <elf_load+0x30>
  104aa7:	68 91 a5 10 00       	push   $0x10a591
  104aac:	68 df 92 10 00       	push   $0x1092df
  104ab1:	6a 1e                	push   $0x1e
  104ab3:	68 aa a5 10 00       	push   $0x10a5aa
  104ab8:	e8 93 ed ff ff       	call   103850 <debug_panic>
  104abd:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(eh->e_shstrndx != ELF_SHN_UNDEF);
  104ac0:	8b 44 24 30          	mov    0x30(%esp),%eax
  104ac4:	0f b7 40 32          	movzwl 0x32(%eax),%eax
  104ac8:	66 85 c0             	test   %ax,%ax
  104acb:	0f 84 8f 01 00 00    	je     104c60 <elf_load+0x1d0>

    sh = (sechdr *) ((uintptr_t) eh + eh->e_shoff);
    esh = sh + eh->e_shnum;

    strtab = (char *) (exe + sh[eh->e_shstrndx].sh_offset);
    KERN_ASSERT(sh[eh->e_shstrndx].sh_type == ELF_SHT_STRTAB);
  104ad1:	8b 54 24 30          	mov    0x30(%esp),%edx
  104ad5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  104ad8:	8d 04 c2             	lea    (%edx,%eax,8),%eax
  104adb:	03 42 20             	add    0x20(%edx),%eax
  104ade:	83 78 04 03          	cmpl   $0x3,0x4(%eax)
  104ae2:	74 19                	je     104afd <elf_load+0x6d>
  104ae4:	68 dc a5 10 00       	push   $0x10a5dc
  104ae9:	68 df 92 10 00       	push   $0x1092df
  104aee:	6a 25                	push   $0x25
  104af0:	68 aa a5 10 00       	push   $0x10a5aa
  104af5:	e8 56 ed ff ff       	call   103850 <debug_panic>
  104afa:	83 c4 10             	add    $0x10,%esp

    ph = (proghdr *) ((uintptr_t) eh + eh->e_phoff);
  104afd:	8b 44 24 30          	mov    0x30(%esp),%eax
  104b01:	8b 58 1c             	mov    0x1c(%eax),%ebx
  104b04:	01 c3                	add    %eax,%ebx
    eph = ph + eh->e_phnum;
  104b06:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  104b0a:	c1 e0 05             	shl    $0x5,%eax
  104b0d:	01 d8                	add    %ebx,%eax
  104b0f:	89 44 24 04          	mov    %eax,0x4(%esp)

    for (; ph < eph; ph++) {
  104b13:	39 c3                	cmp    %eax,%ebx
  104b15:	72 16                	jb     104b2d <elf_load+0x9d>
  104b17:	e9 08 01 00 00       	jmp    104c24 <elf_load+0x194>
  104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104b20:	83 c3 20             	add    $0x20,%ebx
  104b23:	39 5c 24 04          	cmp    %ebx,0x4(%esp)
  104b27:	0f 86 f7 00 00 00    	jbe    104c24 <elf_load+0x194>
        uintptr_t fa;
        uint32_t va, zva, eva, perm;

        if (ph->p_type != ELF_PROG_LOAD)
  104b2d:	83 3b 01             	cmpl   $0x1,(%ebx)
  104b30:	75 ee                	jne    104b20 <elf_load+0x90>
            continue;

        fa = (uintptr_t) eh + rounddown(ph->p_offset, PAGESIZE);
  104b32:	83 ec 08             	sub    $0x8,%esp
  104b35:	68 00 10 00 00       	push   $0x1000
  104b3a:	ff 73 04             	pushl  0x4(%ebx)
  104b3d:	e8 be f7 ff ff       	call   104300 <rounddown>
  104b42:	03 44 24 40          	add    0x40(%esp),%eax
  104b46:	89 44 24 18          	mov    %eax,0x18(%esp)
        va = rounddown(ph->p_va, PAGESIZE);
  104b4a:	5e                   	pop    %esi
  104b4b:	5f                   	pop    %edi
  104b4c:	68 00 10 00 00       	push   $0x1000
  104b51:	ff 73 08             	pushl  0x8(%ebx)
  104b54:	e8 a7 f7 ff ff       	call   104300 <rounddown>
        zva = ph->p_va + ph->p_filesz;
  104b59:	8b 73 10             	mov    0x10(%ebx),%esi
        eva = roundup(ph->p_va + ph->p_memsz, PAGESIZE);
  104b5c:	5a                   	pop    %edx
        va = rounddown(ph->p_va, PAGESIZE);
  104b5d:	89 c7                	mov    %eax,%edi
        zva = ph->p_va + ph->p_filesz;
  104b5f:	8b 43 08             	mov    0x8(%ebx),%eax
        eva = roundup(ph->p_va + ph->p_memsz, PAGESIZE);
  104b62:	59                   	pop    %ecx
  104b63:	68 00 10 00 00       	push   $0x1000
        zva = ph->p_va + ph->p_filesz;
  104b68:	01 c6                	add    %eax,%esi
        eva = roundup(ph->p_va + ph->p_memsz, PAGESIZE);
  104b6a:	03 43 14             	add    0x14(%ebx),%eax
  104b6d:	50                   	push   %eax
  104b6e:	e8 ad f7 ff ff       	call   104320 <roundup>

        perm = PTE_U | PTE_P;
        if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  104b73:	8b 4b 18             	mov    0x18(%ebx),%ecx
        eva = roundup(ph->p_va + ph->p_memsz, PAGESIZE);
  104b76:	89 44 24 10          	mov    %eax,0x10(%esp)
        if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  104b7a:	83 c4 10             	add    $0x10,%esp
                /* copy a complete page */
                pt_copyout((void *) fa, pid, va, PAGESIZE);
            } else if (va < zva && ph->p_filesz) {
                /* copy a partial page */
                pt_memset(pid, va, 0, PAGESIZE);
                pt_copyout((void *) fa, pid, va, zva - va);
  104b7d:	8b 54 24 08          	mov    0x8(%esp),%edx
        if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  104b81:	83 e1 02             	and    $0x2,%ecx
            perm |= PTE_W;
  104b84:	83 f9 01             	cmp    $0x1,%ecx
  104b87:	19 c9                	sbb    %ecx,%ecx
                pt_copyout((void *) fa, pid, va, zva - va);
  104b89:	29 fa                	sub    %edi,%edx
            perm |= PTE_W;
  104b8b:	83 e1 fe             	and    $0xfffffffe,%ecx
                pt_copyout((void *) fa, pid, va, zva - va);
  104b8e:	89 54 24 0c          	mov    %edx,0xc(%esp)
            perm |= PTE_W;
  104b92:	83 c1 07             	add    $0x7,%ecx
        for (; va < eva; va += PAGESIZE, fa += PAGESIZE) {
  104b95:	3b 3c 24             	cmp    (%esp),%edi
  104b98:	73 86                	jae    104b20 <elf_load+0x90>
  104b9a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104b9e:	89 fb                	mov    %edi,%ebx
  104ba0:	89 cf                	mov    %ecx,%edi
  104ba2:	eb 2f                	jmp    104bd3 <elf_load+0x143>
  104ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            } else if (va < zva && ph->p_filesz) {
  104ba8:	39 de                	cmp    %ebx,%esi
  104baa:	76 0b                	jbe    104bb7 <elf_load+0x127>
  104bac:	8b 44 24 08          	mov    0x8(%esp),%eax
  104bb0:	8b 40 10             	mov    0x10(%eax),%eax
  104bb3:	85 c0                	test   %eax,%eax
  104bb5:	75 79                	jne    104c30 <elf_load+0x1a0>
            } else {
                /* zero a page */
                pt_memset(pid, va, 0, PAGESIZE);
  104bb7:	68 00 10 00 00       	push   $0x1000
  104bbc:	6a 00                	push   $0x0
  104bbe:	53                   	push   %ebx
  104bbf:	55                   	push   %ebp
  104bc0:	e8 1b fe ff ff       	call   1049e0 <pt_memset>
  104bc5:	83 c4 10             	add    $0x10,%esp
        for (; va < eva; va += PAGESIZE, fa += PAGESIZE) {
  104bc8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  104bce:	39 1c 24             	cmp    %ebx,(%esp)
  104bd1:	76 40                	jbe    104c13 <elf_load+0x183>
            alloc_page(pid, va, perm);
  104bd3:	83 ec 04             	sub    $0x4,%esp
  104bd6:	57                   	push   %edi
  104bd7:	53                   	push   %ebx
  104bd8:	55                   	push   %ebp
  104bd9:	e8 82 1e 00 00       	call   106a60 <alloc_page>
            if (va < rounddown(zva, PAGESIZE)) {
  104bde:	5a                   	pop    %edx
  104bdf:	59                   	pop    %ecx
  104be0:	68 00 10 00 00       	push   $0x1000
  104be5:	56                   	push   %esi
  104be6:	e8 15 f7 ff ff       	call   104300 <rounddown>
  104beb:	83 c4 10             	add    $0x10,%esp
  104bee:	39 d8                	cmp    %ebx,%eax
  104bf0:	76 b6                	jbe    104ba8 <elf_load+0x118>
                pt_copyout((void *) fa, pid, va, PAGESIZE);
  104bf2:	68 00 10 00 00       	push   $0x1000
  104bf7:	53                   	push   %ebx
  104bf8:	55                   	push   %ebp
  104bf9:	8b 44 24 18          	mov    0x18(%esp),%eax
  104bfd:	01 d8                	add    %ebx,%eax
        for (; va < eva; va += PAGESIZE, fa += PAGESIZE) {
  104bff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                pt_copyout((void *) fa, pid, va, PAGESIZE);
  104c05:	50                   	push   %eax
  104c06:	e8 05 fd ff ff       	call   104910 <pt_copyout>
  104c0b:	83 c4 10             	add    $0x10,%esp
        for (; va < eva; va += PAGESIZE, fa += PAGESIZE) {
  104c0e:	39 1c 24             	cmp    %ebx,(%esp)
  104c11:	77 c0                	ja     104bd3 <elf_load+0x143>
  104c13:	8b 5c 24 08          	mov    0x8(%esp),%ebx
    for (; ph < eph; ph++) {
  104c17:	83 c3 20             	add    $0x20,%ebx
  104c1a:	39 5c 24 04          	cmp    %ebx,0x4(%esp)
  104c1e:	0f 87 09 ff ff ff    	ja     104b2d <elf_load+0x9d>
            }
        }
    }
}
  104c24:	83 c4 1c             	add    $0x1c,%esp
  104c27:	5b                   	pop    %ebx
  104c28:	5e                   	pop    %esi
  104c29:	5f                   	pop    %edi
  104c2a:	5d                   	pop    %ebp
  104c2b:	c3                   	ret    
  104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                pt_memset(pid, va, 0, PAGESIZE);
  104c30:	68 00 10 00 00       	push   $0x1000
  104c35:	6a 00                	push   $0x0
  104c37:	53                   	push   %ebx
  104c38:	55                   	push   %ebp
  104c39:	e8 a2 fd ff ff       	call   1049e0 <pt_memset>
                pt_copyout((void *) fa, pid, va, zva - va);
  104c3e:	89 f0                	mov    %esi,%eax
  104c40:	29 d8                	sub    %ebx,%eax
  104c42:	50                   	push   %eax
  104c43:	53                   	push   %ebx
  104c44:	55                   	push   %ebp
  104c45:	8b 44 24 28          	mov    0x28(%esp),%eax
  104c49:	01 d8                	add    %ebx,%eax
  104c4b:	50                   	push   %eax
  104c4c:	e8 bf fc ff ff       	call   104910 <pt_copyout>
  104c51:	83 c4 20             	add    $0x20,%esp
  104c54:	e9 6f ff ff ff       	jmp    104bc8 <elf_load+0x138>
  104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    KERN_ASSERT(eh->e_shstrndx != ELF_SHN_UNDEF);
  104c60:	68 bc a5 10 00       	push   $0x10a5bc
  104c65:	68 df 92 10 00       	push   $0x1092df
  104c6a:	6a 1f                	push   $0x1f
  104c6c:	68 aa a5 10 00       	push   $0x10a5aa
  104c71:	e8 da eb ff ff       	call   103850 <debug_panic>
  104c76:	8b 44 24 40          	mov    0x40(%esp),%eax
  104c7a:	83 c4 10             	add    $0x10,%esp
  104c7d:	0f b7 40 32          	movzwl 0x32(%eax),%eax
  104c81:	e9 4b fe ff ff       	jmp    104ad1 <elf_load+0x41>
  104c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104c8d:	8d 76 00             	lea    0x0(%esi),%esi

00104c90 <elf_entry>:

uintptr_t elf_entry(void *exe_ptr)
{
  104c90:	53                   	push   %ebx
  104c91:	83 ec 08             	sub    $0x8,%esp
  104c94:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    uintptr_t exe = (uintptr_t) exe_ptr;
    elfhdr *eh = (elfhdr *) exe;
    KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  104c98:	81 3b 7f 45 4c 46    	cmpl   $0x464c457f,(%ebx)
  104c9e:	74 19                	je     104cb9 <elf_entry+0x29>
  104ca0:	68 91 a5 10 00       	push   $0x10a591
  104ca5:	68 df 92 10 00       	push   $0x1092df
  104caa:	6a 50                	push   $0x50
  104cac:	68 aa a5 10 00       	push   $0x10a5aa
  104cb1:	e8 9a eb ff ff       	call   103850 <debug_panic>
  104cb6:	83 c4 10             	add    $0x10,%esp
    return (uintptr_t) eh->e_entry;
  104cb9:	8b 43 18             	mov    0x18(%ebx),%eax
}
  104cbc:	83 c4 08             	add    $0x8,%esp
  104cbf:	5b                   	pop    %ebx
  104cc0:	c3                   	ret    
  104cc1:	66 90                	xchg   %ax,%ax
  104cc3:	66 90                	xchg   %ax,%ax
  104cc5:	66 90                	xchg   %ax,%ax
  104cc7:	66 90                	xchg   %ax,%ax
  104cc9:	66 90                	xchg   %ax,%ax
  104ccb:	66 90                	xchg   %ax,%ax
  104ccd:	66 90                	xchg   %ax,%ax
  104ccf:	90                   	nop

00104cd0 <get_kstack_pointer>:
#include <lib/seg.h>

#include "kstack.h"

uintptr_t *get_kstack_pointer(void)
{
  104cd0:	83 ec 0c             	sub    $0xc,%esp
    return (uintptr_t *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  104cd3:	e8 68 f6 ff ff       	call   104340 <read_esp>
}
  104cd8:	83 c4 0c             	add    $0xc,%esp
    return (uintptr_t *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  104cdb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
  104ce0:	c3                   	ret    
  104ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104cef:	90                   	nop

00104cf0 <get_kstack_cpu_idx>:

int get_kstack_cpu_idx(void)
{
  104cf0:	83 ec 0c             	sub    $0xc,%esp
    return (uintptr_t *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  104cf3:	e8 48 f6 ff ff       	call   104340 <read_esp>
  104cf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    struct kstack *ks = (struct kstack *) get_kstack_pointer();
    return ks->cpu_idx;
  104cfd:	8b 80 1c 01 00 00    	mov    0x11c(%eax),%eax
}
  104d03:	83 c4 0c             	add    $0xc,%esp
  104d06:	c3                   	ret    
  104d07:	66 90                	xchg   %ax,%ax
  104d09:	66 90                	xchg   %ax,%ax
  104d0b:	66 90                	xchg   %ax,%ax
  104d0d:	66 90                	xchg   %ax,%ax
  104d0f:	90                   	nop

00104d10 <spinlock_init>:
#include "spinlock.h"

extern volatile uint64_t tsc_per_ms;

void gcc_inline spinlock_init(spinlock_t *lk)
{
  104d10:	8b 44 24 04          	mov    0x4(%esp),%eax
    lk->lock_holder = NUM_CPUS + 1;
  104d14:	c7 00 09 00 00 00    	movl   $0x9,(%eax)
    lk->lock = 0;
  104d1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
  104d21:	c3                   	ret    
  104d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104d30 <spinlock_holding>:

bool gcc_inline spinlock_holding(spinlock_t *lk)
{
  104d30:	56                   	push   %esi
  104d31:	31 c0                	xor    %eax,%eax
  104d33:	53                   	push   %ebx
  104d34:	83 ec 04             	sub    $0x4,%esp
  104d37:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    if (!lk->lock)
  104d3b:	8b 53 04             	mov    0x4(%ebx),%edx
  104d3e:	85 d2                	test   %edx,%edx
  104d40:	75 0e                	jne    104d50 <spinlock_holding+0x20>
        return FALSE;

    struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
    KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
    return lk->lock_holder == kstack->cpu_idx;
}
  104d42:	83 c4 04             	add    $0x4,%esp
  104d45:	5b                   	pop    %ebx
  104d46:	5e                   	pop    %esi
  104d47:	c3                   	ret    
  104d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104d4f:	90                   	nop
    struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  104d50:	e8 eb f5 ff ff       	call   104340 <read_esp>
  104d55:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  104d5a:	81 b8 20 01 00 00 32 	cmpl   $0x98765432,0x120(%eax)
  104d61:	54 76 98 
    struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  104d64:	89 c6                	mov    %eax,%esi
    KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  104d66:	74 19                	je     104d81 <spinlock_holding+0x51>
  104d68:	68 09 a6 10 00       	push   $0x10a609
  104d6d:	68 df 92 10 00       	push   $0x1092df
  104d72:	6a 16                	push   $0x16
  104d74:	68 27 a6 10 00       	push   $0x10a627
  104d79:	e8 d2 ea ff ff       	call   103850 <debug_panic>
  104d7e:	83 c4 10             	add    $0x10,%esp
    return lk->lock_holder == kstack->cpu_idx;
  104d81:	8b 86 1c 01 00 00    	mov    0x11c(%esi),%eax
  104d87:	39 03                	cmp    %eax,(%ebx)
  104d89:	0f 94 c0             	sete   %al
}
  104d8c:	83 c4 04             	add    $0x4,%esp
  104d8f:	5b                   	pop    %ebx
  104d90:	5e                   	pop    %esi
  104d91:	c3                   	ret    
  104d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104da0 <spinlock_acquire>:

    return spinlock_try_acquire_A(lk);
}
#else   /* DEBUG_LOCKHOLDING */
void gcc_inline spinlock_acquire(spinlock_t *lk)
{
  104da0:	56                   	push   %esi
  104da1:	53                   	push   %ebx
  104da2:	83 ec 04             	sub    $0x4,%esp
  104da5:	8b 74 24 10          	mov    0x10(%esp),%esi
    while (xchg(&lk->lock, 1) != 0)
  104da9:	8d 5e 04             	lea    0x4(%esi),%ebx
  104dac:	eb 07                	jmp    104db5 <spinlock_acquire+0x15>
  104dae:	66 90                	xchg   %ax,%ax
        pause();
  104db0:	e8 0b f6 ff ff       	call   1043c0 <pause>
    while (xchg(&lk->lock, 1) != 0)
  104db5:	83 ec 08             	sub    $0x8,%esp
  104db8:	6a 01                	push   $0x1
  104dba:	53                   	push   %ebx
  104dbb:	e8 10 f6 ff ff       	call   1043d0 <xchg>
  104dc0:	83 c4 10             	add    $0x10,%esp
  104dc3:	85 c0                	test   %eax,%eax
  104dc5:	75 e9                	jne    104db0 <spinlock_acquire+0x10>
    struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  104dc7:	e8 74 f5 ff ff       	call   104340 <read_esp>
  104dcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  104dd1:	81 b8 20 01 00 00 32 	cmpl   $0x98765432,0x120(%eax)
  104dd8:	54 76 98 
    struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  104ddb:	89 c3                	mov    %eax,%ebx
    KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  104ddd:	74 19                	je     104df8 <spinlock_acquire+0x58>
  104ddf:	68 09 a6 10 00       	push   $0x10a609
  104de4:	68 df 92 10 00       	push   $0x1092df
  104de9:	6a 2f                	push   $0x2f
  104deb:	68 27 a6 10 00       	push   $0x10a627
  104df0:	e8 5b ea ff ff       	call   103850 <debug_panic>
  104df5:	83 c4 10             	add    $0x10,%esp
    lk->lock_holder = kstack->cpu_idx;
  104df8:	8b 83 1c 01 00 00    	mov    0x11c(%ebx),%eax
  104dfe:	89 06                	mov    %eax,(%esi)
    spinlock_acquire_A(lk);
}
  104e00:	83 c4 04             	add    $0x4,%esp
  104e03:	5b                   	pop    %ebx
  104e04:	5e                   	pop    %esi
  104e05:	c3                   	ret    
  104e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104e0d:	8d 76 00             	lea    0x0(%esi),%esi

00104e10 <spinlock_release>:

void gcc_inline spinlock_release(spinlock_t *lk)
{
  104e10:	83 ec 14             	sub    $0x14,%esp
  104e13:	8b 44 24 18          	mov    0x18(%esp),%eax
    lk->lock_holder = NUM_CPUS + 1;
  104e17:	c7 00 09 00 00 00    	movl   $0x9,(%eax)
    xchg(&lk->lock, 0);
  104e1d:	83 c0 04             	add    $0x4,%eax
  104e20:	6a 00                	push   $0x0
  104e22:	50                   	push   %eax
  104e23:	e8 a8 f5 ff ff       	call   1043d0 <xchg>
    spinlock_release_A(lk);
}
  104e28:	83 c4 1c             	add    $0x1c,%esp
  104e2b:	c3                   	ret    
  104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104e30 <spinlock_try_acquire>:

int gcc_inline spinlock_try_acquire(spinlock_t *lk)
{
  104e30:	57                   	push   %edi
  104e31:	56                   	push   %esi
  104e32:	53                   	push   %ebx
  104e33:	8b 74 24 10          	mov    0x10(%esp),%esi
    uint32_t old_val = xchg(&lk->lock, 1);
  104e37:	8d 46 04             	lea    0x4(%esi),%eax
  104e3a:	83 ec 08             	sub    $0x8,%esp
  104e3d:	6a 01                	push   $0x1
  104e3f:	50                   	push   %eax
  104e40:	e8 8b f5 ff ff       	call   1043d0 <xchg>
    if (old_val == 0) {
  104e45:	83 c4 10             	add    $0x10,%esp
    uint32_t old_val = xchg(&lk->lock, 1);
  104e48:	89 c3                	mov    %eax,%ebx
    if (old_val == 0) {
  104e4a:	85 c0                	test   %eax,%eax
  104e4c:	74 0a                	je     104e58 <spinlock_try_acquire+0x28>
    return spinlock_try_acquire_A(lk);
}
  104e4e:	89 d8                	mov    %ebx,%eax
  104e50:	5b                   	pop    %ebx
  104e51:	5e                   	pop    %esi
  104e52:	5f                   	pop    %edi
  104e53:	c3                   	ret    
  104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  104e58:	e8 e3 f4 ff ff       	call   104340 <read_esp>
  104e5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  104e62:	81 b8 20 01 00 00 32 	cmpl   $0x98765432,0x120(%eax)
  104e69:	54 76 98 
        struct kstack *kstack = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  104e6c:	89 c7                	mov    %eax,%edi
        KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  104e6e:	75 10                	jne    104e80 <spinlock_try_acquire+0x50>
        lk->lock_holder = kstack->cpu_idx;
  104e70:	8b 87 1c 01 00 00    	mov    0x11c(%edi),%eax
  104e76:	89 06                	mov    %eax,(%esi)
}
  104e78:	89 d8                	mov    %ebx,%eax
  104e7a:	5b                   	pop    %ebx
  104e7b:	5e                   	pop    %esi
  104e7c:	5f                   	pop    %edi
  104e7d:	c3                   	ret    
  104e7e:	66 90                	xchg   %ax,%ax
        KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  104e80:	68 09 a6 10 00       	push   $0x10a609
  104e85:	68 df 92 10 00       	push   $0x1092df
  104e8a:	6a 39                	push   $0x39
  104e8c:	68 27 a6 10 00       	push   $0x10a627
  104e91:	e8 ba e9 ff ff       	call   103850 <debug_panic>
        lk->lock_holder = kstack->cpu_idx;
  104e96:	8b 87 1c 01 00 00    	mov    0x11c(%edi),%eax
        KERN_ASSERT(kstack->magic == KSTACK_MAGIC);
  104e9c:	83 c4 10             	add    $0x10,%esp
        lk->lock_holder = kstack->cpu_idx;
  104e9f:	89 06                	mov    %eax,(%esi)
  104ea1:	eb d5                	jmp    104e78 <spinlock_try_acquire+0x48>
  104ea3:	66 90                	xchg   %ax,%ax
  104ea5:	66 90                	xchg   %ax,%ax
  104ea7:	66 90                	xchg   %ax,%ax
  104ea9:	66 90                	xchg   %ax,%ax
  104eab:	66 90                	xchg   %ax,%ax
  104ead:	66 90                	xchg   %ax,%ax
  104eaf:	90                   	nop

00104eb0 <reentrantlock_init>:
#include "reentrant_lock.h"

#define UNLOCKED    0xFFFFFFFF

void reentrantlock_init(reentrantlock *lk)
{
  104eb0:	8b 44 24 04          	mov    0x4(%esp),%eax
    lk->lock = UNLOCKED;
  104eb4:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    lk->count = 0u;
  104eba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
  104ec1:	c3                   	ret    
  104ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104ed0 <reentrantlock_holding>:

bool reentrantlock_holding(reentrantlock *lk)
{
    if (lk->count > 0u)
  104ed0:	8b 44 24 04          	mov    0x4(%esp),%eax
  104ed4:	8b 40 04             	mov    0x4(%eax),%eax
  104ed7:	85 c0                	test   %eax,%eax
  104ed9:	0f 95 c0             	setne  %al
        return TRUE;
    else
        return FALSE;
}
  104edc:	c3                   	ret    
  104edd:	8d 76 00             	lea    0x0(%esi),%esi

00104ee0 <reentrantlock_acquire>:

void reentrantlock_acquire(reentrantlock *lk)
{
  104ee0:	56                   	push   %esi
  104ee1:	53                   	push   %ebx
  104ee2:	83 ec 04             	sub    $0x4,%esp
  104ee5:	8b 74 24 10          	mov    0x10(%esp),%esi
    uint32_t cpuid = get_kstack_cpu_idx();
  104ee9:	e8 02 fe ff ff       	call   104cf0 <get_kstack_cpu_idx>
  104eee:	89 c3                	mov    %eax,%ebx
    uint32_t lv;

    do {
        lv = cmpxchg(&lk->lock, UNLOCKED, cpuid);
  104ef0:	83 ec 04             	sub    $0x4,%esp
  104ef3:	53                   	push   %ebx
  104ef4:	6a ff                	push   $0xffffffff
  104ef6:	56                   	push   %esi
  104ef7:	e8 e4 f4 ff ff       	call   1043e0 <cmpxchg>
    } while (lv != cpuid && lv != UNLOCKED);
  104efc:	83 c4 10             	add    $0x10,%esp
  104eff:	39 c3                	cmp    %eax,%ebx
  104f01:	74 05                	je     104f08 <reentrantlock_acquire+0x28>
  104f03:	83 f8 ff             	cmp    $0xffffffff,%eax
  104f06:	75 e8                	jne    104ef0 <reentrantlock_acquire+0x10>
    lk->count++;
  104f08:	8b 46 04             	mov    0x4(%esi),%eax
  104f0b:	83 c0 01             	add    $0x1,%eax
  104f0e:	89 46 04             	mov    %eax,0x4(%esi)
}
  104f11:	83 c4 04             	add    $0x4,%esp
  104f14:	5b                   	pop    %ebx
  104f15:	5e                   	pop    %esi
  104f16:	c3                   	ret    
  104f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104f1e:	66 90                	xchg   %ax,%ax

00104f20 <reentrantlock_try_acquire>:

int reentrantlock_try_acquire(reentrantlock *lk)
{
  104f20:	56                   	push   %esi
  104f21:	53                   	push   %ebx
  104f22:	83 ec 04             	sub    $0x4,%esp
  104f25:	8b 74 24 10          	mov    0x10(%esp),%esi
    uint32_t cpuid = get_kstack_cpu_idx();
  104f29:	e8 c2 fd ff ff       	call   104cf0 <get_kstack_cpu_idx>
    uint32_t lv;

    lv = cmpxchg(&lk->lock, UNLOCKED, cpuid);
  104f2e:	83 ec 04             	sub    $0x4,%esp
  104f31:	50                   	push   %eax
    uint32_t cpuid = get_kstack_cpu_idx();
  104f32:	89 c3                	mov    %eax,%ebx
    lv = cmpxchg(&lk->lock, UNLOCKED, cpuid);
  104f34:	6a ff                	push   $0xffffffff
  104f36:	56                   	push   %esi
  104f37:	e8 a4 f4 ff ff       	call   1043e0 <cmpxchg>

    if (lv == cpuid || lv == UNLOCKED) {
  104f3c:	83 c4 10             	add    $0x10,%esp
  104f3f:	39 c3                	cmp    %eax,%ebx
  104f41:	74 15                	je     104f58 <reentrantlock_try_acquire+0x38>
        lk->count++;
        return 1;
    } else
        return 0;
  104f43:	31 d2                	xor    %edx,%edx
    if (lv == cpuid || lv == UNLOCKED) {
  104f45:	83 f8 ff             	cmp    $0xffffffff,%eax
  104f48:	74 0e                	je     104f58 <reentrantlock_try_acquire+0x38>
}
  104f4a:	83 c4 04             	add    $0x4,%esp
  104f4d:	89 d0                	mov    %edx,%eax
  104f4f:	5b                   	pop    %ebx
  104f50:	5e                   	pop    %esi
  104f51:	c3                   	ret    
  104f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        lk->count++;
  104f58:	8b 46 04             	mov    0x4(%esi),%eax
        return 1;
  104f5b:	ba 01 00 00 00       	mov    $0x1,%edx
        lk->count++;
  104f60:	83 c0 01             	add    $0x1,%eax
  104f63:	89 46 04             	mov    %eax,0x4(%esi)
}
  104f66:	83 c4 04             	add    $0x4,%esp
  104f69:	89 d0                	mov    %edx,%eax
  104f6b:	5b                   	pop    %ebx
  104f6c:	5e                   	pop    %esi
  104f6d:	c3                   	ret    
  104f6e:	66 90                	xchg   %ax,%ax

00104f70 <reentrantlock_release>:

void reentrantlock_release(reentrantlock *lk)
{
  104f70:	83 ec 0c             	sub    $0xc,%esp
  104f73:	8b 44 24 10          	mov    0x10(%esp),%eax
    lk->count--;
  104f77:	8b 50 04             	mov    0x4(%eax),%edx
  104f7a:	83 ea 01             	sub    $0x1,%edx
  104f7d:	89 50 04             	mov    %edx,0x4(%eax)
    if (lk->count == 0u) {
  104f80:	8b 50 04             	mov    0x4(%eax),%edx
  104f83:	85 d2                	test   %edx,%edx
  104f85:	74 09                	je     104f90 <reentrantlock_release+0x20>
        xchg(&lk->lock, UNLOCKED);
    }
}
  104f87:	83 c4 0c             	add    $0xc,%esp
  104f8a:	c3                   	ret    
  104f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104f8f:	90                   	nop
        xchg(&lk->lock, UNLOCKED);
  104f90:	83 ec 08             	sub    $0x8,%esp
  104f93:	6a ff                	push   $0xffffffff
  104f95:	50                   	push   %eax
  104f96:	e8 35 f4 ff ff       	call   1043d0 <xchg>
  104f9b:	83 c4 10             	add    $0x10,%esp
}
  104f9e:	83 c4 0c             	add    $0xc,%esp
  104fa1:	c3                   	ret    
  104fa2:	66 90                	xchg   %ax,%ax
  104fa4:	66 90                	xchg   %ax,%ax
  104fa6:	66 90                	xchg   %ax,%ax
  104fa8:	66 90                	xchg   %ax,%ax
  104faa:	66 90                	xchg   %ax,%ax
  104fac:	66 90                	xchg   %ax,%ax
  104fae:	66 90                	xchg   %ax,%ax

00104fb0 <CV_init>:
#include <dev/intr.h>
#include <thread/PCurID/export.h>
#include <thread/PThread/export.h>

void CV_init(CV *cv)
{
  104fb0:	8b 54 24 04          	mov    0x4(%esp),%edx
    int i;
    cv->tail = 0;
  104fb4:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    for (i = 0; i < NUM_IDS; i++) {
  104fba:	8d 42 04             	lea    0x4(%edx),%eax
  104fbd:	81 c2 04 01 00 00    	add    $0x104,%edx
  104fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104fc7:	90                   	nop
        cv->queue[i] = 0;
  104fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < NUM_IDS; i++) {
  104fce:	83 c0 04             	add    $0x4,%eax
  104fd1:	39 d0                	cmp    %edx,%eax
  104fd3:	75 f3                	jne    104fc8 <CV_init+0x18>
    }
}
  104fd5:	c3                   	ret    
  104fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104fdd:	8d 76 00             	lea    0x0(%esi),%esi

00104fe0 <CV_wait>:

    return pid;
}

void CV_wait(CV *cv, spinlock_t *lk)
{
  104fe0:	57                   	push   %edi
  104fe1:	56                   	push   %esi
  104fe2:	53                   	push   %ebx
  104fe3:	8b 7c 24 14          	mov    0x14(%esp),%edi
  104fe7:	8b 74 24 10          	mov    0x10(%esp),%esi
    unsigned int old_cur_pid;
    NO_INTR(
  104feb:	e8 30 c6 ff ff       	call   101620 <intr_local_disable>
  104ff0:	83 ec 0c             	sub    $0xc,%esp
  104ff3:	57                   	push   %edi
  104ff4:	e8 37 fd ff ff       	call   104d30 <spinlock_holding>
  104ff9:	83 c4 10             	add    $0x10,%esp
  104ffc:	84 c0                	test   %al,%al
  104ffe:	74 70                	je     105070 <CV_wait+0x90>
  105000:	e8 0b c6 ff ff       	call   101610 <intr_local_enable>
        KERN_ASSERT(spinlock_holding(lk))
    );

    old_cur_pid = get_curid();
  105005:	e8 96 1f 00 00       	call   106fa0 <get_curid>
  10500a:	89 c3                	mov    %eax,%ebx
    NO_INTR(
  10500c:	e8 0f c6 ff ff       	call   101620 <intr_local_disable>
  105011:	8d 43 ff             	lea    -0x1(%ebx),%eax
  105014:	83 f8 3e             	cmp    $0x3e,%eax
  105017:	0f 87 d3 00 00 00    	ja     1050f0 <CV_wait+0x110>
  10501d:	8b 06                	mov    (%esi),%eax
  10501f:	83 f8 3f             	cmp    $0x3f,%eax
  105022:	0f 87 a8 00 00 00    	ja     1050d0 <CV_wait+0xf0>
  105028:	8b 54 86 04          	mov    0x4(%esi,%eax,4),%edx
  10502c:	85 d2                	test   %edx,%edx
  10502e:	0f 85 7c 00 00 00    	jne    1050b0 <CV_wait+0xd0>
  105034:	8b 44 9e 04          	mov    0x4(%esi,%ebx,4),%eax
  105038:	85 c0                	test   %eax,%eax
  10503a:	75 54                	jne    105090 <CV_wait+0xb0>
  10503c:	e8 cf c5 ff ff       	call   101610 <intr_local_enable>
    cv->queue[cv->tail] = pid;
  105041:	8b 06                	mov    (%esi),%eax
  105043:	89 5c 86 04          	mov    %ebx,0x4(%esi,%eax,4)
    cv->tail = pid;
  105047:	89 1e                	mov    %ebx,(%esi)
    CV_enqueue(cv, old_cur_pid);

    NO_INTR(
  105049:	e8 d2 c5 ff ff       	call   101620 <intr_local_disable>
  10504e:	83 ec 08             	sub    $0x8,%esp
  105051:	53                   	push   %ebx
  105052:	57                   	push   %edi
  105053:	e8 88 21 00 00       	call   1071e0 <thread_suspend>
  105058:	e8 b3 c5 ff ff       	call   101610 <intr_local_enable>
        thread_suspend(lk, old_cur_pid)
    );

    spinlock_acquire(lk);
  10505d:	83 c4 10             	add    $0x10,%esp
  105060:	89 7c 24 10          	mov    %edi,0x10(%esp)
}
  105064:	5b                   	pop    %ebx
  105065:	5e                   	pop    %esi
  105066:	5f                   	pop    %edi
    spinlock_acquire(lk);
  105067:	e9 34 fd ff ff       	jmp    104da0 <spinlock_acquire>
  10506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    NO_INTR(
  105070:	68 3b a6 10 00       	push   $0x10a63b
  105075:	68 df 92 10 00       	push   $0x1092df
  10507a:	6a 30                	push   $0x30
  10507c:	68 50 a6 10 00       	push   $0x10a650
  105081:	e8 ca e7 ff ff       	call   103850 <debug_panic>
  105086:	83 c4 10             	add    $0x10,%esp
  105089:	e9 72 ff ff ff       	jmp    105000 <CV_wait+0x20>
  10508e:	66 90                	xchg   %ax,%ax
    NO_INTR(
  105090:	68 90 a6 10 00       	push   $0x10a690
  105095:	68 df 92 10 00       	push   $0x1092df
  10509a:	6a 18                	push   $0x18
  10509c:	68 50 a6 10 00       	push   $0x10a650
  1050a1:	e8 aa e7 ff ff       	call   103850 <debug_panic>
  1050a6:	83 c4 10             	add    $0x10,%esp
  1050a9:	eb 91                	jmp    10503c <CV_wait+0x5c>
  1050ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1050af:	90                   	nop
  1050b0:	68 77 a6 10 00       	push   $0x10a677
  1050b5:	68 df 92 10 00       	push   $0x1092df
  1050ba:	6a 17                	push   $0x17
  1050bc:	68 50 a6 10 00       	push   $0x10a650
  1050c1:	e8 8a e7 ff ff       	call   103850 <debug_panic>
  1050c6:	83 c4 10             	add    $0x10,%esp
  1050c9:	e9 66 ff ff ff       	jmp    105034 <CV_wait+0x54>
  1050ce:	66 90                	xchg   %ax,%ax
  1050d0:	68 a4 a6 10 00       	push   $0x10a6a4
  1050d5:	68 df 92 10 00       	push   $0x1092df
  1050da:	6a 16                	push   $0x16
  1050dc:	68 50 a6 10 00       	push   $0x10a650
  1050e1:	e8 6a e7 ff ff       	call   103850 <debug_panic>
  1050e6:	8b 06                	mov    (%esi),%eax
  1050e8:	83 c4 10             	add    $0x10,%esp
  1050eb:	e9 38 ff ff ff       	jmp    105028 <CV_wait+0x48>
  1050f0:	68 5e a6 10 00       	push   $0x10a65e
  1050f5:	68 df 92 10 00       	push   $0x1092df
  1050fa:	6a 15                	push   $0x15
  1050fc:	68 50 a6 10 00       	push   $0x10a650
  105101:	e8 4a e7 ff ff       	call   103850 <debug_panic>
  105106:	83 c4 10             	add    $0x10,%esp
  105109:	e9 0f ff ff ff       	jmp    10501d <CV_wait+0x3d>
  10510e:	66 90                	xchg   %ax,%ax

00105110 <CV_signal>:

void CV_signal(CV *cv)
{
  105110:	53                   	push   %ebx
  105111:	83 ec 08             	sub    $0x8,%esp
  105114:	8b 44 24 10          	mov    0x10(%esp),%eax
    unsigned int pid = cv->queue[0];
  105118:	8b 58 04             	mov    0x4(%eax),%ebx
    if (cv->queue[pid] == 0) {
  10511b:	8d 14 98             	lea    (%eax,%ebx,4),%edx
  10511e:	8b 4a 04             	mov    0x4(%edx),%ecx
  105121:	85 c9                	test   %ecx,%ecx
  105123:	75 06                	jne    10512b <CV_signal+0x1b>
        cv->tail = 0;
  105125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    cv->queue[0] = cv->queue[pid];
  10512b:	89 48 04             	mov    %ecx,0x4(%eax)
    cv->queue[pid] = 0;
  10512e:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
    unsigned int pid = CV_dequeue(cv);
    if (pid != 0) {
  105135:	85 db                	test   %ebx,%ebx
  105137:	75 07                	jne    105140 <CV_signal+0x30>
        NO_INTR(
            thread_ready(pid)
        );
    }
}
  105139:	83 c4 08             	add    $0x8,%esp
  10513c:	5b                   	pop    %ebx
  10513d:	c3                   	ret    
  10513e:	66 90                	xchg   %ax,%ax
        NO_INTR(
  105140:	e8 db c4 ff ff       	call   101620 <intr_local_disable>
  105145:	83 ec 0c             	sub    $0xc,%esp
  105148:	53                   	push   %ebx
  105149:	e8 62 21 00 00       	call   1072b0 <thread_ready>
}
  10514e:	83 c4 18             	add    $0x18,%esp
  105151:	5b                   	pop    %ebx
        NO_INTR(
  105152:	e9 b9 c4 ff ff       	jmp    101610 <intr_local_enable>
  105157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10515e:	66 90                	xchg   %ax,%ax

00105160 <CV_broadcast>:

void CV_broadcast(CV *cv)
{
  105160:	56                   	push   %esi
  105161:	53                   	push   %ebx
  105162:	83 ec 04             	sub    $0x4,%esp
  105165:	8b 74 24 10          	mov    0x10(%esp),%esi
    unsigned int pid;

    while ((pid = CV_dequeue(cv)) != 0) {
  105169:	eb 1b                	jmp    105186 <CV_broadcast+0x26>
  10516b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10516f:	90                   	nop
        NO_INTR(
  105170:	e8 ab c4 ff ff       	call   101620 <intr_local_disable>
  105175:	83 ec 0c             	sub    $0xc,%esp
  105178:	53                   	push   %ebx
  105179:	e8 32 21 00 00       	call   1072b0 <thread_ready>
  10517e:	e8 8d c4 ff ff       	call   101610 <intr_local_enable>
  105183:	83 c4 10             	add    $0x10,%esp
    unsigned int pid = cv->queue[0];
  105186:	8b 5e 04             	mov    0x4(%esi),%ebx
    if (cv->queue[pid] == 0) {
  105189:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
  10518c:	8b 50 04             	mov    0x4(%eax),%edx
  10518f:	85 d2                	test   %edx,%edx
  105191:	75 06                	jne    105199 <CV_broadcast+0x39>
        cv->tail = 0;
  105193:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    cv->queue[0] = cv->queue[pid];
  105199:	89 56 04             	mov    %edx,0x4(%esi)
    cv->queue[pid] = 0;
  10519c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    while ((pid = CV_dequeue(cv)) != 0) {
  1051a3:	85 db                	test   %ebx,%ebx
  1051a5:	75 c9                	jne    105170 <CV_broadcast+0x10>
            thread_ready(pid)
        );
    }
}
  1051a7:	83 c4 04             	add    $0x4,%esp
  1051aa:	5b                   	pop    %ebx
  1051ab:	5e                   	pop    %esi
  1051ac:	c3                   	ret    
  1051ad:	8d 76 00             	lea    0x0(%esi),%esi

001051b0 <BB_init>:

void BB_init(BoundedBuffer *bb)
{
  1051b0:	53                   	push   %ebx
  1051b1:	83 ec 10             	sub    $0x10,%esp
  1051b4:	8b 5c 24 18          	mov    0x18(%esp),%ebx
    memzero(bb->buf, BUFFER_SIZE);
  1051b8:	6a 03                	push   $0x3
  1051ba:	53                   	push   %ebx
  1051bb:	e8 40 e5 ff ff       	call   103700 <memzero>
    bb->head = bb->size = 0;
  1051c0:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    spinlock_init(&bb->lk);
  1051c7:	8d 43 14             	lea    0x14(%ebx),%eax
    bb->head = bb->size = 0;
  1051ca:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    spinlock_init(&bb->lk);
  1051d1:	89 04 24             	mov    %eax,(%esp)
  1051d4:	e8 37 fb ff ff       	call   104d10 <spinlock_init>
    cv->tail = 0;
  1051d9:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
    for (i = 0; i < NUM_IDS; i++) {
  1051e0:	8d 43 20             	lea    0x20(%ebx),%eax
  1051e3:	83 c4 10             	add    $0x10,%esp
  1051e6:	8d 93 20 01 00 00    	lea    0x120(%ebx),%edx
  1051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cv->queue[i] = 0;
  1051f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < NUM_IDS; i++) {
  1051f6:	83 c0 04             	add    $0x4,%eax
  1051f9:	39 d0                	cmp    %edx,%eax
  1051fb:	75 f3                	jne    1051f0 <BB_init+0x40>
    cv->tail = 0;
  1051fd:	c7 83 20 01 00 00 00 	movl   $0x0,0x120(%ebx)
  105204:	00 00 00 
    for (i = 0; i < NUM_IDS; i++) {
  105207:	8d 83 24 01 00 00    	lea    0x124(%ebx),%eax
  10520d:	8d 93 24 02 00 00    	lea    0x224(%ebx),%edx
  105213:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105217:	90                   	nop
        cv->queue[i] = 0;
  105218:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < NUM_IDS; i++) {
  10521e:	83 c0 04             	add    $0x4,%eax
  105221:	39 c2                	cmp    %eax,%edx
  105223:	75 f3                	jne    105218 <BB_init+0x68>
    CV_init(&bb->empty);
    CV_init(&bb->full);
}
  105225:	83 c4 08             	add    $0x8,%esp
  105228:	5b                   	pop    %ebx
  105229:	c3                   	ret    
  10522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105230 <BB_is_empty>:

bool BB_is_empty(BoundedBuffer *bb)
{
    return bb->size == 0;
  105230:	8b 44 24 04          	mov    0x4(%esp),%eax
  105234:	8b 40 10             	mov    0x10(%eax),%eax
  105237:	85 c0                	test   %eax,%eax
  105239:	0f 94 c0             	sete   %al
}
  10523c:	c3                   	ret    
  10523d:	8d 76 00             	lea    0x0(%esi),%esi

00105240 <BB_is_full>:

bool BB_is_full(BoundedBuffer *bb)
{
    return bb->size == BUFFER_SIZE;
  105240:	8b 44 24 04          	mov    0x4(%esp),%eax
  105244:	83 78 10 03          	cmpl   $0x3,0x10(%eax)
  105248:	0f 94 c0             	sete   %al
}
  10524b:	c3                   	ret    
  10524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105250 <BB_enqueue>:

void BB_enqueue(BoundedBuffer *bb, unsigned int val)
{
  105250:	55                   	push   %ebp
  105251:	57                   	push   %edi
  105252:	56                   	push   %esi
  105253:	53                   	push   %ebx
  105254:	83 ec 18             	sub    $0x18,%esp
  105257:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
  10525b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
    unsigned int idx;
    spinlock_acquire(&bb->lk);
  10525f:	8d 73 14             	lea    0x14(%ebx),%esi
  105262:	56                   	push   %esi
  105263:	e8 38 fb ff ff       	call   104da0 <spinlock_acquire>
    return bb->size == BUFFER_SIZE;
  105268:	8b 4b 10             	mov    0x10(%ebx),%ecx

    while (BB_is_full(bb)) {
  10526b:	83 c4 10             	add    $0x10,%esp
  10526e:	83 f9 03             	cmp    $0x3,%ecx
  105271:	75 22                	jne    105295 <BB_enqueue+0x45>
  105273:	8d bb 20 01 00 00    	lea    0x120(%ebx),%edi
  105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        CV_wait(&bb->full, &bb->lk);
  105280:	83 ec 08             	sub    $0x8,%esp
  105283:	56                   	push   %esi
  105284:	57                   	push   %edi
  105285:	e8 56 fd ff ff       	call   104fe0 <CV_wait>
    return bb->size == BUFFER_SIZE;
  10528a:	8b 4b 10             	mov    0x10(%ebx),%ecx
    while (BB_is_full(bb)) {
  10528d:	83 c4 10             	add    $0x10,%esp
  105290:	83 f9 03             	cmp    $0x3,%ecx
  105293:	74 eb                	je     105280 <BB_enqueue+0x30>
    }

    idx = (bb->head + bb->size) % BUFFER_SIZE;
  105295:	8b 7b 0c             	mov    0xc(%ebx),%edi
  105298:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    bb->buf[idx] = val;
    bb->size++;

    CV_signal(&bb->empty);
  10529d:	83 ec 0c             	sub    $0xc,%esp
    idx = (bb->head + bb->size) % BUFFER_SIZE;
  1052a0:	01 cf                	add    %ecx,%edi
    bb->size++;
  1052a2:	83 c1 01             	add    $0x1,%ecx
    idx = (bb->head + bb->size) % BUFFER_SIZE;
  1052a5:	89 f8                	mov    %edi,%eax
  1052a7:	f7 e2                	mul    %edx
  1052a9:	89 d0                	mov    %edx,%eax
  1052ab:	83 e2 fe             	and    $0xfffffffe,%edx
  1052ae:	d1 e8                	shr    %eax
  1052b0:	01 c2                	add    %eax,%edx
  1052b2:	29 d7                	sub    %edx,%edi
    bb->buf[idx] = val;
  1052b4:	89 2c bb             	mov    %ebp,(%ebx,%edi,4)
    CV_signal(&bb->empty);
  1052b7:	83 c3 1c             	add    $0x1c,%ebx
    bb->size++;
  1052ba:	89 4b f4             	mov    %ecx,-0xc(%ebx)
    CV_signal(&bb->empty);
  1052bd:	53                   	push   %ebx
  1052be:	e8 4d fe ff ff       	call   105110 <CV_signal>
    spinlock_release(&bb->lk);
  1052c3:	89 74 24 30          	mov    %esi,0x30(%esp)
}
  1052c7:	83 c4 1c             	add    $0x1c,%esp
  1052ca:	5b                   	pop    %ebx
  1052cb:	5e                   	pop    %esi
  1052cc:	5f                   	pop    %edi
  1052cd:	5d                   	pop    %ebp
    spinlock_release(&bb->lk);
  1052ce:	e9 3d fb ff ff       	jmp    104e10 <spinlock_release>
  1052d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001052e0 <BB_dequeue>:

unsigned int BB_dequeue(BoundedBuffer *bb)
{
  1052e0:	55                   	push   %ebp
  1052e1:	57                   	push   %edi
  1052e2:	56                   	push   %esi
  1052e3:	53                   	push   %ebx
  1052e4:	83 ec 18             	sub    $0x18,%esp
  1052e7:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
    unsigned int val;
    spinlock_acquire(&bb->lk);
  1052eb:	8d 73 14             	lea    0x14(%ebx),%esi
  1052ee:	56                   	push   %esi
  1052ef:	e8 ac fa ff ff       	call   104da0 <spinlock_acquire>
    return bb->size == 0;
  1052f4:	8b 4b 10             	mov    0x10(%ebx),%ecx

    while (BB_is_empty(bb)) {
  1052f7:	83 c4 10             	add    $0x10,%esp
  1052fa:	85 c9                	test   %ecx,%ecx
  1052fc:	75 1e                	jne    10531c <BB_dequeue+0x3c>
  1052fe:	8d 7b 1c             	lea    0x1c(%ebx),%edi
  105301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        CV_wait(&bb->empty, &bb->lk);
  105308:	83 ec 08             	sub    $0x8,%esp
  10530b:	56                   	push   %esi
  10530c:	57                   	push   %edi
  10530d:	e8 ce fc ff ff       	call   104fe0 <CV_wait>
    return bb->size == 0;
  105312:	8b 4b 10             	mov    0x10(%ebx),%ecx
    while (BB_is_empty(bb)) {
  105315:	83 c4 10             	add    $0x10,%esp
  105318:	85 c9                	test   %ecx,%ecx
  10531a:	74 ec                	je     105308 <BB_dequeue+0x28>
    }

    val = bb->buf[bb->head];
  10531c:	8b 6b 0c             	mov    0xc(%ebx),%ebp
    bb->head = (bb->head + 1) % BUFFER_SIZE;
  10531f:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    bb->size--;
  105324:	83 e9 01             	sub    $0x1,%ecx

    CV_signal(&bb->full);
  105327:	83 ec 0c             	sub    $0xc,%esp
    val = bb->buf[bb->head];
  10532a:	8b 3c ab             	mov    (%ebx,%ebp,4),%edi
    bb->head = (bb->head + 1) % BUFFER_SIZE;
  10532d:	83 c5 01             	add    $0x1,%ebp
    bb->size--;
  105330:	89 4b 10             	mov    %ecx,0x10(%ebx)
    CV_signal(&bb->full);
  105333:	81 c3 20 01 00 00    	add    $0x120,%ebx
    bb->head = (bb->head + 1) % BUFFER_SIZE;
  105339:	89 e8                	mov    %ebp,%eax
  10533b:	f7 e2                	mul    %edx
  10533d:	89 d0                	mov    %edx,%eax
  10533f:	83 e2 fe             	and    $0xfffffffe,%edx
  105342:	d1 e8                	shr    %eax
  105344:	01 c2                	add    %eax,%edx
  105346:	29 d5                	sub    %edx,%ebp
  105348:	89 ab ec fe ff ff    	mov    %ebp,-0x114(%ebx)
    CV_signal(&bb->full);
  10534e:	53                   	push   %ebx
  10534f:	e8 bc fd ff ff       	call   105110 <CV_signal>
    spinlock_release(&bb->lk);
  105354:	89 34 24             	mov    %esi,(%esp)
  105357:	e8 b4 fa ff ff       	call   104e10 <spinlock_release>
    return val;
}
  10535c:	83 c4 1c             	add    $0x1c,%esp
  10535f:	89 f8                	mov    %edi,%eax
  105361:	5b                   	pop    %ebx
  105362:	5e                   	pop    %esi
  105363:	5f                   	pop    %edi
  105364:	5d                   	pop    %ebp
  105365:	c3                   	ret    
  105366:	66 90                	xchg   %ax,%ax
  105368:	66 90                	xchg   %ax,%ax
  10536a:	66 90                	xchg   %ax,%ax
  10536c:	66 90                	xchg   %ax,%ax
  10536e:	66 90                	xchg   %ax,%ax

00105370 <mqueue_init>:
#include <lib/thread.h>
#include <dev/intr.h>
#include <thread/PCurID/export.h>
#include <thread/PThread/export.h>

void mqueue_init(mqueue_t *mq) {
  105370:	8b 44 24 04          	mov    0x4(%esp),%eax
    mq->head = 0;
  105374:	c7 80 90 01 00 00 00 	movl   $0x0,0x190(%eax)
  10537b:	00 00 00 
    mq->tail = 0;
  10537e:	c7 80 94 01 00 00 00 	movl   $0x0,0x194(%eax)
  105385:	00 00 00 
    mq->size = 0;
  105388:	c7 80 98 01 00 00 00 	movl   $0x0,0x198(%eax)
  10538f:	00 00 00 
}
  105392:	c3                   	ret    
  105393:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10539a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001053a0 <mqueue_get>:

void *mqueue_get(mqueue_t *mq, uint32_t index) {
  1053a0:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    return mq->data[(mq->head + index) % mq->size];
  1053a4:	31 d2                	xor    %edx,%edx
  1053a6:	8b 81 90 01 00 00    	mov    0x190(%ecx),%eax
  1053ac:	03 44 24 08          	add    0x8(%esp),%eax
  1053b0:	f7 b1 98 01 00 00    	divl   0x198(%ecx)
  1053b6:	8b 04 91             	mov    (%ecx,%edx,4),%eax
}
  1053b9:	c3                   	ret    
  1053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001053c0 <mqueue_pop>:

void *mqueue_pop(mqueue_t *mq) {
  1053c0:	57                   	push   %edi
  1053c1:	56                   	push   %esi
  1053c2:	53                   	push   %ebx
  1053c3:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    KERN_ASSERT(mq->size != 0);
  1053c7:	8b b3 98 01 00 00    	mov    0x198(%ebx),%esi
  1053cd:	85 f6                	test   %esi,%esi
  1053cf:	74 3f                	je     105410 <mqueue_pop+0x50>

    void *front = mq->data[mq->head];
  1053d1:	8b 8b 90 01 00 00    	mov    0x190(%ebx),%ecx
  1053d7:	8b 3c 8b             	mov    (%ebx,%ecx,4),%edi

    if (mq->head != mq->tail)
  1053da:	3b 8b 94 01 00 00    	cmp    0x194(%ebx),%ecx
  1053e0:	74 1a                	je     1053fc <mqueue_pop+0x3c>
	mq->head = (mq->head + 1) % MQUEUE_CAPACITY;
  1053e2:	83 c1 01             	add    $0x1,%ecx
  1053e5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  1053ea:	89 c8                	mov    %ecx,%eax
  1053ec:	f7 e2                	mul    %edx
  1053ee:	c1 ea 05             	shr    $0x5,%edx
  1053f1:	6b d2 64             	imul   $0x64,%edx,%edx
  1053f4:	29 d1                	sub    %edx,%ecx
  1053f6:	89 8b 90 01 00 00    	mov    %ecx,0x190(%ebx)
    --mq->size;
  1053fc:	83 ee 01             	sub    $0x1,%esi

    return front;
}
  1053ff:	89 f8                	mov    %edi,%eax
    --mq->size;
  105401:	89 b3 98 01 00 00    	mov    %esi,0x198(%ebx)
}
  105407:	5b                   	pop    %ebx
  105408:	5e                   	pop    %esi
  105409:	5f                   	pop    %edi
  10540a:	c3                   	ret    
  10540b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10540f:	90                   	nop
    KERN_ASSERT(mq->size != 0);
  105410:	68 c8 a6 10 00       	push   $0x10a6c8
  105415:	68 df 92 10 00       	push   $0x1092df
  10541a:	6a 15                	push   $0x15
  10541c:	68 d6 a6 10 00       	push   $0x10a6d6
  105421:	e8 2a e4 ff ff       	call   103850 <debug_panic>
  105426:	8b b3 98 01 00 00    	mov    0x198(%ebx),%esi
  10542c:	83 c4 10             	add    $0x10,%esp
  10542f:	eb a0                	jmp    1053d1 <mqueue_pop+0x11>
  105431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10543f:	90                   	nop

00105440 <mqueue_push>:

void mqueue_push(mqueue_t *mq, void *val) {
  105440:	56                   	push   %esi
  105441:	53                   	push   %ebx
  105442:	83 ec 04             	sub    $0x4,%esp
  105445:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    KERN_ASSERT(mq->size != MQUEUE_CAPACITY);
  105449:	8b 8b 98 01 00 00    	mov    0x198(%ebx),%ecx
  10544f:	83 f9 64             	cmp    $0x64,%ecx
  105452:	74 44                	je     105498 <mqueue_push+0x58>

    if (mq->head != mq->tail)
  105454:	8b 93 94 01 00 00    	mov    0x194(%ebx),%edx
  10545a:	39 93 90 01 00 00    	cmp    %edx,0x190(%ebx)
  105460:	74 1c                	je     10547e <mqueue_push+0x3e>
	mq->tail = (mq->tail + 1) % MQUEUE_CAPACITY;
  105462:	8d 72 01             	lea    0x1(%edx),%esi
  105465:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  10546a:	89 f0                	mov    %esi,%eax
  10546c:	f7 e2                	mul    %edx
  10546e:	c1 ea 05             	shr    $0x5,%edx
  105471:	6b d2 64             	imul   $0x64,%edx,%edx
  105474:	29 d6                	sub    %edx,%esi
  105476:	89 b3 94 01 00 00    	mov    %esi,0x194(%ebx)
  10547c:	89 f2                	mov    %esi,%edx
    mq->data[mq->tail] = val;
  10547e:	8b 44 24 14          	mov    0x14(%esp),%eax

    ++mq->size;
  105482:	83 c1 01             	add    $0x1,%ecx
    mq->data[mq->tail] = val;
  105485:	89 04 93             	mov    %eax,(%ebx,%edx,4)
    ++mq->size;
  105488:	89 8b 98 01 00 00    	mov    %ecx,0x198(%ebx)
}
  10548e:	83 c4 04             	add    $0x4,%esp
  105491:	5b                   	pop    %ebx
  105492:	5e                   	pop    %esi
  105493:	c3                   	ret    
  105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    KERN_ASSERT(mq->size != MQUEUE_CAPACITY);
  105498:	68 e8 a6 10 00       	push   $0x10a6e8
  10549d:	68 df 92 10 00       	push   $0x1092df
  1054a2:	6a 21                	push   $0x21
  1054a4:	68 d6 a6 10 00       	push   $0x10a6d6
  1054a9:	e8 a2 e3 ff ff       	call   103850 <debug_panic>
  1054ae:	8b 8b 98 01 00 00    	mov    0x198(%ebx),%ecx
  1054b4:	83 c4 10             	add    $0x10,%esp
  1054b7:	eb 9b                	jmp    105454 <mqueue_push+0x14>
  1054b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001054c0 <mqueue_size>:

uint32_t mqueue_size(mqueue_t *mq) {
    return mq->size;
  1054c0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1054c4:	8b 80 98 01 00 00    	mov    0x198(%eax),%eax
}
  1054ca:	c3                   	ret    
  1054cb:	66 90                	xchg   %ax,%ax
  1054cd:	66 90                	xchg   %ax,%ax
  1054cf:	90                   	nop

001054d0 <futex_queue_init>:
    struct futex_q *waiters_tail;

    uint32_t waiters;
};

void futex_queue_init(struct futex_queue *queue) {
  1054d0:	53                   	push   %ebx
  1054d1:	83 ec 14             	sub    $0x14,%esp
  1054d4:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    spinlock_init(&queue->lock);
  1054d8:	53                   	push   %ebx
  1054d9:	e8 32 f8 ff ff       	call   104d10 <spinlock_init>

    queue->waiters_head = NULL;
  1054de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    queue->waiters_tail = NULL;
  1054e5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    queue->waiters = 0;
  1054ec:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
}
  1054f3:	83 c4 18             	add    $0x18,%esp
  1054f6:	5b                   	pop    %ebx
  1054f7:	c3                   	ret    
  1054f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1054ff:	90                   	nop

00105500 <futex_queue_push>:

void futex_queue_push(struct futex_queue *queue, struct futex_q *q) {
  105500:	8b 44 24 04          	mov    0x4(%esp),%eax
  105504:	8b 54 24 08          	mov    0x8(%esp),%edx
    if (queue->waiters_tail == NULL) {
  105508:	8b 48 0c             	mov    0xc(%eax),%ecx
  10550b:	85 c9                	test   %ecx,%ecx
  10550d:	74 19                	je     105528 <futex_queue_push+0x28>
	queue->waiters_tail = q;
	queue->waiters_head = q;
	q->prev = NULL;
    } else {
	queue->waiters_tail->next = q;
  10550f:	89 51 0c             	mov    %edx,0xc(%ecx)
	q->prev = queue->waiters_tail;
  105512:	89 4a 08             	mov    %ecx,0x8(%edx)
	queue->waiters_tail = q;
  105515:	89 50 0c             	mov    %edx,0xc(%eax)
    }

    q->next = NULL;
  105518:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    ++queue->waiters;
  10551f:	83 40 10 01          	addl   $0x1,0x10(%eax)
}
  105523:	c3                   	ret    
  105524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	queue->waiters_tail = q;
  105528:	89 50 0c             	mov    %edx,0xc(%eax)
	queue->waiters_head = q;
  10552b:	89 50 08             	mov    %edx,0x8(%eax)
	q->prev = NULL;
  10552e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    q->next = NULL;
  105535:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    ++queue->waiters;
  10553c:	83 40 10 01          	addl   $0x1,0x10(%eax)
}
  105540:	c3                   	ret    
  105541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10554f:	90                   	nop

00105550 <futex_queue_remove>:

void futex_queue_remove(struct futex_queue *queue, struct futex_q *q) {
  105550:	56                   	push   %esi
  105551:	53                   	push   %ebx
  105552:	83 ec 04             	sub    $0x4,%esp
  105555:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  105559:	8b 74 24 14          	mov    0x14(%esp),%esi
    KERN_ASSERT(queue->waiters > 0);
  10555d:	8b 43 10             	mov    0x10(%ebx),%eax
  105560:	85 c0                	test   %eax,%eax
  105562:	74 4c                	je     1055b0 <futex_queue_remove+0x60>

    if (queue->waiters == 1) {
  105564:	83 f8 01             	cmp    $0x1,%eax
  105567:	74 27                	je     105590 <futex_queue_remove+0x40>
	queue->waiters_head = NULL;
	queue->waiters_tail = NULL;
    } else if (queue->waiters_head == q) {
  105569:	39 73 08             	cmp    %esi,0x8(%ebx)
  10556c:	74 62                	je     1055d0 <futex_queue_remove+0x80>
	queue->waiters_head = q->next;
    } else if (queue->waiters_tail == q) {
  10556e:	8b 56 08             	mov    0x8(%esi),%edx
  105571:	39 73 0c             	cmp    %esi,0xc(%ebx)
  105574:	74 72                	je     1055e8 <futex_queue_remove+0x98>
	q->prev->next = NULL;
    } else {
	q->prev->next = q->next;
  105576:	8b 4e 0c             	mov    0xc(%esi),%ecx
	q->next->prev = q->prev;
    }

    --queue->waiters;
  105579:	83 e8 01             	sub    $0x1,%eax
	q->prev->next = q->next;
  10557c:	89 4a 0c             	mov    %ecx,0xc(%edx)
	q->next->prev = q->prev;
  10557f:	89 51 08             	mov    %edx,0x8(%ecx)
    --queue->waiters;
  105582:	89 43 10             	mov    %eax,0x10(%ebx)
}
  105585:	83 c4 04             	add    $0x4,%esp
  105588:	5b                   	pop    %ebx
  105589:	5e                   	pop    %esi
  10558a:	c3                   	ret    
  10558b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10558f:	90                   	nop
    --queue->waiters;
  105590:	83 e8 01             	sub    $0x1,%eax
	queue->waiters_head = NULL;
  105593:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	queue->waiters_tail = NULL;
  10559a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    --queue->waiters;
  1055a1:	89 43 10             	mov    %eax,0x10(%ebx)
}
  1055a4:	83 c4 04             	add    $0x4,%esp
  1055a7:	5b                   	pop    %ebx
  1055a8:	5e                   	pop    %esi
  1055a9:	c3                   	ret    
  1055aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    KERN_ASSERT(queue->waiters > 0);
  1055b0:	68 04 a7 10 00       	push   $0x10a704
  1055b5:	68 df 92 10 00       	push   $0x1092df
  1055ba:	6a 4e                	push   $0x4e
  1055bc:	68 17 a7 10 00       	push   $0x10a717
  1055c1:	e8 8a e2 ff ff       	call   103850 <debug_panic>
  1055c6:	8b 43 10             	mov    0x10(%ebx),%eax
  1055c9:	83 c4 10             	add    $0x10,%esp
  1055cc:	eb 96                	jmp    105564 <futex_queue_remove+0x14>
  1055ce:	66 90                	xchg   %ax,%ax
	queue->waiters_head = q->next;
  1055d0:	8b 56 0c             	mov    0xc(%esi),%edx
    --queue->waiters;
  1055d3:	83 e8 01             	sub    $0x1,%eax
  1055d6:	89 43 10             	mov    %eax,0x10(%ebx)
	queue->waiters_head = q->next;
  1055d9:	89 53 08             	mov    %edx,0x8(%ebx)
}
  1055dc:	83 c4 04             	add    $0x4,%esp
  1055df:	5b                   	pop    %ebx
  1055e0:	5e                   	pop    %esi
  1055e1:	c3                   	ret    
  1055e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    --queue->waiters;
  1055e8:	83 e8 01             	sub    $0x1,%eax
	q->prev->next = NULL;
  1055eb:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    --queue->waiters;
  1055f2:	89 43 10             	mov    %eax,0x10(%ebx)
}
  1055f5:	83 c4 04             	add    $0x4,%esp
  1055f8:	5b                   	pop    %ebx
  1055f9:	5e                   	pop    %esi
  1055fa:	c3                   	ret    
  1055fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1055ff:	90                   	nop

00105600 <futex>:
    return op & 0xFFFFFFFC;
}

int futex(uint32_t *uaddr, uint32_t op, uint32_t val1,
          const struct timespect *timeout,
          uint32_t *uaddr2, uint32_t val3) {
  105600:	55                   	push   %ebp
  105601:	57                   	push   %edi
  105602:	56                   	push   %esi
  105603:	53                   	push   %ebx
  105604:	83 ec 1c             	sub    $0x1c,%esp
    return op & 0xFFFFFFFC;
  105607:	8b 44 24 34          	mov    0x34(%esp),%eax
          uint32_t *uaddr2, uint32_t val3) {
  10560b:	8b 74 24 30          	mov    0x30(%esp),%esi
    return op & 0xFFFFFFFC;
  10560f:	83 e0 fc             	and    $0xfffffffc,%eax

    switch (get_op(op)) {
  105612:	83 f8 08             	cmp    $0x8,%eax
  105615:	74 29                	je     105640 <futex+0x40>
  105617:	83 f8 40             	cmp    $0x40,%eax
  10561a:	0f 84 18 01 00 00    	je     105738 <futex+0x138>
  105620:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  105625:	83 f8 04             	cmp    $0x4,%eax
  105628:	0f 84 b2 00 00 00    	je     1056e0 <futex+0xe0>
	default:
	    break;
    }

    return -1;  
}
  10562e:	83 c4 1c             	add    $0x1c,%esp
  105631:	89 e8                	mov    %ebp,%eax
  105633:	5b                   	pop    %ebx
  105634:	5e                   	pop    %esi
  105635:	5f                   	pop    %edi
  105636:	5d                   	pop    %ebp
  105637:	c3                   	ret    
  105638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10563f:	90                   	nop
    return (uint32_t)uaddr % TOTAL_FUTEX_QUEUE_NUM;
  105640:	89 f0                	mov    %esi,%eax
  105642:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    spinlock_acquire(&queue->lock);
  105647:	83 ec 0c             	sub    $0xc,%esp
    return (uint32_t)uaddr % TOTAL_FUTEX_QUEUE_NUM;
  10564a:	f7 e2                	mul    %edx
  10564c:	89 f0                	mov    %esi,%eax
  10564e:	c1 ea 06             	shr    $0x6,%edx
  105651:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
  105657:	29 d0                	sub    %edx,%eax
    return &futex_queues[hash_bucket(uaddr)];
  105659:	8d 04 80             	lea    (%eax,%eax,4),%eax
  10565c:	8d 2c 85 80 ce 14 00 	lea    0x14ce80(,%eax,4),%ebp
    spinlock_acquire(&queue->lock);
  105663:	55                   	push   %ebp
  105664:	e8 37 f7 ff ff       	call   104da0 <spinlock_acquire>
    if (queue->waiters == 0) {
  105669:	8b 45 10             	mov    0x10(%ebp),%eax
  10566c:	83 c4 10             	add    $0x10,%esp
  10566f:	85 c0                	test   %eax,%eax
  105671:	74 4d                	je     1056c0 <futex+0xc0>
    for (struct futex_q *q = queue->waiters_head; q != NULL && woken < to_wake; q = q->next) {
  105673:	8b 44 24 38          	mov    0x38(%esp),%eax
  105677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10567a:	85 c0                	test   %eax,%eax
  10567c:	74 42                	je     1056c0 <futex+0xc0>
    uint32_t woken = 0;
  10567e:	31 ff                	xor    %edi,%edi
    for (struct futex_q *q = queue->waiters_head; q != NULL && woken < to_wake; q = q->next) {
  105680:	85 db                	test   %ebx,%ebx
  105682:	75 19                	jne    10569d <futex+0x9d>
  105684:	eb 3a                	jmp    1056c0 <futex+0xc0>
  105686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10568d:	8d 76 00             	lea    0x0(%esi),%esi
  105690:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  105693:	85 db                	test   %ebx,%ebx
  105695:	74 29                	je     1056c0 <futex+0xc0>
  105697:	39 7c 24 38          	cmp    %edi,0x38(%esp)
  10569b:	76 23                	jbe    1056c0 <futex+0xc0>
	if (q->futex == (uint32_t)uaddr) {
  10569d:	3b 33                	cmp    (%ebx),%esi
  10569f:	75 ef                	jne    105690 <futex+0x90>
	    futex_queue_remove(queue, q);
  1056a1:	83 ec 08             	sub    $0x8,%esp
	    ++woken;
  1056a4:	83 c7 01             	add    $0x1,%edi
	    futex_queue_remove(queue, q);
  1056a7:	53                   	push   %ebx
  1056a8:	55                   	push   %ebp
  1056a9:	e8 a2 fe ff ff       	call   105550 <futex_queue_remove>
	    thread_ready(q->pid);
  1056ae:	58                   	pop    %eax
  1056af:	ff 73 04             	pushl  0x4(%ebx)
  1056b2:	e8 f9 1b 00 00       	call   1072b0 <thread_ready>
	    ++woken;
  1056b7:	83 c4 10             	add    $0x10,%esp
  1056ba:	eb d4                	jmp    105690 <futex+0x90>
  1056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    spinlock_release(&queue->lock);
  1056c0:	83 ec 0c             	sub    $0xc,%esp
  1056c3:	55                   	push   %ebp
	    return futex_wake(uaddr, val1);
  1056c4:	31 ed                	xor    %ebp,%ebp
    spinlock_release(&queue->lock);
  1056c6:	e8 45 f7 ff ff       	call   104e10 <spinlock_release>
    return 0;
  1056cb:	83 c4 10             	add    $0x10,%esp
}
  1056ce:	89 e8                	mov    %ebp,%eax
  1056d0:	83 c4 1c             	add    $0x1c,%esp
  1056d3:	5b                   	pop    %ebx
  1056d4:	5e                   	pop    %esi
  1056d5:	5f                   	pop    %edi
  1056d6:	5d                   	pop    %ebp
  1056d7:	c3                   	ret    
  1056d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1056df:	90                   	nop
    return (uint32_t)uaddr % TOTAL_FUTEX_QUEUE_NUM;
  1056e0:	89 f0                	mov    %esi,%eax
  1056e2:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    spinlock_acquire(&queue->lock);
  1056e7:	83 ec 0c             	sub    $0xc,%esp
    return (uint32_t)uaddr % TOTAL_FUTEX_QUEUE_NUM;
  1056ea:	f7 e2                	mul    %edx
  1056ec:	89 f0                	mov    %esi,%eax
  1056ee:	c1 ea 06             	shr    $0x6,%edx
  1056f1:	69 da e8 03 00 00    	imul   $0x3e8,%edx,%ebx
  1056f7:	29 d8                	sub    %ebx,%eax
  1056f9:	89 c3                	mov    %eax,%ebx
    spinlock_acquire(&queue->lock);
  1056fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1056fe:	8d 3c 85 80 ce 14 00 	lea    0x14ce80(,%eax,4),%edi
  105705:	57                   	push   %edi
  105706:	e8 95 f6 ff ff       	call   104da0 <spinlock_acquire>
    if (*uaddr == val1) {
  10570b:	83 c4 10             	add    $0x10,%esp
  10570e:	8b 06                	mov    (%esi),%eax
  105710:	39 44 24 38          	cmp    %eax,0x38(%esp)
  105714:	0f 84 76 01 00 00    	je     105890 <futex+0x290>
	spinlock_release(&queue->lock);
  10571a:	83 ec 0c             	sub    $0xc,%esp
	    return futex_wait(uaddr, val1, NULL);
  10571d:	31 ed                	xor    %ebp,%ebp
	spinlock_release(&queue->lock);
  10571f:	57                   	push   %edi
  105720:	e8 eb f6 ff ff       	call   104e10 <spinlock_release>
  105725:	83 c4 10             	add    $0x10,%esp
}
  105728:	89 e8                	mov    %ebp,%eax
  10572a:	83 c4 1c             	add    $0x1c,%esp
  10572d:	5b                   	pop    %ebx
  10572e:	5e                   	pop    %esi
  10572f:	5f                   	pop    %edi
  105730:	5d                   	pop    %ebp
  105731:	c3                   	ret    
  105732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return (uint32_t)uaddr % TOTAL_FUTEX_QUEUE_NUM;
  105738:	bb d3 4d 62 10       	mov    $0x10624dd3,%ebx
  10573d:	89 f0                	mov    %esi,%eax
  10573f:	8b 4c 24 40          	mov    0x40(%esp),%ecx
  105743:	f7 e3                	mul    %ebx
  105745:	89 f0                	mov    %esi,%eax
  105747:	c1 ea 06             	shr    $0x6,%edx
  10574a:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
  105750:	29 d0                	sub    %edx,%eax
    return &futex_queues[hash_bucket(uaddr)];
  105752:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105755:	8d 3c 85 80 ce 14 00 	lea    0x14ce80(,%eax,4),%edi
    return (uint32_t)uaddr % TOTAL_FUTEX_QUEUE_NUM;
  10575c:	89 d8                	mov    %ebx,%eax
  10575e:	f7 64 24 40          	mull   0x40(%esp)
  105762:	89 d0                	mov    %edx,%eax
  105764:	c1 e8 06             	shr    $0x6,%eax
  105767:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  10576d:	29 c1                	sub    %eax,%ecx
    return &futex_queues[hash_bucket(uaddr)];
  10576f:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
  105772:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105776:	8d 1c 95 80 ce 14 00 	lea    0x14ce80(,%edx,4),%ebx
  10577d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    if (queue == queue2) {
  105781:	39 df                	cmp    %ebx,%edi
  105783:	0f 84 c1 01 00 00    	je     10594a <futex+0x34a>
    spinlock_acquire(&queue->lock);
  105789:	83 ec 0c             	sub    $0xc,%esp
  10578c:	57                   	push   %edi
  10578d:	e8 0e f6 ff ff       	call   104da0 <spinlock_acquire>
    spinlock_acquire(&queue2->lock);
  105792:	89 1c 24             	mov    %ebx,(%esp)
  105795:	e8 06 f6 ff ff       	call   104da0 <spinlock_acquire>
    if (queue->waiters == 0) {
  10579a:	8b 6f 10             	mov    0x10(%edi),%ebp
  10579d:	83 c4 10             	add    $0x10,%esp
  1057a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  1057a4:	85 ed                	test   %ebp,%ebp
  1057a6:	0f 84 54 01 00 00    	je     105900 <futex+0x300>
    if (*uaddr != val3) {
  1057ac:	8b 0e                	mov    (%esi),%ecx
  1057ae:	39 4c 24 44          	cmp    %ecx,0x44(%esp)
  1057b2:	0f 85 9c 01 00 00    	jne    105954 <futex+0x354>
    for (q = queue->waiters_head; q != NULL && woken < to_wake; q = q->next) {
  1057b8:	8b 5f 08             	mov    0x8(%edi),%ebx
    uint32_t woken = 0;
  1057bb:	31 ed                	xor    %ebp,%ebp
    for (q = queue->waiters_head; q != NULL && woken < to_wake; q = q->next) {
  1057bd:	85 db                	test   %ebx,%ebx
  1057bf:	74 52                	je     105813 <futex+0x213>
  1057c1:	8b 54 24 38          	mov    0x38(%esp),%edx
  1057c5:	85 d2                	test   %edx,%edx
  1057c7:	75 18                	jne    1057e1 <futex+0x1e1>
  1057c9:	eb 48                	jmp    105813 <futex+0x213>
  1057cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1057cf:	90                   	nop
  1057d0:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  1057d3:	85 db                	test   %ebx,%ebx
  1057d5:	0f 84 8b 00 00 00    	je     105866 <futex+0x266>
  1057db:	39 6c 24 38          	cmp    %ebp,0x38(%esp)
  1057df:	76 32                	jbe    105813 <futex+0x213>
	if (q->futex == (uint32_t)uaddr) {
  1057e1:	3b 33                	cmp    (%ebx),%esi
  1057e3:	75 eb                	jne    1057d0 <futex+0x1d0>
  1057e5:	89 44 24 08          	mov    %eax,0x8(%esp)
	    futex_queue_remove(queue, q);
  1057e9:	83 ec 08             	sub    $0x8,%esp
	    ++woken;
  1057ec:	83 c5 01             	add    $0x1,%ebp
	    futex_queue_remove(queue, q);
  1057ef:	53                   	push   %ebx
  1057f0:	57                   	push   %edi
  1057f1:	e8 5a fd ff ff       	call   105550 <futex_queue_remove>
	    thread_ready(q->pid);
  1057f6:	58                   	pop    %eax
  1057f7:	ff 73 04             	pushl  0x4(%ebx)
  1057fa:	e8 b1 1a 00 00       	call   1072b0 <thread_ready>
	    ++woken;
  1057ff:	83 c4 10             	add    $0x10,%esp
  105802:	8b 44 24 08          	mov    0x8(%esp),%eax
  105806:	eb c8                	jmp    1057d0 <futex+0x1d0>
  105808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10580f:	90                   	nop
    for ( ; q != NULL && requeued < requeue_limit; q = q->next) {
  105810:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  105813:	85 db                	test   %ebx,%ebx
  105815:	74 4f                	je     105866 <futex+0x266>
	if (q->futex == (uint32_t)uaddr) {
  105817:	3b 33                	cmp    (%ebx),%esi
  105819:	75 f5                	jne    105810 <futex+0x210>
  10581b:	89 44 24 08          	mov    %eax,0x8(%esp)
	    futex_queue_remove(queue, q);
  10581f:	83 ec 08             	sub    $0x8,%esp
  105822:	53                   	push   %ebx
  105823:	57                   	push   %edi
  105824:	e8 27 fd ff ff       	call   105550 <futex_queue_remove>
	    q->futex = (uint32_t)uaddr2;
  105829:	8b 44 24 50          	mov    0x50(%esp),%eax
  10582d:	89 03                	mov    %eax,(%ebx)
    if (queue->waiters_tail == NULL) {
  10582f:	8b 44 24 18          	mov    0x18(%esp),%eax
  105833:	83 c4 10             	add    $0x10,%esp
  105836:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  105839:	8d 34 8d 80 ce 14 00 	lea    0x14ce80(,%ecx,4),%esi
  105840:	8b 4e 0c             	mov    0xc(%esi),%ecx
  105843:	85 c9                	test   %ecx,%ecx
  105845:	0f 84 d5 00 00 00    	je     105920 <futex+0x320>
	queue->waiters_tail->next = q;
  10584b:	89 59 0c             	mov    %ebx,0xc(%ecx)
	q->prev = queue->waiters_tail;
  10584e:	89 4b 08             	mov    %ecx,0x8(%ebx)
	queue->waiters_tail = q;
  105851:	89 5e 0c             	mov    %ebx,0xc(%esi)
    ++queue->waiters;
  105854:	8d 04 80             	lea    (%eax,%eax,4),%eax
    q->next = NULL;
  105857:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    ++queue->waiters;
  10585e:	83 04 85 90 ce 14 00 	addl   $0x1,0x14ce90(,%eax,4)
  105865:	01 
    spinlock_release(&queue2->lock);
  105866:	83 ec 0c             	sub    $0xc,%esp
  105869:	ff 74 24 18          	pushl  0x18(%esp)
  10586d:	e8 9e f5 ff ff       	call   104e10 <spinlock_release>
    spinlock_release(&queue->lock);
  105872:	89 3c 24             	mov    %edi,(%esp)
  105875:	e8 96 f5 ff ff       	call   104e10 <spinlock_release>
    return woken;
  10587a:	83 c4 10             	add    $0x10,%esp
}
  10587d:	89 e8                	mov    %ebp,%eax
  10587f:	83 c4 1c             	add    $0x1c,%esp
  105882:	5b                   	pop    %ebx
  105883:	5e                   	pop    %esi
  105884:	5f                   	pop    %edi
  105885:	5d                   	pop    %ebp
  105886:	c3                   	ret    
  105887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10588e:	66 90                	xchg   %ax,%ax
	struct futex_q *q = &futex_q_pool[get_curid()];
  105890:	e8 0b 17 00 00       	call   106fa0 <get_curid>
  105895:	89 44 24 08          	mov    %eax,0x8(%esp)
  105899:	c1 e0 04             	shl    $0x4,%eax
  10589c:	8d a8 a0 1c 15 00    	lea    0x151ca0(%eax),%ebp
	q->futex = (uint32_t)uaddr;
  1058a2:	89 b0 a0 1c 15 00    	mov    %esi,0x151ca0(%eax)
	q->pid = get_curid();
  1058a8:	e8 f3 16 00 00       	call   106fa0 <get_curid>
    if (queue->waiters_tail == NULL) {
  1058ad:	8b 54 24 08          	mov    0x8(%esp),%edx
	q->pid = get_curid();
  1058b1:	89 45 04             	mov    %eax,0x4(%ebp)
    if (queue->waiters_tail == NULL) {
  1058b4:	8b 47 0c             	mov    0xc(%edi),%eax
  1058b7:	85 c0                	test   %eax,%eax
  1058b9:	74 7d                	je     105938 <futex+0x338>
	queue->waiters_tail->next = q;
  1058bb:	89 68 0c             	mov    %ebp,0xc(%eax)
	q->prev = queue->waiters_tail;
  1058be:	89 45 08             	mov    %eax,0x8(%ebp)
	queue->waiters_tail = q;
  1058c1:	89 6f 0c             	mov    %ebp,0xc(%edi)
    q->next = NULL;
  1058c4:	89 d6                	mov    %edx,%esi
    ++queue->waiters;
  1058c6:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
	    return futex_wait(uaddr, val1, NULL);
  1058c9:	31 ed                	xor    %ebp,%ebp
    q->next = NULL;
  1058cb:	c1 e6 04             	shl    $0x4,%esi
    ++queue->waiters;
  1058ce:	83 04 85 90 ce 14 00 	addl   $0x1,0x14ce90(,%eax,4)
  1058d5:	01 
    q->next = NULL;
  1058d6:	c7 86 ac 1c 15 00 00 	movl   $0x0,0x151cac(%esi)
  1058dd:	00 00 00 
	thread_suspend(&queue->lock, get_curid());
  1058e0:	e8 bb 16 00 00       	call   106fa0 <get_curid>
  1058e5:	83 ec 08             	sub    $0x8,%esp
  1058e8:	50                   	push   %eax
  1058e9:	57                   	push   %edi
  1058ea:	e8 f1 18 00 00       	call   1071e0 <thread_suspend>
  1058ef:	83 c4 10             	add    $0x10,%esp
  1058f2:	e9 37 fd ff ff       	jmp    10562e <futex+0x2e>
  1058f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1058fe:	66 90                	xchg   %ax,%ax
	spinlock_release(&queue->lock);
  105900:	83 ec 0c             	sub    $0xc,%esp
	return 0;
  105903:	31 ed                	xor    %ebp,%ebp
	spinlock_release(&queue->lock);
  105905:	57                   	push   %edi
  105906:	e8 05 f5 ff ff       	call   104e10 <spinlock_release>
	spinlock_release(&queue2->lock);
  10590b:	5b                   	pop    %ebx
  10590c:	ff 74 24 18          	pushl  0x18(%esp)
  105910:	e8 fb f4 ff ff       	call   104e10 <spinlock_release>
	return 0;
  105915:	83 c4 10             	add    $0x10,%esp
  105918:	e9 11 fd ff ff       	jmp    10562e <futex+0x2e>
  10591d:	8d 76 00             	lea    0x0(%esi),%esi
	queue->waiters_tail = q;
  105920:	89 5e 0c             	mov    %ebx,0xc(%esi)
	queue->waiters_head = q;
  105923:	89 5e 08             	mov    %ebx,0x8(%esi)
	q->prev = NULL;
  105926:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  10592d:	e9 22 ff ff ff       	jmp    105854 <futex+0x254>
  105932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	queue->waiters_tail = q;
  105938:	89 6f 0c             	mov    %ebp,0xc(%edi)
	queue->waiters_head = q;
  10593b:	89 6f 08             	mov    %ebp,0x8(%edi)
	q->prev = NULL;
  10593e:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  105945:	e9 7a ff ff ff       	jmp    1058c4 <futex+0x2c4>
	return -2;
  10594a:	bd fe ff ff ff       	mov    $0xfffffffe,%ebp
  10594f:	e9 da fc ff ff       	jmp    10562e <futex+0x2e>
	spinlock_release(&queue->lock);
  105954:	83 ec 0c             	sub    $0xc,%esp
	return -1;
  105957:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
	spinlock_release(&queue->lock);
  10595c:	57                   	push   %edi
  10595d:	e8 ae f4 ff ff       	call   104e10 <spinlock_release>
	spinlock_release(&queue2->lock);
  105962:	59                   	pop    %ecx
  105963:	ff 74 24 18          	pushl  0x18(%esp)
  105967:	e8 a4 f4 ff ff       	call   104e10 <spinlock_release>
	return -1;
  10596c:	83 c4 10             	add    $0x10,%esp
  10596f:	e9 ba fc ff ff       	jmp    10562e <futex+0x2e>
  105974:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10597b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10597f:	90                   	nop

00105980 <futex_init>:


/*
 *  Initialize every futex queue
 */
void futex_init() {
  105980:	53                   	push   %ebx
  105981:	bb 80 ce 14 00       	mov    $0x14ce80,%ebx
  105986:	83 ec 08             	sub    $0x8,%esp
  105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    spinlock_init(&queue->lock);
  105990:	83 ec 0c             	sub    $0xc,%esp
  105993:	53                   	push   %ebx
  105994:	83 c3 14             	add    $0x14,%ebx
  105997:	e8 74 f3 ff ff       	call   104d10 <spinlock_init>
    queue->waiters_head = NULL;
  10599c:	c7 43 f4 00 00 00 00 	movl   $0x0,-0xc(%ebx)
    for (uint32_t i = 0; i < TOTAL_FUTEX_QUEUE_NUM; ++i) {
  1059a3:	83 c4 10             	add    $0x10,%esp
    queue->waiters_tail = NULL;
  1059a6:	c7 43 f8 00 00 00 00 	movl   $0x0,-0x8(%ebx)
    queue->waiters = 0;
  1059ad:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
    for (uint32_t i = 0; i < TOTAL_FUTEX_QUEUE_NUM; ++i) {
  1059b4:	81 fb a0 1c 15 00    	cmp    $0x151ca0,%ebx
  1059ba:	75 d4                	jne    105990 <futex_init+0x10>
	futex_queue_init(&futex_queues[i]);
    }
}
  1059bc:	83 c4 08             	add    $0x8,%esp
  1059bf:	5b                   	pop    %ebx
  1059c0:	c3                   	ret    
  1059c1:	66 90                	xchg   %ax,%ax
  1059c3:	66 90                	xchg   %ax,%ax
  1059c5:	66 90                	xchg   %ax,%ax
  1059c7:	66 90                	xchg   %ax,%ax
  1059c9:	66 90                	xchg   %ax,%ax
  1059cb:	66 90                	xchg   %ax,%ax
  1059cd:	66 90                	xchg   %ax,%ax
  1059cf:	90                   	nop

001059d0 <pcpu_set_zero>:
struct pcpu pcpu[NUM_CPUS];

extern int get_kstack_cpu_idx(void);

void pcpu_set_zero()
{
  1059d0:	83 ec 14             	sub    $0x14,%esp
    memzero(pcpu, sizeof(struct pcpu) * NUM_CPUS);
  1059d3:	68 80 02 00 00       	push   $0x280
  1059d8:	68 e0 d8 9d 00       	push   $0x9dd8e0
  1059dd:	e8 1e dd ff ff       	call   103700 <memzero>
}
  1059e2:	83 c4 1c             	add    $0x1c,%esp
  1059e5:	c3                   	ret    
  1059e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1059ed:	8d 76 00             	lea    0x0(%esi),%esi

001059f0 <pcpu_fields_init>:

void pcpu_fields_init(int cpu_idx)
{
  1059f0:	8b 54 24 04          	mov    0x4(%esp),%edx
    pcpu[cpu_idx].inited = TRUE;
  1059f4:	8d 04 92             	lea    (%edx,%edx,4),%eax
  1059f7:	c1 e0 04             	shl    $0x4,%eax
  1059fa:	c6 80 e0 d8 9d 00 01 	movb   $0x1,0x9dd8e0(%eax)
    pcpu[cpu_idx].cpu_idx = cpu_idx;
  105a01:	89 90 2c d9 9d 00    	mov    %edx,0x9dd92c(%eax)
}
  105a07:	c3                   	ret    
  105a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a0f:	90                   	nop

00105a10 <pcpu_cur>:

struct pcpu *pcpu_cur(void)
{
  105a10:	83 ec 0c             	sub    $0xc,%esp
    int cpu_idx = get_kstack_cpu_idx();
  105a13:	e8 d8 f2 ff ff       	call   104cf0 <get_kstack_cpu_idx>
    return &pcpu[cpu_idx];
}
  105a18:	83 c4 0c             	add    $0xc,%esp
    return &pcpu[cpu_idx];
  105a1b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105a1e:	c1 e0 04             	shl    $0x4,%eax
  105a21:	05 e0 d8 9d 00       	add    $0x9dd8e0,%eax
}
  105a26:	c3                   	ret    
  105a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a2e:	66 90                	xchg   %ax,%ax

00105a30 <get_pcpu_idx>:

int get_pcpu_idx(void)
{
  105a30:	83 ec 0c             	sub    $0xc,%esp
    int cpu_idx = get_kstack_cpu_idx();
  105a33:	e8 b8 f2 ff ff       	call   104cf0 <get_kstack_cpu_idx>
    return pcpu_cur()->cpu_idx;
  105a38:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105a3b:	c1 e0 04             	shl    $0x4,%eax
  105a3e:	8b 80 2c d9 9d 00    	mov    0x9dd92c(%eax),%eax
}
  105a44:	83 c4 0c             	add    $0xc,%esp
  105a47:	c3                   	ret    
  105a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a4f:	90                   	nop

00105a50 <set_pcpu_idx>:

void set_pcpu_idx(int index, int cpu_idx)
{
  105a50:	8b 44 24 04          	mov    0x4(%esp),%eax
    pcpu[index].cpu_idx = cpu_idx;
  105a54:	8b 54 24 08          	mov    0x8(%esp),%edx
  105a58:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105a5b:	c1 e0 04             	shl    $0x4,%eax
  105a5e:	89 90 2c d9 9d 00    	mov    %edx,0x9dd92c(%eax)
}
  105a64:	c3                   	ret    
  105a65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105a70 <get_pcpu_kstack_pointer>:

uintptr_t *get_pcpu_kstack_pointer(int cpu_idx)
{
  105a70:	8b 44 24 04          	mov    0x4(%esp),%eax
    return pcpu[cpu_idx].kstack;
  105a74:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105a77:	c1 e0 04             	shl    $0x4,%eax
  105a7a:	8b 80 e4 d8 9d 00    	mov    0x9dd8e4(%eax),%eax
}
  105a80:	c3                   	ret    
  105a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105a8f:	90                   	nop

00105a90 <set_pcpu_kstack_pointer>:

void set_pcpu_kstack_pointer(int cpu_idx, uintptr_t *ks)
{
  105a90:	8b 44 24 04          	mov    0x4(%esp),%eax
    pcpu[cpu_idx].kstack = ks;
  105a94:	8b 54 24 08          	mov    0x8(%esp),%edx
  105a98:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105a9b:	c1 e0 04             	shl    $0x4,%eax
  105a9e:	89 90 e4 d8 9d 00    	mov    %edx,0x9dd8e4(%eax)
}
  105aa4:	c3                   	ret    
  105aa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105ab0 <get_pcpu_boot_info>:

volatile bool get_pcpu_boot_info(int cpu_idx)
{
  105ab0:	8b 44 24 04          	mov    0x4(%esp),%eax
    return pcpu[cpu_idx].booted;
  105ab4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105ab7:	c1 e0 04             	shl    $0x4,%eax
  105aba:	05 e0 d8 9d 00       	add    $0x9dd8e0,%eax
  105abf:	0f b6 40 01          	movzbl 0x1(%eax),%eax
}
  105ac3:	c3                   	ret    
  105ac4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105acf:	90                   	nop

00105ad0 <set_pcpu_boot_info>:

void set_pcpu_boot_info(int cpu_idx, volatile bool boot_info)
{
  105ad0:	83 ec 04             	sub    $0x4,%esp
  105ad3:	8b 54 24 0c          	mov    0xc(%esp),%edx
  105ad7:	8b 44 24 08          	mov    0x8(%esp),%eax
  105adb:	88 14 24             	mov    %dl,(%esp)
    pcpu[cpu_idx].booted = boot_info;
  105ade:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105ae1:	0f b6 14 24          	movzbl (%esp),%edx
  105ae5:	c1 e0 04             	shl    $0x4,%eax
  105ae8:	88 90 e1 d8 9d 00    	mov    %dl,0x9dd8e1(%eax)
}
  105aee:	83 c4 04             	add    $0x4,%esp
  105af1:	c3                   	ret    
  105af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105b00 <get_pcpu_cpu_vendor>:

cpu_vendor get_pcpu_cpu_vendor(int cpu_idx)
{
  105b00:	8b 44 24 04          	mov    0x4(%esp),%eax
    return pcpu[cpu_idx].arch_info.cpu_vendor;
  105b04:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105b07:	c1 e0 04             	shl    $0x4,%eax
  105b0a:	8b 80 08 d9 9d 00    	mov    0x9dd908(%eax),%eax
}
  105b10:	c3                   	ret    
  105b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105b1f:	90                   	nop

00105b20 <get_pcpu_arch_info_pointer>:

uintptr_t *get_pcpu_arch_info_pointer(int cpu_idx)
{
  105b20:	8b 44 24 04          	mov    0x4(%esp),%eax
    return (uintptr_t *) &pcpu[cpu_idx].arch_info;
  105b24:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105b27:	c1 e0 04             	shl    $0x4,%eax
  105b2a:	05 e8 d8 9d 00       	add    $0x9dd8e8,%eax
}
  105b2f:	c3                   	ret    

00105b30 <get_pcpu_inited_info>:

bool get_pcpu_inited_info(int cpu_idx)
{
  105b30:	8b 44 24 04          	mov    0x4(%esp),%eax
    return pcpu[cpu_idx].inited;
  105b34:	8d 04 80             	lea    (%eax,%eax,4),%eax
  105b37:	c1 e0 04             	shl    $0x4,%eax
  105b3a:	0f b6 80 e0 d8 9d 00 	movzbl 0x9dd8e0(%eax),%eax
}
  105b41:	c3                   	ret    
  105b42:	66 90                	xchg   %ax,%ax
  105b44:	66 90                	xchg   %ax,%ax
  105b46:	66 90                	xchg   %ax,%ax
  105b48:	66 90                	xchg   %ax,%ax
  105b4a:	66 90                	xchg   %ax,%ax
  105b4c:	66 90                	xchg   %ax,%ax
  105b4e:	66 90                	xchg   %ax,%ax

00105b50 <pcpu_init>:
#include "import.h"

static bool pcpu_inited = FALSE;

void pcpu_init(void)
{
  105b50:	57                   	push   %edi
  105b51:	56                   	push   %esi
  105b52:	53                   	push   %ebx
    struct kstack *ks = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  105b53:	e8 e8 e7 ff ff       	call   104340 <read_esp>
  105b58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    int cpu_idx = ks->cpu_idx;
  105b5d:	8b b0 1c 01 00 00    	mov    0x11c(%eax),%esi
    struct kstack *ks = (struct kstack *) ROUNDDOWN(read_esp(), KSTACK_SIZE);
  105b63:	89 c7                	mov    %eax,%edi
    int i;

    if (cpu_idx == 0) {
  105b65:	85 f6                	test   %esi,%esi
  105b67:	75 32                	jne    105b9b <pcpu_init+0x4b>
        if (pcpu_inited == TRUE)
  105b69:	80 3d a0 20 15 00 01 	cmpb   $0x1,0x1520a0
  105b70:	74 56                	je     105bc8 <pcpu_init+0x78>
            return;

        pcpu_set_zero();
  105b72:	e8 59 fe ff ff       	call   1059d0 <pcpu_set_zero>

        /* Probe SMP. */
        pcpu_mp_init();

        for (i = 0; i < NUM_CPUS; i++) {
  105b77:	31 db                	xor    %ebx,%ebx
        pcpu_mp_init();
  105b79:	e8 02 cd ff ff       	call   102880 <pcpu_mp_init>
        for (i = 0; i < NUM_CPUS; i++) {
  105b7e:	66 90                	xchg   %ax,%ax
            pcpu_fields_init(i);
  105b80:	83 ec 0c             	sub    $0xc,%esp
  105b83:	53                   	push   %ebx
        for (i = 0; i < NUM_CPUS; i++) {
  105b84:	83 c3 01             	add    $0x1,%ebx
            pcpu_fields_init(i);
  105b87:	e8 64 fe ff ff       	call   1059f0 <pcpu_fields_init>
        for (i = 0; i < NUM_CPUS; i++) {
  105b8c:	83 c4 10             	add    $0x10,%esp
  105b8f:	83 fb 08             	cmp    $0x8,%ebx
  105b92:	75 ec                	jne    105b80 <pcpu_init+0x30>
        }

        pcpu_inited = TRUE;
  105b94:	c6 05 a0 20 15 00 01 	movb   $0x1,0x1520a0
    }

    set_pcpu_idx(cpu_idx, cpu_idx);
  105b9b:	83 ec 08             	sub    $0x8,%esp
  105b9e:	56                   	push   %esi
  105b9f:	56                   	push   %esi
  105ba0:	e8 ab fe ff ff       	call   105a50 <set_pcpu_idx>
    set_pcpu_kstack_pointer(cpu_idx, (uintptr_t *) ks);
  105ba5:	58                   	pop    %eax
  105ba6:	5a                   	pop    %edx
  105ba7:	57                   	push   %edi
  105ba8:	56                   	push   %esi
  105ba9:	e8 e2 fe ff ff       	call   105a90 <set_pcpu_kstack_pointer>
    set_pcpu_boot_info(cpu_idx, TRUE);
  105bae:	59                   	pop    %ecx
  105baf:	5b                   	pop    %ebx
  105bb0:	6a 01                	push   $0x1
  105bb2:	56                   	push   %esi
  105bb3:	e8 18 ff ff ff       	call   105ad0 <set_pcpu_boot_info>
    pcpu_init_cpu();
  105bb8:	83 c4 10             	add    $0x10,%esp
}
  105bbb:	5b                   	pop    %ebx
  105bbc:	5e                   	pop    %esi
  105bbd:	5f                   	pop    %edi
    pcpu_init_cpu();
  105bbe:	e9 0d d2 ff ff       	jmp    102dd0 <pcpu_init_cpu>
  105bc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105bc7:	90                   	nop
}
  105bc8:	5b                   	pop    %ebx
  105bc9:	5e                   	pop    %esi
  105bca:	5f                   	pop    %edi
  105bcb:	c3                   	ret    
  105bcc:	66 90                	xchg   %ax,%ax
  105bce:	66 90                	xchg   %ax,%ax

00105bd0 <kern_main_ap>:
    dprintf("\nTest complete. Please Use Ctrl-a x to exit qemu.");
#endif
}

static void kern_main_ap(void)
{
  105bd0:	56                   	push   %esi
  105bd1:	53                   	push   %ebx
  105bd2:	83 ec 04             	sub    $0x4,%esp
    unsigned int pid, pid2;
    int cpu_idx = get_pcpu_idx();
  105bd5:	e8 56 fe ff ff       	call   105a30 <get_pcpu_idx>

    set_pcpu_boot_info(cpu_idx, TRUE);
  105bda:	83 ec 08             	sub    $0x8,%esp
  105bdd:	6a 01                	push   $0x1
    int cpu_idx = get_pcpu_idx();
  105bdf:	89 c3                	mov    %eax,%ebx
    set_pcpu_boot_info(cpu_idx, TRUE);
  105be1:	50                   	push   %eax
  105be2:	e8 e9 fe ff ff       	call   105ad0 <set_pcpu_boot_info>

    while (all_ready == FALSE);
  105be7:	83 c4 10             	add    $0x10,%esp
  105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105bf0:	a1 a4 20 15 00       	mov    0x1520a4,%eax
  105bf5:	85 c0                	test   %eax,%eax
  105bf7:	74 f7                	je     105bf0 <kern_main_ap+0x20>

    KERN_INFO("[AP%d KERN] kernel_main_ap\n", cpu_idx);
  105bf9:	83 ec 08             	sub    $0x8,%esp
  105bfc:	53                   	push   %ebx
  105bfd:	68 28 a7 10 00       	push   $0x10a728
  105c02:	e8 c9 db ff ff       	call   1037d0 <debug_info>

    cpu_booted++;
  105c07:	a1 a8 20 15 00       	mov    0x1520a8,%eax


    if (cpu_idx == 1) {
  105c0c:	83 c4 10             	add    $0x10,%esp
    cpu_booted++;
  105c0f:	83 c0 01             	add    $0x1,%eax
  105c12:	a3 a8 20 15 00       	mov    %eax,0x1520a8
    if (cpu_idx == 1) {
  105c17:	83 fb 01             	cmp    $0x1,%ebx
  105c1a:	0f 84 80 00 00 00    	je     105ca0 <kern_main_ap+0xd0>
	pid = proc_create(_binary___obj_user_thread_thread_start, 1000);
	KERN_INFO("CPU%d: process futex_test %d is created.\n", cpu_idx, pid);

	pid2 = proc_create(_binary___obj_user_idle_idle_start, 1000);
	KERN_INFO("CPU%d: process idle %d is created.\n", cpu_idx, pid2);
    } else if (cpu_idx == 2) {
  105c20:	83 fb 02             	cmp    $0x2,%ebx
  105c23:	74 0b                	je     105c30 <kern_main_ap+0x60>
    set_curid(pid);
    kctx_switch(0, pid);

    KERN_PANIC("kern_main_ap() should never reach here.\n");
#endif*/
}
  105c25:	83 c4 04             	add    $0x4,%esp
  105c28:	5b                   	pop    %ebx
  105c29:	5e                   	pop    %esi
  105c2a:	c3                   	ret    
  105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105c2f:	90                   	nop
	pid2 = proc_create(_binary___obj_user_idle_idle_start, 1000);
  105c30:	83 ec 08             	sub    $0x8,%esp
  105c33:	68 e8 03 00 00       	push   $0x3e8
  105c38:	68 72 13 11 00       	push   $0x111372
  105c3d:	e8 4e 17 00 00       	call   107390 <proc_create>
	KERN_INFO("CPU%d: process idle %d is created.\n", cpu_idx, pid2);
  105c42:	83 c4 0c             	add    $0xc,%esp
  105c45:	50                   	push   %eax
	pid2 = proc_create(_binary___obj_user_idle_idle_start, 1000);
  105c46:	89 c6                	mov    %eax,%esi
	KERN_INFO("CPU%d: process idle %d is created.\n", cpu_idx, pid2);
  105c48:	6a 02                	push   $0x2
  105c4a:	68 d0 a7 10 00       	push   $0x10a7d0
  105c4f:	e8 7c db ff ff       	call   1037d0 <debug_info>
  105c54:	83 c4 10             	add    $0x10,%esp
    tqueue_remove(NUM_IDS + cpu_idx, pid2);
  105c57:	83 ec 08             	sub    $0x8,%esp
  105c5a:	83 c3 40             	add    $0x40,%ebx
  105c5d:	56                   	push   %esi
  105c5e:	53                   	push   %ebx
  105c5f:	e8 5c 12 00 00       	call   106ec0 <tqueue_remove>
    tcb_set_state(pid2, TSTATE_RUN);
  105c64:	58                   	pop    %eax
  105c65:	5a                   	pop    %edx
  105c66:	6a 01                	push   $0x1
  105c68:	56                   	push   %esi
  105c69:	e8 92 0f 00 00       	call   106c00 <tcb_set_state>
    set_curid(pid2);
  105c6e:	89 34 24             	mov    %esi,(%esp)
  105c71:	e8 4a 13 00 00       	call   106fc0 <set_curid>
    kctx_switch(0, pid2);
  105c76:	59                   	pop    %ecx
  105c77:	5b                   	pop    %ebx
  105c78:	56                   	push   %esi
  105c79:	6a 00                	push   $0x0
  105c7b:	e8 a0 0e 00 00       	call   106b20 <kctx_switch>
    KERN_PANIC("kern_main_ap() should never reach here.\n");
  105c80:	83 c4 0c             	add    $0xc,%esp
  105c83:	68 f4 a7 10 00       	push   $0x10a7f4
  105c88:	6a 7d                	push   $0x7d
  105c8a:	68 44 a7 10 00       	push   $0x10a744
  105c8f:	e8 bc db ff ff       	call   103850 <debug_panic>
  105c94:	83 c4 10             	add    $0x10,%esp
}
  105c97:	83 c4 04             	add    $0x4,%esp
  105c9a:	5b                   	pop    %ebx
  105c9b:	5e                   	pop    %esi
  105c9c:	c3                   	ret    
  105c9d:	8d 76 00             	lea    0x0(%esi),%esi
	pid = proc_create(_binary___obj_user_thread_thread_start, 1000);
  105ca0:	83 ec 08             	sub    $0x8,%esp
  105ca3:	68 e8 03 00 00       	push   $0x3e8
  105ca8:	68 ba 82 13 00       	push   $0x1382ba
  105cad:	e8 de 16 00 00       	call   107390 <proc_create>
	KERN_INFO("CPU%d: process futex_test %d is created.\n", cpu_idx, pid);
  105cb2:	83 c4 0c             	add    $0xc,%esp
  105cb5:	50                   	push   %eax
  105cb6:	6a 01                	push   $0x1
  105cb8:	68 a4 a7 10 00       	push   $0x10a7a4
  105cbd:	e8 0e db ff ff       	call   1037d0 <debug_info>
	pid2 = proc_create(_binary___obj_user_idle_idle_start, 1000);
  105cc2:	5e                   	pop    %esi
  105cc3:	58                   	pop    %eax
  105cc4:	68 e8 03 00 00       	push   $0x3e8
  105cc9:	68 72 13 11 00       	push   $0x111372
  105cce:	e8 bd 16 00 00       	call   107390 <proc_create>
	KERN_INFO("CPU%d: process idle %d is created.\n", cpu_idx, pid2);
  105cd3:	83 c4 0c             	add    $0xc,%esp
  105cd6:	50                   	push   %eax
	pid2 = proc_create(_binary___obj_user_idle_idle_start, 1000);
  105cd7:	89 c6                	mov    %eax,%esi
	KERN_INFO("CPU%d: process idle %d is created.\n", cpu_idx, pid2);
  105cd9:	6a 01                	push   $0x1
  105cdb:	68 d0 a7 10 00       	push   $0x10a7d0
  105ce0:	e8 eb da ff ff       	call   1037d0 <debug_info>
  105ce5:	83 c4 10             	add    $0x10,%esp
  105ce8:	e9 6a ff ff ff       	jmp    105c57 <kern_main_ap+0x87>
  105ced:	8d 76 00             	lea    0x0(%esi),%esi

00105cf0 <kern_init>:

void kern_init(uintptr_t mbi_addr)
{
  105cf0:	56                   	push   %esi
  105cf1:	be 00 40 99 00       	mov    $0x994000,%esi
  105cf6:	53                   	push   %ebx
    for (i = 1; i < pcpu_ncpu(); i++) {
  105cf7:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  105cfc:	83 ec 10             	sub    $0x10,%esp
    thread_init(mbi_addr);
  105cff:	ff 74 24 1c          	pushl  0x1c(%esp)
  105d03:	e8 d8 12 00 00       	call   106fe0 <thread_init>
    futex_init();
  105d08:	e8 73 fc ff ff       	call   105980 <futex_init>
    KERN_INFO("[BSP KERN] Kernel initialized.\n");
  105d0d:	c7 04 24 20 a8 10 00 	movl   $0x10a820,(%esp)
  105d14:	e8 b7 da ff ff       	call   1037d0 <debug_info>
    KERN_INFO("[BSP KERN] In kernel main.\n\n");
  105d19:	c7 04 24 55 a7 10 00 	movl   $0x10a755,(%esp)
  105d20:	e8 ab da ff ff       	call   1037d0 <debug_info>
    KERN_INFO("[BSP KERN] Number of CPUs in this system: %d. \n", pcpu_ncpu());
  105d25:	e8 66 d4 ff ff       	call   103190 <pcpu_ncpu>
  105d2a:	5a                   	pop    %edx
  105d2b:	59                   	pop    %ecx
  105d2c:	50                   	push   %eax
  105d2d:	68 40 a8 10 00       	push   $0x10a840
  105d32:	e8 99 da ff ff       	call   1037d0 <debug_info>
    int cpu_idx = get_pcpu_idx();
  105d37:	e8 f4 fc ff ff       	call   105a30 <get_pcpu_idx>
    for (i = 1; i < pcpu_ncpu(); i++) {
  105d3c:	83 c4 10             	add    $0x10,%esp
    all_ready = FALSE;
  105d3f:	c7 05 a4 20 15 00 00 	movl   $0x0,0x1520a4
  105d46:	00 00 00 
    for (i = 1; i < pcpu_ncpu(); i++) {
  105d49:	e8 42 d4 ff ff       	call   103190 <pcpu_ncpu>
  105d4e:	39 d8                	cmp    %ebx,%eax
  105d50:	76 60                	jbe    105db2 <kern_init+0xc2>
  105d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        KERN_INFO("[BSP KERN] Boot CPU %d .... \n", i);
  105d58:	83 ec 08             	sub    $0x8,%esp
  105d5b:	53                   	push   %ebx
  105d5c:	68 72 a7 10 00       	push   $0x10a772
  105d61:	e8 6a da ff ff       	call   1037d0 <debug_info>
        pcpu_boot_ap(i, kern_main_ap, (uintptr_t) &bsp_kstack[i]);
  105d66:	83 c4 0c             	add    $0xc,%esp
        bsp_kstack[i].cpu_idx = i;
  105d69:	89 9e 1c 01 00 00    	mov    %ebx,0x11c(%esi)
        pcpu_boot_ap(i, kern_main_ap, (uintptr_t) &bsp_kstack[i]);
  105d6f:	56                   	push   %esi
  105d70:	68 d0 5b 10 00       	push   $0x105bd0
  105d75:	53                   	push   %ebx
  105d76:	e8 c5 d4 ff ff       	call   103240 <pcpu_boot_ap>
        while (get_pcpu_boot_info(i) == FALSE);
  105d7b:	83 c4 10             	add    $0x10,%esp
  105d7e:	66 90                	xchg   %ax,%ax
  105d80:	83 ec 0c             	sub    $0xc,%esp
  105d83:	53                   	push   %ebx
  105d84:	e8 27 fd ff ff       	call   105ab0 <get_pcpu_boot_info>
  105d89:	83 c4 10             	add    $0x10,%esp
  105d8c:	84 c0                	test   %al,%al
  105d8e:	74 f0                	je     105d80 <kern_init+0x90>
        KERN_INFO("[BSP KERN] done.\n");
  105d90:	83 ec 0c             	sub    $0xc,%esp
    for (i = 1; i < pcpu_ncpu(); i++) {
  105d93:	83 c3 01             	add    $0x1,%ebx
  105d96:	81 c6 00 10 00 00    	add    $0x1000,%esi
        KERN_INFO("[BSP KERN] done.\n");
  105d9c:	68 90 a7 10 00       	push   $0x10a790
  105da1:	e8 2a da ff ff       	call   1037d0 <debug_info>
    for (i = 1; i < pcpu_ncpu(); i++) {
  105da6:	83 c4 10             	add    $0x10,%esp
  105da9:	e8 e2 d3 ff ff       	call   103190 <pcpu_ncpu>
  105dae:	39 d8                	cmp    %ebx,%eax
  105db0:	77 a6                	ja     105d58 <kern_init+0x68>
    all_ready = TRUE;
  105db2:	c7 05 a4 20 15 00 01 	movl   $0x1,0x1520a4
  105db9:	00 00 00 
    kern_main();
}
  105dbc:	83 c4 04             	add    $0x4,%esp
  105dbf:	5b                   	pop    %ebx
  105dc0:	5e                   	pop    %esi
  105dc1:	c3                   	ret    
  105dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105dd0 <kern_init_ap>:

void kern_init_ap(void (*f)(void))
{
  105dd0:	53                   	push   %ebx
  105dd1:	83 ec 08             	sub    $0x8,%esp
  105dd4:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    devinit_ap();
  105dd8:	e8 f3 ab ff ff       	call   1009d0 <devinit_ap>
    f();
}
  105ddd:	83 c4 08             	add    $0x8,%esp
    f();
  105de0:	89 d8                	mov    %ebx,%eax
}
  105de2:	5b                   	pop    %ebx
    f();
  105de3:	ff e0                	jmp    *%eax
  105de5:	66 90                	xchg   %ax,%ax
  105de7:	90                   	nop
  105de8:	02 b0 ad 1b 03 00    	add    0x31bad(%eax),%dh
  105dee:	00 00                	add    %al,(%eax)
  105df0:	fb                   	sti    
  105df1:	4f                   	dec    %edi
  105df2:	52                   	push   %edx
  105df3:	e4                   	.byte 0xe4

00105df4 <start>:
	.long CHECKSUM

	/* this is the entry of the kernel */
	.globl start
start:
	cli
  105df4:	fa                   	cli    

	/* check whether the bootloader provide multiboot information */
	cmpl	$MULTIBOOT_BOOTLOADER_MAGIC, %eax
  105df5:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
	jne	spin
  105dfa:	75 27                	jne    105e23 <spin>
	movl	%ebx, multiboot_ptr
  105dfc:	89 1d 24 5e 10 00    	mov    %ebx,0x105e24

	/* tell BIOS to warmboot next time */
	movw	$0x1234, 0x472
  105e02:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
  105e09:	34 12 

	/* clear EFLAGS */
	pushl	$0x2
  105e0b:	6a 02                	push   $0x2
	popfl
  105e0d:	9d                   	popf   

	/* prepare the kernel stack */
	movl	$0x0, %ebp
  105e0e:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl	$(bsp_kstack + 4096), %esp
  105e13:	bc 00 40 99 00       	mov    $0x994000,%esp

	/* jump to the C code */
	push	multiboot_ptr
  105e18:	ff 35 24 5e 10 00    	pushl  0x105e24
	call	kern_init
  105e1e:	e8 cd fe ff ff       	call   105cf0 <kern_init>

00105e23 <spin>:

	/* should not be here */
spin:
	hlt
  105e23:	f4                   	hlt    

00105e24 <multiboot_ptr>:
  105e24:	00 00                	add    %al,(%eax)
  105e26:	00 00                	add    %al,(%eax)
  105e28:	66 90                	xchg   %ax,%ax
  105e2a:	66 90                	xchg   %ax,%ax
  105e2c:	66 90                	xchg   %ax,%ax
  105e2e:	66 90                	xchg   %ax,%ax

00105e30 <mem_spinlock_init>:
 * So it may have up to 2^20 physical pages,
 * with the page size being 4KB.
 */
static struct ATStruct AT[1 << 20];

void mem_spinlock_init(void) {
  105e30:	83 ec 18             	sub    $0x18,%esp
    spinlock_init(&mem_lk);
  105e33:	68 c4 20 95 00       	push   $0x9520c4
  105e38:	e8 d3 ee ff ff       	call   104d10 <spinlock_init>
}
  105e3d:	83 c4 1c             	add    $0x1c,%esp
  105e40:	c3                   	ret    
  105e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e4f:	90                   	nop

00105e50 <mem_lock>:

void mem_lock(void) {
  105e50:	83 ec 18             	sub    $0x18,%esp
    spinlock_acquire(&mem_lk);
  105e53:	68 c4 20 95 00       	push   $0x9520c4
  105e58:	e8 43 ef ff ff       	call   104da0 <spinlock_acquire>
}
  105e5d:	83 c4 1c             	add    $0x1c,%esp
  105e60:	c3                   	ret    
  105e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e6f:	90                   	nop

00105e70 <mem_unlock>:

void mem_unlock(void) {
  105e70:	83 ec 18             	sub    $0x18,%esp
    spinlock_release(&mem_lk);
  105e73:	68 c4 20 95 00       	push   $0x9520c4
  105e78:	e8 93 ef ff ff       	call   104e10 <spinlock_release>
}
  105e7d:	83 c4 1c             	add    $0x1c,%esp
  105e80:	c3                   	ret    
  105e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e8f:	90                   	nop

00105e90 <get_nps>:

// The getter function for NUM_PAGES.
unsigned int get_nps(void)
{
    return NUM_PAGES;
}
  105e90:	a1 c0 20 95 00       	mov    0x9520c0,%eax
  105e95:	c3                   	ret    
  105e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105e9d:	8d 76 00             	lea    0x0(%esi),%esi

00105ea0 <set_nps>:

// The setter function for NUM_PAGES.
void set_nps(unsigned int nps)
{
    NUM_PAGES = nps;
  105ea0:	8b 44 24 04          	mov    0x4(%esp),%eax
  105ea4:	a3 c0 20 95 00       	mov    %eax,0x9520c0
}
  105ea9:	c3                   	ret    
  105eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105eb0 <at_is_norm>:
unsigned int at_is_norm(unsigned int page_index)
{
    unsigned int perm;

    perm = AT[page_index].perm;
    if (perm > 1) {
  105eb0:	8b 44 24 04          	mov    0x4(%esp),%eax
  105eb4:	83 3c c5 c0 20 15 00 	cmpl   $0x1,0x1520c0(,%eax,8)
  105ebb:	01 
  105ebc:	0f 97 c0             	seta   %al
  105ebf:	0f b6 c0             	movzbl %al,%eax
    } else {
        perm = 0;
    }

    return perm;
}
  105ec2:	c3                   	ret    
  105ec3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105ed0 <at_set_perm>:
 * The setter function for the physical page permission.
 * Sets the permission of the page with given index.
 * It also marks the page as unallocated.
 */
void at_set_perm(unsigned int page_index, unsigned int perm)
{
  105ed0:	8b 44 24 04          	mov    0x4(%esp),%eax
    AT[page_index].perm = perm;
  105ed4:	8b 54 24 08          	mov    0x8(%esp),%edx
    AT[page_index].allocated = 0;
  105ed8:	c7 04 c5 c4 20 15 00 	movl   $0x0,0x1520c4(,%eax,8)
  105edf:	00 00 00 00 
    AT[page_index].perm = perm;
  105ee3:	89 14 c5 c0 20 15 00 	mov    %edx,0x1520c0(,%eax,8)
}
  105eea:	c3                   	ret    
  105eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105eef:	90                   	nop

00105ef0 <at_is_allocated>:
 */
unsigned int at_is_allocated(unsigned int page_index)
{
    unsigned int allocated;

    allocated = AT[page_index].allocated;
  105ef0:	8b 44 24 04          	mov    0x4(%esp),%eax
    if (allocated > 0) {
        allocated = 1;
    }

    return allocated;
  105ef4:	ba 01 00 00 00       	mov    $0x1,%edx
    allocated = AT[page_index].allocated;
  105ef9:	8b 04 c5 c4 20 15 00 	mov    0x1520c4(,%eax,8),%eax
    return allocated;
  105f00:	85 c0                	test   %eax,%eax
  105f02:	0f 45 c2             	cmovne %edx,%eax
}
  105f05:	c3                   	ret    
  105f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105f0d:	8d 76 00             	lea    0x0(%esi),%esi

00105f10 <at_set_allocated>:
 * The setter function for the physical page allocation flag.
 * Set the flag of the page with given index to the given value.
 */
void at_set_allocated(unsigned int page_index, unsigned int allocated)
{
    AT[page_index].allocated = allocated;
  105f10:	8b 44 24 04          	mov    0x4(%esp),%eax
  105f14:	8b 54 24 08          	mov    0x8(%esp),%edx
  105f18:	89 14 c5 c4 20 15 00 	mov    %edx,0x1520c4(,%eax,8)
}
  105f1f:	c3                   	ret    

00105f20 <pmem_init>:
 *    based on the information available in the physical memory map table.
 *    Review import.h in the current directory for the list of available
 *    getter and setter functions.
 */
void pmem_init(unsigned int mbi_addr)
{
  105f20:	55                   	push   %ebp
  105f21:	57                   	push   %edi
  105f22:	56                   	push   %esi
  105f23:	53                   	push   %ebx
  105f24:	83 ec 38             	sub    $0x38,%esp
    unsigned int pg_idx, pmmap_size, cur_addr, highest_addr;
    unsigned int entry_idx, flag, isnorm, start, len;

    // Calls the lower layer initialization primitive.
    // The parameter mbi_addr should not be used in the further code.
    devinit(mbi_addr);
  105f27:	ff 74 24 4c          	pushl  0x4c(%esp)
  105f2b:	e8 10 aa ff ff       	call   100940 <devinit>
    mem_spinlock_init();
  105f30:	e8 fb fe ff ff       	call   105e30 <mem_spinlock_init>
     * Hint: Think of it as the highest address in the ranges of the memory map table,
     *       divided by the page size.
     */
    nps = 0;
    entry_idx = 0;
    pmmap_size = get_size();
  105f35:	e8 f6 ae ff ff       	call   100e30 <get_size>
    while (entry_idx < pmmap_size) {
  105f3a:	83 c4 10             	add    $0x10,%esp
  105f3d:	85 c0                	test   %eax,%eax
  105f3f:	0f 84 49 01 00 00    	je     10608e <pmem_init+0x16e>
  105f45:	89 c6                	mov    %eax,%esi
    entry_idx = 0;
  105f47:	31 ed                	xor    %ebp,%ebp
    nps = 0;
  105f49:	31 ff                	xor    %edi,%edi
  105f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  105f4f:	90                   	nop
        cur_addr = get_mms(entry_idx) + get_mml(entry_idx);
  105f50:	83 ec 0c             	sub    $0xc,%esp
  105f53:	55                   	push   %ebp
  105f54:	e8 e7 ae ff ff       	call   100e40 <get_mms>
  105f59:	89 2c 24             	mov    %ebp,(%esp)
  105f5c:	89 c3                	mov    %eax,%ebx
  105f5e:	e8 1d af ff ff       	call   100e80 <get_mml>
        if (nps < cur_addr) {
  105f63:	83 c4 10             	add    $0x10,%esp
        cur_addr = get_mms(entry_idx) + get_mml(entry_idx);
  105f66:	01 d8                	add    %ebx,%eax
  105f68:	39 c7                	cmp    %eax,%edi
  105f6a:	0f 42 f8             	cmovb  %eax,%edi
            nps = cur_addr;
        }
        entry_idx++;
  105f6d:	83 c5 01             	add    $0x1,%ebp
    while (entry_idx < pmmap_size) {
  105f70:	39 ee                	cmp    %ebp,%esi
  105f72:	75 dc                	jne    105f50 <pmem_init+0x30>
    }

    nps = ROUNDDOWN(nps, PAGESIZE) / PAGESIZE;
  105f74:	c1 ef 0c             	shr    $0xc,%edi
    set_nps(nps);  // Setting the value computed above to NUM_PAGES.
  105f77:	83 ec 0c             	sub    $0xc,%esp
    nps = ROUNDDOWN(nps, PAGESIZE) / PAGESIZE;
  105f7a:	89 7c 24 24          	mov    %edi,0x24(%esp)
    set_nps(nps);  // Setting the value computed above to NUM_PAGES.
  105f7e:	57                   	push   %edi
  105f7f:	e8 1c ff ff ff       	call   105ea0 <set_nps>
     *    not aligned by pages, so it may be possible that for some pages, only some of
     *    the addresses are in a usable range. Currently, we do not utilize partial pages,
     *    so in that case, you should consider those pages as unavailable.
     */
    pg_idx = 0;
    while (pg_idx < nps) {
  105f84:	83 c4 10             	add    $0x10,%esp
  105f87:	85 ff                	test   %edi,%edi
  105f89:	0f 84 db 00 00 00    	je     10606a <pmem_init+0x14a>
    pg_idx = 0;
  105f8f:	89 6c 24 0c          	mov    %ebp,0xc(%esp)
    while (pg_idx < nps) {
  105f93:	31 f6                	xor    %esi,%esi
    pg_idx = 0;
  105f95:	31 ff                	xor    %edi,%edi
  105f97:	eb 25                	jmp    105fbe <pmem_init+0x9e>
  105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (pg_idx < VM_USERLO_PI || VM_USERHI_PI <= pg_idx) {
            at_set_perm(pg_idx, 1);
  105fa0:	83 ec 08             	sub    $0x8,%esp
  105fa3:	6a 01                	push   $0x1
  105fa5:	51                   	push   %ecx
  105fa6:	e8 25 ff ff ff       	call   105ed0 <at_set_perm>
  105fab:	83 c4 10             	add    $0x10,%esp
    while (pg_idx < nps) {
  105fae:	81 c6 00 10 00 00    	add    $0x1000,%esi
  105fb4:	39 7c 24 18          	cmp    %edi,0x18(%esp)
  105fb8:	0f 84 ac 00 00 00    	je     10606a <pmem_init+0x14a>
        if (pg_idx < VM_USERLO_PI || VM_USERHI_PI <= pg_idx) {
  105fbe:	89 f9                	mov    %edi,%ecx
  105fc0:	89 7c 24 14          	mov    %edi,0x14(%esp)
  105fc4:	83 c7 01             	add    $0x1,%edi
  105fc7:	8d 81 00 00 fc ff    	lea    -0x40000(%ecx),%eax
  105fcd:	3d ff ff 0a 00       	cmp    $0xaffff,%eax
  105fd2:	77 cc                	ja     105fa0 <pmem_init+0x80>
        } else {
            entry_idx = 0;
            flag = 0;
            isnorm = 0;
            while (entry_idx < pmmap_size && !flag) {
  105fd4:	89 f8                	mov    %edi,%eax
            entry_idx = 0;
  105fd6:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
  105fda:	31 db                	xor    %ebx,%ebx
  105fdc:	c1 e0 0c             	shl    $0xc,%eax
  105fdf:	89 44 24 10          	mov    %eax,0x10(%esp)
  105fe3:	eb 22                	jmp    106007 <pmem_init+0xe7>
  105fe5:	8d 76 00             	lea    0x0(%esi),%esi
                isnorm = is_usable(entry_idx);
                start = get_mms(entry_idx);
                len = get_mml(entry_idx);
                if (start <= pg_idx * PAGESIZE && (pg_idx + 1) * PAGESIZE <= start + len) {
  105fe8:	8d 54 05 00          	lea    0x0(%ebp,%eax,1),%edx
  105fec:	8b 44 24 10          	mov    0x10(%esp),%eax
  105ff0:	31 c9                	xor    %ecx,%ecx
  105ff2:	39 c2                	cmp    %eax,%edx
  105ff4:	0f 93 c1             	setae  %cl
  105ff7:	0f 92 c0             	setb   %al
                    flag = 1;
                }
                entry_idx++;
  105ffa:	83 c3 01             	add    $0x1,%ebx
            while (entry_idx < pmmap_size && !flag) {
  105ffd:	3b 5c 24 0c          	cmp    0xc(%esp),%ebx
  106001:	73 38                	jae    10603b <pmem_init+0x11b>
  106003:	84 c0                	test   %al,%al
  106005:	74 34                	je     10603b <pmem_init+0x11b>
                isnorm = is_usable(entry_idx);
  106007:	83 ec 0c             	sub    $0xc,%esp
  10600a:	53                   	push   %ebx
  10600b:	e8 d0 ae ff ff       	call   100ee0 <is_usable>
                start = get_mms(entry_idx);
  106010:	89 1c 24             	mov    %ebx,(%esp)
                isnorm = is_usable(entry_idx);
  106013:	89 c7                	mov    %eax,%edi
                start = get_mms(entry_idx);
  106015:	e8 26 ae ff ff       	call   100e40 <get_mms>
                len = get_mml(entry_idx);
  10601a:	89 1c 24             	mov    %ebx,(%esp)
                start = get_mms(entry_idx);
  10601d:	89 c5                	mov    %eax,%ebp
                len = get_mml(entry_idx);
  10601f:	e8 5c ae ff ff       	call   100e80 <get_mml>
                if (start <= pg_idx * PAGESIZE && (pg_idx + 1) * PAGESIZE <= start + len) {
  106024:	83 c4 10             	add    $0x10,%esp
  106027:	39 ee                	cmp    %ebp,%esi
  106029:	73 bd                	jae    105fe8 <pmem_init+0xc8>
  10602b:	b8 01 00 00 00       	mov    $0x1,%eax
  106030:	31 c9                	xor    %ecx,%ecx
                entry_idx++;
  106032:	83 c3 01             	add    $0x1,%ebx
            while (entry_idx < pmmap_size && !flag) {
  106035:	3b 5c 24 0c          	cmp    0xc(%esp),%ebx
  106039:	72 c8                	jb     106003 <pmem_init+0xe3>
  10603b:	89 f8                	mov    %edi,%eax
  10603d:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
            }

            if (flag && isnorm) {
  106041:	85 c0                	test   %eax,%eax
  106043:	74 33                	je     106078 <pmem_init+0x158>
  106045:	85 c9                	test   %ecx,%ecx
  106047:	74 2f                	je     106078 <pmem_init+0x158>
                at_set_perm(pg_idx, 2);
  106049:	83 ec 08             	sub    $0x8,%esp
  10604c:	81 c6 00 10 00 00    	add    $0x1000,%esi
  106052:	6a 02                	push   $0x2
  106054:	ff 74 24 20          	pushl  0x20(%esp)
  106058:	e8 73 fe ff ff       	call   105ed0 <at_set_perm>
  10605d:	83 c4 10             	add    $0x10,%esp
    while (pg_idx < nps) {
  106060:	39 7c 24 18          	cmp    %edi,0x18(%esp)
  106064:	0f 85 54 ff ff ff    	jne    105fbe <pmem_init+0x9e>
                at_set_perm(pg_idx, 0);
            }
        }
        pg_idx++;
    }
}
  10606a:	83 c4 2c             	add    $0x2c,%esp
  10606d:	5b                   	pop    %ebx
  10606e:	5e                   	pop    %esi
  10606f:	5f                   	pop    %edi
  106070:	5d                   	pop    %ebp
  106071:	c3                   	ret    
  106072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                at_set_perm(pg_idx, 0);
  106078:	83 ec 08             	sub    $0x8,%esp
  10607b:	6a 00                	push   $0x0
  10607d:	ff 74 24 20          	pushl  0x20(%esp)
  106081:	e8 4a fe ff ff       	call   105ed0 <at_set_perm>
  106086:	83 c4 10             	add    $0x10,%esp
  106089:	e9 20 ff ff ff       	jmp    105fae <pmem_init+0x8e>
    set_nps(nps);  // Setting the value computed above to NUM_PAGES.
  10608e:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%esp)
  106095:	00 
}
  106096:	83 c4 2c             	add    $0x2c,%esp
  106099:	5b                   	pop    %ebx
  10609a:	5e                   	pop    %esi
  10609b:	5f                   	pop    %edi
  10609c:	5d                   	pop    %ebp
    set_nps(nps);  // Setting the value computed above to NUM_PAGES.
  10609d:	e9 fe fd ff ff       	jmp    105ea0 <set_nps>
  1060a2:	66 90                	xchg   %ax,%ax
  1060a4:	66 90                	xchg   %ax,%ax
  1060a6:	66 90                	xchg   %ax,%ax
  1060a8:	66 90                	xchg   %ax,%ax
  1060aa:	66 90                	xchg   %ax,%ax
  1060ac:	66 90                	xchg   %ax,%ax
  1060ae:	66 90                	xchg   %ax,%ax

001060b0 <palloc>:
 *    return 0.
 * 2. Optimize the code using memoization so that you do not have to
 *    scan the allocation table from scratch every time.
 */
unsigned int palloc()
{
  1060b0:	57                   	push   %edi
  1060b1:	56                   	push   %esi
  1060b2:	53                   	push   %ebx
    unsigned int nps;
    unsigned int palloc_index;
    unsigned int palloc_free_index;
    bool first;

    mem_lock();
  1060b3:	e8 98 fd ff ff       	call   105e50 <mem_lock>

    nps = get_nps();
  1060b8:	e8 d3 fd ff ff       	call   105e90 <get_nps>
    palloc_index = last_palloc_index;
  1060bd:	8b 1d 08 13 11 00    	mov    0x111308,%ebx
    nps = get_nps();
  1060c3:	89 c6                	mov    %eax,%esi
    palloc_free_index = nps;
    first = TRUE;

    while ((palloc_index != last_palloc_index || first) && palloc_free_index == nps) {
  1060c5:	eb 19                	jmp    1060e0 <palloc+0x30>
  1060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1060ce:	66 90                	xchg   %ax,%ax
  1060d0:	3d 00 00 04 00       	cmp    $0x40000,%eax
  1060d5:	74 2f                	je     106106 <palloc+0x56>
  1060d7:	bb 00 00 04 00       	mov    $0x40000,%ebx
  1060dc:	39 f7                	cmp    %esi,%edi
  1060de:	75 60                	jne    106140 <palloc+0x90>
        first = FALSE;
        if (at_is_norm(palloc_index) && !at_is_allocated(palloc_index)) {
  1060e0:	83 ec 0c             	sub    $0xc,%esp
  1060e3:	89 f7                	mov    %esi,%edi
  1060e5:	53                   	push   %ebx
  1060e6:	e8 c5 fd ff ff       	call   105eb0 <at_is_norm>
  1060eb:	83 c4 10             	add    $0x10,%esp
  1060ee:	85 c0                	test   %eax,%eax
  1060f0:	75 36                	jne    106128 <palloc+0x78>
            palloc_free_index = palloc_index;
        }
        palloc_index++;
  1060f2:	83 c3 01             	add    $0x1,%ebx
        if (palloc_index >= VM_USERHI_PI) {
  1060f5:	a1 08 13 11 00       	mov    0x111308,%eax
  1060fa:	81 fb ff ff 0e 00    	cmp    $0xeffff,%ebx
  106100:	77 ce                	ja     1060d0 <palloc+0x20>
    while ((palloc_index != last_palloc_index || first) && palloc_free_index == nps) {
  106102:	39 c3                	cmp    %eax,%ebx
  106104:	75 d6                	jne    1060dc <palloc+0x2c>
            palloc_index = VM_USERLO_PI;
        }
    }

    if (palloc_free_index == nps) {
  106106:	39 f7                	cmp    %esi,%edi
  106108:	75 36                	jne    106140 <palloc+0x90>
        palloc_free_index = 0;
        last_palloc_index = VM_USERLO_PI;
  10610a:	c7 05 08 13 11 00 00 	movl   $0x40000,0x111308
  106111:	00 04 00 
        palloc_free_index = 0;
  106114:	31 ff                	xor    %edi,%edi
    } else {
        at_set_allocated(palloc_free_index, 1);
        last_palloc_index = palloc_free_index;
    }

    mem_unlock();
  106116:	e8 55 fd ff ff       	call   105e70 <mem_unlock>

    return palloc_free_index;
}
  10611b:	89 f8                	mov    %edi,%eax
  10611d:	5b                   	pop    %ebx
  10611e:	5e                   	pop    %esi
  10611f:	5f                   	pop    %edi
  106120:	c3                   	ret    
  106121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (at_is_norm(palloc_index) && !at_is_allocated(palloc_index)) {
  106128:	83 ec 0c             	sub    $0xc,%esp
  10612b:	89 df                	mov    %ebx,%edi
  10612d:	53                   	push   %ebx
  10612e:	e8 bd fd ff ff       	call   105ef0 <at_is_allocated>
  106133:	83 c4 10             	add    $0x10,%esp
  106136:	85 c0                	test   %eax,%eax
  106138:	0f 45 fe             	cmovne %esi,%edi
  10613b:	eb b5                	jmp    1060f2 <palloc+0x42>
  10613d:	8d 76 00             	lea    0x0(%esi),%esi
        at_set_allocated(palloc_free_index, 1);
  106140:	83 ec 08             	sub    $0x8,%esp
  106143:	6a 01                	push   $0x1
  106145:	57                   	push   %edi
  106146:	e8 c5 fd ff ff       	call   105f10 <at_set_allocated>
        last_palloc_index = palloc_free_index;
  10614b:	83 c4 10             	add    $0x10,%esp
  10614e:	89 3d 08 13 11 00    	mov    %edi,0x111308
    mem_unlock();
  106154:	e8 17 fd ff ff       	call   105e70 <mem_unlock>
}
  106159:	89 f8                	mov    %edi,%eax
  10615b:	5b                   	pop    %ebx
  10615c:	5e                   	pop    %esi
  10615d:	5f                   	pop    %edi
  10615e:	c3                   	ret    
  10615f:	90                   	nop

00106160 <pfree>:
 * in the allocation table.
 *
 * Hint: Simple.
 */
void pfree(unsigned int pfree_index)
{
  106160:	53                   	push   %ebx
  106161:	83 ec 08             	sub    $0x8,%esp
  106164:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    mem_lock();
  106168:	e8 e3 fc ff ff       	call   105e50 <mem_lock>
    at_set_allocated(pfree_index, 0);
  10616d:	83 ec 08             	sub    $0x8,%esp
  106170:	6a 00                	push   $0x0
  106172:	53                   	push   %ebx
  106173:	e8 98 fd ff ff       	call   105f10 <at_set_allocated>
    mem_unlock();
}
  106178:	83 c4 18             	add    $0x18,%esp
  10617b:	5b                   	pop    %ebx
    mem_unlock();
  10617c:	e9 ef fc ff ff       	jmp    105e70 <mem_unlock>
  106181:	66 90                	xchg   %ax,%ax
  106183:	66 90                	xchg   %ax,%ax
  106185:	66 90                	xchg   %ax,%ax
  106187:	66 90                	xchg   %ax,%ax
  106189:	66 90                	xchg   %ax,%ax
  10618b:	66 90                	xchg   %ax,%ax
  10618d:	66 90                	xchg   %ax,%ax
  10618f:	90                   	nop

00106190 <container_init>:
/**
 * Initializes the container data for the root process (the one with index 0).
 * The root process is the one that gets spawned first by the kernel.
 */
void container_init(unsigned int mbi_addr)
{
  106190:	57                   	push   %edi
  106191:	56                   	push   %esi
  106192:	53                   	push   %ebx
    unsigned int real_quota;
    unsigned int nps, idx;

    pmem_init(mbi_addr);
  106193:	83 ec 0c             	sub    $0xc,%esp
  106196:	ff 74 24 1c          	pushl  0x1c(%esp)
  10619a:	e8 81 fd ff ff       	call   105f20 <pmem_init>
    /**
     * Compute the available quota and store it into the variable real_quota.
     * It should be the number of the unallocated pages with the normal permission
     * in the physical memory allocation table.
     */
    nps = get_nps();
  10619f:	e8 ec fc ff ff       	call   105e90 <get_nps>
    idx = 1;
    while (idx < nps) {
  1061a4:	83 c4 10             	add    $0x10,%esp
  1061a7:	83 f8 01             	cmp    $0x1,%eax
  1061aa:	0f 86 ab 00 00 00    	jbe    10625b <container_init+0xcb>
  1061b0:	89 c6                	mov    %eax,%esi
    idx = 1;
  1061b2:	bb 01 00 00 00       	mov    $0x1,%ebx
    real_quota = 0;
  1061b7:	31 ff                	xor    %edi,%edi
  1061b9:	eb 0c                	jmp    1061c7 <container_init+0x37>
  1061bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1061bf:	90                   	nop
        if (at_is_norm(idx) && !at_is_allocated(idx)) {
            real_quota++;
        }
        idx++;
  1061c0:	83 c3 01             	add    $0x1,%ebx
    while (idx < nps) {
  1061c3:	39 de                	cmp    %ebx,%esi
  1061c5:	74 29                	je     1061f0 <container_init+0x60>
        if (at_is_norm(idx) && !at_is_allocated(idx)) {
  1061c7:	83 ec 0c             	sub    $0xc,%esp
  1061ca:	53                   	push   %ebx
  1061cb:	e8 e0 fc ff ff       	call   105eb0 <at_is_norm>
  1061d0:	83 c4 10             	add    $0x10,%esp
  1061d3:	85 c0                	test   %eax,%eax
  1061d5:	74 e9                	je     1061c0 <container_init+0x30>
  1061d7:	83 ec 0c             	sub    $0xc,%esp
  1061da:	53                   	push   %ebx
  1061db:	e8 10 fd ff ff       	call   105ef0 <at_is_allocated>
  1061e0:	83 c4 10             	add    $0x10,%esp
            real_quota++;
  1061e3:	83 f8 01             	cmp    $0x1,%eax
  1061e6:	83 d7 00             	adc    $0x0,%edi
        idx++;
  1061e9:	83 c3 01             	add    $0x1,%ebx
    while (idx < nps) {
  1061ec:	39 de                	cmp    %ebx,%esi
  1061ee:	75 d7                	jne    1061c7 <container_init+0x37>
  1061f0:	89 fb                	mov    %edi,%ebx
    }

    KERN_DEBUG("\nreal quota: %d\n\n", real_quota);
  1061f2:	57                   	push   %edi
  1061f3:	68 70 a8 10 00       	push   $0x10a870
  1061f8:	6a 2c                	push   $0x2c
  1061fa:	68 84 a8 10 00       	push   $0x10a884
  1061ff:	e8 fc d5 ff ff       	call   103800 <debug_normal>

    CONTAINER[0].quota = real_quota;
  106204:	89 1d e0 22 95 00    	mov    %ebx,0x9522e0
    CONTAINER[0].usage = 0;
  10620a:	83 c4 10             	add    $0x10,%esp
  10620d:	bb e0 20 95 00       	mov    $0x9520e0,%ebx
  106212:	c7 05 e4 22 95 00 00 	movl   $0x0,0x9522e4
  106219:	00 00 00 
    CONTAINER[0].parent = 0;
  10621c:	c7 05 e8 22 95 00 00 	movl   $0x0,0x9522e8
  106223:	00 00 00 
    CONTAINER[0].nchildren = 0;
  106226:	c7 05 ec 22 95 00 00 	movl   $0x0,0x9522ec
  10622d:	00 00 00 
    CONTAINER[0].used = 1;
  106230:	c7 05 f0 22 95 00 01 	movl   $0x1,0x9522f0
  106237:	00 00 00 

    for (idx = 0; idx < NUM_IDS; idx++) {
  10623a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        spinlock_init(&container_lks[idx]);
  106240:	83 ec 0c             	sub    $0xc,%esp
  106243:	53                   	push   %ebx
  106244:	83 c3 08             	add    $0x8,%ebx
  106247:	e8 c4 ea ff ff       	call   104d10 <spinlock_init>
    for (idx = 0; idx < NUM_IDS; idx++) {
  10624c:	83 c4 10             	add    $0x10,%esp
  10624f:	81 fb e0 22 95 00    	cmp    $0x9522e0,%ebx
  106255:	75 e9                	jne    106240 <container_init+0xb0>
    }
}
  106257:	5b                   	pop    %ebx
  106258:	5e                   	pop    %esi
  106259:	5f                   	pop    %edi
  10625a:	c3                   	ret    
    while (idx < nps) {
  10625b:	31 db                	xor    %ebx,%ebx
    real_quota = 0;
  10625d:	31 ff                	xor    %edi,%edi
  10625f:	eb 91                	jmp    1061f2 <container_init+0x62>
  106261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10626f:	90                   	nop

00106270 <container_get_parent>:

// Get the id of parent process of process # [id].
unsigned int container_get_parent(unsigned int id)
{
  106270:	8b 44 24 04          	mov    0x4(%esp),%eax
    return CONTAINER[id].parent;
  106274:	8d 04 80             	lea    (%eax,%eax,4),%eax
  106277:	8b 04 85 e8 22 95 00 	mov    0x9522e8(,%eax,4),%eax
}
  10627e:	c3                   	ret    
  10627f:	90                   	nop

00106280 <container_get_nchildren>:

// Get the number of children of process # [id].
unsigned int container_get_nchildren(unsigned int id)
{
  106280:	8b 44 24 04          	mov    0x4(%esp),%eax
    return CONTAINER[id].nchildren;
  106284:	8d 04 80             	lea    (%eax,%eax,4),%eax
  106287:	8b 04 85 ec 22 95 00 	mov    0x9522ec(,%eax,4),%eax
}
  10628e:	c3                   	ret    
  10628f:	90                   	nop

00106290 <container_get_quota>:

// Get the maximum memory quota of process # [id].
unsigned int container_get_quota(unsigned int id)
{
  106290:	8b 44 24 04          	mov    0x4(%esp),%eax
    return CONTAINER[id].quota;
  106294:	8d 04 80             	lea    (%eax,%eax,4),%eax
  106297:	8b 04 85 e0 22 95 00 	mov    0x9522e0(,%eax,4),%eax
}
  10629e:	c3                   	ret    
  10629f:	90                   	nop

001062a0 <container_get_usage>:

// Get the current memory usage of process # [id].
unsigned int container_get_usage(unsigned int id)
{
  1062a0:	8b 44 24 04          	mov    0x4(%esp),%eax
    return CONTAINER[id].usage;
  1062a4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1062a7:	8b 04 85 e4 22 95 00 	mov    0x9522e4(,%eax,4),%eax
}
  1062ae:	c3                   	ret    
  1062af:	90                   	nop

001062b0 <container_can_consume>:

// Determines whether the process # [id] can consume an extra
// [n] pages of memory. If so, returns 1, otherwise, returns 0.
unsigned int container_can_consume(unsigned int id, unsigned int n)
{
  1062b0:	8b 44 24 04          	mov    0x4(%esp),%eax
    return CONTAINER[id].usage + n <= CONTAINER[id].quota;
  1062b4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1062b7:	c1 e0 02             	shl    $0x2,%eax
  1062ba:	8b 90 e4 22 95 00    	mov    0x9522e4(%eax),%edx
  1062c0:	03 54 24 08          	add    0x8(%esp),%edx
  1062c4:	3b 90 e0 22 95 00    	cmp    0x9522e0(%eax),%edx
  1062ca:	0f 96 c0             	setbe  %al
  1062cd:	0f b6 c0             	movzbl %al,%eax
}
  1062d0:	c3                   	ret    
  1062d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1062d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1062df:	90                   	nop

001062e0 <container_split>:
 * You can assume it is safe to allocate [quota] pages
 * (the check is already done outside before calling this function).
 * Returns the container index for the new child process.
 */
unsigned int container_split(unsigned int id, unsigned int quota)
{
  1062e0:	55                   	push   %ebp
  1062e1:	57                   	push   %edi
  1062e2:	56                   	push   %esi
  1062e3:	53                   	push   %ebx
  1062e4:	83 ec 18             	sub    $0x18,%esp
  1062e7:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
  1062eb:	8b 7c 24 30          	mov    0x30(%esp),%edi
    unsigned int child, nc;

    spinlock_acquire(&container_lks[id]);
  1062ef:	8d 2c dd e0 20 95 00 	lea    0x9520e0(,%ebx,8),%ebp

    nc = CONTAINER[id].nchildren;
    child = id * MAX_CHILDREN + 1 + nc;  // container index for the child process
  1062f6:	8d 74 5b 01          	lea    0x1(%ebx,%ebx,2),%esi
    spinlock_acquire(&container_lks[id]);
  1062fa:	55                   	push   %ebp
  1062fb:	e8 a0 ea ff ff       	call   104da0 <spinlock_acquire>
    nc = CONTAINER[id].nchildren;
  106300:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax

    if (NUM_IDS <= child) {
  106303:	83 c4 10             	add    $0x10,%esp
    nc = CONTAINER[id].nchildren;
  106306:	8d 14 85 e0 22 95 00 	lea    0x9522e0(,%eax,4),%edx
    child = id * MAX_CHILDREN + 1 + nc;  // container index for the child process
  10630d:	03 72 0c             	add    0xc(%edx),%esi
    if (NUM_IDS <= child) {
  106310:	83 fe 3f             	cmp    $0x3f,%esi
  106313:	77 53                	ja     106368 <container_split+0x88>
    }

    /**
     * Update the container structure of both parent and child process appropriately.
     */
    CONTAINER[child].used = 1;
  106315:	8d 0c b6             	lea    (%esi,%esi,4),%ecx
    CONTAINER[child].nchildren = 0;

    CONTAINER[id].usage += quota;
    CONTAINER[id].nchildren++;

    spinlock_release(&container_lks[id]);
  106318:	83 ec 0c             	sub    $0xc,%esp
    CONTAINER[child].used = 1;
  10631b:	c1 e1 02             	shl    $0x2,%ecx
    CONTAINER[child].usage = 0;
  10631e:	c7 81 e4 22 95 00 00 	movl   $0x0,0x9522e4(%ecx)
  106325:	00 00 00 
    CONTAINER[child].nchildren = 0;
  106328:	c7 81 ec 22 95 00 00 	movl   $0x0,0x9522ec(%ecx)
  10632f:	00 00 00 
    CONTAINER[id].usage += quota;
  106332:	01 7a 04             	add    %edi,0x4(%edx)
    CONTAINER[id].nchildren++;
  106335:	83 42 0c 01          	addl   $0x1,0xc(%edx)
    spinlock_release(&container_lks[id]);
  106339:	55                   	push   %ebp
    CONTAINER[child].quota = quota;
  10633a:	89 b9 e0 22 95 00    	mov    %edi,0x9522e0(%ecx)
    CONTAINER[child].parent = id;
  106340:	89 99 e8 22 95 00    	mov    %ebx,0x9522e8(%ecx)
    CONTAINER[child].used = 1;
  106346:	c7 81 f0 22 95 00 01 	movl   $0x1,0x9522f0(%ecx)
  10634d:	00 00 00 
    spinlock_release(&container_lks[id]);
  106350:	e8 bb ea ff ff       	call   104e10 <spinlock_release>

    return child;
  106355:	83 c4 10             	add    $0x10,%esp
}
  106358:	89 f0                	mov    %esi,%eax
  10635a:	83 c4 0c             	add    $0xc,%esp
  10635d:	5b                   	pop    %ebx
  10635e:	5e                   	pop    %esi
  10635f:	5f                   	pop    %edi
  106360:	5d                   	pop    %ebp
  106361:	c3                   	ret    
  106362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  106368:	83 c4 0c             	add    $0xc,%esp
        return NUM_IDS;
  10636b:	be 40 00 00 00       	mov    $0x40,%esi
}
  106370:	5b                   	pop    %ebx
  106371:	89 f0                	mov    %esi,%eax
  106373:	5e                   	pop    %esi
  106374:	5f                   	pop    %edi
  106375:	5d                   	pop    %ebp
  106376:	c3                   	ret    
  106377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10637e:	66 90                	xchg   %ax,%ax

00106380 <container_alloc>:
 * Allocates one more page for process # [id], given that this will not exceed the quota.
 * The container structure should be updated accordingly after the allocation.
 * Returns the page index of the allocated page, or 0 in the case of failure.
 */
unsigned int container_alloc(unsigned int id)
{
  106380:	56                   	push   %esi
  106381:	53                   	push   %ebx
  106382:	83 ec 10             	sub    $0x10,%esp
  106385:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    unsigned int page_index = 0;

    spinlock_acquire(&container_lks[id]);
  106389:	8d 34 dd e0 20 95 00 	lea    0x9520e0(,%ebx,8),%esi
  106390:	56                   	push   %esi
  106391:	e8 0a ea ff ff       	call   104da0 <spinlock_acquire>

    if (CONTAINER[id].usage + 1 <= CONTAINER[id].quota) {
  106396:	8d 14 9b             	lea    (%ebx,%ebx,4),%edx
  106399:	83 c4 10             	add    $0x10,%esp
  10639c:	31 db                	xor    %ebx,%ebx
  10639e:	c1 e2 02             	shl    $0x2,%edx
  1063a1:	8b 82 e4 22 95 00    	mov    0x9522e4(%edx),%eax
  1063a7:	3b 82 e0 22 95 00    	cmp    0x9522e0(%edx),%eax
  1063ad:	7c 11                	jl     1063c0 <container_alloc+0x40>
        CONTAINER[id].usage++;
        page_index = palloc();
    }

    spinlock_release(&container_lks[id]);
  1063af:	83 ec 0c             	sub    $0xc,%esp
  1063b2:	56                   	push   %esi
  1063b3:	e8 58 ea ff ff       	call   104e10 <spinlock_release>

    return page_index;
}
  1063b8:	83 c4 14             	add    $0x14,%esp
  1063bb:	89 d8                	mov    %ebx,%eax
  1063bd:	5b                   	pop    %ebx
  1063be:	5e                   	pop    %esi
  1063bf:	c3                   	ret    
        CONTAINER[id].usage++;
  1063c0:	83 c0 01             	add    $0x1,%eax
  1063c3:	89 82 e4 22 95 00    	mov    %eax,0x9522e4(%edx)
        page_index = palloc();
  1063c9:	e8 e2 fc ff ff       	call   1060b0 <palloc>
  1063ce:	89 c3                	mov    %eax,%ebx
  1063d0:	eb dd                	jmp    1063af <container_alloc+0x2f>
  1063d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1063d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001063e0 <container_free>:

// Frees the physical page and reduces the usage by 1.
void container_free(unsigned int id, unsigned int page_index)
{
  1063e0:	57                   	push   %edi
  1063e1:	56                   	push   %esi
  1063e2:	53                   	push   %ebx
  1063e3:	8b 74 24 10          	mov    0x10(%esp),%esi
  1063e7:	8b 7c 24 14          	mov    0x14(%esp),%edi
    spinlock_acquire(&container_lks[id]);
  1063eb:	8d 1c f5 e0 20 95 00 	lea    0x9520e0(,%esi,8),%ebx
  1063f2:	83 ec 0c             	sub    $0xc,%esp
  1063f5:	53                   	push   %ebx
  1063f6:	e8 a5 e9 ff ff       	call   104da0 <spinlock_acquire>

    if (at_is_allocated(page_index)) {
  1063fb:	89 3c 24             	mov    %edi,(%esp)
  1063fe:	e8 ed fa ff ff       	call   105ef0 <at_is_allocated>
  106403:	83 c4 10             	add    $0x10,%esp
  106406:	85 c0                	test   %eax,%eax
  106408:	75 16                	jne    106420 <container_free+0x40>
        if (CONTAINER[id].usage > 0) {
            CONTAINER[id].usage--;
        }
    }

    spinlock_release(&container_lks[id]);
  10640a:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
  10640e:	5b                   	pop    %ebx
  10640f:	5e                   	pop    %esi
  106410:	5f                   	pop    %edi
    spinlock_release(&container_lks[id]);
  106411:	e9 fa e9 ff ff       	jmp    104e10 <spinlock_release>
  106416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10641d:	8d 76 00             	lea    0x0(%esi),%esi
        pfree(page_index);
  106420:	83 ec 0c             	sub    $0xc,%esp
  106423:	57                   	push   %edi
  106424:	e8 37 fd ff ff       	call   106160 <pfree>
        if (CONTAINER[id].usage > 0) {
  106429:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  10642c:	83 c4 10             	add    $0x10,%esp
  10642f:	8d 14 85 e0 22 95 00 	lea    0x9522e0(,%eax,4),%edx
  106436:	8b 42 04             	mov    0x4(%edx),%eax
  106439:	85 c0                	test   %eax,%eax
  10643b:	7e cd                	jle    10640a <container_free+0x2a>
            CONTAINER[id].usage--;
  10643d:	83 e8 01             	sub    $0x1,%eax
  106440:	89 42 04             	mov    %eax,0x4(%edx)
    spinlock_release(&container_lks[id]);
  106443:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
  106447:	5b                   	pop    %ebx
  106448:	5e                   	pop    %esi
  106449:	5f                   	pop    %edi
    spinlock_release(&container_lks[id]);
  10644a:	e9 c1 e9 ff ff       	jmp    104e10 <spinlock_release>
  10644f:	90                   	nop

00106450 <set_pdir_base>:
unsigned int IDPTbl[1024][1024] gcc_aligned(PAGESIZE);

// Sets the CR3 register with the start address of the page structure for process # [index].
void set_pdir_base(unsigned int index)
{
    set_cr3(PDirPool[index]);
  106450:	8b 44 24 04          	mov    0x4(%esp),%eax
  106454:	c1 e0 0c             	shl    $0xc,%eax
  106457:	05 00 e0 dd 00       	add    $0xdde000,%eax
  10645c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106460:	e9 cb aa ff ff       	jmp    100f30 <set_cr3>
  106465:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10646c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106470 <get_pdir_entry>:

// Returns the page directory entry # [pde_index] of the process # [proc_index].
// This can be used to test whether the page directory entry is mapped.
unsigned int get_pdir_entry(unsigned int proc_index, unsigned int pde_index)
{
    return (unsigned int) PDirPool[proc_index][pde_index];
  106470:	8b 44 24 04          	mov    0x4(%esp),%eax
  106474:	c1 e0 0a             	shl    $0xa,%eax
  106477:	03 44 24 08          	add    0x8(%esp),%eax
  10647b:	8b 04 85 00 e0 dd 00 	mov    0xdde000(,%eax,4),%eax
}
  106482:	c3                   	ret    
  106483:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10648a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106490 <set_pdir_entry>:
// page # [page_index].
// You should also set the permissions PTE_P, PTE_W, and PTE_U.
void set_pdir_entry(unsigned int proc_index, unsigned int pde_index,
                    unsigned int page_index)
{
    unsigned int addr = page_index << 12;
  106490:	8b 54 24 0c          	mov    0xc(%esp),%edx
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  106494:	8b 44 24 04          	mov    0x4(%esp),%eax
    unsigned int addr = page_index << 12;
  106498:	c1 e2 0c             	shl    $0xc,%edx
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  10649b:	c1 e0 0a             	shl    $0xa,%eax
  10649e:	03 44 24 08          	add    0x8(%esp),%eax
  1064a2:	83 ca 07             	or     $0x7,%edx
  1064a5:	89 14 85 00 e0 dd 00 	mov    %edx,0xdde000(,%eax,4)
}
  1064ac:	c3                   	ret    
  1064ad:	8d 76 00             	lea    0x0(%esi),%esi

001064b0 <set_pdir_entry_identity>:
// You should also set the permissions PTE_P, PTE_W, and PTE_U.
// This will be used to map a page directory entry to an identity page table.
void set_pdir_entry_identity(unsigned int proc_index, unsigned int pde_index)
{
    unsigned int addr = (unsigned int) IDPTbl[pde_index];
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  1064b0:	8b 54 24 04          	mov    0x4(%esp),%edx
{
  1064b4:	8b 44 24 08          	mov    0x8(%esp),%eax
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  1064b8:	c1 e2 0a             	shl    $0xa,%edx
  1064bb:	01 c2                	add    %eax,%edx
    unsigned int addr = (unsigned int) IDPTbl[pde_index];
  1064bd:	c1 e0 0c             	shl    $0xc,%eax
  1064c0:	05 00 e0 9d 00       	add    $0x9de000,%eax
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  1064c5:	83 c8 07             	or     $0x7,%eax
  1064c8:	89 04 95 00 e0 dd 00 	mov    %eax,0xdde000(,%edx,4)
}
  1064cf:	c3                   	ret    

001064d0 <rmv_pdir_entry>:

// Removes the specified page directory entry (sets the page directory entry to 0).
// Don't forget to cast the value to (unsigned int *).
void rmv_pdir_entry(unsigned int proc_index, unsigned int pde_index)
{
    PDirPool[proc_index][pde_index] = (unsigned int *) 0;
  1064d0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1064d4:	c1 e0 0a             	shl    $0xa,%eax
  1064d7:	03 44 24 08          	add    0x8(%esp),%eax
  1064db:	c7 04 85 00 e0 dd 00 	movl   $0x0,0xdde000(,%eax,4)
  1064e2:	00 00 00 00 
}
  1064e6:	c3                   	ret    
  1064e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1064ee:	66 90                	xchg   %ax,%ax

001064f0 <get_ptbl_entry>:
// Returns the specified page table entry.
// Do not forget that the permission info is also stored in the page directory entries.
unsigned int get_ptbl_entry(unsigned int proc_index, unsigned int pde_index,
                            unsigned int pte_index)
{
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  1064f0:	8b 44 24 04          	mov    0x4(%esp),%eax
    return pt[pte_index];
  1064f4:	8b 54 24 0c          	mov    0xc(%esp),%edx
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  1064f8:	c1 e0 0a             	shl    $0xa,%eax
  1064fb:	03 44 24 08          	add    0x8(%esp),%eax
  1064ff:	8b 04 85 00 e0 dd 00 	mov    0xdde000(,%eax,4),%eax
  106506:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return pt[pte_index];
  10650b:	8b 04 90             	mov    (%eax,%edx,4),%eax
}
  10650e:	c3                   	ret    
  10650f:	90                   	nop

00106510 <set_ptbl_entry>:
// You should also set the given permission.
void set_ptbl_entry(unsigned int proc_index, unsigned int pde_index,
                    unsigned int pte_index, unsigned int page_index,
                    unsigned int perm)
{
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106510:	8b 44 24 04          	mov    0x4(%esp),%eax
    pt[pte_index] = (page_index << 12) | perm;
  106514:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106518:	c1 e0 0a             	shl    $0xa,%eax
  10651b:	03 44 24 08          	add    0x8(%esp),%eax
  10651f:	8b 14 85 00 e0 dd 00 	mov    0xdde000(,%eax,4),%edx
    pt[pte_index] = (page_index << 12) | perm;
  106526:	8b 44 24 10          	mov    0x10(%esp),%eax
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  10652a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    pt[pte_index] = (page_index << 12) | perm;
  106530:	c1 e0 0c             	shl    $0xc,%eax
  106533:	0b 44 24 14          	or     0x14(%esp),%eax
  106537:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
}
  10653a:	c3                   	ret    
  10653b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10653f:	90                   	nop

00106540 <set_ptbl_entry_identity>:

// Sets up the specified page table entry in IDPTbl as the identity map.
// You should also set the given permission.
void set_ptbl_entry_identity(unsigned int pde_index, unsigned int pte_index,
                             unsigned int perm)
{
  106540:	8b 54 24 04          	mov    0x4(%esp),%edx
  106544:	8b 44 24 08          	mov    0x8(%esp),%eax
    unsigned int addr = (pde_index << 22) | (pte_index << 12);
    IDPTbl[pde_index][pte_index] = addr | perm;
  106548:	89 d1                	mov    %edx,%ecx
    unsigned int addr = (pde_index << 22) | (pte_index << 12);
  10654a:	c1 e2 16             	shl    $0x16,%edx
    IDPTbl[pde_index][pte_index] = addr | perm;
  10654d:	c1 e1 0a             	shl    $0xa,%ecx
  106550:	01 c1                	add    %eax,%ecx
    unsigned int addr = (pde_index << 22) | (pte_index << 12);
  106552:	c1 e0 0c             	shl    $0xc,%eax
    IDPTbl[pde_index][pte_index] = addr | perm;
  106555:	0b 44 24 0c          	or     0xc(%esp),%eax
  106559:	09 d0                	or     %edx,%eax
  10655b:	89 04 8d 00 e0 9d 00 	mov    %eax,0x9de000(,%ecx,4)
}
  106562:	c3                   	ret    
  106563:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10656a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106570 <rmv_ptbl_entry>:

// Sets the specified page table entry to 0.
void rmv_ptbl_entry(unsigned int proc_index, unsigned int pde_index,
                    unsigned int pte_index)
{
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106570:	8b 44 24 04          	mov    0x4(%esp),%eax
    pt[pte_index] = 0;
  106574:	8b 54 24 0c          	mov    0xc(%esp),%edx
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106578:	c1 e0 0a             	shl    $0xa,%eax
  10657b:	03 44 24 08          	add    0x8(%esp),%eax
  10657f:	8b 04 85 00 e0 dd 00 	mov    0xdde000(,%eax,4),%eax
  106586:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    pt[pte_index] = 0;
  10658b:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
}
  106592:	c3                   	ret    
  106593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10659a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001065a0 <copy_ptbl_entry>:
// Copy PTE entry assuming page directory exists.
// If original PTE entry is not zero, set PTE_COW permissions.
// Otherwise, delete new entry as well.
void copy_ptbl_entry(unsigned int from, unsigned int to, unsigned int pde_index,
                     unsigned int pte_index)
{
  1065a0:	56                   	push   %esi
  1065a1:	53                   	push   %ebx
    return pt[pte_index];
  1065a2:	8b 44 24 18          	mov    0x18(%esp),%eax
{
  1065a6:	8b 54 24 14          	mov    0x14(%esp),%edx
    return pt[pte_index];
  1065aa:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  1065ae:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  1065b5:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1065b9:	c1 e1 0a             	shl    $0xa,%ecx
  1065bc:	c1 e0 0a             	shl    $0xa,%eax
  1065bf:	01 d1                	add    %edx,%ecx
  1065c1:	01 d0                	add    %edx,%eax
  1065c3:	8b 14 8d 00 e0 dd 00 	mov    0xdde000(,%ecx,4),%edx
  1065ca:	8b 04 85 00 e0 dd 00 	mov    0xdde000(,%eax,4),%eax
  1065d1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  1065d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1065dc:	01 f2                	add    %esi,%edx
    return pt[pte_index];
  1065de:	01 f0                	add    %esi,%eax
  1065e0:	8b 18                	mov    (%eax),%ebx
    unsigned int pi;
    unsigned int from_pte = get_ptbl_entry(from, pde_index, pte_index);

    if (from_pte != 0) {
  1065e2:	85 db                	test   %ebx,%ebx
  1065e4:	74 1a                	je     106600 <copy_ptbl_entry+0x60>
    pt[pte_index] = (page_index << 12) | perm;
  1065e6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  1065ec:	83 cb 07             	or     $0x7,%ebx
  1065ef:	89 1a                	mov    %ebx,(%edx)
  1065f1:	89 18                	mov    %ebx,(%eax)
        set_ptbl_entry(to, pde_index, pte_index, pi, PT_PERM_PTU);
        set_ptbl_entry(from, pde_index, pte_index, pi, PT_PERM_PTU);
    } else {
        rmv_ptbl_entry(to, pde_index, pte_index);
    }
}
  1065f3:	5b                   	pop    %ebx
  1065f4:	5e                   	pop    %esi
  1065f5:	c3                   	ret    
  1065f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1065fd:	8d 76 00             	lea    0x0(%esi),%esi
    pt[pte_index] = 0;
  106600:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
}
  106606:	5b                   	pop    %ebx
  106607:	5e                   	pop    %esi
  106608:	c3                   	ret    
  106609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106610 <copy_pdir_entry>:

// Copy page table corresponding to pde_index.
// If it doesn't exist in 'from', remove entry in 'to' also.
void copy_pdir_entry(unsigned int from, unsigned int to, unsigned int pde_index)
{
  106610:	55                   	push   %ebp
  106611:	57                   	push   %edi
  106612:	56                   	push   %esi
  106613:	53                   	push   %ebx
  106614:	83 ec 0c             	sub    $0xc,%esp
    unsigned int pte, pi;
    unsigned int from_pde = (unsigned int) PDirPool[from][pde_index];
  106617:	8b 74 24 20          	mov    0x20(%esp),%esi
{
  10661b:	8b 6c 24 28          	mov    0x28(%esp),%ebp
  10661f:	8b 7c 24 24          	mov    0x24(%esp),%edi
    unsigned int from_pde = (unsigned int) PDirPool[from][pde_index];
  106623:	c1 e6 0a             	shl    $0xa,%esi
  106626:	01 ee                	add    %ebp,%esi
    unsigned int to_pde = (unsigned int) PDirPool[to][pde_index];
    unsigned int from_pi = from_pde >> 12;
    unsigned int to_pi = to_pde >> 12;

    if (from_pde == 0) {
  106628:	8b 04 b5 00 e0 dd 00 	mov    0xdde000(,%esi,4),%eax
  10662f:	85 c0                	test   %eax,%eax
  106631:	74 6f                	je     1066a2 <copy_pdir_entry+0x92>
        rmv_pdir_entry(to, pde_index);
    } else {
        pi = container_alloc(to);
  106633:	83 ec 0c             	sub    $0xc,%esp
  106636:	57                   	push   %edi
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  106637:	c1 e7 0a             	shl    $0xa,%edi
        pi = container_alloc(to);
  10663a:	e8 41 fd ff ff       	call   106380 <container_alloc>
    unsigned int addr = page_index << 12;
  10663f:	83 c4 10             	add    $0x10,%esp
  106642:	c1 e0 0c             	shl    $0xc,%eax
  106645:	89 c3                	mov    %eax,%ebx
    PDirPool[proc_index][pde_index] = (unsigned int *) (addr | PT_PERM_PTU);
  106647:	8d 04 2f             	lea    (%edi,%ebp,1),%eax
  10664a:	89 da                	mov    %ebx,%edx
  10664c:	83 ca 07             	or     $0x7,%edx
  10664f:	89 14 85 00 e0 dd 00 	mov    %edx,0xdde000(,%eax,4)
    unsigned int *pt = (unsigned int *) ADDR_MASK(PDirPool[proc_index][pde_index]);
  106656:	8b 14 b5 00 e0 dd 00 	mov    0xdde000(,%esi,4),%edx
  10665d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  106663:	8d b2 00 10 00 00    	lea    0x1000(%edx),%esi
  106669:	29 d3                	sub    %edx,%ebx
  10666b:	eb 17                	jmp    106684 <copy_pdir_entry+0x74>
  10666d:	8d 76 00             	lea    0x0(%esi),%esi
    pt[pte_index] = (page_index << 12) | perm;
  106670:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  106675:	83 c2 04             	add    $0x4,%edx
  106678:	83 c8 07             	or     $0x7,%eax
  10667b:	89 01                	mov    %eax,(%ecx)
  10667d:	89 42 fc             	mov    %eax,-0x4(%edx)
        set_pdir_entry(to, pde_index, pi);

        for (pte = 0; pte < 1024; pte++) {
  106680:	39 d6                	cmp    %edx,%esi
  106682:	74 16                	je     10669a <copy_pdir_entry+0x8a>
    return pt[pte_index];
  106684:	8b 02                	mov    (%edx),%eax
    if (from_pte != 0) {
  106686:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
  106689:	85 c0                	test   %eax,%eax
  10668b:	75 e3                	jne    106670 <copy_pdir_entry+0x60>
    pt[pte_index] = 0;
  10668d:	83 c2 04             	add    $0x4,%edx
  106690:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
        for (pte = 0; pte < 1024; pte++) {
  106696:	39 d6                	cmp    %edx,%esi
  106698:	75 ea                	jne    106684 <copy_pdir_entry+0x74>
            copy_ptbl_entry(from, to, pde_index, pte);
        }
    }
}
  10669a:	83 c4 0c             	add    $0xc,%esp
  10669d:	5b                   	pop    %ebx
  10669e:	5e                   	pop    %esi
  10669f:	5f                   	pop    %edi
  1066a0:	5d                   	pop    %ebp
  1066a1:	c3                   	ret    
    PDirPool[proc_index][pde_index] = (unsigned int *) 0;
  1066a2:	c1 e7 0a             	shl    $0xa,%edi
  1066a5:	8d 04 2f             	lea    (%edi,%ebp,1),%eax
  1066a8:	c7 04 85 00 e0 dd 00 	movl   $0x0,0xdde000(,%eax,4)
  1066af:	00 00 00 00 
}
  1066b3:	83 c4 0c             	add    $0xc,%esp
  1066b6:	5b                   	pop    %ebx
  1066b7:	5e                   	pop    %esi
  1066b8:	5f                   	pop    %edi
  1066b9:	5d                   	pop    %ebp
  1066ba:	c3                   	ret    
  1066bb:	66 90                	xchg   %ax,%ax
  1066bd:	66 90                	xchg   %ax,%ax
  1066bf:	90                   	nop

001066c0 <get_ptbl_entry_by_va>:
 * Returns the page table entry corresponding to the virtual address,
 * according to the page structure of process # [proc_index].
 * Returns 0 if the mapping does not exist.
 */
unsigned int get_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  1066c0:	57                   	push   %edi
  1066c1:	56                   	push   %esi
  1066c2:	53                   	push   %ebx
  1066c3:	8b 5c 24 14          	mov    0x14(%esp),%ebx
  1066c7:	8b 74 24 10          	mov    0x10(%esp),%esi
    unsigned int pde_index = PDE_ADDR(vaddr);
  1066cb:	89 df                	mov    %ebx,%edi
    if (get_pdir_entry(proc_index, pde_index) != 0) {
  1066cd:	83 ec 08             	sub    $0x8,%esp
    unsigned int pde_index = PDE_ADDR(vaddr);
  1066d0:	c1 ef 16             	shr    $0x16,%edi
    if (get_pdir_entry(proc_index, pde_index) != 0) {
  1066d3:	57                   	push   %edi
  1066d4:	56                   	push   %esi
  1066d5:	e8 96 fd ff ff       	call   106470 <get_pdir_entry>
  1066da:	83 c4 10             	add    $0x10,%esp
  1066dd:	85 c0                	test   %eax,%eax
  1066df:	75 07                	jne    1066e8 <get_ptbl_entry_by_va+0x28>
        return get_ptbl_entry(proc_index, pde_index, PTE_ADDR(vaddr));
    } else {
        return 0;
    }
}
  1066e1:	5b                   	pop    %ebx
  1066e2:	5e                   	pop    %esi
  1066e3:	5f                   	pop    %edi
  1066e4:	c3                   	ret    
  1066e5:	8d 76 00             	lea    0x0(%esi),%esi
        return get_ptbl_entry(proc_index, pde_index, PTE_ADDR(vaddr));
  1066e8:	c1 eb 0c             	shr    $0xc,%ebx
  1066eb:	83 ec 04             	sub    $0x4,%esp
  1066ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  1066f4:	53                   	push   %ebx
  1066f5:	57                   	push   %edi
  1066f6:	56                   	push   %esi
  1066f7:	e8 f4 fd ff ff       	call   1064f0 <get_ptbl_entry>
  1066fc:	83 c4 10             	add    $0x10,%esp
}
  1066ff:	5b                   	pop    %ebx
  106700:	5e                   	pop    %esi
  106701:	5f                   	pop    %edi
  106702:	c3                   	ret    
  106703:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10670a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106710 <get_pdir_entry_by_va>:

// Returns the page directory entry corresponding to the given virtual address.
unsigned int get_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
    return get_pdir_entry(proc_index, PDE_ADDR(vaddr));
  106710:	c1 6c 24 08 16       	shrl   $0x16,0x8(%esp)
  106715:	e9 56 fd ff ff       	jmp    106470 <get_pdir_entry>
  10671a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106720 <rmv_ptbl_entry_by_va>:
}

// Removes the page table entry for the given virtual address.
void rmv_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  106720:	57                   	push   %edi
  106721:	56                   	push   %esi
  106722:	53                   	push   %ebx
  106723:	8b 5c 24 14          	mov    0x14(%esp),%ebx
  106727:	8b 74 24 10          	mov    0x10(%esp),%esi
    unsigned int pde_index = PDE_ADDR(vaddr);
  10672b:	89 df                	mov    %ebx,%edi
    if (get_pdir_entry(proc_index, pde_index) != 0) {
  10672d:	83 ec 08             	sub    $0x8,%esp
    unsigned int pde_index = PDE_ADDR(vaddr);
  106730:	c1 ef 16             	shr    $0x16,%edi
    if (get_pdir_entry(proc_index, pde_index) != 0) {
  106733:	57                   	push   %edi
  106734:	56                   	push   %esi
  106735:	e8 36 fd ff ff       	call   106470 <get_pdir_entry>
  10673a:	83 c4 10             	add    $0x10,%esp
  10673d:	85 c0                	test   %eax,%eax
  10673f:	75 07                	jne    106748 <rmv_ptbl_entry_by_va+0x28>
        rmv_ptbl_entry(proc_index, pde_index, PTE_ADDR(vaddr));
    }
}
  106741:	5b                   	pop    %ebx
  106742:	5e                   	pop    %esi
  106743:	5f                   	pop    %edi
  106744:	c3                   	ret    
  106745:	8d 76 00             	lea    0x0(%esi),%esi
        rmv_ptbl_entry(proc_index, pde_index, PTE_ADDR(vaddr));
  106748:	c1 eb 0c             	shr    $0xc,%ebx
  10674b:	83 ec 04             	sub    $0x4,%esp
  10674e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  106754:	53                   	push   %ebx
  106755:	57                   	push   %edi
  106756:	56                   	push   %esi
  106757:	e8 14 fe ff ff       	call   106570 <rmv_ptbl_entry>
  10675c:	83 c4 10             	add    $0x10,%esp
}
  10675f:	5b                   	pop    %ebx
  106760:	5e                   	pop    %esi
  106761:	5f                   	pop    %edi
  106762:	c3                   	ret    
  106763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10676a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106770 <rmv_pdir_entry_by_va>:

// Removes the page directory entry for the given virtual address.
void rmv_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
    rmv_pdir_entry(proc_index, PDE_ADDR(vaddr));
  106770:	c1 6c 24 08 16       	shrl   $0x16,0x8(%esp)
  106775:	e9 56 fd ff ff       	jmp    1064d0 <rmv_pdir_entry>
  10677a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106780 <set_ptbl_entry_by_va>:

// Maps the virtual address [vaddr] to the physical page # [page_index] with permission [perm].
// You do not need to worry about the page directory entry. just map the page table entry.
void set_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr,
                          unsigned int page_index, unsigned int perm)
{
  106780:	83 ec 18             	sub    $0x18,%esp
  106783:	8b 44 24 20          	mov    0x20(%esp),%eax
    set_ptbl_entry(proc_index, PDE_ADDR(vaddr), PTE_ADDR(vaddr), page_index, perm);
  106787:	ff 74 24 28          	pushl  0x28(%esp)
  10678b:	ff 74 24 28          	pushl  0x28(%esp)
  10678f:	89 c2                	mov    %eax,%edx
  106791:	c1 e8 16             	shr    $0x16,%eax
  106794:	c1 ea 0c             	shr    $0xc,%edx
  106797:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  10679d:	52                   	push   %edx
  10679e:	50                   	push   %eax
  10679f:	ff 74 24 2c          	pushl  0x2c(%esp)
  1067a3:	e8 68 fd ff ff       	call   106510 <set_ptbl_entry>
}
  1067a8:	83 c4 2c             	add    $0x2c,%esp
  1067ab:	c3                   	ret    
  1067ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001067b0 <set_pdir_entry_by_va>:

// Registers the mapping from [vaddr] to physical page # [page_index] in the page directory.
void set_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr,
                          unsigned int page_index)
{
    set_pdir_entry(proc_index, PDE_ADDR(vaddr), page_index);
  1067b0:	c1 6c 24 08 16       	shrl   $0x16,0x8(%esp)
  1067b5:	e9 d6 fc ff ff       	jmp    106490 <set_pdir_entry>
  1067ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001067c0 <idptbl_init>:

// Initializes the identity page table.
// The permission for the kernel memory should be PTE_P, PTE_W, and PTE_G,
// While the permission for the rest should be PTE_P and PTE_W.
void idptbl_init(unsigned int mbi_addr)
{
  1067c0:	57                   	push   %edi
    unsigned int pde_index, pte_index, perm;
    container_init(mbi_addr);

    // Set up IDPTbl
    for (pde_index = 0; pde_index < 1024; pde_index++) {
  1067c1:	31 ff                	xor    %edi,%edi
{
  1067c3:	56                   	push   %esi
  1067c4:	53                   	push   %ebx
    container_init(mbi_addr);
  1067c5:	83 ec 0c             	sub    $0xc,%esp
  1067c8:	ff 74 24 1c          	pushl  0x1c(%esp)
  1067cc:	e8 bf f9 ff ff       	call   106190 <container_init>
  1067d1:	83 c4 10             	add    $0x10,%esp
        if ((pde_index < VM_USERLO_PDE) || (VM_USERHI_PDE <= pde_index)) {
  1067d4:	8d 87 00 ff ff ff    	lea    -0x100(%edi),%eax
            // kernel mapping
            perm = PTE_P | PTE_W | PTE_G;
        } else {
            // normal memory
            perm = PTE_P | PTE_W;
  1067da:	3d c0 02 00 00       	cmp    $0x2c0,%eax
  1067df:	19 f6                	sbb    %esi,%esi
        }

        for (pte_index = 0; pte_index < 1024; pte_index++) {
  1067e1:	31 db                	xor    %ebx,%ebx
            perm = PTE_P | PTE_W;
  1067e3:	81 e6 00 ff ff ff    	and    $0xffffff00,%esi
  1067e9:	81 c6 03 01 00 00    	add    $0x103,%esi
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  1067ef:	90                   	nop
            set_ptbl_entry_identity(pde_index, pte_index, perm);
  1067f0:	83 ec 04             	sub    $0x4,%esp
  1067f3:	56                   	push   %esi
  1067f4:	53                   	push   %ebx
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  1067f5:	83 c3 01             	add    $0x1,%ebx
            set_ptbl_entry_identity(pde_index, pte_index, perm);
  1067f8:	57                   	push   %edi
  1067f9:	e8 42 fd ff ff       	call   106540 <set_ptbl_entry_identity>
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  1067fe:	83 c4 10             	add    $0x10,%esp
  106801:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  106807:	75 e7                	jne    1067f0 <idptbl_init+0x30>
    for (pde_index = 0; pde_index < 1024; pde_index++) {
  106809:	83 c7 01             	add    $0x1,%edi
  10680c:	81 ff 00 04 00 00    	cmp    $0x400,%edi
  106812:	75 c0                	jne    1067d4 <idptbl_init+0x14>
        }
    }
}
  106814:	5b                   	pop    %ebx
  106815:	5e                   	pop    %esi
  106816:	5f                   	pop    %edi
  106817:	c3                   	ret    
  106818:	66 90                	xchg   %ax,%ax
  10681a:	66 90                	xchg   %ax,%ax
  10681c:	66 90                	xchg   %ax,%ax
  10681e:	66 90                	xchg   %ax,%ax

00106820 <pdir_init>:
 * For each process from id 0 to NUM_IDS - 1,
 * set up the page directory entries so that the kernel portion of the map is
 * the identity map, and the rest of the page directories are unmapped.
 */
void pdir_init(unsigned int mbi_addr)
{
  106820:	56                   	push   %esi
    unsigned int proc_index, pde_index;
    idptbl_init(mbi_addr);

    for (proc_index = 0; proc_index < NUM_IDS; proc_index++) {
  106821:	31 f6                	xor    %esi,%esi
{
  106823:	53                   	push   %ebx
  106824:	83 ec 10             	sub    $0x10,%esp
    idptbl_init(mbi_addr);
  106827:	ff 74 24 1c          	pushl  0x1c(%esp)
  10682b:	e8 90 ff ff ff       	call   1067c0 <idptbl_init>
  106830:	83 c4 10             	add    $0x10,%esp
        for (pde_index = 0; pde_index < 1024; pde_index++) {
  106833:	31 c0                	xor    %eax,%eax
  106835:	8d 76 00             	lea    0x0(%esi),%esi
            if ((pde_index < VM_USERLO_PDE) || (VM_USERHI_PDE <= pde_index)) {
  106838:	8d 90 00 ff ff ff    	lea    -0x100(%eax),%edx
  10683e:	8d 58 01             	lea    0x1(%eax),%ebx
  106841:	81 fa bf 02 00 00    	cmp    $0x2bf,%edx
  106847:	77 11                	ja     10685a <pdir_init+0x3a>
                set_pdir_entry_identity(proc_index, pde_index);
            } else {
                rmv_pdir_entry(proc_index, pde_index);
  106849:	83 ec 08             	sub    $0x8,%esp
  10684c:	50                   	push   %eax
  10684d:	56                   	push   %esi
  10684e:	e8 7d fc ff ff       	call   1064d0 <rmv_pdir_entry>
  106853:	83 c4 10             	add    $0x10,%esp
        for (pde_index = 0; pde_index < 1024; pde_index++) {
  106856:	89 d8                	mov    %ebx,%eax
  106858:	eb de                	jmp    106838 <pdir_init+0x18>
                set_pdir_entry_identity(proc_index, pde_index);
  10685a:	83 ec 08             	sub    $0x8,%esp
  10685d:	50                   	push   %eax
  10685e:	56                   	push   %esi
  10685f:	e8 4c fc ff ff       	call   1064b0 <set_pdir_entry_identity>
        for (pde_index = 0; pde_index < 1024; pde_index++) {
  106864:	83 c4 10             	add    $0x10,%esp
  106867:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  10686d:	75 e7                	jne    106856 <pdir_init+0x36>
    for (proc_index = 0; proc_index < NUM_IDS; proc_index++) {
  10686f:	83 c6 01             	add    $0x1,%esi
  106872:	83 fe 40             	cmp    $0x40,%esi
  106875:	75 bc                	jne    106833 <pdir_init+0x13>
            }
        }
    }
}
  106877:	83 c4 04             	add    $0x4,%esp
  10687a:	5b                   	pop    %ebx
  10687b:	5e                   	pop    %esi
  10687c:	c3                   	ret    
  10687d:	8d 76 00             	lea    0x0(%esi),%esi

00106880 <alloc_ptbl>:
 * and clears (set to 0) all page table entries for this newly mapped page table.
 * It returns the page index of the newly allocated physical page.
 * In the case when there's no physical page available, it returns 0.
 */
unsigned int alloc_ptbl(unsigned int proc_index, unsigned int vaddr)
{
  106880:	55                   	push   %ebp
  106881:	57                   	push   %edi
  106882:	56                   	push   %esi
  106883:	53                   	push   %ebx
  106884:	83 ec 18             	sub    $0x18,%esp
  106887:	8b 74 24 2c          	mov    0x2c(%esp),%esi
    unsigned int page_index = container_alloc(proc_index);
  10688b:	56                   	push   %esi
  10688c:	e8 ef fa ff ff       	call   106380 <container_alloc>
    unsigned int pde_index = PDE_ADDR(vaddr);
    unsigned int pte_index;

    if (page_index == 0) {
  106891:	83 c4 10             	add    $0x10,%esp
    unsigned int page_index = container_alloc(proc_index);
  106894:	89 c5                	mov    %eax,%ebp
    if (page_index == 0) {
  106896:	85 c0                	test   %eax,%eax
  106898:	75 0a                	jne    1068a4 <alloc_ptbl+0x24>
            rmv_ptbl_entry(proc_index, pde_index, pte_index);
        }

        return page_index;
    }
}
  10689a:	83 c4 0c             	add    $0xc,%esp
  10689d:	89 e8                	mov    %ebp,%eax
  10689f:	5b                   	pop    %ebx
  1068a0:	5e                   	pop    %esi
  1068a1:	5f                   	pop    %edi
  1068a2:	5d                   	pop    %ebp
  1068a3:	c3                   	ret    
        set_pdir_entry_by_va(proc_index, vaddr, page_index);
  1068a4:	83 ec 04             	sub    $0x4,%esp
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  1068a7:	31 db                	xor    %ebx,%ebx
        set_pdir_entry_by_va(proc_index, vaddr, page_index);
  1068a9:	50                   	push   %eax
  1068aa:	ff 74 24 2c          	pushl  0x2c(%esp)
  1068ae:	56                   	push   %esi
  1068af:	e8 fc fe ff ff       	call   1067b0 <set_pdir_entry_by_va>
    unsigned int pde_index = PDE_ADDR(vaddr);
  1068b4:	8b 7c 24 34          	mov    0x34(%esp),%edi
  1068b8:	83 c4 10             	add    $0x10,%esp
  1068bb:	c1 ef 16             	shr    $0x16,%edi
  1068be:	66 90                	xchg   %ax,%ax
            rmv_ptbl_entry(proc_index, pde_index, pte_index);
  1068c0:	83 ec 04             	sub    $0x4,%esp
  1068c3:	53                   	push   %ebx
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  1068c4:	83 c3 01             	add    $0x1,%ebx
            rmv_ptbl_entry(proc_index, pde_index, pte_index);
  1068c7:	57                   	push   %edi
  1068c8:	56                   	push   %esi
  1068c9:	e8 a2 fc ff ff       	call   106570 <rmv_ptbl_entry>
        for (pte_index = 0; pte_index < 1024; pte_index++) {
  1068ce:	83 c4 10             	add    $0x10,%esp
  1068d1:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  1068d7:	75 e7                	jne    1068c0 <alloc_ptbl+0x40>
}
  1068d9:	83 c4 0c             	add    $0xc,%esp
  1068dc:	89 e8                	mov    %ebp,%eax
  1068de:	5b                   	pop    %ebx
  1068df:	5e                   	pop    %esi
  1068e0:	5f                   	pop    %edi
  1068e1:	5d                   	pop    %ebp
  1068e2:	c3                   	ret    
  1068e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1068ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001068f0 <free_ptbl>:

// Reverse operation of alloc_ptbl.
// Removes corresponding the page directory entry,
// and frees the page for the page table entries (with container_free).
void free_ptbl(unsigned int proc_index, unsigned int vaddr)
{
  1068f0:	57                   	push   %edi
  1068f1:	56                   	push   %esi
  1068f2:	53                   	push   %ebx
  1068f3:	8b 7c 24 10          	mov    0x10(%esp),%edi
  1068f7:	8b 74 24 14          	mov    0x14(%esp),%esi
    unsigned int page_index = get_pdir_entry_by_va(proc_index, vaddr) >> 12;
  1068fb:	83 ec 08             	sub    $0x8,%esp
  1068fe:	56                   	push   %esi

    rmv_pdir_entry(proc_index, PDE_ADDR(vaddr));
  1068ff:	c1 ee 16             	shr    $0x16,%esi
    unsigned int page_index = get_pdir_entry_by_va(proc_index, vaddr) >> 12;
  106902:	57                   	push   %edi
  106903:	e8 08 fe ff ff       	call   106710 <get_pdir_entry_by_va>
  106908:	89 c3                	mov    %eax,%ebx
    rmv_pdir_entry(proc_index, PDE_ADDR(vaddr));
  10690a:	58                   	pop    %eax
  10690b:	5a                   	pop    %edx
  10690c:	56                   	push   %esi
  10690d:	57                   	push   %edi
    unsigned int page_index = get_pdir_entry_by_va(proc_index, vaddr) >> 12;
  10690e:	c1 eb 0c             	shr    $0xc,%ebx
    rmv_pdir_entry(proc_index, PDE_ADDR(vaddr));
  106911:	e8 ba fb ff ff       	call   1064d0 <rmv_pdir_entry>
    container_free(proc_index, page_index);
  106916:	83 c4 10             	add    $0x10,%esp
  106919:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  10691d:	89 7c 24 10          	mov    %edi,0x10(%esp)
}
  106921:	5b                   	pop    %ebx
  106922:	5e                   	pop    %esi
  106923:	5f                   	pop    %edi
    container_free(proc_index, page_index);
  106924:	e9 b7 fa ff ff       	jmp    1063e0 <container_free>
  106929:	66 90                	xchg   %ax,%ax
  10692b:	66 90                	xchg   %ax,%ax
  10692d:	66 90                	xchg   %ax,%ax
  10692f:	90                   	nop

00106930 <pdir_init_kern>:
/**
 * Sets the entire page map for process 0 as the identity map.
 * Note that part of the task is already completed by pdir_init.
 */
void pdir_init_kern(unsigned int mbi_addr)
{
  106930:	53                   	push   %ebx
    unsigned int pde_index;

    pdir_init(mbi_addr);

    // Set identity map for user PDEs
    for (pde_index = VM_USERLO_PDE; pde_index < VM_USERHI_PDE; pde_index++) {
  106931:	bb 00 01 00 00       	mov    $0x100,%ebx
{
  106936:	83 ec 14             	sub    $0x14,%esp
    pdir_init(mbi_addr);
  106939:	ff 74 24 1c          	pushl  0x1c(%esp)
  10693d:	e8 de fe ff ff       	call   106820 <pdir_init>
  106942:	83 c4 10             	add    $0x10,%esp
  106945:	8d 76 00             	lea    0x0(%esi),%esi
        set_pdir_entry_identity(0, pde_index);
  106948:	83 ec 08             	sub    $0x8,%esp
  10694b:	53                   	push   %ebx
    for (pde_index = VM_USERLO_PDE; pde_index < VM_USERHI_PDE; pde_index++) {
  10694c:	83 c3 01             	add    $0x1,%ebx
        set_pdir_entry_identity(0, pde_index);
  10694f:	6a 00                	push   $0x0
  106951:	e8 5a fb ff ff       	call   1064b0 <set_pdir_entry_identity>
    for (pde_index = VM_USERLO_PDE; pde_index < VM_USERHI_PDE; pde_index++) {
  106956:	83 c4 10             	add    $0x10,%esp
  106959:	81 fb c0 03 00 00    	cmp    $0x3c0,%ebx
  10695f:	75 e7                	jne    106948 <pdir_init_kern+0x18>
    }
}
  106961:	83 c4 08             	add    $0x8,%esp
  106964:	5b                   	pop    %ebx
  106965:	c3                   	ret    
  106966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10696d:	8d 76 00             	lea    0x0(%esi),%esi

00106970 <map_page>:
 * otherwise, it returns the physical page index registered in the page directory,
 * (the return value of get_pdir_entry_by_va or alloc_ptbl).
 */
unsigned int map_page(unsigned int proc_index, unsigned int vaddr,
                      unsigned int page_index, unsigned int perm)
{
  106970:	57                   	push   %edi
  106971:	56                   	push   %esi
  106972:	53                   	push   %ebx
  106973:	8b 74 24 10          	mov    0x10(%esp),%esi
  106977:	8b 7c 24 14          	mov    0x14(%esp),%edi
    unsigned int pde_entry = get_pdir_entry_by_va(proc_index, vaddr);
  10697b:	83 ec 08             	sub    $0x8,%esp
  10697e:	57                   	push   %edi
  10697f:	56                   	push   %esi
  106980:	e8 8b fd ff ff       	call   106710 <get_pdir_entry_by_va>
    unsigned int pde_page_index = pde_entry >> 12;

    if (pde_entry == 0) {
  106985:	83 c4 10             	add    $0x10,%esp
  106988:	85 c0                	test   %eax,%eax
  10698a:	74 24                	je     1069b0 <map_page+0x40>
    unsigned int pde_page_index = pde_entry >> 12;
  10698c:	c1 e8 0c             	shr    $0xc,%eax
  10698f:	89 c3                	mov    %eax,%ebx
        if (pde_page_index == 0) {
            return MagicNumber;
        }
    }

    set_ptbl_entry_by_va(proc_index, vaddr, page_index, perm);
  106991:	ff 74 24 1c          	pushl  0x1c(%esp)
  106995:	ff 74 24 1c          	pushl  0x1c(%esp)
  106999:	57                   	push   %edi
  10699a:	56                   	push   %esi
  10699b:	e8 e0 fd ff ff       	call   106780 <set_ptbl_entry_by_va>
    return pde_page_index;
  1069a0:	83 c4 10             	add    $0x10,%esp
}
  1069a3:	89 d8                	mov    %ebx,%eax
  1069a5:	5b                   	pop    %ebx
  1069a6:	5e                   	pop    %esi
  1069a7:	5f                   	pop    %edi
  1069a8:	c3                   	ret    
  1069a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        pde_page_index = alloc_ptbl(proc_index, vaddr);
  1069b0:	83 ec 08             	sub    $0x8,%esp
  1069b3:	57                   	push   %edi
  1069b4:	56                   	push   %esi
  1069b5:	e8 c6 fe ff ff       	call   106880 <alloc_ptbl>
        if (pde_page_index == 0) {
  1069ba:	83 c4 10             	add    $0x10,%esp
        pde_page_index = alloc_ptbl(proc_index, vaddr);
  1069bd:	89 c3                	mov    %eax,%ebx
        if (pde_page_index == 0) {
  1069bf:	85 c0                	test   %eax,%eax
  1069c1:	75 ce                	jne    106991 <map_page+0x21>
            return MagicNumber;
  1069c3:	bb 01 00 10 00       	mov    $0x100001,%ebx
}
  1069c8:	89 d8                	mov    %ebx,%eax
  1069ca:	5b                   	pop    %ebx
  1069cb:	5e                   	pop    %esi
  1069cc:	5f                   	pop    %edi
  1069cd:	c3                   	ret    
  1069ce:	66 90                	xchg   %ax,%ax

001069d0 <unmap_page>:
 * Nothing should be done if the mapping no longer exists.
 * You do not need to unmap the page table from the page directory.
 * It should return the corresponding page table entry.
 */
unsigned int unmap_page(unsigned int proc_index, unsigned int vaddr)
{
  1069d0:	56                   	push   %esi
  1069d1:	53                   	push   %ebx
  1069d2:	83 ec 1c             	sub    $0x1c,%esp
  1069d5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
  1069d9:	8b 74 24 2c          	mov    0x2c(%esp),%esi
    unsigned int pte_entry = get_ptbl_entry_by_va(proc_index, vaddr);
  1069dd:	56                   	push   %esi
  1069de:	53                   	push   %ebx
  1069df:	e8 dc fc ff ff       	call   1066c0 <get_ptbl_entry_by_va>
    if (pte_entry != 0) {
  1069e4:	83 c4 10             	add    $0x10,%esp
  1069e7:	85 c0                	test   %eax,%eax
  1069e9:	75 0d                	jne    1069f8 <unmap_page+0x28>
        rmv_ptbl_entry_by_va(proc_index, vaddr);
    }
    return pte_entry;
}
  1069eb:	83 c4 14             	add    $0x14,%esp
  1069ee:	5b                   	pop    %ebx
  1069ef:	5e                   	pop    %esi
  1069f0:	c3                   	ret    
  1069f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1069f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
        rmv_ptbl_entry_by_va(proc_index, vaddr);
  1069fc:	83 ec 08             	sub    $0x8,%esp
  1069ff:	56                   	push   %esi
  106a00:	53                   	push   %ebx
  106a01:	e8 1a fd ff ff       	call   106720 <rmv_ptbl_entry_by_va>
  106a06:	83 c4 10             	add    $0x10,%esp
  106a09:	8b 44 24 0c          	mov    0xc(%esp),%eax
}
  106a0d:	83 c4 14             	add    $0x14,%esp
  106a10:	5b                   	pop    %ebx
  106a11:	5e                   	pop    %esi
  106a12:	c3                   	ret    
  106a13:	66 90                	xchg   %ax,%ax
  106a15:	66 90                	xchg   %ax,%ax
  106a17:	66 90                	xchg   %ax,%ax
  106a19:	66 90                	xchg   %ax,%ax
  106a1b:	66 90                	xchg   %ax,%ax
  106a1d:	66 90                	xchg   %ax,%ax
  106a1f:	90                   	nop

00106a20 <paging_init>:
/**
 * Initializes the page structures, moves to the kernel page structure (0),
 * and turns on the paging.
 */
void paging_init(unsigned int mbi_addr)
{
  106a20:	83 ec 18             	sub    $0x18,%esp
    pdir_init_kern(mbi_addr);
  106a23:	ff 74 24 1c          	pushl  0x1c(%esp)
  106a27:	e8 04 ff ff ff       	call   106930 <pdir_init_kern>
    set_pdir_base(0);
  106a2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106a33:	e8 18 fa ff ff       	call   106450 <set_pdir_base>
    enable_paging();
}
  106a38:	83 c4 1c             	add    $0x1c,%esp
    enable_paging();
  106a3b:	e9 00 a5 ff ff       	jmp    100f40 <enable_paging>

00106a40 <paging_init_ap>:

void paging_init_ap(void)
{
  106a40:	83 ec 18             	sub    $0x18,%esp
    set_pdir_base(0);
  106a43:	6a 00                	push   $0x0
  106a45:	e8 06 fa ff ff       	call   106450 <set_pdir_base>
    enable_paging();
}
  106a4a:	83 c4 1c             	add    $0x1c,%esp
    enable_paging();
  106a4d:	e9 ee a4 ff ff       	jmp    100f40 <enable_paging>
  106a52:	66 90                	xchg   %ax,%ax
  106a54:	66 90                	xchg   %ax,%ax
  106a56:	66 90                	xchg   %ax,%ax
  106a58:	66 90                	xchg   %ax,%ax
  106a5a:	66 90                	xchg   %ax,%ax
  106a5c:	66 90                	xchg   %ax,%ax
  106a5e:	66 90                	xchg   %ax,%ax

00106a60 <alloc_page>:
 * return value from map_page.
 * In the case of error, it should return the constant MagicNumber.
 */
unsigned int alloc_page(unsigned int proc_index, unsigned int vaddr,
                        unsigned int perm)
{
  106a60:	53                   	push   %ebx
  106a61:	83 ec 14             	sub    $0x14,%esp
  106a64:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    unsigned int page_index = container_alloc(proc_index);
  106a68:	53                   	push   %ebx
  106a69:	e8 12 f9 ff ff       	call   106380 <container_alloc>
    if (page_index != 0) {
  106a6e:	83 c4 10             	add    $0x10,%esp
  106a71:	ba 01 00 10 00       	mov    $0x100001,%edx
  106a76:	85 c0                	test   %eax,%eax
  106a78:	74 14                	je     106a8e <alloc_page+0x2e>
        return map_page(proc_index, vaddr, page_index, perm);
  106a7a:	ff 74 24 18          	pushl  0x18(%esp)
  106a7e:	50                   	push   %eax
  106a7f:	ff 74 24 1c          	pushl  0x1c(%esp)
  106a83:	53                   	push   %ebx
  106a84:	e8 e7 fe ff ff       	call   106970 <map_page>
  106a89:	83 c4 10             	add    $0x10,%esp
  106a8c:	89 c2                	mov    %eax,%edx
    } else {
        return MagicNumber;
    }
}
  106a8e:	83 c4 08             	add    $0x8,%esp
  106a91:	89 d0                	mov    %edx,%eax
  106a93:	5b                   	pop    %ebx
  106a94:	c3                   	ret    
  106a95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106aa0 <alloc_mem_quota>:
 * Designate some memory quota for the next child process.
 */
unsigned int alloc_mem_quota(unsigned int id, unsigned int quota)
{
    unsigned int child;
    child = container_split(id, quota);
  106aa0:	e9 3b f8 ff ff       	jmp    1062e0 <container_split>
  106aa5:	66 90                	xchg   %ax,%ax
  106aa7:	66 90                	xchg   %ax,%ax
  106aa9:	66 90                	xchg   %ax,%ax
  106aab:	66 90                	xchg   %ax,%ax
  106aad:	66 90                	xchg   %ax,%ax
  106aaf:	90                   	nop

00106ab0 <map_vm>:
#define ADDR_MASK(x) ((unsigned int) x & 0xfffff000)

/* Copy memory map from 'from' to 'to'
 * N.B. Only user space mapping has to be copied. */
void map_vm(unsigned int from, unsigned int to)
{
  106ab0:	57                   	push   %edi
  106ab1:	56                   	push   %esi
  106ab2:	53                   	push   %ebx
  106ab3:	8b 7c 24 10          	mov    0x10(%esp),%edi
    unsigned int pde;
    for (pde = VM_USERLO_PDE; pde < VM_USERHI_PDE; pde++) {
  106ab7:	bb 00 01 00 00       	mov    $0x100,%ebx
{
  106abc:	8b 74 24 14          	mov    0x14(%esp),%esi
        copy_pdir_entry(from, to, pde);
  106ac0:	83 ec 04             	sub    $0x4,%esp
  106ac3:	53                   	push   %ebx
    for (pde = VM_USERLO_PDE; pde < VM_USERHI_PDE; pde++) {
  106ac4:	83 c3 01             	add    $0x1,%ebx
        copy_pdir_entry(from, to, pde);
  106ac7:	56                   	push   %esi
  106ac8:	57                   	push   %edi
  106ac9:	e8 42 fb ff ff       	call   106610 <copy_pdir_entry>
    for (pde = VM_USERLO_PDE; pde < VM_USERHI_PDE; pde++) {
  106ace:	83 c4 10             	add    $0x10,%esp
  106ad1:	81 fb c0 03 00 00    	cmp    $0x3c0,%ebx
  106ad7:	75 e7                	jne    106ac0 <map_vm+0x10>
    }
}
  106ad9:	5b                   	pop    %ebx
  106ada:	5e                   	pop    %esi
  106adb:	5f                   	pop    %edi
  106adc:	c3                   	ret    
  106add:	66 90                	xchg   %ax,%ax
  106adf:	90                   	nop

00106ae0 <kctx_set_esp>:

// Memory to save the NUM_IDS kernel thread states.
struct kctx kctx_pool[NUM_IDS];

void kctx_set_esp(unsigned int pid, void *esp)
{
  106ae0:	8b 44 24 04          	mov    0x4(%esp),%eax
    kctx_pool[pid].esp = esp;
  106ae4:	8b 54 24 08          	mov    0x8(%esp),%edx
  106ae8:	8d 04 40             	lea    (%eax,%eax,2),%eax
  106aeb:	89 14 c5 00 e0 e1 00 	mov    %edx,0xe1e000(,%eax,8)
}
  106af2:	c3                   	ret    
  106af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106b00 <kctx_set_eip>:

void kctx_set_eip(unsigned int pid, void *eip)
{
  106b00:	8b 44 24 04          	mov    0x4(%esp),%eax
    kctx_pool[pid].eip = eip;
  106b04:	8b 54 24 08          	mov    0x8(%esp),%edx
  106b08:	8d 04 40             	lea    (%eax,%eax,2),%eax
  106b0b:	89 14 c5 14 e0 e1 00 	mov    %edx,0xe1e014(,%eax,8)
}
  106b12:	c3                   	ret    
  106b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106b20 <kctx_switch>:
/**
 * Saves the states for thread # [from_pid] and restores the states
 * for thread # [to_pid].
 */
void kctx_switch(unsigned int from_pid, unsigned int to_pid)
{
  106b20:	8b 44 24 04          	mov    0x4(%esp),%eax
  106b24:	8b 54 24 08          	mov    0x8(%esp),%edx
    cswitch(&kctx_pool[from_pid], &kctx_pool[to_pid]);
  106b28:	8d 04 40             	lea    (%eax,%eax,2),%eax
  106b2b:	8d 14 52             	lea    (%edx,%edx,2),%edx
  106b2e:	8d 14 d5 00 e0 e1 00 	lea    0xe1e000(,%edx,8),%edx
  106b35:	8d 04 c5 00 e0 e1 00 	lea    0xe1e000(,%eax,8),%eax
  106b3c:	89 54 24 08          	mov    %edx,0x8(%esp)
  106b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  106b44:	e9 00 00 00 00       	jmp    106b49 <cswitch>

00106b49 <cswitch>:
/*
 * void cswitch(struct kctx *from, struct kctx *to);
 */
	.globl cswitch
cswitch:
	movl	4(%esp), %eax	/* %eax <- from */
  106b49:	8b 44 24 04          	mov    0x4(%esp),%eax
	movl	8(%esp), %edx	/* %edx <- to */
  106b4d:	8b 54 24 08          	mov    0x8(%esp),%edx

	/* save the old kernel context */
	movl	0(%esp), %ecx
  106b51:	8b 0c 24             	mov    (%esp),%ecx
	movl	%ecx, 20(%eax)
  106b54:	89 48 14             	mov    %ecx,0x14(%eax)
	movl	%ebp, 16(%eax)
  106b57:	89 68 10             	mov    %ebp,0x10(%eax)
	movl	%ebx, 12(%eax)
  106b5a:	89 58 0c             	mov    %ebx,0xc(%eax)
	movl	%esi, 8(%eax)
  106b5d:	89 70 08             	mov    %esi,0x8(%eax)
	movl	%edi, 4(%eax)
  106b60:	89 78 04             	mov    %edi,0x4(%eax)
	movl	%esp, 0(%eax)
  106b63:	89 20                	mov    %esp,(%eax)

	/* load the new kernel context */
	movl	0(%edx), %esp
  106b65:	8b 22                	mov    (%edx),%esp
	movl	4(%edx), %edi
  106b67:	8b 7a 04             	mov    0x4(%edx),%edi
	movl	8(%edx), %esi
  106b6a:	8b 72 08             	mov    0x8(%edx),%esi
	movl	12(%edx), %ebx
  106b6d:	8b 5a 0c             	mov    0xc(%edx),%ebx
	movl	16(%edx), %ebp
  106b70:	8b 6a 10             	mov    0x10(%edx),%ebp
	movl	20(%edx), %ecx
  106b73:	8b 4a 14             	mov    0x14(%edx),%ecx
	movl	%ecx, 0(%esp)
  106b76:	89 0c 24             	mov    %ecx,(%esp)

	xor	%eax, %eax
  106b79:	31 c0                	xor    %eax,%eax
	ret
  106b7b:	c3                   	ret    
  106b7c:	66 90                	xchg   %ax,%ax
  106b7e:	66 90                	xchg   %ax,%ax

00106b80 <kctx_new>:
 * Don't forget the stack is going down from high address to low.
 * We do not care about the rest of states when a new thread starts.
 * The function returns the child thread (process) id.
 */
unsigned int kctx_new(void *entry, unsigned int id, unsigned int quota)
{
  106b80:	57                   	push   %edi
  106b81:	56                   	push   %esi
  106b82:	53                   	push   %ebx
  106b83:	8b 74 24 14          	mov    0x14(%esp),%esi
    unsigned int pid = NUM_IDS;
  106b87:	bb 40 00 00 00       	mov    $0x40,%ebx
{
  106b8c:	8b 7c 24 18          	mov    0x18(%esp),%edi

    if (container_can_consume(id, quota)) {
  106b90:	83 ec 08             	sub    $0x8,%esp
  106b93:	57                   	push   %edi
  106b94:	56                   	push   %esi
  106b95:	e8 16 f7 ff ff       	call   1062b0 <container_can_consume>
  106b9a:	83 c4 10             	add    $0x10,%esp
  106b9d:	85 c0                	test   %eax,%eax
  106b9f:	75 0f                	jne    106bb0 <kctx_new+0x30>
            kctx_set_eip(pid, entry);
        }
    }

    return pid;
}
  106ba1:	89 d8                	mov    %ebx,%eax
  106ba3:	5b                   	pop    %ebx
  106ba4:	5e                   	pop    %esi
  106ba5:	5f                   	pop    %edi
  106ba6:	c3                   	ret    
  106ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106bae:	66 90                	xchg   %ax,%ax
        pid = alloc_mem_quota(id, quota);
  106bb0:	83 ec 08             	sub    $0x8,%esp
  106bb3:	57                   	push   %edi
  106bb4:	56                   	push   %esi
  106bb5:	e8 e6 fe ff ff       	call   106aa0 <alloc_mem_quota>
        if (pid != NUM_IDS) {
  106bba:	83 c4 10             	add    $0x10,%esp
        pid = alloc_mem_quota(id, quota);
  106bbd:	89 c3                	mov    %eax,%ebx
        if (pid != NUM_IDS) {
  106bbf:	83 f8 40             	cmp    $0x40,%eax
  106bc2:	74 dd                	je     106ba1 <kctx_new+0x21>
            kctx_set_esp(pid, proc_kstack[pid].kstack_hi);
  106bc4:	c1 e0 0c             	shl    $0xc,%eax
  106bc7:	83 ec 08             	sub    $0x8,%esp
  106bca:	05 00 c0 99 00       	add    $0x99c000,%eax
  106bcf:	50                   	push   %eax
  106bd0:	53                   	push   %ebx
  106bd1:	e8 0a ff ff ff       	call   106ae0 <kctx_set_esp>
            kctx_set_eip(pid, entry);
  106bd6:	58                   	pop    %eax
  106bd7:	5a                   	pop    %edx
  106bd8:	ff 74 24 18          	pushl  0x18(%esp)
  106bdc:	53                   	push   %ebx
  106bdd:	e8 1e ff ff ff       	call   106b00 <kctx_set_eip>
  106be2:	83 c4 10             	add    $0x10,%esp
}
  106be5:	89 d8                	mov    %ebx,%eax
  106be7:	5b                   	pop    %ebx
  106be8:	5e                   	pop    %esi
  106be9:	5f                   	pop    %edi
  106bea:	c3                   	ret    
  106beb:	66 90                	xchg   %ax,%ax
  106bed:	66 90                	xchg   %ax,%ax
  106bef:	90                   	nop

00106bf0 <tcb_get_state>:

struct TCB TCBPool[NUM_IDS];

unsigned int tcb_get_state(unsigned int pid)
{
    return TCBPool[pid].state;
  106bf0:	8b 44 24 04          	mov    0x4(%esp),%eax
  106bf4:	c1 e0 04             	shl    $0x4,%eax
  106bf7:	8b 80 00 e6 e1 00    	mov    0xe1e600(%eax),%eax
}
  106bfd:	c3                   	ret    
  106bfe:	66 90                	xchg   %ax,%ax

00106c00 <tcb_set_state>:

void tcb_set_state(unsigned int pid, unsigned int state)
{
    TCBPool[pid].state = state;
  106c00:	8b 44 24 04          	mov    0x4(%esp),%eax
  106c04:	8b 54 24 08          	mov    0x8(%esp),%edx
  106c08:	c1 e0 04             	shl    $0x4,%eax
  106c0b:	89 90 00 e6 e1 00    	mov    %edx,0xe1e600(%eax)
}
  106c11:	c3                   	ret    
  106c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106c20 <tcb_get_cpu>:

unsigned int tcb_get_cpu(unsigned int pid)
{
    return TCBPool[pid].cpuid;
  106c20:	8b 44 24 04          	mov    0x4(%esp),%eax
  106c24:	c1 e0 04             	shl    $0x4,%eax
  106c27:	8b 80 04 e6 e1 00    	mov    0xe1e604(%eax),%eax
}
  106c2d:	c3                   	ret    
  106c2e:	66 90                	xchg   %ax,%ax

00106c30 <tcb_set_cpu>:

void tcb_set_cpu(unsigned int pid, unsigned int cpu)
{
    TCBPool[pid].cpuid = cpu;
  106c30:	8b 44 24 04          	mov    0x4(%esp),%eax
  106c34:	8b 54 24 08          	mov    0x8(%esp),%edx
  106c38:	c1 e0 04             	shl    $0x4,%eax
  106c3b:	89 90 04 e6 e1 00    	mov    %edx,0xe1e604(%eax)
}
  106c41:	c3                   	ret    
  106c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106c50 <tcb_get_prev>:

unsigned int tcb_get_prev(unsigned int pid)
{
    return TCBPool[pid].prev;
  106c50:	8b 44 24 04          	mov    0x4(%esp),%eax
  106c54:	c1 e0 04             	shl    $0x4,%eax
  106c57:	8b 80 08 e6 e1 00    	mov    0xe1e608(%eax),%eax
}
  106c5d:	c3                   	ret    
  106c5e:	66 90                	xchg   %ax,%ax

00106c60 <tcb_set_prev>:

void tcb_set_prev(unsigned int pid, unsigned int prev_pid)
{
    TCBPool[pid].prev = prev_pid;
  106c60:	8b 44 24 04          	mov    0x4(%esp),%eax
  106c64:	8b 54 24 08          	mov    0x8(%esp),%edx
  106c68:	c1 e0 04             	shl    $0x4,%eax
  106c6b:	89 90 08 e6 e1 00    	mov    %edx,0xe1e608(%eax)
}
  106c71:	c3                   	ret    
  106c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106c80 <tcb_get_next>:

unsigned int tcb_get_next(unsigned int pid)
{
    return TCBPool[pid].next;
  106c80:	8b 44 24 04          	mov    0x4(%esp),%eax
  106c84:	c1 e0 04             	shl    $0x4,%eax
  106c87:	8b 80 0c e6 e1 00    	mov    0xe1e60c(%eax),%eax
}
  106c8d:	c3                   	ret    
  106c8e:	66 90                	xchg   %ax,%ax

00106c90 <tcb_set_next>:

void tcb_set_next(unsigned int pid, unsigned int next_pid)
{
    TCBPool[pid].next = next_pid;
  106c90:	8b 44 24 04          	mov    0x4(%esp),%eax
  106c94:	8b 54 24 08          	mov    0x8(%esp),%edx
  106c98:	c1 e0 04             	shl    $0x4,%eax
  106c9b:	89 90 0c e6 e1 00    	mov    %edx,0xe1e60c(%eax)
}
  106ca1:	c3                   	ret    
  106ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106cb0 <tcb_init_at_id>:

void tcb_init_at_id(unsigned int pid)
{
    TCBPool[pid].state = TSTATE_DEAD;
  106cb0:	8b 44 24 04          	mov    0x4(%esp),%eax
  106cb4:	c1 e0 04             	shl    $0x4,%eax
  106cb7:	c7 80 00 e6 e1 00 03 	movl   $0x3,0xe1e600(%eax)
  106cbe:	00 00 00 
    TCBPool[pid].cpuid = NUM_CPUS;
  106cc1:	c7 80 04 e6 e1 00 08 	movl   $0x8,0xe1e604(%eax)
  106cc8:	00 00 00 
    TCBPool[pid].prev = NUM_IDS;
  106ccb:	c7 80 08 e6 e1 00 40 	movl   $0x40,0xe1e608(%eax)
  106cd2:	00 00 00 
    TCBPool[pid].next = NUM_IDS;
  106cd5:	c7 80 0c e6 e1 00 40 	movl   $0x40,0xe1e60c(%eax)
  106cdc:	00 00 00 
}
  106cdf:	c3                   	ret    

00106ce0 <tcb_init>:
/**
 * Initializes the TCB for all NUM_IDS threads with the state TSTATE_DEAD,
 * and with two indices being NUM_IDS (which represents NULL).
 */
void tcb_init(unsigned int mbi_addr)
{
  106ce0:	53                   	push   %ebx
    unsigned int pid = 0;
  106ce1:	31 db                	xor    %ebx,%ebx
{
  106ce3:	83 ec 14             	sub    $0x14,%esp
    paging_init(mbi_addr);
  106ce6:	ff 74 24 1c          	pushl  0x1c(%esp)
  106cea:	e8 31 fd ff ff       	call   106a20 <paging_init>
  106cef:	83 c4 10             	add    $0x10,%esp
  106cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    while (pid < NUM_IDS) {
        tcb_init_at_id(pid);
  106cf8:	83 ec 0c             	sub    $0xc,%esp
  106cfb:	53                   	push   %ebx
        pid++;
  106cfc:	83 c3 01             	add    $0x1,%ebx
        tcb_init_at_id(pid);
  106cff:	e8 ac ff ff ff       	call   106cb0 <tcb_init_at_id>
    while (pid < NUM_IDS) {
  106d04:	83 c4 10             	add    $0x10,%esp
  106d07:	83 fb 40             	cmp    $0x40,%ebx
  106d0a:	75 ec                	jne    106cf8 <tcb_init+0x18>
    }
}
  106d0c:	83 c4 08             	add    $0x8,%esp
  106d0f:	5b                   	pop    %ebx
  106d10:	c3                   	ret    
  106d11:	66 90                	xchg   %ax,%ax
  106d13:	66 90                	xchg   %ax,%ax
  106d15:	66 90                	xchg   %ax,%ax
  106d17:	66 90                	xchg   %ax,%ax
  106d19:	66 90                	xchg   %ax,%ax
  106d1b:	66 90                	xchg   %ax,%ax
  106d1d:	66 90                	xchg   %ax,%ax
  106d1f:	90                   	nop

00106d20 <tqueue_get_head>:
 */
struct TQueue TQueuePool[NUM_IDS + NUM_CPUS];

unsigned int tqueue_get_head(unsigned int chid)
{
    return TQueuePool[chid].head;
  106d20:	8b 44 24 04          	mov    0x4(%esp),%eax
  106d24:	8b 04 c5 20 ea e1 00 	mov    0xe1ea20(,%eax,8),%eax
}
  106d2b:	c3                   	ret    
  106d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106d30 <tqueue_set_head>:

void tqueue_set_head(unsigned int chid, unsigned int head)
{
    TQueuePool[chid].head = head;
  106d30:	8b 44 24 04          	mov    0x4(%esp),%eax
  106d34:	8b 54 24 08          	mov    0x8(%esp),%edx
  106d38:	89 14 c5 20 ea e1 00 	mov    %edx,0xe1ea20(,%eax,8)
}
  106d3f:	c3                   	ret    

00106d40 <tqueue_get_tail>:

unsigned int tqueue_get_tail(unsigned int chid)
{
    return TQueuePool[chid].tail;
  106d40:	8b 44 24 04          	mov    0x4(%esp),%eax
  106d44:	8b 04 c5 24 ea e1 00 	mov    0xe1ea24(,%eax,8),%eax
}
  106d4b:	c3                   	ret    
  106d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106d50 <tqueue_set_tail>:

void tqueue_set_tail(unsigned int chid, unsigned int tail)
{
    TQueuePool[chid].tail = tail;
  106d50:	8b 44 24 04          	mov    0x4(%esp),%eax
  106d54:	8b 54 24 08          	mov    0x8(%esp),%edx
  106d58:	89 14 c5 24 ea e1 00 	mov    %edx,0xe1ea24(,%eax,8)
}
  106d5f:	c3                   	ret    

00106d60 <tqueue_init_at_id>:

void tqueue_init_at_id(unsigned int chid)
{
  106d60:	8b 44 24 04          	mov    0x4(%esp),%eax
    TQueuePool[chid].head = NUM_IDS;
  106d64:	c7 04 c5 20 ea e1 00 	movl   $0x40,0xe1ea20(,%eax,8)
  106d6b:	40 00 00 00 
    TQueuePool[chid].tail = NUM_IDS;
  106d6f:	c7 04 c5 24 ea e1 00 	movl   $0x40,0xe1ea24(,%eax,8)
  106d76:	40 00 00 00 
}
  106d7a:	c3                   	ret    
  106d7b:	66 90                	xchg   %ax,%ax
  106d7d:	66 90                	xchg   %ax,%ax
  106d7f:	90                   	nop

00106d80 <tqueue_init>:

/**
 * Initializes all the thread queues with tqueue_init_at_id.
 */
void tqueue_init(unsigned int mbi_addr)
{
  106d80:	53                   	push   %ebx
    unsigned int cpu_idx, chid;
    tcb_init(mbi_addr);

    chid = 0;
  106d81:	31 db                	xor    %ebx,%ebx
{
  106d83:	83 ec 14             	sub    $0x14,%esp
    tcb_init(mbi_addr);
  106d86:	ff 74 24 1c          	pushl  0x1c(%esp)
  106d8a:	e8 51 ff ff ff       	call   106ce0 <tcb_init>
  106d8f:	83 c4 10             	add    $0x10,%esp
  106d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while (chid < NUM_IDS + NUM_CPUS) {
        tqueue_init_at_id(chid);
  106d98:	83 ec 0c             	sub    $0xc,%esp
  106d9b:	53                   	push   %ebx
        chid++;
  106d9c:	83 c3 01             	add    $0x1,%ebx
        tqueue_init_at_id(chid);
  106d9f:	e8 bc ff ff ff       	call   106d60 <tqueue_init_at_id>
    while (chid < NUM_IDS + NUM_CPUS) {
  106da4:	83 c4 10             	add    $0x10,%esp
  106da7:	83 fb 48             	cmp    $0x48,%ebx
  106daa:	75 ec                	jne    106d98 <tqueue_init+0x18>
    }
}
  106dac:	83 c4 08             	add    $0x8,%esp
  106daf:	5b                   	pop    %ebx
  106db0:	c3                   	ret    
  106db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106dbf:	90                   	nop

00106dc0 <tqueue_enqueue>:
 * Recall that the doubly linked list is index based.
 * So you only need to insert the index.
 * Hint: there are multiple cases in this function.
 */
void tqueue_enqueue(unsigned int chid, unsigned int pid)
{
  106dc0:	57                   	push   %edi
  106dc1:	56                   	push   %esi
  106dc2:	53                   	push   %ebx
  106dc3:	8b 7c 24 10          	mov    0x10(%esp),%edi
  106dc7:	8b 74 24 14          	mov    0x14(%esp),%esi
    unsigned int tail = tqueue_get_tail(chid);
  106dcb:	83 ec 0c             	sub    $0xc,%esp
  106dce:	57                   	push   %edi
  106dcf:	e8 6c ff ff ff       	call   106d40 <tqueue_get_tail>

    if (tail == NUM_IDS) {
  106dd4:	83 c4 10             	add    $0x10,%esp
  106dd7:	83 f8 40             	cmp    $0x40,%eax
  106dda:	74 34                	je     106e10 <tqueue_enqueue+0x50>
        tcb_set_prev(pid, NUM_IDS);
        tcb_set_next(pid, NUM_IDS);
        tqueue_set_head(chid, pid);
        tqueue_set_tail(chid, pid);
    } else {
        tcb_set_next(tail, pid);
  106ddc:	83 ec 08             	sub    $0x8,%esp
  106ddf:	89 c3                	mov    %eax,%ebx
  106de1:	56                   	push   %esi
  106de2:	50                   	push   %eax
  106de3:	e8 a8 fe ff ff       	call   106c90 <tcb_set_next>
        tcb_set_prev(pid, tail);
  106de8:	58                   	pop    %eax
  106de9:	5a                   	pop    %edx
  106dea:	53                   	push   %ebx
  106deb:	56                   	push   %esi
  106dec:	e8 6f fe ff ff       	call   106c60 <tcb_set_prev>
        tcb_set_next(pid, NUM_IDS);
  106df1:	59                   	pop    %ecx
  106df2:	5b                   	pop    %ebx
  106df3:	6a 40                	push   $0x40
  106df5:	56                   	push   %esi
  106df6:	e8 95 fe ff ff       	call   106c90 <tcb_set_next>
        tqueue_set_tail(chid, pid);
  106dfb:	83 c4 10             	add    $0x10,%esp
  106dfe:	89 74 24 14          	mov    %esi,0x14(%esp)
  106e02:	89 7c 24 10          	mov    %edi,0x10(%esp)
    }
}
  106e06:	5b                   	pop    %ebx
  106e07:	5e                   	pop    %esi
  106e08:	5f                   	pop    %edi
        tqueue_set_tail(chid, pid);
  106e09:	e9 42 ff ff ff       	jmp    106d50 <tqueue_set_tail>
  106e0e:	66 90                	xchg   %ax,%ax
        tcb_set_prev(pid, NUM_IDS);
  106e10:	83 ec 08             	sub    $0x8,%esp
  106e13:	6a 40                	push   $0x40
  106e15:	56                   	push   %esi
  106e16:	e8 45 fe ff ff       	call   106c60 <tcb_set_prev>
        tcb_set_next(pid, NUM_IDS);
  106e1b:	58                   	pop    %eax
  106e1c:	5a                   	pop    %edx
  106e1d:	6a 40                	push   $0x40
  106e1f:	56                   	push   %esi
  106e20:	e8 6b fe ff ff       	call   106c90 <tcb_set_next>
        tqueue_set_head(chid, pid);
  106e25:	59                   	pop    %ecx
  106e26:	5b                   	pop    %ebx
  106e27:	56                   	push   %esi
  106e28:	57                   	push   %edi
  106e29:	e8 02 ff ff ff       	call   106d30 <tqueue_set_head>
        tqueue_set_tail(chid, pid);
  106e2e:	eb cb                	jmp    106dfb <tqueue_enqueue+0x3b>

00106e30 <tqueue_dequeue>:
 * Reverse action of tqueue_enqueue, i.e. pops a TCB from the head of the specified queue.
 * It returns the popped thread's id, or NUM_IDS if the queue is empty.
 * Hint: there are multiple cases in this function.
 */
unsigned int tqueue_dequeue(unsigned int chid)
{
  106e30:	57                   	push   %edi
  106e31:	56                   	push   %esi
  106e32:	53                   	push   %ebx
  106e33:	8b 7c 24 10          	mov    0x10(%esp),%edi
    unsigned int head, next, pid;

    pid = NUM_IDS;
    head = tqueue_get_head(chid);
  106e37:	83 ec 0c             	sub    $0xc,%esp
  106e3a:	57                   	push   %edi
  106e3b:	e8 e0 fe ff ff       	call   106d20 <tqueue_get_head>

    if (head != NUM_IDS) {
  106e40:	83 c4 10             	add    $0x10,%esp
    head = tqueue_get_head(chid);
  106e43:	89 c3                	mov    %eax,%ebx
    if (head != NUM_IDS) {
  106e45:	83 f8 40             	cmp    $0x40,%eax
  106e48:	74 42                	je     106e8c <tqueue_dequeue+0x5c>
        pid = head;
        next = tcb_get_next(head);
  106e4a:	83 ec 0c             	sub    $0xc,%esp
  106e4d:	50                   	push   %eax
  106e4e:	e8 2d fe ff ff       	call   106c80 <tcb_get_next>

        if (next == NUM_IDS) {
  106e53:	83 c4 10             	add    $0x10,%esp
        next = tcb_get_next(head);
  106e56:	89 c6                	mov    %eax,%esi
        if (next == NUM_IDS) {
  106e58:	83 f8 40             	cmp    $0x40,%eax
  106e5b:	74 3b                	je     106e98 <tqueue_dequeue+0x68>
            tqueue_set_head(chid, NUM_IDS);
            tqueue_set_tail(chid, NUM_IDS);
        } else {
            tcb_set_prev(next, NUM_IDS);
  106e5d:	83 ec 08             	sub    $0x8,%esp
  106e60:	6a 40                	push   $0x40
  106e62:	50                   	push   %eax
  106e63:	e8 f8 fd ff ff       	call   106c60 <tcb_set_prev>
            tqueue_set_head(chid, next);
  106e68:	59                   	pop    %ecx
  106e69:	58                   	pop    %eax
  106e6a:	56                   	push   %esi
  106e6b:	57                   	push   %edi
  106e6c:	e8 bf fe ff ff       	call   106d30 <tqueue_set_head>
  106e71:	83 c4 10             	add    $0x10,%esp
        }
        tcb_set_prev(pid, NUM_IDS);
  106e74:	83 ec 08             	sub    $0x8,%esp
  106e77:	6a 40                	push   $0x40
  106e79:	53                   	push   %ebx
  106e7a:	e8 e1 fd ff ff       	call   106c60 <tcb_set_prev>
        tcb_set_next(pid, NUM_IDS);
  106e7f:	58                   	pop    %eax
  106e80:	5a                   	pop    %edx
  106e81:	6a 40                	push   $0x40
  106e83:	53                   	push   %ebx
  106e84:	e8 07 fe ff ff       	call   106c90 <tcb_set_next>
  106e89:	83 c4 10             	add    $0x10,%esp
    }

    return pid;
}
  106e8c:	89 d8                	mov    %ebx,%eax
  106e8e:	5b                   	pop    %ebx
  106e8f:	5e                   	pop    %esi
  106e90:	5f                   	pop    %edi
  106e91:	c3                   	ret    
  106e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            tqueue_set_head(chid, NUM_IDS);
  106e98:	83 ec 08             	sub    $0x8,%esp
  106e9b:	6a 40                	push   $0x40
  106e9d:	57                   	push   %edi
  106e9e:	e8 8d fe ff ff       	call   106d30 <tqueue_set_head>
            tqueue_set_tail(chid, NUM_IDS);
  106ea3:	58                   	pop    %eax
  106ea4:	5a                   	pop    %edx
  106ea5:	6a 40                	push   $0x40
  106ea7:	57                   	push   %edi
  106ea8:	e8 a3 fe ff ff       	call   106d50 <tqueue_set_tail>
  106ead:	83 c4 10             	add    $0x10,%esp
  106eb0:	eb c2                	jmp    106e74 <tqueue_dequeue+0x44>
  106eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00106ec0 <tqueue_remove>:
/**
 * Removes the TCB #pid from the queue #chid.
 * Hint: there are many cases in this function.
 */
void tqueue_remove(unsigned int chid, unsigned int pid)
{
  106ec0:	55                   	push   %ebp
  106ec1:	57                   	push   %edi
  106ec2:	56                   	push   %esi
  106ec3:	53                   	push   %ebx
  106ec4:	83 ec 18             	sub    $0x18,%esp
  106ec7:	8b 74 24 30          	mov    0x30(%esp),%esi
  106ecb:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
    unsigned int prev, next;

    prev = tcb_get_prev(pid);
  106ecf:	56                   	push   %esi
  106ed0:	e8 7b fd ff ff       	call   106c50 <tcb_get_prev>
    next = tcb_get_next(pid);
  106ed5:	89 34 24             	mov    %esi,(%esp)
    prev = tcb_get_prev(pid);
  106ed8:	89 c5                	mov    %eax,%ebp
    next = tcb_get_next(pid);
  106eda:	e8 a1 fd ff ff       	call   106c80 <tcb_get_next>

    if (prev == NUM_IDS) {
  106edf:	83 c4 10             	add    $0x10,%esp
    next = tcb_get_next(pid);
  106ee2:	89 c3                	mov    %eax,%ebx
    if (prev == NUM_IDS) {
  106ee4:	83 fd 40             	cmp    $0x40,%ebp
  106ee7:	74 57                	je     106f40 <tqueue_remove+0x80>
        } else {
            tcb_set_prev(next, NUM_IDS);
            tqueue_set_head(chid, next);
        }
    } else {
        if (next == NUM_IDS) {
  106ee9:	83 f8 40             	cmp    $0x40,%eax
  106eec:	74 72                	je     106f60 <tqueue_remove+0xa0>
            tcb_set_next(prev, NUM_IDS);
            tqueue_set_tail(chid, prev);
        } else {
            if (prev != next)
  106eee:	39 c5                	cmp    %eax,%ebp
  106ef0:	75 36                	jne    106f28 <tqueue_remove+0x68>
                tcb_set_next(prev, next);
            tcb_set_prev(next, prev);
  106ef2:	83 ec 08             	sub    $0x8,%esp
  106ef5:	55                   	push   %ebp
  106ef6:	53                   	push   %ebx
  106ef7:	e8 64 fd ff ff       	call   106c60 <tcb_set_prev>
  106efc:	83 c4 10             	add    $0x10,%esp
        }
    }
    tcb_set_prev(pid, NUM_IDS);
  106eff:	83 ec 08             	sub    $0x8,%esp
  106f02:	6a 40                	push   $0x40
  106f04:	56                   	push   %esi
  106f05:	e8 56 fd ff ff       	call   106c60 <tcb_set_prev>
    tcb_set_next(pid, NUM_IDS);
  106f0a:	89 74 24 30          	mov    %esi,0x30(%esp)
  106f0e:	c7 44 24 34 40 00 00 	movl   $0x40,0x34(%esp)
  106f15:	00 
}
  106f16:	83 c4 1c             	add    $0x1c,%esp
  106f19:	5b                   	pop    %ebx
  106f1a:	5e                   	pop    %esi
  106f1b:	5f                   	pop    %edi
  106f1c:	5d                   	pop    %ebp
    tcb_set_next(pid, NUM_IDS);
  106f1d:	e9 6e fd ff ff       	jmp    106c90 <tcb_set_next>
  106f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                tcb_set_next(prev, next);
  106f28:	83 ec 08             	sub    $0x8,%esp
  106f2b:	50                   	push   %eax
  106f2c:	55                   	push   %ebp
  106f2d:	e8 5e fd ff ff       	call   106c90 <tcb_set_next>
  106f32:	83 c4 10             	add    $0x10,%esp
  106f35:	eb bb                	jmp    106ef2 <tqueue_remove+0x32>
  106f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106f3e:	66 90                	xchg   %ax,%ax
        if (next == NUM_IDS) {
  106f40:	83 f8 40             	cmp    $0x40,%eax
  106f43:	74 3b                	je     106f80 <tqueue_remove+0xc0>
            tcb_set_prev(next, NUM_IDS);
  106f45:	83 ec 08             	sub    $0x8,%esp
  106f48:	6a 40                	push   $0x40
  106f4a:	50                   	push   %eax
  106f4b:	e8 10 fd ff ff       	call   106c60 <tcb_set_prev>
            tqueue_set_head(chid, next);
  106f50:	59                   	pop    %ecx
  106f51:	5d                   	pop    %ebp
  106f52:	53                   	push   %ebx
  106f53:	57                   	push   %edi
  106f54:	e8 d7 fd ff ff       	call   106d30 <tqueue_set_head>
  106f59:	83 c4 10             	add    $0x10,%esp
  106f5c:	eb a1                	jmp    106eff <tqueue_remove+0x3f>
  106f5e:	66 90                	xchg   %ax,%ax
            tcb_set_next(prev, NUM_IDS);
  106f60:	83 ec 08             	sub    $0x8,%esp
  106f63:	6a 40                	push   $0x40
  106f65:	55                   	push   %ebp
  106f66:	e8 25 fd ff ff       	call   106c90 <tcb_set_next>
            tqueue_set_tail(chid, prev);
  106f6b:	58                   	pop    %eax
  106f6c:	5a                   	pop    %edx
  106f6d:	55                   	push   %ebp
  106f6e:	57                   	push   %edi
  106f6f:	e8 dc fd ff ff       	call   106d50 <tqueue_set_tail>
  106f74:	83 c4 10             	add    $0x10,%esp
  106f77:	eb 86                	jmp    106eff <tqueue_remove+0x3f>
  106f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            tqueue_set_head(chid, NUM_IDS);
  106f80:	83 ec 08             	sub    $0x8,%esp
  106f83:	6a 40                	push   $0x40
  106f85:	57                   	push   %edi
  106f86:	e8 a5 fd ff ff       	call   106d30 <tqueue_set_head>
            tqueue_set_tail(chid, NUM_IDS);
  106f8b:	58                   	pop    %eax
  106f8c:	5a                   	pop    %edx
  106f8d:	6a 40                	push   $0x40
  106f8f:	57                   	push   %edi
  106f90:	e8 bb fd ff ff       	call   106d50 <tqueue_set_tail>
  106f95:	83 c4 10             	add    $0x10,%esp
  106f98:	e9 62 ff ff ff       	jmp    106eff <tqueue_remove+0x3f>
  106f9d:	66 90                	xchg   %ax,%ax
  106f9f:	90                   	nop

00106fa0 <get_curid>:
#include <pcpu/PCPUIntro/export.h>

unsigned int CURID[NUM_CPUS];

unsigned int get_curid(void)
{
  106fa0:	83 ec 0c             	sub    $0xc,%esp
    return CURID[get_pcpu_idx()];
  106fa3:	e8 88 ea ff ff       	call   105a30 <get_pcpu_idx>
  106fa8:	8b 04 85 60 ec e1 00 	mov    0xe1ec60(,%eax,4),%eax
}
  106faf:	83 c4 0c             	add    $0xc,%esp
  106fb2:	c3                   	ret    
  106fb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106fc0 <set_curid>:

void set_curid(unsigned int curid)
{
  106fc0:	83 ec 0c             	sub    $0xc,%esp
    CURID[get_pcpu_idx()] = curid;
  106fc3:	e8 68 ea ff ff       	call   105a30 <get_pcpu_idx>
  106fc8:	8b 54 24 10          	mov    0x10(%esp),%edx
  106fcc:	89 14 85 60 ec e1 00 	mov    %edx,0xe1ec60(,%eax,4)
}
  106fd3:	83 c4 0c             	add    $0xc,%esp
  106fd6:	c3                   	ret    
  106fd7:	66 90                	xchg   %ax,%ax
  106fd9:	66 90                	xchg   %ax,%ax
  106fdb:	66 90                	xchg   %ax,%ax
  106fdd:	66 90                	xchg   %ax,%ax
  106fdf:	90                   	nop

00106fe0 <thread_init>:
static spinlock_t sched_lks[NUM_CPUS];

static unsigned int sched_ticks[NUM_CPUS];

void thread_init(unsigned int mbi_addr)
{
  106fe0:	53                   	push   %ebx
    int i;
    for (i = 0; i < NUM_CPUS; i++) {
  106fe1:	31 db                	xor    %ebx,%ebx
{
  106fe3:	83 ec 08             	sub    $0x8,%esp
  106fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106fed:	8d 76 00             	lea    0x0(%esi),%esi
        sched_ticks[i] = 0;
        spinlock_init(&sched_lks[i]);
  106ff0:	83 ec 0c             	sub    $0xc,%esp
  106ff3:	8d 04 dd 00 28 95 00 	lea    0x952800(,%ebx,8),%eax
        sched_ticks[i] = 0;
  106ffa:	c7 04 9d e0 27 95 00 	movl   $0x0,0x9527e0(,%ebx,4)
  107001:	00 00 00 00 
    for (i = 0; i < NUM_CPUS; i++) {
  107005:	83 c3 01             	add    $0x1,%ebx
        spinlock_init(&sched_lks[i]);
  107008:	50                   	push   %eax
  107009:	e8 02 dd ff ff       	call   104d10 <spinlock_init>
    for (i = 0; i < NUM_CPUS; i++) {
  10700e:	83 c4 10             	add    $0x10,%esp
  107011:	83 fb 08             	cmp    $0x8,%ebx
  107014:	75 da                	jne    106ff0 <thread_init+0x10>
    }
    tqueue_init(mbi_addr);
  107016:	83 ec 0c             	sub    $0xc,%esp
  107019:	ff 74 24 1c          	pushl  0x1c(%esp)
  10701d:	e8 5e fd ff ff       	call   106d80 <tqueue_init>
    set_curid(0);
  107022:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  107029:	e8 92 ff ff ff       	call   106fc0 <set_curid>
    tcb_set_state(0, TSTATE_RUN);
  10702e:	58                   	pop    %eax
  10702f:	5a                   	pop    %edx
  107030:	6a 01                	push   $0x1
  107032:	6a 00                	push   $0x0
  107034:	e8 c7 fb ff ff       	call   106c00 <tcb_set_state>
}
  107039:	83 c4 18             	add    $0x18,%esp
  10703c:	5b                   	pop    %ebx
  10703d:	c3                   	ret    
  10703e:	66 90                	xchg   %ax,%ax

00107040 <thread_spawn>:
 * Allocates a new child thread context, sets the state of the new child thread
 * to ready, and pushes it to the ready queue.
 * It returns the child thread id.
 */
unsigned int thread_spawn(void *entry, unsigned int id, unsigned int quota)
{
  107040:	53                   	push   %ebx
  107041:	83 ec 08             	sub    $0x8,%esp
    unsigned int pid;
    spinlock_acquire(&sched_lks[get_pcpu_idx()]);
  107044:	e8 e7 e9 ff ff       	call   105a30 <get_pcpu_idx>
  107049:	83 ec 0c             	sub    $0xc,%esp
  10704c:	8d 04 c5 00 28 95 00 	lea    0x952800(,%eax,8),%eax
  107053:	50                   	push   %eax
  107054:	e8 47 dd ff ff       	call   104da0 <spinlock_acquire>

    pid = kctx_new(entry, id, quota);
  107059:	83 c4 0c             	add    $0xc,%esp
  10705c:	ff 74 24 1c          	pushl  0x1c(%esp)
  107060:	ff 74 24 1c          	pushl  0x1c(%esp)
  107064:	ff 74 24 1c          	pushl  0x1c(%esp)
  107068:	e8 13 fb ff ff       	call   106b80 <kctx_new>
    if (pid != NUM_IDS) {
  10706d:	83 c4 10             	add    $0x10,%esp
    pid = kctx_new(entry, id, quota);
  107070:	89 c3                	mov    %eax,%ebx
    if (pid != NUM_IDS) {
  107072:	83 f8 40             	cmp    $0x40,%eax
  107075:	74 2d                	je     1070a4 <thread_spawn+0x64>
        tcb_set_cpu(pid, get_pcpu_idx());
  107077:	e8 b4 e9 ff ff       	call   105a30 <get_pcpu_idx>
  10707c:	83 ec 08             	sub    $0x8,%esp
  10707f:	50                   	push   %eax
  107080:	53                   	push   %ebx
  107081:	e8 aa fb ff ff       	call   106c30 <tcb_set_cpu>
        tcb_set_state(pid, TSTATE_READY);
  107086:	58                   	pop    %eax
  107087:	5a                   	pop    %edx
  107088:	6a 00                	push   $0x0
  10708a:	53                   	push   %ebx
  10708b:	e8 70 fb ff ff       	call   106c00 <tcb_set_state>
        tqueue_enqueue(NUM_IDS + get_pcpu_idx(), pid);
  107090:	e8 9b e9 ff ff       	call   105a30 <get_pcpu_idx>
  107095:	59                   	pop    %ecx
  107096:	5a                   	pop    %edx
  107097:	53                   	push   %ebx
  107098:	83 c0 40             	add    $0x40,%eax
  10709b:	50                   	push   %eax
  10709c:	e8 1f fd ff ff       	call   106dc0 <tqueue_enqueue>
  1070a1:	83 c4 10             	add    $0x10,%esp
    }

    spinlock_release(&sched_lks[get_pcpu_idx()]);
  1070a4:	e8 87 e9 ff ff       	call   105a30 <get_pcpu_idx>
  1070a9:	83 ec 0c             	sub    $0xc,%esp
  1070ac:	8d 04 c5 00 28 95 00 	lea    0x952800(,%eax,8),%eax
  1070b3:	50                   	push   %eax
  1070b4:	e8 57 dd ff ff       	call   104e10 <spinlock_release>
    return pid;
}
  1070b9:	83 c4 18             	add    $0x18,%esp
  1070bc:	89 d8                	mov    %ebx,%eax
  1070be:	5b                   	pop    %ebx
  1070bf:	c3                   	ret    

001070c0 <thread_copy>:

/*
 * Create a thread that has the same memory space as the parent thread
 */
unsigned int thread_copy(void *entry, unsigned int id, unsigned int cpu_idx)
{            
  1070c0:	55                   	push   %ebp
  1070c1:	57                   	push   %edi
  1070c2:	56                   	push   %esi
  1070c3:	53                   	push   %ebx
  1070c4:	83 ec 18             	sub    $0x18,%esp
  1070c7:	8b 7c 24 34          	mov    0x34(%esp),%edi
  1070cb:	8b 74 24 30          	mov    0x30(%esp),%esi
    spinlock_acquire(&sched_lks[cpu_idx]);
  1070cf:	8d 2c fd 00 28 95 00 	lea    0x952800(,%edi,8),%ebp
  1070d6:	55                   	push   %ebp
  1070d7:	e8 c4 dc ff ff       	call   104da0 <spinlock_acquire>

    unsigned int quota = (container_get_quota(id) - container_get_usage(id)) / 2;
  1070dc:	89 34 24             	mov    %esi,(%esp)
  1070df:	e8 ac f1 ff ff       	call   106290 <container_get_quota>
  1070e4:	89 34 24             	mov    %esi,(%esp)
  1070e7:	89 c3                	mov    %eax,%ebx
  1070e9:	e8 b2 f1 ff ff       	call   1062a0 <container_get_usage>
    unsigned int pid = kctx_new(entry, id, quota);
  1070ee:	83 c4 0c             	add    $0xc,%esp
    unsigned int quota = (container_get_quota(id) - container_get_usage(id)) / 2;
  1070f1:	29 c3                	sub    %eax,%ebx
  1070f3:	d1 eb                	shr    %ebx
    unsigned int pid = kctx_new(entry, id, quota);
  1070f5:	53                   	push   %ebx
  1070f6:	56                   	push   %esi
  1070f7:	ff 74 24 2c          	pushl  0x2c(%esp)
  1070fb:	e8 80 fa ff ff       	call   106b80 <kctx_new>
    if (pid != NUM_IDS) {
  107100:	83 c4 10             	add    $0x10,%esp
    unsigned int pid = kctx_new(entry, id, quota);
  107103:	89 c3                	mov    %eax,%ebx
    if (pid != NUM_IDS) {
  107105:	83 f8 40             	cmp    $0x40,%eax
  107108:	74 2c                	je     107136 <thread_copy+0x76>
	map_vm(id, pid);
  10710a:	83 ec 08             	sub    $0x8,%esp
  10710d:	50                   	push   %eax
  10710e:	56                   	push   %esi
  10710f:	e8 9c f9 ff ff       	call   106ab0 <map_vm>

	tcb_set_cpu(pid, cpu_idx);
  107114:	58                   	pop    %eax
  107115:	5a                   	pop    %edx
  107116:	57                   	push   %edi
  107117:	53                   	push   %ebx
	tcb_set_state(pid, TSTATE_READY);
	tqueue_enqueue(NUM_IDS + cpu_idx, pid);
  107118:	83 c7 40             	add    $0x40,%edi
	tcb_set_cpu(pid, cpu_idx);
  10711b:	e8 10 fb ff ff       	call   106c30 <tcb_set_cpu>
	tcb_set_state(pid, TSTATE_READY);
  107120:	59                   	pop    %ecx
  107121:	5e                   	pop    %esi
  107122:	6a 00                	push   $0x0
  107124:	53                   	push   %ebx
  107125:	e8 d6 fa ff ff       	call   106c00 <tcb_set_state>
	tqueue_enqueue(NUM_IDS + cpu_idx, pid);
  10712a:	58                   	pop    %eax
  10712b:	5a                   	pop    %edx
  10712c:	53                   	push   %ebx
  10712d:	57                   	push   %edi
  10712e:	e8 8d fc ff ff       	call   106dc0 <tqueue_enqueue>
  107133:	83 c4 10             	add    $0x10,%esp
    }

    spinlock_release(&sched_lks[cpu_idx]);
  107136:	83 ec 0c             	sub    $0xc,%esp
  107139:	55                   	push   %ebp
  10713a:	e8 d1 dc ff ff       	call   104e10 <spinlock_release>
    return pid;
}
  10713f:	83 c4 1c             	add    $0x1c,%esp
  107142:	89 d8                	mov    %ebx,%eax
  107144:	5b                   	pop    %ebx
  107145:	5e                   	pop    %esi
  107146:	5f                   	pop    %edi
  107147:	5d                   	pop    %ebp
  107148:	c3                   	ret    
  107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00107150 <thread_yield>:
 * current thread id, and switch to the new kernel context.
 * Hint: If you are the only thread that is ready to run,
 * do you need to switch to yourself?
 */
void thread_yield(void)
{
  107150:	56                   	push   %esi
  107151:	53                   	push   %ebx
  107152:	83 ec 04             	sub    $0x4,%esp
    unsigned int new_cur_pid;
    unsigned int old_cur_pid;
    spinlock_acquire(&sched_lks[get_pcpu_idx()]);
  107155:	e8 d6 e8 ff ff       	call   105a30 <get_pcpu_idx>
  10715a:	83 ec 0c             	sub    $0xc,%esp
  10715d:	8d 04 c5 00 28 95 00 	lea    0x952800(,%eax,8),%eax
  107164:	50                   	push   %eax
  107165:	e8 36 dc ff ff       	call   104da0 <spinlock_acquire>

    old_cur_pid = get_curid();
  10716a:	e8 31 fe ff ff       	call   106fa0 <get_curid>
    tcb_set_state(old_cur_pid, TSTATE_READY);
  10716f:	5a                   	pop    %edx
  107170:	59                   	pop    %ecx
  107171:	6a 00                	push   $0x0
  107173:	50                   	push   %eax
    old_cur_pid = get_curid();
  107174:	89 c3                	mov    %eax,%ebx
    tcb_set_state(old_cur_pid, TSTATE_READY);
  107176:	e8 85 fa ff ff       	call   106c00 <tcb_set_state>
    tqueue_enqueue(NUM_IDS + get_pcpu_idx(), old_cur_pid);
  10717b:	e8 b0 e8 ff ff       	call   105a30 <get_pcpu_idx>
  107180:	5e                   	pop    %esi
  107181:	5a                   	pop    %edx
  107182:	53                   	push   %ebx
  107183:	83 c0 40             	add    $0x40,%eax
  107186:	50                   	push   %eax
  107187:	e8 34 fc ff ff       	call   106dc0 <tqueue_enqueue>

    new_cur_pid = tqueue_dequeue(NUM_IDS + get_pcpu_idx());
  10718c:	e8 9f e8 ff ff       	call   105a30 <get_pcpu_idx>
  107191:	83 c0 40             	add    $0x40,%eax
  107194:	89 04 24             	mov    %eax,(%esp)
  107197:	e8 94 fc ff ff       	call   106e30 <tqueue_dequeue>
    tcb_set_state(new_cur_pid, TSTATE_RUN);
  10719c:	59                   	pop    %ecx
  10719d:	5a                   	pop    %edx
  10719e:	6a 01                	push   $0x1
  1071a0:	50                   	push   %eax
    new_cur_pid = tqueue_dequeue(NUM_IDS + get_pcpu_idx());
  1071a1:	89 c6                	mov    %eax,%esi
    tcb_set_state(new_cur_pid, TSTATE_RUN);
  1071a3:	e8 58 fa ff ff       	call   106c00 <tcb_set_state>
    set_curid(new_cur_pid);
  1071a8:	89 34 24             	mov    %esi,(%esp)
  1071ab:	e8 10 fe ff ff       	call   106fc0 <set_curid>

    spinlock_release(&sched_lks[get_pcpu_idx()]);
  1071b0:	e8 7b e8 ff ff       	call   105a30 <get_pcpu_idx>
  1071b5:	8d 04 c5 00 28 95 00 	lea    0x952800(,%eax,8),%eax
  1071bc:	89 04 24             	mov    %eax,(%esp)
  1071bf:	e8 4c dc ff ff       	call   104e10 <spinlock_release>

    if (old_cur_pid != new_cur_pid) {
  1071c4:	83 c4 10             	add    $0x10,%esp
  1071c7:	39 f3                	cmp    %esi,%ebx
  1071c9:	74 0d                	je     1071d8 <thread_yield+0x88>
        kctx_switch(old_cur_pid, new_cur_pid);
  1071cb:	83 ec 08             	sub    $0x8,%esp
  1071ce:	56                   	push   %esi
  1071cf:	53                   	push   %ebx
  1071d0:	e8 4b f9 ff ff       	call   106b20 <kctx_switch>
  1071d5:	83 c4 10             	add    $0x10,%esp
    }
}
  1071d8:	83 c4 04             	add    $0x4,%esp
  1071db:	5b                   	pop    %ebx
  1071dc:	5e                   	pop    %esi
  1071dd:	c3                   	ret    
  1071de:	66 90                	xchg   %ax,%ax

001071e0 <thread_suspend>:

void thread_suspend(spinlock_t *lk, unsigned int old_cur_pid)
{
  1071e0:	57                   	push   %edi
  1071e1:	56                   	push   %esi
  1071e2:	53                   	push   %ebx
  1071e3:	8b 7c 24 10          	mov    0x10(%esp),%edi
  1071e7:	8b 74 24 14          	mov    0x14(%esp),%esi
    unsigned int new_cur_pid;
    spinlock_acquire(&sched_lks[get_pcpu_idx()]);
  1071eb:	e8 40 e8 ff ff       	call   105a30 <get_pcpu_idx>
  1071f0:	83 ec 0c             	sub    $0xc,%esp
  1071f3:	8d 04 c5 00 28 95 00 	lea    0x952800(,%eax,8),%eax
  1071fa:	50                   	push   %eax
  1071fb:	e8 a0 db ff ff       	call   104da0 <spinlock_acquire>
    KERN_ASSERT(old_cur_pid == get_curid());
  107200:	e8 9b fd ff ff       	call   106fa0 <get_curid>
  107205:	83 c4 10             	add    $0x10,%esp
  107208:	39 f0                	cmp    %esi,%eax
  10720a:	74 19                	je     107225 <thread_suspend+0x45>
  10720c:	68 a5 a8 10 00       	push   $0x10a8a5
  107211:	68 df 92 10 00       	push   $0x1092df
  107216:	6a 69                	push   $0x69
  107218:	68 c0 a8 10 00       	push   $0x10a8c0
  10721d:	e8 2e c6 ff ff       	call   103850 <debug_panic>
  107222:	83 c4 10             	add    $0x10,%esp

    new_cur_pid = tqueue_dequeue(NUM_IDS + get_pcpu_idx());
  107225:	e8 06 e8 ff ff       	call   105a30 <get_pcpu_idx>
  10722a:	83 ec 0c             	sub    $0xc,%esp
  10722d:	83 c0 40             	add    $0x40,%eax
  107230:	50                   	push   %eax
  107231:	e8 fa fb ff ff       	call   106e30 <tqueue_dequeue>
    KERN_ASSERT(new_cur_pid != NUM_IDS);
  107236:	83 c4 10             	add    $0x10,%esp
    new_cur_pid = tqueue_dequeue(NUM_IDS + get_pcpu_idx());
  107239:	89 c3                	mov    %eax,%ebx
    KERN_ASSERT(new_cur_pid != NUM_IDS);
  10723b:	83 f8 40             	cmp    $0x40,%eax
  10723e:	74 50                	je     107290 <thread_suspend+0xb0>

    spinlock_release(lk);
  107240:	83 ec 0c             	sub    $0xc,%esp
  107243:	57                   	push   %edi
  107244:	e8 c7 db ff ff       	call   104e10 <spinlock_release>

    tcb_set_state(old_cur_pid, TSTATE_SLEEP);
  107249:	58                   	pop    %eax
  10724a:	5a                   	pop    %edx
  10724b:	6a 02                	push   $0x2
  10724d:	56                   	push   %esi
  10724e:	e8 ad f9 ff ff       	call   106c00 <tcb_set_state>
    tcb_set_state(new_cur_pid, TSTATE_RUN);
  107253:	59                   	pop    %ecx
  107254:	5f                   	pop    %edi
  107255:	6a 01                	push   $0x1
  107257:	53                   	push   %ebx
  107258:	e8 a3 f9 ff ff       	call   106c00 <tcb_set_state>
    set_curid(new_cur_pid);
  10725d:	89 1c 24             	mov    %ebx,(%esp)
  107260:	e8 5b fd ff ff       	call   106fc0 <set_curid>

    spinlock_release(&sched_lks[get_pcpu_idx()]);
  107265:	e8 c6 e7 ff ff       	call   105a30 <get_pcpu_idx>
  10726a:	8d 04 c5 00 28 95 00 	lea    0x952800(,%eax,8),%eax
  107271:	89 04 24             	mov    %eax,(%esp)
  107274:	e8 97 db ff ff       	call   104e10 <spinlock_release>

    kctx_switch(old_cur_pid, new_cur_pid);
  107279:	83 c4 10             	add    $0x10,%esp
  10727c:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  107280:	89 74 24 10          	mov    %esi,0x10(%esp)
}
  107284:	5b                   	pop    %ebx
  107285:	5e                   	pop    %esi
  107286:	5f                   	pop    %edi
    kctx_switch(old_cur_pid, new_cur_pid);
  107287:	e9 94 f8 ff ff       	jmp    106b20 <kctx_switch>
  10728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    KERN_ASSERT(new_cur_pid != NUM_IDS);
  107290:	68 de a8 10 00       	push   $0x10a8de
  107295:	68 df 92 10 00       	push   $0x1092df
  10729a:	6a 6c                	push   $0x6c
  10729c:	68 c0 a8 10 00       	push   $0x10a8c0
  1072a1:	e8 aa c5 ff ff       	call   103850 <debug_panic>
  1072a6:	83 c4 10             	add    $0x10,%esp
  1072a9:	eb 95                	jmp    107240 <thread_suspend+0x60>
  1072ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1072af:	90                   	nop

001072b0 <thread_ready>:

void thread_ready(unsigned int pid)
{
  1072b0:	53                   	push   %ebx
  1072b1:	83 ec 14             	sub    $0x14,%esp
  1072b4:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    spinlock_acquire(&sched_lks[tcb_get_cpu(pid)]);
  1072b8:	53                   	push   %ebx
  1072b9:	e8 62 f9 ff ff       	call   106c20 <tcb_get_cpu>
  1072be:	8d 04 c5 00 28 95 00 	lea    0x952800(,%eax,8),%eax
  1072c5:	89 04 24             	mov    %eax,(%esp)
  1072c8:	e8 d3 da ff ff       	call   104da0 <spinlock_acquire>

    tcb_set_state(pid, TSTATE_READY);
  1072cd:	58                   	pop    %eax
  1072ce:	5a                   	pop    %edx
  1072cf:	6a 00                	push   $0x0
  1072d1:	53                   	push   %ebx
  1072d2:	e8 29 f9 ff ff       	call   106c00 <tcb_set_state>
    tqueue_enqueue(NUM_IDS + tcb_get_cpu(pid), pid);
  1072d7:	89 1c 24             	mov    %ebx,(%esp)
  1072da:	e8 41 f9 ff ff       	call   106c20 <tcb_get_cpu>
  1072df:	59                   	pop    %ecx
  1072e0:	5a                   	pop    %edx
  1072e1:	53                   	push   %ebx
  1072e2:	83 c0 40             	add    $0x40,%eax
  1072e5:	50                   	push   %eax
  1072e6:	e8 d5 fa ff ff       	call   106dc0 <tqueue_enqueue>

    spinlock_release(&sched_lks[tcb_get_cpu(pid)]);
  1072eb:	89 1c 24             	mov    %ebx,(%esp)
  1072ee:	e8 2d f9 ff ff       	call   106c20 <tcb_get_cpu>
  1072f3:	8d 04 c5 00 28 95 00 	lea    0x952800(,%eax,8),%eax
  1072fa:	89 44 24 20          	mov    %eax,0x20(%esp)
}
  1072fe:	83 c4 18             	add    $0x18,%esp
  107301:	5b                   	pop    %ebx
    spinlock_release(&sched_lks[tcb_get_cpu(pid)]);
  107302:	e9 09 db ff ff       	jmp    104e10 <spinlock_release>
  107307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10730e:	66 90                	xchg   %ax,%ax

00107310 <sched_update>:

void sched_update(void)
{
  107310:	83 ec 0c             	sub    $0xc,%esp
    sched_ticks[get_pcpu_idx()] += 1000 / LAPIC_TIMER_INTR_FREQ;
  107313:	e8 18 e7 ff ff       	call   105a30 <get_pcpu_idx>
  107318:	83 04 85 e0 27 95 00 	addl   $0x1,0x9527e0(,%eax,4)
  10731f:	01 
    if (sched_ticks[get_pcpu_idx()] >= SCHED_SLICE) {
  107320:	e8 0b e7 ff ff       	call   105a30 <get_pcpu_idx>
  107325:	83 3c 85 e0 27 95 00 	cmpl   $0x4,0x9527e0(,%eax,4)
  10732c:	04 
  10732d:	77 09                	ja     107338 <sched_update+0x28>
        sched_ticks[get_pcpu_idx()] = 0;
        thread_yield();
    }
}
  10732f:	83 c4 0c             	add    $0xc,%esp
  107332:	c3                   	ret    
  107333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  107337:	90                   	nop
        sched_ticks[get_pcpu_idx()] = 0;
  107338:	e8 f3 e6 ff ff       	call   105a30 <get_pcpu_idx>
  10733d:	c7 04 85 e0 27 95 00 	movl   $0x0,0x9527e0(,%eax,4)
  107344:	00 00 00 00 
}
  107348:	83 c4 0c             	add    $0xc,%esp
        thread_yield();
  10734b:	e9 00 fe ff ff       	jmp    107150 <thread_yield>

00107350 <proc_start_user>:
#include "import.h"

extern tf_t uctx_pool[NUM_IDS];

void proc_start_user(void)
{
  107350:	53                   	push   %ebx
  107351:	83 ec 08             	sub    $0x8,%esp
    unsigned int cur_pid;

    cur_pid = get_curid();
  107354:	e8 47 fc ff ff       	call   106fa0 <get_curid>

    kstack_switch(cur_pid);
  107359:	83 ec 0c             	sub    $0xc,%esp
  10735c:	50                   	push   %eax
    cur_pid = get_curid();
  10735d:	89 c3                	mov    %eax,%ebx
    kstack_switch(cur_pid);
  10735f:	e8 4c cc ff ff       	call   103fb0 <kstack_switch>
    set_pdir_base(cur_pid);
  107364:	89 1c 24             	mov    %ebx,(%esp)

    trap_return((void *) &uctx_pool[cur_pid]);
  107367:	6b db 44             	imul   $0x44,%ebx,%ebx
    set_pdir_base(cur_pid);
  10736a:	e8 e1 f0 ff ff       	call   106450 <set_pdir_base>
    trap_return((void *) &uctx_pool[cur_pid]);
  10736f:	81 c3 80 ec e1 00    	add    $0xe1ec80,%ebx
  107375:	89 1c 24             	mov    %ebx,(%esp)
  107378:	e8 33 aa ff ff       	call   101db0 <trap_return>
}
  10737d:	83 c4 18             	add    $0x18,%esp
  107380:	5b                   	pop    %ebx
  107381:	c3                   	ret    
  107382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00107390 <proc_create>:

unsigned int proc_create(void *elf_addr, unsigned int quota)
{
  107390:	56                   	push   %esi
  107391:	53                   	push   %ebx
  107392:	83 ec 04             	sub    $0x4,%esp
    unsigned int pid, id;

    id = get_curid();
  107395:	e8 06 fc ff ff       	call   106fa0 <get_curid>
    pid = thread_spawn((void *) proc_start_user, id, quota);
  10739a:	83 ec 04             	sub    $0x4,%esp
  10739d:	ff 74 24 18          	pushl  0x18(%esp)
  1073a1:	50                   	push   %eax
  1073a2:	68 50 73 10 00       	push   $0x107350
  1073a7:	e8 94 fc ff ff       	call   107040 <thread_spawn>

    if (pid != NUM_IDS) {
  1073ac:	83 c4 10             	add    $0x10,%esp
    pid = thread_spawn((void *) proc_start_user, id, quota);
  1073af:	89 c3                	mov    %eax,%ebx
    if (pid != NUM_IDS) {
  1073b1:	83 f8 40             	cmp    $0x40,%eax
  1073b4:	74 75                	je     10742b <proc_create+0x9b>
        elf_load(elf_addr, pid);
  1073b6:	83 ec 08             	sub    $0x8,%esp

        uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  1073b9:	6b f3 44             	imul   $0x44,%ebx,%esi
        elf_load(elf_addr, pid);
  1073bc:	50                   	push   %eax
  1073bd:	ff 74 24 1c          	pushl  0x1c(%esp)
  1073c1:	e8 ca d6 ff ff       	call   104a90 <elf_load>
        uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  1073c6:	b8 23 00 00 00       	mov    $0x23,%eax
        uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
  1073cb:	ba 23 00 00 00       	mov    $0x23,%edx
        uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
  1073d0:	b9 1b 00 00 00       	mov    $0x1b,%ecx
        uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  1073d5:	66 89 86 a0 ec e1 00 	mov    %ax,0xe1eca0(%esi)
        uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
  1073dc:	b8 23 00 00 00       	mov    $0x23,%eax
  1073e1:	66 89 86 c0 ec e1 00 	mov    %ax,0xe1ecc0(%esi)
        uctx_pool[pid].esp = VM_USERHI;
        uctx_pool[pid].eflags = FL_IF;
        uctx_pool[pid].eip = elf_entry(elf_addr);
  1073e8:	58                   	pop    %eax
  1073e9:	ff 74 24 1c          	pushl  0x1c(%esp)
        uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
  1073ed:	66 89 96 a4 ec e1 00 	mov    %dx,0xe1eca4(%esi)
        uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
  1073f4:	66 89 8e b4 ec e1 00 	mov    %cx,0xe1ecb4(%esi)
        uctx_pool[pid].esp = VM_USERHI;
  1073fb:	c7 86 bc ec e1 00 00 	movl   $0xf0000000,0xe1ecbc(%esi)
  107402:	00 00 f0 
        uctx_pool[pid].eflags = FL_IF;
  107405:	c7 86 b8 ec e1 00 00 	movl   $0x200,0xe1ecb8(%esi)
  10740c:	02 00 00 
        uctx_pool[pid].eip = elf_entry(elf_addr);
  10740f:	e8 7c d8 ff ff       	call   104c90 <elf_entry>
  107414:	89 86 b0 ec e1 00    	mov    %eax,0xe1ecb0(%esi)

        seg_init_proc(get_pcpu_idx(), pid);
  10741a:	e8 11 e6 ff ff       	call   105a30 <get_pcpu_idx>
  10741f:	5a                   	pop    %edx
  107420:	59                   	pop    %ecx
  107421:	53                   	push   %ebx
  107422:	50                   	push   %eax
  107423:	e8 a8 cd ff ff       	call   1041d0 <seg_init_proc>
  107428:	83 c4 10             	add    $0x10,%esp
    }

    return pid;
}
  10742b:	83 c4 04             	add    $0x4,%esp
  10742e:	89 d8                	mov    %ebx,%eax
  107430:	5b                   	pop    %ebx
  107431:	5e                   	pop    %esi
  107432:	c3                   	ret    
  107433:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107440 <thread_create>:

// Create a thread that shares the same memory space with the parent process
unsigned int thread_create(uintptr_t eip, uintptr_t esp) {
  107440:	56                   	push   %esi
    unsigned int pid, id;

    static int cpu_idx = 1;
    cpu_idx = (cpu_idx + 1) % 3;
  107441:	ba 56 55 55 55       	mov    $0x55555556,%edx
unsigned int thread_create(uintptr_t eip, uintptr_t esp) {
  107446:	53                   	push   %ebx
  107447:	83 ec 04             	sub    $0x4,%esp
    cpu_idx = (cpu_idx + 1) % 3;
  10744a:	a1 0c 13 11 00       	mov    0x11130c,%eax
  10744f:	8d 48 01             	lea    0x1(%eax),%ecx
  107452:	89 c8                	mov    %ecx,%eax
  107454:	f7 ea                	imul   %edx
  107456:	89 c8                	mov    %ecx,%eax
  107458:	c1 f8 1f             	sar    $0x1f,%eax
  10745b:	29 c2                	sub    %eax,%edx
  10745d:	8d 04 52             	lea    (%edx,%edx,2),%eax
  107460:	29 c1                	sub    %eax,%ecx
  107462:	b8 01 00 00 00       	mov    $0x1,%eax
  107467:	89 ca                	mov    %ecx,%edx
  107469:	0f 44 d0             	cmove  %eax,%edx
  10746c:	89 15 0c 13 11 00    	mov    %edx,0x11130c
    if (cpu_idx == 0) {
	++cpu_idx;
    }

    id = get_curid();
  107472:	e8 29 fb ff ff       	call   106fa0 <get_curid>
    pid = thread_copy((void *)proc_start_user, id, cpu_idx);
  107477:	83 ec 04             	sub    $0x4,%esp
  10747a:	ff 35 0c 13 11 00    	pushl  0x11130c
  107480:	50                   	push   %eax
    id = get_curid();
  107481:	89 c3                	mov    %eax,%ebx
    pid = thread_copy((void *)proc_start_user, id, cpu_idx);
  107483:	68 50 73 10 00       	push   $0x107350
  107488:	e8 33 fc ff ff       	call   1070c0 <thread_copy>

    if (pid != NUM_IDS) {
  10748d:	83 c4 10             	add    $0x10,%esp
    pid = thread_copy((void *)proc_start_user, id, cpu_idx);
  107490:	89 c6                	mov    %eax,%esi
    if (pid != NUM_IDS) {
  107492:	83 f8 40             	cmp    $0x40,%eax
  107495:	74 3d                	je     1074d4 <thread_create+0x94>
        // Copy user context and set child return value
        memcpy(&uctx_pool[pid], &uctx_pool[id], sizeof(struct tf_t));
  107497:	6b db 44             	imul   $0x44,%ebx,%ebx
  10749a:	83 ec 04             	sub    $0x4,%esp
  10749d:	6a 44                	push   $0x44
  10749f:	81 c3 80 ec e1 00    	add    $0xe1ec80,%ebx
  1074a5:	53                   	push   %ebx
  1074a6:	6b d8 44             	imul   $0x44,%eax,%ebx
  1074a9:	81 c3 80 ec e1 00    	add    $0xe1ec80,%ebx
  1074af:	53                   	push   %ebx
  1074b0:	e8 3b c1 ff ff       	call   1035f0 <memcpy>

	uctx_pool[pid].eip = eip;
  1074b5:	8b 44 24 20          	mov    0x20(%esp),%eax
  1074b9:	89 43 30             	mov    %eax,0x30(%ebx)
	uctx_pool[pid].esp = esp;
  1074bc:	8b 44 24 24          	mov    0x24(%esp),%eax
  1074c0:	89 43 3c             	mov    %eax,0x3c(%ebx)

	seg_init_proc(cpu_idx, pid);
  1074c3:	58                   	pop    %eax
  1074c4:	5a                   	pop    %edx
  1074c5:	56                   	push   %esi
  1074c6:	ff 35 0c 13 11 00    	pushl  0x11130c
  1074cc:	e8 ff cc ff ff       	call   1041d0 <seg_init_proc>
  1074d1:	83 c4 10             	add    $0x10,%esp
    }

    return pid;
}
  1074d4:	83 c4 04             	add    $0x4,%esp
  1074d7:	89 f0                	mov    %esi,%eax
  1074d9:	5b                   	pop    %ebx
  1074da:	5e                   	pop    %esi
  1074db:	c3                   	ret    
  1074dc:	66 90                	xchg   %ax,%ax
  1074de:	66 90                	xchg   %ax,%ax

001074e0 <syscall_get_arg1>:
 * Retrieves the system call arguments from uctx_pool that get
 * passed in from the current running process' system call.
 */
unsigned int syscall_get_arg1(tf_t *tf)
{
    return tf->regs.eax;
  1074e0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1074e4:	8b 40 1c             	mov    0x1c(%eax),%eax
}
  1074e7:	c3                   	ret    
  1074e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1074ef:	90                   	nop

001074f0 <syscall_get_arg2>:

unsigned int syscall_get_arg2(tf_t *tf)
{
    return tf->regs.ebx;
  1074f0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1074f4:	8b 40 10             	mov    0x10(%eax),%eax
}
  1074f7:	c3                   	ret    
  1074f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1074ff:	90                   	nop

00107500 <syscall_get_arg3>:

unsigned int syscall_get_arg3(tf_t *tf)
{
    return tf->regs.ecx;
  107500:	8b 44 24 04          	mov    0x4(%esp),%eax
  107504:	8b 40 18             	mov    0x18(%eax),%eax
}
  107507:	c3                   	ret    
  107508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10750f:	90                   	nop

00107510 <syscall_get_arg4>:

unsigned int syscall_get_arg4(tf_t *tf)
{
    return tf->regs.edx;
  107510:	8b 44 24 04          	mov    0x4(%esp),%eax
  107514:	8b 40 14             	mov    0x14(%eax),%eax
}
  107517:	c3                   	ret    
  107518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10751f:	90                   	nop

00107520 <syscall_get_arg5>:

unsigned int syscall_get_arg5(tf_t *tf)
{
    return tf->regs.esi;
  107520:	8b 44 24 04          	mov    0x4(%esp),%eax
  107524:	8b 40 04             	mov    0x4(%eax),%eax
}
  107527:	c3                   	ret    
  107528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10752f:	90                   	nop

00107530 <syscall_get_arg6>:

unsigned int syscall_get_arg6(tf_t *tf)
{
    return tf->regs.edi;
  107530:	8b 44 24 04          	mov    0x4(%esp),%eax
  107534:	8b 00                	mov    (%eax),%eax
}
  107536:	c3                   	ret    
  107537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10753e:	66 90                	xchg   %ax,%ax

00107540 <syscall_set_errno>:
 * Sets the error number in uctx_pool that gets passed
 * to the current running process when we return to it.
 */
void syscall_set_errno(tf_t *tf, unsigned int errno)
{
    tf->regs.eax = errno;
  107540:	8b 44 24 04          	mov    0x4(%esp),%eax
  107544:	8b 54 24 08          	mov    0x8(%esp),%edx
  107548:	89 50 1c             	mov    %edx,0x1c(%eax)
}
  10754b:	c3                   	ret    
  10754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107550 <syscall_set_retval1>:
 * Sets the return values in uctx_pool that get passed
 * to the current running process when we return to it.
 */
void syscall_set_retval1(tf_t *tf, unsigned int retval)
{
    tf->regs.ebx = retval;
  107550:	8b 44 24 04          	mov    0x4(%esp),%eax
  107554:	8b 54 24 08          	mov    0x8(%esp),%edx
  107558:	89 50 10             	mov    %edx,0x10(%eax)
}
  10755b:	c3                   	ret    
  10755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107560 <syscall_set_retval2>:

void syscall_set_retval2(tf_t *tf, unsigned int retval)
{
    tf->regs.ecx = retval;
  107560:	8b 44 24 04          	mov    0x4(%esp),%eax
  107564:	8b 54 24 08          	mov    0x8(%esp),%edx
  107568:	89 50 18             	mov    %edx,0x18(%eax)
}
  10756b:	c3                   	ret    
  10756c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107570 <syscall_set_retval3>:

void syscall_set_retval3(tf_t *tf, unsigned int retval)
{
    tf->regs.edx = retval;
  107570:	8b 44 24 04          	mov    0x4(%esp),%eax
  107574:	8b 54 24 08          	mov    0x8(%esp),%edx
  107578:	89 50 14             	mov    %edx,0x14(%eax)
}
  10757b:	c3                   	ret    
  10757c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107580 <syscall_set_retval4>:

void syscall_set_retval4(tf_t *tf, unsigned int retval)
{
    tf->regs.esi = retval;
  107580:	8b 44 24 04          	mov    0x4(%esp),%eax
  107584:	8b 54 24 08          	mov    0x8(%esp),%edx
  107588:	89 50 04             	mov    %edx,0x4(%eax)
}
  10758b:	c3                   	ret    
  10758c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107590 <syscall_set_retval5>:

void syscall_set_retval5(tf_t *tf, unsigned int retval)
{
    tf->regs.edi = retval;
  107590:	8b 44 24 04          	mov    0x4(%esp),%eax
  107594:	8b 54 24 08          	mov    0x8(%esp),%edx
  107598:	89 10                	mov    %edx,(%eax)
}
  10759a:	c3                   	ret    
  10759b:	66 90                	xchg   %ax,%ax
  10759d:	66 90                	xchg   %ax,%ax
  10759f:	90                   	nop

001075a0 <sys_puts>:
/**
 * Copies a string from user into buffer and prints it to the screen.
 * This is called by the user level "printf" library as a system call.
 */
void sys_puts(tf_t *tf)
{
  1075a0:	55                   	push   %ebp
  1075a1:	57                   	push   %edi
  1075a2:	56                   	push   %esi
  1075a3:	53                   	push   %ebx
  1075a4:	83 ec 1c             	sub    $0x1c,%esp
    unsigned int cur_pid;
    unsigned int str_uva, str_len;
    unsigned int remain, cur_pos, nbytes;

    cur_pid = get_curid();
  1075a7:	e8 f4 f9 ff ff       	call   106fa0 <get_curid>
    str_uva = syscall_get_arg2(tf);
  1075ac:	83 ec 0c             	sub    $0xc,%esp
  1075af:	ff 74 24 3c          	pushl  0x3c(%esp)
    cur_pid = get_curid();
  1075b3:	89 c7                	mov    %eax,%edi
    str_uva = syscall_get_arg2(tf);
  1075b5:	e8 36 ff ff ff       	call   1074f0 <syscall_get_arg2>
  1075ba:	89 c3                	mov    %eax,%ebx
    str_len = syscall_get_arg3(tf);
  1075bc:	58                   	pop    %eax
  1075bd:	ff 74 24 3c          	pushl  0x3c(%esp)
  1075c1:	e8 3a ff ff ff       	call   107500 <syscall_get_arg3>

    if (!(VM_USERLO <= str_uva && str_uva + str_len <= VM_USERHI)) {
  1075c6:	83 c4 10             	add    $0x10,%esp
  1075c9:	81 fb ff ff ff 3f    	cmp    $0x3fffffff,%ebx
  1075cf:	76 0c                	jbe    1075dd <sys_puts+0x3d>
  1075d1:	01 c3                	add    %eax,%ebx
  1075d3:	89 c5                	mov    %eax,%ebp
  1075d5:	81 fb 00 00 00 f0    	cmp    $0xf0000000,%ebx
  1075db:	76 23                	jbe    107600 <sys_puts+0x60>
        syscall_set_errno(tf, E_INVAL_ADDR);
  1075dd:	83 ec 08             	sub    $0x8,%esp
  1075e0:	6a 04                	push   $0x4
  1075e2:	ff 74 24 3c          	pushl  0x3c(%esp)
  1075e6:	e8 55 ff ff ff       	call   107540 <syscall_set_errno>
        return;
  1075eb:	83 c4 10             	add    $0x10,%esp
        cur_pos += nbytes;
    }
    debug_unlock();

    syscall_set_errno(tf, E_SUCC);
}
  1075ee:	83 c4 1c             	add    $0x1c,%esp
  1075f1:	5b                   	pop    %ebx
  1075f2:	5e                   	pop    %esi
  1075f3:	5f                   	pop    %edi
  1075f4:	5d                   	pop    %ebp
  1075f5:	c3                   	ret    
  1075f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1075fd:	8d 76 00             	lea    0x0(%esi),%esi
    debug_lock();
  107600:	e8 8b c1 ff ff       	call   103790 <debug_lock>
        if (pt_copyin(cur_pid, cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
  107605:	89 fe                	mov    %edi,%esi
  107607:	c1 e6 0c             	shl    $0xc,%esi
  10760a:	81 c6 40 28 95 00    	add    $0x952840,%esi
        sys_buf[cur_pid][nbytes] = '\0';
  107610:	89 74 24 0c          	mov    %esi,0xc(%esp)
    while (remain) {
  107614:	85 ed                	test   %ebp,%ebp
  107616:	75 49                	jne    107661 <sys_puts+0xc1>
  107618:	e9 a5 00 00 00       	jmp    1076c2 <sys_puts+0x122>
  10761d:	8d 76 00             	lea    0x0(%esi),%esi
        if (pt_copyin(cur_pid, cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
  107620:	68 ff 0f 00 00       	push   $0xfff
  107625:	56                   	push   %esi
  107626:	50                   	push   %eax
  107627:	57                   	push   %edi
  107628:	e8 13 d2 ff ff       	call   104840 <pt_copyin>
  10762d:	83 c4 10             	add    $0x10,%esp
  107630:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  107635:	75 46                	jne    10767d <sys_puts+0xdd>
        sys_buf[cur_pid][nbytes] = '\0';
  107637:	8b 44 24 0c          	mov    0xc(%esp),%eax
  10763b:	c6 80 ff 0f 00 00 00 	movb   $0x0,0xfff(%eax)
        KERN_INFO("From cpu %d: %s", get_pcpu_idx(), sys_buf[cur_pid]);
  107642:	e8 e9 e3 ff ff       	call   105a30 <get_pcpu_idx>
  107647:	83 ec 04             	sub    $0x4,%esp
  10764a:	56                   	push   %esi
  10764b:	50                   	push   %eax
  10764c:	68 f5 a8 10 00       	push   $0x10a8f5
  107651:	e8 7a c1 ff ff       	call   1037d0 <debug_info>
    while (remain) {
  107656:	83 c4 10             	add    $0x10,%esp
  107659:	81 ed ff 0f 00 00    	sub    $0xfff,%ebp
  10765f:	74 61                	je     1076c2 <sys_puts+0x122>
  107661:	89 d8                	mov    %ebx,%eax
  107663:	29 e8                	sub    %ebp,%eax
        if (remain < PAGESIZE - 1)
  107665:	81 fd fe 0f 00 00    	cmp    $0xffe,%ebp
  10766b:	77 b3                	ja     107620 <sys_puts+0x80>
        if (pt_copyin(cur_pid, cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
  10766d:	55                   	push   %ebp
  10766e:	56                   	push   %esi
  10766f:	50                   	push   %eax
  107670:	57                   	push   %edi
  107671:	e8 ca d1 ff ff       	call   104840 <pt_copyin>
  107676:	83 c4 10             	add    $0x10,%esp
  107679:	39 c5                	cmp    %eax,%ebp
  10767b:	74 23                	je     1076a0 <sys_puts+0x100>
            debug_unlock();
  10767d:	e8 2e c1 ff ff       	call   1037b0 <debug_unlock>
            syscall_set_errno(tf, E_MEM);
  107682:	83 ec 08             	sub    $0x8,%esp
  107685:	6a 01                	push   $0x1
  107687:	ff 74 24 3c          	pushl  0x3c(%esp)
  10768b:	e8 b0 fe ff ff       	call   107540 <syscall_set_errno>
            return;
  107690:	83 c4 10             	add    $0x10,%esp
}
  107693:	83 c4 1c             	add    $0x1c,%esp
  107696:	5b                   	pop    %ebx
  107697:	5e                   	pop    %esi
  107698:	5f                   	pop    %edi
  107699:	5d                   	pop    %ebp
  10769a:	c3                   	ret    
  10769b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  10769f:	90                   	nop
        sys_buf[cur_pid][nbytes] = '\0';
  1076a0:	c1 e7 0c             	shl    $0xc,%edi
  1076a3:	c6 84 3d 40 28 95 00 	movb   $0x0,0x952840(%ebp,%edi,1)
  1076aa:	00 
        KERN_INFO("From cpu %d: %s", get_pcpu_idx(), sys_buf[cur_pid]);
  1076ab:	e8 80 e3 ff ff       	call   105a30 <get_pcpu_idx>
  1076b0:	83 ec 04             	sub    $0x4,%esp
  1076b3:	56                   	push   %esi
  1076b4:	50                   	push   %eax
  1076b5:	68 f5 a8 10 00       	push   $0x10a8f5
  1076ba:	e8 11 c1 ff ff       	call   1037d0 <debug_info>
  1076bf:	83 c4 10             	add    $0x10,%esp
    debug_unlock();
  1076c2:	e8 e9 c0 ff ff       	call   1037b0 <debug_unlock>
    syscall_set_errno(tf, E_SUCC);
  1076c7:	83 ec 08             	sub    $0x8,%esp
  1076ca:	6a 00                	push   $0x0
  1076cc:	ff 74 24 3c          	pushl  0x3c(%esp)
  1076d0:	e8 6b fe ff ff       	call   107540 <syscall_set_errno>
  1076d5:	83 c4 10             	add    $0x10,%esp
  1076d8:	e9 11 ff ff ff       	jmp    1075ee <sys_puts+0x4e>
  1076dd:	8d 76 00             	lea    0x0(%esi),%esi

001076e0 <sys_spawn>:
 * NUM_IDS with the error number E_INVAL_PID. The same error case apply
 * when the proc_create fails.
 * Otherwise, you should mark it as successful, and return the new child process id.
 */
void sys_spawn(tf_t *tf)
{
  1076e0:	55                   	push   %ebp
  1076e1:	57                   	push   %edi
  1076e2:	56                   	push   %esi
  1076e3:	53                   	push   %ebx
  1076e4:	83 ec 0c             	sub    $0xc,%esp
  1076e7:	8b 74 24 20          	mov    0x20(%esp),%esi
    unsigned int curid;
    unsigned int new_pid;
    unsigned int elf_id, quota;
    void *elf_addr;

    curid = get_curid();
  1076eb:	e8 b0 f8 ff ff       	call   106fa0 <get_curid>
    elf_id = syscall_get_arg2(tf);
  1076f0:	83 ec 0c             	sub    $0xc,%esp
  1076f3:	56                   	push   %esi
    curid = get_curid();
  1076f4:	89 c3                	mov    %eax,%ebx
    elf_id = syscall_get_arg2(tf);
  1076f6:	e8 f5 fd ff ff       	call   1074f0 <syscall_get_arg2>
    quota = syscall_get_arg3(tf);
  1076fb:	89 34 24             	mov    %esi,(%esp)
    elf_id = syscall_get_arg2(tf);
  1076fe:	89 c7                	mov    %eax,%edi
    quota = syscall_get_arg3(tf);
  107700:	e8 fb fd ff ff       	call   107500 <syscall_get_arg3>

    if (container_can_consume(curid, quota) == 0) {
  107705:	5a                   	pop    %edx
  107706:	59                   	pop    %ecx
  107707:	50                   	push   %eax
    quota = syscall_get_arg3(tf);
  107708:	89 c5                	mov    %eax,%ebp
    if (container_can_consume(curid, quota) == 0) {
  10770a:	53                   	push   %ebx
  10770b:	e8 a0 eb ff ff       	call   1062b0 <container_can_consume>
  107710:	83 c4 10             	add    $0x10,%esp
  107713:	85 c0                	test   %eax,%eax
  107715:	0f 84 95 00 00 00    	je     1077b0 <sys_spawn+0xd0>
        syscall_set_errno(tf, E_EXCEEDS_QUOTA);
        syscall_set_retval1(tf, NUM_IDS);
        return;
    }
    else if (NUM_IDS < curid * MAX_CHILDREN + 1 + MAX_CHILDREN) {
  10771b:	8d 44 5b 04          	lea    0x4(%ebx,%ebx,2),%eax
  10771f:	83 f8 40             	cmp    $0x40,%eax
  107722:	77 7c                	ja     1077a0 <sys_spawn+0xc0>
        syscall_set_errno(tf, E_MAX_NUM_CHILDEN_REACHED);
        syscall_set_retval1(tf, NUM_IDS);
        return;
    }
    else if (container_get_nchildren(curid) == MAX_CHILDREN) {
  107724:	83 ec 0c             	sub    $0xc,%esp
  107727:	53                   	push   %ebx
  107728:	e8 53 eb ff ff       	call   106280 <container_get_nchildren>
  10772d:	83 c4 10             	add    $0x10,%esp
  107730:	83 f8 03             	cmp    $0x3,%eax
  107733:	0f 84 87 00 00 00    	je     1077c0 <sys_spawn+0xe0>
        syscall_set_errno(tf, E_INVAL_CHILD_ID);
        syscall_set_retval1(tf, NUM_IDS);
        return;
    }

    switch (elf_id) {
  107739:	83 ef 01             	sub    $0x1,%edi
  10773c:	83 ff 02             	cmp    $0x2,%edi
  10773f:	77 3f                	ja     107780 <sys_spawn+0xa0>
        syscall_set_errno(tf, E_INVAL_PID);
        syscall_set_retval1(tf, NUM_IDS);
        return;
    }

    new_pid = proc_create(elf_addr, quota);
  107741:	83 ec 08             	sub    $0x8,%esp
  107744:	55                   	push   %ebp
  107745:	ff 34 bd 6c a9 10 00 	pushl  0x10a96c(,%edi,4)
  10774c:	e8 3f fc ff ff       	call   107390 <proc_create>

    if (new_pid == NUM_IDS) {
  107751:	83 c4 10             	add    $0x10,%esp
    new_pid = proc_create(elf_addr, quota);
  107754:	89 c3                	mov    %eax,%ebx
    if (new_pid == NUM_IDS) {
  107756:	83 f8 40             	cmp    $0x40,%eax
  107759:	74 25                	je     107780 <sys_spawn+0xa0>
        syscall_set_errno(tf, E_INVAL_PID);
        syscall_set_retval1(tf, NUM_IDS);
    } else {
        syscall_set_errno(tf, E_SUCC);
  10775b:	83 ec 08             	sub    $0x8,%esp
  10775e:	6a 00                	push   $0x0
  107760:	56                   	push   %esi
  107761:	e8 da fd ff ff       	call   107540 <syscall_set_errno>
        syscall_set_retval1(tf, new_pid);
  107766:	58                   	pop    %eax
  107767:	5a                   	pop    %edx
  107768:	53                   	push   %ebx
  107769:	56                   	push   %esi
  10776a:	e8 e1 fd ff ff       	call   107550 <syscall_set_retval1>
  10776f:	83 c4 10             	add    $0x10,%esp
    }
}
  107772:	83 c4 0c             	add    $0xc,%esp
  107775:	5b                   	pop    %ebx
  107776:	5e                   	pop    %esi
  107777:	5f                   	pop    %edi
  107778:	5d                   	pop    %ebp
  107779:	c3                   	ret    
  10777a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        syscall_set_errno(tf, E_INVAL_PID);
  107780:	83 ec 08             	sub    $0x8,%esp
  107783:	6a 05                	push   $0x5
  107785:	56                   	push   %esi
  107786:	e8 b5 fd ff ff       	call   107540 <syscall_set_errno>
        syscall_set_retval1(tf, NUM_IDS);
  10778b:	59                   	pop    %ecx
  10778c:	5b                   	pop    %ebx
  10778d:	6a 40                	push   $0x40
  10778f:	56                   	push   %esi
  107790:	e8 bb fd ff ff       	call   107550 <syscall_set_retval1>
  107795:	83 c4 10             	add    $0x10,%esp
}
  107798:	83 c4 0c             	add    $0xc,%esp
  10779b:	5b                   	pop    %ebx
  10779c:	5e                   	pop    %esi
  10779d:	5f                   	pop    %edi
  10779e:	5d                   	pop    %ebp
  10779f:	c3                   	ret    
        syscall_set_errno(tf, E_MAX_NUM_CHILDEN_REACHED);
  1077a0:	83 ec 08             	sub    $0x8,%esp
  1077a3:	6a 18                	push   $0x18
  1077a5:	eb de                	jmp    107785 <sys_spawn+0xa5>
  1077a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1077ae:	66 90                	xchg   %ax,%ax
        syscall_set_errno(tf, E_EXCEEDS_QUOTA);
  1077b0:	83 ec 08             	sub    $0x8,%esp
  1077b3:	6a 17                	push   $0x17
  1077b5:	eb ce                	jmp    107785 <sys_spawn+0xa5>
  1077b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1077be:	66 90                	xchg   %ax,%ax
        syscall_set_errno(tf, E_INVAL_CHILD_ID);
  1077c0:	83 ec 08             	sub    $0x8,%esp
  1077c3:	6a 19                	push   $0x19
  1077c5:	eb be                	jmp    107785 <sys_spawn+0xa5>
  1077c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1077ce:	66 90                	xchg   %ax,%ax

001077d0 <sys_yield>:
 * The user level library function sys_yield (defined in user/include/syscall.h)
 * does not take any argument and does not have any return values.
 * Do not forget to set the error number as E_SUCC.
 */
void sys_yield(tf_t *tf)
{
  1077d0:	83 ec 0c             	sub    $0xc,%esp
    thread_yield();
  1077d3:	e8 78 f9 ff ff       	call   107150 <thread_yield>
    syscall_set_errno(tf, E_SUCC);
  1077d8:	83 ec 08             	sub    $0x8,%esp
  1077db:	6a 00                	push   $0x0
  1077dd:	ff 74 24 1c          	pushl  0x1c(%esp)
  1077e1:	e8 5a fd ff ff       	call   107540 <syscall_set_errno>
}
  1077e6:	83 c4 1c             	add    $0x1c,%esp
  1077e9:	c3                   	ret    
  1077ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001077f0 <sys_produce>:

BoundedBuffer bb;

void sys_produce(tf_t *tf)
{
  1077f0:	57                   	push   %edi
  1077f1:	56                   	push   %esi
  1077f2:	53                   	push   %ebx
  1077f3:	8b 7c 24 10          	mov    0x10(%esp),%edi
    unsigned int val = syscall_get_arg2(tf);
  1077f7:	83 ec 0c             	sub    $0xc,%esp
  1077fa:	57                   	push   %edi
  1077fb:	e8 f0 fc ff ff       	call   1074f0 <syscall_get_arg2>
  107800:	89 c3                	mov    %eax,%ebx
    BB_enqueue(&bb, val);
  107802:	58                   	pop    %eax
  107803:	5a                   	pop    %edx
  107804:	53                   	push   %ebx
  107805:	68 80 fd e1 00       	push   $0xe1fd80
  10780a:	e8 41 da ff ff       	call   105250 <BB_enqueue>
    NO_INTR(
  10780f:	e8 0c 9e ff ff       	call   101620 <intr_local_disable>
  107814:	e8 87 f7 ff ff       	call   106fa0 <get_curid>
  107819:	89 c6                	mov    %eax,%esi
  10781b:	e8 10 e2 ff ff       	call   105a30 <get_pcpu_idx>
  107820:	59                   	pop    %ecx
  107821:	5a                   	pop    %edx
  107822:	53                   	push   %ebx
  107823:	56                   	push   %esi
  107824:	50                   	push   %eax
  107825:	68 24 a9 10 00       	push   $0x10a924
  10782a:	68 9f 00 00 00       	push   $0x9f
  10782f:	68 05 a9 10 00       	push   $0x10a905
  107834:	e8 c7 bf ff ff       	call   103800 <debug_normal>
  107839:	83 c4 20             	add    $0x20,%esp
  10783c:	e8 cf 9d ff ff       	call   101610 <intr_local_enable>
        KERN_DEBUG("CPU %d: Process %d: Produced %d\n", get_pcpu_idx(), get_curid(), val);
    );
    syscall_set_errno(tf, E_SUCC);
  107841:	83 ec 08             	sub    $0x8,%esp
  107844:	6a 00                	push   $0x0
  107846:	57                   	push   %edi
  107847:	e8 f4 fc ff ff       	call   107540 <syscall_set_errno>
}
  10784c:	83 c4 10             	add    $0x10,%esp
  10784f:	5b                   	pop    %ebx
  107850:	5e                   	pop    %esi
  107851:	5f                   	pop    %edi
  107852:	c3                   	ret    
  107853:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10785a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00107860 <sys_consume>:

void sys_consume(tf_t *tf)
{
  107860:	57                   	push   %edi
  107861:	56                   	push   %esi
  107862:	53                   	push   %ebx
  107863:	8b 7c 24 10          	mov    0x10(%esp),%edi
    unsigned int val = BB_dequeue(&bb);
  107867:	83 ec 0c             	sub    $0xc,%esp
  10786a:	68 80 fd e1 00       	push   $0xe1fd80
  10786f:	e8 6c da ff ff       	call   1052e0 <BB_dequeue>
  107874:	89 c3                	mov    %eax,%ebx
    NO_INTR(
  107876:	e8 a5 9d ff ff       	call   101620 <intr_local_disable>
  10787b:	e8 20 f7 ff ff       	call   106fa0 <get_curid>
  107880:	89 c6                	mov    %eax,%esi
  107882:	e8 a9 e1 ff ff       	call   105a30 <get_pcpu_idx>
  107887:	5a                   	pop    %edx
  107888:	59                   	pop    %ecx
  107889:	53                   	push   %ebx
  10788a:	56                   	push   %esi
  10788b:	50                   	push   %eax
  10788c:	68 48 a9 10 00       	push   $0x10a948
  107891:	68 a8 00 00 00       	push   $0xa8
  107896:	68 05 a9 10 00       	push   $0x10a905
  10789b:	e8 60 bf ff ff       	call   103800 <debug_normal>
  1078a0:	83 c4 20             	add    $0x20,%esp
  1078a3:	e8 68 9d ff ff       	call   101610 <intr_local_enable>
        KERN_DEBUG("CPU %d: Process %d: Consumed %d\n", get_pcpu_idx(), get_curid(), val);
    );
    syscall_set_errno(tf, E_SUCC);
  1078a8:	83 ec 08             	sub    $0x8,%esp
  1078ab:	6a 00                	push   $0x0
  1078ad:	57                   	push   %edi
  1078ae:	e8 8d fc ff ff       	call   107540 <syscall_set_errno>
    syscall_set_retval1(tf, val);
  1078b3:	5e                   	pop    %esi
  1078b4:	58                   	pop    %eax
  1078b5:	53                   	push   %ebx
  1078b6:	57                   	push   %edi
  1078b7:	e8 94 fc ff ff       	call   107550 <syscall_set_retval1>
}
  1078bc:	83 c4 10             	add    $0x10,%esp
  1078bf:	5b                   	pop    %ebx
  1078c0:	5e                   	pop    %esi
  1078c1:	5f                   	pop    %edi
  1078c2:	c3                   	ret    
  1078c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1078ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001078d0 <sys_thread_join>:


void sys_thread_join(tf_t *tf) {

}
  1078d0:	c3                   	ret    
  1078d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1078d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1078df:	90                   	nop

001078e0 <sys_thread_exit>:
  1078e0:	c3                   	ret    
  1078e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1078e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1078ef:	90                   	nop

001078f0 <sys_thread_create>:

void sys_thread_exit(tf_t *tf) {
    //thread_exit();
}

void sys_thread_create(tf_t *tf) {
  1078f0:	56                   	push   %esi
  1078f1:	53                   	push   %ebx
  1078f2:	83 ec 10             	sub    $0x10,%esp
  1078f5:	8b 74 24 1c          	mov    0x1c(%esp),%esi
    uintptr_t eip = syscall_get_arg2(tf);
  1078f9:	56                   	push   %esi
  1078fa:	e8 f1 fb ff ff       	call   1074f0 <syscall_get_arg2>
    uintptr_t esp = syscall_get_arg3(tf);
  1078ff:	89 34 24             	mov    %esi,(%esp)
    uintptr_t eip = syscall_get_arg2(tf);
  107902:	89 c3                	mov    %eax,%ebx
    uintptr_t esp = syscall_get_arg3(tf);
  107904:	e8 f7 fb ff ff       	call   107500 <syscall_get_arg3>

    if (!(VM_USERLO <= eip && eip <= VM_USERHI)) {
  107909:	8d 93 00 00 00 c0    	lea    -0x40000000(%ebx),%edx
  10790f:	83 c4 10             	add    $0x10,%esp
  107912:	81 fa 00 00 00 b0    	cmp    $0xb0000000,%edx
  107918:	77 46                	ja     107960 <sys_thread_create+0x70>
        syscall_set_errno(tf, E_INVAL_ADDR);
        return;
    }

    if (!(VM_USERLO <= esp && esp <= VM_USERHI)) {
  10791a:	8d 90 00 00 00 c0    	lea    -0x40000000(%eax),%edx
  107920:	81 fa 00 00 00 b0    	cmp    $0xb0000000,%edx
  107926:	77 38                	ja     107960 <sys_thread_create+0x70>
        syscall_set_errno(tf, E_INVAL_ADDR);
        return;
    }

    unsigned int pid = thread_create(eip, esp);
  107928:	83 ec 08             	sub    $0x8,%esp
  10792b:	50                   	push   %eax
  10792c:	53                   	push   %ebx
  10792d:	e8 0e fb ff ff       	call   107440 <thread_create>
    if (pid != NUM_IDS) {
  107932:	83 c4 10             	add    $0x10,%esp
    unsigned int pid = thread_create(eip, esp);
  107935:	89 c3                	mov    %eax,%ebx
    if (pid != NUM_IDS) {
  107937:	83 f8 40             	cmp    $0x40,%eax
  10793a:	74 3c                	je     107978 <sys_thread_create+0x88>
        syscall_set_errno(tf, E_SUCC);
  10793c:	83 ec 08             	sub    $0x8,%esp
  10793f:	6a 00                	push   $0x0
  107941:	56                   	push   %esi
  107942:	e8 f9 fb ff ff       	call   107540 <syscall_set_errno>
  107947:	83 c4 10             	add    $0x10,%esp
    } else {
        syscall_set_errno(tf, E_INVAL_PID);
    }

    syscall_set_retval1(tf, pid);
  10794a:	83 ec 08             	sub    $0x8,%esp
  10794d:	53                   	push   %ebx
  10794e:	56                   	push   %esi
  10794f:	e8 fc fb ff ff       	call   107550 <syscall_set_retval1>
  107954:	83 c4 10             	add    $0x10,%esp
}
  107957:	83 c4 04             	add    $0x4,%esp
  10795a:	5b                   	pop    %ebx
  10795b:	5e                   	pop    %esi
  10795c:	c3                   	ret    
  10795d:	8d 76 00             	lea    0x0(%esi),%esi
        syscall_set_errno(tf, E_INVAL_ADDR);
  107960:	83 ec 08             	sub    $0x8,%esp
  107963:	6a 04                	push   $0x4
  107965:	56                   	push   %esi
  107966:	e8 d5 fb ff ff       	call   107540 <syscall_set_errno>
        return;
  10796b:	83 c4 10             	add    $0x10,%esp
}
  10796e:	83 c4 04             	add    $0x4,%esp
  107971:	5b                   	pop    %ebx
  107972:	5e                   	pop    %esi
  107973:	c3                   	ret    
  107974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        syscall_set_errno(tf, E_INVAL_PID);
  107978:	83 ec 08             	sub    $0x8,%esp
  10797b:	6a 05                	push   $0x5
  10797d:	56                   	push   %esi
  10797e:	e8 bd fb ff ff       	call   107540 <syscall_set_errno>
  107983:	83 c4 10             	add    $0x10,%esp
  107986:	eb c2                	jmp    10794a <sys_thread_create+0x5a>
  107988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10798f:	90                   	nop

00107990 <sys_getpid>:

void sys_getpid(tf_t *tf) {
  107990:	53                   	push   %ebx
  107991:	83 ec 10             	sub    $0x10,%esp
  107994:	8b 5c 24 18          	mov    0x18(%esp),%ebx
    syscall_set_errno(tf, E_SUCC);
  107998:	6a 00                	push   $0x0
  10799a:	53                   	push   %ebx
  10799b:	e8 a0 fb ff ff       	call   107540 <syscall_set_errno>
    syscall_set_retval1(tf, get_curid());
  1079a0:	e8 fb f5 ff ff       	call   106fa0 <get_curid>
  1079a5:	5a                   	pop    %edx
  1079a6:	59                   	pop    %ecx
  1079a7:	50                   	push   %eax
  1079a8:	53                   	push   %ebx
  1079a9:	e8 a2 fb ff ff       	call   107550 <syscall_set_retval1>
}
  1079ae:	83 c4 18             	add    $0x18,%esp
  1079b1:	5b                   	pop    %ebx
  1079b2:	c3                   	ret    
  1079b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1079ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001079c0 <sys_futex>:

void sys_futex(tf_t *tf) {
  1079c0:	55                   	push   %ebp
  1079c1:	57                   	push   %edi
  1079c2:	56                   	push   %esi
  1079c3:	53                   	push   %ebx
  1079c4:	83 ec 28             	sub    $0x28,%esp
  1079c7:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
    uint32_t *uaddr = (uint32_t *)syscall_get_arg2(tf);
  1079cb:	53                   	push   %ebx
  1079cc:	e8 1f fb ff ff       	call   1074f0 <syscall_get_arg2>
    uint32_t op = syscall_get_arg3(tf);
  1079d1:	89 1c 24             	mov    %ebx,(%esp)
    uint32_t *uaddr = (uint32_t *)syscall_get_arg2(tf);
  1079d4:	89 c6                	mov    %eax,%esi
    uint32_t op = syscall_get_arg3(tf);
  1079d6:	e8 25 fb ff ff       	call   107500 <syscall_get_arg3>
    uint32_t val1 = syscall_get_arg4(tf);
  1079db:	89 1c 24             	mov    %ebx,(%esp)
    uint32_t op = syscall_get_arg3(tf);
  1079de:	89 c7                	mov    %eax,%edi
    uint32_t val1 = syscall_get_arg4(tf);
  1079e0:	e8 2b fb ff ff       	call   107510 <syscall_get_arg4>
    uint32_t *uaddr2 = (uint32_t *)syscall_get_arg5(tf);
  1079e5:	89 1c 24             	mov    %ebx,(%esp)
    uint32_t val1 = syscall_get_arg4(tf);
  1079e8:	89 c5                	mov    %eax,%ebp
    uint32_t *uaddr2 = (uint32_t *)syscall_get_arg5(tf);
  1079ea:	e8 31 fb ff ff       	call   107520 <syscall_get_arg5>
    uint32_t val3 = syscall_get_arg6(tf);
  1079ef:	89 1c 24             	mov    %ebx,(%esp)
    uint32_t *uaddr2 = (uint32_t *)syscall_get_arg5(tf);
  1079f2:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    uint32_t val3 = syscall_get_arg6(tf);
  1079f6:	e8 35 fb ff ff       	call   107530 <syscall_get_arg6>
 
    // TODO: Timeout is not passed in
    int ret = futex(uaddr, op, val1, NULL, uaddr2, val3);
  1079fb:	59                   	pop    %ecx
  1079fc:	5a                   	pop    %edx
  1079fd:	50                   	push   %eax
  1079fe:	8b 54 24 18          	mov    0x18(%esp),%edx
  107a02:	52                   	push   %edx
  107a03:	6a 00                	push   $0x0
  107a05:	55                   	push   %ebp
  107a06:	57                   	push   %edi
  107a07:	56                   	push   %esi
  107a08:	e8 f3 db ff ff       	call   105600 <futex>

    if (ret < 0) {
  107a0d:	83 c4 20             	add    $0x20,%esp
    int ret = futex(uaddr, op, val1, NULL, uaddr2, val3);
  107a10:	89 c6                	mov    %eax,%esi
    if (ret < 0) {
  107a12:	85 c0                	test   %eax,%eax
  107a14:	78 22                	js     107a38 <sys_futex+0x78>
	syscall_set_errno(tf, ret);
    } else {
	syscall_set_errno(tf, E_SUCC);
  107a16:	83 ec 08             	sub    $0x8,%esp
  107a19:	6a 00                	push   $0x0
  107a1b:	53                   	push   %ebx
  107a1c:	e8 1f fb ff ff       	call   107540 <syscall_set_errno>
	syscall_set_retval1(tf, ret);
  107a21:	58                   	pop    %eax
  107a22:	5a                   	pop    %edx
  107a23:	56                   	push   %esi
  107a24:	53                   	push   %ebx
  107a25:	e8 26 fb ff ff       	call   107550 <syscall_set_retval1>
  107a2a:	83 c4 10             	add    $0x10,%esp
    }
}
  107a2d:	83 c4 1c             	add    $0x1c,%esp
  107a30:	5b                   	pop    %ebx
  107a31:	5e                   	pop    %esi
  107a32:	5f                   	pop    %edi
  107a33:	5d                   	pop    %ebp
  107a34:	c3                   	ret    
  107a35:	8d 76 00             	lea    0x0(%esi),%esi
	syscall_set_errno(tf, ret);
  107a38:	83 ec 08             	sub    $0x8,%esp
  107a3b:	50                   	push   %eax
  107a3c:	53                   	push   %ebx
  107a3d:	e8 fe fa ff ff       	call   107540 <syscall_set_errno>
  107a42:	83 c4 10             	add    $0x10,%esp
}
  107a45:	83 c4 1c             	add    $0x1c,%esp
  107a48:	5b                   	pop    %ebx
  107a49:	5e                   	pop    %esi
  107a4a:	5f                   	pop    %edi
  107a4b:	5d                   	pop    %ebp
  107a4c:	c3                   	ret    
  107a4d:	66 90                	xchg   %ax,%ax
  107a4f:	90                   	nop

00107a50 <syscall_dispatch>:
#include <kern/trap/TSyscall/export.h>

#include "import.h"

void syscall_dispatch(tf_t *tf)
{
  107a50:	53                   	push   %ebx
  107a51:	83 ec 14             	sub    $0x14,%esp
  107a54:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    unsigned int nr;

    nr = syscall_get_arg1(tf);
  107a58:	53                   	push   %ebx
  107a59:	e8 82 fa ff ff       	call   1074e0 <syscall_get_arg1>

    switch (nr) {
  107a5e:	83 c4 10             	add    $0x10,%esp
  107a61:	83 f8 09             	cmp    $0x9,%eax
  107a64:	0f 87 d3 00 00 00    	ja     107b3d <syscall_dispatch+0xed>
  107a6a:	ff 24 85 78 a9 10 00 	jmp    *0x10a978(,%eax,4)
  107a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	break;
    case SYS_thread_exit:
	sys_thread_exit(tf);
	break;
    case SYS_getpid:
	sys_getpid(tf);
  107a78:	89 5c 24 10          	mov    %ebx,0x10(%esp)
	//intr_local_disable();
	break;
    default:
        syscall_set_errno(tf, E_INVAL_CALLNR);
    }
}
  107a7c:	83 c4 08             	add    $0x8,%esp
  107a7f:	5b                   	pop    %ebx
	sys_getpid(tf);
  107a80:	e9 0b ff ff ff       	jmp    107990 <sys_getpid>
  107a85:	8d 76 00             	lea    0x0(%esi),%esi
	sys_futex(tf);
  107a88:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
  107a8c:	83 c4 08             	add    $0x8,%esp
  107a8f:	5b                   	pop    %ebx
	sys_futex(tf);
  107a90:	e9 2b ff ff ff       	jmp    1079c0 <sys_futex>
  107a95:	8d 76 00             	lea    0x0(%esi),%esi
        sys_puts(tf);
  107a98:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
  107a9c:	83 c4 08             	add    $0x8,%esp
  107a9f:	5b                   	pop    %ebx
        sys_puts(tf);
  107aa0:	e9 fb fa ff ff       	jmp    1075a0 <sys_puts>
  107aa5:	8d 76 00             	lea    0x0(%esi),%esi
        sys_spawn(tf);
  107aa8:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
  107aac:	83 c4 08             	add    $0x8,%esp
  107aaf:	5b                   	pop    %ebx
        sys_spawn(tf);
  107ab0:	e9 2b fc ff ff       	jmp    1076e0 <sys_spawn>
  107ab5:	8d 76 00             	lea    0x0(%esi),%esi
        sys_yield(tf);
  107ab8:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
  107abc:	83 c4 08             	add    $0x8,%esp
  107abf:	5b                   	pop    %ebx
        sys_yield(tf);
  107ac0:	e9 0b fd ff ff       	jmp    1077d0 <sys_yield>
  107ac5:	8d 76 00             	lea    0x0(%esi),%esi
        intr_local_enable();
  107ac8:	e8 43 9b ff ff       	call   101610 <intr_local_enable>
        sys_produce(tf);
  107acd:	83 ec 0c             	sub    $0xc,%esp
  107ad0:	53                   	push   %ebx
  107ad1:	e8 1a fd ff ff       	call   1077f0 <sys_produce>
}
  107ad6:	83 c4 18             	add    $0x18,%esp
  107ad9:	5b                   	pop    %ebx
        intr_local_disable();
  107ada:	e9 41 9b ff ff       	jmp    101620 <intr_local_disable>
  107adf:	90                   	nop
        intr_local_enable();
  107ae0:	e8 2b 9b ff ff       	call   101610 <intr_local_enable>
        sys_consume(tf);
  107ae5:	83 ec 0c             	sub    $0xc,%esp
  107ae8:	53                   	push   %ebx
  107ae9:	e8 72 fd ff ff       	call   107860 <sys_consume>
}
  107aee:	83 c4 18             	add    $0x18,%esp
  107af1:	5b                   	pop    %ebx
        intr_local_disable();
  107af2:	e9 29 9b ff ff       	jmp    101620 <intr_local_disable>
  107af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107afe:	66 90                	xchg   %ax,%ax
	sys_thread_create(tf);
  107b00:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
  107b04:	83 c4 08             	add    $0x8,%esp
  107b07:	5b                   	pop    %ebx
	sys_thread_create(tf);
  107b08:	e9 e3 fd ff ff       	jmp    1078f0 <sys_thread_create>
  107b0d:	8d 76 00             	lea    0x0(%esi),%esi
	intr_local_enable();
  107b10:	e8 fb 9a ff ff       	call   101610 <intr_local_enable>
	sys_thread_join(tf);
  107b15:	83 ec 0c             	sub    $0xc,%esp
  107b18:	53                   	push   %ebx
  107b19:	e8 b2 fd ff ff       	call   1078d0 <sys_thread_join>
}
  107b1e:	83 c4 18             	add    $0x18,%esp
  107b21:	5b                   	pop    %ebx
	intr_local_disable();
  107b22:	e9 f9 9a ff ff       	jmp    101620 <intr_local_disable>
  107b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107b2e:	66 90                	xchg   %ax,%ax
	sys_thread_exit(tf);
  107b30:	89 5c 24 10          	mov    %ebx,0x10(%esp)
}
  107b34:	83 c4 08             	add    $0x8,%esp
  107b37:	5b                   	pop    %ebx
	sys_thread_exit(tf);
  107b38:	e9 a3 fd ff ff       	jmp    1078e0 <sys_thread_exit>
        syscall_set_errno(tf, E_INVAL_CALLNR);
  107b3d:	83 ec 08             	sub    $0x8,%esp
  107b40:	6a 03                	push   $0x3
  107b42:	53                   	push   %ebx
  107b43:	e8 f8 f9 ff ff       	call   107540 <syscall_set_errno>
}
  107b48:	83 c4 18             	add    $0x18,%esp
  107b4b:	5b                   	pop    %ebx
  107b4c:	c3                   	ret    
  107b4d:	66 90                	xchg   %ax,%ax
  107b4f:	90                   	nop

00107b50 <default_exception_handler>:
    KERN_DEBUG("\t%08x:\tss:    \t\t%08x\n", &tf->ss, tf->ss);
    debug_unlock();
}

void default_exception_handler(tf_t *tf)
{
  107b50:	57                   	push   %edi
  107b51:	56                   	push   %esi
  107b52:	53                   	push   %ebx
  107b53:	8b 5c 24 10          	mov    0x10(%esp),%ebx
    unsigned int cur_pid;

    cur_pid = get_curid();
  107b57:	e8 44 f4 ff ff       	call   106fa0 <get_curid>
    if (tf == NULL)
  107b5c:	85 db                	test   %ebx,%ebx
  107b5e:	0f 84 ec 01 00 00    	je     107d50 <default_exception_handler+0x200>
    debug_lock();
  107b64:	e8 27 bc ff ff       	call   103790 <debug_lock>
    KERN_DEBUG("trapframe at %x\n", base);
  107b69:	53                   	push   %ebx
  107b6a:	68 a0 a9 10 00       	push   $0x10a9a0
  107b6f:	6a 19                	push   $0x19
  107b71:	68 14 ab 10 00       	push   $0x10ab14
  107b76:	e8 85 bc ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tedi:   \t\t%08x\n", &tf->regs.edi, tf->regs.edi);
  107b7b:	58                   	pop    %eax
  107b7c:	ff 33                	pushl  (%ebx)
  107b7e:	53                   	push   %ebx
  107b7f:	68 b1 a9 10 00       	push   $0x10a9b1
  107b84:	6a 1a                	push   $0x1a
  107b86:	68 14 ab 10 00       	push   $0x10ab14
  107b8b:	e8 70 bc ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tesi:   \t\t%08x\n", &tf->regs.esi, tf->regs.esi);
  107b90:	83 c4 14             	add    $0x14,%esp
  107b93:	8d 43 04             	lea    0x4(%ebx),%eax
  107b96:	ff 73 04             	pushl  0x4(%ebx)
  107b99:	50                   	push   %eax
  107b9a:	68 c7 a9 10 00       	push   $0x10a9c7
  107b9f:	6a 1b                	push   $0x1b
  107ba1:	68 14 ab 10 00       	push   $0x10ab14
  107ba6:	e8 55 bc ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tebp:   \t\t%08x\n", &tf->regs.ebp, tf->regs.ebp);
  107bab:	83 c4 14             	add    $0x14,%esp
  107bae:	8d 43 08             	lea    0x8(%ebx),%eax
  107bb1:	ff 73 08             	pushl  0x8(%ebx)
  107bb4:	50                   	push   %eax
  107bb5:	68 dd a9 10 00       	push   $0x10a9dd
  107bba:	6a 1c                	push   $0x1c
  107bbc:	68 14 ab 10 00       	push   $0x10ab14
  107bc1:	e8 3a bc ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
  107bc6:	83 c4 14             	add    $0x14,%esp
  107bc9:	8d 43 0c             	lea    0xc(%ebx),%eax
  107bcc:	ff 73 0c             	pushl  0xc(%ebx)
  107bcf:	50                   	push   %eax
  107bd0:	68 f3 a9 10 00       	push   $0x10a9f3
  107bd5:	6a 1d                	push   $0x1d
  107bd7:	68 14 ab 10 00       	push   $0x10ab14
  107bdc:	e8 1f bc ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tebx:   \t\t%08x\n", &tf->regs.ebx, tf->regs.ebx);
  107be1:	83 c4 14             	add    $0x14,%esp
  107be4:	8d 43 10             	lea    0x10(%ebx),%eax
  107be7:	ff 73 10             	pushl  0x10(%ebx)
  107bea:	50                   	push   %eax
  107beb:	68 09 aa 10 00       	push   $0x10aa09
  107bf0:	6a 1e                	push   $0x1e
  107bf2:	68 14 ab 10 00       	push   $0x10ab14
  107bf7:	e8 04 bc ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tedx:   \t\t%08x\n", &tf->regs.edx, tf->regs.edx);
  107bfc:	83 c4 14             	add    $0x14,%esp
  107bff:	8d 43 14             	lea    0x14(%ebx),%eax
  107c02:	ff 73 14             	pushl  0x14(%ebx)
  107c05:	50                   	push   %eax
  107c06:	68 1f aa 10 00       	push   $0x10aa1f
  107c0b:	6a 1f                	push   $0x1f
  107c0d:	68 14 ab 10 00       	push   $0x10ab14
  107c12:	e8 e9 bb ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tecx:   \t\t%08x\n", &tf->regs.ecx, tf->regs.ecx);
  107c17:	83 c4 14             	add    $0x14,%esp
  107c1a:	8d 43 18             	lea    0x18(%ebx),%eax
  107c1d:	ff 73 18             	pushl  0x18(%ebx)
  107c20:	50                   	push   %eax
  107c21:	68 35 aa 10 00       	push   $0x10aa35
  107c26:	6a 20                	push   $0x20
  107c28:	68 14 ab 10 00       	push   $0x10ab14
  107c2d:	e8 ce bb ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\teax:   \t\t%08x\n", &tf->regs.eax, tf->regs.eax);
  107c32:	83 c4 14             	add    $0x14,%esp
  107c35:	8d 43 1c             	lea    0x1c(%ebx),%eax
  107c38:	ff 73 1c             	pushl  0x1c(%ebx)
  107c3b:	50                   	push   %eax
  107c3c:	68 4b aa 10 00       	push   $0x10aa4b
  107c41:	6a 21                	push   $0x21
  107c43:	68 14 ab 10 00       	push   $0x10ab14
  107c48:	e8 b3 bb ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tes:    \t\t%08x\n", &tf->es, tf->es);
  107c4d:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
  107c51:	83 c4 14             	add    $0x14,%esp
  107c54:	50                   	push   %eax
  107c55:	8d 43 20             	lea    0x20(%ebx),%eax
  107c58:	50                   	push   %eax
  107c59:	68 61 aa 10 00       	push   $0x10aa61
  107c5e:	6a 22                	push   $0x22
  107c60:	68 14 ab 10 00       	push   $0x10ab14
  107c65:	e8 96 bb ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tds:    \t\t%08x\n", &tf->ds, tf->ds);
  107c6a:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
  107c6e:	83 c4 14             	add    $0x14,%esp
  107c71:	50                   	push   %eax
  107c72:	8d 43 24             	lea    0x24(%ebx),%eax
  107c75:	50                   	push   %eax
  107c76:	68 77 aa 10 00       	push   $0x10aa77
  107c7b:	6a 23                	push   $0x23
  107c7d:	68 14 ab 10 00       	push   $0x10ab14
  107c82:	e8 79 bb ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\ttrapno:\t\t%08x\n", &tf->trapno, tf->trapno);
  107c87:	83 c4 14             	add    $0x14,%esp
  107c8a:	8d 43 28             	lea    0x28(%ebx),%eax
  107c8d:	ff 73 28             	pushl  0x28(%ebx)
  107c90:	50                   	push   %eax
  107c91:	68 8d aa 10 00       	push   $0x10aa8d
  107c96:	6a 24                	push   $0x24
  107c98:	68 14 ab 10 00       	push   $0x10ab14
  107c9d:	e8 5e bb ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\terr:   \t\t%08x\n", &tf->err, tf->err);
  107ca2:	83 c4 14             	add    $0x14,%esp
  107ca5:	8d 43 2c             	lea    0x2c(%ebx),%eax
  107ca8:	ff 73 2c             	pushl  0x2c(%ebx)
  107cab:	50                   	push   %eax
  107cac:	68 a3 aa 10 00       	push   $0x10aaa3
  107cb1:	6a 25                	push   $0x25
  107cb3:	68 14 ab 10 00       	push   $0x10ab14
  107cb8:	e8 43 bb ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\teip:   \t\t%08x\n", &tf->eip, tf->eip);
  107cbd:	83 c4 14             	add    $0x14,%esp
  107cc0:	8d 43 30             	lea    0x30(%ebx),%eax
  107cc3:	ff 73 30             	pushl  0x30(%ebx)
  107cc6:	50                   	push   %eax
  107cc7:	68 b9 aa 10 00       	push   $0x10aab9
  107ccc:	6a 26                	push   $0x26
  107cce:	68 14 ab 10 00       	push   $0x10ab14
  107cd3:	e8 28 bb ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tcs:    \t\t%08x\n", &tf->cs, tf->cs);
  107cd8:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  107cdc:	83 c4 14             	add    $0x14,%esp
  107cdf:	50                   	push   %eax
  107ce0:	8d 43 34             	lea    0x34(%ebx),%eax
  107ce3:	50                   	push   %eax
  107ce4:	68 cf aa 10 00       	push   $0x10aacf
  107ce9:	6a 27                	push   $0x27
  107ceb:	68 14 ab 10 00       	push   $0x10ab14
  107cf0:	e8 0b bb ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\teflags:\t\t%08x\n", &tf->eflags, tf->eflags);
  107cf5:	83 c4 14             	add    $0x14,%esp
  107cf8:	8d 43 38             	lea    0x38(%ebx),%eax
  107cfb:	ff 73 38             	pushl  0x38(%ebx)
  107cfe:	50                   	push   %eax
  107cff:	68 e5 aa 10 00       	push   $0x10aae5
  107d04:	6a 28                	push   $0x28
  107d06:	68 14 ab 10 00       	push   $0x10ab14
  107d0b:	e8 f0 ba ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->esp, tf->esp);
  107d10:	83 c4 14             	add    $0x14,%esp
  107d13:	8d 43 3c             	lea    0x3c(%ebx),%eax
  107d16:	ff 73 3c             	pushl  0x3c(%ebx)
  107d19:	50                   	push   %eax
  107d1a:	68 f3 a9 10 00       	push   $0x10a9f3
  107d1f:	6a 29                	push   $0x29
  107d21:	68 14 ab 10 00       	push   $0x10ab14
  107d26:	e8 d5 ba ff ff       	call   103800 <debug_normal>
    KERN_DEBUG("\t%08x:\tss:    \t\t%08x\n", &tf->ss, tf->ss);
  107d2b:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
  107d2f:	83 c4 14             	add    $0x14,%esp
  107d32:	50                   	push   %eax
  107d33:	8d 43 40             	lea    0x40(%ebx),%eax
  107d36:	50                   	push   %eax
  107d37:	68 fb aa 10 00       	push   $0x10aafb
  107d3c:	6a 2a                	push   $0x2a
  107d3e:	68 14 ab 10 00       	push   $0x10ab14
  107d43:	e8 b8 ba ff ff       	call   103800 <debug_normal>
    debug_unlock();
  107d48:	83 c4 20             	add    $0x20,%esp
  107d4b:	e8 60 ba ff ff       	call   1037b0 <debug_unlock>
    trap_dump(tf);

    KERN_PANIC("cpu [%d] pid [%d] Trap %d @ 0x%08x.\n", get_pcpu_idx(), get_curid(), tf->trapno, tf->eip);
  107d50:	8b 7b 30             	mov    0x30(%ebx),%edi
  107d53:	8b 73 28             	mov    0x28(%ebx),%esi
  107d56:	e8 45 f2 ff ff       	call   106fa0 <get_curid>
  107d5b:	89 c3                	mov    %eax,%ebx
  107d5d:	e8 ce dc ff ff       	call   105a30 <get_pcpu_idx>
  107d62:	83 ec 04             	sub    $0x4,%esp
  107d65:	57                   	push   %edi
  107d66:	56                   	push   %esi
  107d67:	53                   	push   %ebx
  107d68:	50                   	push   %eax
  107d69:	68 3c ab 10 00       	push   $0x10ab3c
  107d6e:	6a 35                	push   $0x35
  107d70:	68 14 ab 10 00       	push   $0x10ab14
  107d75:	e8 d6 ba ff ff       	call   103850 <debug_panic>
}
  107d7a:	83 c4 20             	add    $0x20,%esp
  107d7d:	5b                   	pop    %ebx
  107d7e:	5e                   	pop    %esi
  107d7f:	5f                   	pop    %edi
  107d80:	c3                   	ret    
  107d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107d8f:	90                   	nop

00107d90 <pgflt_handler>:

void pgflt_handler(tf_t *tf)
{
  107d90:	57                   	push   %edi
  107d91:	56                   	push   %esi
  107d92:	53                   	push   %ebx
    unsigned int cur_pid;
    unsigned int errno;
    unsigned int fault_va;

    cur_pid = get_curid();
  107d93:	e8 08 f2 ff ff       	call   106fa0 <get_curid>
  107d98:	89 c6                	mov    %eax,%esi
    errno = tf->err;
  107d9a:	8b 44 24 10          	mov    0x10(%esp),%eax
  107d9e:	8b 78 2c             	mov    0x2c(%eax),%edi
    fault_va = rcr2();
  107da1:	e8 7a c7 ff ff       	call   104520 <rcr2>
  107da6:	89 c3                	mov    %eax,%ebx

    // Uncomment this line to see information about the page fault
    // KERN_DEBUG("Page fault: VA 0x%08x, errno 0x%08x, process %d, EIP 0x%08x.\n",
    //            fault_va, errno, cur_pid, uctx_pool[cur_pid].eip);

    if (errno & PFE_PR) {
  107da8:	f7 c7 01 00 00 00    	test   $0x1,%edi
  107dae:	75 20                	jne    107dd0 <pgflt_handler+0x40>
        KERN_PANIC("cpu %u pid %u Permission denied: va = 0x%08x, errno = 0x%08x.\n",
                   get_pcpu_idx(), get_curid(), fault_va, errno);
        return;
    }

    if (alloc_page(cur_pid, fault_va, PTE_W | PTE_U | PTE_P) == MagicNumber) {
  107db0:	83 ec 04             	sub    $0x4,%esp
  107db3:	6a 07                	push   $0x7
  107db5:	50                   	push   %eax
  107db6:	56                   	push   %esi
  107db7:	e8 a4 ec ff ff       	call   106a60 <alloc_page>
  107dbc:	83 c4 10             	add    $0x10,%esp
  107dbf:	3d 01 00 10 00       	cmp    $0x100001,%eax
  107dc4:	74 3a                	je     107e00 <pgflt_handler+0x70>
        KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n",
                   fault_va, errno);
    }
}
  107dc6:	5b                   	pop    %ebx
  107dc7:	5e                   	pop    %esi
  107dc8:	5f                   	pop    %edi
  107dc9:	c3                   	ret    
  107dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        KERN_PANIC("cpu %u pid %u Permission denied: va = 0x%08x, errno = 0x%08x.\n",
  107dd0:	e8 cb f1 ff ff       	call   106fa0 <get_curid>
  107dd5:	89 c6                	mov    %eax,%esi
  107dd7:	e8 54 dc ff ff       	call   105a30 <get_pcpu_idx>
  107ddc:	83 ec 04             	sub    $0x4,%esp
  107ddf:	57                   	push   %edi
  107de0:	53                   	push   %ebx
  107de1:	56                   	push   %esi
  107de2:	50                   	push   %eax
  107de3:	68 64 ab 10 00       	push   $0x10ab64
  107de8:	6a 47                	push   $0x47
  107dea:	68 14 ab 10 00       	push   $0x10ab14
  107def:	e8 5c ba ff ff       	call   103850 <debug_panic>
        return;
  107df4:	83 c4 20             	add    $0x20,%esp
}
  107df7:	5b                   	pop    %ebx
  107df8:	5e                   	pop    %esi
  107df9:	5f                   	pop    %edi
  107dfa:	c3                   	ret    
  107dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  107dff:	90                   	nop
        KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n",
  107e00:	83 ec 0c             	sub    $0xc,%esp
  107e03:	57                   	push   %edi
  107e04:	53                   	push   %ebx
  107e05:	68 a4 ab 10 00       	push   $0x10aba4
  107e0a:	6a 4d                	push   $0x4d
  107e0c:	68 14 ab 10 00       	push   $0x10ab14
  107e11:	e8 3a ba ff ff       	call   103850 <debug_panic>
  107e16:	83 c4 20             	add    $0x20,%esp
}
  107e19:	5b                   	pop    %ebx
  107e1a:	5e                   	pop    %esi
  107e1b:	5f                   	pop    %edi
  107e1c:	c3                   	ret    
  107e1d:	8d 76 00             	lea    0x0(%esi),%esi

00107e20 <exception_handler>:
 * We currently only handle the page fault exception.
 * All other exceptions should be routed to the default exception handler.
 */
void exception_handler(tf_t *tf)
{
    if (tf->trapno == T_PGFLT)
  107e20:	8b 44 24 04          	mov    0x4(%esp),%eax
  107e24:	83 78 28 0e          	cmpl   $0xe,0x28(%eax)
  107e28:	74 06                	je     107e30 <exception_handler+0x10>
        pgflt_handler(tf);
    else
        default_exception_handler(tf);
  107e2a:	e9 21 fd ff ff       	jmp    107b50 <default_exception_handler>
  107e2f:	90                   	nop
        pgflt_handler(tf);
  107e30:	e9 5b ff ff ff       	jmp    107d90 <pgflt_handler>
  107e35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00107e40 <interrupt_handler>:
/**
 * Any interrupt request other than the spurious or timer should be
 * routed to the default interrupt handler.
 */
void interrupt_handler(tf_t *tf)
{
  107e40:	83 ec 0c             	sub    $0xc,%esp
    switch (tf->trapno) {
  107e43:	8b 44 24 10          	mov    0x10(%esp),%eax
  107e47:	8b 40 28             	mov    0x28(%eax),%eax
  107e4a:	83 f8 20             	cmp    $0x20,%eax
  107e4d:	74 11                	je     107e60 <interrupt_handler+0x20>
  107e4f:	83 f8 27             	cmp    $0x27,%eax
  107e52:	74 1c                	je     107e70 <interrupt_handler+0x30>
        timer_intr_handler();
        break;
    default:
        default_intr_handler();
    }
}
  107e54:	83 c4 0c             	add    $0xc,%esp
    intr_eoi();
  107e57:	e9 94 97 ff ff       	jmp    1015f0 <intr_eoi>
  107e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    intr_eoi();
  107e60:	e8 8b 97 ff ff       	call   1015f0 <intr_eoi>
}
  107e65:	83 c4 0c             	add    $0xc,%esp
    sched_update();
  107e68:	e9 a3 f4 ff ff       	jmp    107310 <sched_update>
  107e6d:	8d 76 00             	lea    0x0(%esi),%esi
}
  107e70:	83 c4 0c             	add    $0xc,%esp
  107e73:	c3                   	ret    
  107e74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  107e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  107e7f:	90                   	nop

00107e80 <trap>:

void trap(tf_t *tf)
{
  107e80:	57                   	push   %edi
  107e81:	56                   	push   %esi
  107e82:	53                   	push   %ebx
  107e83:	8b 7c 24 10          	mov    0x10(%esp),%edi
    unsigned int cur_pid = get_curid();
  107e87:	e8 14 f1 ff ff       	call   106fa0 <get_curid>
  107e8c:	89 c3                	mov    %eax,%ebx
    unsigned int cpu_idx = get_pcpu_idx();
  107e8e:	e8 9d db ff ff       	call   105a30 <get_pcpu_idx>
    trap_cb_t handler;

    set_pdir_base(0);  // switch to the kernel's page table
  107e93:	83 ec 0c             	sub    $0xc,%esp
  107e96:	6a 00                	push   $0x0
    unsigned int cpu_idx = get_pcpu_idx();
  107e98:	89 c6                	mov    %eax,%esi
    set_pdir_base(0);  // switch to the kernel's page table
  107e9a:	e8 b1 e5 ff ff       	call   106450 <set_pdir_base>

    last_active[cpu_idx] = cur_pid;
  107e9f:	89 1c b5 c0 ff e1 00 	mov    %ebx,0xe1ffc0(,%esi,4)

    handler = TRAP_HANDLER[get_pcpu_idx()][tf->trapno];
  107ea6:	e8 85 db ff ff       	call   105a30 <get_pcpu_idx>
  107eab:	8b 57 28             	mov    0x28(%edi),%edx

    if (handler) {
  107eae:	83 c4 10             	add    $0x10,%esp
    handler = TRAP_HANDLER[get_pcpu_idx()][tf->trapno];
  107eb1:	c1 e0 08             	shl    $0x8,%eax
  107eb4:	01 d0                	add    %edx,%eax
  107eb6:	8b 04 85 00 b0 9d 00 	mov    0x9db000(,%eax,4),%eax
    if (handler) {
  107ebd:	85 c0                	test   %eax,%eax
  107ebf:	74 47                	je     107f08 <trap+0x88>
        handler(tf);
  107ec1:	83 ec 0c             	sub    $0xc,%esp
  107ec4:	57                   	push   %edi
  107ec5:	ff d0                	call   *%eax
  107ec7:	83 c4 10             	add    $0x10,%esp
    } else {
        KERN_WARN("No handler for user trap 0x%x, process %d, eip 0x%08x.\n",
                  tf->trapno, cur_pid, tf->eip);
    }

    if (last_active[cpu_idx] != cur_pid) {
  107eca:	39 1c b5 c0 ff e1 00 	cmp    %ebx,0xe1ffc0(,%esi,4)
  107ed1:	74 0c                	je     107edf <trap+0x5f>
        kstack_switch(cur_pid);
  107ed3:	83 ec 0c             	sub    $0xc,%esp
  107ed6:	53                   	push   %ebx
  107ed7:	e8 d4 c0 ff ff       	call   103fb0 <kstack_switch>
  107edc:	83 c4 10             	add    $0x10,%esp
    }
    set_pdir_base(cur_pid);
  107edf:	83 ec 0c             	sub    $0xc,%esp
  107ee2:	53                   	push   %ebx
  107ee3:	e8 68 e5 ff ff       	call   106450 <set_pdir_base>

    last_active[cpu_idx] = 0;
    trap_return((void *) tf);
  107ee8:	83 c4 10             	add    $0x10,%esp
    last_active[cpu_idx] = 0;
  107eeb:	c7 04 b5 c0 ff e1 00 	movl   $0x0,0xe1ffc0(,%esi,4)
  107ef2:	00 00 00 00 
    trap_return((void *) tf);
  107ef6:	89 7c 24 10          	mov    %edi,0x10(%esp)
}
  107efa:	5b                   	pop    %ebx
  107efb:	5e                   	pop    %esi
  107efc:	5f                   	pop    %edi
    trap_return((void *) tf);
  107efd:	e9 ae 9e ff ff       	jmp    101db0 <trap_return>
  107f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        KERN_WARN("No handler for user trap 0x%x, process %d, eip 0x%08x.\n",
  107f08:	83 ec 08             	sub    $0x8,%esp
  107f0b:	ff 77 30             	pushl  0x30(%edi)
  107f0e:	53                   	push   %ebx
  107f0f:	52                   	push   %edx
  107f10:	68 dc ab 10 00       	push   $0x10abdc
  107f15:	68 91 00 00 00       	push   $0x91
  107f1a:	68 14 ab 10 00       	push   $0x10ab14
  107f1f:	e8 fc b9 ff ff       	call   103920 <debug_warn>
  107f24:	83 c4 20             	add    $0x20,%esp
  107f27:	eb a1                	jmp    107eca <trap+0x4a>
  107f29:	66 90                	xchg   %ax,%ax
  107f2b:	66 90                	xchg   %ax,%ax
  107f2d:	66 90                	xchg   %ax,%ax
  107f2f:	90                   	nop

00107f30 <trap_init_array>:
extern BoundedBuffer bb;
extern unsigned int last_active[NUM_CPUS];
int inited = FALSE;

void trap_init_array(void)
{
  107f30:	83 ec 0c             	sub    $0xc,%esp
    KERN_ASSERT(inited == FALSE);
  107f33:	a1 40 28 99 00       	mov    0x992840,%eax
  107f38:	85 c0                	test   %eax,%eax
  107f3a:	75 24                	jne    107f60 <trap_init_array+0x30>
    memzero(&TRAP_HANDLER, sizeof(trap_cb_t) * 8 * 256);
  107f3c:	83 ec 08             	sub    $0x8,%esp
  107f3f:	68 00 20 00 00       	push   $0x2000
  107f44:	68 00 b0 9d 00       	push   $0x9db000
  107f49:	e8 b2 b7 ff ff       	call   103700 <memzero>
    inited = TRUE;
  107f4e:	c7 05 40 28 99 00 01 	movl   $0x1,0x992840
  107f55:	00 00 00 
}
  107f58:	83 c4 1c             	add    $0x1c,%esp
  107f5b:	c3                   	ret    
  107f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    KERN_ASSERT(inited == FALSE);
  107f60:	68 14 ac 10 00       	push   $0x10ac14
  107f65:	68 df 92 10 00       	push   $0x1092df
  107f6a:	6a 12                	push   $0x12
  107f6c:	68 8c ac 10 00       	push   $0x10ac8c
  107f71:	e8 da b8 ff ff       	call   103850 <debug_panic>
  107f76:	83 c4 10             	add    $0x10,%esp
  107f79:	eb c1                	jmp    107f3c <trap_init_array+0xc>
  107f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  107f7f:	90                   	nop

00107f80 <trap_handler_register>:

void trap_handler_register(int cpu_idx, int trapno, trap_cb_t cb)
{
  107f80:	57                   	push   %edi
  107f81:	56                   	push   %esi
  107f82:	53                   	push   %ebx
  107f83:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  107f87:	8b 7c 24 14          	mov    0x14(%esp),%edi
  107f8b:	8b 74 24 18          	mov    0x18(%esp),%esi
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  107f8f:	83 fb 07             	cmp    $0x7,%ebx
  107f92:	77 1c                	ja     107fb0 <trap_handler_register+0x30>
    KERN_ASSERT(0 <= trapno && trapno < 256);
  107f94:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  107f9a:	77 35                	ja     107fd1 <trap_handler_register+0x51>
    KERN_ASSERT(cb != NULL);
  107f9c:	85 f6                	test   %esi,%esi
  107f9e:	74 4e                	je     107fee <trap_handler_register+0x6e>

    TRAP_HANDLER[cpu_idx][trapno] = cb;
  107fa0:	c1 e3 08             	shl    $0x8,%ebx
  107fa3:	01 fb                	add    %edi,%ebx
  107fa5:	89 34 9d 00 b0 9d 00 	mov    %esi,0x9db000(,%ebx,4)
}
  107fac:	5b                   	pop    %ebx
  107fad:	5e                   	pop    %esi
  107fae:	5f                   	pop    %edi
  107faf:	c3                   	ret    
    KERN_ASSERT(0 <= cpu_idx && cpu_idx < 8);
  107fb0:	68 24 ac 10 00       	push   $0x10ac24
  107fb5:	68 df 92 10 00       	push   $0x1092df
  107fba:	6a 19                	push   $0x19
  107fbc:	68 8c ac 10 00       	push   $0x10ac8c
  107fc1:	e8 8a b8 ff ff       	call   103850 <debug_panic>
  107fc6:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(0 <= trapno && trapno < 256);
  107fc9:	81 ff ff 00 00 00    	cmp    $0xff,%edi
  107fcf:	76 cb                	jbe    107f9c <trap_handler_register+0x1c>
  107fd1:	68 40 ac 10 00       	push   $0x10ac40
  107fd6:	68 df 92 10 00       	push   $0x1092df
  107fdb:	6a 1a                	push   $0x1a
  107fdd:	68 8c ac 10 00       	push   $0x10ac8c
  107fe2:	e8 69 b8 ff ff       	call   103850 <debug_panic>
  107fe7:	83 c4 10             	add    $0x10,%esp
    KERN_ASSERT(cb != NULL);
  107fea:	85 f6                	test   %esi,%esi
  107fec:	75 b2                	jne    107fa0 <trap_handler_register+0x20>
  107fee:	68 5c ac 10 00       	push   $0x10ac5c
    TRAP_HANDLER[cpu_idx][trapno] = cb;
  107ff3:	c1 e3 08             	shl    $0x8,%ebx
    KERN_ASSERT(cb != NULL);
  107ff6:	68 df 92 10 00       	push   $0x1092df
    TRAP_HANDLER[cpu_idx][trapno] = cb;
  107ffb:	01 fb                	add    %edi,%ebx
    KERN_ASSERT(cb != NULL);
  107ffd:	6a 1b                	push   $0x1b
  107fff:	68 8c ac 10 00       	push   $0x10ac8c
  108004:	e8 47 b8 ff ff       	call   103850 <debug_panic>
  108009:	83 c4 10             	add    $0x10,%esp
    TRAP_HANDLER[cpu_idx][trapno] = cb;
  10800c:	89 34 9d 00 b0 9d 00 	mov    %esi,0x9db000(,%ebx,4)
}
  108013:	5b                   	pop    %ebx
  108014:	5e                   	pop    %esi
  108015:	5f                   	pop    %edi
  108016:	c3                   	ret    
  108017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10801e:	66 90                	xchg   %ax,%ax

00108020 <trap_init>:

void trap_init(unsigned int cpu_idx)
{
  108020:	57                   	push   %edi
  108021:	56                   	push   %esi
  108022:	53                   	push   %ebx
  108023:	8b 74 24 10          	mov    0x10(%esp),%esi
    int trapno;

    if (cpu_idx == 0) {
  108027:	85 f6                	test   %esi,%esi
  108029:	0f 84 73 01 00 00    	je     1081a2 <trap_init+0x182>
        trap_init_array();
    }

    KERN_INFO_CPU("Register trap handlers...\n", cpu_idx);
  10802f:	83 ec 08             	sub    $0x8,%esp
  108032:	56                   	push   %esi
  108033:	68 1c ad 10 00       	push   $0x10ad1c
  108038:	e8 93 b7 ff ff       	call   1037d0 <debug_info>
  10803d:	83 c4 10             	add    $0x10,%esp
{
  108040:	31 c0                	xor    %eax,%eax
        // Exceptions
        if ((T_DIVIDE <= trapno && trapno <= T_SIMD) || trapno == T_SECEV) {
            trap_handler_register(cpu_idx, trapno, exception_handler);
        }
        // Interrupts
        else if ((T_IRQ0 + IRQ_TIMER <= trapno && trapno <= T_IRQ0 + IRQ_RTC)
  108042:	bf ff f1 0e 00       	mov    $0xef1ff,%edi
        if ((T_DIVIDE <= trapno && trapno <= T_SIMD) || trapno == T_SECEV) {
  108047:	8d 58 01             	lea    0x1(%eax),%ebx
  10804a:	83 f8 13             	cmp    $0x13,%eax
  10804d:	76 38                	jbe    108087 <trap_init+0x67>
  10804f:	90                   	nop
  108050:	83 f8 1e             	cmp    $0x1e,%eax
  108053:	74 32                	je     108087 <trap_init+0x67>
        else if ((T_IRQ0 + IRQ_TIMER <= trapno && trapno <= T_IRQ0 + IRQ_RTC)
  108055:	8d 50 e0             	lea    -0x20(%eax),%edx
  108058:	83 fa 13             	cmp    $0x13,%edx
  10805b:	0f 86 af 00 00 00    	jbe    108110 <trap_init+0xf0>
                 || (T_IRQ0 + IRQ_MOUSE <= trapno && trapno <= T_IRQ0 + IRQ_IDE2)
                 || (T_LTIMER <= trapno && trapno <= T_PERFCTR)
                 || (trapno == T_DEFAULT)) {
  108061:	3d fe 00 00 00       	cmp    $0xfe,%eax
  108066:	0f 84 ad 00 00 00    	je     108119 <trap_init+0xf9>
            trap_handler_register(cpu_idx, trapno, interrupt_handler);
        }
        // Syscall
        else if (trapno == T_SYSCALL) {
  10806c:	83 f8 30             	cmp    $0x30,%eax
  10806f:	0f 84 bb 00 00 00    	je     108130 <trap_init+0x110>
    for (trapno = 0; trapno < 256; trapno++) {
  108075:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
  10807b:	74 24                	je     1080a1 <trap_init+0x81>
{
  10807d:	89 d8                	mov    %ebx,%eax
        if ((T_DIVIDE <= trapno && trapno <= T_SIMD) || trapno == T_SECEV) {
  10807f:	8d 58 01             	lea    0x1(%eax),%ebx
  108082:	83 f8 13             	cmp    $0x13,%eax
  108085:	77 c9                	ja     108050 <trap_init+0x30>
            trap_handler_register(cpu_idx, trapno, exception_handler);
  108087:	83 ec 04             	sub    $0x4,%esp
  10808a:	68 20 7e 10 00       	push   $0x107e20
  10808f:	50                   	push   %eax
  108090:	56                   	push   %esi
  108091:	e8 ea fe ff ff       	call   107f80 <trap_handler_register>
  108096:	83 c4 10             	add    $0x10,%esp
    for (trapno = 0; trapno < 256; trapno++) {
  108099:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
  10809f:	75 dc                	jne    10807d <trap_init+0x5d>
            trap_handler_register(cpu_idx, trapno, syscall_dispatch);
        }
    }

    KERN_INFO_CPU("Done.\n", cpu_idx);
  1080a1:	85 f6                	test   %esi,%esi
  1080a3:	0f 85 a1 00 00 00    	jne    10814a <trap_init+0x12a>
  1080a9:	83 ec 0c             	sub    $0xc,%esp
  1080ac:	68 67 ac 10 00       	push   $0x10ac67
  1080b1:	e8 1a b7 ff ff       	call   1037d0 <debug_info>

    // Initialize bounded buffer
    if (cpu_idx == 0) {
        BB_init(&bb);
  1080b6:	c7 04 24 80 fd e1 00 	movl   $0xe1fd80,(%esp)
  1080bd:	e8 ee d0 ff ff       	call   1051b0 <BB_init>
    }
    last_active[cpu_idx] = 0;

    KERN_INFO_CPU("Enabling interrupts...\n", cpu_idx);
  1080c2:	c7 04 24 d4 ac 10 00 	movl   $0x10acd4,(%esp)
    last_active[cpu_idx] = 0;
  1080c9:	c7 05 c0 ff e1 00 00 	movl   $0x0,0xe1ffc0
  1080d0:	00 00 00 
    KERN_INFO_CPU("Enabling interrupts...\n", cpu_idx);
  1080d3:	e8 f8 b6 ff ff       	call   1037d0 <debug_info>

    /* enable interrupts */
    intr_enable(IRQ_TIMER, cpu_idx);
  1080d8:	5e                   	pop    %esi
  1080d9:	5f                   	pop    %edi
  1080da:	6a 00                	push   $0x0
  1080dc:	6a 00                	push   $0x0
  1080de:	e8 bd 93 ff ff       	call   1014a0 <intr_enable>
    intr_enable(IRQ_KBD, cpu_idx);
  1080e3:	58                   	pop    %eax
  1080e4:	5a                   	pop    %edx
  1080e5:	6a 00                	push   $0x0
  1080e7:	6a 01                	push   $0x1
  1080e9:	e8 b2 93 ff ff       	call   1014a0 <intr_enable>
    intr_enable(IRQ_SERIAL13, cpu_idx);
  1080ee:	59                   	pop    %ecx
  1080ef:	5b                   	pop    %ebx
  1080f0:	6a 00                	push   $0x0
  1080f2:	6a 04                	push   $0x4
  1080f4:	e8 a7 93 ff ff       	call   1014a0 <intr_enable>

    KERN_INFO_CPU("Done.\n", cpu_idx);
  1080f9:	83 c4 10             	add    $0x10,%esp
  1080fc:	c7 44 24 10 67 ac 10 	movl   $0x10ac67,0x10(%esp)
  108103:	00 
}
  108104:	5b                   	pop    %ebx
  108105:	5e                   	pop    %esi
  108106:	5f                   	pop    %edi
    KERN_INFO_CPU("Done.\n", cpu_idx);
  108107:	e9 c4 b6 ff ff       	jmp    1037d0 <debug_info>
  10810c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        else if ((T_IRQ0 + IRQ_TIMER <= trapno && trapno <= T_IRQ0 + IRQ_RTC)
  108110:	0f a3 d7             	bt     %edx,%edi
  108113:	0f 83 53 ff ff ff    	jae    10806c <trap_init+0x4c>
            trap_handler_register(cpu_idx, trapno, interrupt_handler);
  108119:	83 ec 04             	sub    $0x4,%esp
  10811c:	68 40 7e 10 00       	push   $0x107e40
  108121:	50                   	push   %eax
  108122:	56                   	push   %esi
  108123:	e8 58 fe ff ff       	call   107f80 <trap_handler_register>
  108128:	83 c4 10             	add    $0x10,%esp
  10812b:	e9 45 ff ff ff       	jmp    108075 <trap_init+0x55>
            trap_handler_register(cpu_idx, trapno, syscall_dispatch);
  108130:	83 ec 04             	sub    $0x4,%esp
  108133:	68 50 7a 10 00       	push   $0x107a50
  108138:	6a 30                	push   $0x30
  10813a:	56                   	push   %esi
  10813b:	e8 40 fe ff ff       	call   107f80 <trap_handler_register>
  108140:	83 c4 10             	add    $0x10,%esp
{
  108143:	89 d8                	mov    %ebx,%eax
  108145:	e9 35 ff ff ff       	jmp    10807f <trap_init+0x5f>
    KERN_INFO_CPU("Done.\n", cpu_idx);
  10814a:	83 ec 08             	sub    $0x8,%esp
  10814d:	56                   	push   %esi
  10814e:	68 79 ac 10 00       	push   $0x10ac79
  108153:	e8 78 b6 ff ff       	call   1037d0 <debug_info>
    KERN_INFO_CPU("Enabling interrupts...\n", cpu_idx);
  108158:	58                   	pop    %eax
  108159:	5a                   	pop    %edx
  10815a:	56                   	push   %esi
  10815b:	68 f8 ac 10 00       	push   $0x10acf8
    last_active[cpu_idx] = 0;
  108160:	c7 04 b5 c0 ff e1 00 	movl   $0x0,0xe1ffc0(,%esi,4)
  108167:	00 00 00 00 
    KERN_INFO_CPU("Enabling interrupts...\n", cpu_idx);
  10816b:	e8 60 b6 ff ff       	call   1037d0 <debug_info>
    intr_enable(IRQ_TIMER, cpu_idx);
  108170:	59                   	pop    %ecx
  108171:	5b                   	pop    %ebx
  108172:	56                   	push   %esi
  108173:	6a 00                	push   $0x0
  108175:	e8 26 93 ff ff       	call   1014a0 <intr_enable>
    intr_enable(IRQ_KBD, cpu_idx);
  10817a:	5f                   	pop    %edi
  10817b:	58                   	pop    %eax
  10817c:	56                   	push   %esi
  10817d:	6a 01                	push   $0x1
  10817f:	e8 1c 93 ff ff       	call   1014a0 <intr_enable>
    intr_enable(IRQ_SERIAL13, cpu_idx);
  108184:	58                   	pop    %eax
  108185:	5a                   	pop    %edx
  108186:	56                   	push   %esi
  108187:	6a 04                	push   $0x4
  108189:	e8 12 93 ff ff       	call   1014a0 <intr_enable>
    KERN_INFO_CPU("Done.\n", cpu_idx);
  10818e:	59                   	pop    %ecx
  10818f:	5b                   	pop    %ebx
  108190:	56                   	push   %esi
  108191:	68 79 ac 10 00       	push   $0x10ac79
  108196:	e8 35 b6 ff ff       	call   1037d0 <debug_info>
  10819b:	83 c4 10             	add    $0x10,%esp
}
  10819e:	5b                   	pop    %ebx
  10819f:	5e                   	pop    %esi
  1081a0:	5f                   	pop    %edi
  1081a1:	c3                   	ret    
        trap_init_array();
  1081a2:	e8 89 fd ff ff       	call   107f30 <trap_init_array>
    KERN_INFO_CPU("Register trap handlers...\n", cpu_idx);
  1081a7:	83 ec 0c             	sub    $0xc,%esp
  1081aa:	68 ac ac 10 00       	push   $0x10acac
  1081af:	e8 1c b6 ff ff       	call   1037d0 <debug_info>
  1081b4:	83 c4 10             	add    $0x10,%esp
  1081b7:	e9 84 fe ff ff       	jmp    108040 <trap_init+0x20>
  1081bc:	66 90                	xchg   %ax,%ax
  1081be:	66 90                	xchg   %ax,%ax

001081c0 <__udivdi3>:
  1081c0:	f3 0f 1e fb          	endbr32 
  1081c4:	55                   	push   %ebp
  1081c5:	57                   	push   %edi
  1081c6:	56                   	push   %esi
  1081c7:	53                   	push   %ebx
  1081c8:	83 ec 1c             	sub    $0x1c,%esp
  1081cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  1081cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  1081d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  1081d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  1081db:	85 d2                	test   %edx,%edx
  1081dd:	75 19                	jne    1081f8 <__udivdi3+0x38>
  1081df:	39 f3                	cmp    %esi,%ebx
  1081e1:	76 4d                	jbe    108230 <__udivdi3+0x70>
  1081e3:	31 ff                	xor    %edi,%edi
  1081e5:	89 e8                	mov    %ebp,%eax
  1081e7:	89 f2                	mov    %esi,%edx
  1081e9:	f7 f3                	div    %ebx
  1081eb:	89 fa                	mov    %edi,%edx
  1081ed:	83 c4 1c             	add    $0x1c,%esp
  1081f0:	5b                   	pop    %ebx
  1081f1:	5e                   	pop    %esi
  1081f2:	5f                   	pop    %edi
  1081f3:	5d                   	pop    %ebp
  1081f4:	c3                   	ret    
  1081f5:	8d 76 00             	lea    0x0(%esi),%esi
  1081f8:	39 f2                	cmp    %esi,%edx
  1081fa:	76 14                	jbe    108210 <__udivdi3+0x50>
  1081fc:	31 ff                	xor    %edi,%edi
  1081fe:	31 c0                	xor    %eax,%eax
  108200:	89 fa                	mov    %edi,%edx
  108202:	83 c4 1c             	add    $0x1c,%esp
  108205:	5b                   	pop    %ebx
  108206:	5e                   	pop    %esi
  108207:	5f                   	pop    %edi
  108208:	5d                   	pop    %ebp
  108209:	c3                   	ret    
  10820a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  108210:	0f bd fa             	bsr    %edx,%edi
  108213:	83 f7 1f             	xor    $0x1f,%edi
  108216:	75 48                	jne    108260 <__udivdi3+0xa0>
  108218:	39 f2                	cmp    %esi,%edx
  10821a:	72 06                	jb     108222 <__udivdi3+0x62>
  10821c:	31 c0                	xor    %eax,%eax
  10821e:	39 eb                	cmp    %ebp,%ebx
  108220:	77 de                	ja     108200 <__udivdi3+0x40>
  108222:	b8 01 00 00 00       	mov    $0x1,%eax
  108227:	eb d7                	jmp    108200 <__udivdi3+0x40>
  108229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  108230:	89 d9                	mov    %ebx,%ecx
  108232:	85 db                	test   %ebx,%ebx
  108234:	75 0b                	jne    108241 <__udivdi3+0x81>
  108236:	b8 01 00 00 00       	mov    $0x1,%eax
  10823b:	31 d2                	xor    %edx,%edx
  10823d:	f7 f3                	div    %ebx
  10823f:	89 c1                	mov    %eax,%ecx
  108241:	31 d2                	xor    %edx,%edx
  108243:	89 f0                	mov    %esi,%eax
  108245:	f7 f1                	div    %ecx
  108247:	89 c6                	mov    %eax,%esi
  108249:	89 e8                	mov    %ebp,%eax
  10824b:	89 f7                	mov    %esi,%edi
  10824d:	f7 f1                	div    %ecx
  10824f:	89 fa                	mov    %edi,%edx
  108251:	83 c4 1c             	add    $0x1c,%esp
  108254:	5b                   	pop    %ebx
  108255:	5e                   	pop    %esi
  108256:	5f                   	pop    %edi
  108257:	5d                   	pop    %ebp
  108258:	c3                   	ret    
  108259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  108260:	89 f9                	mov    %edi,%ecx
  108262:	b8 20 00 00 00       	mov    $0x20,%eax
  108267:	29 f8                	sub    %edi,%eax
  108269:	d3 e2                	shl    %cl,%edx
  10826b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10826f:	89 c1                	mov    %eax,%ecx
  108271:	89 da                	mov    %ebx,%edx
  108273:	d3 ea                	shr    %cl,%edx
  108275:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  108279:	09 d1                	or     %edx,%ecx
  10827b:	89 f2                	mov    %esi,%edx
  10827d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  108281:	89 f9                	mov    %edi,%ecx
  108283:	d3 e3                	shl    %cl,%ebx
  108285:	89 c1                	mov    %eax,%ecx
  108287:	d3 ea                	shr    %cl,%edx
  108289:	89 f9                	mov    %edi,%ecx
  10828b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10828f:	89 eb                	mov    %ebp,%ebx
  108291:	d3 e6                	shl    %cl,%esi
  108293:	89 c1                	mov    %eax,%ecx
  108295:	d3 eb                	shr    %cl,%ebx
  108297:	09 de                	or     %ebx,%esi
  108299:	89 f0                	mov    %esi,%eax
  10829b:	f7 74 24 08          	divl   0x8(%esp)
  10829f:	89 d6                	mov    %edx,%esi
  1082a1:	89 c3                	mov    %eax,%ebx
  1082a3:	f7 64 24 0c          	mull   0xc(%esp)
  1082a7:	39 d6                	cmp    %edx,%esi
  1082a9:	72 15                	jb     1082c0 <__udivdi3+0x100>
  1082ab:	89 f9                	mov    %edi,%ecx
  1082ad:	d3 e5                	shl    %cl,%ebp
  1082af:	39 c5                	cmp    %eax,%ebp
  1082b1:	73 04                	jae    1082b7 <__udivdi3+0xf7>
  1082b3:	39 d6                	cmp    %edx,%esi
  1082b5:	74 09                	je     1082c0 <__udivdi3+0x100>
  1082b7:	89 d8                	mov    %ebx,%eax
  1082b9:	31 ff                	xor    %edi,%edi
  1082bb:	e9 40 ff ff ff       	jmp    108200 <__udivdi3+0x40>
  1082c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  1082c3:	31 ff                	xor    %edi,%edi
  1082c5:	e9 36 ff ff ff       	jmp    108200 <__udivdi3+0x40>
  1082ca:	66 90                	xchg   %ax,%ax
  1082cc:	66 90                	xchg   %ax,%ax
  1082ce:	66 90                	xchg   %ax,%ax

001082d0 <__umoddi3>:
  1082d0:	f3 0f 1e fb          	endbr32 
  1082d4:	55                   	push   %ebp
  1082d5:	57                   	push   %edi
  1082d6:	56                   	push   %esi
  1082d7:	53                   	push   %ebx
  1082d8:	83 ec 1c             	sub    $0x1c,%esp
  1082db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  1082df:	8b 74 24 30          	mov    0x30(%esp),%esi
  1082e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  1082e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  1082eb:	85 c0                	test   %eax,%eax
  1082ed:	75 19                	jne    108308 <__umoddi3+0x38>
  1082ef:	39 df                	cmp    %ebx,%edi
  1082f1:	76 5d                	jbe    108350 <__umoddi3+0x80>
  1082f3:	89 f0                	mov    %esi,%eax
  1082f5:	89 da                	mov    %ebx,%edx
  1082f7:	f7 f7                	div    %edi
  1082f9:	89 d0                	mov    %edx,%eax
  1082fb:	31 d2                	xor    %edx,%edx
  1082fd:	83 c4 1c             	add    $0x1c,%esp
  108300:	5b                   	pop    %ebx
  108301:	5e                   	pop    %esi
  108302:	5f                   	pop    %edi
  108303:	5d                   	pop    %ebp
  108304:	c3                   	ret    
  108305:	8d 76 00             	lea    0x0(%esi),%esi
  108308:	89 f2                	mov    %esi,%edx
  10830a:	39 d8                	cmp    %ebx,%eax
  10830c:	76 12                	jbe    108320 <__umoddi3+0x50>
  10830e:	89 f0                	mov    %esi,%eax
  108310:	89 da                	mov    %ebx,%edx
  108312:	83 c4 1c             	add    $0x1c,%esp
  108315:	5b                   	pop    %ebx
  108316:	5e                   	pop    %esi
  108317:	5f                   	pop    %edi
  108318:	5d                   	pop    %ebp
  108319:	c3                   	ret    
  10831a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  108320:	0f bd e8             	bsr    %eax,%ebp
  108323:	83 f5 1f             	xor    $0x1f,%ebp
  108326:	75 50                	jne    108378 <__umoddi3+0xa8>
  108328:	39 d8                	cmp    %ebx,%eax
  10832a:	0f 82 e0 00 00 00    	jb     108410 <__umoddi3+0x140>
  108330:	89 d9                	mov    %ebx,%ecx
  108332:	39 f7                	cmp    %esi,%edi
  108334:	0f 86 d6 00 00 00    	jbe    108410 <__umoddi3+0x140>
  10833a:	89 d0                	mov    %edx,%eax
  10833c:	89 ca                	mov    %ecx,%edx
  10833e:	83 c4 1c             	add    $0x1c,%esp
  108341:	5b                   	pop    %ebx
  108342:	5e                   	pop    %esi
  108343:	5f                   	pop    %edi
  108344:	5d                   	pop    %ebp
  108345:	c3                   	ret    
  108346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10834d:	8d 76 00             	lea    0x0(%esi),%esi
  108350:	89 fd                	mov    %edi,%ebp
  108352:	85 ff                	test   %edi,%edi
  108354:	75 0b                	jne    108361 <__umoddi3+0x91>
  108356:	b8 01 00 00 00       	mov    $0x1,%eax
  10835b:	31 d2                	xor    %edx,%edx
  10835d:	f7 f7                	div    %edi
  10835f:	89 c5                	mov    %eax,%ebp
  108361:	89 d8                	mov    %ebx,%eax
  108363:	31 d2                	xor    %edx,%edx
  108365:	f7 f5                	div    %ebp
  108367:	89 f0                	mov    %esi,%eax
  108369:	f7 f5                	div    %ebp
  10836b:	89 d0                	mov    %edx,%eax
  10836d:	31 d2                	xor    %edx,%edx
  10836f:	eb 8c                	jmp    1082fd <__umoddi3+0x2d>
  108371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  108378:	89 e9                	mov    %ebp,%ecx
  10837a:	ba 20 00 00 00       	mov    $0x20,%edx
  10837f:	29 ea                	sub    %ebp,%edx
  108381:	d3 e0                	shl    %cl,%eax
  108383:	89 44 24 08          	mov    %eax,0x8(%esp)
  108387:	89 d1                	mov    %edx,%ecx
  108389:	89 f8                	mov    %edi,%eax
  10838b:	d3 e8                	shr    %cl,%eax
  10838d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  108391:	89 54 24 04          	mov    %edx,0x4(%esp)
  108395:	8b 54 24 04          	mov    0x4(%esp),%edx
  108399:	09 c1                	or     %eax,%ecx
  10839b:	89 d8                	mov    %ebx,%eax
  10839d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1083a1:	89 e9                	mov    %ebp,%ecx
  1083a3:	d3 e7                	shl    %cl,%edi
  1083a5:	89 d1                	mov    %edx,%ecx
  1083a7:	d3 e8                	shr    %cl,%eax
  1083a9:	89 e9                	mov    %ebp,%ecx
  1083ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  1083af:	d3 e3                	shl    %cl,%ebx
  1083b1:	89 c7                	mov    %eax,%edi
  1083b3:	89 d1                	mov    %edx,%ecx
  1083b5:	89 f0                	mov    %esi,%eax
  1083b7:	d3 e8                	shr    %cl,%eax
  1083b9:	89 e9                	mov    %ebp,%ecx
  1083bb:	89 fa                	mov    %edi,%edx
  1083bd:	d3 e6                	shl    %cl,%esi
  1083bf:	09 d8                	or     %ebx,%eax
  1083c1:	f7 74 24 08          	divl   0x8(%esp)
  1083c5:	89 d1                	mov    %edx,%ecx
  1083c7:	89 f3                	mov    %esi,%ebx
  1083c9:	f7 64 24 0c          	mull   0xc(%esp)
  1083cd:	89 c6                	mov    %eax,%esi
  1083cf:	89 d7                	mov    %edx,%edi
  1083d1:	39 d1                	cmp    %edx,%ecx
  1083d3:	72 06                	jb     1083db <__umoddi3+0x10b>
  1083d5:	75 10                	jne    1083e7 <__umoddi3+0x117>
  1083d7:	39 c3                	cmp    %eax,%ebx
  1083d9:	73 0c                	jae    1083e7 <__umoddi3+0x117>
  1083db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  1083df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  1083e3:	89 d7                	mov    %edx,%edi
  1083e5:	89 c6                	mov    %eax,%esi
  1083e7:	89 ca                	mov    %ecx,%edx
  1083e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  1083ee:	29 f3                	sub    %esi,%ebx
  1083f0:	19 fa                	sbb    %edi,%edx
  1083f2:	89 d0                	mov    %edx,%eax
  1083f4:	d3 e0                	shl    %cl,%eax
  1083f6:	89 e9                	mov    %ebp,%ecx
  1083f8:	d3 eb                	shr    %cl,%ebx
  1083fa:	d3 ea                	shr    %cl,%edx
  1083fc:	09 d8                	or     %ebx,%eax
  1083fe:	83 c4 1c             	add    $0x1c,%esp
  108401:	5b                   	pop    %ebx
  108402:	5e                   	pop    %esi
  108403:	5f                   	pop    %edi
  108404:	5d                   	pop    %ebp
  108405:	c3                   	ret    
  108406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  10840d:	8d 76 00             	lea    0x0(%esi),%esi
  108410:	29 fe                	sub    %edi,%esi
  108412:	19 c3                	sbb    %eax,%ebx
  108414:	89 f2                	mov    %esi,%edx
  108416:	89 d9                	mov    %ebx,%ecx
  108418:	e9 1d ff ff ff       	jmp    10833a <__umoddi3+0x6a>
