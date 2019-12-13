
obj/boot/boot1.elf:     file format elf32-i386


Disassembly of section .text:

00007e00 <start>:
	.set SMAP_SIG, 0x0534D4150	# "SMAP"

	.globl start
start:
	.code16
	cli
    7e00:	fa                   	cli    
	cld
    7e01:	fc                   	cld    

00007e02 <seta20.1>:

	/* enable A20 */
seta20.1:
	inb	$0x64, %al
    7e02:	e4 64                	in     $0x64,%al
	testb	$0x2, %al
    7e04:	a8 02                	test   $0x2,%al
	jnz	seta20.1
    7e06:	75 fa                	jne    7e02 <seta20.1>
	movb	$0xd1, %al
    7e08:	b0 d1                	mov    $0xd1,%al
	outb	%al, $0x64
    7e0a:	e6 64                	out    %al,$0x64

00007e0c <seta20.2>:
seta20.2:
	inb	$0x64, %al
    7e0c:	e4 64                	in     $0x64,%al
	testb	$0x2, %al
    7e0e:	a8 02                	test   $0x2,%al
	jnz	seta20.2
    7e10:	75 fa                	jne    7e0c <seta20.2>
	movb	$0xdf, %al
    7e12:	b0 df                	mov    $0xdf,%al
	outb	%al, $0x60
    7e14:	e6 60                	out    %al,$0x60

00007e16 <set_video_mode.2>:

	/*
	 * print starting message
	 */
set_video_mode.2:
	movw	$STARTUP_MSG, %si
    7e16:	be ab 7e e8 81       	mov    $0x81e87eab,%esi
	call	putstr
    7e1b:	00               	add    %ah,0x31(%esi)

00007e1c <e820>:

	/*
	 * detect the physical memory map
	 */
e820:
	xorl	%ebx, %ebx		# ebx must be 0 when first calling e820
    7e1c:	66 31 db             	xor    %bx,%bx
	movl	$SMAP_SIG, %edx		# edx must be 'SMAP' when calling e820
    7e1f:	66 ba 50 41          	mov    $0x4150,%dx
    7e23:	4d                   	dec    %ebp
    7e24:	53                   	push   %ebx
	movw	$(smap + 4), %di	# set the address of the output buffer
    7e25:	bf 2a 7f         	mov    $0xb9667f2a,%edi

00007e28 <e820.1>:
e820.1:
	movl	$20, %ecx		# set the size of the output buffer
    7e28:	66 b9 14 00          	mov    $0x14,%cx
    7e2c:	00 00                	add    %al,(%eax)
	movl	$0xe820, %eax		# set the BIOS service code
    7e2e:	66 b8 20 e8          	mov    $0xe820,%ax
    7e32:	00 00                	add    %al,(%eax)
	int	$0x15			# call BIOS service e820h
    7e34:	cd 15                	int    $0x15

00007e36 <e820.2>:
e820.2:
	jc	e820.fail		# error during e820h
    7e36:	72 24                	jb     7e5c <e820.fail>
	cmpl	$SMAP_SIG, %eax		# check eax, which should be 'SMAP'
    7e38:	66 3d 50 41          	cmp    $0x4150,%ax
    7e3c:	4d                   	dec    %ebp
    7e3d:	53                   	push   %ebx
	jne	e820.fail
    7e3e:	75 1c                	jne    7e5c <e820.fail>

00007e40 <e820.3>:
e820.3:
	movl	$20, -4(%di)
    7e40:	66 c7 45 fc 14 00    	movw   $0x14,-0x4(%ebp)
    7e46:	00 00                	add    %al,(%eax)
	addw	$24, %di
    7e48:	83 c7 18             	add    $0x18,%edi
	cmpl	$0x0, %ebx		# whether it's the last descriptor
    7e4b:	66 83 fb 00          	cmp    $0x0,%bx
	je	e820.4
    7e4f:	74 02                	je     7e53 <e820.4>
	jmp	e820.1
    7e51:	eb d5                	jmp    7e28 <e820.1>

00007e53 <e820.4>:
e820.4:					# zero the descriptor after the last one
	xorb	%al, %al
    7e53:	30 c0                	xor    %al,%al
	movw	$20, %cx
    7e55:	b9 14 00 f3 aa       	mov    $0xaaf30014,%ecx
	rep	stosb
	jmp	switch_prot
    7e5a:	eb 09                	jmp    7e65 <switch_prot>

00007e5c <e820.fail>:
e820.fail:
	movw	$E820_FAIL_MSG, %si
    7e5c:	be bd 7e e8 3b       	mov    $0x3be87ebd,%esi
	call	putstr
    7e61:	00 eb                	add    %ch,%bl
	jmp	spin16
    7e63:	00                 	add    %dh,%ah

00007e64 <spin16>:

spin16:
	hlt
    7e64:	f4                   	hlt    

00007e65 <switch_prot>:

	/*
	 * load the bootstrap GDT
	 */
switch_prot:
	lgdt	gdtdesc
    7e65:	0f 01 16             	lgdtl  (%esi)
    7e68:	20 7f 0f             	and    %bh,0xf(%edi)
	movl	%cr0, %eax
    7e6b:	20 c0                	and    %al,%al
	orl	$CR0_PE_ON, %eax
    7e6d:	66 83 c8 01          	or     $0x1,%ax
	movl	%eax, %cr0
    7e71:	0f 22 c0             	mov    %eax,%cr0
	/*
	 * switch to the protected mode
	 */
	ljmp	$PROT_MODE_CSEG, $protcseg
    7e74:	ea 79 7e 08 00   	ljmp   $0xb866,$0x87e79

00007e79 <protcseg>:

	.code32
protcseg:
	movw	$PROT_MODE_DSEG, %ax
    7e79:	66 b8 10 00          	mov    $0x10,%ax
	movw	%ax, %ds
    7e7d:	8e d8                	mov    %eax,%ds
	movw	%ax, %es
    7e7f:	8e c0                	mov    %eax,%es
	movw	%ax, %fs
    7e81:	8e e0                	mov    %eax,%fs
	movw	%ax, %gs
    7e83:	8e e8                	mov    %eax,%gs
	movw	%ax, %ss
    7e85:	8e d0                	mov    %eax,%ss

	/*
	 * jump to the C part
	 * (dev, lba, smap)
	 */
	pushl	$smap
    7e87:	68 26 7f 00 00       	push   $0x7f26
	pushl	$BOOT0
    7e8c:	68 00 7c 00 00       	push   $0x7c00
	movl	(BOOT0 - 4), %eax
    7e91:	a1 fc 7b 00 00       	mov    0x7bfc,%eax
	pushl	%eax
    7e96:	50                   	push   %eax
	call	boot1main
    7e97:	e8 dd 0f 00 00       	call   8e79 <boot1main>

00007e9c <spin>:

spin:
	hlt
    7e9c:	f4                   	hlt    

00007e9d <putstr>:
/*
 * print a string (@ %si) to the screen
 */
	.globl putstr
putstr:
	pusha
    7e9d:	60                   	pusha  
	movb	$0xe, %ah
    7e9e:	b4 0e                	mov    $0xe,%ah

00007ea0 <putstr.1>:
putstr.1:
	lodsb
    7ea0:	ac                   	lods   %ds:(%esi),%al
	cmp	$0, %al
    7ea1:	3c 00                	cmp    $0x0,%al
	je	putstr.2
    7ea3:	74 04                	je     7ea9 <putstr.2>
	int	$0x10
    7ea5:	cd 10                	int    $0x10
	jmp	putstr.1
    7ea7:	eb f7                	jmp    7ea0 <putstr.1>

00007ea9 <putstr.2>:
putstr.2:
	popa
    7ea9:	61                   	popa   
	ret
    7eaa:	c3                   	ret    

00007eab <STARTUP_MSG>:
    7eab:	53                   	push   %ebx
    7eac:	74 61                	je     7f0f <gdt+0x17>
    7eae:	72 74                	jb     7f24 <gdtdesc+0x4>
    7eb0:	20 62 6f             	and    %ah,0x6f(%edx)
    7eb3:	6f                   	outsl  %ds:(%esi),(%dx)
    7eb4:	74 31                	je     7ee7 <NO_BOOTABLE_MSG+0x8>
    7eb6:	20 2e                	and    %ch,(%esi)
    7eb8:	2e 2e 0d 0a 00   	cs cs or $0x7265000a,%eax

00007ebd <E820_FAIL_MSG>:
    7ebd:	65 72 72             	gs jb  7f32 <smap+0xc>
    7ec0:	6f                   	outsl  %ds:(%esi),(%dx)
    7ec1:	72 20                	jb     7ee3 <NO_BOOTABLE_MSG+0x4>
    7ec3:	77 68                	ja     7f2d <smap+0x7>
    7ec5:	65 6e                	outsb  %gs:(%esi),(%dx)
    7ec7:	20 64 65 74          	and    %ah,0x74(%ebp,%eiz,2)
    7ecb:	65 63 74 69 6e       	arpl   %si,%gs:0x6e(%ecx,%ebp,2)
    7ed0:	67 20 6d 65          	and    %ch,0x65(%di)
    7ed4:	6d                   	insl   (%dx),%es:(%edi)
    7ed5:	6f                   	outsl  %ds:(%esi),(%dx)
    7ed6:	72 79                	jb     7f51 <smap+0x2b>
    7ed8:	20 6d 61             	and    %ch,0x61(%ebp)
    7edb:	70 0d                	jo     7eea <NO_BOOTABLE_MSG+0xb>
    7edd:	0a 00                	or     (%eax),%al

00007edf <NO_BOOTABLE_MSG>:
    7edf:	4e                   	dec    %esi
    7ee0:	6f                   	outsl  %ds:(%esi),(%dx)
    7ee1:	20 62 6f             	and    %ah,0x6f(%edx)
    7ee4:	6f                   	outsl  %ds:(%esi),(%dx)
    7ee5:	74 61                	je     7f48 <smap+0x22>
    7ee7:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
    7eeb:	70 61                	jo     7f4e <smap+0x28>
    7eed:	72 74                	jb     7f63 <smap+0x3d>
    7eef:	69 74 69 6f 6e 2e 0d 	imul   $0xa0d2e6e,0x6f(%ecx,%ebp,2),%esi
    7ef6:	0a 
    7ef7:	00                 	add    %al,(%eax)

00007ef8 <gdt>:
    7ef8:	00 00                	add    %al,(%eax)
    7efa:	00 00                	add    %al,(%eax)
    7efc:	00 00                	add    %al,(%eax)
    7efe:	00 00                	add    %al,(%eax)
    7f00:	ff                   	(bad)  
    7f01:	ff 00                	incl   (%eax)
    7f03:	00 00                	add    %al,(%eax)
    7f05:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7f0c:	00 92 cf 00 ff ff    	add    %dl,-0xff31(%edx)
    7f12:	00 00                	add    %al,(%eax)
    7f14:	00 9e 00 00 ff ff    	add    %bl,-0x10000(%esi)
    7f1a:	00 00                	add    %al,(%eax)
    7f1c:	00 92 00 00      	add    %dl,0x270000(%edx)

00007f20 <gdtdesc>:
    7f20:	27                   	daa    
    7f21:	00 f8                	add    %bh,%al
    7f23:	7e 00                	jle    7f25 <gdtdesc+0x5>
    7f25:	00                 	add    %al,(%eax)

00007f26 <smap>:
    7f26:	00 00                	add    %al,(%eax)
    7f28:	00 00                	add    %al,(%eax)
    7f2a:	00 00                	add    %al,(%eax)
    7f2c:	00 00                	add    %al,(%eax)
    7f2e:	00 00                	add    %al,(%eax)
    7f30:	00 00                	add    %al,(%eax)
    7f32:	00 00                	add    %al,(%eax)
    7f34:	00 00                	add    %al,(%eax)
    7f36:	00 00                	add    %al,(%eax)
    7f38:	00 00                	add    %al,(%eax)
    7f3a:	00 00                	add    %al,(%eax)
    7f3c:	00 00                	add    %al,(%eax)
    7f3e:	00 00                	add    %al,(%eax)
    7f40:	00 00                	add    %al,(%eax)
    7f42:	00 00                	add    %al,(%eax)
    7f44:	00 00                	add    %al,(%eax)
    7f46:	00 00                	add    %al,(%eax)
    7f48:	00 00                	add    %al,(%eax)
    7f4a:	00 00                	add    %al,(%eax)
    7f4c:	00 00                	add    %al,(%eax)
    7f4e:	00 00                	add    %al,(%eax)
    7f50:	00 00                	add    %al,(%eax)
    7f52:	00 00                	add    %al,(%eax)
    7f54:	00 00                	add    %al,(%eax)
    7f56:	00 00                	add    %al,(%eax)
    7f58:	00 00                	add    %al,(%eax)
    7f5a:	00 00                	add    %al,(%eax)
    7f5c:	00 00                	add    %al,(%eax)
    7f5e:	00 00                	add    %al,(%eax)
    7f60:	00 00                	add    %al,(%eax)
    7f62:	00 00                	add    %al,(%eax)
    7f64:	00 00                	add    %al,(%eax)
    7f66:	00 00                	add    %al,(%eax)
    7f68:	00 00                	add    %al,(%eax)
    7f6a:	00 00                	add    %al,(%eax)
    7f6c:	00 00                	add    %al,(%eax)
    7f6e:	00 00                	add    %al,(%eax)
    7f70:	00 00                	add    %al,(%eax)
    7f72:	00 00                	add    %al,(%eax)
    7f74:	00 00                	add    %al,(%eax)
    7f76:	00 00                	add    %al,(%eax)
    7f78:	00 00                	add    %al,(%eax)
    7f7a:	00 00                	add    %al,(%eax)
    7f7c:	00 00                	add    %al,(%eax)
    7f7e:	00 00                	add    %al,(%eax)
    7f80:	00 00                	add    %al,(%eax)
    7f82:	00 00                	add    %al,(%eax)
    7f84:	00 00                	add    %al,(%eax)
    7f86:	00 00                	add    %al,(%eax)
    7f88:	00 00                	add    %al,(%eax)
    7f8a:	00 00                	add    %al,(%eax)
    7f8c:	00 00                	add    %al,(%eax)
    7f8e:	00 00                	add    %al,(%eax)
    7f90:	00 00                	add    %al,(%eax)
    7f92:	00 00                	add    %al,(%eax)
    7f94:	00 00                	add    %al,(%eax)
    7f96:	00 00                	add    %al,(%eax)
    7f98:	00 00                	add    %al,(%eax)
    7f9a:	00 00                	add    %al,(%eax)
    7f9c:	00 00                	add    %al,(%eax)
    7f9e:	00 00                	add    %al,(%eax)
    7fa0:	00 00                	add    %al,(%eax)
    7fa2:	00 00                	add    %al,(%eax)
    7fa4:	00 00                	add    %al,(%eax)
    7fa6:	00 00                	add    %al,(%eax)
    7fa8:	00 00                	add    %al,(%eax)
    7faa:	00 00                	add    %al,(%eax)
    7fac:	00 00                	add    %al,(%eax)
    7fae:	00 00                	add    %al,(%eax)
    7fb0:	00 00                	add    %al,(%eax)
    7fb2:	00 00                	add    %al,(%eax)
    7fb4:	00 00                	add    %al,(%eax)
    7fb6:	00 00                	add    %al,(%eax)
    7fb8:	00 00                	add    %al,(%eax)
    7fba:	00 00                	add    %al,(%eax)
    7fbc:	00 00                	add    %al,(%eax)
    7fbe:	00 00                	add    %al,(%eax)
    7fc0:	00 00                	add    %al,(%eax)
    7fc2:	00 00                	add    %al,(%eax)
    7fc4:	00 00                	add    %al,(%eax)
    7fc6:	00 00                	add    %al,(%eax)
    7fc8:	00 00                	add    %al,(%eax)
    7fca:	00 00                	add    %al,(%eax)
    7fcc:	00 00                	add    %al,(%eax)
    7fce:	00 00                	add    %al,(%eax)
    7fd0:	00 00                	add    %al,(%eax)
    7fd2:	00 00                	add    %al,(%eax)
    7fd4:	00 00                	add    %al,(%eax)
    7fd6:	00 00                	add    %al,(%eax)
    7fd8:	00 00                	add    %al,(%eax)
    7fda:	00 00                	add    %al,(%eax)
    7fdc:	00 00                	add    %al,(%eax)
    7fde:	00 00                	add    %al,(%eax)
    7fe0:	00 00                	add    %al,(%eax)
    7fe2:	00 00                	add    %al,(%eax)
    7fe4:	00 00                	add    %al,(%eax)
    7fe6:	00 00                	add    %al,(%eax)
    7fe8:	00 00                	add    %al,(%eax)
    7fea:	00 00                	add    %al,(%eax)
    7fec:	00 00                	add    %al,(%eax)
    7fee:	00 00                	add    %al,(%eax)
    7ff0:	00 00                	add    %al,(%eax)
    7ff2:	00 00                	add    %al,(%eax)
    7ff4:	00 00                	add    %al,(%eax)
    7ff6:	00 00                	add    %al,(%eax)
    7ff8:	00 00                	add    %al,(%eax)
    7ffa:	00 00                	add    %al,(%eax)
    7ffc:	00 00                	add    %al,(%eax)
    7ffe:	00 00                	add    %al,(%eax)
    8000:	00 00                	add    %al,(%eax)
    8002:	00 00                	add    %al,(%eax)
    8004:	00 00                	add    %al,(%eax)
    8006:	00 00                	add    %al,(%eax)
    8008:	00 00                	add    %al,(%eax)
    800a:	00 00                	add    %al,(%eax)
    800c:	00 00                	add    %al,(%eax)
    800e:	00 00                	add    %al,(%eax)
    8010:	00 00                	add    %al,(%eax)
    8012:	00 00                	add    %al,(%eax)
    8014:	00 00                	add    %al,(%eax)
    8016:	00 00                	add    %al,(%eax)
    8018:	00 00                	add    %al,(%eax)
    801a:	00 00                	add    %al,(%eax)
    801c:	00 00                	add    %al,(%eax)
    801e:	00 00                	add    %al,(%eax)
    8020:	00 00                	add    %al,(%eax)
    8022:	00 00                	add    %al,(%eax)
    8024:	00 00                	add    %al,(%eax)
    8026:	00 00                	add    %al,(%eax)
    8028:	00 00                	add    %al,(%eax)
    802a:	00 00                	add    %al,(%eax)
    802c:	00 00                	add    %al,(%eax)
    802e:	00 00                	add    %al,(%eax)
    8030:	00 00                	add    %al,(%eax)
    8032:	00 00                	add    %al,(%eax)
    8034:	00 00                	add    %al,(%eax)
    8036:	00 00                	add    %al,(%eax)
    8038:	00 00                	add    %al,(%eax)
    803a:	00 00                	add    %al,(%eax)
    803c:	00 00                	add    %al,(%eax)
    803e:	00 00                	add    %al,(%eax)
    8040:	00 00                	add    %al,(%eax)
    8042:	00 00                	add    %al,(%eax)
    8044:	00 00                	add    %al,(%eax)
    8046:	00 00                	add    %al,(%eax)
    8048:	00 00                	add    %al,(%eax)
    804a:	00 00                	add    %al,(%eax)
    804c:	00 00                	add    %al,(%eax)
    804e:	00 00                	add    %al,(%eax)
    8050:	00 00                	add    %al,(%eax)
    8052:	00 00                	add    %al,(%eax)
    8054:	00 00                	add    %al,(%eax)
    8056:	00 00                	add    %al,(%eax)
    8058:	00 00                	add    %al,(%eax)
    805a:	00 00                	add    %al,(%eax)
    805c:	00 00                	add    %al,(%eax)
    805e:	00 00                	add    %al,(%eax)
    8060:	00 00                	add    %al,(%eax)
    8062:	00 00                	add    %al,(%eax)
    8064:	00 00                	add    %al,(%eax)
    8066:	00 00                	add    %al,(%eax)
    8068:	00 00                	add    %al,(%eax)
    806a:	00 00                	add    %al,(%eax)
    806c:	00 00                	add    %al,(%eax)
    806e:	00 00                	add    %al,(%eax)
    8070:	00 00                	add    %al,(%eax)
    8072:	00 00                	add    %al,(%eax)
    8074:	00 00                	add    %al,(%eax)
    8076:	00 00                	add    %al,(%eax)
    8078:	00 00                	add    %al,(%eax)
    807a:	00 00                	add    %al,(%eax)
    807c:	00 00                	add    %al,(%eax)
    807e:	00 00                	add    %al,(%eax)
    8080:	00 00                	add    %al,(%eax)
    8082:	00 00                	add    %al,(%eax)
    8084:	00 00                	add    %al,(%eax)
    8086:	00 00                	add    %al,(%eax)
    8088:	00 00                	add    %al,(%eax)
    808a:	00 00                	add    %al,(%eax)
    808c:	00 00                	add    %al,(%eax)
    808e:	00 00                	add    %al,(%eax)
    8090:	00 00                	add    %al,(%eax)
    8092:	00 00                	add    %al,(%eax)
    8094:	00 00                	add    %al,(%eax)
    8096:	00 00                	add    %al,(%eax)
    8098:	00 00                	add    %al,(%eax)
    809a:	00 00                	add    %al,(%eax)
    809c:	00 00                	add    %al,(%eax)
    809e:	00 00                	add    %al,(%eax)
    80a0:	00 00                	add    %al,(%eax)
    80a2:	00 00                	add    %al,(%eax)
    80a4:	00 00                	add    %al,(%eax)
    80a6:	00 00                	add    %al,(%eax)
    80a8:	00 00                	add    %al,(%eax)
    80aa:	00 00                	add    %al,(%eax)
    80ac:	00 00                	add    %al,(%eax)
    80ae:	00 00                	add    %al,(%eax)
    80b0:	00 00                	add    %al,(%eax)
    80b2:	00 00                	add    %al,(%eax)
    80b4:	00 00                	add    %al,(%eax)
    80b6:	00 00                	add    %al,(%eax)
    80b8:	00 00                	add    %al,(%eax)
    80ba:	00 00                	add    %al,(%eax)
    80bc:	00 00                	add    %al,(%eax)
    80be:	00 00                	add    %al,(%eax)
    80c0:	00 00                	add    %al,(%eax)
    80c2:	00 00                	add    %al,(%eax)
    80c4:	00 00                	add    %al,(%eax)
    80c6:	00 00                	add    %al,(%eax)
    80c8:	00 00                	add    %al,(%eax)
    80ca:	00 00                	add    %al,(%eax)
    80cc:	00 00                	add    %al,(%eax)
    80ce:	00 00                	add    %al,(%eax)
    80d0:	00 00                	add    %al,(%eax)
    80d2:	00 00                	add    %al,(%eax)
    80d4:	00 00                	add    %al,(%eax)
    80d6:	00 00                	add    %al,(%eax)
    80d8:	00 00                	add    %al,(%eax)
    80da:	00 00                	add    %al,(%eax)
    80dc:	00 00                	add    %al,(%eax)
    80de:	00 00                	add    %al,(%eax)
    80e0:	00 00                	add    %al,(%eax)
    80e2:	00 00                	add    %al,(%eax)
    80e4:	00 00                	add    %al,(%eax)
    80e6:	00 00                	add    %al,(%eax)
    80e8:	00 00                	add    %al,(%eax)
    80ea:	00 00                	add    %al,(%eax)
    80ec:	00 00                	add    %al,(%eax)
    80ee:	00 00                	add    %al,(%eax)
    80f0:	00 00                	add    %al,(%eax)
    80f2:	00 00                	add    %al,(%eax)
    80f4:	00 00                	add    %al,(%eax)
    80f6:	00 00                	add    %al,(%eax)
    80f8:	00 00                	add    %al,(%eax)
    80fa:	00 00                	add    %al,(%eax)
    80fc:	00 00                	add    %al,(%eax)
    80fe:	00 00                	add    %al,(%eax)
    8100:	00 00                	add    %al,(%eax)
    8102:	00 00                	add    %al,(%eax)
    8104:	00 00                	add    %al,(%eax)
    8106:	00 00                	add    %al,(%eax)
    8108:	00 00                	add    %al,(%eax)
    810a:	00 00                	add    %al,(%eax)
    810c:	00 00                	add    %al,(%eax)
    810e:	00 00                	add    %al,(%eax)
    8110:	00 00                	add    %al,(%eax)
    8112:	00 00                	add    %al,(%eax)
    8114:	00 00                	add    %al,(%eax)
    8116:	00 00                	add    %al,(%eax)
    8118:	00 00                	add    %al,(%eax)
    811a:	00 00                	add    %al,(%eax)
    811c:	00 00                	add    %al,(%eax)
    811e:	00 00                	add    %al,(%eax)
    8120:	00 00                	add    %al,(%eax)
    8122:	00 00                	add    %al,(%eax)
    8124:	00 00                	add    %al,(%eax)
    8126:	00 00                	add    %al,(%eax)
    8128:	00 00                	add    %al,(%eax)
    812a:	00 00                	add    %al,(%eax)
    812c:	00 00                	add    %al,(%eax)
    812e:	00 00                	add    %al,(%eax)
    8130:	00 00                	add    %al,(%eax)
    8132:	00 00                	add    %al,(%eax)
    8134:	00 00                	add    %al,(%eax)
    8136:	00 00                	add    %al,(%eax)
    8138:	00 00                	add    %al,(%eax)
    813a:	00 00                	add    %al,(%eax)
    813c:	00 00                	add    %al,(%eax)
    813e:	00 00                	add    %al,(%eax)
    8140:	00 00                	add    %al,(%eax)
    8142:	00 00                	add    %al,(%eax)
    8144:	00 00                	add    %al,(%eax)
    8146:	00 00                	add    %al,(%eax)
    8148:	00 00                	add    %al,(%eax)
    814a:	00 00                	add    %al,(%eax)
    814c:	00 00                	add    %al,(%eax)
    814e:	00 00                	add    %al,(%eax)
    8150:	00 00                	add    %al,(%eax)
    8152:	00 00                	add    %al,(%eax)
    8154:	00 00                	add    %al,(%eax)
    8156:	00 00                	add    %al,(%eax)
    8158:	00 00                	add    %al,(%eax)
    815a:	00 00                	add    %al,(%eax)
    815c:	00 00                	add    %al,(%eax)
    815e:	00 00                	add    %al,(%eax)
    8160:	00 00                	add    %al,(%eax)
    8162:	00 00                	add    %al,(%eax)
    8164:	00 00                	add    %al,(%eax)
    8166:	00 00                	add    %al,(%eax)
    8168:	00 00                	add    %al,(%eax)
    816a:	00 00                	add    %al,(%eax)
    816c:	00 00                	add    %al,(%eax)
    816e:	00 00                	add    %al,(%eax)
    8170:	00 00                	add    %al,(%eax)
    8172:	00 00                	add    %al,(%eax)
    8174:	00 00                	add    %al,(%eax)
    8176:	00 00                	add    %al,(%eax)
    8178:	00 00                	add    %al,(%eax)
    817a:	00 00                	add    %al,(%eax)
    817c:	00 00                	add    %al,(%eax)
    817e:	00 00                	add    %al,(%eax)
    8180:	00 00                	add    %al,(%eax)
    8182:	00 00                	add    %al,(%eax)
    8184:	00 00                	add    %al,(%eax)
    8186:	00 00                	add    %al,(%eax)
    8188:	00 00                	add    %al,(%eax)
    818a:	00 00                	add    %al,(%eax)
    818c:	00 00                	add    %al,(%eax)
    818e:	00 00                	add    %al,(%eax)
    8190:	00 00                	add    %al,(%eax)
    8192:	00 00                	add    %al,(%eax)
    8194:	00 00                	add    %al,(%eax)
    8196:	00 00                	add    %al,(%eax)
    8198:	00 00                	add    %al,(%eax)
    819a:	00 00                	add    %al,(%eax)
    819c:	00 00                	add    %al,(%eax)
    819e:	00 00                	add    %al,(%eax)
    81a0:	00 00                	add    %al,(%eax)
    81a2:	00 00                	add    %al,(%eax)
    81a4:	00 00                	add    %al,(%eax)
    81a6:	00 00                	add    %al,(%eax)
    81a8:	00 00                	add    %al,(%eax)
    81aa:	00 00                	add    %al,(%eax)
    81ac:	00 00                	add    %al,(%eax)
    81ae:	00 00                	add    %al,(%eax)
    81b0:	00 00                	add    %al,(%eax)
    81b2:	00 00                	add    %al,(%eax)
    81b4:	00 00                	add    %al,(%eax)
    81b6:	00 00                	add    %al,(%eax)
    81b8:	00 00                	add    %al,(%eax)
    81ba:	00 00                	add    %al,(%eax)
    81bc:	00 00                	add    %al,(%eax)
    81be:	00 00                	add    %al,(%eax)
    81c0:	00 00                	add    %al,(%eax)
    81c2:	00 00                	add    %al,(%eax)
    81c4:	00 00                	add    %al,(%eax)
    81c6:	00 00                	add    %al,(%eax)
    81c8:	00 00                	add    %al,(%eax)
    81ca:	00 00                	add    %al,(%eax)
    81cc:	00 00                	add    %al,(%eax)
    81ce:	00 00                	add    %al,(%eax)
    81d0:	00 00                	add    %al,(%eax)
    81d2:	00 00                	add    %al,(%eax)
    81d4:	00 00                	add    %al,(%eax)
    81d6:	00 00                	add    %al,(%eax)
    81d8:	00 00                	add    %al,(%eax)
    81da:	00 00                	add    %al,(%eax)
    81dc:	00 00                	add    %al,(%eax)
    81de:	00 00                	add    %al,(%eax)
    81e0:	00 00                	add    %al,(%eax)
    81e2:	00 00                	add    %al,(%eax)
    81e4:	00 00                	add    %al,(%eax)
    81e6:	00 00                	add    %al,(%eax)
    81e8:	00 00                	add    %al,(%eax)
    81ea:	00 00                	add    %al,(%eax)
    81ec:	00 00                	add    %al,(%eax)
    81ee:	00 00                	add    %al,(%eax)
    81f0:	00 00                	add    %al,(%eax)
    81f2:	00 00                	add    %al,(%eax)
    81f4:	00 00                	add    %al,(%eax)
    81f6:	00 00                	add    %al,(%eax)
    81f8:	00 00                	add    %al,(%eax)
    81fa:	00 00                	add    %al,(%eax)
    81fc:	00 00                	add    %al,(%eax)
    81fe:	00 00                	add    %al,(%eax)
    8200:	00 00                	add    %al,(%eax)
    8202:	00 00                	add    %al,(%eax)
    8204:	00 00                	add    %al,(%eax)
    8206:	00 00                	add    %al,(%eax)
    8208:	00 00                	add    %al,(%eax)
    820a:	00 00                	add    %al,(%eax)
    820c:	00 00                	add    %al,(%eax)
    820e:	00 00                	add    %al,(%eax)
    8210:	00 00                	add    %al,(%eax)
    8212:	00 00                	add    %al,(%eax)
    8214:	00 00                	add    %al,(%eax)
    8216:	00 00                	add    %al,(%eax)
    8218:	00 00                	add    %al,(%eax)
    821a:	00 00                	add    %al,(%eax)
    821c:	00 00                	add    %al,(%eax)
    821e:	00 00                	add    %al,(%eax)
    8220:	00 00                	add    %al,(%eax)
    8222:	00 00                	add    %al,(%eax)
    8224:	00 00                	add    %al,(%eax)
    8226:	00 00                	add    %al,(%eax)
    8228:	00 00                	add    %al,(%eax)
    822a:	00 00                	add    %al,(%eax)
    822c:	00 00                	add    %al,(%eax)
    822e:	00 00                	add    %al,(%eax)
    8230:	00 00                	add    %al,(%eax)
    8232:	00 00                	add    %al,(%eax)
    8234:	00 00                	add    %al,(%eax)
    8236:	00 00                	add    %al,(%eax)
    8238:	00 00                	add    %al,(%eax)
    823a:	00 00                	add    %al,(%eax)
    823c:	00 00                	add    %al,(%eax)
    823e:	00 00                	add    %al,(%eax)
    8240:	00 00                	add    %al,(%eax)
    8242:	00 00                	add    %al,(%eax)
    8244:	00 00                	add    %al,(%eax)
    8246:	00 00                	add    %al,(%eax)
    8248:	00 00                	add    %al,(%eax)
    824a:	00 00                	add    %al,(%eax)
    824c:	00 00                	add    %al,(%eax)
    824e:	00 00                	add    %al,(%eax)
    8250:	00 00                	add    %al,(%eax)
    8252:	00 00                	add    %al,(%eax)
    8254:	00 00                	add    %al,(%eax)
    8256:	00 00                	add    %al,(%eax)
    8258:	00 00                	add    %al,(%eax)
    825a:	00 00                	add    %al,(%eax)
    825c:	00 00                	add    %al,(%eax)
    825e:	00 00                	add    %al,(%eax)
    8260:	00 00                	add    %al,(%eax)
    8262:	00 00                	add    %al,(%eax)
    8264:	00 00                	add    %al,(%eax)
    8266:	00 00                	add    %al,(%eax)
    8268:	00 00                	add    %al,(%eax)
    826a:	00 00                	add    %al,(%eax)
    826c:	00 00                	add    %al,(%eax)
    826e:	00 00                	add    %al,(%eax)
    8270:	00 00                	add    %al,(%eax)
    8272:	00 00                	add    %al,(%eax)
    8274:	00 00                	add    %al,(%eax)
    8276:	00 00                	add    %al,(%eax)
    8278:	00 00                	add    %al,(%eax)
    827a:	00 00                	add    %al,(%eax)
    827c:	00 00                	add    %al,(%eax)
    827e:	00 00                	add    %al,(%eax)
    8280:	00 00                	add    %al,(%eax)
    8282:	00 00                	add    %al,(%eax)
    8284:	00 00                	add    %al,(%eax)
    8286:	00 00                	add    %al,(%eax)
    8288:	00 00                	add    %al,(%eax)
    828a:	00 00                	add    %al,(%eax)
    828c:	00 00                	add    %al,(%eax)
    828e:	00 00                	add    %al,(%eax)
    8290:	00 00                	add    %al,(%eax)
    8292:	00 00                	add    %al,(%eax)
    8294:	00 00                	add    %al,(%eax)
    8296:	00 00                	add    %al,(%eax)
    8298:	00 00                	add    %al,(%eax)
    829a:	00 00                	add    %al,(%eax)
    829c:	00 00                	add    %al,(%eax)
    829e:	00 00                	add    %al,(%eax)
    82a0:	00 00                	add    %al,(%eax)
    82a2:	00 00                	add    %al,(%eax)
    82a4:	00 00                	add    %al,(%eax)
    82a6:	00 00                	add    %al,(%eax)
    82a8:	00 00                	add    %al,(%eax)
    82aa:	00 00                	add    %al,(%eax)
    82ac:	00 00                	add    %al,(%eax)
    82ae:	00 00                	add    %al,(%eax)
    82b0:	00 00                	add    %al,(%eax)
    82b2:	00 00                	add    %al,(%eax)
    82b4:	00 00                	add    %al,(%eax)
    82b6:	00 00                	add    %al,(%eax)
    82b8:	00 00                	add    %al,(%eax)
    82ba:	00 00                	add    %al,(%eax)
    82bc:	00 00                	add    %al,(%eax)
    82be:	00 00                	add    %al,(%eax)
    82c0:	00 00                	add    %al,(%eax)
    82c2:	00 00                	add    %al,(%eax)
    82c4:	00 00                	add    %al,(%eax)
    82c6:	00 00                	add    %al,(%eax)
    82c8:	00 00                	add    %al,(%eax)
    82ca:	00 00                	add    %al,(%eax)
    82cc:	00 00                	add    %al,(%eax)
    82ce:	00 00                	add    %al,(%eax)
    82d0:	00 00                	add    %al,(%eax)
    82d2:	00 00                	add    %al,(%eax)
    82d4:	00 00                	add    %al,(%eax)
    82d6:	00 00                	add    %al,(%eax)
    82d8:	00 00                	add    %al,(%eax)
    82da:	00 00                	add    %al,(%eax)
    82dc:	00 00                	add    %al,(%eax)
    82de:	00 00                	add    %al,(%eax)
    82e0:	00 00                	add    %al,(%eax)
    82e2:	00 00                	add    %al,(%eax)
    82e4:	00 00                	add    %al,(%eax)
    82e6:	00 00                	add    %al,(%eax)
    82e8:	00 00                	add    %al,(%eax)
    82ea:	00 00                	add    %al,(%eax)
    82ec:	00 00                	add    %al,(%eax)
    82ee:	00 00                	add    %al,(%eax)
    82f0:	00 00                	add    %al,(%eax)
    82f2:	00 00                	add    %al,(%eax)
    82f4:	00 00                	add    %al,(%eax)
    82f6:	00 00                	add    %al,(%eax)
    82f8:	00 00                	add    %al,(%eax)
    82fa:	00 00                	add    %al,(%eax)
    82fc:	00 00                	add    %al,(%eax)
    82fe:	00 00                	add    %al,(%eax)
    8300:	00 00                	add    %al,(%eax)
    8302:	00 00                	add    %al,(%eax)
    8304:	00 00                	add    %al,(%eax)
    8306:	00 00                	add    %al,(%eax)
    8308:	00 00                	add    %al,(%eax)
    830a:	00 00                	add    %al,(%eax)
    830c:	00 00                	add    %al,(%eax)
    830e:	00 00                	add    %al,(%eax)
    8310:	00 00                	add    %al,(%eax)
    8312:	00 00                	add    %al,(%eax)
    8314:	00 00                	add    %al,(%eax)
    8316:	00 00                	add    %al,(%eax)
    8318:	00 00                	add    %al,(%eax)
    831a:	00 00                	add    %al,(%eax)
    831c:	00 00                	add    %al,(%eax)
    831e:	00 00                	add    %al,(%eax)
    8320:	00 00                	add    %al,(%eax)
    8322:	00 00                	add    %al,(%eax)
    8324:	00 00                	add    %al,(%eax)
    8326:	00 00                	add    %al,(%eax)
    8328:	00 00                	add    %al,(%eax)
    832a:	00 00                	add    %al,(%eax)
    832c:	00 00                	add    %al,(%eax)
    832e:	00 00                	add    %al,(%eax)
    8330:	00 00                	add    %al,(%eax)
    8332:	00 00                	add    %al,(%eax)
    8334:	00 00                	add    %al,(%eax)
    8336:	00 00                	add    %al,(%eax)
    8338:	00 00                	add    %al,(%eax)
    833a:	00 00                	add    %al,(%eax)
    833c:	00 00                	add    %al,(%eax)
    833e:	00 00                	add    %al,(%eax)
    8340:	00 00                	add    %al,(%eax)
    8342:	00 00                	add    %al,(%eax)
    8344:	00 00                	add    %al,(%eax)
    8346:	00 00                	add    %al,(%eax)
    8348:	00 00                	add    %al,(%eax)
    834a:	00 00                	add    %al,(%eax)
    834c:	00 00                	add    %al,(%eax)
    834e:	00 00                	add    %al,(%eax)
    8350:	00 00                	add    %al,(%eax)
    8352:	00 00                	add    %al,(%eax)
    8354:	00 00                	add    %al,(%eax)
    8356:	00 00                	add    %al,(%eax)
    8358:	00 00                	add    %al,(%eax)
    835a:	00 00                	add    %al,(%eax)
    835c:	00 00                	add    %al,(%eax)
    835e:	00 00                	add    %al,(%eax)
    8360:	00 00                	add    %al,(%eax)
    8362:	00 00                	add    %al,(%eax)
    8364:	00 00                	add    %al,(%eax)
    8366:	00 00                	add    %al,(%eax)
    8368:	00 00                	add    %al,(%eax)
    836a:	00 00                	add    %al,(%eax)
    836c:	00 00                	add    %al,(%eax)
    836e:	00 00                	add    %al,(%eax)
    8370:	00 00                	add    %al,(%eax)
    8372:	00 00                	add    %al,(%eax)
    8374:	00 00                	add    %al,(%eax)
    8376:	00 00                	add    %al,(%eax)
    8378:	00 00                	add    %al,(%eax)
    837a:	00 00                	add    %al,(%eax)
    837c:	00 00                	add    %al,(%eax)
    837e:	00 00                	add    %al,(%eax)
    8380:	00 00                	add    %al,(%eax)
    8382:	00 00                	add    %al,(%eax)
    8384:	00 00                	add    %al,(%eax)
    8386:	00 00                	add    %al,(%eax)
    8388:	00 00                	add    %al,(%eax)
    838a:	00 00                	add    %al,(%eax)
    838c:	00 00                	add    %al,(%eax)
    838e:	00 00                	add    %al,(%eax)
    8390:	00 00                	add    %al,(%eax)
    8392:	00 00                	add    %al,(%eax)
    8394:	00 00                	add    %al,(%eax)
    8396:	00 00                	add    %al,(%eax)
    8398:	00 00                	add    %al,(%eax)
    839a:	00 00                	add    %al,(%eax)
    839c:	00 00                	add    %al,(%eax)
    839e:	00 00                	add    %al,(%eax)
    83a0:	00 00                	add    %al,(%eax)
    83a2:	00 00                	add    %al,(%eax)
    83a4:	00 00                	add    %al,(%eax)
    83a6:	00 00                	add    %al,(%eax)
    83a8:	00 00                	add    %al,(%eax)
    83aa:	00 00                	add    %al,(%eax)
    83ac:	00 00                	add    %al,(%eax)
    83ae:	00 00                	add    %al,(%eax)
    83b0:	00 00                	add    %al,(%eax)
    83b2:	00 00                	add    %al,(%eax)
    83b4:	00 00                	add    %al,(%eax)
    83b6:	00 00                	add    %al,(%eax)
    83b8:	00 00                	add    %al,(%eax)
    83ba:	00 00                	add    %al,(%eax)
    83bc:	00 00                	add    %al,(%eax)
    83be:	00 00                	add    %al,(%eax)
    83c0:	00 00                	add    %al,(%eax)
    83c2:	00 00                	add    %al,(%eax)
    83c4:	00 00                	add    %al,(%eax)
    83c6:	00 00                	add    %al,(%eax)
    83c8:	00 00                	add    %al,(%eax)
    83ca:	00 00                	add    %al,(%eax)
    83cc:	00 00                	add    %al,(%eax)
    83ce:	00 00                	add    %al,(%eax)
    83d0:	00 00                	add    %al,(%eax)
    83d2:	00 00                	add    %al,(%eax)
    83d4:	00 00                	add    %al,(%eax)
    83d6:	00 00                	add    %al,(%eax)
    83d8:	00 00                	add    %al,(%eax)
    83da:	00 00                	add    %al,(%eax)
    83dc:	00 00                	add    %al,(%eax)
    83de:	00 00                	add    %al,(%eax)
    83e0:	00 00                	add    %al,(%eax)
    83e2:	00 00                	add    %al,(%eax)
    83e4:	00 00                	add    %al,(%eax)
    83e6:	00 00                	add    %al,(%eax)
    83e8:	00 00                	add    %al,(%eax)
    83ea:	00 00                	add    %al,(%eax)
    83ec:	00 00                	add    %al,(%eax)
    83ee:	00 00                	add    %al,(%eax)
    83f0:	00 00                	add    %al,(%eax)
    83f2:	00 00                	add    %al,(%eax)
    83f4:	00 00                	add    %al,(%eax)
    83f6:	00 00                	add    %al,(%eax)
    83f8:	00 00                	add    %al,(%eax)
    83fa:	00 00                	add    %al,(%eax)
    83fc:	00 00                	add    %al,(%eax)
    83fe:	00 00                	add    %al,(%eax)
    8400:	00 00                	add    %al,(%eax)
    8402:	00 00                	add    %al,(%eax)
    8404:	00 00                	add    %al,(%eax)
    8406:	00 00                	add    %al,(%eax)
    8408:	00 00                	add    %al,(%eax)
    840a:	00 00                	add    %al,(%eax)
    840c:	00 00                	add    %al,(%eax)
    840e:	00 00                	add    %al,(%eax)
    8410:	00 00                	add    %al,(%eax)
    8412:	00 00                	add    %al,(%eax)
    8414:	00 00                	add    %al,(%eax)
    8416:	00 00                	add    %al,(%eax)
    8418:	00 00                	add    %al,(%eax)
    841a:	00 00                	add    %al,(%eax)
    841c:	00 00                	add    %al,(%eax)
    841e:	00 00                	add    %al,(%eax)
    8420:	00 00                	add    %al,(%eax)
    8422:	00 00                	add    %al,(%eax)
    8424:	00 00                	add    %al,(%eax)
    8426:	00 00                	add    %al,(%eax)
    8428:	00 00                	add    %al,(%eax)
    842a:	00 00                	add    %al,(%eax)
    842c:	00 00                	add    %al,(%eax)
    842e:	00 00                	add    %al,(%eax)
    8430:	00 00                	add    %al,(%eax)
    8432:	00 00                	add    %al,(%eax)
    8434:	00 00                	add    %al,(%eax)
    8436:	00 00                	add    %al,(%eax)
    8438:	00 00                	add    %al,(%eax)
    843a:	00 00                	add    %al,(%eax)
    843c:	00 00                	add    %al,(%eax)
    843e:	00 00                	add    %al,(%eax)
    8440:	00 00                	add    %al,(%eax)
    8442:	00 00                	add    %al,(%eax)
    8444:	00 00                	add    %al,(%eax)
    8446:	00 00                	add    %al,(%eax)
    8448:	00 00                	add    %al,(%eax)
    844a:	00 00                	add    %al,(%eax)
    844c:	00 00                	add    %al,(%eax)
    844e:	00 00                	add    %al,(%eax)
    8450:	00 00                	add    %al,(%eax)
    8452:	00 00                	add    %al,(%eax)
    8454:	00 00                	add    %al,(%eax)
    8456:	00 00                	add    %al,(%eax)
    8458:	00 00                	add    %al,(%eax)
    845a:	00 00                	add    %al,(%eax)
    845c:	00 00                	add    %al,(%eax)
    845e:	00 00                	add    %al,(%eax)
    8460:	00 00                	add    %al,(%eax)
    8462:	00 00                	add    %al,(%eax)
    8464:	00 00                	add    %al,(%eax)
    8466:	00 00                	add    %al,(%eax)
    8468:	00 00                	add    %al,(%eax)
    846a:	00 00                	add    %al,(%eax)
    846c:	00 00                	add    %al,(%eax)
    846e:	00 00                	add    %al,(%eax)
    8470:	00 00                	add    %al,(%eax)
    8472:	00 00                	add    %al,(%eax)
    8474:	00 00                	add    %al,(%eax)
    8476:	00 00                	add    %al,(%eax)
    8478:	00 00                	add    %al,(%eax)
    847a:	00 00                	add    %al,(%eax)
    847c:	00 00                	add    %al,(%eax)
    847e:	00 00                	add    %al,(%eax)
    8480:	00 00                	add    %al,(%eax)
    8482:	00 00                	add    %al,(%eax)
    8484:	00 00                	add    %al,(%eax)
    8486:	00 00                	add    %al,(%eax)
    8488:	00 00                	add    %al,(%eax)
    848a:	00 00                	add    %al,(%eax)
    848c:	00 00                	add    %al,(%eax)
    848e:	00 00                	add    %al,(%eax)
    8490:	00 00                	add    %al,(%eax)
    8492:	00 00                	add    %al,(%eax)
    8494:	00 00                	add    %al,(%eax)
    8496:	00 00                	add    %al,(%eax)
    8498:	00 00                	add    %al,(%eax)
    849a:	00 00                	add    %al,(%eax)
    849c:	00 00                	add    %al,(%eax)
    849e:	00 00                	add    %al,(%eax)
    84a0:	00 00                	add    %al,(%eax)
    84a2:	00 00                	add    %al,(%eax)
    84a4:	00 00                	add    %al,(%eax)
    84a6:	00 00                	add    %al,(%eax)
    84a8:	00 00                	add    %al,(%eax)
    84aa:	00 00                	add    %al,(%eax)
    84ac:	00 00                	add    %al,(%eax)
    84ae:	00 00                	add    %al,(%eax)
    84b0:	00 00                	add    %al,(%eax)
    84b2:	00 00                	add    %al,(%eax)
    84b4:	00 00                	add    %al,(%eax)
    84b6:	00 00                	add    %al,(%eax)
    84b8:	00 00                	add    %al,(%eax)
    84ba:	00 00                	add    %al,(%eax)
    84bc:	00 00                	add    %al,(%eax)
    84be:	00 00                	add    %al,(%eax)
    84c0:	00 00                	add    %al,(%eax)
    84c2:	00 00                	add    %al,(%eax)
    84c4:	00 00                	add    %al,(%eax)
    84c6:	00 00                	add    %al,(%eax)
    84c8:	00 00                	add    %al,(%eax)
    84ca:	00 00                	add    %al,(%eax)
    84cc:	00 00                	add    %al,(%eax)
    84ce:	00 00                	add    %al,(%eax)
    84d0:	00 00                	add    %al,(%eax)
    84d2:	00 00                	add    %al,(%eax)
    84d4:	00 00                	add    %al,(%eax)
    84d6:	00 00                	add    %al,(%eax)
    84d8:	00 00                	add    %al,(%eax)
    84da:	00 00                	add    %al,(%eax)
    84dc:	00 00                	add    %al,(%eax)
    84de:	00 00                	add    %al,(%eax)
    84e0:	00 00                	add    %al,(%eax)
    84e2:	00 00                	add    %al,(%eax)
    84e4:	00 00                	add    %al,(%eax)
    84e6:	00 00                	add    %al,(%eax)
    84e8:	00 00                	add    %al,(%eax)
    84ea:	00 00                	add    %al,(%eax)
    84ec:	00 00                	add    %al,(%eax)
    84ee:	00 00                	add    %al,(%eax)
    84f0:	00 00                	add    %al,(%eax)
    84f2:	00 00                	add    %al,(%eax)
    84f4:	00 00                	add    %al,(%eax)
    84f6:	00 00                	add    %al,(%eax)
    84f8:	00 00                	add    %al,(%eax)
    84fa:	00 00                	add    %al,(%eax)
    84fc:	00 00                	add    %al,(%eax)
    84fe:	00 00                	add    %al,(%eax)
    8500:	00 00                	add    %al,(%eax)
    8502:	00 00                	add    %al,(%eax)
    8504:	00 00                	add    %al,(%eax)
    8506:	00 00                	add    %al,(%eax)
    8508:	00 00                	add    %al,(%eax)
    850a:	00 00                	add    %al,(%eax)
    850c:	00 00                	add    %al,(%eax)
    850e:	00 00                	add    %al,(%eax)
    8510:	00 00                	add    %al,(%eax)
    8512:	00 00                	add    %al,(%eax)
    8514:	00 00                	add    %al,(%eax)
    8516:	00 00                	add    %al,(%eax)
    8518:	00 00                	add    %al,(%eax)
    851a:	00 00                	add    %al,(%eax)
    851c:	00 00                	add    %al,(%eax)
    851e:	00 00                	add    %al,(%eax)
    8520:	00 00                	add    %al,(%eax)
    8522:	00 00                	add    %al,(%eax)
    8524:	00 00                	add    %al,(%eax)
    8526:	00 00                	add    %al,(%eax)
    8528:	00 00                	add    %al,(%eax)
    852a:	00 00                	add    %al,(%eax)
    852c:	00 00                	add    %al,(%eax)
    852e:	00 00                	add    %al,(%eax)
    8530:	00 00                	add    %al,(%eax)
    8532:	00 00                	add    %al,(%eax)
    8534:	00 00                	add    %al,(%eax)
    8536:	00 00                	add    %al,(%eax)
    8538:	00 00                	add    %al,(%eax)
    853a:	00 00                	add    %al,(%eax)
    853c:	00 00                	add    %al,(%eax)
    853e:	00 00                	add    %al,(%eax)
    8540:	00 00                	add    %al,(%eax)
    8542:	00 00                	add    %al,(%eax)
    8544:	00 00                	add    %al,(%eax)
    8546:	00 00                	add    %al,(%eax)
    8548:	00 00                	add    %al,(%eax)
    854a:	00 00                	add    %al,(%eax)
    854c:	00 00                	add    %al,(%eax)
    854e:	00 00                	add    %al,(%eax)
    8550:	00 00                	add    %al,(%eax)
    8552:	00 00                	add    %al,(%eax)
    8554:	00 00                	add    %al,(%eax)
    8556:	00 00                	add    %al,(%eax)
    8558:	00 00                	add    %al,(%eax)
    855a:	00 00                	add    %al,(%eax)
    855c:	00 00                	add    %al,(%eax)
    855e:	00 00                	add    %al,(%eax)
    8560:	00 00                	add    %al,(%eax)
    8562:	00 00                	add    %al,(%eax)
    8564:	00 00                	add    %al,(%eax)
    8566:	00 00                	add    %al,(%eax)
    8568:	00 00                	add    %al,(%eax)
    856a:	00 00                	add    %al,(%eax)
    856c:	00 00                	add    %al,(%eax)
    856e:	00 00                	add    %al,(%eax)
    8570:	00 00                	add    %al,(%eax)
    8572:	00 00                	add    %al,(%eax)
    8574:	00 00                	add    %al,(%eax)
    8576:	00 00                	add    %al,(%eax)
    8578:	00 00                	add    %al,(%eax)
    857a:	00 00                	add    %al,(%eax)
    857c:	00 00                	add    %al,(%eax)
    857e:	00 00                	add    %al,(%eax)
    8580:	00 00                	add    %al,(%eax)
    8582:	00 00                	add    %al,(%eax)
    8584:	00 00                	add    %al,(%eax)
    8586:	00 00                	add    %al,(%eax)
    8588:	00 00                	add    %al,(%eax)
    858a:	00 00                	add    %al,(%eax)
    858c:	00 00                	add    %al,(%eax)
    858e:	00 00                	add    %al,(%eax)
    8590:	00 00                	add    %al,(%eax)
    8592:	00 00                	add    %al,(%eax)
    8594:	00 00                	add    %al,(%eax)
    8596:	00 00                	add    %al,(%eax)
    8598:	00 00                	add    %al,(%eax)
    859a:	00 00                	add    %al,(%eax)
    859c:	00 00                	add    %al,(%eax)
    859e:	00 00                	add    %al,(%eax)
    85a0:	00 00                	add    %al,(%eax)
    85a2:	00 00                	add    %al,(%eax)
    85a4:	00 00                	add    %al,(%eax)
    85a6:	00 00                	add    %al,(%eax)
    85a8:	00 00                	add    %al,(%eax)
    85aa:	00 00                	add    %al,(%eax)
    85ac:	00 00                	add    %al,(%eax)
    85ae:	00 00                	add    %al,(%eax)
    85b0:	00 00                	add    %al,(%eax)
    85b2:	00 00                	add    %al,(%eax)
    85b4:	00 00                	add    %al,(%eax)
    85b6:	00 00                	add    %al,(%eax)
    85b8:	00 00                	add    %al,(%eax)
    85ba:	00 00                	add    %al,(%eax)
    85bc:	00 00                	add    %al,(%eax)
    85be:	00 00                	add    %al,(%eax)
    85c0:	00 00                	add    %al,(%eax)
    85c2:	00 00                	add    %al,(%eax)
    85c4:	00 00                	add    %al,(%eax)
    85c6:	00 00                	add    %al,(%eax)
    85c8:	00 00                	add    %al,(%eax)
    85ca:	00 00                	add    %al,(%eax)
    85cc:	00 00                	add    %al,(%eax)
    85ce:	00 00                	add    %al,(%eax)
    85d0:	00 00                	add    %al,(%eax)
    85d2:	00 00                	add    %al,(%eax)
    85d4:	00 00                	add    %al,(%eax)
    85d6:	00 00                	add    %al,(%eax)
    85d8:	00 00                	add    %al,(%eax)
    85da:	00 00                	add    %al,(%eax)
    85dc:	00 00                	add    %al,(%eax)
    85de:	00 00                	add    %al,(%eax)
    85e0:	00 00                	add    %al,(%eax)
    85e2:	00 00                	add    %al,(%eax)
    85e4:	00 00                	add    %al,(%eax)
    85e6:	00 00                	add    %al,(%eax)
    85e8:	00 00                	add    %al,(%eax)
    85ea:	00 00                	add    %al,(%eax)
    85ec:	00 00                	add    %al,(%eax)
    85ee:	00 00                	add    %al,(%eax)
    85f0:	00 00                	add    %al,(%eax)
    85f2:	00 00                	add    %al,(%eax)
    85f4:	00 00                	add    %al,(%eax)
    85f6:	00 00                	add    %al,(%eax)
    85f8:	00 00                	add    %al,(%eax)
    85fa:	00 00                	add    %al,(%eax)
    85fc:	00 00                	add    %al,(%eax)
    85fe:	00 00                	add    %al,(%eax)
    8600:	00 00                	add    %al,(%eax)
    8602:	00 00                	add    %al,(%eax)
    8604:	00 00                	add    %al,(%eax)
    8606:	00 00                	add    %al,(%eax)
    8608:	00 00                	add    %al,(%eax)
    860a:	00 00                	add    %al,(%eax)
    860c:	00 00                	add    %al,(%eax)
    860e:	00 00                	add    %al,(%eax)
    8610:	00 00                	add    %al,(%eax)
    8612:	00 00                	add    %al,(%eax)
    8614:	00 00                	add    %al,(%eax)
    8616:	00 00                	add    %al,(%eax)
    8618:	00 00                	add    %al,(%eax)
    861a:	00 00                	add    %al,(%eax)
    861c:	00 00                	add    %al,(%eax)
    861e:	00 00                	add    %al,(%eax)
    8620:	00 00                	add    %al,(%eax)
    8622:	00 00                	add    %al,(%eax)
    8624:	00 00                	add    %al,(%eax)
    8626:	00 00                	add    %al,(%eax)
    8628:	00 00                	add    %al,(%eax)
    862a:	00 00                	add    %al,(%eax)
    862c:	00 00                	add    %al,(%eax)
    862e:	00 00                	add    %al,(%eax)
    8630:	00 00                	add    %al,(%eax)
    8632:	00 00                	add    %al,(%eax)
    8634:	00 00                	add    %al,(%eax)
    8636:	00 00                	add    %al,(%eax)
    8638:	00 00                	add    %al,(%eax)
    863a:	00 00                	add    %al,(%eax)
    863c:	00 00                	add    %al,(%eax)
    863e:	00 00                	add    %al,(%eax)
    8640:	00 00                	add    %al,(%eax)
    8642:	00 00                	add    %al,(%eax)
    8644:	00 00                	add    %al,(%eax)
    8646:	00 00                	add    %al,(%eax)
    8648:	00 00                	add    %al,(%eax)
    864a:	00 00                	add    %al,(%eax)
    864c:	00 00                	add    %al,(%eax)
    864e:	00 00                	add    %al,(%eax)
    8650:	00 00                	add    %al,(%eax)
    8652:	00 00                	add    %al,(%eax)
    8654:	00 00                	add    %al,(%eax)
    8656:	00 00                	add    %al,(%eax)
    8658:	00 00                	add    %al,(%eax)
    865a:	00 00                	add    %al,(%eax)
    865c:	00 00                	add    %al,(%eax)
    865e:	00 00                	add    %al,(%eax)
    8660:	00 00                	add    %al,(%eax)
    8662:	00 00                	add    %al,(%eax)
    8664:	00 00                	add    %al,(%eax)
    8666:	00 00                	add    %al,(%eax)
    8668:	00 00                	add    %al,(%eax)
    866a:	00 00                	add    %al,(%eax)
    866c:	00 00                	add    %al,(%eax)
    866e:	00 00                	add    %al,(%eax)
    8670:	00 00                	add    %al,(%eax)
    8672:	00 00                	add    %al,(%eax)
    8674:	00 00                	add    %al,(%eax)
    8676:	00 00                	add    %al,(%eax)
    8678:	00 00                	add    %al,(%eax)
    867a:	00 00                	add    %al,(%eax)
    867c:	00 00                	add    %al,(%eax)
    867e:	00 00                	add    %al,(%eax)
    8680:	00 00                	add    %al,(%eax)
    8682:	00 00                	add    %al,(%eax)
    8684:	00 00                	add    %al,(%eax)
    8686:	00 00                	add    %al,(%eax)
    8688:	00 00                	add    %al,(%eax)
    868a:	00 00                	add    %al,(%eax)
    868c:	00 00                	add    %al,(%eax)
    868e:	00 00                	add    %al,(%eax)
    8690:	00 00                	add    %al,(%eax)
    8692:	00 00                	add    %al,(%eax)
    8694:	00 00                	add    %al,(%eax)
    8696:	00 00                	add    %al,(%eax)
    8698:	00 00                	add    %al,(%eax)
    869a:	00 00                	add    %al,(%eax)
    869c:	00 00                	add    %al,(%eax)
    869e:	00 00                	add    %al,(%eax)
    86a0:	00 00                	add    %al,(%eax)
    86a2:	00 00                	add    %al,(%eax)
    86a4:	00 00                	add    %al,(%eax)
    86a6:	00 00                	add    %al,(%eax)
    86a8:	00 00                	add    %al,(%eax)
    86aa:	00 00                	add    %al,(%eax)
    86ac:	00 00                	add    %al,(%eax)
    86ae:	00 00                	add    %al,(%eax)
    86b0:	00 00                	add    %al,(%eax)
    86b2:	00 00                	add    %al,(%eax)
    86b4:	00 00                	add    %al,(%eax)
    86b6:	00 00                	add    %al,(%eax)
    86b8:	00 00                	add    %al,(%eax)
    86ba:	00 00                	add    %al,(%eax)
    86bc:	00 00                	add    %al,(%eax)
    86be:	00 00                	add    %al,(%eax)
    86c0:	00 00                	add    %al,(%eax)
    86c2:	00 00                	add    %al,(%eax)
    86c4:	00 00                	add    %al,(%eax)
    86c6:	00 00                	add    %al,(%eax)
    86c8:	00 00                	add    %al,(%eax)
    86ca:	00 00                	add    %al,(%eax)
    86cc:	00 00                	add    %al,(%eax)
    86ce:	00 00                	add    %al,(%eax)
    86d0:	00 00                	add    %al,(%eax)
    86d2:	00 00                	add    %al,(%eax)
    86d4:	00 00                	add    %al,(%eax)
    86d6:	00 00                	add    %al,(%eax)
    86d8:	00 00                	add    %al,(%eax)
    86da:	00 00                	add    %al,(%eax)
    86dc:	00 00                	add    %al,(%eax)
    86de:	00 00                	add    %al,(%eax)
    86e0:	00 00                	add    %al,(%eax)
    86e2:	00 00                	add    %al,(%eax)
    86e4:	00 00                	add    %al,(%eax)
    86e6:	00 00                	add    %al,(%eax)
    86e8:	00 00                	add    %al,(%eax)
    86ea:	00 00                	add    %al,(%eax)
    86ec:	00 00                	add    %al,(%eax)
    86ee:	00 00                	add    %al,(%eax)
    86f0:	00 00                	add    %al,(%eax)
    86f2:	00 00                	add    %al,(%eax)
    86f4:	00 00                	add    %al,(%eax)
    86f6:	00 00                	add    %al,(%eax)
    86f8:	00 00                	add    %al,(%eax)
    86fa:	00 00                	add    %al,(%eax)
    86fc:	00 00                	add    %al,(%eax)
    86fe:	00 00                	add    %al,(%eax)
    8700:	00 00                	add    %al,(%eax)
    8702:	00 00                	add    %al,(%eax)
    8704:	00 00                	add    %al,(%eax)
    8706:	00 00                	add    %al,(%eax)
    8708:	00 00                	add    %al,(%eax)
    870a:	00 00                	add    %al,(%eax)
    870c:	00 00                	add    %al,(%eax)
    870e:	00 00                	add    %al,(%eax)
    8710:	00 00                	add    %al,(%eax)
    8712:	00 00                	add    %al,(%eax)
    8714:	00 00                	add    %al,(%eax)
    8716:	00 00                	add    %al,(%eax)
    8718:	00 00                	add    %al,(%eax)
    871a:	00 00                	add    %al,(%eax)
    871c:	00 00                	add    %al,(%eax)
    871e:	00 00                	add    %al,(%eax)
    8720:	00 00                	add    %al,(%eax)
    8722:	00 00                	add    %al,(%eax)
    8724:	00 00                	add    %al,(%eax)
    8726:	00 00                	add    %al,(%eax)
    8728:	00 00                	add    %al,(%eax)
    872a:	00 00                	add    %al,(%eax)
    872c:	00 00                	add    %al,(%eax)
    872e:	00 00                	add    %al,(%eax)
    8730:	00 00                	add    %al,(%eax)
    8732:	00 00                	add    %al,(%eax)
    8734:	00 00                	add    %al,(%eax)
    8736:	00 00                	add    %al,(%eax)
    8738:	00 00                	add    %al,(%eax)
    873a:	00 00                	add    %al,(%eax)
    873c:	00 00                	add    %al,(%eax)
    873e:	00 00                	add    %al,(%eax)
    8740:	00 00                	add    %al,(%eax)
    8742:	00 00                	add    %al,(%eax)
    8744:	00 00                	add    %al,(%eax)
    8746:	00 00                	add    %al,(%eax)
    8748:	00 00                	add    %al,(%eax)
    874a:	00 00                	add    %al,(%eax)
    874c:	00 00                	add    %al,(%eax)
    874e:	00 00                	add    %al,(%eax)
    8750:	00 00                	add    %al,(%eax)
    8752:	00 00                	add    %al,(%eax)
    8754:	00 00                	add    %al,(%eax)
    8756:	00 00                	add    %al,(%eax)
    8758:	00 00                	add    %al,(%eax)
    875a:	00 00                	add    %al,(%eax)
    875c:	00 00                	add    %al,(%eax)
    875e:	00 00                	add    %al,(%eax)
    8760:	00 00                	add    %al,(%eax)
    8762:	00 00                	add    %al,(%eax)
    8764:	00 00                	add    %al,(%eax)
    8766:	00 00                	add    %al,(%eax)
    8768:	00 00                	add    %al,(%eax)
    876a:	00 00                	add    %al,(%eax)
    876c:	00 00                	add    %al,(%eax)
    876e:	00 00                	add    %al,(%eax)
    8770:	00 00                	add    %al,(%eax)
    8772:	00 00                	add    %al,(%eax)
    8774:	00 00                	add    %al,(%eax)
    8776:	00 00                	add    %al,(%eax)
    8778:	00 00                	add    %al,(%eax)
    877a:	00 00                	add    %al,(%eax)
    877c:	00 00                	add    %al,(%eax)
    877e:	00 00                	add    %al,(%eax)
    8780:	00 00                	add    %al,(%eax)
    8782:	00 00                	add    %al,(%eax)
    8784:	00 00                	add    %al,(%eax)
    8786:	00 00                	add    %al,(%eax)
    8788:	00 00                	add    %al,(%eax)
    878a:	00 00                	add    %al,(%eax)
    878c:	00 00                	add    %al,(%eax)
    878e:	00 00                	add    %al,(%eax)
    8790:	00 00                	add    %al,(%eax)
    8792:	00 00                	add    %al,(%eax)
    8794:	00 00                	add    %al,(%eax)
    8796:	00 00                	add    %al,(%eax)
    8798:	00 00                	add    %al,(%eax)
    879a:	00 00                	add    %al,(%eax)
    879c:	00 00                	add    %al,(%eax)
    879e:	00 00                	add    %al,(%eax)
    87a0:	00 00                	add    %al,(%eax)
    87a2:	00 00                	add    %al,(%eax)
    87a4:	00 00                	add    %al,(%eax)
    87a6:	00 00                	add    %al,(%eax)
    87a8:	00 00                	add    %al,(%eax)
    87aa:	00 00                	add    %al,(%eax)
    87ac:	00 00                	add    %al,(%eax)
    87ae:	00 00                	add    %al,(%eax)
    87b0:	00 00                	add    %al,(%eax)
    87b2:	00 00                	add    %al,(%eax)
    87b4:	00 00                	add    %al,(%eax)
    87b6:	00 00                	add    %al,(%eax)
    87b8:	00 00                	add    %al,(%eax)
    87ba:	00 00                	add    %al,(%eax)
    87bc:	00 00                	add    %al,(%eax)
    87be:	00 00                	add    %al,(%eax)
    87c0:	00 00                	add    %al,(%eax)
    87c2:	00 00                	add    %al,(%eax)
    87c4:	00 00                	add    %al,(%eax)
    87c6:	00 00                	add    %al,(%eax)
    87c8:	00 00                	add    %al,(%eax)
    87ca:	00 00                	add    %al,(%eax)
    87cc:	00 00                	add    %al,(%eax)
    87ce:	00 00                	add    %al,(%eax)
    87d0:	00 00                	add    %al,(%eax)
    87d2:	00 00                	add    %al,(%eax)
    87d4:	00 00                	add    %al,(%eax)
    87d6:	00 00                	add    %al,(%eax)
    87d8:	00 00                	add    %al,(%eax)
    87da:	00 00                	add    %al,(%eax)
    87dc:	00 00                	add    %al,(%eax)
    87de:	00 00                	add    %al,(%eax)
    87e0:	00 00                	add    %al,(%eax)
    87e2:	00 00                	add    %al,(%eax)
    87e4:	00 00                	add    %al,(%eax)
    87e6:	00 00                	add    %al,(%eax)
    87e8:	00 00                	add    %al,(%eax)
    87ea:	00 00                	add    %al,(%eax)
    87ec:	00 00                	add    %al,(%eax)
    87ee:	00 00                	add    %al,(%eax)
    87f0:	00 00                	add    %al,(%eax)
    87f2:	00 00                	add    %al,(%eax)
    87f4:	00 00                	add    %al,(%eax)
    87f6:	00 00                	add    %al,(%eax)
    87f8:	00 00                	add    %al,(%eax)
    87fa:	00 00                	add    %al,(%eax)
    87fc:	00 00                	add    %al,(%eax)
    87fe:	00 00                	add    %al,(%eax)
    8800:	00 00                	add    %al,(%eax)
    8802:	00 00                	add    %al,(%eax)
    8804:	00 00                	add    %al,(%eax)
    8806:	00 00                	add    %al,(%eax)
    8808:	00 00                	add    %al,(%eax)
    880a:	00 00                	add    %al,(%eax)
    880c:	00 00                	add    %al,(%eax)
    880e:	00 00                	add    %al,(%eax)
    8810:	00 00                	add    %al,(%eax)
    8812:	00 00                	add    %al,(%eax)
    8814:	00 00                	add    %al,(%eax)
    8816:	00 00                	add    %al,(%eax)
    8818:	00 00                	add    %al,(%eax)
    881a:	00 00                	add    %al,(%eax)
    881c:	00 00                	add    %al,(%eax)
    881e:	00 00                	add    %al,(%eax)
    8820:	00 00                	add    %al,(%eax)
    8822:	00 00                	add    %al,(%eax)
    8824:	00 00                	add    %al,(%eax)
    8826:	00 00                	add    %al,(%eax)
    8828:	00 00                	add    %al,(%eax)
    882a:	00 00                	add    %al,(%eax)
    882c:	00 00                	add    %al,(%eax)
    882e:	00 00                	add    %al,(%eax)
    8830:	00 00                	add    %al,(%eax)
    8832:	00 00                	add    %al,(%eax)
    8834:	00 00                	add    %al,(%eax)
    8836:	00 00                	add    %al,(%eax)
    8838:	00 00                	add    %al,(%eax)
    883a:	00 00                	add    %al,(%eax)
    883c:	00 00                	add    %al,(%eax)
    883e:	00 00                	add    %al,(%eax)
    8840:	00 00                	add    %al,(%eax)
    8842:	00 00                	add    %al,(%eax)
    8844:	00 00                	add    %al,(%eax)
    8846:	00 00                	add    %al,(%eax)
    8848:	00 00                	add    %al,(%eax)
    884a:	00 00                	add    %al,(%eax)
    884c:	00 00                	add    %al,(%eax)
    884e:	00 00                	add    %al,(%eax)
    8850:	00 00                	add    %al,(%eax)
    8852:	00 00                	add    %al,(%eax)
    8854:	00 00                	add    %al,(%eax)
    8856:	00 00                	add    %al,(%eax)
    8858:	00 00                	add    %al,(%eax)
    885a:	00 00                	add    %al,(%eax)
    885c:	00 00                	add    %al,(%eax)
    885e:	00 00                	add    %al,(%eax)
    8860:	00 00                	add    %al,(%eax)
    8862:	00 00                	add    %al,(%eax)
    8864:	00 00                	add    %al,(%eax)
    8866:	00 00                	add    %al,(%eax)
    8868:	00 00                	add    %al,(%eax)
    886a:	00 00                	add    %al,(%eax)
    886c:	00 00                	add    %al,(%eax)
    886e:	00 00                	add    %al,(%eax)
    8870:	00 00                	add    %al,(%eax)
    8872:	00 00                	add    %al,(%eax)
    8874:	00 00                	add    %al,(%eax)
    8876:	00 00                	add    %al,(%eax)
    8878:	00 00                	add    %al,(%eax)
    887a:	00 00                	add    %al,(%eax)
    887c:	00 00                	add    %al,(%eax)
    887e:	00 00                	add    %al,(%eax)
    8880:	00 00                	add    %al,(%eax)
    8882:	00 00                	add    %al,(%eax)
    8884:	00 00                	add    %al,(%eax)
    8886:	00 00                	add    %al,(%eax)
    8888:	00 00                	add    %al,(%eax)
    888a:	00 00                	add    %al,(%eax)
    888c:	00 00                	add    %al,(%eax)
    888e:	00 00                	add    %al,(%eax)
    8890:	00 00                	add    %al,(%eax)
    8892:	00 00                	add    %al,(%eax)
    8894:	00 00                	add    %al,(%eax)
    8896:	00 00                	add    %al,(%eax)
    8898:	00 00                	add    %al,(%eax)
    889a:	00 00                	add    %al,(%eax)
    889c:	00 00                	add    %al,(%eax)
    889e:	00 00                	add    %al,(%eax)
    88a0:	00 00                	add    %al,(%eax)
    88a2:	00 00                	add    %al,(%eax)
    88a4:	00 00                	add    %al,(%eax)
    88a6:	00 00                	add    %al,(%eax)
    88a8:	00 00                	add    %al,(%eax)
    88aa:	00 00                	add    %al,(%eax)
    88ac:	00 00                	add    %al,(%eax)
    88ae:	00 00                	add    %al,(%eax)
    88b0:	00 00                	add    %al,(%eax)
    88b2:	00 00                	add    %al,(%eax)
    88b4:	00 00                	add    %al,(%eax)
    88b6:	00 00                	add    %al,(%eax)
    88b8:	00 00                	add    %al,(%eax)
    88ba:	00 00                	add    %al,(%eax)
    88bc:	00 00                	add    %al,(%eax)
    88be:	00 00                	add    %al,(%eax)
    88c0:	00 00                	add    %al,(%eax)
    88c2:	00 00                	add    %al,(%eax)
    88c4:	00 00                	add    %al,(%eax)
    88c6:	00 00                	add    %al,(%eax)
    88c8:	00 00                	add    %al,(%eax)
    88ca:	00 00                	add    %al,(%eax)
    88cc:	00 00                	add    %al,(%eax)
    88ce:	00 00                	add    %al,(%eax)
    88d0:	00 00                	add    %al,(%eax)
    88d2:	00 00                	add    %al,(%eax)
    88d4:	00 00                	add    %al,(%eax)
    88d6:	00 00                	add    %al,(%eax)
    88d8:	00 00                	add    %al,(%eax)
    88da:	00 00                	add    %al,(%eax)
    88dc:	00 00                	add    %al,(%eax)
    88de:	00 00                	add    %al,(%eax)
    88e0:	00 00                	add    %al,(%eax)
    88e2:	00 00                	add    %al,(%eax)
    88e4:	00 00                	add    %al,(%eax)
    88e6:	00 00                	add    %al,(%eax)
    88e8:	00 00                	add    %al,(%eax)
    88ea:	00 00                	add    %al,(%eax)
    88ec:	00 00                	add    %al,(%eax)
    88ee:	00 00                	add    %al,(%eax)
    88f0:	00 00                	add    %al,(%eax)
    88f2:	00 00                	add    %al,(%eax)
    88f4:	00 00                	add    %al,(%eax)
    88f6:	00 00                	add    %al,(%eax)
    88f8:	00 00                	add    %al,(%eax)
    88fa:	00 00                	add    %al,(%eax)
    88fc:	00 00                	add    %al,(%eax)
    88fe:	00 00                	add    %al,(%eax)
    8900:	00 00                	add    %al,(%eax)
    8902:	00 00                	add    %al,(%eax)
    8904:	00 00                	add    %al,(%eax)
    8906:	00 00                	add    %al,(%eax)
    8908:	00 00                	add    %al,(%eax)
    890a:	00 00                	add    %al,(%eax)
    890c:	00 00                	add    %al,(%eax)
    890e:	00 00                	add    %al,(%eax)
    8910:	00 00                	add    %al,(%eax)
    8912:	00 00                	add    %al,(%eax)
    8914:	00 00                	add    %al,(%eax)
    8916:	00 00                	add    %al,(%eax)
    8918:	00 00                	add    %al,(%eax)
    891a:	00 00                	add    %al,(%eax)
    891c:	00 00                	add    %al,(%eax)
    891e:	00 00                	add    %al,(%eax)
    8920:	00 00                	add    %al,(%eax)
    8922:	00 00                	add    %al,(%eax)
    8924:	00 00                	add    %al,(%eax)
    8926:	00 00                	add    %al,(%eax)
    8928:	00 00                	add    %al,(%eax)
    892a:	00 00                	add    %al,(%eax)
    892c:	00 00                	add    %al,(%eax)
    892e:	00 00                	add    %al,(%eax)
    8930:	00 00                	add    %al,(%eax)
    8932:	00 00                	add    %al,(%eax)
    8934:	00 00                	add    %al,(%eax)
    8936:	00 00                	add    %al,(%eax)
    8938:	00 00                	add    %al,(%eax)
    893a:	00 00                	add    %al,(%eax)
    893c:	00 00                	add    %al,(%eax)
    893e:	00 00                	add    %al,(%eax)
    8940:	00 00                	add    %al,(%eax)
    8942:	00 00                	add    %al,(%eax)
    8944:	00 00                	add    %al,(%eax)
    8946:	00 00                	add    %al,(%eax)
    8948:	00 00                	add    %al,(%eax)
    894a:	00 00                	add    %al,(%eax)
    894c:	00 00                	add    %al,(%eax)
    894e:	00 00                	add    %al,(%eax)
    8950:	00 00                	add    %al,(%eax)
    8952:	00 00                	add    %al,(%eax)
    8954:	00 00                	add    %al,(%eax)
    8956:	00 00                	add    %al,(%eax)
    8958:	00 00                	add    %al,(%eax)
    895a:	00 00                	add    %al,(%eax)
    895c:	00 00                	add    %al,(%eax)
    895e:	00 00                	add    %al,(%eax)
    8960:	00 00                	add    %al,(%eax)
    8962:	00 00                	add    %al,(%eax)
    8964:	00 00                	add    %al,(%eax)
    8966:	00 00                	add    %al,(%eax)
    8968:	00 00                	add    %al,(%eax)
    896a:	00 00                	add    %al,(%eax)
    896c:	00 00                	add    %al,(%eax)
    896e:	00 00                	add    %al,(%eax)
    8970:	00 00                	add    %al,(%eax)
    8972:	00 00                	add    %al,(%eax)
    8974:	00 00                	add    %al,(%eax)
    8976:	00 00                	add    %al,(%eax)
    8978:	00 00                	add    %al,(%eax)
    897a:	00 00                	add    %al,(%eax)
    897c:	00 00                	add    %al,(%eax)
    897e:	00 00                	add    %al,(%eax)
    8980:	00 00                	add    %al,(%eax)
    8982:	00 00                	add    %al,(%eax)
    8984:	00 00                	add    %al,(%eax)
    8986:	00 00                	add    %al,(%eax)
    8988:	00 00                	add    %al,(%eax)
    898a:	00 00                	add    %al,(%eax)
    898c:	00 00                	add    %al,(%eax)
    898e:	00 00                	add    %al,(%eax)
    8990:	00 00                	add    %al,(%eax)
    8992:	00 00                	add    %al,(%eax)
    8994:	00 00                	add    %al,(%eax)
    8996:	00 00                	add    %al,(%eax)
    8998:	00 00                	add    %al,(%eax)
    899a:	00 00                	add    %al,(%eax)
    899c:	00 00                	add    %al,(%eax)
    899e:	00 00                	add    %al,(%eax)
    89a0:	00 00                	add    %al,(%eax)
    89a2:	00 00                	add    %al,(%eax)
    89a4:	00 00                	add    %al,(%eax)
    89a6:	00 00                	add    %al,(%eax)
    89a8:	00 00                	add    %al,(%eax)
    89aa:	00 00                	add    %al,(%eax)
    89ac:	00 00                	add    %al,(%eax)
    89ae:	00 00                	add    %al,(%eax)
    89b0:	00 00                	add    %al,(%eax)
    89b2:	00 00                	add    %al,(%eax)
    89b4:	00 00                	add    %al,(%eax)
    89b6:	00 00                	add    %al,(%eax)
    89b8:	00 00                	add    %al,(%eax)
    89ba:	00 00                	add    %al,(%eax)
    89bc:	00 00                	add    %al,(%eax)
    89be:	00 00                	add    %al,(%eax)
    89c0:	00 00                	add    %al,(%eax)
    89c2:	00 00                	add    %al,(%eax)
    89c4:	00 00                	add    %al,(%eax)
    89c6:	00 00                	add    %al,(%eax)
    89c8:	00 00                	add    %al,(%eax)
    89ca:	00 00                	add    %al,(%eax)
    89cc:	00 00                	add    %al,(%eax)
    89ce:	00 00                	add    %al,(%eax)
    89d0:	00 00                	add    %al,(%eax)
    89d2:	00 00                	add    %al,(%eax)
    89d4:	00 00                	add    %al,(%eax)
    89d6:	00 00                	add    %al,(%eax)
    89d8:	00 00                	add    %al,(%eax)
    89da:	00 00                	add    %al,(%eax)
    89dc:	00 00                	add    %al,(%eax)
    89de:	00 00                	add    %al,(%eax)
    89e0:	00 00                	add    %al,(%eax)
    89e2:	00 00                	add    %al,(%eax)
    89e4:	00 00                	add    %al,(%eax)
    89e6:	00 00                	add    %al,(%eax)
    89e8:	00 00                	add    %al,(%eax)
    89ea:	00 00                	add    %al,(%eax)
    89ec:	00 00                	add    %al,(%eax)
    89ee:	00 00                	add    %al,(%eax)
    89f0:	00 00                	add    %al,(%eax)
    89f2:	00 00                	add    %al,(%eax)
    89f4:	00 00                	add    %al,(%eax)
    89f6:	00 00                	add    %al,(%eax)
    89f8:	00 00                	add    %al,(%eax)
    89fa:	00 00                	add    %al,(%eax)
    89fc:	00 00                	add    %al,(%eax)
    89fe:	00 00                	add    %al,(%eax)
    8a00:	00 00                	add    %al,(%eax)
    8a02:	00 00                	add    %al,(%eax)
    8a04:	00 00                	add    %al,(%eax)
    8a06:	00 00                	add    %al,(%eax)
    8a08:	00 00                	add    %al,(%eax)
    8a0a:	00 00                	add    %al,(%eax)
    8a0c:	00 00                	add    %al,(%eax)
    8a0e:	00 00                	add    %al,(%eax)
    8a10:	00 00                	add    %al,(%eax)
    8a12:	00 00                	add    %al,(%eax)
    8a14:	00 00                	add    %al,(%eax)
    8a16:	00 00                	add    %al,(%eax)
    8a18:	00 00                	add    %al,(%eax)
    8a1a:	00 00                	add    %al,(%eax)
    8a1c:	00 00                	add    %al,(%eax)
    8a1e:	00 00                	add    %al,(%eax)
    8a20:	00 00                	add    %al,(%eax)
    8a22:	00 00                	add    %al,(%eax)
    8a24:	00 00                	add    %al,(%eax)
    8a26:	00 00                	add    %al,(%eax)
    8a28:	00 00                	add    %al,(%eax)
    8a2a:	00 00                	add    %al,(%eax)
    8a2c:	00 00                	add    %al,(%eax)
    8a2e:	00 00                	add    %al,(%eax)
    8a30:	00 00                	add    %al,(%eax)
    8a32:	00 00                	add    %al,(%eax)
    8a34:	00 00                	add    %al,(%eax)
    8a36:	00 00                	add    %al,(%eax)
    8a38:	00 00                	add    %al,(%eax)
    8a3a:	00 00                	add    %al,(%eax)
    8a3c:	00 00                	add    %al,(%eax)
    8a3e:	00 00                	add    %al,(%eax)
    8a40:	00 00                	add    %al,(%eax)
    8a42:	00 00                	add    %al,(%eax)
    8a44:	00 00                	add    %al,(%eax)
    8a46:	00 00                	add    %al,(%eax)
    8a48:	00 00                	add    %al,(%eax)
    8a4a:	00 00                	add    %al,(%eax)
    8a4c:	00 00                	add    %al,(%eax)
    8a4e:	00 00                	add    %al,(%eax)
    8a50:	00 00                	add    %al,(%eax)
    8a52:	00 00                	add    %al,(%eax)
    8a54:	00 00                	add    %al,(%eax)
    8a56:	00 00                	add    %al,(%eax)
    8a58:	00 00                	add    %al,(%eax)
    8a5a:	00 00                	add    %al,(%eax)
    8a5c:	00 00                	add    %al,(%eax)
    8a5e:	00 00                	add    %al,(%eax)
    8a60:	00 00                	add    %al,(%eax)
    8a62:	00 00                	add    %al,(%eax)
    8a64:	00 00                	add    %al,(%eax)
    8a66:	00 00                	add    %al,(%eax)
    8a68:	00 00                	add    %al,(%eax)
    8a6a:	00 00                	add    %al,(%eax)
    8a6c:	00 00                	add    %al,(%eax)
    8a6e:	00 00                	add    %al,(%eax)
    8a70:	00 00                	add    %al,(%eax)
    8a72:	00 00                	add    %al,(%eax)
    8a74:	00 00                	add    %al,(%eax)
    8a76:	00 00                	add    %al,(%eax)
    8a78:	00 00                	add    %al,(%eax)
    8a7a:	00 00                	add    %al,(%eax)
    8a7c:	00 00                	add    %al,(%eax)
    8a7e:	00 00                	add    %al,(%eax)
    8a80:	00 00                	add    %al,(%eax)
    8a82:	00 00                	add    %al,(%eax)
    8a84:	00 00                	add    %al,(%eax)
    8a86:	00 00                	add    %al,(%eax)
    8a88:	00 00                	add    %al,(%eax)
    8a8a:	00 00                	add    %al,(%eax)
    8a8c:	00 00                	add    %al,(%eax)
    8a8e:	00 00                	add    %al,(%eax)
    8a90:	00 00                	add    %al,(%eax)
    8a92:	00 00                	add    %al,(%eax)
    8a94:	00 00                	add    %al,(%eax)
    8a96:	00 00                	add    %al,(%eax)
    8a98:	00 00                	add    %al,(%eax)
    8a9a:	00 00                	add    %al,(%eax)
    8a9c:	00 00                	add    %al,(%eax)
    8a9e:	00 00                	add    %al,(%eax)
    8aa0:	00 00                	add    %al,(%eax)
    8aa2:	00 00                	add    %al,(%eax)
    8aa4:	00 00                	add    %al,(%eax)
    8aa6:	00 00                	add    %al,(%eax)
    8aa8:	00 00                	add    %al,(%eax)
    8aaa:	00 00                	add    %al,(%eax)
    8aac:	00 00                	add    %al,(%eax)
    8aae:	00 00                	add    %al,(%eax)
    8ab0:	00 00                	add    %al,(%eax)
    8ab2:	00 00                	add    %al,(%eax)
    8ab4:	00 00                	add    %al,(%eax)
    8ab6:	00 00                	add    %al,(%eax)
    8ab8:	00 00                	add    %al,(%eax)
    8aba:	00 00                	add    %al,(%eax)
    8abc:	00 00                	add    %al,(%eax)
    8abe:	00 00                	add    %al,(%eax)
    8ac0:	00 00                	add    %al,(%eax)
    8ac2:	00 00                	add    %al,(%eax)
    8ac4:	00 00                	add    %al,(%eax)
    8ac6:	00 00                	add    %al,(%eax)
    8ac8:	00 00                	add    %al,(%eax)
    8aca:	00 00                	add    %al,(%eax)
    8acc:	00 00                	add    %al,(%eax)
    8ace:	00 00                	add    %al,(%eax)
    8ad0:	00 00                	add    %al,(%eax)
    8ad2:	00 00                	add    %al,(%eax)
    8ad4:	00 00                	add    %al,(%eax)
    8ad6:	00 00                	add    %al,(%eax)
    8ad8:	00 00                	add    %al,(%eax)
    8ada:	00 00                	add    %al,(%eax)
    8adc:	00 00                	add    %al,(%eax)
    8ade:	00 00                	add    %al,(%eax)
    8ae0:	00 00                	add    %al,(%eax)
    8ae2:	00 00                	add    %al,(%eax)
    8ae4:	00 00                	add    %al,(%eax)
    8ae6:	00 00                	add    %al,(%eax)
    8ae8:	00 00                	add    %al,(%eax)
    8aea:	00 00                	add    %al,(%eax)
    8aec:	00 00                	add    %al,(%eax)
    8aee:	00 00                	add    %al,(%eax)
    8af0:	00 00                	add    %al,(%eax)
    8af2:	00 00                	add    %al,(%eax)
    8af4:	00 00                	add    %al,(%eax)
    8af6:	00 00                	add    %al,(%eax)
    8af8:	00 00                	add    %al,(%eax)
    8afa:	00 00                	add    %al,(%eax)
    8afc:	00 00                	add    %al,(%eax)
    8afe:	00 00                	add    %al,(%eax)
    8b00:	00 00                	add    %al,(%eax)
    8b02:	00 00                	add    %al,(%eax)
    8b04:	00 00                	add    %al,(%eax)
    8b06:	00 00                	add    %al,(%eax)
    8b08:	00 00                	add    %al,(%eax)
    8b0a:	00 00                	add    %al,(%eax)
    8b0c:	00 00                	add    %al,(%eax)
    8b0e:	00 00                	add    %al,(%eax)
    8b10:	00 00                	add    %al,(%eax)
    8b12:	00 00                	add    %al,(%eax)
    8b14:	00 00                	add    %al,(%eax)
    8b16:	00 00                	add    %al,(%eax)
    8b18:	00 00                	add    %al,(%eax)
    8b1a:	00 00                	add    %al,(%eax)
    8b1c:	00 00                	add    %al,(%eax)
    8b1e:	00 00                	add    %al,(%eax)
    8b20:	00 00                	add    %al,(%eax)
    8b22:	00 00                	add    %al,(%eax)
    8b24:	00 00                	add    %al,(%eax)

00008b26 <putc>:
 * video
 */
volatile char *video = (volatile char *) 0xB8000;

void putc(int l, int color, char ch)
{
    8b26:	55                   	push   %ebp
    8b27:	89 e5                	mov    %esp,%ebp
    8b29:	8b 45 08             	mov    0x8(%ebp),%eax
    volatile char *p = video + l * 2;
    *p = ch;
    8b2c:	8b 55 10             	mov    0x10(%ebp),%edx
    volatile char *p = video + l * 2;
    8b2f:	01 c0                	add    %eax,%eax
    8b31:	03 05 a4 92 00 00    	add    0x92a4,%eax
    *p = ch;
    8b37:	88 10                	mov    %dl,(%eax)
    *(p + 1) = color;
    8b39:	8b 55 0c             	mov    0xc(%ebp),%edx
    8b3c:	88 50 01             	mov    %dl,0x1(%eax)
}
    8b3f:	5d                   	pop    %ebp
    8b40:	c3                   	ret    

00008b41 <puts>:

int puts(int r, int c, int color, const char *string)
{
    8b41:	55                   	push   %ebp
    8b42:	89 e5                	mov    %esp,%ebp
    8b44:	56                   	push   %esi
    8b45:	8b 4d 10             	mov    0x10(%ebp),%ecx
    int l = r * 80 + c;
    8b48:	6b 75 08 50          	imul   $0x50,0x8(%ebp),%esi
{
    8b4c:	53                   	push   %ebx
    int l = r * 80 + c;
    8b4d:	03 75 0c             	add    0xc(%ebp),%esi
    8b50:	89 f0                	mov    %esi,%eax
    while (*string != 0) {
    8b52:	8b 55 14             	mov    0x14(%ebp),%edx
    8b55:	29 f2                	sub    %esi,%edx
    8b57:	0f be 14 02          	movsbl (%edx,%eax,1),%edx
    8b5b:	84 d2                	test   %dl,%dl
    8b5d:	74 15                	je     8b74 <puts+0x33>
        putc(l++, color, *string++);
    8b5f:	83 ec 04             	sub    $0x4,%esp
    8b62:	8d 58 01             	lea    0x1(%eax),%ebx
    8b65:	52                   	push   %edx
    8b66:	51                   	push   %ecx
    8b67:	50                   	push   %eax
    8b68:	e8 b9 ff ff ff       	call   8b26 <putc>
    8b6d:	83 c4 10             	add    $0x10,%esp
    8b70:	89 d8                	mov    %ebx,%eax
    8b72:	eb de                	jmp    8b52 <puts+0x11>
    }
    return l;
}
    8b74:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8b77:	5b                   	pop    %ebx
    8b78:	5e                   	pop    %esi
    8b79:	5d                   	pop    %ebp
    8b7a:	c3                   	ret    

00008b7b <putline>:

char *blank =
    "                                                                                ";

void putline(char *s)
{
    8b7b:	55                   	push   %ebp
    8b7c:	89 e5                	mov    %esp,%ebp
    8b7e:	53                   	push   %ebx
    8b7f:	50                   	push   %eax
    puts(row = (row >= CRT_ROWS) ? 0 : row + 1, 0, VGA_CLR_BLACK, blank);
    8b80:	a1 48 93 00 00       	mov    0x9348,%eax
    8b85:	8b 15 a0 92 00 00    	mov    0x92a0,%edx
    8b8b:	8d 58 01             	lea    0x1(%eax),%ebx
    8b8e:	83 f8 18             	cmp    $0x18,%eax
    8b91:	7e 02                	jle    8b95 <putline+0x1a>
    8b93:	31 db                	xor    %ebx,%ebx
    8b95:	52                   	push   %edx
    8b96:	6a 00                	push   $0x0
    8b98:	6a 00                	push   $0x0
    8b9a:	53                   	push   %ebx
    8b9b:	89 1d 48 93 00 00    	mov    %ebx,0x9348
    8ba1:	e8 9b ff ff ff       	call   8b41 <puts>
    puts(row, 0, VGA_CLR_WHITE, s);
    8ba6:	ff 75 08             	pushl  0x8(%ebp)
    8ba9:	6a 0f                	push   $0xf
    8bab:	6a 00                	push   $0x0
    8bad:	53                   	push   %ebx
    8bae:	e8 8e ff ff ff       	call   8b41 <puts>
}
    8bb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    8bb6:	83 c4 20             	add    $0x20,%esp
    8bb9:	c9                   	leave  
    8bba:	c3                   	ret    

00008bbb <roll>:

void roll(int r)
{
    8bbb:	55                   	push   %ebp
    8bbc:	89 e5                	mov    %esp,%ebp
    row = r;
    8bbe:	8b 45 08             	mov    0x8(%ebp),%eax
}
    8bc1:	5d                   	pop    %ebp
    row = r;
    8bc2:	a3 48 93 00 00       	mov    %eax,0x9348
}
    8bc7:	c3                   	ret    

00008bc8 <panic>:

void panic(char *m)
{
    8bc8:	55                   	push   %ebp
    8bc9:	89 e5                	mov    %esp,%ebp
    8bcb:	83 ec 08             	sub    $0x8,%esp
    puts(0, 0, VGA_CLR_RED, m);
    8bce:	ff 75 08             	pushl  0x8(%ebp)
    8bd1:	6a 04                	push   $0x4
    8bd3:	6a 00                	push   $0x0
    8bd5:	6a 00                	push   $0x0
    8bd7:	e8 65 ff ff ff       	call   8b41 <puts>
    8bdc:	83 c4 10             	add    $0x10,%esp
    while (1) {
        asm volatile ("hlt");
    8bdf:	f4                   	hlt    
    while (1) {
    8be0:	eb fd                	jmp    8bdf <panic+0x17>

00008be2 <strlen>:

/**
 * string
 */
int strlen(const char *s)
{
    8be2:	55                   	push   %ebp
    int n;

    for (n = 0; *s != '\0'; s++)
    8be3:	31 c0                	xor    %eax,%eax
{
    8be5:	89 e5                	mov    %esp,%ebp
    8be7:	8b 55 08             	mov    0x8(%ebp),%edx
    for (n = 0; *s != '\0'; s++)
    8bea:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    8bee:	74 03                	je     8bf3 <strlen+0x11>
        n++;
    8bf0:	40                   	inc    %eax
    for (n = 0; *s != '\0'; s++)
    8bf1:	eb f7                	jmp    8bea <strlen+0x8>
    return n;
}
    8bf3:	5d                   	pop    %ebp
    8bf4:	c3                   	ret    

00008bf5 <reverse>:

/* reverse: reverse string s in place */
void reverse(char s[])
{
    8bf5:	55                   	push   %ebp
    8bf6:	89 e5                	mov    %esp,%ebp
    8bf8:	56                   	push   %esi
    8bf9:	53                   	push   %ebx
    8bfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
    int i, j;
    char c;

    for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
    8bfd:	83 ec 0c             	sub    $0xc,%esp
    8c00:	51                   	push   %ecx
    8c01:	e8 dc ff ff ff       	call   8be2 <strlen>
    8c06:	83 c4 10             	add    $0x10,%esp
    8c09:	31 d2                	xor    %edx,%edx
    8c0b:	48                   	dec    %eax
    8c0c:	39 c2                	cmp    %eax,%edx
    8c0e:	7d 13                	jge    8c23 <reverse+0x2e>
        c = s[i];
    8c10:	0f b6 34 11          	movzbl (%ecx,%edx,1),%esi
        s[i] = s[j];
    8c14:	8a 1c 01             	mov    (%ecx,%eax,1),%bl
    8c17:	88 1c 11             	mov    %bl,(%ecx,%edx,1)
        s[j] = c;
    8c1a:	89 f3                	mov    %esi,%ebx
    for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
    8c1c:	42                   	inc    %edx
        s[j] = c;
    8c1d:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
    for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
    8c20:	48                   	dec    %eax
    8c21:	eb e9                	jmp    8c0c <reverse+0x17>
    }
}
    8c23:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8c26:	5b                   	pop    %ebx
    8c27:	5e                   	pop    %esi
    8c28:	5d                   	pop    %ebp
    8c29:	c3                   	ret    

00008c2a <itox>:

/* itoa: convert n to characters in s */
void itox(int n, char s[], int root, char *table)
{
    8c2a:	55                   	push   %ebp
    8c2b:	31 c9                	xor    %ecx,%ecx
    8c2d:	89 e5                	mov    %esp,%ebp
    8c2f:	57                   	push   %edi
    8c30:	56                   	push   %esi
    8c31:	53                   	push   %ebx
    8c32:	83 ec 1c             	sub    $0x1c,%esp
    8c35:	8b 75 08             	mov    0x8(%ebp),%esi
    8c38:	8b 45 10             	mov    0x10(%ebp),%eax
    8c3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    8c3e:	8b 7d 14             	mov    0x14(%ebp),%edi
    8c41:	89 f2                	mov    %esi,%edx
    8c43:	89 45 e0             	mov    %eax,-0x20(%ebp)
    8c46:	c1 fa 1f             	sar    $0x1f,%edx
    8c49:	89 d0                	mov    %edx,%eax
    8c4b:	31 f0                	xor    %esi,%eax
    8c4d:	29 d0                	sub    %edx,%eax

    if ((sign = n) < 0)            /* record sign */
        n = -n;                    /* make n positive */
    i = 0;
    do {                           /* generate digits in reverse order */
        s[i++] = table[n % root];  /* get next digit */
    8c4f:	99                   	cltd   
    8c50:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    8c53:	41                   	inc    %ecx
    } while ((n /= root) > 0);     /* delete it */
    8c54:	f7 7d e0             	idivl  -0x20(%ebp)
        s[i++] = table[n % root];  /* get next digit */
    8c57:	8a 14 17             	mov    (%edi,%edx,1),%dl
    8c5a:	88 54 0b ff          	mov    %dl,-0x1(%ebx,%ecx,1)
    8c5e:	89 ca                	mov    %ecx,%edx
    } while ((n /= root) > 0);     /* delete it */
    8c60:	85 c0                	test   %eax,%eax
    8c62:	7f eb                	jg     8c4f <itox+0x25>
    if (sign < 0)
    8c64:	85 f6                	test   %esi,%esi
    8c66:	79 0a                	jns    8c72 <itox+0x48>
        s[i++] = '-';
    8c68:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    8c6b:	c6 04 13 2d          	movb   $0x2d,(%ebx,%edx,1)
    8c6f:	83 c1 02             	add    $0x2,%ecx
    s[i] = '\0';
    8c72:	c6 04 0b 00          	movb   $0x0,(%ebx,%ecx,1)
    reverse(s);
    8c76:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    8c79:	83 c4 1c             	add    $0x1c,%esp
    8c7c:	5b                   	pop    %ebx
    8c7d:	5e                   	pop    %esi
    8c7e:	5f                   	pop    %edi
    8c7f:	5d                   	pop    %ebp
    reverse(s);
    8c80:	e9 70 ff ff ff       	jmp    8bf5 <reverse>

00008c85 <itoa>:

void itoa(int n, char s[])
{
    8c85:	55                   	push   %ebp
    8c86:	89 e5                	mov    %esp,%ebp
    8c88:	83 ec 08             	sub    $0x8,%esp
    static char dec[] = "0123456789";
    itox(n, s, 10, dec);
    8c8b:	68 94 92 00 00       	push   $0x9294
    8c90:	6a 0a                	push   $0xa
    8c92:	ff 75 0c             	pushl  0xc(%ebp)
    8c95:	ff 75 08             	pushl  0x8(%ebp)
    8c98:	e8 8d ff ff ff       	call   8c2a <itox>
}
    8c9d:	83 c4 10             	add    $0x10,%esp
    8ca0:	c9                   	leave  
    8ca1:	c3                   	ret    

00008ca2 <itoh>:

void itoh(int n, char *s)
{
    8ca2:	55                   	push   %ebp
    8ca3:	89 e5                	mov    %esp,%ebp
    8ca5:	83 ec 08             	sub    $0x8,%esp
    static char hex[] = "0123456789abcdef";
    itox(n, s, 16, hex);
    8ca8:	68 80 92 00 00       	push   $0x9280
    8cad:	6a 10                	push   $0x10
    8caf:	ff 75 0c             	pushl  0xc(%ebp)
    8cb2:	ff 75 08             	pushl  0x8(%ebp)
    8cb5:	e8 70 ff ff ff       	call   8c2a <itox>
}
    8cba:	83 c4 10             	add    $0x10,%esp
    8cbd:	c9                   	leave  
    8cbe:	c3                   	ret    

00008cbf <puti>:
{
    8cbf:	55                   	push   %ebp
    8cc0:	89 e5                	mov    %esp,%ebp
    8cc2:	83 ec 10             	sub    $0x10,%esp
    itoh(i, puti_str);
    8cc5:	68 20 93 00 00       	push   $0x9320
    8cca:	ff 75 08             	pushl  0x8(%ebp)
    8ccd:	e8 d0 ff ff ff       	call   8ca2 <itoh>
    putline(puti_str);
    8cd2:	c7 45 08 20 93 00 00 	movl   $0x9320,0x8(%ebp)
    8cd9:	83 c4 10             	add    $0x10,%esp
}
    8cdc:	c9                   	leave  
    putline(puti_str);
    8cdd:	e9 99 fe ff ff       	jmp    8b7b <putline>

00008ce2 <readsector>:
    while ((inb(0x1F7) & 0xC0) != 0x40)
        /* do nothing */ ;
}

void readsector(void *dst, uint32_t offset)
{
    8ce2:	55                   	push   %ebp
    8ce3:	89 e5                	mov    %esp,%ebp
    8ce5:	57                   	push   %edi
}

static inline uint8_t inb(int port)
{
    uint8_t data;
    __asm __volatile ("inb %w1,%0" : "=a" (data) : "d" (port));
    8ce6:	bf f7 01 00 00       	mov    $0x1f7,%edi
    8ceb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    8cee:	89 fa                	mov    %edi,%edx
    8cf0:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    8cf1:	83 e0 c0             	and    $0xffffffc0,%eax
    8cf4:	3c 40                	cmp    $0x40,%al
    8cf6:	75 f6                	jne    8cee <readsector+0xc>
    __asm __volatile ("outb %0,%w1" :: "a" (data), "d" (port));
    8cf8:	b0 01                	mov    $0x1,%al
    8cfa:	ba f2 01 00 00       	mov    $0x1f2,%edx
    8cff:	ee                   	out    %al,(%dx)
    8d00:	ba f3 01 00 00       	mov    $0x1f3,%edx
    8d05:	89 c8                	mov    %ecx,%eax
    8d07:	ee                   	out    %al,(%dx)
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1);     // count = 1
    outb(0x1F3, offset);
    outb(0x1F4, offset >> 8);
    8d08:	89 c8                	mov    %ecx,%eax
    8d0a:	ba f4 01 00 00       	mov    $0x1f4,%edx
    8d0f:	c1 e8 08             	shr    $0x8,%eax
    8d12:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
    8d13:	89 c8                	mov    %ecx,%eax
    8d15:	ba f5 01 00 00       	mov    $0x1f5,%edx
    8d1a:	c1 e8 10             	shr    $0x10,%eax
    8d1d:	ee                   	out    %al,(%dx)
    outb(0x1F6, (offset >> 24) | 0xE0);
    8d1e:	89 c8                	mov    %ecx,%eax
    8d20:	ba f6 01 00 00       	mov    $0x1f6,%edx
    8d25:	c1 e8 18             	shr    $0x18,%eax
    8d28:	83 c8 e0             	or     $0xffffffe0,%eax
    8d2b:	ee                   	out    %al,(%dx)
    8d2c:	b0 20                	mov    $0x20,%al
    8d2e:	89 fa                	mov    %edi,%edx
    8d30:	ee                   	out    %al,(%dx)
    __asm __volatile ("inb %w1,%0" : "=a" (data) : "d" (port));
    8d31:	ba f7 01 00 00       	mov    $0x1f7,%edx
    8d36:	ec                   	in     (%dx),%al
    while ((inb(0x1F7) & 0xC0) != 0x40)
    8d37:	83 e0 c0             	and    $0xffffffc0,%eax
    8d3a:	3c 40                	cmp    $0x40,%al
    8d3c:	75 f8                	jne    8d36 <readsector+0x54>
    return data;
}

static inline void insl(int port, void *addr, int cnt)
{
    __asm __volatile ("cld\n\trepne\n\tinsl"
    8d3e:	8b 7d 08             	mov    0x8(%ebp),%edi
    8d41:	b9 80 00 00 00       	mov    $0x80,%ecx
    8d46:	ba f0 01 00 00       	mov    $0x1f0,%edx
    8d4b:	fc                   	cld    
    8d4c:	f2 6d                	repnz insl (%dx),%es:(%edi)
    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTOR_SIZE / 4);
}
    8d4e:	5f                   	pop    %edi
    8d4f:	5d                   	pop    %ebp
    8d50:	c3                   	ret    

00008d51 <readsection>:

// Read 'count' bytes at 'offset' from kernel into virtual address 'va'.
// Might copy more than asked
void readsection(uint32_t va, uint32_t count, uint32_t offset, uint32_t lba)
{
    8d51:	55                   	push   %ebp
    8d52:	89 e5                	mov    %esp,%ebp
    8d54:	57                   	push   %edi
    8d55:	56                   	push   %esi
    8d56:	53                   	push   %ebx
    8d57:	83 ec 0c             	sub    $0xc,%esp
    8d5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
    end_va = va + count;
    // round down to sector boundary
    va &= ~(SECTOR_SIZE - 1);

    // translate from bytes to sectors, and kernel starts at sector 1
    offset = (offset / SECTOR_SIZE) + lba;
    8d5d:	8b 7d 10             	mov    0x10(%ebp),%edi
    va &= 0xFFFFFF;
    8d60:	89 de                	mov    %ebx,%esi
    offset = (offset / SECTOR_SIZE) + lba;
    8d62:	c1 ef 09             	shr    $0x9,%edi
    va &= ~(SECTOR_SIZE - 1);
    8d65:	81 e3 00 fe ff 00    	and    $0xfffe00,%ebx
    offset = (offset / SECTOR_SIZE) + lba;
    8d6b:	03 7d 14             	add    0x14(%ebp),%edi
    va &= 0xFFFFFF;
    8d6e:	81 e6 ff ff ff 00    	and    $0xffffff,%esi
    end_va = va + count;
    8d74:	03 75 0c             	add    0xc(%ebp),%esi

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    while (va < end_va) {
    8d77:	39 f3                	cmp    %esi,%ebx
    8d79:	73 15                	jae    8d90 <readsection+0x3f>
        readsector((uint8_t *) va, offset);
    8d7b:	50                   	push   %eax
    8d7c:	50                   	push   %eax
    8d7d:	57                   	push   %edi
        va += SECTOR_SIZE;
        offset++;
    8d7e:	47                   	inc    %edi
        readsector((uint8_t *) va, offset);
    8d7f:	53                   	push   %ebx
        va += SECTOR_SIZE;
    8d80:	81 c3 00 02 00 00    	add    $0x200,%ebx
        readsector((uint8_t *) va, offset);
    8d86:	e8 57 ff ff ff       	call   8ce2 <readsector>
        offset++;
    8d8b:	83 c4 10             	add    $0x10,%esp
    8d8e:	eb e7                	jmp    8d77 <readsection+0x26>
    }
}
    8d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8d93:	5b                   	pop    %ebx
    8d94:	5e                   	pop    %esi
    8d95:	5f                   	pop    %edi
    8d96:	5d                   	pop    %ebp
    8d97:	c3                   	ret    

00008d98 <load_kernel>:
}

#define ELFHDR ((elfhdr *) 0x20000)

uint32_t load_kernel(uint32_t dkernel)
{
    8d98:	55                   	push   %ebp
    8d99:	89 e5                	mov    %esp,%ebp
    8d9b:	57                   	push   %edi
    8d9c:	56                   	push   %esi
    8d9d:	53                   	push   %ebx
    8d9e:	83 ec 0c             	sub    $0xc,%esp
    8da1:	8b 7d 08             	mov    0x8(%ebp),%edi
    // load kernel from the beginning of the first bootable partition
    proghdr *ph, *eph;

    readsection((uint32_t) ELFHDR, SECTOR_SIZE * 8, 0, dkernel);
    8da4:	57                   	push   %edi
    8da5:	6a 00                	push   $0x0
    8da7:	68 00 10 00 00       	push   $0x1000
    8dac:	68 00 00 02 00       	push   $0x20000
    8db1:	e8 9b ff ff ff       	call   8d51 <readsection>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC)
    8db6:	83 c4 10             	add    $0x10,%esp
    8db9:	81 3d 00 00 02 00 7f 	cmpl   $0x464c457f,0x20000
    8dc0:	45 4c 46 
    8dc3:	74 10                	je     8dd5 <load_kernel+0x3d>
        panic("Kernel is not a valid elf.");
    8dc5:	83 ec 0c             	sub    $0xc,%esp
    8dc8:	68 7d 8f 00 00       	push   $0x8f7d
    8dcd:	e8 f6 fd ff ff       	call   8bc8 <panic>
    8dd2:	83 c4 10             	add    $0x10,%esp

    // load each program segment (ignores ph flags)
    ph = (proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    8dd5:	a1 1c 00 02 00       	mov    0x2001c,%eax
    eph = ph + ELFHDR->e_phnum;
    8dda:	0f b7 35 2c 00 02 00 	movzwl 0x2002c,%esi
    ph = (proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    8de1:	8d 98 00 00 02 00    	lea    0x20000(%eax),%ebx
    eph = ph + ELFHDR->e_phnum;
    8de7:	c1 e6 05             	shl    $0x5,%esi
    8dea:	01 de                	add    %ebx,%esi

    for (; ph < eph; ph++) {
    8dec:	39 f3                	cmp    %esi,%ebx
    8dee:	73 17                	jae    8e07 <load_kernel+0x6f>
        readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    8df0:	57                   	push   %edi
    for (; ph < eph; ph++) {
    8df1:	83 c3 20             	add    $0x20,%ebx
        readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    8df4:	ff 73 e4             	pushl  -0x1c(%ebx)
    8df7:	ff 73 f4             	pushl  -0xc(%ebx)
    8dfa:	ff 73 e8             	pushl  -0x18(%ebx)
    8dfd:	e8 4f ff ff ff       	call   8d51 <readsection>
    for (; ph < eph; ph++) {
    8e02:	83 c4 10             	add    $0x10,%esp
    8e05:	eb e5                	jmp    8dec <load_kernel+0x54>
    }

    return (ELFHDR->e_entry & 0xFFFFFF);
    8e07:	a1 18 00 02 00       	mov    0x20018,%eax
}
    8e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8e0f:	5b                   	pop    %ebx
    8e10:	5e                   	pop    %esi
    return (ELFHDR->e_entry & 0xFFFFFF);
    8e11:	25 ff ff ff 00       	and    $0xffffff,%eax
}
    8e16:	5f                   	pop    %edi
    8e17:	5d                   	pop    %ebp
    8e18:	c3                   	ret    

00008e19 <parse_e820>:

mboot_info_t *parse_e820(bios_smap_t *smap)
{
    8e19:	55                   	push   %ebp
    8e1a:	89 e5                	mov    %esp,%ebp
    8e1c:	56                   	push   %esi
    8e1d:	53                   	push   %ebx
    8e1e:	8b 75 08             	mov    0x8(%ebp),%esi
    bios_smap_t *p;
    uint32_t mmap_len;
    p = smap;
    mmap_len = 0;
    8e21:	31 db                	xor    %ebx,%ebx
    putline("* E820 Memory Map *");
    8e23:	83 ec 0c             	sub    $0xc,%esp
    8e26:	68 98 8f 00 00       	push   $0x8f98
    8e2b:	e8 4b fd ff ff       	call   8b7b <putline>
    while (p->base_addr != 0 || p->length != 0 || p->type != 0) {
    8e30:	83 c4 10             	add    $0x10,%esp
    8e33:	8b 44 1e 04          	mov    0x4(%esi,%ebx,1),%eax
    8e37:	89 c1                	mov    %eax,%ecx
    8e39:	0b 4c 1e 08          	or     0x8(%esi,%ebx,1),%ecx
    8e3d:	74 11                	je     8e50 <parse_e820+0x37>
        puti(p->base_addr);
    8e3f:	83 ec 0c             	sub    $0xc,%esp
        p++;
        mmap_len += sizeof(bios_smap_t);
    8e42:	83 c3 18             	add    $0x18,%ebx
        puti(p->base_addr);
    8e45:	50                   	push   %eax
    8e46:	e8 74 fe ff ff       	call   8cbf <puti>
        mmap_len += sizeof(bios_smap_t);
    8e4b:	83 c4 10             	add    $0x10,%esp
    8e4e:	eb e3                	jmp    8e33 <parse_e820+0x1a>
    while (p->base_addr != 0 || p->length != 0 || p->type != 0) {
    8e50:	8b 54 1e 10          	mov    0x10(%esi,%ebx,1),%edx
    8e54:	0b 54 1e 0c          	or     0xc(%esi,%ebx,1),%edx
    8e58:	75 e5                	jne    8e3f <parse_e820+0x26>
    8e5a:	83 7c 1e 14 00       	cmpl   $0x0,0x14(%esi,%ebx,1)
    8e5f:	75 de                	jne    8e3f <parse_e820+0x26>
    }
    mboot_info.mmap_length = mmap_len;
    8e61:	89 1d ec 92 00 00    	mov    %ebx,0x92ec
    mboot_info.mmap_addr = (uint32_t) smap;
    return &mboot_info;
}
    8e67:	b8 c0 92 00 00       	mov    $0x92c0,%eax
    mboot_info.mmap_addr = (uint32_t) smap;
    8e6c:	89 35 f0 92 00 00    	mov    %esi,0x92f0
}
    8e72:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8e75:	5b                   	pop    %ebx
    8e76:	5e                   	pop    %esi
    8e77:	5d                   	pop    %ebp
    8e78:	c3                   	ret    

00008e79 <boot1main>:
{
    8e79:	55                   	push   %ebp
    8e7a:	89 e5                	mov    %esp,%ebp
    8e7c:	56                   	push   %esi
    8e7d:	53                   	push   %ebx
    8e7e:	8b 75 0c             	mov    0xc(%ebp),%esi
    8e81:	8b 5d 10             	mov    0x10(%ebp),%ebx
    roll(3);
    8e84:	83 ec 0c             	sub    $0xc,%esp
    8e87:	6a 03                	push   $0x3
    8e89:	e8 2d fd ff ff       	call   8bbb <roll>
    putline("Start boot1 main ...");
    8e8e:	c7 04 24 ac 8f 00 00 	movl   $0x8fac,(%esp)
    8e95:	e8 e1 fc ff ff       	call   8b7b <putline>
    8e9a:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 4; i++) {
    8e9d:	31 c0                	xor    %eax,%eax
        if (mbr->partition[i].bootable == BOOTABLE_PARTITION) {
    8e9f:	89 c2                	mov    %eax,%edx
    8ea1:	c1 e2 04             	shl    $0x4,%edx
    8ea4:	80 bc 16 be 01 00 00 	cmpb   $0x80,0x1be(%esi,%edx,1)
    8eab:	80 
    8eac:	75 09                	jne    8eb7 <boot1main+0x3e>
            bootable_lba = mbr->partition[i].first_lba;
    8eae:	8b b4 32 c6 01 00 00 	mov    0x1c6(%edx,%esi,1),%esi
    if (i == 4)
    8eb5:	eb 18                	jmp    8ecf <boot1main+0x56>
    for (i = 0; i < 4; i++) {
    8eb7:	40                   	inc    %eax
    8eb8:	83 f8 04             	cmp    $0x4,%eax
    8ebb:	75 e2                	jne    8e9f <boot1main+0x26>
        panic("Cannot find bootable partition!");
    8ebd:	83 ec 0c             	sub    $0xc,%esp
    uint32_t bootable_lba = 0;
    8ec0:	31 f6                	xor    %esi,%esi
        panic("Cannot find bootable partition!");
    8ec2:	68 f9 8f 00 00       	push   $0x8ff9
    8ec7:	e8 fc fc ff ff       	call   8bc8 <panic>
    8ecc:	83 c4 10             	add    $0x10,%esp
    parse_e820(smap);
    8ecf:	83 ec 0c             	sub    $0xc,%esp
    8ed2:	53                   	push   %ebx
    8ed3:	e8 41 ff ff ff       	call   8e19 <parse_e820>
    putline("Load kernel ...\n");
    8ed8:	c7 04 24 c1 8f 00 00 	movl   $0x8fc1,(%esp)
    8edf:	e8 97 fc ff ff       	call   8b7b <putline>
    uint32_t entry = load_kernel(bootable_lba);
    8ee4:	89 34 24             	mov    %esi,(%esp)
    8ee7:	e8 ac fe ff ff       	call   8d98 <load_kernel>
    putline("Start kernel ...\n");
    8eec:	c7 04 24 d2 8f 00 00 	movl   $0x8fd2,(%esp)
    uint32_t entry = load_kernel(bootable_lba);
    8ef3:	89 c3                	mov    %eax,%ebx
    putline("Start kernel ...\n");
    8ef5:	e8 81 fc ff ff       	call   8b7b <putline>
    exec_kernel(entry, &mboot_info);
    8efa:	58                   	pop    %eax
    8efb:	5a                   	pop    %edx
    8efc:	68 c0 92 00 00       	push   $0x92c0
    8f01:	53                   	push   %ebx
    8f02:	e8 15 00 00 00       	call   8f1c <exec_kernel>
    panic("Fail to load kernel.");
    8f07:	c7 45 08 e4 8f 00 00 	movl   $0x8fe4,0x8(%ebp)
    8f0e:	83 c4 10             	add    $0x10,%esp
}
    8f11:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8f14:	5b                   	pop    %ebx
    8f15:	5e                   	pop    %esi
    8f16:	5d                   	pop    %ebp
    panic("Fail to load kernel.");
    8f17:	e9 ac fc ff ff       	jmp    8bc8 <panic>

00008f1c <exec_kernel>:
	.set MBOOT_INFO_MAGIC, 0x2badb002

	.globl exec_kernel
	.code32
exec_kernel:
	cli
    8f1c:	fa                   	cli    
	movl	$MBOOT_INFO_MAGIC, %eax
    8f1d:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
	movl	8(%esp), %ebx
    8f22:	8b 5c 24 08          	mov    0x8(%esp),%ebx
	movl	4(%esp), %edx
    8f26:	8b 54 24 04          	mov    0x4(%esp),%edx
	jmp	*%edx
    8f2a:	ff e2                	jmp    *%edx

Disassembly of section .rodata:

00008f2c <.rodata>:
    8f2c:	20 20                	and    %ah,(%eax)
    8f2e:	20 20                	and    %ah,(%eax)
    8f30:	20 20                	and    %ah,(%eax)
    8f32:	20 20                	and    %ah,(%eax)
    8f34:	20 20                	and    %ah,(%eax)
    8f36:	20 20                	and    %ah,(%eax)
    8f38:	20 20                	and    %ah,(%eax)
    8f3a:	20 20                	and    %ah,(%eax)
    8f3c:	20 20                	and    %ah,(%eax)
    8f3e:	20 20                	and    %ah,(%eax)
    8f40:	20 20                	and    %ah,(%eax)
    8f42:	20 20                	and    %ah,(%eax)
    8f44:	20 20                	and    %ah,(%eax)
    8f46:	20 20                	and    %ah,(%eax)
    8f48:	20 20                	and    %ah,(%eax)
    8f4a:	20 20                	and    %ah,(%eax)
    8f4c:	20 20                	and    %ah,(%eax)
    8f4e:	20 20                	and    %ah,(%eax)
    8f50:	20 20                	and    %ah,(%eax)
    8f52:	20 20                	and    %ah,(%eax)
    8f54:	20 20                	and    %ah,(%eax)
    8f56:	20 20                	and    %ah,(%eax)
    8f58:	20 20                	and    %ah,(%eax)
    8f5a:	20 20                	and    %ah,(%eax)
    8f5c:	20 20                	and    %ah,(%eax)
    8f5e:	20 20                	and    %ah,(%eax)
    8f60:	20 20                	and    %ah,(%eax)
    8f62:	20 20                	and    %ah,(%eax)
    8f64:	20 20                	and    %ah,(%eax)
    8f66:	20 20                	and    %ah,(%eax)
    8f68:	20 20                	and    %ah,(%eax)
    8f6a:	20 20                	and    %ah,(%eax)
    8f6c:	20 20                	and    %ah,(%eax)
    8f6e:	20 20                	and    %ah,(%eax)
    8f70:	20 20                	and    %ah,(%eax)
    8f72:	20 20                	and    %ah,(%eax)
    8f74:	20 20                	and    %ah,(%eax)
    8f76:	20 20                	and    %ah,(%eax)
    8f78:	20 20                	and    %ah,(%eax)
    8f7a:	20 20                	and    %ah,(%eax)
    8f7c:	00 4b 65             	add    %cl,0x65(%ebx)
    8f7f:	72 6e                	jb     8fef <exec_kernel+0xd3>
    8f81:	65 6c                	gs insb (%dx),%es:(%edi)
    8f83:	20 69 73             	and    %ch,0x73(%ecx)
    8f86:	20 6e 6f             	and    %ch,0x6f(%esi)
    8f89:	74 20                	je     8fab <exec_kernel+0x8f>
    8f8b:	61                   	popa   
    8f8c:	20 76 61             	and    %dh,0x61(%esi)
    8f8f:	6c                   	insb   (%dx),%es:(%edi)
    8f90:	69 64 20 65 6c 66 2e 	imul   $0x2e666c,0x65(%eax,%eiz,1),%esp
    8f97:	00 
    8f98:	2a 20                	sub    (%eax),%ah
    8f9a:	45                   	inc    %ebp
    8f9b:	38 32                	cmp    %dh,(%edx)
    8f9d:	30 20                	xor    %ah,(%eax)
    8f9f:	4d                   	dec    %ebp
    8fa0:	65 6d                	gs insl (%dx),%es:(%edi)
    8fa2:	6f                   	outsl  %ds:(%esi),(%dx)
    8fa3:	72 79                	jb     901e <exec_kernel+0x102>
    8fa5:	20 4d 61             	and    %cl,0x61(%ebp)
    8fa8:	70 20                	jo     8fca <exec_kernel+0xae>
    8faa:	2a 00                	sub    (%eax),%al
    8fac:	53                   	push   %ebx
    8fad:	74 61                	je     9010 <exec_kernel+0xf4>
    8faf:	72 74                	jb     9025 <exec_kernel+0x109>
    8fb1:	20 62 6f             	and    %ah,0x6f(%edx)
    8fb4:	6f                   	outsl  %ds:(%esi),(%dx)
    8fb5:	74 31                	je     8fe8 <exec_kernel+0xcc>
    8fb7:	20 6d 61             	and    %ch,0x61(%ebp)
    8fba:	69 6e 20 2e 2e 2e 00 	imul   $0x2e2e2e,0x20(%esi),%ebp
    8fc1:	4c                   	dec    %esp
    8fc2:	6f                   	outsl  %ds:(%esi),(%dx)
    8fc3:	61                   	popa   
    8fc4:	64 20 6b 65          	and    %ch,%fs:0x65(%ebx)
    8fc8:	72 6e                	jb     9038 <exec_kernel+0x11c>
    8fca:	65 6c                	gs insb (%dx),%es:(%edi)
    8fcc:	20 2e                	and    %ch,(%esi)
    8fce:	2e 2e 0a 00          	cs or  %cs:(%eax),%al
    8fd2:	53                   	push   %ebx
    8fd3:	74 61                	je     9036 <exec_kernel+0x11a>
    8fd5:	72 74                	jb     904b <exec_kernel+0x12f>
    8fd7:	20 6b 65             	and    %ch,0x65(%ebx)
    8fda:	72 6e                	jb     904a <exec_kernel+0x12e>
    8fdc:	65 6c                	gs insb (%dx),%es:(%edi)
    8fde:	20 2e                	and    %ch,(%esi)
    8fe0:	2e 2e 0a 00          	cs or  %cs:(%eax),%al
    8fe4:	46                   	inc    %esi
    8fe5:	61                   	popa   
    8fe6:	69 6c 20 74 6f 20 6c 	imul   $0x6f6c206f,0x74(%eax,%eiz,1),%ebp
    8fed:	6f 
    8fee:	61                   	popa   
    8fef:	64 20 6b 65          	and    %ch,%fs:0x65(%ebx)
    8ff3:	72 6e                	jb     9063 <exec_kernel+0x147>
    8ff5:	65 6c                	gs insb (%dx),%es:(%edi)
    8ff7:	2e 00 43 61          	add    %al,%cs:0x61(%ebx)
    8ffb:	6e                   	outsb  %ds:(%esi),(%dx)
    8ffc:	6e                   	outsb  %ds:(%esi),(%dx)
    8ffd:	6f                   	outsl  %ds:(%esi),(%dx)
    8ffe:	74 20                	je     9020 <exec_kernel+0x104>
    9000:	66 69 6e 64 20 62    	imul   $0x6220,0x64(%esi),%bp
    9006:	6f                   	outsl  %ds:(%esi),(%dx)
    9007:	6f                   	outsl  %ds:(%esi),(%dx)
    9008:	74 61                	je     906b <exec_kernel+0x14f>
    900a:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
    900e:	70 61                	jo     9071 <exec_kernel+0x155>
    9010:	72 74                	jb     9086 <exec_kernel+0x16a>
    9012:	69                   	.byte 0x69
    9013:	74 69                	je     907e <exec_kernel+0x162>
    9015:	6f                   	outsl  %ds:(%esi),(%dx)
    9016:	6e                   	outsb  %ds:(%esi),(%dx)
    9017:	21 00                	and    %eax,(%eax)

Disassembly of section .eh_frame:

0000901c <.eh_frame>:
    901c:	14 00                	adc    $0x0,%al
    901e:	00 00                	add    %al,(%eax)
    9020:	00 00                	add    %al,(%eax)
    9022:	00 00                	add    %al,(%eax)
    9024:	01 7a 52             	add    %edi,0x52(%edx)
    9027:	00 01                	add    %al,(%ecx)
    9029:	7c 08                	jl     9033 <exec_kernel+0x117>
    902b:	01 1b                	add    %ebx,(%ebx)
    902d:	0c 04                	or     $0x4,%al
    902f:	04 88                	add    $0x88,%al
    9031:	01 00                	add    %eax,(%eax)
    9033:	00 1c 00             	add    %bl,(%eax,%eax,1)
    9036:	00 00                	add    %al,(%eax)
    9038:	1c 00                	sbb    $0x0,%al
    903a:	00 00                	add    %al,(%eax)
    903c:	ea fa ff ff 1b 00 00 	ljmp   $0x0,$0x1bfffffa
    9043:	00 00                	add    %al,(%eax)
    9045:	41                   	inc    %ecx
    9046:	0e                   	push   %cs
    9047:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    904d:	57                   	push   %edi
    904e:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9051:	04 00                	add    $0x0,%al
    9053:	00 24 00             	add    %ah,(%eax,%eax,1)
    9056:	00 00                	add    %al,(%eax)
    9058:	3c 00                	cmp    $0x0,%al
    905a:	00 00                	add    %al,(%eax)
    905c:	e5 fa                	in     $0xfa,%eax
    905e:	ff                   	(bad)  
    905f:	ff                   	(bad)  
    9060:	3a 00                	cmp    (%eax),%al
    9062:	00 00                	add    %al,(%eax)
    9064:	00 41 0e             	add    %al,0xe(%ecx)
    9067:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    906d:	44                   	inc    %esp
    906e:	86 03                	xchg   %al,(%ebx)
    9070:	45                   	inc    %ebp
    9071:	83 04 6b c3          	addl   $0xffffffc3,(%ebx,%ebp,2)
    9075:	41                   	inc    %ecx
    9076:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
    907a:	04 04                	add    $0x4,%al
    907c:	20 00                	and    %al,(%eax)
    907e:	00 00                	add    %al,(%eax)
    9080:	64 00 00             	add    %al,%fs:(%eax)
    9083:	00 f7                	add    %dh,%bh
    9085:	fa                   	cli    
    9086:	ff                   	(bad)  
    9087:	ff 40 00             	incl   0x0(%eax)
    908a:	00 00                	add    %al,(%eax)
    908c:	00 41 0e             	add    %al,0xe(%ecx)
    908f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9095:	42                   	inc    %edx
    9096:	83 03 7a             	addl   $0x7a,(%ebx)
    9099:	c5 c3 0c             	(bad)  
    909c:	04 04                	add    $0x4,%al
    909e:	00 00                	add    %al,(%eax)
    90a0:	1c 00                	sbb    $0x0,%al
    90a2:	00 00                	add    %al,(%eax)
    90a4:	88 00                	mov    %al,(%eax)
    90a6:	00 00                	add    %al,(%eax)
    90a8:	13 fb                	adc    %ebx,%edi
    90aa:	ff                   	(bad)  
    90ab:	ff 0d 00 00 00 00    	decl   0x0
    90b1:	41                   	inc    %ecx
    90b2:	0e                   	push   %cs
    90b3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    90b9:	44                   	inc    %esp
    90ba:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    90bd:	04 00                	add    $0x0,%al
    90bf:	00 18                	add    %bl,(%eax)
    90c1:	00 00                	add    %al,(%eax)
    90c3:	00 a8 00 00 00 00    	add    %ch,0x0(%eax)
    90c9:	fb                   	sti    
    90ca:	ff                   	(bad)  
    90cb:	ff 1a                	lcall  *(%edx)
    90cd:	00 00                	add    %al,(%eax)
    90cf:	00 00                	add    %al,(%eax)
    90d1:	41                   	inc    %ecx
    90d2:	0e                   	push   %cs
    90d3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    90d9:	00 00                	add    %al,(%eax)
    90db:	00 1c 00             	add    %bl,(%eax,%eax,1)
    90de:	00 00                	add    %al,(%eax)
    90e0:	c4 00                	les    (%eax),%eax
    90e2:	00 00                	add    %al,(%eax)
    90e4:	fe                   	(bad)  
    90e5:	fa                   	cli    
    90e6:	ff                   	(bad)  
    90e7:	ff 13                	call   *(%ebx)
    90e9:	00 00                	add    %al,(%eax)
    90eb:	00 00                	add    %al,(%eax)
    90ed:	41                   	inc    %ecx
    90ee:	0e                   	push   %cs
    90ef:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
    90f5:	4d                   	dec    %ebp
    90f6:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    90f9:	04 00                	add    $0x0,%al
    90fb:	00 24 00             	add    %ah,(%eax,%eax,1)
    90fe:	00 00                	add    %al,(%eax)
    9100:	e4 00                	in     $0x0,%al
    9102:	00 00                	add    %al,(%eax)
    9104:	f1                   	icebp  
    9105:	fa                   	cli    
    9106:	ff                   	(bad)  
    9107:	ff 35 00 00 00 00    	pushl  0x0
    910d:	41                   	inc    %ecx
    910e:	0e                   	push   %cs
    910f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9115:	42                   	inc    %edx
    9116:	86 03                	xchg   %al,(%ebx)
    9118:	83 04 6d c3 41 c6 41 	addl   $0xffffffc5,0x41c641c3(,%ebp,2)
    911f:	c5 
    9120:	0c 04                	or     $0x4,%al
    9122:	04 00                	add    $0x0,%al
    9124:	28 00                	sub    %al,(%eax)
    9126:	00 00                	add    %al,(%eax)
    9128:	0c 01                	or     $0x1,%al
    912a:	00 00                	add    %al,(%eax)
    912c:	fe                   	(bad)  
    912d:	fa                   	cli    
    912e:	ff                   	(bad)  
    912f:	ff 5b 00             	lcall  *0x0(%ebx)
    9132:	00 00                	add    %al,(%eax)
    9134:	00 41 0e             	add    %al,0xe(%ecx)
    9137:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
    913d:	46                   	inc    %esi
    913e:	87 03                	xchg   %eax,(%ebx)
    9140:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    9143:	05 02 48 c3 41       	add    $0x41c34802,%eax
    9148:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
    914c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    914f:	04 1c                	add    $0x1c,%al
    9151:	00 00                	add    %al,(%eax)
    9153:	00 38                	add    %bh,(%eax)
    9155:	01 00                	add    %eax,(%eax)
    9157:	00 2d fb ff ff 1d    	add    %ch,0x1dfffffb
    915d:	00 00                	add    %al,(%eax)
    915f:	00 00                	add    %al,(%eax)
    9161:	41                   	inc    %ecx
    9162:	0e                   	push   %cs
    9163:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9169:	59                   	pop    %ecx
    916a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    916d:	04 00                	add    $0x0,%al
    916f:	00 1c 00             	add    %bl,(%eax,%eax,1)
    9172:	00 00                	add    %al,(%eax)
    9174:	58                   	pop    %eax
    9175:	01 00                	add    %eax,(%eax)
    9177:	00 2a                	add    %ch,(%edx)
    9179:	fb                   	sti    
    917a:	ff                   	(bad)  
    917b:	ff 1d 00 00 00 00    	lcall  *0x0
    9181:	41                   	inc    %ecx
    9182:	0e                   	push   %cs
    9183:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9189:	59                   	pop    %ecx
    918a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    918d:	04 00                	add    $0x0,%al
    918f:	00 1c 00             	add    %bl,(%eax,%eax,1)
    9192:	00 00                	add    %al,(%eax)
    9194:	78 01                	js     9197 <exec_kernel+0x27b>
    9196:	00 00                	add    %al,(%eax)
    9198:	27                   	daa    
    9199:	fb                   	sti    
    919a:	ff                   	(bad)  
    919b:	ff 23                	jmp    *(%ebx)
    919d:	00 00                	add    %al,(%eax)
    919f:	00 00                	add    %al,(%eax)
    91a1:	41                   	inc    %ecx
    91a2:	0e                   	push   %cs
    91a3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    91a9:	5b                   	pop    %ebx
    91aa:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    91ad:	04 00                	add    $0x0,%al
    91af:	00 20                	add    %ah,(%eax)
    91b1:	00 00                	add    %al,(%eax)
    91b3:	00 98 01 00 00 2a    	add    %bl,0x2a000001(%eax)
    91b9:	fb                   	sti    
    91ba:	ff                   	(bad)  
    91bb:	ff 6f 00             	ljmp   *0x0(%edi)
    91be:	00 00                	add    %al,(%eax)
    91c0:	00 41 0e             	add    %al,0xe(%ecx)
    91c3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    91c9:	41                   	inc    %ecx
    91ca:	87 03                	xchg   %eax,(%ebx)
    91cc:	02 69 c7             	add    -0x39(%ecx),%ch
    91cf:	41                   	inc    %ecx
    91d0:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    91d3:	04 28                	add    $0x28,%al
    91d5:	00 00                	add    %al,(%eax)
    91d7:	00 bc 01 00 00 75 fb 	add    %bh,-0x48b0000(%ecx,%eax,1)
    91de:	ff                   	(bad)  
    91df:	ff 47 00             	incl   0x0(%edi)
    91e2:	00 00                	add    %al,(%eax)
    91e4:	00 41 0e             	add    %al,0xe(%ecx)
    91e7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    91ed:	46                   	inc    %esi
    91ee:	87 03                	xchg   %eax,(%ebx)
    91f0:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    91f3:	05 7a c3 41 c6       	add    $0xc641c37a,%eax
    91f8:	41                   	inc    %ecx
    91f9:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
    9200:	28 00                	sub    %al,(%eax)
    9202:	00 00                	add    %al,(%eax)
    9204:	e8 01 00 00 90       	call   9000920a <SMAP_SIG+0x3cb350ba>
    9209:	fb                   	sti    
    920a:	ff                   	(bad)  
    920b:	ff 81 00 00 00 00    	incl   0x0(%ecx)
    9211:	41                   	inc    %ecx
    9212:	0e                   	push   %cs
    9213:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9219:	46                   	inc    %esi
    921a:	87 03                	xchg   %eax,(%ebx)
    921c:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    921f:	05 02 6f c3 41       	add    $0x41c36f02,%eax
    9224:	c6 46 c7 41          	movb   $0x41,-0x39(%esi)
    9228:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    922b:	04 24                	add    $0x24,%al
    922d:	00 00                	add    %al,(%eax)
    922f:	00 14 02             	add    %dl,(%edx,%eax,1)
    9232:	00 00                	add    %al,(%eax)
    9234:	e5 fb                	in     $0xfb,%eax
    9236:	ff                   	(bad)  
    9237:	ff 60 00             	jmp    *0x0(%eax)
    923a:	00 00                	add    %al,(%eax)
    923c:	00 41 0e             	add    %al,0xe(%ecx)
    923f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9245:	42                   	inc    %edx
    9246:	86 03                	xchg   %al,(%ebx)
    9248:	83 04 02 58          	addl   $0x58,(%edx,%eax,1)
    924c:	c3                   	ret    
    924d:	41                   	inc    %ecx
    924e:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
    9252:	04 04                	add    $0x4,%al
    9254:	24 00                	and    $0x0,%al
    9256:	00 00                	add    %al,(%eax)
    9258:	3c 02                	cmp    $0x2,%al
    925a:	00 00                	add    %al,(%eax)
    925c:	1d fc ff ff a3       	sbb    $0xa3fffffc,%eax
    9261:	00 00                	add    %al,(%eax)
    9263:	00 00                	add    %al,(%eax)
    9265:	41                   	inc    %ecx
    9266:	0e                   	push   %cs
    9267:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    926d:	42                   	inc    %edx
    926e:	86 03                	xchg   %al,(%ebx)
    9270:	83 04 02 97          	addl   $0xffffff97,(%edx,%eax,1)
    9274:	c3                   	ret    
    9275:	41                   	inc    %ecx
    9276:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
    927a:	04 04                	add    $0x4,%al

Disassembly of section .data:

00009280 <hex.1184>:
    9280:	30 31                	xor    %dh,(%ecx)
    9282:	32 33                	xor    (%ebx),%dh
    9284:	34 35                	xor    $0x35,%al
    9286:	36 37                	ss aaa 
    9288:	38 39                	cmp    %bh,(%ecx)
    928a:	61                   	popa   
    928b:	62 63 64             	bound  %esp,0x64(%ebx)
    928e:	65 66 00 00          	data16 add %al,%gs:(%eax)
    9292:	00 00                	add    %al,(%eax)

00009294 <dec.1179>:
    9294:	30 31                	xor    %dh,(%ecx)
    9296:	32 33                	xor    (%ebx),%dh
    9298:	34 35                	xor    $0x35,%al
    929a:	36 37                	ss aaa 
    929c:	38 39                	cmp    %bh,(%ecx)
    929e:	00 00                	add    %al,(%eax)

000092a0 <blank>:
char *blank =
    92a0:	2c 8f                	sub    $0x8f,%al
    92a2:	00 00                	add    %al,(%eax)

000092a4 <video>:
volatile char *video = (volatile char *) 0xB8000;
    92a4:	00 80 0b 00 00 00    	add    %al,0xb(%eax)
    92aa:	00 00                	add    %al,(%eax)
    92ac:	00 00                	add    %al,(%eax)
    92ae:	00 00                	add    %al,(%eax)
    92b0:	00 00                	add    %al,(%eax)
    92b2:	00 00                	add    %al,(%eax)
    92b4:	00 00                	add    %al,(%eax)
    92b6:	00 00                	add    %al,(%eax)
    92b8:	00 00                	add    %al,(%eax)
    92ba:	00 00                	add    %al,(%eax)
    92bc:	00 00                	add    %al,(%eax)
    92be:	00 00                	add    %al,(%eax)

000092c0 <mboot_info>:
mboot_info_t mboot_info = {.flags = (1 << 6), };
    92c0:	40                   	inc    %eax
    92c1:	00 00                	add    %al,(%eax)
    92c3:	00 00                	add    %al,(%eax)
    92c5:	00 00                	add    %al,(%eax)
    92c7:	00 00                	add    %al,(%eax)
    92c9:	00 00                	add    %al,(%eax)
    92cb:	00 00                	add    %al,(%eax)
    92cd:	00 00                	add    %al,(%eax)
    92cf:	00 00                	add    %al,(%eax)
    92d1:	00 00                	add    %al,(%eax)
    92d3:	00 00                	add    %al,(%eax)
    92d5:	00 00                	add    %al,(%eax)
    92d7:	00 00                	add    %al,(%eax)
    92d9:	00 00                	add    %al,(%eax)
    92db:	00 00                	add    %al,(%eax)
    92dd:	00 00                	add    %al,(%eax)
    92df:	00 00                	add    %al,(%eax)
    92e1:	00 00                	add    %al,(%eax)
    92e3:	00 00                	add    %al,(%eax)
    92e5:	00 00                	add    %al,(%eax)
    92e7:	00 00                	add    %al,(%eax)
    92e9:	00 00                	add    %al,(%eax)
    92eb:	00 00                	add    %al,(%eax)
    92ed:	00 00                	add    %al,(%eax)
    92ef:	00 00                	add    %al,(%eax)
    92f1:	00 00                	add    %al,(%eax)
    92f3:	00 00                	add    %al,(%eax)
    92f5:	00 00                	add    %al,(%eax)
    92f7:	00 00                	add    %al,(%eax)
    92f9:	00 00                	add    %al,(%eax)
    92fb:	00 00                	add    %al,(%eax)
    92fd:	00 00                	add    %al,(%eax)
    92ff:	00 00                	add    %al,(%eax)
    9301:	00 00                	add    %al,(%eax)
    9303:	00 00                	add    %al,(%eax)
    9305:	00 00                	add    %al,(%eax)
    9307:	00 00                	add    %al,(%eax)
    9309:	00 00                	add    %al,(%eax)
    930b:	00 00                	add    %al,(%eax)
    930d:	00 00                	add    %al,(%eax)
    930f:	00 00                	add    %al,(%eax)
    9311:	00 00                	add    %al,(%eax)
    9313:	00 00                	add    %al,(%eax)
    9315:	00 00                	add    %al,(%eax)
    9317:	00 00                	add    %al,(%eax)
    9319:	00 00                	add    %al,(%eax)
    931b:	00 00                	add    %al,(%eax)
    931d:	00 00                	add    %al,(%eax)
    931f:	00                   	.byte 0x0

Disassembly of section .bss:

00009320 <__bss_start>:
    9320:	00 00                	add    %al,(%eax)
    9322:	00 00                	add    %al,(%eax)
    9324:	00 00                	add    %al,(%eax)
    9326:	00 00                	add    %al,(%eax)
    9328:	00 00                	add    %al,(%eax)
    932a:	00 00                	add    %al,(%eax)
    932c:	00 00                	add    %al,(%eax)
    932e:	00 00                	add    %al,(%eax)
    9330:	00 00                	add    %al,(%eax)
    9332:	00 00                	add    %al,(%eax)
    9334:	00 00                	add    %al,(%eax)
    9336:	00 00                	add    %al,(%eax)
    9338:	00 00                	add    %al,(%eax)
    933a:	00 00                	add    %al,(%eax)
    933c:	00 00                	add    %al,(%eax)
    933e:	00 00                	add    %al,(%eax)
    9340:	00 00                	add    %al,(%eax)
    9342:	00 00                	add    %al,(%eax)
    9344:	00 00                	add    %al,(%eax)
    9346:	00 00                	add    %al,(%eax)

00009348 <row>:
static int row = 0;
    9348:	00 00                	add    %al,(%eax)
    934a:	00 00                	add    %al,(%eax)

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 47 4e             	sub    %al,0x4e(%edi)
   8:	55                   	push   %ebp
   9:	29 20                	sub    %esp,(%eax)
   b:	39 2e                	cmp    %ebp,(%esi)
   d:	32 2e                	xor    (%esi),%ch
   f:	31 20                	xor    %esp,(%eax)
  11:	32 30                	xor    (%eax),%dh
  13:	31 39                	xor    %edi,(%ecx)
  15:	30 38                	xor    %bh,(%eax)
  17:	32 37                	xor    (%edi),%dh
  19:	20 28                	and    %ch,(%eax)
  1b:	52                   	push   %edx
  1c:	65 64 20 48 61       	gs and %cl,%fs:0x61(%eax)
  21:	74 20                	je     43 <PROT_MODE_DSEG+0x33>
  23:	39 2e                	cmp    %ebp,(%esi)
  25:	32 2e                	xor    (%esi),%ch
  27:	31                   	.byte 0x31
  28:	2d                   	.byte 0x2d
  29:	31 29                	xor    %ebp,(%ecx)
  2b:	00                   	.byte 0x0

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	1c 00                	sbb    $0x0,%al
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	04 00                	add    $0x0,%al
   c:	00 00                	add    %al,(%eax)
   e:	00 00                	add    %al,(%eax)
  10:	00 7e 00             	add    %bh,0x0(%esi)
  13:	00 26                	add    %ah,(%esi)
  15:	0d 00 00 00 00       	or     $0x0,%eax
  1a:	00 00                	add    %al,(%eax)
  1c:	00 00                	add    %al,(%eax)
  1e:	00 00                	add    %al,(%eax)
  20:	1c 00                	sbb    $0x0,%al
  22:	00 00                	add    %al,(%eax)
  24:	02 00                	add    (%eax),%al
  26:	26 00 00             	add    %al,%es:(%eax)
  29:	00 04 00             	add    %al,(%eax,%eax,1)
  2c:	00 00                	add    %al,(%eax)
  2e:	00 00                	add    %al,(%eax)
  30:	26 8b 00             	mov    %es:(%eax),%eax
  33:	00 72 02             	add    %dh,0x2(%edx)
  36:	00 00                	add    %al,(%eax)
  38:	00 00                	add    %al,(%eax)
  3a:	00 00                	add    %al,(%eax)
  3c:	00 00                	add    %al,(%eax)
  3e:	00 00                	add    %al,(%eax)
  40:	1c 00                	sbb    $0x0,%al
  42:	00 00                	add    %al,(%eax)
  44:	02 00                	add    (%eax),%al
  46:	bc 07 00 00 04       	mov    $0x4000007,%esp
  4b:	00 00                	add    %al,(%eax)
  4d:	00 00                	add    %al,(%eax)
  4f:	00 98 8d 00 00 84    	add    %bl,-0x7bffff73(%eax)
  55:	01 00                	add    %eax,(%eax)
  57:	00 00                	add    %al,(%eax)
  59:	00 00                	add    %al,(%eax)
  5b:	00 00                	add    %al,(%eax)
  5d:	00 00                	add    %al,(%eax)
  5f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  62:	00 00                	add    %al,(%eax)
  64:	02 00                	add    (%eax),%al
  66:	1c 0f                	sbb    $0xf,%al
  68:	00 00                	add    %al,(%eax)
  6a:	04 00                	add    $0x0,%al
  6c:	00 00                	add    %al,(%eax)
  6e:	00 00                	add    %al,(%eax)
  70:	1c 8f                	sbb    $0x8f,%al
  72:	00 00                	add    %al,(%eax)
  74:	10 00                	adc    %al,(%eax)
  76:	00 00                	add    %al,(%eax)
  78:	00 00                	add    %al,(%eax)
  7a:	00 00                	add    %al,(%eax)
  7c:	00 00                	add    %al,(%eax)
  7e:	00 00                	add    %al,(%eax)

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	22 00                	and    (%eax),%al
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	04 01                	add    $0x1,%al
   c:	00 00                	add    %al,(%eax)
   e:	00 00                	add    %al,(%eax)
  10:	00 7e 00             	add    %bh,0x0(%esi)
  13:	00 26                	add    %ah,(%esi)
  15:	8b 00                	mov    (%eax),%eax
  17:	00 00                	add    %al,(%eax)
  19:	00 00                	add    %al,(%eax)
  1b:	00 13                	add    %dl,(%ebx)
  1d:	00 00                	add    %al,(%eax)
  1f:	00 36                	add    %dh,(%esi)
  21:	00 00                	add    %al,(%eax)
  23:	00 01                	add    %al,(%ecx)
  25:	80 92 07 00 00 04 00 	adcb   $0x0,0x4000007(%edx)
  2c:	14 00                	adc    $0x0,%al
  2e:	00 00                	add    %al,(%eax)
  30:	04 01                	add    $0x1,%al
  32:	ed                   	in     (%dx),%eax
  33:	00 00                	add    %al,(%eax)
  35:	00 0c 8e             	add    %cl,(%esi,%ecx,4)
  38:	00 00                	add    %al,(%eax)
  3a:	00 13                	add    %dl,(%ebx)
  3c:	00 00                	add    %al,(%eax)
  3e:	00 26                	add    %ah,(%esi)
  40:	8b 00                	mov    (%eax),%eax
  42:	00 72 02             	add    %dh,0x2(%edx)
  45:	00 00                	add    %al,(%eax)
  47:	80 00 00             	addb   $0x0,(%eax)
  4a:	00 02                	add    %al,(%edx)
  4c:	01 06                	add    %eax,(%esi)
  4e:	d7                   	xlat   %ds:(%ebx)
  4f:	00 00                	add    %al,(%eax)
  51:	00 03                	add    %al,(%ebx)
  53:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  54:	00 00                	add    %al,(%eax)
  56:	00 02                	add    %al,(%edx)
  58:	0d 1c 38 00 00       	or     $0x381c,%eax
  5d:	00 02                	add    %al,(%edx)
  5f:	01 08                	add    %ecx,(%eax)
  61:	d5 00                	aad    $0x0
  63:	00 00                	add    %al,(%eax)
  65:	02 02                	add    (%edx),%al
  67:	05 5c 00 00 00       	add    $0x5c,%eax
  6c:	02 02                	add    (%edx),%al
  6e:	07                   	pop    %es
  6f:	8d 01                	lea    (%ecx),%eax
  71:	00 00                	add    %al,(%eax)
  73:	03 7b 01             	add    0x1(%ebx),%edi
  76:	00 00                	add    %al,(%eax)
  78:	02 10                	add    (%eax),%dl
  7a:	1c 59                	sbb    $0x59,%al
  7c:	00 00                	add    %al,(%eax)
  7e:	00 04 04             	add    %al,(%esp,%eax,1)
  81:	05 69 6e 74 00       	add    $0x746e69,%eax
  86:	03 7a 01             	add    0x1(%edx),%edi
  89:	00 00                	add    %al,(%eax)
  8b:	02 11                	add    (%ecx),%dl
  8d:	1c 6c                	sbb    $0x6c,%al
  8f:	00 00                	add    %al,(%eax)
  91:	00 02                	add    %al,(%edx)
  93:	04 07                	add    $0x7,%al
  95:	6d                   	insl   (%dx),%es:(%edi)
  96:	01 00                	add    %eax,(%eax)
  98:	00 02                	add    %al,(%edx)
  9a:	08 05 b6 00 00 00    	or     %al,0xb6
  a0:	02 08                	add    (%eax),%cl
  a2:	07                   	pop    %es
  a3:	63 01                	arpl   %ax,(%ecx)
  a5:	00 00                	add    %al,(%eax)
  a7:	05 d2 01 00 00       	add    $0x1d2,%eax
  ac:	01 06                	add    %eax,(%esi)
  ae:	10 93 00 00 00 05    	adc    %dl,0x5000000(%ebx)
  b4:	03 a4 92 00 00 06 04 	add    0x4060000(%edx,%edx,4),%esp
  bb:	a0 00 00 00 02       	mov    0x2000000,%al
  c0:	01 06                	add    %eax,(%esi)
  c2:	de 00                	fiadds (%eax)
  c4:	00 00                	add    %al,(%eax)
  c6:	07                   	pop    %es
  c7:	99                   	cltd   
  c8:	00 00                	add    %al,(%eax)
  ca:	00 08                	add    %cl,(%eax)
  cc:	99                   	cltd   
  cd:	00 00                	add    %al,(%eax)
  cf:	00 09                	add    %cl,(%ecx)
  d1:	72 6f                	jb     142 <PR_BOOTABLE+0xc2>
  d3:	77 00                	ja     d5 <PR_BOOTABLE+0x55>
  d5:	01 18                	add    %ebx,(%eax)
  d7:	0c 59                	or     $0x59,%al
  d9:	00 00                	add    %al,(%eax)
  db:	00 05 03 48 93 00    	add    %al,0x934803
  e1:	00 05 c7 01 00 00    	add    %al,0x1c7
  e7:	01 1a                	add    %ebx,(%edx)
  e9:	07                   	pop    %es
  ea:	ce                   	into   
  eb:	00 00                	add    %al,(%eax)
  ed:	00 05 03 a0 92 00    	add    %al,0x92a003
  f3:	00 06                	add    %al,(%esi)
  f5:	04 99                	add    $0x99,%al
  f7:	00 00                	add    %al,(%eax)
  f9:	00 0a                	add    %cl,(%edx)
  fb:	99                   	cltd   
  fc:	00 00                	add    %al,(%eax)
  fe:	00 e4                	add    %ah,%ah
 100:	00 00                	add    %al,(%eax)
 102:	00 0b                	add    %cl,(%ebx)
 104:	6c                   	insb   (%dx),%es:(%edi)
 105:	00 00                	add    %al,(%eax)
 107:	00 27                	add    %ah,(%edi)
 109:	00 0c be             	add    %cl,(%esi,%edi,4)
 10c:	01 00                	add    %eax,(%eax)
 10e:	00 01                	add    %al,(%ecx)
 110:	30 0d d4 00 00 00    	xor    %cl,0xd4
 116:	05 03 20 93 00       	add    $0x932003,%eax
 11b:	00 0d c4 00 00 00    	add    %cl,0xc4
 121:	01 8d 06 51 8d 00    	add    %ecx,0x8d5106(%ebp)
 127:	00 47 00             	add    %al,0x0(%edi)
 12a:	00 00                	add    %al,(%eax)
 12c:	01 9c 6f 01 00 00 0e 	add    %ebx,0xe000001(%edi,%ebp,2)
 133:	76 61                	jbe    196 <PR_BOOTABLE+0x116>
 135:	00 01                	add    %al,(%ecx)
 137:	8d 1b                	lea    (%ebx),%ebx
 139:	60                   	pusha  
 13a:	00 00                	add    %al,(%eax)
 13c:	00 12                	add    %dl,(%edx)
 13e:	00 00                	add    %al,(%eax)
 140:	00 00                	add    %al,(%eax)
 142:	00 00                	add    %al,(%eax)
 144:	00 0f                	add    %cl,(%edi)
 146:	91                   	xchg   %eax,%ecx
 147:	04 00                	add    $0x0,%al
 149:	00 01                	add    %al,(%ecx)
 14b:	8d 28                	lea    (%eax),%ebp
 14d:	60                   	pusha  
 14e:	00 00                	add    %al,(%eax)
 150:	00 02                	add    %al,(%edx)
 152:	91                   	xchg   %eax,%ecx
 153:	04 10                	add    $0x10,%al
 155:	35 02 00 00 01       	xor    $0x1000002,%eax
 15a:	8d 38                	lea    (%eax),%edi
 15c:	60                   	pusha  
 15d:	00 00                	add    %al,(%eax)
 15f:	00 a7 00 00 00 9b    	add    %ah,-0x65000000(%edi)
 165:	00 00                	add    %al,(%eax)
 167:	00 11                	add    %dl,(%ecx)
 169:	6c                   	insb   (%dx),%es:(%edi)
 16a:	62 61 00             	bound  %esp,0x0(%ecx)
 16d:	01 8d 49 60 00 00    	add    %ecx,0x6049(%ebp)
 173:	00 02                	add    %al,(%edx)
 175:	91                   	xchg   %eax,%ecx
 176:	0c 12                	or     $0x12,%al
 178:	44                   	inc    %esp
 179:	00 00                	add    %al,(%eax)
 17b:	00 01                	add    %al,(%ecx)
 17d:	8f                   	(bad)  
 17e:	0e                   	push   %cs
 17f:	60                   	pusha  
 180:	00 00                	add    %al,(%eax)
 182:	00 fa                	add    %bh,%dl
 184:	00 00                	add    %al,(%eax)
 186:	00 f6                	add    %dh,%dh
 188:	00 00                	add    %al,(%eax)
 18a:	00 13                	add    %dl,(%ebx)
 18c:	8b 8d 00 00 6f 01    	mov    0x16f0000(%ebp),%ecx
 192:	00 00                	add    %al,(%eax)
 194:	00 0d 83 00 00 00    	add    %cl,0x83
 19a:	01 78 06             	add    %edi,0x6(%eax)
 19d:	e2 8c                	loop   12b <PR_BOOTABLE+0xab>
 19f:	00 00                	add    %al,(%eax)
 1a1:	6f                   	outsl  %ds:(%esi),(%dx)
 1a2:	00 00                	add    %al,(%eax)
 1a4:	00 01                	add    %al,(%ecx)
 1a6:	9c                   	pushf  
 1a7:	a1 03 00 00 11       	mov    0x11000003,%eax
 1ac:	64 73 74             	fs jae 223 <PR_BOOTABLE+0x1a3>
 1af:	00 01                	add    %al,(%ecx)
 1b1:	78 17                	js     1ca <PR_BOOTABLE+0x14a>
 1b3:	a1 03 00 00 02       	mov    0x2000003,%eax
 1b8:	91                   	xchg   %eax,%ecx
 1b9:	00 0f                	add    %cl,(%edi)
 1bb:	35 02 00 00 01       	xor    $0x1000002,%eax
 1c0:	78 25                	js     1e7 <PR_BOOTABLE+0x167>
 1c2:	60                   	pusha  
 1c3:	00 00                	add    %al,(%eax)
 1c5:	00 02                	add    %al,(%edx)
 1c7:	91                   	xchg   %eax,%ecx
 1c8:	04 14                	add    $0x14,%al
 1ca:	a3 03 00 00 e2       	mov    %eax,0xe2000003
 1cf:	8c 00                	mov    %es,(%eax)
 1d1:	00 02                	add    %al,(%edx)
 1d3:	00 00                	add    %al,(%eax)
 1d5:	00 00                	add    %al,(%eax)
 1d7:	01 7b 05             	add    %edi,0x5(%ebx)
 1da:	eb 01                	jmp    1dd <PR_BOOTABLE+0x15d>
 1dc:	00 00                	add    %al,(%eax)
 1de:	15 49 07 00 00       	adc    $0x749,%eax
 1e3:	ee                   	out    %al,(%dx)
 1e4:	8c 00                	mov    %es,(%eax)
 1e6:	00 02                	add    %al,(%edx)
 1e8:	20 00                	and    %al,(%eax)
 1ea:	00 00                	add    %al,(%eax)
 1ec:	01 74 0d 16          	add    %esi,0x16(%ebp,%ecx,1)
 1f0:	5a                   	pop    %edx
 1f1:	07                   	pop    %es
 1f2:	00 00                	add    %al,(%eax)
 1f4:	27                   	daa    
 1f5:	01 00                	add    %eax,(%eax)
 1f7:	00 25 01 00 00 17    	add    %ah,0x17000001
 1fd:	20 00                	and    %al,(%eax)
 1ff:	00 00                	add    %al,(%eax)
 201:	18 66 07             	sbb    %ah,0x7(%esi)
 204:	00 00                	add    %al,(%eax)
 206:	3f                   	aas    
 207:	01 00                	add    %eax,(%eax)
 209:	00 3d 01 00 00 00    	add    %bh,0x1
 20f:	00 00                	add    %al,(%eax)
 211:	19 73 07             	sbb    %esi,0x7(%ebx)
 214:	00 00                	add    %al,(%eax)
 216:	f8                   	clc    
 217:	8c 00                	mov    %es,(%eax)
 219:	00 04 f8             	add    %al,(%eax,%edi,8)
 21c:	8c 00                	mov    %es,(%eax)
 21e:	00 08                	add    %cl,(%eax)
 220:	00 00                	add    %al,(%eax)
 222:	00 01                	add    %al,(%ecx)
 224:	7d 05                	jge    22b <PR_BOOTABLE+0x1ab>
 226:	1f                   	pop    %ds
 227:	02 00                	add    (%eax),%al
 229:	00 16                	add    %dl,(%esi)
 22b:	88 07                	mov    %al,(%edi)
 22d:	00 00                	add    %al,(%eax)
 22f:	54                   	push   %esp
 230:	01 00                	add    %eax,(%eax)
 232:	00 52 01             	add    %dl,0x1(%edx)
 235:	00 00                	add    %al,(%eax)
 237:	16                   	push   %ss
 238:	7c 07                	jl     241 <PR_BOOTABLE+0x1c1>
 23a:	00 00                	add    %al,(%eax)
 23c:	6a 01                	push   $0x1
 23e:	00 00                	add    %al,(%eax)
 240:	68 01 00 00 00       	push   $0x1
 245:	19 73 07             	sbb    %esi,0x7(%ebx)
 248:	00 00                	add    %al,(%eax)
 24a:	00 8d 00 00 02 00    	add    %cl,0x20000(%ebp)
 250:	8d 00                	lea    (%eax),%eax
 252:	00 08                	add    %cl,(%eax)
 254:	00 00                	add    %al,(%eax)
 256:	00 01                	add    %al,(%ecx)
 258:	7e 05                	jle    25f <PR_BOOTABLE+0x1df>
 25a:	53                   	push   %ebx
 25b:	02 00                	add    (%eax),%al
 25d:	00 16                	add    %dl,(%esi)
 25f:	88 07                	mov    %al,(%edi)
 261:	00 00                	add    %al,(%eax)
 263:	82 01 00             	addb   $0x0,(%ecx)
 266:	00 80 01 00 00 16    	add    %al,0x16000001(%eax)
 26c:	7c 07                	jl     275 <PR_BOOTABLE+0x1f5>
 26e:	00 00                	add    %al,(%eax)
 270:	97                   	xchg   %eax,%edi
 271:	01 00                	add    %eax,(%eax)
 273:	00 95 01 00 00 00    	add    %dl,0x1(%ebp)
 279:	14 73                	adc    $0x73,%al
 27b:	07                   	pop    %es
 27c:	00 00                	add    %al,(%eax)
 27e:	08 8d 00 00 02 38    	or     %cl,0x38020000(%ebp)
 284:	00 00                	add    %al,(%eax)
 286:	00 01                	add    %al,(%ecx)
 288:	7f 05                	jg     28f <PR_BOOTABLE+0x20f>
 28a:	83 02 00             	addl   $0x0,(%edx)
 28d:	00 16                	add    %dl,(%esi)
 28f:	88 07                	mov    %al,(%edi)
 291:	00 00                	add    %al,(%eax)
 293:	af                   	scas   %es:(%edi),%eax
 294:	01 00                	add    %eax,(%eax)
 296:	00 ad 01 00 00 16    	add    %ch,0x16000001(%ebp)
 29c:	7c 07                	jl     2a5 <PR_BOOTABLE+0x225>
 29e:	00 00                	add    %al,(%eax)
 2a0:	c5 01                	lds    (%ecx),%eax
 2a2:	00 00                	add    %al,(%eax)
 2a4:	c3                   	ret    
 2a5:	01 00                	add    %eax,(%eax)
 2a7:	00 00                	add    %al,(%eax)
 2a9:	14 73                	adc    $0x73,%al
 2ab:	07                   	pop    %es
 2ac:	00 00                	add    %al,(%eax)
 2ae:	13 8d 00 00 02 58    	adc    0x58020000(%ebp),%ecx
 2b4:	00 00                	add    %al,(%eax)
 2b6:	00 01                	add    %al,(%ecx)
 2b8:	80 05 b3 02 00 00 16 	addb   $0x16,0x2b3
 2bf:	88 07                	mov    %al,(%edi)
 2c1:	00 00                	add    %al,(%eax)
 2c3:	dd 01                	fldl   (%ecx)
 2c5:	00 00                	add    %al,(%eax)
 2c7:	db 01                	fildl  (%ecx)
 2c9:	00 00                	add    %al,(%eax)
 2cb:	16                   	push   %ss
 2cc:	7c 07                	jl     2d5 <PR_BOOTABLE+0x255>
 2ce:	00 00                	add    %al,(%eax)
 2d0:	f3 01 00             	repz add %eax,(%eax)
 2d3:	00 f1                	add    %dh,%cl
 2d5:	01 00                	add    %eax,(%eax)
 2d7:	00 00                	add    %al,(%eax)
 2d9:	14 73                	adc    $0x73,%al
 2db:	07                   	pop    %es
 2dc:	00 00                	add    %al,(%eax)
 2de:	1e                   	push   %ds
 2df:	8d 00                	lea    (%eax),%eax
 2e1:	00 02                	add    %al,(%edx)
 2e3:	78 00                	js     2e5 <PR_BOOTABLE+0x265>
 2e5:	00 00                	add    %al,(%eax)
 2e7:	01 81 05 e3 02 00    	add    %eax,0x2e305(%ecx)
 2ed:	00 16                	add    %dl,(%esi)
 2ef:	88 07                	mov    %al,(%edi)
 2f1:	00 00                	add    %al,(%eax)
 2f3:	0b 02                	or     (%edx),%eax
 2f5:	00 00                	add    %al,(%eax)
 2f7:	09 02                	or     %eax,(%edx)
 2f9:	00 00                	add    %al,(%eax)
 2fb:	16                   	push   %ss
 2fc:	7c 07                	jl     305 <PR_BOOTABLE+0x285>
 2fe:	00 00                	add    %al,(%eax)
 300:	27                   	daa    
 301:	02 00                	add    (%eax),%al
 303:	00 25 02 00 00 00    	add    %ah,0x2
 309:	19 73 07             	sbb    %esi,0x7(%ebx)
 30c:	00 00                	add    %al,(%eax)
 30e:	2c 8d                	sub    $0x8d,%al
 310:	00 00                	add    %al,(%eax)
 312:	02 2c 8d 00 00 05 00 	add    0x50000(,%ecx,4),%ch
 319:	00 00                	add    %al,(%eax)
 31b:	01 82 05 17 03 00    	add    %eax,0x31705(%edx)
 321:	00 16                	add    %dl,(%esi)
 323:	88 07                	mov    %al,(%edi)
 325:	00 00                	add    %al,(%eax)
 327:	3f                   	aas    
 328:	02 00                	add    (%eax),%al
 32a:	00 3d 02 00 00 16    	add    %bh,0x16000002
 330:	7c 07                	jl     339 <PR_BOOTABLE+0x2b9>
 332:	00 00                	add    %al,(%eax)
 334:	56                   	push   %esi
 335:	02 00                	add    (%eax),%al
 337:	00 54 02 00          	add    %dl,0x0(%edx,%eax,1)
 33b:	00 00                	add    %al,(%eax)
 33d:	19 a3 03 00 00 31    	sbb    %esp,0x31000003(%ebx)
 343:	8d 00                	lea    (%eax),%eax
 345:	00 02                	add    %al,(%edx)
 347:	31 8d 00 00 0d 00    	xor    %ecx,0xd0000(%ebp)
 34d:	00 00                	add    %al,(%eax)
 34f:	01 85 05 63 03 00    	add    %eax,0x36305(%ebp)
 355:	00 15 49 07 00 00    	add    %dl,0x749
 35b:	36 8d 00             	lea    %ss:(%eax),%eax
 35e:	00 02                	add    %al,(%edx)
 360:	98                   	cwtl   
 361:	00 00                	add    %al,(%eax)
 363:	00 01                	add    %al,(%ecx)
 365:	74 0d                	je     374 <PR_BOOTABLE+0x2f4>
 367:	16                   	push   %ss
 368:	5a                   	pop    %edx
 369:	07                   	pop    %es
 36a:	00 00                	add    %al,(%eax)
 36c:	6e                   	outsb  %ds:(%esi),(%dx)
 36d:	02 00                	add    (%eax),%al
 36f:	00 6c 02 00          	add    %ch,0x0(%edx,%eax,1)
 373:	00 17                	add    %dl,(%edi)
 375:	98                   	cwtl   
 376:	00 00                	add    %al,(%eax)
 378:	00 18                	add    %bl,(%eax)
 37a:	66 07                	popw   %es
 37c:	00 00                	add    %al,(%eax)
 37e:	86 02                	xchg   %al,(%edx)
 380:	00 00                	add    %al,(%eax)
 382:	84 02                	test   %al,(%edx)
 384:	00 00                	add    %al,(%eax)
 386:	00 00                	add    %al,(%eax)
 388:	00 1a                	add    %bl,(%edx)
 38a:	17                   	pop    %ss
 38b:	07                   	pop    %es
 38c:	00 00                	add    %al,(%eax)
 38e:	3e 8d 00             	lea    %ds:(%eax),%eax
 391:	00 04 3e             	add    %al,(%esi,%edi,1)
 394:	8d 00                	lea    (%eax),%eax
 396:	00 10                	add    %dl,(%eax)
 398:	00 00                	add    %al,(%eax)
 39a:	00 01                	add    %al,(%ecx)
 39c:	88 05 16 3c 07 00    	mov    %al,0x73c16
 3a2:	00 9b 02 00 00 99    	add    %bl,-0x66fffffe(%ebx)
 3a8:	02 00                	add    (%eax),%al
 3aa:	00 16                	add    %dl,(%esi)
 3ac:	30 07                	xor    %al,(%edi)
 3ae:	00 00                	add    %al,(%eax)
 3b0:	b2 02                	mov    $0x2,%dl
 3b2:	00 00                	add    %al,(%eax)
 3b4:	b0 02                	mov    $0x2,%al
 3b6:	00 00                	add    %al,(%eax)
 3b8:	16                   	push   %ss
 3b9:	24 07                	and    $0x7,%al
 3bb:	00 00                	add    %al,(%eax)
 3bd:	c8 02 00 00          	enter  $0x2,$0x0
 3c1:	c6 02 00             	movb   $0x0,(%edx)
 3c4:	00 00                	add    %al,(%eax)
 3c6:	00 1b                	add    %bl,(%ebx)
 3c8:	04 1c                	add    $0x1c,%al
 3ca:	4b                   	dec    %ebx
 3cb:	00 00                	add    %al,(%eax)
 3cd:	00 01                	add    %al,(%ecx)
 3cf:	71 0d                	jno    3de <PR_BOOTABLE+0x35e>
 3d1:	01 0d e3 00 00 00    	add    %ecx,0xe3
 3d7:	01 68 06             	add    %ebp,0x6(%eax)
 3da:	a2 8c 00 00 1d       	mov    %al,0x1d00008c
 3df:	00 00                	add    %al,(%eax)
 3e1:	00 01                	add    %al,(%ecx)
 3e3:	9c                   	pushf  
 3e4:	f8                   	clc    
 3e5:	03 00                	add    (%eax),%eax
 3e7:	00 11                	add    %dl,(%ecx)
 3e9:	6e                   	outsb  %ds:(%esi),(%dx)
 3ea:	00 01                	add    %al,(%ecx)
 3ec:	68 0f 59 00 00       	push   $0x590f
 3f1:	00 02                	add    %al,(%edx)
 3f3:	91                   	xchg   %eax,%ecx
 3f4:	00 11                	add    %dl,(%ecx)
 3f6:	73 00                	jae    3f8 <PR_BOOTABLE+0x378>
 3f8:	01 68 18             	add    %ebp,0x18(%eax)
 3fb:	ce                   	into   
 3fc:	00 00                	add    %al,(%eax)
 3fe:	00 02                	add    %al,(%edx)
 400:	91                   	xchg   %eax,%ecx
 401:	04 09                	add    $0x9,%al
 403:	68 65 78 00 01       	push   $0x1007865
 408:	6a 11                	push   $0x11
 40a:	f8                   	clc    
 40b:	03 00                	add    (%eax),%eax
 40d:	00 05 03 80 92 00    	add    %al,0x928003
 413:	00 13                	add    %dl,(%ebx)
 415:	ba 8c 00 00 64       	mov    $0x6400008c,%edx
 41a:	04 00                	add    $0x0,%al
 41c:	00 00                	add    %al,(%eax)
 41e:	0a 99 00 00 00 08    	or     0x8000000(%ecx),%bl
 424:	04 00                	add    $0x0,%al
 426:	00 0b                	add    %cl,(%ebx)
 428:	6c                   	insb   (%dx),%es:(%edi)
 429:	00 00                	add    %al,(%eax)
 42b:	00 10                	add    %dl,(%eax)
 42d:	00 0d d0 00 00 00    	add    %cl,0xd0
 433:	01 62 06             	add    %esp,0x6(%edx)
 436:	85 8c 00 00 1d 00 00 	test   %ecx,0x1d00(%eax,%eax,1)
 43d:	00 01                	add    %al,(%ecx)
 43f:	9c                   	pushf  
 440:	54                   	push   %esp
 441:	04 00                	add    $0x0,%al
 443:	00 11                	add    %dl,(%ecx)
 445:	6e                   	outsb  %ds:(%esi),(%dx)
 446:	00 01                	add    %al,(%ecx)
 448:	62 0f                	bound  %ecx,(%edi)
 44a:	59                   	pop    %ecx
 44b:	00 00                	add    %al,(%eax)
 44d:	00 02                	add    %al,(%edx)
 44f:	91                   	xchg   %eax,%ecx
 450:	00 11                	add    %dl,(%ecx)
 452:	73 00                	jae    454 <PR_BOOTABLE+0x3d4>
 454:	01 62 17             	add    %esp,0x17(%edx)
 457:	ce                   	into   
 458:	00 00                	add    %al,(%eax)
 45a:	00 02                	add    %al,(%edx)
 45c:	91                   	xchg   %eax,%ecx
 45d:	04 09                	add    $0x9,%al
 45f:	64 65 63 00          	fs arpl %ax,%gs:(%eax)
 463:	01 64 11 54          	add    %esp,0x54(%ecx,%edx,1)
 467:	04 00                	add    $0x0,%al
 469:	00 05 03 94 92 00    	add    %al,0x929403
 46f:	00 13                	add    %dl,(%ebx)
 471:	9d                   	popf   
 472:	8c 00                	mov    %es,(%eax)
 474:	00 64 04 00          	add    %ah,0x0(%esp,%eax,1)
 478:	00 00                	add    %al,(%eax)
 47a:	0a 99 00 00 00 64    	or     0x64000000(%ecx),%bl
 480:	04 00                	add    $0x0,%al
 482:	00 0b                	add    %cl,(%ebx)
 484:	6c                   	insb   (%dx),%es:(%edi)
 485:	00 00                	add    %al,(%eax)
 487:	00 0a                	add    %cl,(%edx)
 489:	00 0d 83 01 00 00    	add    %cl,0x183
 48f:	01 52 06             	add    %edx,0x6(%edx)
 492:	2a 8c 00 00 5b 00 00 	sub    0x5b00(%eax,%eax,1),%cl
 499:	00 01                	add    %al,(%ecx)
 49b:	9c                   	pushf  
 49c:	e7 04                	out    %eax,$0x4
 49e:	00 00                	add    %al,(%eax)
 4a0:	0e                   	push   %cs
 4a1:	6e                   	outsb  %ds:(%esi),(%dx)
 4a2:	00 01                	add    %al,(%ecx)
 4a4:	52                   	push   %edx
 4a5:	0f 59 00             	mulps  (%eax),%xmm0
 4a8:	00 00                	add    %al,(%eax)
 4aa:	e2 02                	loop   4ae <PR_BOOTABLE+0x42e>
 4ac:	00 00                	add    %al,(%eax)
 4ae:	de 02                	fiadds (%edx)
 4b0:	00 00                	add    %al,(%eax)
 4b2:	11 73 00             	adc    %esi,0x0(%ebx)
 4b5:	01 52 17             	add    %edx,0x17(%edx)
 4b8:	ce                   	into   
 4b9:	00 00                	add    %al,(%eax)
 4bb:	00 02                	add    %al,(%edx)
 4bd:	91                   	xchg   %eax,%ecx
 4be:	04 0f                	add    $0xf,%al
 4c0:	cd 01                	int    $0x1
 4c2:	00 00                	add    %al,(%eax)
 4c4:	01 52 20             	add    %edx,0x20(%edx)
 4c7:	59                   	pop    %ecx
 4c8:	00 00                	add    %al,(%eax)
 4ca:	00 02                	add    %al,(%edx)
 4cc:	91                   	xchg   %eax,%ecx
 4cd:	08 0f                	or     %cl,(%edi)
 4cf:	ce                   	into   
 4d0:	03 00                	add    (%eax),%eax
 4d2:	00 01                	add    %al,(%ecx)
 4d4:	52                   	push   %edx
 4d5:	2c ce                	sub    $0xce,%al
 4d7:	00 00                	add    %al,(%eax)
 4d9:	00 02                	add    %al,(%edx)
 4db:	91                   	xchg   %eax,%ecx
 4dc:	0c 1d                	or     $0x1d,%al
 4de:	69 00 01 54 09 59    	imul   $0x59095401,(%eax),%eax
 4e4:	00 00                	add    %al,(%eax)
 4e6:	00 07                	add    %al,(%edi)
 4e8:	03 00                	add    (%eax),%eax
 4ea:	00 01                	add    %al,(%ecx)
 4ec:	03 00                	add    (%eax),%eax
 4ee:	00 12                	add    %dl,(%edx)
 4f0:	b1 01                	mov    $0x1,%cl
 4f2:	00 00                	add    %al,(%eax)
 4f4:	01 54 0c 59          	add    %edx,0x59(%esp,%ecx,1)
 4f8:	00 00                	add    %al,(%eax)
 4fa:	00 32                	add    %dh,(%edx)
 4fc:	03 00                	add    (%eax),%eax
 4fe:	00 30                	add    %dh,(%eax)
 500:	03 00                	add    (%eax),%eax
 502:	00 1e                	add    %bl,(%esi)
 504:	85 8c 00 00 e7 04 00 	test   %ecx,0x4e700(%eax,%eax,1)
 50b:	00 00                	add    %al,(%eax)
 50d:	0d b6 01 00 00       	or     $0x1b6,%eax
 512:	01 45 06             	add    %eax,0x6(%ebp)
 515:	f5                   	cmc    
 516:	8b 00                	mov    (%eax),%eax
 518:	00 35 00 00 00 01    	add    %dh,0x1000000
 51e:	9c                   	pushf  
 51f:	4a                   	dec    %edx
 520:	05 00 00 11 73       	add    $0x73110000,%eax
 525:	00 01                	add    %al,(%ecx)
 527:	45                   	inc    %ebp
 528:	13 ce                	adc    %esi,%ecx
 52a:	00 00                	add    %al,(%eax)
 52c:	00 02                	add    %al,(%edx)
 52e:	91                   	xchg   %eax,%ecx
 52f:	00 1d 69 00 01 47    	add    %bl,0x47010069
 535:	09 59 00             	or     %ebx,0x0(%ecx)
 538:	00 00                	add    %al,(%eax)
 53a:	4d                   	dec    %ebp
 53b:	03 00                	add    (%eax),%eax
 53d:	00 45 03             	add    %al,0x3(%ebp)
 540:	00 00                	add    %al,(%eax)
 542:	1d 6a 00 01 47       	sbb    $0x4701006a,%eax
 547:	0c 59                	or     $0x59,%al
 549:	00 00                	add    %al,(%eax)
 54b:	00 86 03 00 00 84    	add    %al,-0x7bfffffd(%esi)
 551:	03 00                	add    (%eax),%eax
 553:	00 1d 63 00 01 48    	add    %bl,0x48010063
 559:	0a 99 00 00 00 9b    	or     -0x65000000(%ecx),%bl
 55f:	03 00                	add    (%eax),%eax
 561:	00 99 03 00 00 13    	add    %bl,0x13000003(%ecx)
 567:	06                   	push   %es
 568:	8c 00                	mov    %es,(%eax)
 56a:	00 4a 05             	add    %cl,0x5(%edx)
 56d:	00 00                	add    %al,(%eax)
 56f:	00 1f                	add    %bl,(%edi)
 571:	a0 01 00 00 01       	mov    0x1000001,%al
 576:	3b 05 59 00 00 00    	cmp    0x59,%eax
 57c:	e2 8b                	loop   509 <PR_BOOTABLE+0x489>
 57e:	00 00                	add    %al,(%eax)
 580:	13 00                	adc    (%eax),%eax
 582:	00 00                	add    %al,(%eax)
 584:	01 9c 89 05 00 00 0e 	add    %ebx,0xe000005(%ecx,%ecx,4)
 58b:	73 00                	jae    58d <PR_BOOTABLE+0x50d>
 58d:	01 3b                	add    %edi,(%ebx)
 58f:	18 89 05 00 00 b6    	sbb    %cl,-0x49fffffb(%ecx)
 595:	03 00                	add    (%eax),%eax
 597:	00 ae 03 00 00 1d    	add    %ch,0x1d000003(%esi)
 59d:	6e                   	outsb  %ds:(%esi),(%dx)
 59e:	00 01                	add    %al,(%ecx)
 5a0:	3d 09 59 00 00       	cmp    $0x5909,%eax
 5a5:	00 03                	add    %al,(%ebx)
 5a7:	04 00                	add    $0x0,%al
 5a9:	00 ff                	add    %bh,%bh
 5ab:	03 00                	add    (%eax),%eax
 5ad:	00 00                	add    %al,(%eax)
 5af:	06                   	push   %es
 5b0:	04 a5                	add    $0xa5,%al
 5b2:	00 00                	add    %al,(%eax)
 5b4:	00 0d 7e 00 00 00    	add    %cl,0x7e
 5ba:	01 32                	add    %esi,(%edx)
 5bc:	06                   	push   %es
 5bd:	bf 8c 00 00 23       	mov    $0x2300008c,%edi
 5c2:	00 00                	add    %al,(%eax)
 5c4:	00 01                	add    %al,(%ecx)
 5c6:	9c                   	pushf  
 5c7:	ca 05 00             	lret   $0x5
 5ca:	00 0e                	add    %cl,(%esi)
 5cc:	69 00 01 32 13 4d    	imul   $0x4d133201,(%eax),%eax
 5d2:	00 00                	add    %al,(%eax)
 5d4:	00 24 04             	add    %ah,(%esp,%eax,1)
 5d7:	00 00                	add    %al,(%eax)
 5d9:	22 04 00             	and    (%eax,%eax,1),%al
 5dc:	00 13                	add    %dl,(%ebx)
 5de:	d2 8c 00 00 ac 03 00 	rorb   %cl,0x3ac00(%eax,%eax,1)
 5e5:	00 1e                	add    %bl,(%esi)
 5e7:	e2 8c                	loop   575 <PR_BOOTABLE+0x4f5>
 5e9:	00 00                	add    %al,(%eax)
 5eb:	1b 06                	sbb    (%esi),%eax
 5ed:	00 00                	add    %al,(%eax)
 5ef:	00 0d 78 00 00 00    	add    %cl,0x78
 5f5:	01 28                	add    %ebp,(%eax)
 5f7:	06                   	push   %es
 5f8:	c8 8b 00 00          	enter  $0x8b,$0x0
 5fc:	1a 00                	sbb    (%eax),%al
 5fe:	00 00                	add    %al,(%eax)
 600:	01 9c f7 05 00 00 11 	add    %ebx,0x11000005(%edi,%esi,8)
 607:	6d                   	insl   (%dx),%es:(%edi)
 608:	00 01                	add    %al,(%ecx)
 60a:	28 12                	sub    %dl,(%edx)
 60c:	ce                   	into   
 60d:	00 00                	add    %al,(%eax)
 60f:	00 02                	add    %al,(%edx)
 611:	91                   	xchg   %eax,%ecx
 612:	00 13                	add    %dl,(%ebx)
 614:	dc 8b 00 00 51 06    	fmull  0x6510000(%ebx)
 61a:	00 00                	add    %al,(%eax)
 61c:	00 0d 6c 00 00 00    	add    %cl,0x6c
 622:	01 23                	add    %esp,(%ebx)
 624:	06                   	push   %es
 625:	bb 8b 00 00 0d       	mov    $0xd00008b,%ebx
 62a:	00 00                	add    %al,(%eax)
 62c:	00 01                	add    %al,(%ecx)
 62e:	9c                   	pushf  
 62f:	1b 06                	sbb    (%esi),%eax
 631:	00 00                	add    %al,(%eax)
 633:	11 72 00             	adc    %esi,0x0(%edx)
 636:	01 23                	add    %esp,(%ebx)
 638:	0f 59 00             	mulps  (%eax),%xmm0
 63b:	00 00                	add    %al,(%eax)
 63d:	02 91 00 00 0d 54    	add    0x540d0000(%ecx),%dl
 643:	00 00                	add    %al,(%eax)
 645:	00 01                	add    %al,(%ecx)
 647:	1d 06 7b 8b 00       	sbb    $0x8b7b06,%eax
 64c:	00 40 00             	add    %al,0x0(%eax)
 64f:	00 00                	add    %al,(%eax)
 651:	01 9c 51 06 00 00 11 	add    %ebx,0x11000006(%ecx,%edx,2)
 658:	73 00                	jae    65a <PR_BOOTABLE+0x5da>
 65a:	01 1d 14 ce 00 00    	add    %ebx,0xce14
 660:	00 02                	add    %al,(%edx)
 662:	91                   	xchg   %eax,%ecx
 663:	00 13                	add    %dl,(%ebx)
 665:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 666:	8b 00                	mov    (%eax),%eax
 668:	00 51 06             	add    %dl,0x6(%ecx)
 66b:	00 00                	add    %al,(%eax)
 66d:	13 b3 8b 00 00 51    	adc    0x5100008b(%ebx),%esi
 673:	06                   	push   %es
 674:	00 00                	add    %al,(%eax)
 676:	00 1f                	add    %bl,(%edi)
 678:	88 01                	mov    %al,(%ecx)
 67a:	00 00                	add    %al,(%eax)
 67c:	01 0f                	add    %ecx,(%edi)
 67e:	05 59 00 00 00       	add    $0x59,%eax
 683:	41                   	inc    %ecx
 684:	8b 00                	mov    (%eax),%eax
 686:	00 3a                	add    %bh,(%edx)
 688:	00 00                	add    %al,(%eax)
 68a:	00 01                	add    %al,(%ecx)
 68c:	9c                   	pushf  
 68d:	c4 06                	les    (%esi),%eax
 68f:	00 00                	add    %al,(%eax)
 691:	11 72 00             	adc    %esi,0x0(%edx)
 694:	01 0f                	add    %ecx,(%edi)
 696:	0e                   	push   %cs
 697:	59                   	pop    %ecx
 698:	00 00                	add    %al,(%eax)
 69a:	00 02                	add    %al,(%edx)
 69c:	91                   	xchg   %eax,%ecx
 69d:	00 11                	add    %dl,(%ecx)
 69f:	63 00                	arpl   %ax,(%eax)
 6a1:	01 0f                	add    %ecx,(%edi)
 6a3:	15 59 00 00 00       	adc    $0x59,%eax
 6a8:	02 91 04 0f 66 00    	add    0x660f04(%ecx),%dl
 6ae:	00 00                	add    %al,(%eax)
 6b0:	01 0f                	add    %ecx,(%edi)
 6b2:	1c 59                	sbb    $0x59,%al
 6b4:	00 00                	add    %al,(%eax)
 6b6:	00 02                	add    %al,(%edx)
 6b8:	91                   	xchg   %eax,%ecx
 6b9:	08 10                	or     %dl,(%eax)
 6bb:	71 00                	jno    6bd <PR_BOOTABLE+0x63d>
 6bd:	00 00                	add    %al,(%eax)
 6bf:	01 0f                	add    %ecx,(%edi)
 6c1:	2f                   	das    
 6c2:	89 05 00 00 44 04    	mov    %eax,0x4440000
 6c8:	00 00                	add    %al,(%eax)
 6ca:	38 04 00             	cmp    %al,(%eax,%eax,1)
 6cd:	00 1d 6c 00 01 11    	add    %bl,0x1101006c
 6d3:	09 59 00             	or     %ebx,0x0(%ecx)
 6d6:	00 00                	add    %al,(%eax)
 6d8:	ce                   	into   
 6d9:	04 00                	add    $0x0,%al
 6db:	00 c6                	add    %al,%dh
 6dd:	04 00                	add    $0x0,%al
 6df:	00 13                	add    %dl,(%ebx)
 6e1:	6d                   	insl   (%dx),%es:(%edi)
 6e2:	8b 00                	mov    (%eax),%eax
 6e4:	00 c4                	add    %al,%ah
 6e6:	06                   	push   %es
 6e7:	00 00                	add    %al,(%eax)
 6e9:	00 0d e8 00 00 00    	add    %cl,0xe8
 6ef:	01 08                	add    %ecx,(%eax)
 6f1:	06                   	push   %es
 6f2:	26 8b 00             	mov    %es:(%eax),%eax
 6f5:	00 1b                	add    %bl,(%ebx)
 6f7:	00 00                	add    %al,(%eax)
 6f9:	00 01                	add    %al,(%ecx)
 6fb:	9c                   	pushf  
 6fc:	17                   	pop    %ss
 6fd:	07                   	pop    %es
 6fe:	00 00                	add    %al,(%eax)
 700:	11 6c 00 01          	adc    %ebp,0x1(%eax,%eax,1)
 704:	08 0f                	or     %cl,(%edi)
 706:	59                   	pop    %ecx
 707:	00 00                	add    %al,(%eax)
 709:	00 02                	add    %al,(%edx)
 70b:	91                   	xchg   %eax,%ecx
 70c:	00 0f                	add    %cl,(%edi)
 70e:	66 00 00             	data16 add %al,(%eax)
 711:	00 01                	add    %al,(%ecx)
 713:	08 16                	or     %dl,(%esi)
 715:	59                   	pop    %ecx
 716:	00 00                	add    %al,(%eax)
 718:	00 02                	add    %al,(%edx)
 71a:	91                   	xchg   %eax,%ecx
 71b:	04 11                	add    $0x11,%al
 71d:	63 68 00             	arpl   %bp,0x0(%eax)
 720:	01 08                	add    %ecx,(%eax)
 722:	22 99 00 00 00 02    	and    0x2000000(%ecx),%bl
 728:	91                   	xchg   %eax,%ecx
 729:	08 1d 70 00 01 0a    	or     %bl,0xa010070
 72f:	14 93                	adc    $0x93,%al
 731:	00 00                	add    %al,(%eax)
 733:	00 04 05 00 00 02 05 	add    %al,0x5020000(,%eax,1)
 73a:	00 00                	add    %al,(%eax)
 73c:	00 20                	add    %ah,(%eax)
 73e:	b1 00                	mov    $0x0,%cl
 740:	00 00                	add    %al,(%eax)
 742:	02 29                	add    (%ecx),%ch
 744:	14 03                	adc    $0x3,%al
 746:	49                   	dec    %ecx
 747:	07                   	pop    %es
 748:	00 00                	add    %al,(%eax)
 74a:	21 ac 01 00 00 02 29 	and    %ebp,0x29020000(%ecx,%eax,1)
 751:	1d 59 00 00 00       	sbb    $0x59,%eax
 756:	21 ea                	and    %ebp,%edx
 758:	03 00                	add    (%eax),%eax
 75a:	00 02                	add    %al,(%edx)
 75c:	29 29                	sub    %ebp,(%ecx)
 75e:	a1 03 00 00 22       	mov    0x22000003,%eax
 763:	63 6e 74             	arpl   %bp,0x74(%esi)
 766:	00 02                	add    %al,(%edx)
 768:	29 33                	sub    %esi,(%ebx)
 76a:	59                   	pop    %ecx
 76b:	00 00                	add    %al,(%eax)
 76d:	00 00                	add    %al,(%eax)
 76f:	23 69 6e             	and    0x6e(%ecx),%ebp
 772:	62 00                	bound  %eax,(%eax)
 774:	02 22                	add    (%edx),%ah
 776:	17                   	pop    %ss
 777:	2c 00                	sub    $0x0,%al
 779:	00 00                	add    %al,(%eax)
 77b:	03 73 07             	add    0x7(%ebx),%esi
 77e:	00 00                	add    %al,(%eax)
 780:	21 ac 01 00 00 02 22 	and    %ebp,0x22020000(%ecx,%eax,1)
 787:	1f                   	pop    %ds
 788:	59                   	pop    %ecx
 789:	00 00                	add    %al,(%eax)
 78b:	00 24 a7             	add    %ah,(%edi,%eiz,4)
 78e:	01 00                	add    %eax,(%eax)
 790:	00 02                	add    %al,(%edx)
 792:	24 0d                	and    $0xd,%al
 794:	2c 00                	sub    $0x0,%al
 796:	00 00                	add    %al,(%eax)
 798:	00 25 ac 00 00 00    	add    %ah,0xac
 79e:	02 18                	add    (%eax),%bl
 7a0:	14 03                	adc    $0x3,%al
 7a2:	21 ac 01 00 00 02 18 	and    %ebp,0x18020000(%ecx,%eax,1)
 7a9:	1d 59 00 00 00       	sbb    $0x59,%eax
 7ae:	21 a7 01 00 00 02    	and    %esp,0x2000001(%edi)
 7b4:	18 2b                	sbb    %ch,(%ebx)
 7b6:	2c 00                	sub    $0x0,%al
 7b8:	00 00                	add    %al,(%eax)
 7ba:	00 00                	add    %al,(%eax)
 7bc:	5c                   	pop    %esp
 7bd:	07                   	pop    %es
 7be:	00 00                	add    %al,(%eax)
 7c0:	04 00                	add    $0x0,%al
 7c2:	65 02 00             	add    %gs:(%eax),%al
 7c5:	00 04 01             	add    %al,(%ecx,%eax,1)
 7c8:	ed                   	in     (%dx),%eax
 7c9:	00 00                	add    %al,(%eax)
 7cb:	00 0c 75 04 00 00 13 	add    %cl,0x13000004(,%esi,2)
 7d2:	00 00                	add    %al,(%eax)
 7d4:	00 98 8d 00 00 84    	add    %bl,-0x7bffff73(%eax)
 7da:	01 00                	add    %eax,(%eax)
 7dc:	00 ad 04 00 00 02    	add    %ch,0x2000004(%ebp)
 7e2:	01 06                	add    %eax,(%esi)
 7e4:	d7                   	xlat   %ds:(%ebx)
 7e5:	00 00                	add    %al,(%eax)
 7e7:	00 03                	add    %al,(%ebx)
 7e9:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 7ea:	00 00                	add    %al,(%eax)
 7ec:	00 02                	add    %al,(%edx)
 7ee:	0d 1c 38 00 00       	or     $0x381c,%eax
 7f3:	00 02                	add    %al,(%edx)
 7f5:	01 08                	add    %ecx,(%eax)
 7f7:	d5 00                	aad    $0x0
 7f9:	00 00                	add    %al,(%eax)
 7fb:	02 02                	add    (%edx),%al
 7fd:	05 5c 00 00 00       	add    $0x5c,%eax
 802:	03 57 03             	add    0x3(%edi),%edx
 805:	00 00                	add    %al,(%eax)
 807:	02 0f                	add    (%edi),%cl
 809:	1c 52                	sbb    $0x52,%al
 80b:	00 00                	add    %al,(%eax)
 80d:	00 02                	add    %al,(%edx)
 80f:	02 07                	add    (%edi),%al
 811:	8d 01                	lea    (%ecx),%eax
 813:	00 00                	add    %al,(%eax)
 815:	04 04                	add    $0x4,%al
 817:	05 69 6e 74 00       	add    $0x746e69,%eax
 81c:	03 7a 01             	add    0x1(%edx),%edi
 81f:	00 00                	add    %al,(%eax)
 821:	02 11                	add    (%ecx),%dl
 823:	1c 6c                	sbb    $0x6c,%al
 825:	00 00                	add    %al,(%eax)
 827:	00 02                	add    %al,(%edx)
 829:	04 07                	add    $0x7,%al
 82b:	6d                   	insl   (%dx),%es:(%edi)
 82c:	01 00                	add    %eax,(%eax)
 82e:	00 02                	add    %al,(%edx)
 830:	08 05 b6 00 00 00    	or     %al,0xb6
 836:	03 1e                	add    (%esi),%ebx
 838:	02 00                	add    (%eax),%al
 83a:	00 02                	add    %al,(%edx)
 83c:	13 1c 86             	adc    (%esi,%eax,4),%ebx
 83f:	00 00                	add    %al,(%eax)
 841:	00 02                	add    %al,(%edx)
 843:	08 07                	or     %al,(%edi)
 845:	63 01                	arpl   %ax,(%ecx)
 847:	00 00                	add    %al,(%eax)
 849:	05 10 02 5e 05       	add    $0x55e0210,%eax
 84e:	e4 00                	in     $0x0,%al
 850:	00 00                	add    %al,(%eax)
 852:	06                   	push   %es
 853:	49                   	dec    %ecx
 854:	03 00                	add    (%eax),%eax
 856:	00 02                	add    %al,(%edx)
 858:	5f                   	pop    %edi
 859:	11 2c 00             	adc    %ebp,(%eax,%eax,1)
 85c:	00 00                	add    %al,(%eax)
 85e:	00 06                	add    %al,(%esi)
 860:	2b 03                	sub    (%ebx),%eax
 862:	00 00                	add    %al,(%eax)
 864:	02 62 11             	add    0x11(%edx),%ah
 867:	e4 00                	in     $0x0,%al
 869:	00 00                	add    %al,(%eax)
 86b:	01 07                	add    %eax,(%edi)
 86d:	69 64 00 02 63 11 2c 	imul   $0x2c1163,0x2(%eax,%eax,1),%esp
 874:	00 
 875:	00 00                	add    %al,(%eax)
 877:	04 06                	add    $0x6,%al
 879:	dc 03                	faddl  (%ebx)
 87b:	00 00                	add    %al,(%eax)
 87d:	02 67 11             	add    0x11(%edi),%ah
 880:	e4 00                	in     $0x0,%al
 882:	00 00                	add    %al,(%eax)
 884:	05 06 20 04 00       	add    $0x42006,%eax
 889:	00 02                	add    %al,(%edx)
 88b:	68 12 60 00 00       	push   $0x6012
 890:	00 08                	add    %cl,(%eax)
 892:	06                   	push   %es
 893:	e4 04                	in     $0x4,%al
 895:	00 00                	add    %al,(%eax)
 897:	02 69 12             	add    0x12(%ecx),%ch
 89a:	60                   	pusha  
 89b:	00 00                	add    %al,(%eax)
 89d:	00 0c 00             	add    %cl,(%eax,%eax,1)
 8a0:	08 2c 00             	or     %ch,(%eax,%eax,1)
 8a3:	00 00                	add    %al,(%eax)
 8a5:	f4                   	hlt    
 8a6:	00 00                	add    %al,(%eax)
 8a8:	00 09                	add    %cl,(%ecx)
 8aa:	6c                   	insb   (%dx),%es:(%edi)
 8ab:	00 00                	add    %al,(%eax)
 8ad:	00 02                	add    %al,(%edx)
 8af:	00 0a                	add    %cl,(%edx)
 8b1:	6d                   	insl   (%dx),%es:(%edi)
 8b2:	62 72 00             	bound  %esi,0x0(%edx)
 8b5:	00 02                	add    %al,(%edx)
 8b7:	02 5b 10             	add    0x10(%ebx),%bl
 8ba:	3a 01                	cmp    (%ecx),%al
 8bc:	00 00                	add    %al,(%eax)
 8be:	06                   	push   %es
 8bf:	3c 02                	cmp    $0x2,%al
 8c1:	00 00                	add    %al,(%eax)
 8c3:	02 5c 0d 3a          	add    0x3a(%ebp,%ecx,1),%bl
 8c7:	01 00                	add    %eax,(%eax)
 8c9:	00 00                	add    %al,(%eax)
 8cb:	0b d8                	or     %eax,%ebx
 8cd:	01 00                	add    %eax,(%eax)
 8cf:	00 02                	add    %al,(%edx)
 8d1:	5d                   	pop    %ebp
 8d2:	0d 4b 01 00 00       	or     $0x14b,%eax
 8d7:	b4 01                	mov    $0x1,%ah
 8d9:	0b d4                	or     %esp,%edx
 8db:	02 00                	add    (%eax),%al
 8dd:	00 02                	add    %al,(%edx)
 8df:	6a 12                	push   $0x12
 8e1:	5b                   	pop    %ebx
 8e2:	01 00                	add    %eax,(%eax)
 8e4:	00 be 01 0b 51 04    	add    %bh,0x4510b01(%esi)
 8ea:	00 00                	add    %al,(%eax)
 8ec:	02 6b 0d             	add    0xd(%ebx),%ch
 8ef:	6b 01 00             	imul   $0x0,(%ecx),%eax
 8f2:	00 fe                	add    %bh,%dh
 8f4:	01 00                	add    %eax,(%eax)
 8f6:	08 2c 00             	or     %ch,(%eax,%eax,1)
 8f9:	00 00                	add    %al,(%eax)
 8fb:	4b                   	dec    %ebx
 8fc:	01 00                	add    %eax,(%eax)
 8fe:	00 0c 6c             	add    %cl,(%esp,%ebp,2)
 901:	00 00                	add    %al,(%eax)
 903:	00 b3 01 00 08 2c    	add    %dh,0x2c080001(%ebx)
 909:	00 00                	add    %al,(%eax)
 90b:	00 5b 01             	add    %bl,0x1(%ebx)
 90e:	00 00                	add    %al,(%eax)
 910:	09 6c 00 00          	or     %ebp,0x0(%eax,%eax,1)
 914:	00 09                	add    %cl,(%ecx)
 916:	00 08                	add    %cl,(%eax)
 918:	8d 00                	lea    (%eax),%eax
 91a:	00 00                	add    %al,(%eax)
 91c:	6b 01 00             	imul   $0x0,(%ecx),%eax
 91f:	00 09                	add    %cl,(%ecx)
 921:	6c                   	insb   (%dx),%es:(%edi)
 922:	00 00                	add    %al,(%eax)
 924:	00 03                	add    %al,(%ebx)
 926:	00 08                	add    %cl,(%eax)
 928:	2c 00                	sub    $0x0,%al
 92a:	00 00                	add    %al,(%eax)
 92c:	7b 01                	jnp    92f <PR_BOOTABLE+0x8af>
 92e:	00 00                	add    %al,(%eax)
 930:	09 6c 00 00          	or     %ebp,0x0(%eax,%eax,1)
 934:	00 01                	add    %al,(%ecx)
 936:	00 03                	add    %al,(%ebx)
 938:	b2 02                	mov    $0x2,%dl
 93a:	00 00                	add    %al,(%eax)
 93c:	02 6c 0e f4          	add    -0xc(%esi,%ecx,1),%ch
 940:	00 00                	add    %al,(%eax)
 942:	00 0d 35 03 00 00    	add    %cl,0x335
 948:	18 02                	sbb    %al,(%edx)
 94a:	76 10                	jbe    95c <PR_BOOTABLE+0x8dc>
 94c:	c9                   	leave  
 94d:	01 00                	add    %eax,(%eax)
 94f:	00 06                	add    %al,(%esi)
 951:	1b 04 00             	sbb    (%eax,%eax,1),%eax
 954:	00 02                	add    %al,(%edx)
 956:	77 0e                	ja     966 <PR_BOOTABLE+0x8e6>
 958:	60                   	pusha  
 959:	00 00                	add    %al,(%eax)
 95b:	00 00                	add    %al,(%eax)
 95d:	06                   	push   %es
 95e:	e5 03                	in     $0x3,%eax
 960:	00 00                	add    %al,(%eax)
 962:	02 78 0e             	add    0xe(%eax),%bh
 965:	7a 00                	jp     967 <PR_BOOTABLE+0x8e7>
 967:	00 00                	add    %al,(%eax)
 969:	04 06                	add    $0x6,%al
 96b:	65 03 00             	add    %gs:(%eax),%eax
 96e:	00 02                	add    %al,(%edx)
 970:	79 0e                	jns    980 <PR_BOOTABLE+0x900>
 972:	7a 00                	jp     974 <PR_BOOTABLE+0x8f4>
 974:	00 00                	add    %al,(%eax)
 976:	0c 06                	or     $0x6,%al
 978:	ba 02 00 00 02       	mov    $0x2000002,%edx
 97d:	7a 0e                	jp     98d <PR_BOOTABLE+0x90d>
 97f:	60                   	pusha  
 980:	00 00                	add    %al,(%eax)
 982:	00 14 00             	add    %dl,(%eax,%eax,1)
 985:	03 de                	add    %esi,%ebx
 987:	02 00                	add    (%eax),%al
 989:	00 02                	add    %al,(%edx)
 98b:	7b 0e                	jnp    99b <PR_BOOTABLE+0x91b>
 98d:	87 01                	xchg   %eax,(%ecx)
 98f:	00 00                	add    %al,(%eax)
 991:	0d e1 01 00 00       	or     $0x1e1,%eax
 996:	34 02                	xor    $0x2,%al
 998:	83 10 a6             	adcl   $0xffffffa6,(%eax)
 99b:	02 00                	add    (%eax),%al
 99d:	00 06                	add    %al,(%esi)
 99f:	d4 03                	aam    $0x3
 9a1:	00 00                	add    %al,(%eax)
 9a3:	02 84 0e 60 00 00 00 	add    0x60(%esi,%ecx,1),%al
 9aa:	00 06                	add    %al,(%esi)
 9ac:	a0 03 00 00 02       	mov    0x2000003,%al
 9b1:	85 0d a6 02 00 00    	test   %ecx,0x2a6
 9b7:	04 06                	add    $0x6,%al
 9b9:	b8 02 00 00 02       	mov    $0x2000002,%eax
 9be:	86 0e                	xchg   %cl,(%esi)
 9c0:	46                   	inc    %esi
 9c1:	00 00                	add    %al,(%eax)
 9c3:	00 10                	add    %dl,(%eax)
 9c5:	06                   	push   %es
 9c6:	57                   	push   %edi
 9c7:	02 00                	add    (%eax),%al
 9c9:	00 02                	add    %al,(%edx)
 9cb:	87 0e                	xchg   %ecx,(%esi)
 9cd:	46                   	inc    %esi
 9ce:	00 00                	add    %al,(%eax)
 9d0:	00 12                	add    %dl,(%edx)
 9d2:	06                   	push   %es
 9d3:	0e                   	push   %cs
 9d4:	03 00                	add    (%eax),%eax
 9d6:	00 02                	add    %al,(%edx)
 9d8:	88 0e                	mov    %cl,(%esi)
 9da:	60                   	pusha  
 9db:	00 00                	add    %al,(%eax)
 9dd:	00 14 06             	add    %dl,(%esi,%eax,1)
 9e0:	16                   	push   %ss
 9e1:	02 00                	add    (%eax),%al
 9e3:	00 02                	add    %al,(%edx)
 9e5:	89 0e                	mov    %ecx,(%esi)
 9e7:	60                   	pusha  
 9e8:	00 00                	add    %al,(%eax)
 9ea:	00 18                	add    %bl,(%eax)
 9ec:	06                   	push   %es
 9ed:	bf 03 00 00 02       	mov    $0x2000003,%edi
 9f2:	8a 0e                	mov    (%esi),%cl
 9f4:	60                   	pusha  
 9f5:	00 00                	add    %al,(%eax)
 9f7:	00 1c 06             	add    %bl,(%esi,%eax,1)
 9fa:	f8                   	clc    
 9fb:	03 00                	add    (%eax),%eax
 9fd:	00 02                	add    %al,(%edx)
 9ff:	8b 0e                	mov    (%esi),%ecx
 a01:	60                   	pusha  
 a02:	00 00                	add    %al,(%eax)
 a04:	00 20                	add    %ah,(%eax)
 a06:	06                   	push   %es
 a07:	47                   	inc    %edi
 a08:	02 00                	add    (%eax),%al
 a0a:	00 02                	add    %al,(%edx)
 a0c:	8c 0e                	mov    %cs,(%esi)
 a0e:	60                   	pusha  
 a0f:	00 00                	add    %al,(%eax)
 a11:	00 24 06             	add    %ah,(%esi,%eax,1)
 a14:	cb                   	lret   
 a15:	02 00                	add    (%eax),%al
 a17:	00 02                	add    %al,(%edx)
 a19:	8d 0e                	lea    (%esi),%ecx
 a1b:	46                   	inc    %esi
 a1c:	00 00                	add    %al,(%eax)
 a1e:	00 28                	add    %ch,(%eax)
 a20:	06                   	push   %es
 a21:	61                   	popa   
 a22:	02 00                	add    (%eax),%al
 a24:	00 02                	add    %al,(%edx)
 a26:	8e 0e                	mov    (%esi),%cs
 a28:	46                   	inc    %esi
 a29:	00 00                	add    %al,(%eax)
 a2b:	00 2a                	add    %ch,(%edx)
 a2d:	06                   	push   %es
 a2e:	49                   	dec    %ecx
 a2f:	04 00                	add    $0x0,%al
 a31:	00 02                	add    %al,(%edx)
 a33:	8f                   	(bad)  
 a34:	0e                   	push   %cs
 a35:	46                   	inc    %esi
 a36:	00 00                	add    %al,(%eax)
 a38:	00 2c 06             	add    %ch,(%esi,%eax,1)
 a3b:	a0 02 00 00 02       	mov    0x2000002,%al
 a40:	90                   	nop
 a41:	0e                   	push   %cs
 a42:	46                   	inc    %esi
 a43:	00 00                	add    %al,(%eax)
 a45:	00 2e                	add    %ch,(%esi)
 a47:	06                   	push   %es
 a48:	5b                   	pop    %ebx
 a49:	04 00                	add    $0x0,%al
 a4b:	00 02                	add    %al,(%edx)
 a4d:	91                   	xchg   %eax,%ecx
 a4e:	0e                   	push   %cs
 a4f:	46                   	inc    %esi
 a50:	00 00                	add    %al,(%eax)
 a52:	00 30                	add    %dh,(%eax)
 a54:	06                   	push   %es
 a55:	e8 01 00 00 02       	call   2000a5b <_end+0x1ff770f>
 a5a:	92                   	xchg   %eax,%edx
 a5b:	0e                   	push   %cs
 a5c:	46                   	inc    %esi
 a5d:	00 00                	add    %al,(%eax)
 a5f:	00 32                	add    %dh,(%edx)
 a61:	00 08                	add    %cl,(%eax)
 a63:	2c 00                	sub    $0x0,%al
 a65:	00 00                	add    %al,(%eax)
 a67:	b6 02                	mov    $0x2,%dh
 a69:	00 00                	add    %al,(%eax)
 a6b:	09 6c 00 00          	or     %ebp,0x0(%eax,%eax,1)
 a6f:	00 0b                	add    %cl,(%ebx)
 a71:	00 03                	add    %al,(%ebx)
 a73:	fd                   	std    
 a74:	01 00                	add    %eax,(%eax)
 a76:	00 02                	add    %al,(%edx)
 a78:	93                   	xchg   %eax,%ebx
 a79:	03 d5                	add    %ebp,%edx
 a7b:	01 00                	add    %eax,(%eax)
 a7d:	00 0d 98 02 00 00    	add    %cl,0x298
 a83:	20 02                	and    %al,(%edx)
 a85:	96                   	xchg   %eax,%esi
 a86:	10 38                	adc    %bh,(%eax)
 a88:	03 00                	add    (%eax),%eax
 a8a:	00 06                	add    %al,(%esi)
 a8c:	91                   	xchg   %eax,%ecx
 a8d:	02 00                	add    (%eax),%al
 a8f:	00 02                	add    %al,(%edx)
 a91:	97                   	xchg   %eax,%edi
 a92:	0e                   	push   %cs
 a93:	60                   	pusha  
 a94:	00 00                	add    %al,(%eax)
 a96:	00 00                	add    %al,(%eax)
 a98:	06                   	push   %es
 a99:	33 02                	xor    (%edx),%eax
 a9b:	00 00                	add    %al,(%eax)
 a9d:	02 98 0e 60 00 00    	add    0x600e(%eax),%bl
 aa3:	00 04 06             	add    %al,(%esi,%eax,1)
 aa6:	77 03                	ja     aab <PR_BOOTABLE+0xa2b>
 aa8:	00 00                	add    %al,(%eax)
 aaa:	02 99 0e 60 00 00    	add    0x600e(%ecx),%bl
 ab0:	00 08                	add    %cl,(%eax)
 ab2:	06                   	push   %es
 ab3:	df 04 00             	filds  (%eax,%eax,1)
 ab6:	00 02                	add    %al,(%edx)
 ab8:	9a 0e 60 00 00 00 0c 	lcall  $0xc00,$0x600e
 abf:	06                   	push   %es
 ac0:	40                   	inc    %eax
 ac1:	04 00                	add    $0x0,%al
 ac3:	00 02                	add    %al,(%edx)
 ac5:	9b                   	fwait
 ac6:	0e                   	push   %cs
 ac7:	60                   	pusha  
 ac8:	00 00                	add    %al,(%eax)
 aca:	00 10                	add    %dl,(%eax)
 acc:	06                   	push   %es
 acd:	38 04 00             	cmp    %al,(%eax,%eax,1)
 ad0:	00 02                	add    %al,(%edx)
 ad2:	9c                   	pushf  
 ad3:	0e                   	push   %cs
 ad4:	60                   	pusha  
 ad5:	00 00                	add    %al,(%eax)
 ad7:	00 14 06             	add    %dl,(%esi,%eax,1)
 ada:	8d 03                	lea    (%ebx),%eax
 adc:	00 00                	add    %al,(%eax)
 ade:	02 9d 0e 60 00 00    	add    0x600e(%ebp),%bl
 ae4:	00 18                	add    %bl,(%eax)
 ae6:	06                   	push   %es
 ae7:	cd 04                	int    $0x4
 ae9:	00 00                	add    %al,(%eax)
 aeb:	02 9e 0e 60 00 00    	add    0x600e(%esi),%bl
 af1:	00 1c 00             	add    %bl,(%eax,%eax,1)
 af4:	03 98 02 00 00 02    	add    0x2000002(%eax),%ebx
 afa:	9f                   	lahf   
 afb:	03 c2                	add    %edx,%eax
 afd:	02 00                	add    (%eax),%al
 aff:	00 05 04 02 ad 05    	add    %al,0x5ad0204
 b05:	82 03 00             	addb   $0x0,(%ebx)
 b08:	00 06                	add    %al,(%esi)
 b0a:	24 03                	and    $0x3,%al
 b0c:	00 00                	add    %al,(%eax)
 b0e:	02 ae 11 2c 00 00    	add    0x2c11(%esi),%ch
 b14:	00 00                	add    %al,(%eax)
 b16:	06                   	push   %es
 b17:	18 03                	sbb    %al,(%ebx)
 b19:	00 00                	add    %al,(%eax)
 b1b:	02 af 11 2c 00 00    	add    0x2c11(%edi),%ch
 b21:	00 01                	add    %al,(%ecx)
 b23:	06                   	push   %es
 b24:	1e                   	push   %ds
 b25:	03 00                	add    (%eax),%eax
 b27:	00 02                	add    %al,(%edx)
 b29:	b0 11                	mov    $0x11,%al
 b2b:	2c 00                	sub    $0x0,%al
 b2d:	00 00                	add    %al,(%eax)
 b2f:	02 06                	add    (%esi),%al
 b31:	8b 02                	mov    (%edx),%eax
 b33:	00 00                	add    %al,(%eax)
 b35:	02 b1 11 2c 00 00    	add    0x2c11(%ecx),%dh
 b3b:	00 03                	add    %al,(%ebx)
 b3d:	00 05 10 02 be 09    	add    %al,0x9be0210
 b43:	c0 03 00             	rolb   $0x0,(%ebx)
 b46:	00 06                	add    %al,(%esi)
 b48:	18 04 00             	sbb    %al,(%eax,%eax,1)
 b4b:	00 02                	add    %al,(%edx)
 b4d:	bf 16 60 00 00       	mov    $0x6016,%edi
 b52:	00 00                	add    %al,(%eax)
 b54:	06                   	push   %es
 b55:	83 02 00             	addl   $0x0,(%edx)
 b58:	00 02                	add    %al,(%edx)
 b5a:	c0 16 60             	rclb   $0x60,(%esi)
 b5d:	00 00                	add    %al,(%eax)
 b5f:	00 04 06             	add    %al,(%esi,%eax,1)
 b62:	ea 03 00 00 02 c1 16 	ljmp   $0x16c1,$0x2000003
 b69:	60                   	pusha  
 b6a:	00 00                	add    %al,(%eax)
 b6c:	00 08                	add    %cl,(%eax)
 b6e:	06                   	push   %es
 b6f:	97                   	xchg   %eax,%edi
 b70:	04 00                	add    $0x0,%al
 b72:	00 02                	add    %al,(%edx)
 b74:	c2 16 60             	ret    $0x6016
 b77:	00 00                	add    %al,(%eax)
 b79:	00 0c 00             	add    %cl,(%eax,%eax,1)
 b7c:	05 10 02 c4 09       	add    $0x9c40210,%eax
 b81:	fe 03                	incb   (%ebx)
 b83:	00 00                	add    %al,(%eax)
 b85:	07                   	pop    %es
 b86:	6e                   	outsb  %ds:(%esi),(%dx)
 b87:	75 6d                	jne    bf6 <PR_BOOTABLE+0xb76>
 b89:	00 02                	add    %al,(%edx)
 b8b:	c5 16                	lds    (%esi),%edx
 b8d:	60                   	pusha  
 b8e:	00 00                	add    %al,(%eax)
 b90:	00 00                	add    %al,(%eax)
 b92:	06                   	push   %es
 b93:	1b 04 00             	sbb    (%eax,%eax,1),%eax
 b96:	00 02                	add    %al,(%edx)
 b98:	c6                   	(bad)  
 b99:	16                   	push   %ss
 b9a:	60                   	pusha  
 b9b:	00 00                	add    %al,(%eax)
 b9d:	00 04 06             	add    %al,(%esi,%eax,1)
 ba0:	ea 03 00 00 02 c7 16 	ljmp   $0x16c7,$0x2000003
 ba7:	60                   	pusha  
 ba8:	00 00                	add    %al,(%eax)
 baa:	00 08                	add    %cl,(%eax)
 bac:	06                   	push   %es
 bad:	ac                   	lods   %ds:(%esi),%al
 bae:	02 00                	add    (%eax),%al
 bb0:	00 02                	add    %al,(%edx)
 bb2:	c8 16 60 00          	enter  $0x6016,$0x0
 bb6:	00 00                	add    %al,(%eax)
 bb8:	0c 00                	or     $0x0,%al
 bba:	0e                   	push   %cs
 bbb:	10 02                	adc    %al,(%edx)
 bbd:	bd 05 20 04 00       	mov    $0x42005,%ebp
 bc2:	00 0f                	add    %cl,(%edi)
 bc4:	b2 03                	mov    $0x3,%dl
 bc6:	00 00                	add    %al,(%eax)
 bc8:	02 c3                	add    %bl,%al
 bca:	0b 82 03 00 00 10    	or     0x10000003(%edx),%eax
 bd0:	65 6c                	gs insb (%dx),%es:(%edi)
 bd2:	66 00 02             	data16 add %al,(%edx)
 bd5:	c9                   	leave  
 bd6:	0b c0                	or     %eax,%eax
 bd8:	03 00                	add    (%eax),%eax
 bda:	00 00                	add    %al,(%eax)
 bdc:	0d 6c 03 00 00       	or     $0x36c,%eax
 be1:	60                   	pusha  
 be2:	02 a5 10 3f 05 00    	add    0x53f10(%ebp),%ah
 be8:	00 06                	add    %al,(%esi)
 bea:	49                   	dec    %ecx
 beb:	02 00                	add    (%eax),%al
 bed:	00 02                	add    %al,(%edx)
 bef:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 bf0:	0e                   	push   %cs
 bf1:	60                   	pusha  
 bf2:	00 00                	add    %al,(%eax)
 bf4:	00 00                	add    %al,(%eax)
 bf6:	06                   	push   %es
 bf7:	3f                   	aas    
 bf8:	03 00                	add    (%eax),%eax
 bfa:	00 02                	add    %al,(%edx)
 bfc:	a9 0e 60 00 00       	test   $0x600e,%eax
 c01:	00 04 06             	add    %al,(%esi,%eax,1)
 c04:	00 04 00             	add    %al,(%eax,%eax,1)
 c07:	00 02                	add    %al,(%edx)
 c09:	aa                   	stos   %al,%es:(%edi)
 c0a:	0e                   	push   %cs
 c0b:	60                   	pusha  
 c0c:	00 00                	add    %al,(%eax)
 c0e:	00 08                	add    %cl,(%eax)
 c10:	06                   	push   %es
 c11:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 c12:	03 00                	add    (%eax),%eax
 c14:	00 02                	add    %al,(%edx)
 c16:	b2 07                	mov    $0x7,%dl
 c18:	44                   	inc    %esp
 c19:	03 00                	add    (%eax),%eax
 c1b:	00 0c 06             	add    %cl,(%esi,%eax,1)
 c1e:	4f                   	dec    %edi
 c1f:	02 00                	add    (%eax),%al
 c21:	00 02                	add    %al,(%edx)
 c23:	b5 0e                	mov    $0xe,%ch
 c25:	60                   	pusha  
 c26:	00 00                	add    %al,(%eax)
 c28:	00 10                	add    %dl,(%eax)
 c2a:	06                   	push   %es
 c2b:	8c 04 00             	mov    %es,(%eax,%eax,1)
 c2e:	00 02                	add    %al,(%edx)
 c30:	b9 0e 60 00 00       	mov    $0x600e,%ecx
 c35:	00 14 06             	add    %dl,(%esi,%eax,1)
 c38:	79 02                	jns    c3c <PR_BOOTABLE+0xbbc>
 c3a:	00 00                	add    %al,(%eax)
 c3c:	02 ba 0e 60 00 00    	add    0x600e(%edx),%bh
 c42:	00 18                	add    %bl,(%eax)
 c44:	06                   	push   %es
 c45:	52                   	push   %edx
 c46:	03 00                	add    (%eax),%eax
 c48:	00 02                	add    %al,(%edx)
 c4a:	ca 07 fe             	lret   $0xfe07
 c4d:	03 00                	add    (%eax),%eax
 c4f:	00 1c 06             	add    %bl,(%esi,%eax,1)
 c52:	60                   	pusha  
 c53:	03 00                	add    (%eax),%eax
 c55:	00 02                	add    %al,(%edx)
 c57:	cd 0e                	int    $0xe
 c59:	60                   	pusha  
 c5a:	00 00                	add    %al,(%eax)
 c5c:	00 2c 06             	add    %ch,(%esi,%eax,1)
 c5f:	f3 01 00             	repz add %eax,(%eax)
 c62:	00 02                	add    %al,(%edx)
 c64:	cf                   	iret   
 c65:	0e                   	push   %cs
 c66:	60                   	pusha  
 c67:	00 00                	add    %al,(%eax)
 c69:	00 30                	add    %dh,(%eax)
 c6b:	06                   	push   %es
 c6c:	2a 04 00             	sub    (%eax,%eax,1),%al
 c6f:	00 02                	add    %al,(%edx)
 c71:	d3 0e                	rorl   %cl,(%esi)
 c73:	60                   	pusha  
 c74:	00 00                	add    %al,(%eax)
 c76:	00 34 06             	add    %dh,(%esi,%eax,1)
 c79:	bf 02 00 00 02       	mov    $0x2000002,%edi
 c7e:	d4 0e                	aam    $0xe
 c80:	60                   	pusha  
 c81:	00 00                	add    %al,(%eax)
 c83:	00 38                	add    %bh,(%eax)
 c85:	06                   	push   %es
 c86:	c7 03 00 00 02 d7    	movl   $0xd7020000,(%ebx)
 c8c:	0e                   	push   %cs
 c8d:	60                   	pusha  
 c8e:	00 00                	add    %al,(%eax)
 c90:	00 3c 06             	add    %bh,(%esi,%eax,1)
 c93:	a1 04 00 00 02       	mov    0x2000004,%eax
 c98:	da 0e                	fimull (%esi)
 c9a:	60                   	pusha  
 c9b:	00 00                	add    %al,(%eax)
 c9d:	00 40 06             	add    %al,0x6(%eax)
 ca0:	d5 04                	aad    $0x4
 ca2:	00 00                	add    %al,(%eax)
 ca4:	02 dd                	add    %ch,%bl
 ca6:	0e                   	push   %cs
 ca7:	60                   	pusha  
 ca8:	00 00                	add    %al,(%eax)
 caa:	00 44 06 7c          	add    %al,0x7c(%esi,%eax,1)
 cae:	03 00                	add    (%eax),%eax
 cb0:	00 02                	add    %al,(%edx)
 cb2:	e0 0e                	loopne cc2 <PR_BOOTABLE+0xc42>
 cb4:	60                   	pusha  
 cb5:	00 00                	add    %al,(%eax)
 cb7:	00 48 06             	add    %cl,0x6(%eax)
 cba:	0a 04 00             	or     (%eax,%eax,1),%al
 cbd:	00 02                	add    %al,(%edx)
 cbf:	e1 0e                	loope  ccf <PR_BOOTABLE+0xc4f>
 cc1:	60                   	pusha  
 cc2:	00 00                	add    %al,(%eax)
 cc4:	00 4c 06 ef          	add    %cl,-0x11(%esi,%eax,1)
 cc8:	03 00                	add    (%eax),%eax
 cca:	00 02                	add    %al,(%edx)
 ccc:	e2 0e                	loop   cdc <PR_BOOTABLE+0xc5c>
 cce:	60                   	pusha  
 ccf:	00 00                	add    %al,(%eax)
 cd1:	00 50 06             	add    %dl,0x6(%eax)
 cd4:	b2 04                	mov    $0x4,%dl
 cd6:	00 00                	add    %al,(%eax)
 cd8:	02 e3                	add    %bl,%ah
 cda:	0e                   	push   %cs
 cdb:	60                   	pusha  
 cdc:	00 00                	add    %al,(%eax)
 cde:	00 54 06 04          	add    %dl,0x4(%esi,%eax,1)
 ce2:	02 00                	add    (%eax),%al
 ce4:	00 02                	add    %al,(%edx)
 ce6:	e4 0e                	in     $0xe,%al
 ce8:	60                   	pusha  
 ce9:	00 00                	add    %al,(%eax)
 ceb:	00 58 06             	add    %bl,0x6(%eax)
 cee:	63 04 00             	arpl   %ax,(%eax,%eax,1)
 cf1:	00 02                	add    %al,(%edx)
 cf3:	e5 0e                	in     $0xe,%eax
 cf5:	60                   	pusha  
 cf6:	00 00                	add    %al,(%eax)
 cf8:	00 5c 00 03          	add    %bl,0x3(%eax,%eax,1)
 cfc:	ea 02 00 00 02 e6 03 	ljmp   $0x3e6,$0x2000002
 d03:	20 04 00             	and    %al,(%eax,%eax,1)
 d06:	00 11                	add    %dl,(%ecx)
 d08:	6c                   	insb   (%dx),%es:(%edi)
 d09:	03 00                	add    (%eax),%eax
 d0b:	00 01                	add    %al,(%ecx)
 d0d:	08 0e                	or     %cl,(%esi)
 d0f:	3f                   	aas    
 d10:	05 00 00 05 03       	add    $0x3050000,%eax
 d15:	c0 92 00 00 12 95 03 	rclb   $0x3,-0x6aee0000(%edx)
 d1c:	00 00                	add    %al,(%eax)
 d1e:	01 41 0f             	add    %eax,0xf(%ecx)
 d21:	bf 05 00 00 19       	mov    $0x19000005,%edi
 d26:	8e 00                	mov    (%eax),%es
 d28:	00 60 00             	add    %ah,0x0(%eax)
 d2b:	00 00                	add    %al,(%eax)
 d2d:	01 9c bf 05 00 00 13 	add    %ebx,0x13000005(%edi,%edi,4)
 d34:	3a 03                	cmp    (%ebx),%al
 d36:	00 00                	add    %al,(%eax)
 d38:	01 41 27             	add    %eax,0x27(%ecx)
 d3b:	c5 05 00 00 02 91    	lds    0x91020000,%eax
 d41:	00 14 70             	add    %dl,(%eax,%esi,2)
 d44:	00 01                	add    %al,(%ecx)
 d46:	43                   	inc    %ebx
 d47:	12 c5                	adc    %ch,%al
 d49:	05 00 00 21 05       	add    $0x5210000,%eax
 d4e:	00 00                	add    %al,(%eax)
 d50:	17                   	pop    %ss
 d51:	05 00 00 15 c4       	add    $0xc4150000,%eax
 d56:	04 00                	add    $0x0,%al
 d58:	00 01                	add    %al,(%ecx)
 d5a:	44                   	inc    %esp
 d5b:	0e                   	push   %cs
 d5c:	60                   	pusha  
 d5d:	00 00                	add    %al,(%eax)
 d5f:	00 89 05 00 00 7f    	add    %cl,0x7f000005(%ecx)
 d65:	05 00 00 16 30       	add    $0x30160000,%eax
 d6a:	8e 00                	mov    (%eax),%es
 d6c:	00 17                	add    %dl,(%edi)
 d6e:	07                   	pop    %es
 d6f:	00 00                	add    %al,(%eax)
 d71:	16                   	push   %ss
 d72:	4b                   	dec    %ebx
 d73:	8e 00                	mov    (%eax),%es
 d75:	00 23                	add    %ah,(%ebx)
 d77:	07                   	pop    %es
 d78:	00 00                	add    %al,(%eax)
 d7a:	00 17                	add    %dl,(%edi)
 d7c:	04 3f                	add    $0x3f,%al
 d7e:	05 00 00 17 04       	add    $0x4170000,%eax
 d83:	c9                   	leave  
 d84:	01 00                	add    %eax,(%eax)
 d86:	00 12                	add    %dl,(%edx)
 d88:	27                   	daa    
 d89:	02 00                	add    (%eax),%al
 d8b:	00 01                	add    %al,(%ecx)
 d8d:	2b 0a                	sub    (%edx),%ecx
 d8f:	60                   	pusha  
 d90:	00 00                	add    %al,(%eax)
 d92:	00 98 8d 00 00 81    	add    %bl,-0x7effff73(%eax)
 d98:	00 00                	add    %al,(%eax)
 d9a:	00 01                	add    %al,(%ecx)
 d9c:	9c                   	pushf  
 d9d:	37                   	aaa    
 d9e:	06                   	push   %es
 d9f:	00 00                	add    %al,(%eax)
 da1:	13 b7 03 00 00 01    	adc    0x1000003(%edi),%esi
 da7:	2b 1f                	sub    (%edi),%ebx
 da9:	60                   	pusha  
 daa:	00 00                	add    %al,(%eax)
 dac:	00 02                	add    %al,(%edx)
 dae:	91                   	xchg   %eax,%ecx
 daf:	00 14 70             	add    %dl,(%eax,%esi,2)
 db2:	68 00 01 2e 0e       	push   $0xe2e0100
 db7:	37                   	aaa    
 db8:	06                   	push   %es
 db9:	00 00                	add    %al,(%eax)
 dbb:	d5 05                	aad    $0x5
 dbd:	00 00                	add    %al,(%eax)
 dbf:	cf                   	iret   
 dc0:	05 00 00 14 65       	add    $0x65140000,%eax
 dc5:	70 68                	jo     e2f <PR_BOOTABLE+0xdaf>
 dc7:	00 01                	add    %al,(%ecx)
 dc9:	2e 13 37             	adc    %cs:(%edi),%esi
 dcc:	06                   	push   %es
 dcd:	00 00                	add    %al,(%eax)
 dcf:	02 06                	add    (%esi),%al
 dd1:	00 00                	add    %al,(%eax)
 dd3:	00 06                	add    %al,(%esi)
 dd5:	00 00                	add    %al,(%eax)
 dd7:	16                   	push   %ss
 dd8:	b6 8d                	mov    $0x8d,%dh
 dda:	00 00                	add    %al,(%eax)
 ddc:	2f                   	das    
 ddd:	07                   	pop    %es
 dde:	00 00                	add    %al,(%eax)
 de0:	16                   	push   %ss
 de1:	d2 8d 00 00 3b 07    	rorb   %cl,0x73b0000(%ebp)
 de7:	00 00                	add    %al,(%eax)
 de9:	16                   	push   %ss
 dea:	02 8e 00 00 2f 07    	add    0x72f0000(%esi),%cl
 df0:	00 00                	add    %al,(%eax)
 df2:	00 17                	add    %dl,(%edi)
 df4:	04 38                	add    $0x38,%al
 df6:	03 00                	add    (%eax),%eax
 df8:	00 18                	add    %bl,(%eax)
 dfa:	04 03                	add    $0x3,%al
 dfc:	00 00                	add    %al,(%eax)
 dfe:	01 0a                	add    %ecx,(%edx)
 e00:	06                   	push   %es
 e01:	79 8e                	jns    d91 <PR_BOOTABLE+0xd11>
 e03:	00 00                	add    %al,(%eax)
 e05:	a3 00 00 00 01       	mov    %eax,0x1000000
 e0a:	9c                   	pushf  
 e0b:	11 07                	adc    %eax,(%edi)
 e0d:	00 00                	add    %al,(%eax)
 e0f:	19 64 65 76          	sbb    %esp,0x76(%ebp,%eiz,2)
 e13:	00 01                	add    %al,(%ecx)
 e15:	0a 19                	or     (%ecx),%bl
 e17:	60                   	pusha  
 e18:	00 00                	add    %al,(%eax)
 e1a:	00 17                	add    %dl,(%edi)
 e1c:	06                   	push   %es
 e1d:	00 00                	add    %al,(%eax)
 e1f:	15 06 00 00 1a       	adc    $0x1a000006,%eax
 e24:	6d                   	insl   (%dx),%es:(%edi)
 e25:	62 72 00             	bound  %esi,0x0(%edx)
 e28:	01 0a                	add    %ecx,(%edx)
 e2a:	25 11 07 00 00       	and    $0x711,%eax
 e2f:	02 91 04 13 3a 03    	add    0x33a1304(%ecx),%dl
 e35:	00 00                	add    %al,(%eax)
 e37:	01 0a                	add    %ecx,(%edx)
 e39:	37                   	aaa    
 e3a:	c5 05 00 00 02 91    	lds    0x91020000,%eax
 e40:	08 14 69             	or     %dl,(%ecx,%ebp,2)
 e43:	00 01                	add    %al,(%ecx)
 e45:	10 09                	adc    %cl,(%ecx)
 e47:	59                   	pop    %ecx
 e48:	00 00                	add    %al,(%eax)
 e4a:	00 2f                	add    %ch,(%edi)
 e4c:	06                   	push   %es
 e4d:	00 00                	add    %al,(%eax)
 e4f:	2b 06                	sub    (%esi),%eax
 e51:	00 00                	add    %al,(%eax)
 e53:	15 f7 02 00 00       	adc    $0x2f7,%eax
 e58:	01 11                	add    %edx,(%ecx)
 e5a:	0e                   	push   %cs
 e5b:	60                   	pusha  
 e5c:	00 00                	add    %al,(%eax)
 e5e:	00 54 06 00          	add    %dl,0x0(%esi,%eax,1)
 e62:	00 4e 06             	add    %cl,0x6(%esi)
 e65:	00 00                	add    %al,(%eax)
 e67:	15 18 02 00 00       	adc    $0x218,%eax
 e6c:	01 1f                	add    %ebx,(%edi)
 e6e:	0e                   	push   %cs
 e6f:	60                   	pusha  
 e70:	00 00                	add    %al,(%eax)
 e72:	00 83 06 00 00 7f    	add    %al,0x7f000006(%ebx)
 e78:	06                   	push   %es
 e79:	00 00                	add    %al,(%eax)
 e7b:	16                   	push   %ss
 e7c:	8e 8e 00 00 47 07    	mov    0x7470000(%esi),%cs
 e82:	00 00                	add    %al,(%eax)
 e84:	16                   	push   %ss
 e85:	9a 8e 00 00 17 07 00 	lcall  $0x7,$0x1700008e
 e8c:	00 16                	add    %dl,(%esi)
 e8e:	cc                   	int3   
 e8f:	8e 00                	mov    (%eax),%es
 e91:	00 3b                	add    %bh,(%ebx)
 e93:	07                   	pop    %es
 e94:	00 00                	add    %al,(%eax)
 e96:	16                   	push   %ss
 e97:	d8 8e 00 00 5d 05    	fmuls  0x55d0000(%esi)
 e9d:	00 00                	add    %al,(%eax)
 e9f:	16                   	push   %ss
 ea0:	e4 8e                	in     $0x8e,%al
 ea2:	00 00                	add    %al,(%eax)
 ea4:	17                   	pop    %ss
 ea5:	07                   	pop    %es
 ea6:	00 00                	add    %al,(%eax)
 ea8:	16                   	push   %ss
 ea9:	ec                   	in     (%dx),%al
 eaa:	8e 00                	mov    (%eax),%es
 eac:	00 cb                	add    %cl,%bl
 eae:	05 00 00 16 fa       	add    $0xfa160000,%eax
 eb3:	8e 00                	mov    (%eax),%es
 eb5:	00 17                	add    %dl,(%edi)
 eb7:	07                   	pop    %es
 eb8:	00 00                	add    %al,(%eax)
 eba:	16                   	push   %ss
 ebb:	07                   	pop    %es
 ebc:	8f 00                	popl   (%eax)
 ebe:	00 53 07             	add    %dl,0x7(%ebx)
 ec1:	00 00                	add    %al,(%eax)
 ec3:	1b 1c 8f             	sbb    (%edi,%ecx,4),%ebx
 ec6:	00 00                	add    %al,(%eax)
 ec8:	3b 07                	cmp    (%edi),%eax
 eca:	00 00                	add    %al,(%eax)
 ecc:	00 17                	add    %dl,(%edi)
 ece:	04 7b                	add    $0x7b,%al
 ed0:	01 00                	add    %eax,(%eax)
 ed2:	00 1c 54             	add    %bl,(%esp,%edx,2)
 ed5:	00 00                	add    %al,(%eax)
 ed7:	00 54 00 00          	add    %dl,0x0(%eax,%eax,1)
 edb:	00 02                	add    %al,(%edx)
 edd:	49                   	dec    %ecx
 ede:	06                   	push   %es
 edf:	1c 7e                	sbb    $0x7e,%al
 ee1:	00 00                	add    %al,(%eax)
 ee3:	00 7e 00             	add    %bh,0x0(%esi)
 ee6:	00 00                	add    %al,(%eax)
 ee8:	02 4a 06             	add    0x6(%edx),%cl
 eeb:	1c c4                	sbb    $0xc4,%al
 eed:	00 00                	add    %al,(%eax)
 eef:	00 c4                	add    %al,%ah
 ef1:	00 00                	add    %al,(%eax)
 ef3:	00 02                	add    %al,(%edx)
 ef5:	70 06                	jo     efd <PR_BOOTABLE+0xe7d>
 ef7:	1c 78                	sbb    $0x78,%al
 ef9:	00 00                	add    %al,(%eax)
 efb:	00 78 00             	add    %bh,0x0(%eax)
 efe:	00 00                	add    %al,(%eax)
 f00:	02 4c 06 1c          	add    0x1c(%esi,%eax,1),%cl
 f04:	6c                   	insb   (%dx),%es:(%edi)
 f05:	00 00                	add    %al,(%eax)
 f07:	00 6c 00 00          	add    %ch,0x0(%eax,%eax,1)
 f0b:	00 02                	add    %al,(%edx)
 f0d:	4b                   	dec    %ebx
 f0e:	06                   	push   %es
 f0f:	1c 6d                	sbb    $0x6d,%al
 f11:	02 00                	add    (%eax),%al
 f13:	00 6d 02             	add    %ch,0x2(%ebp)
 f16:	00 00                	add    %al,(%eax)
 f18:	01 06                	add    %eax,(%esi)
 f1a:	0d 00 22 00 00       	or     $0x2200,%eax
 f1f:	00 02                	add    %al,(%edx)
 f21:	00 2a                	add    %ch,(%edx)
 f23:	04 00                	add    $0x0,%al
 f25:	00 04 01             	add    %al,(%ecx,%eax,1)
 f28:	6b 06 00             	imul   $0x0,(%esi),%eax
 f2b:	00 1c 8f             	add    %bl,(%edi,%ecx,4)
 f2e:	00 00                	add    %al,(%eax)
 f30:	2c 8f                	sub    $0x8f,%al
 f32:	00 00                	add    %al,(%eax)
 f34:	f2 04 00             	repnz add $0x0,%al
 f37:	00 13                	add    %dl,(%ebx)
 f39:	00 00                	add    %al,(%eax)
 f3b:	00 36                	add    %dh,(%esi)
 f3d:	00 00                	add    %al,(%eax)
 f3f:	00 01                	add    %al,(%ecx)
 f41:	80                   	.byte 0x80

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	01 11                	add    %edx,(%ecx)
   2:	00 10                	add    %dl,(%eax)
   4:	06                   	push   %es
   5:	11 01                	adc    %eax,(%ecx)
   7:	12 01                	adc    (%ecx),%al
   9:	03 0e                	add    (%esi),%ecx
   b:	1b 0e                	sbb    (%esi),%ecx
   d:	25 0e 13 05 00       	and    $0x5130e,%eax
  12:	00 00                	add    %al,(%eax)
  14:	01 11                	add    %edx,(%ecx)
  16:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
  1c:	0e                   	push   %cs
  1d:	1b 0e                	sbb    (%esi),%ecx
  1f:	11 01                	adc    %eax,(%ecx)
  21:	12 06                	adc    (%esi),%al
  23:	10 17                	adc    %dl,(%edi)
  25:	00 00                	add    %al,(%eax)
  27:	02 24 00             	add    (%eax,%eax,1),%ah
  2a:	0b 0b                	or     (%ebx),%ecx
  2c:	3e 0b 03             	or     %ds:(%ebx),%eax
  2f:	0e                   	push   %cs
  30:	00 00                	add    %al,(%eax)
  32:	03 16                	add    (%esi),%edx
  34:	00 03                	add    %al,(%ebx)
  36:	0e                   	push   %cs
  37:	3a 0b                	cmp    (%ebx),%cl
  39:	3b 0b                	cmp    (%ebx),%ecx
  3b:	39 0b                	cmp    %ecx,(%ebx)
  3d:	49                   	dec    %ecx
  3e:	13 00                	adc    (%eax),%eax
  40:	00 04 24             	add    %al,(%esp)
  43:	00 0b                	add    %cl,(%ebx)
  45:	0b 3e                	or     (%esi),%edi
  47:	0b 03                	or     (%ebx),%eax
  49:	08 00                	or     %al,(%eax)
  4b:	00 05 34 00 03 0e    	add    %al,0xe030034
  51:	3a 0b                	cmp    (%ebx),%cl
  53:	3b 0b                	cmp    (%ebx),%ecx
  55:	39 0b                	cmp    %ecx,(%ebx)
  57:	49                   	dec    %ecx
  58:	13 3f                	adc    (%edi),%edi
  5a:	19 02                	sbb    %eax,(%edx)
  5c:	18 00                	sbb    %al,(%eax)
  5e:	00 06                	add    %al,(%esi)
  60:	0f 00 0b             	str    (%ebx)
  63:	0b 49 13             	or     0x13(%ecx),%ecx
  66:	00 00                	add    %al,(%eax)
  68:	07                   	pop    %es
  69:	35 00 49 13 00       	xor    $0x134900,%eax
  6e:	00 08                	add    %cl,(%eax)
  70:	26 00 49 13          	add    %cl,%es:0x13(%ecx)
  74:	00 00                	add    %al,(%eax)
  76:	09 34 00             	or     %esi,(%eax,%eax,1)
  79:	03 08                	add    (%eax),%ecx
  7b:	3a 0b                	cmp    (%ebx),%cl
  7d:	3b 0b                	cmp    (%ebx),%ecx
  7f:	39 0b                	cmp    %ecx,(%ebx)
  81:	49                   	dec    %ecx
  82:	13 02                	adc    (%edx),%eax
  84:	18 00                	sbb    %al,(%eax)
  86:	00 0a                	add    %cl,(%edx)
  88:	01 01                	add    %eax,(%ecx)
  8a:	49                   	dec    %ecx
  8b:	13 01                	adc    (%ecx),%eax
  8d:	13 00                	adc    (%eax),%eax
  8f:	00 0b                	add    %cl,(%ebx)
  91:	21 00                	and    %eax,(%eax)
  93:	49                   	dec    %ecx
  94:	13 2f                	adc    (%edi),%ebp
  96:	0b 00                	or     (%eax),%eax
  98:	00 0c 34             	add    %cl,(%esp,%esi,1)
  9b:	00 03                	add    %al,(%ebx)
  9d:	0e                   	push   %cs
  9e:	3a 0b                	cmp    (%ebx),%cl
  a0:	3b 0b                	cmp    (%ebx),%ecx
  a2:	39 0b                	cmp    %ecx,(%ebx)
  a4:	49                   	dec    %ecx
  a5:	13 02                	adc    (%edx),%eax
  a7:	18 00                	sbb    %al,(%eax)
  a9:	00 0d 2e 01 3f 19    	add    %cl,0x193f012e
  af:	03 0e                	add    (%esi),%ecx
  b1:	3a 0b                	cmp    (%ebx),%cl
  b3:	3b 0b                	cmp    (%ebx),%ecx
  b5:	39 0b                	cmp    %ecx,(%ebx)
  b7:	27                   	daa    
  b8:	19 11                	sbb    %edx,(%ecx)
  ba:	01 12                	add    %edx,(%edx)
  bc:	06                   	push   %es
  bd:	40                   	inc    %eax
  be:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
  c4:	00 00                	add    %al,(%eax)
  c6:	0e                   	push   %cs
  c7:	05 00 03 08 3a       	add    $0x3a080300,%eax
  cc:	0b 3b                	or     (%ebx),%edi
  ce:	0b 39                	or     (%ecx),%edi
  d0:	0b 49 13             	or     0x13(%ecx),%ecx
  d3:	02 17                	add    (%edi),%dl
  d5:	b7 42                	mov    $0x42,%bh
  d7:	17                   	pop    %ss
  d8:	00 00                	add    %al,(%eax)
  da:	0f 05                	syscall 
  dc:	00 03                	add    %al,(%ebx)
  de:	0e                   	push   %cs
  df:	3a 0b                	cmp    (%ebx),%cl
  e1:	3b 0b                	cmp    (%ebx),%ecx
  e3:	39 0b                	cmp    %ecx,(%ebx)
  e5:	49                   	dec    %ecx
  e6:	13 02                	adc    (%edx),%eax
  e8:	18 00                	sbb    %al,(%eax)
  ea:	00 10                	add    %dl,(%eax)
  ec:	05 00 03 0e 3a       	add    $0x3a0e0300,%eax
  f1:	0b 3b                	or     (%ebx),%edi
  f3:	0b 39                	or     (%ecx),%edi
  f5:	0b 49 13             	or     0x13(%ecx),%ecx
  f8:	02 17                	add    (%edi),%dl
  fa:	b7 42                	mov    $0x42,%bh
  fc:	17                   	pop    %ss
  fd:	00 00                	add    %al,(%eax)
  ff:	11 05 00 03 08 3a    	adc    %eax,0x3a080300
 105:	0b 3b                	or     (%ebx),%edi
 107:	0b 39                	or     (%ecx),%edi
 109:	0b 49 13             	or     0x13(%ecx),%ecx
 10c:	02 18                	add    (%eax),%bl
 10e:	00 00                	add    %al,(%eax)
 110:	12 34 00             	adc    (%eax,%eax,1),%dh
 113:	03 0e                	add    (%esi),%ecx
 115:	3a 0b                	cmp    (%ebx),%cl
 117:	3b 0b                	cmp    (%ebx),%ecx
 119:	39 0b                	cmp    %ecx,(%ebx)
 11b:	49                   	dec    %ecx
 11c:	13 02                	adc    (%edx),%eax
 11e:	17                   	pop    %ss
 11f:	b7 42                	mov    $0x42,%bh
 121:	17                   	pop    %ss
 122:	00 00                	add    %al,(%eax)
 124:	13 89 82 01 00 11    	adc    0x11000182(%ecx),%ecx
 12a:	01 31                	add    %esi,(%ecx)
 12c:	13 00                	adc    (%eax),%eax
 12e:	00 14 1d 01 31 13 52 	add    %dl,0x52133101(,%ebx,1)
 135:	01 b8 42 0b 55 17    	add    %edi,0x17550b42(%eax)
 13b:	58                   	pop    %eax
 13c:	0b 59 0b             	or     0xb(%ecx),%ebx
 13f:	57                   	push   %edi
 140:	0b 01                	or     (%ecx),%eax
 142:	13 00                	adc    (%eax),%eax
 144:	00 15 1d 01 31 13    	add    %dl,0x1331011d
 14a:	52                   	push   %edx
 14b:	01 b8 42 0b 55 17    	add    %edi,0x17550b42(%eax)
 151:	58                   	pop    %eax
 152:	0b 59 0b             	or     0xb(%ecx),%ebx
 155:	57                   	push   %edi
 156:	0b 00                	or     (%eax),%eax
 158:	00 16                	add    %dl,(%esi)
 15a:	05 00 31 13 02       	add    $0x2133100,%eax
 15f:	17                   	pop    %ss
 160:	b7 42                	mov    $0x42,%bh
 162:	17                   	pop    %ss
 163:	00 00                	add    %al,(%eax)
 165:	17                   	pop    %ss
 166:	0b 01                	or     (%ecx),%eax
 168:	55                   	push   %ebp
 169:	17                   	pop    %ss
 16a:	00 00                	add    %al,(%eax)
 16c:	18 34 00             	sbb    %dh,(%eax,%eax,1)
 16f:	31 13                	xor    %edx,(%ebx)
 171:	02 17                	add    (%edi),%dl
 173:	b7 42                	mov    $0x42,%bh
 175:	17                   	pop    %ss
 176:	00 00                	add    %al,(%eax)
 178:	19 1d 01 31 13 52    	sbb    %ebx,0x52133101
 17e:	01 b8 42 0b 11 01    	add    %edi,0x1110b42(%eax)
 184:	12 06                	adc    (%esi),%al
 186:	58                   	pop    %eax
 187:	0b 59 0b             	or     0xb(%ecx),%ebx
 18a:	57                   	push   %edi
 18b:	0b 01                	or     (%ecx),%eax
 18d:	13 00                	adc    (%eax),%eax
 18f:	00 1a                	add    %bl,(%edx)
 191:	1d 01 31 13 52       	sbb    $0x52133101,%eax
 196:	01 b8 42 0b 11 01    	add    %edi,0x1110b42(%eax)
 19c:	12 06                	adc    (%esi),%al
 19e:	58                   	pop    %eax
 19f:	0b 59 0b             	or     0xb(%ecx),%ebx
 1a2:	57                   	push   %edi
 1a3:	0b 00                	or     (%eax),%eax
 1a5:	00 1b                	add    %bl,(%ebx)
 1a7:	0f 00 0b             	str    (%ebx)
 1aa:	0b 00                	or     (%eax),%eax
 1ac:	00 1c 2e             	add    %bl,(%esi,%ebp,1)
 1af:	00 03                	add    %al,(%ebx)
 1b1:	0e                   	push   %cs
 1b2:	3a 0b                	cmp    (%ebx),%cl
 1b4:	3b 0b                	cmp    (%ebx),%ecx
 1b6:	39 0b                	cmp    %ecx,(%ebx)
 1b8:	27                   	daa    
 1b9:	19 20                	sbb    %esp,(%eax)
 1bb:	0b 00                	or     (%eax),%eax
 1bd:	00 1d 34 00 03 08    	add    %bl,0x8030034
 1c3:	3a 0b                	cmp    (%ebx),%cl
 1c5:	3b 0b                	cmp    (%ebx),%ecx
 1c7:	39 0b                	cmp    %ecx,(%ebx)
 1c9:	49                   	dec    %ecx
 1ca:	13 02                	adc    (%edx),%eax
 1cc:	17                   	pop    %ss
 1cd:	b7 42                	mov    $0x42,%bh
 1cf:	17                   	pop    %ss
 1d0:	00 00                	add    %al,(%eax)
 1d2:	1e                   	push   %ds
 1d3:	89 82 01 00 11 01    	mov    %eax,0x1110001(%edx)
 1d9:	95                   	xchg   %eax,%ebp
 1da:	42                   	inc    %edx
 1db:	19 31                	sbb    %esi,(%ecx)
 1dd:	13 00                	adc    (%eax),%eax
 1df:	00 1f                	add    %bl,(%edi)
 1e1:	2e 01 3f             	add    %edi,%cs:(%edi)
 1e4:	19 03                	sbb    %eax,(%ebx)
 1e6:	0e                   	push   %cs
 1e7:	3a 0b                	cmp    (%ebx),%cl
 1e9:	3b 0b                	cmp    (%ebx),%ecx
 1eb:	39 0b                	cmp    %ecx,(%ebx)
 1ed:	27                   	daa    
 1ee:	19 49 13             	sbb    %ecx,0x13(%ecx)
 1f1:	11 01                	adc    %eax,(%ecx)
 1f3:	12 06                	adc    (%esi),%al
 1f5:	40                   	inc    %eax
 1f6:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
 1fc:	00 00                	add    %al,(%eax)
 1fe:	20 2e                	and    %ch,(%esi)
 200:	01 03                	add    %eax,(%ebx)
 202:	0e                   	push   %cs
 203:	3a 0b                	cmp    (%ebx),%cl
 205:	3b 0b                	cmp    (%ebx),%ecx
 207:	39 0b                	cmp    %ecx,(%ebx)
 209:	27                   	daa    
 20a:	19 20                	sbb    %esp,(%eax)
 20c:	0b 01                	or     (%ecx),%eax
 20e:	13 00                	adc    (%eax),%eax
 210:	00 21                	add    %ah,(%ecx)
 212:	05 00 03 0e 3a       	add    $0x3a0e0300,%eax
 217:	0b 3b                	or     (%ebx),%edi
 219:	0b 39                	or     (%ecx),%edi
 21b:	0b 49 13             	or     0x13(%ecx),%ecx
 21e:	00 00                	add    %al,(%eax)
 220:	22 05 00 03 08 3a    	and    0x3a080300,%al
 226:	0b 3b                	or     (%ebx),%edi
 228:	0b 39                	or     (%ecx),%edi
 22a:	0b 49 13             	or     0x13(%ecx),%ecx
 22d:	00 00                	add    %al,(%eax)
 22f:	23 2e                	and    (%esi),%ebp
 231:	01 03                	add    %eax,(%ebx)
 233:	08 3a                	or     %bh,(%edx)
 235:	0b 3b                	or     (%ebx),%edi
 237:	0b 39                	or     (%ecx),%edi
 239:	0b 27                	or     (%edi),%esp
 23b:	19 49 13             	sbb    %ecx,0x13(%ecx)
 23e:	20 0b                	and    %cl,(%ebx)
 240:	01 13                	add    %edx,(%ebx)
 242:	00 00                	add    %al,(%eax)
 244:	24 34                	and    $0x34,%al
 246:	00 03                	add    %al,(%ebx)
 248:	0e                   	push   %cs
 249:	3a 0b                	cmp    (%ebx),%cl
 24b:	3b 0b                	cmp    (%ebx),%ecx
 24d:	39 0b                	cmp    %ecx,(%ebx)
 24f:	49                   	dec    %ecx
 250:	13 00                	adc    (%eax),%eax
 252:	00 25 2e 01 03 0e    	add    %ah,0xe03012e
 258:	3a 0b                	cmp    (%ebx),%cl
 25a:	3b 0b                	cmp    (%ebx),%ecx
 25c:	39 0b                	cmp    %ecx,(%ebx)
 25e:	27                   	daa    
 25f:	19 20                	sbb    %esp,(%eax)
 261:	0b 00                	or     (%eax),%eax
 263:	00 00                	add    %al,(%eax)
 265:	01 11                	add    %edx,(%ecx)
 267:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
 26d:	0e                   	push   %cs
 26e:	1b 0e                	sbb    (%esi),%ecx
 270:	11 01                	adc    %eax,(%ecx)
 272:	12 06                	adc    (%esi),%al
 274:	10 17                	adc    %dl,(%edi)
 276:	00 00                	add    %al,(%eax)
 278:	02 24 00             	add    (%eax,%eax,1),%ah
 27b:	0b 0b                	or     (%ebx),%ecx
 27d:	3e 0b 03             	or     %ds:(%ebx),%eax
 280:	0e                   	push   %cs
 281:	00 00                	add    %al,(%eax)
 283:	03 16                	add    (%esi),%edx
 285:	00 03                	add    %al,(%ebx)
 287:	0e                   	push   %cs
 288:	3a 0b                	cmp    (%ebx),%cl
 28a:	3b 0b                	cmp    (%ebx),%ecx
 28c:	39 0b                	cmp    %ecx,(%ebx)
 28e:	49                   	dec    %ecx
 28f:	13 00                	adc    (%eax),%eax
 291:	00 04 24             	add    %al,(%esp)
 294:	00 0b                	add    %cl,(%ebx)
 296:	0b 3e                	or     (%esi),%edi
 298:	0b 03                	or     (%ebx),%eax
 29a:	08 00                	or     %al,(%eax)
 29c:	00 05 13 01 0b 0b    	add    %al,0xb0b0113
 2a2:	3a 0b                	cmp    (%ebx),%cl
 2a4:	3b 0b                	cmp    (%ebx),%ecx
 2a6:	39 0b                	cmp    %ecx,(%ebx)
 2a8:	01 13                	add    %edx,(%ebx)
 2aa:	00 00                	add    %al,(%eax)
 2ac:	06                   	push   %es
 2ad:	0d 00 03 0e 3a       	or     $0x3a0e0300,%eax
 2b2:	0b 3b                	or     (%ebx),%edi
 2b4:	0b 39                	or     (%ecx),%edi
 2b6:	0b 49 13             	or     0x13(%ecx),%ecx
 2b9:	38 0b                	cmp    %cl,(%ebx)
 2bb:	00 00                	add    %al,(%eax)
 2bd:	07                   	pop    %es
 2be:	0d 00 03 08 3a       	or     $0x3a080300,%eax
 2c3:	0b 3b                	or     (%ebx),%edi
 2c5:	0b 39                	or     (%ecx),%edi
 2c7:	0b 49 13             	or     0x13(%ecx),%ecx
 2ca:	38 0b                	cmp    %cl,(%ebx)
 2cc:	00 00                	add    %al,(%eax)
 2ce:	08 01                	or     %al,(%ecx)
 2d0:	01 49 13             	add    %ecx,0x13(%ecx)
 2d3:	01 13                	add    %edx,(%ebx)
 2d5:	00 00                	add    %al,(%eax)
 2d7:	09 21                	or     %esp,(%ecx)
 2d9:	00 49 13             	add    %cl,0x13(%ecx)
 2dc:	2f                   	das    
 2dd:	0b 00                	or     (%eax),%eax
 2df:	00 0a                	add    %cl,(%edx)
 2e1:	13 01                	adc    (%ecx),%eax
 2e3:	03 08                	add    (%eax),%ecx
 2e5:	0b 05 3a 0b 3b 0b    	or     0xb3b0b3a,%eax
 2eb:	39 0b                	cmp    %ecx,(%ebx)
 2ed:	01 13                	add    %edx,(%ebx)
 2ef:	00 00                	add    %al,(%eax)
 2f1:	0b 0d 00 03 0e 3a    	or     0x3a0e0300,%ecx
 2f7:	0b 3b                	or     (%ebx),%edi
 2f9:	0b 39                	or     (%ecx),%edi
 2fb:	0b 49 13             	or     0x13(%ecx),%ecx
 2fe:	38 05 00 00 0c 21    	cmp    %al,0x210c0000
 304:	00 49 13             	add    %cl,0x13(%ecx)
 307:	2f                   	das    
 308:	05 00 00 0d 13       	add    $0x130d0000,%eax
 30d:	01 03                	add    %eax,(%ebx)
 30f:	0e                   	push   %cs
 310:	0b 0b                	or     (%ebx),%ecx
 312:	3a 0b                	cmp    (%ebx),%cl
 314:	3b 0b                	cmp    (%ebx),%ecx
 316:	39 0b                	cmp    %ecx,(%ebx)
 318:	01 13                	add    %edx,(%ebx)
 31a:	00 00                	add    %al,(%eax)
 31c:	0e                   	push   %cs
 31d:	17                   	pop    %ss
 31e:	01 0b                	add    %ecx,(%ebx)
 320:	0b 3a                	or     (%edx),%edi
 322:	0b 3b                	or     (%ebx),%edi
 324:	0b 39                	or     (%ecx),%edi
 326:	0b 01                	or     (%ecx),%eax
 328:	13 00                	adc    (%eax),%eax
 32a:	00 0f                	add    %cl,(%edi)
 32c:	0d 00 03 0e 3a       	or     $0x3a0e0300,%eax
 331:	0b 3b                	or     (%ebx),%edi
 333:	0b 39                	or     (%ecx),%edi
 335:	0b 49 13             	or     0x13(%ecx),%ecx
 338:	00 00                	add    %al,(%eax)
 33a:	10 0d 00 03 08 3a    	adc    %cl,0x3a080300
 340:	0b 3b                	or     (%ebx),%edi
 342:	0b 39                	or     (%ecx),%edi
 344:	0b 49 13             	or     0x13(%ecx),%ecx
 347:	00 00                	add    %al,(%eax)
 349:	11 34 00             	adc    %esi,(%eax,%eax,1)
 34c:	03 0e                	add    (%esi),%ecx
 34e:	3a 0b                	cmp    (%ebx),%cl
 350:	3b 0b                	cmp    (%ebx),%ecx
 352:	39 0b                	cmp    %ecx,(%ebx)
 354:	49                   	dec    %ecx
 355:	13 3f                	adc    (%edi),%edi
 357:	19 02                	sbb    %eax,(%edx)
 359:	18 00                	sbb    %al,(%eax)
 35b:	00 12                	add    %dl,(%edx)
 35d:	2e 01 3f             	add    %edi,%cs:(%edi)
 360:	19 03                	sbb    %eax,(%ebx)
 362:	0e                   	push   %cs
 363:	3a 0b                	cmp    (%ebx),%cl
 365:	3b 0b                	cmp    (%ebx),%ecx
 367:	39 0b                	cmp    %ecx,(%ebx)
 369:	27                   	daa    
 36a:	19 49 13             	sbb    %ecx,0x13(%ecx)
 36d:	11 01                	adc    %eax,(%ecx)
 36f:	12 06                	adc    (%esi),%al
 371:	40                   	inc    %eax
 372:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
 378:	00 00                	add    %al,(%eax)
 37a:	13 05 00 03 0e 3a    	adc    0x3a0e0300,%eax
 380:	0b 3b                	or     (%ebx),%edi
 382:	0b 39                	or     (%ecx),%edi
 384:	0b 49 13             	or     0x13(%ecx),%ecx
 387:	02 18                	add    (%eax),%bl
 389:	00 00                	add    %al,(%eax)
 38b:	14 34                	adc    $0x34,%al
 38d:	00 03                	add    %al,(%ebx)
 38f:	08 3a                	or     %bh,(%edx)
 391:	0b 3b                	or     (%ebx),%edi
 393:	0b 39                	or     (%ecx),%edi
 395:	0b 49 13             	or     0x13(%ecx),%ecx
 398:	02 17                	add    (%edi),%dl
 39a:	b7 42                	mov    $0x42,%bh
 39c:	17                   	pop    %ss
 39d:	00 00                	add    %al,(%eax)
 39f:	15 34 00 03 0e       	adc    $0xe030034,%eax
 3a4:	3a 0b                	cmp    (%ebx),%cl
 3a6:	3b 0b                	cmp    (%ebx),%ecx
 3a8:	39 0b                	cmp    %ecx,(%ebx)
 3aa:	49                   	dec    %ecx
 3ab:	13 02                	adc    (%edx),%eax
 3ad:	17                   	pop    %ss
 3ae:	b7 42                	mov    $0x42,%bh
 3b0:	17                   	pop    %ss
 3b1:	00 00                	add    %al,(%eax)
 3b3:	16                   	push   %ss
 3b4:	89 82 01 00 11 01    	mov    %eax,0x1110001(%edx)
 3ba:	31 13                	xor    %edx,(%ebx)
 3bc:	00 00                	add    %al,(%eax)
 3be:	17                   	pop    %ss
 3bf:	0f 00 0b             	str    (%ebx)
 3c2:	0b 49 13             	or     0x13(%ecx),%ecx
 3c5:	00 00                	add    %al,(%eax)
 3c7:	18 2e                	sbb    %ch,(%esi)
 3c9:	01 3f                	add    %edi,(%edi)
 3cb:	19 03                	sbb    %eax,(%ebx)
 3cd:	0e                   	push   %cs
 3ce:	3a 0b                	cmp    (%ebx),%cl
 3d0:	3b 0b                	cmp    (%ebx),%ecx
 3d2:	39 0b                	cmp    %ecx,(%ebx)
 3d4:	27                   	daa    
 3d5:	19 11                	sbb    %edx,(%ecx)
 3d7:	01 12                	add    %edx,(%edx)
 3d9:	06                   	push   %es
 3da:	40                   	inc    %eax
 3db:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
 3e1:	00 00                	add    %al,(%eax)
 3e3:	19 05 00 03 08 3a    	sbb    %eax,0x3a080300
 3e9:	0b 3b                	or     (%ebx),%edi
 3eb:	0b 39                	or     (%ecx),%edi
 3ed:	0b 49 13             	or     0x13(%ecx),%ecx
 3f0:	02 17                	add    (%edi),%dl
 3f2:	b7 42                	mov    $0x42,%bh
 3f4:	17                   	pop    %ss
 3f5:	00 00                	add    %al,(%eax)
 3f7:	1a 05 00 03 08 3a    	sbb    0x3a080300,%al
 3fd:	0b 3b                	or     (%ebx),%edi
 3ff:	0b 39                	or     (%ecx),%edi
 401:	0b 49 13             	or     0x13(%ecx),%ecx
 404:	02 18                	add    (%eax),%bl
 406:	00 00                	add    %al,(%eax)
 408:	1b 89 82 01 00 11    	sbb    0x11000182(%ecx),%ecx
 40e:	01 95 42 19 31 13    	add    %edx,0x13311942(%ebp)
 414:	00 00                	add    %al,(%eax)
 416:	1c 2e                	sbb    $0x2e,%al
 418:	00 3f                	add    %bh,(%edi)
 41a:	19 3c 19             	sbb    %edi,(%ecx,%ebx,1)
 41d:	6e                   	outsb  %ds:(%esi),(%dx)
 41e:	0e                   	push   %cs
 41f:	03 0e                	add    (%esi),%ecx
 421:	3a 0b                	cmp    (%ebx),%cl
 423:	3b 0b                	cmp    (%ebx),%ecx
 425:	39 0b                	cmp    %ecx,(%ebx)
 427:	00 00                	add    %al,(%eax)
 429:	00 01                	add    %al,(%ecx)
 42b:	11 00                	adc    %eax,(%eax)
 42d:	10 06                	adc    %al,(%esi)
 42f:	11 01                	adc    %eax,(%ecx)
 431:	12 01                	adc    (%ecx),%al
 433:	03 0e                	add    (%esi),%ecx
 435:	1b 0e                	sbb    (%esi),%ecx
 437:	25 0e 13 05 00       	and    $0x5130e,%eax
 43c:	00 00                	add    %al,(%eax)

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	7c 00                	jl     2 <CR0_PE_ON+0x1>
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	29 00                	sub    %eax,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	01 01                	add    %eax,(%ecx)
   c:	fb                   	sti    
   d:	0e                   	push   %cs
   e:	0d 00 01 01 01       	or     $0x1010100,%eax
  13:	01 00                	add    %eax,(%eax)
  15:	00 00                	add    %al,(%eax)
  17:	01 00                	add    %eax,(%eax)
  19:	00 01                	add    %al,(%ecx)
  1b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  1e:	74 2f                	je     4f <PROT_MODE_DSEG+0x3f>
  20:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  23:	74 31                	je     56 <PROT_MODE_DSEG+0x46>
  25:	00 00                	add    %al,(%eax)
  27:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  2a:	74 31                	je     5d <PROT_MODE_DSEG+0x4d>
  2c:	2e 53                	cs push %ebx
  2e:	00 01                	add    %al,(%ecx)
  30:	00 00                	add    %al,(%eax)
  32:	00 00                	add    %al,(%eax)
  34:	05 02 00 7e 00       	add    $0x7e0002,%eax
  39:	00 03                	add    %al,(%ebx)
  3b:	29 01                	sub    %eax,(%ecx)
  3d:	21 24 2f             	and    %esp,(%edi,%ebp,1)
  40:	2f                   	das    
  41:	2f                   	das    
  42:	2f                   	das    
  43:	30 2f                	xor    %ch,(%edi)
  45:	2f                   	das    
  46:	2f                   	das    
  47:	2f                   	das    
  48:	34 3d                	xor    $0x3d,%al
  4a:	42                   	inc    %edx
  4b:	3d 67 3e 67 67       	cmp    $0x67673e67,%eax
  50:	30 2f                	xor    %ch,(%edi)
  52:	67 30 83 3d 4b       	xor    %al,0x4b3d(%bp,%di)
  57:	2f                   	das    
  58:	30 2f                	xor    %ch,(%edi)
  5a:	3d 2f 30 3d 3d       	cmp    $0x3d3d302f,%eax
  5f:	31 26                	xor    %esp,(%esi)
  61:	59                   	pop    %ecx
  62:	3d 4b 40 5c 4b       	cmp    $0x4b5c404b,%eax
  67:	2f                   	das    
  68:	2f                   	das    
  69:	2f                   	das    
  6a:	2f                   	das    
  6b:	34 59                	xor    $0x59,%al
  6d:	59                   	pop    %ecx
  6e:	59                   	pop    %ecx
  6f:	21 5b 27             	and    %ebx,0x27(%ebx)
  72:	21 30                	and    %esi,(%eax)
  74:	21 2f                	and    %ebp,(%edi)
  76:	2f                   	das    
  77:	2f                   	das    
  78:	30 21                	xor    %ah,(%ecx)
  7a:	02 fc                	add    %ah,%bh
  7c:	18 00                	sbb    %al,(%eax)
  7e:	01 01                	add    %eax,(%ecx)
  80:	29 04 00             	sub    %eax,(%eax,%eax,1)
  83:	00 02                	add    %al,(%edx)
  85:	00 3a                	add    %bh,(%edx)
  87:	00 00                	add    %al,(%eax)
  89:	00 01                	add    %al,(%ecx)
  8b:	01 fb                	add    %edi,%ebx
  8d:	0e                   	push   %cs
  8e:	0d 00 01 01 01       	or     $0x1010100,%eax
  93:	01 00                	add    %eax,(%eax)
  95:	00 00                	add    %al,(%eax)
  97:	01 00                	add    %eax,(%eax)
  99:	00 01                	add    %al,(%ecx)
  9b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  9e:	74 2f                	je     cf <PR_BOOTABLE+0x4f>
  a0:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  a3:	74 31                	je     d6 <PR_BOOTABLE+0x56>
  a5:	00 00                	add    %al,(%eax)
  a7:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  aa:	74 31                	je     dd <PR_BOOTABLE+0x5d>
  ac:	6c                   	insb   (%dx),%es:(%edi)
  ad:	69 62 2e 63 00 01 00 	imul   $0x10063,0x2e(%edx),%esp
  b4:	00 62 6f             	add    %ah,0x6f(%edx)
  b7:	6f                   	outsl  %ds:(%esi),(%dx)
  b8:	74 31                	je     eb <PR_BOOTABLE+0x6b>
  ba:	6c                   	insb   (%dx),%es:(%edi)
  bb:	69 62 2e 68 00 01 00 	imul   $0x10068,0x2e(%edx),%esp
  c2:	00 00                	add    %al,(%eax)
  c4:	05 01 00 05 02       	add    $0x2050001,%eax
  c9:	26 8b 00             	mov    %es:(%eax),%eax
  cc:	00 1a                	add    %bl,(%edx)
  ce:	05 05 13 05 01       	add    $0x1051305,%eax
  d3:	06                   	push   %es
  d4:	11 3c 05 08 3e 05 22 	adc    %edi,0x22053e08(,%eax,1)
  db:	3b 05 14 2e 05 05    	cmp    0x5052e14,%eax
  e1:	06                   	push   %es
  e2:	67 05 08 06 01 05    	addr16 add $0x5010608,%eax
  e8:	05 06 2f 05 0e       	add    $0xe052f06,%eax
  ed:	06                   	push   %es
  ee:	01 05 01 67 06 31    	add    %eax,0x31066701
  f4:	05 05 13 05 01       	add    $0x1051305,%eax
  f9:	06                   	push   %es
  fa:	11 05 0f 75 05 01    	adc    %eax,0x105750f
 100:	49                   	dec    %ecx
 101:	05 09 21 05 05       	add    $0x5052109,%eax
 106:	06                   	push   %es
 107:	3d 05 09 06 11       	cmp    $0x11060905,%eax
 10c:	05 0b 06 2f 05       	add    $0x52f060b,%eax
 111:	0c 06                	or     $0x6,%al
 113:	01 05 0b 90 05 09    	add    %eax,0x905900b
 119:	06                   	push   %es
 11a:	4b                   	dec    %ebx
 11b:	06                   	push   %es
 11c:	01 66 82             	add    %esp,-0x7e(%esi)
 11f:	05 01 77 58 06       	add    $0x6587701,%eax
 124:	36 05 05 13 05 01    	ss add $0x1051305,%eax
 12a:	06                   	push   %es
 12b:	11 05 15 59 05 05    	adc    %eax,0x5055915
 131:	58                   	pop    %eax
 132:	05 26 66 05 05       	add    $0x5056626,%eax
 137:	00 02                	add    %al,(%edx)
 139:	04 04                	add    $0x4,%al
 13b:	9e                   	sahf   
 13c:	00 02                	add    %al,(%edx)
 13e:	04 04                	add    $0x4,%al
 140:	06                   	push   %es
 141:	08 13                	or     %dl,(%ebx)
 143:	05 01 00 02 04       	add    $0x4020001,%eax
 148:	04 06                	add    $0x6,%al
 14a:	c9                   	leave  
 14b:	06                   	push   %es
 14c:	85 05 05 13 05 01    	test   %eax,0x1051305
 152:	06                   	push   %es
 153:	11 05 09 3d 05 01    	adc    %eax,0x1053d09
 159:	3d 05 09 1f 05       	cmp    $0x51f0905,%eax
 15e:	01 59 06             	add    %ebx,0x6(%ecx)
 161:	23 05 05 13 05 01    	and    0x1051305,%eax
 167:	06                   	push   %es
 168:	11 05 05 67 00 02    	adc    %eax,0x2006705
 16e:	04 01                	add    $0x1,%al
 170:	06                   	push   %es
 171:	08 13                	or     %dl,(%ebx)
 173:	05 09 00 02 04       	add    $0x4020009,%eax
 178:	01 13                	add    %edx,(%ebx)
 17a:	05 0b 00 02 04       	add    $0x402000b,%eax
 17f:	01 1f                	add    %ebx,(%edi)
 181:	05 01 03 11 2e       	add    $0x2e110301,%eax
 186:	05 05 13 14 05       	add    $0x5141305,%eax
 18b:	01 06                	add    %eax,(%esi)
 18d:	0f 05                	syscall 
 18f:	0c 23                	or     $0x23,%al
 191:	05 01 2b 2e 05       	add    $0x52e2b01,%eax
 196:	11 00                	adc    %eax,(%eax)
 198:	02 04 01             	add    (%ecx,%eax,1),%al
 19b:	06                   	push   %es
 19c:	3f                   	aas    
 19d:	05 05 00 02 04       	add    $0x4020005,%eax
 1a2:	01 06                	add    %eax,(%esi)
 1a4:	01 05 09 00 02 04    	add    %eax,0x4020009
 1aa:	03 06                	add    (%esi),%eax
 1ac:	67 05 0a 00 02 04    	addr16 add $0x402000a,%eax
 1b2:	03 06                	add    (%esi),%eax
 1b4:	01 05 1d 00 02 04    	add    %eax,0x402001d
 1ba:	03 06                	add    (%esi),%eax
 1bc:	1f                   	pop    %ds
 1bd:	00 02                	add    %al,(%edx)
 1bf:	04 03                	add    $0x3,%al
 1c1:	06                   	push   %es
 1c2:	01 05 01 31 06 32    	add    %eax,0x32063101
 1c8:	05 05 13 13 14       	add    $0x14131305,%eax
 1cd:	05 01 06 0e 58       	add    $0x580e0601,%eax
 1d2:	05 15 40 05 0c       	add    $0xc054015,%eax
 1d7:	ba 05 13 2e 05       	mov    $0x52e1305,%edx
 1dc:	24 00                	and    $0x0,%al
 1de:	02 04 01             	add    (%ecx,%eax,1),%al
 1e1:	06                   	push   %es
 1e2:	20 05 05 00 02 04    	and    %al,0x4020005
 1e8:	01 06                	add    %eax,(%esi)
 1ea:	01 05 09 00 02 04    	add    %eax,0x4020009
 1f0:	03 06                	add    (%esi),%eax
 1f2:	4b                   	dec    %ebx
 1f3:	05 0b 00 02 04       	add    $0x402000b,%eax
 1f8:	03 06                	add    (%esi),%eax
 1fa:	01 05 09 00 02 04    	add    %eax,0x4020009
 200:	03 06                	add    (%esi),%eax
 202:	4b                   	dec    %ebx
 203:	05 0e 00 02 04       	add    $0x402000e,%eax
 208:	03 06                	add    (%esi),%eax
 20a:	01 05 09 00 02 04    	add    %eax,0x4020009
 210:	03 06                	add    (%esi),%eax
 212:	67 05 0e 00 02 04    	addr16 add $0x402000e,%eax
 218:	03 06                	add    (%esi),%eax
 21a:	01 05 2c 00 02 04    	add    %eax,0x402002c
 220:	03 2b                	add    (%ebx),%ebp
 222:	05 0e 00 02 04       	add    $0x402000e,%eax
 227:	03 23                	add    (%ebx),%esp
 229:	05 2b 00 02 04       	add    $0x402002b,%eax
 22e:	03 06                	add    (%esi),%eax
 230:	39 05 31 00 02 04    	cmp    %eax,0x4020031
 236:	03 06                	add    (%esi),%eax
 238:	01 00                	add    %eax,(%eax)
 23a:	02 04 03             	add    (%ebx,%eax,1),%al
 23d:	20 05 01 33 06 78    	and    %al,0x78063301
 243:	05 05 13 14 05       	add    $0x5141305,%eax
 248:	01 06                	add    %eax,(%esi)
 24a:	0f ac 3c 05 05 00 02 	shrd   $0x1,%edi,0x4020005(,%eax,1)
 251:	04 01 
 253:	06                   	push   %es
 254:	08 6c 05 09          	or     %ch,0x9(%ebp,%eax,1)
 258:	00 02                	add    %al,(%edx)
 25a:	04 01                	add    $0x1,%al
 25c:	13 05 0c 00 02 04    	adc    0x402000c,%eax
 262:	01 06                	add    %eax,(%esi)
 264:	4a                   	dec    %edx
 265:	05 0d 00 02 04       	add    $0x402000d,%eax
 26a:	01 06                	add    %eax,(%esi)
 26c:	21 05 17 00 02 04    	and    %eax,0x4020017
 272:	01 06                	add    %eax,(%esi)
 274:	3b 05 05 00 02 04    	cmp    0x4020005,%eax
 27a:	01 91 06 4b 05 08    	add    %edx,0x8054b06(%ecx)
 280:	06                   	push   %es
 281:	01 05 09 06 4b 05    	add    %eax,0x54b0609
 287:	0c 06                	or     $0x6,%al
 289:	01 05 10 3c 05 0c    	add    %eax,0xc053c10
 28f:	4a                   	dec    %edx
 290:	05 05 06 3d 05       	add    $0x53d0605,%eax
 295:	0a 06                	or     (%esi),%al
 297:	01 05 05 06 4b 05    	add    %eax,0x54b0605
 29d:	01 06                	add    %eax,(%esi)
 29f:	3d 58 05 05 2d       	cmp    $0x2d050558,%eax
 2a4:	58                   	pop    %eax
 2a5:	05 01 06 00 05       	add    $0x5000601,%eax
 2aa:	02 85 8c 00 00 16    	add    0x1600008c(%ebp),%al
 2b0:	05 05 13 13 05       	add    $0x5131305,%eax
 2b5:	01 06                	add    %eax,(%esi)
 2b7:	10 05 05 68 05 01    	adc    %al,0x1056805
 2bd:	08 21                	or     %ah,(%ecx)
 2bf:	06                   	push   %es
 2c0:	5b                   	pop    %ebx
 2c1:	05 05 13 13 05       	add    $0x5131305,%eax
 2c6:	01 06                	add    %eax,(%esi)
 2c8:	10 05 05 68 05 01    	adc    %al,0x1056805
 2ce:	08 21                	or     %ah,(%ecx)
 2d0:	06                   	push   %es
 2d1:	03 47 58             	add    0x58(%edi),%eax
 2d4:	05 05 13 05 01       	add    $0x1051305,%eax
 2d9:	06                   	push   %es
 2da:	11 05 05 67 06 c9    	adc    %eax,0xc9066705
 2e0:	06                   	push   %es
 2e1:	74 05                	je     2e8 <PR_BOOTABLE+0x268>
 2e3:	01 3d 05 05 1f 05    	add    %edi,0x51f0505
 2e9:	01 06                	add    %eax,(%esi)
 2eb:	03 c4                	add    %esp,%eax
 2ed:	00 58 05             	add    %bl,0x5(%eax)
 2f0:	05 14 05 0d 03       	add    $0x30d0514,%eax
 2f5:	76 01                	jbe    2f8 <PR_BOOTABLE+0x278>
 2f7:	05 05 15 05 01       	add    $0x1051505,%eax
 2fc:	06                   	push   %es
 2fd:	17                   	pop    %ss
 2fe:	04 02                	add    $0x2,%al
 300:	05 05 03 ac 7f       	add    $0x7fac0305,%eax
 305:	4a                   	dec    %edx
 306:	04 01                	add    $0x1,%al
 308:	05 01 03 d4 00       	add    $0xd40301,%eax
 30d:	58                   	pop    %eax
 30e:	05 1a 06 38 05       	add    $0x538061a,%eax
 313:	0b 11                	or     (%ecx),%edx
 315:	04 02                	add    $0x2,%al
 317:	05 17 03 ae 7f       	add    $0x7fae0317,%eax
 31c:	01 05 05 14 13 3d    	add    %eax,0x3d131405
 322:	06                   	push   %es
 323:	01 04 01             	add    %eax,(%ecx,%eax,1)
 326:	05 0b 03 ce 00       	add    $0xce030b,%eax
 32b:	01 05 05 06 03 09    	add    %eax,0x9030605
 331:	74 04                	je     337 <PR_BOOTABLE+0x2b7>
 333:	02 05 14 03 9b 7f    	add    0x7f9b0314,%al
 339:	01 05 05 14 06 82    	add    %eax,0x82061405
 33f:	04 01                	add    $0x1,%al
 341:	06                   	push   %es
 342:	03 e4                	add    %esp,%esp
 344:	00 01                	add    %al,(%ecx)
 346:	04 02                	add    $0x2,%al
 348:	05 14 03 9a 7f       	add    $0x7f9a0314,%eax
 34d:	01 05 05 14 06 82    	add    %eax,0x82061405
 353:	04 01                	add    $0x1,%al
 355:	06                   	push   %es
 356:	03 e5                	add    %ebp,%esp
 358:	00 01                	add    %al,(%ecx)
 35a:	04 02                	add    $0x2,%al
 35c:	05 14 03 99 7f       	add    $0x7f990314,%eax
 361:	01 05 05 14 04 01    	add    %eax,0x1041405
 367:	05 18 06 03 e5       	add    $0xe5030618,%eax
 36c:	00 01                	add    %al,(%ecx)
 36e:	04 02                	add    $0x2,%al
 370:	05 05 03 9b 7f       	add    $0x7f9b0305,%eax
 375:	2e 04 01             	cs add $0x1,%al
 378:	05 18 03 e5 00       	add    $0xe50318,%eax
 37d:	58                   	pop    %eax
 37e:	04 02                	add    $0x2,%al
 380:	05 05 03 9b 7f       	add    $0x7f9b0305,%eax
 385:	3c 20                	cmp    $0x20,%al
 387:	04 01                	add    $0x1,%al
 389:	06                   	push   %es
 38a:	03 e6                	add    %esi,%esp
 38c:	00 01                	add    %al,(%ecx)
 38e:	04 02                	add    $0x2,%al
 390:	05 14 03 98 7f       	add    $0x7f980314,%eax
 395:	01 05 05 14 04 01    	add    %eax,0x1041405
 39b:	05 18 06 03 e6       	add    $0xe6030618,%eax
 3a0:	00 01                	add    %al,(%ecx)
 3a2:	04 02                	add    $0x2,%al
 3a4:	05 05 03 9a 7f       	add    $0x7f9a0305,%eax
 3a9:	2e 04 01             	cs add $0x1,%al
 3ac:	05 18 03 e6 00       	add    $0xe60318,%eax
 3b1:	58                   	pop    %eax
 3b2:	04 02                	add    $0x2,%al
 3b4:	05 05 03 9a 7f       	add    $0x7f9a0305,%eax
 3b9:	3c 20                	cmp    $0x20,%al
 3bb:	04 01                	add    $0x1,%al
 3bd:	06                   	push   %es
 3be:	03 e7                	add    %edi,%esp
 3c0:	00 01                	add    %al,(%ecx)
 3c2:	04 02                	add    $0x2,%al
 3c4:	05 14 03 97 7f       	add    $0x7f970314,%eax
 3c9:	01 05 05 14 04 01    	add    %eax,0x1041405
 3cf:	05 19 06 03 e7       	add    $0xe7030619,%eax
 3d4:	00 01                	add    %al,(%ecx)
 3d6:	04 02                	add    $0x2,%al
 3d8:	05 05 03 99 7f       	add    $0x7f990305,%eax
 3dd:	2e 04 01             	cs add $0x1,%al
 3e0:	05 19 03 e7 00       	add    $0xe70319,%eax
 3e5:	58                   	pop    %eax
 3e6:	05 20 3c 04 02       	add    $0x2043c20,%eax
 3eb:	05 05 03 99 7f       	add    $0x7f990305,%eax
 3f0:	3c 20                	cmp    $0x20,%al
 3f2:	04 01                	add    $0x1,%al
 3f4:	06                   	push   %es
 3f5:	03 e8                	add    %eax,%ebp
 3f7:	00 01                	add    %al,(%ecx)
 3f9:	04 02                	add    $0x2,%al
 3fb:	05 14 03 96 7f       	add    $0x7f960314,%eax
 400:	01 05 05 14 06 58    	add    %eax,0x58061405
 406:	04 01                	add    $0x1,%al
 408:	06                   	push   %es
 409:	03 eb                	add    %ebx,%ebp
 40b:	00 01                	add    %al,(%ecx)
 40d:	05 0d 03 6c 01       	add    $0x16c030d,%eax
 412:	04 02                	add    $0x2,%al
 414:	05 05 06 03 b4       	add    $0xb4030605,%eax
 419:	7f 01                	jg     41c <PR_BOOTABLE+0x39c>
 41b:	04 01                	add    $0x1,%al
 41d:	05 1a 06 03 d0       	add    $0xd003061a,%eax
 422:	00 58 05             	add    %bl,0x5(%eax)
 425:	0b 11                	or     (%ecx),%edx
 427:	04 02                	add    $0x2,%al
 429:	05 17 03 ae 7f       	add    $0x7fae0317,%eax
 42e:	01 05 05 14 13 21    	add    %eax,0x21131405
 434:	06                   	push   %es
 435:	01 04 01             	add    %eax,(%ecx,%eax,1)
 438:	05 0b 03 ce 00       	add    $0xce030b,%eax
 43d:	01 05 05 06 03 14    	add    %eax,0x14030605
 443:	74 04                	je     449 <PR_BOOTABLE+0x3c9>
 445:	02 05 14 03 a1 7f    	add    0x7fa10314,%al
 44b:	01 05 05 14 06 f2    	add    %eax,0xf2061405
 451:	04 01                	add    $0x1,%al
 453:	05 01 03 de 00       	add    $0xde0301,%eax
 458:	01 06                	add    %eax,(%esi)
 45a:	41                   	inc    %ecx
 45b:	05 05 13 14 05       	add    $0x5141305,%eax
 460:	01 06                	add    %eax,(%esi)
 462:	0f 90 05 05 06 40 05 	seto   0x5400605
 469:	16                   	push   %ss
 46a:	06                   	push   %es
 46b:	17                   	pop    %ss
 46c:	05 08 03 7a 3c       	add    $0x3c7a0308,%eax
 471:	05 16 34 05 08       	add    $0x8053416,%eax
 476:	39 05 0c 69 05 08    	cmp    %eax,0x805690c
 47c:	03 7a 3c             	add    0x3c(%edx),%edi
 47f:	05 0c 67 05 05       	add    $0x505670c,%eax
 484:	06                   	push   %es
 485:	3e 15 17 05 0b 01    	ds adc $0x10b0517,%eax
 48b:	05 09 4b 05 0f       	add    $0xf054b09,%eax
 490:	06                   	push   %es
 491:	3e 05 09 1e 05 0c    	ds add $0xc051e09,%eax
 497:	21 05 09 65 06 59    	and    %eax,0x59066509
 49d:	13 05 0f 06 01 05    	adc    0x501060f,%eax
 4a3:	01 5a 4a             	add    %ebx,0x4a(%edx)
 4a6:	20 20                	and    %ah,(%eax)
 4a8:	02 02                	add    (%edx),%al
 4aa:	00 01                	add    %al,(%ecx)
 4ac:	01 ba 01 00 00 02    	add    %edi,0x2000001(%edx)
 4b2:	00 3b                	add    %bh,(%ebx)
 4b4:	00 00                	add    %al,(%eax)
 4b6:	00 01                	add    %al,(%ecx)
 4b8:	01 fb                	add    %edi,%ebx
 4ba:	0e                   	push   %cs
 4bb:	0d 00 01 01 01       	or     $0x1010100,%eax
 4c0:	01 00                	add    %eax,(%eax)
 4c2:	00 00                	add    %al,(%eax)
 4c4:	01 00                	add    %eax,(%eax)
 4c6:	00 01                	add    %al,(%ecx)
 4c8:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4cb:	74 2f                	je     4fc <PR_BOOTABLE+0x47c>
 4cd:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4d0:	74 31                	je     503 <PR_BOOTABLE+0x483>
 4d2:	00 00                	add    %al,(%eax)
 4d4:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4d7:	74 31                	je     50a <PR_BOOTABLE+0x48a>
 4d9:	6d                   	insl   (%dx),%es:(%edi)
 4da:	61                   	popa   
 4db:	69 6e 2e 63 00 01 00 	imul   $0x10063,0x2e(%esi),%ebp
 4e2:	00 62 6f             	add    %ah,0x6f(%edx)
 4e5:	6f                   	outsl  %ds:(%esi),(%dx)
 4e6:	74 31                	je     519 <PR_BOOTABLE+0x499>
 4e8:	6c                   	insb   (%dx),%es:(%edi)
 4e9:	69 62 2e 68 00 01 00 	imul   $0x10068,0x2e(%edx),%esp
 4f0:	00 00                	add    %al,(%eax)
 4f2:	05 01 00 05 02       	add    $0x2050001,%eax
 4f7:	98                   	cwtl   
 4f8:	8d 00                	lea    (%eax),%eax
 4fa:	00 03                	add    %al,(%ebx)
 4fc:	2b 01                	sub    (%ecx),%eax
 4fe:	05 05 14 14 05       	add    $0x5141405,%eax
 503:	01 06                	add    %eax,(%esi)
 505:	0e                   	push   %cs
 506:	90                   	nop
 507:	05 05 40 06 08       	add    $0x8064005,%eax
 50c:	23 05 08 06 01 05    	and    0x5010608,%eax
 512:	09 06                	or     %eax,(%esi)
 514:	e5 05                	in     $0x5,%eax
 516:	05 f5 05 08 06       	add    $0x60805f5,%eax
 51b:	01 05 16 59 05 08    	add    %eax,0x8055916
 521:	73 05                	jae    528 <PR_BOOTABLE+0x4a8>
 523:	05 06 67 05 0e       	add    $0xe056706,%eax
 528:	06                   	push   %es
 529:	01 05 09 3c 05 05    	add    %eax,0x5053c09
 52f:	06                   	push   %es
 530:	30 05 0c 00 02 04    	xor    %al,0x402000c
 536:	01 01                	add    %eax,(%ecx)
 538:	05 05 00 02 04       	add    $0x4020005,%eax
 53d:	01 06                	add    %eax,(%esi)
 53f:	01 05 09 00 02 04    	add    %eax,0x4020009
 545:	02 06                	add    (%esi),%al
 547:	4b                   	dec    %ebx
 548:	05 18 00 02 04       	add    $0x4020018,%eax
 54d:	02 06                	add    (%esi),%al
 54f:	1f                   	pop    %ds
 550:	05 09 00 02 04       	add    $0x4020009,%eax
 555:	02 3d 05 16 00 02    	add    0x2001605,%bh
 55b:	04 02                	add    $0x2,%al
 55d:	06                   	push   %es
 55e:	d5 05                	aad    $0x5
 560:	18 00                	sbb    %al,(%eax)
 562:	02 04 02             	add    (%edx,%eax,1),%al
 565:	06                   	push   %es
 566:	01 05 05 06 5c 05    	add    %eax,0x55c0605
 56c:	1d 06 01 05 01       	sbb    $0x1050106,%eax
 571:	59                   	pop    %ecx
 572:	4a                   	dec    %edx
 573:	05 1d 1f 05 01       	add    $0x1051f1d,%eax
 578:	59                   	pop    %ecx
 579:	06                   	push   %es
 57a:	3f                   	aas    
 57b:	05 05 13 13 13       	add    $0x13131305,%eax
 580:	05 01 06 0f 58       	add    $0x580f0601,%eax
 585:	05 05 06 40 13       	add    $0x13400605,%eax
 58a:	05 0e 06 11 05       	add    $0x511060e,%eax
 58f:	05 2f 06 c9 05       	add    $0x5c9062f,%eax
 594:	0b 06                	or     (%esi),%eax
 596:	01 06                	add    %eax,(%esi)
 598:	3c 05                	cmp    $0x5,%al
 59a:	0d 06 01 05 0b       	or     $0xb050106,%eax
 59f:	4a                   	dec    %edx
 5a0:	05 09 06 83 05       	add    $0x5830609,%eax
 5a5:	12 06                	adc    (%esi),%al
 5a7:	3e 05 09 3a 06 67    	ds add $0x67063a09,%eax
 5ad:	13 05 12 06 01 05    	adc    0x5010612,%eax
 5b3:	1e                   	push   %ds
 5b4:	00 02                	add    %al,(%edx)
 5b6:	04 01                	add    $0x1,%al
 5b8:	55                   	push   %ebp
 5b9:	05 30 00 02 04       	add    $0x4020030,%eax
 5be:	02 9e 05 05 06 79    	add    0x79060505(%esi),%bl
 5c4:	05 1c 06 01 05       	add    $0x501061c,%eax
 5c9:	05 06 67 05 01       	add    $0x1056706,%eax
 5ce:	06                   	push   %es
 5cf:	14 05                	adc    $0x5,%al
 5d1:	1a 56 05             	sbb    0x5(%esi),%dl
 5d4:	05 06 67 05 01       	add    $0x1056706,%eax
 5d9:	06                   	push   %es
 5da:	13 4a 06             	adc    0x6(%edx),%ecx
 5dd:	03 bb 7f 3c 05 05    	add    0x5053c7f(%ebx),%edi
 5e3:	13 05 01 06 11 58    	adc    0x58110601,%eax
 5e9:	05 05 67 06 9f       	add    $0x9f066705,%eax
 5ee:	bd 13 13 05 11       	mov    $0x11051313,%ebp
 5f3:	01 05 05 06 0d 05    	add    %eax,0x50d0605
 5f9:	0c 41                	or     $0x41,%al
 5fb:	05 09 06 2f 05       	add    $0x52f0609,%eax
 600:	1e                   	push   %ds
 601:	06                   	push   %es
 602:	01 05 0c 58 05 0d    	add    %eax,0xd05580c
 608:	06                   	push   %es
 609:	9f                   	lahf   
 60a:	05 1a 06 01 05       	add    $0x501061a,%eax
 60f:	0d 06 75 05 05       	or     $0x5057506,%eax
 614:	16                   	push   %ss
 615:	05 18 00 02 04       	add    $0x4020018,%eax
 61a:	02 03                	add    (%ebx),%al
 61c:	79 2e                	jns    64c <PR_BOOTABLE+0x5cc>
 61e:	05 19 00 02 04       	add    $0x4020019,%eax
 623:	02 06                	add    (%esi),%al
 625:	01 05 11 00 02 04    	add    %eax,0x4020011
 62b:	02 06                	add    (%esi),%al
 62d:	20 05 05 00 02 04    	and    %al,0x4020005
 633:	02 06                	add    (%esi),%al
 635:	01 06                	add    %eax,(%esi)
 637:	5f                   	pop    %edi
 638:	05 09 13 05 0e       	add    $0xe051309,%eax
 63d:	06                   	push   %es
 63e:	03 77 3c             	add    0x3c(%edi),%esi
 641:	05 09 03 09 2e       	add    $0x2e090309,%eax
 646:	9e                   	sahf   
 647:	05 05 06 3e 92       	add    $0x923e0605,%eax
 64c:	bb 05 16 06 01       	mov    $0x1061605,%ebx
 651:	05 05 84 05 16       	add    $0x16058405,%eax
 656:	72 05                	jb     65d <PR_BOOTABLE+0x5dd>
 658:	05 06 30 5a ca       	add    $0xca5a3006,%eax
 65d:	06                   	push   %es
 65e:	74 05                	je     665 <PR_BOOTABLE+0x5e5>
 660:	01 3e                	add    %edi,(%esi)
 662:	4a                   	dec    %edx
 663:	05 05 2c 02 05       	add    $0x5022c05,%eax
 668:	00 01                	add    %al,(%ecx)
 66a:	01 46 00             	add    %eax,0x0(%esi)
 66d:	00 00                	add    %al,(%eax)
 66f:	02 00                	add    (%eax),%al
 671:	2f                   	das    
 672:	00 00                	add    %al,(%eax)
 674:	00 01                	add    %al,(%ecx)
 676:	01 fb                	add    %edi,%ebx
 678:	0e                   	push   %cs
 679:	0d 00 01 01 01       	or     $0x1010100,%eax
 67e:	01 00                	add    %eax,(%eax)
 680:	00 00                	add    %al,(%eax)
 682:	01 00                	add    %eax,(%eax)
 684:	00 01                	add    %al,(%ecx)
 686:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 689:	74 2f                	je     6ba <PR_BOOTABLE+0x63a>
 68b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 68e:	74 31                	je     6c1 <PR_BOOTABLE+0x641>
 690:	00 00                	add    %al,(%eax)
 692:	65 78 65             	gs js  6fa <PR_BOOTABLE+0x67a>
 695:	63 5f 6b             	arpl   %bx,0x6b(%edi)
 698:	65 72 6e             	gs jb  709 <PR_BOOTABLE+0x689>
 69b:	65 6c                	gs insb (%dx),%es:(%edi)
 69d:	2e 53                	cs push %ebx
 69f:	00 01                	add    %al,(%ecx)
 6a1:	00 00                	add    %al,(%eax)
 6a3:	00 00                	add    %al,(%eax)
 6a5:	05 02 1c 8f 00       	add    $0x8f1c02,%eax
 6aa:	00 17                	add    %dl,(%edi)
 6ac:	21 59 4b             	and    %ebx,0x4b(%ecx)
 6af:	4b                   	dec    %ebx
 6b0:	02 02                	add    (%edx),%al
 6b2:	00 01                	add    %al,(%ecx)
 6b4:	01                   	.byte 0x1

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   3:	74 2f                	je     34 <PROT_MODE_DSEG+0x24>
   5:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   8:	74 31                	je     3b <PROT_MODE_DSEG+0x2b>
   a:	2f                   	das    
   b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
   e:	74 31                	je     41 <PROT_MODE_DSEG+0x31>
  10:	2e 53                	cs push %ebx
  12:	00 2f                	add    %ch,(%edi)
  14:	68 6f 6d 65 2f       	push   $0x2f656d6f
  19:	61                   	popa   
  1a:	63 63 74             	arpl   %sp,0x74(%ebx)
  1d:	73 2f                	jae    4e <PROT_MODE_DSEG+0x3e>
  1f:	6a 73                	push   $0x73
  21:	33 38                	xor    (%eax),%edi
  23:	39 36                	cmp    %esi,(%esi)
  25:	2f                   	das    
  26:	63 73 34             	arpl   %si,0x34(%ebx)
  29:	32 32                	xor    (%edx),%dh
  2b:	2f                   	das    
  2c:	6d                   	insl   (%dx),%es:(%edi)
  2d:	63 65 72             	arpl   %sp,0x72(%ebp)
  30:	74 69                	je     9b <PR_BOOTABLE+0x1b>
  32:	6b 6f 73 00          	imul   $0x0,0x73(%edi),%ebp
  36:	47                   	inc    %edi
  37:	4e                   	dec    %esi
  38:	55                   	push   %ebp
  39:	20 41 53             	and    %al,0x53(%ecx)
  3c:	20 32                	and    %dh,(%edx)
  3e:	2e 33 31             	xor    %cs:(%ecx),%esi
  41:	2e 31 00             	xor    %eax,%cs:(%eax)
  44:	65 6e                	outsb  %gs:(%esi),(%dx)
  46:	64 5f                	fs pop %edi
  48:	76 61                	jbe    ab <PR_BOOTABLE+0x2b>
  4a:	00 77 61             	add    %dh,0x61(%edi)
  4d:	69 74 64 69 73 6b 00 	imul   $0x70006b73,0x69(%esp,%eiz,2),%esi
  54:	70 
  55:	75 74                	jne    cb <PR_BOOTABLE+0x4b>
  57:	6c                   	insb   (%dx),%es:(%edi)
  58:	69 6e 65 00 73 68 6f 	imul   $0x6f687300,0x65(%esi),%ebp
  5f:	72 74                	jb     d5 <PR_BOOTABLE+0x55>
  61:	20 69 6e             	and    %ch,0x6e(%ecx)
  64:	74 00                	je     66 <PROT_MODE_DSEG+0x56>
  66:	63 6f 6c             	arpl   %bp,0x6c(%edi)
  69:	6f                   	outsl  %ds:(%esi),(%dx)
  6a:	72 00                	jb     6c <PROT_MODE_DSEG+0x5c>
  6c:	72 6f                	jb     dd <PR_BOOTABLE+0x5d>
  6e:	6c                   	insb   (%dx),%es:(%edi)
  6f:	6c                   	insb   (%dx),%es:(%edi)
  70:	00 73 74             	add    %dh,0x74(%ebx)
  73:	72 69                	jb     de <PR_BOOTABLE+0x5e>
  75:	6e                   	outsb  %ds:(%esi),(%dx)
  76:	67 00 70 61          	add    %dh,0x61(%bx,%si)
  7a:	6e                   	outsb  %ds:(%esi),(%dx)
  7b:	69 63 00 70 75 74 69 	imul   $0x69747570,0x0(%ebx),%esp
  82:	00 72 65             	add    %dh,0x65(%edx)
  85:	61                   	popa   
  86:	64 73 65             	fs jae ee <PR_BOOTABLE+0x6e>
  89:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
  8d:	00 62 6f             	add    %ah,0x6f(%edx)
  90:	6f                   	outsl  %ds:(%esi),(%dx)
  91:	74 2f                	je     c2 <PR_BOOTABLE+0x42>
  93:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  96:	74 31                	je     c9 <PR_BOOTABLE+0x49>
  98:	2f                   	das    
  99:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  9c:	74 31                	je     cf <PR_BOOTABLE+0x4f>
  9e:	6c                   	insb   (%dx),%es:(%edi)
  9f:	69 62 2e 63 00 75 69 	imul   $0x69750063,0x2e(%edx),%esp
  a6:	6e                   	outsb  %ds:(%esi),(%dx)
  a7:	74 38                	je     e1 <PR_BOOTABLE+0x61>
  a9:	5f                   	pop    %edi
  aa:	74 00                	je     ac <PR_BOOTABLE+0x2c>
  ac:	6f                   	outsl  %ds:(%esi),(%dx)
  ad:	75 74                	jne    123 <PR_BOOTABLE+0xa3>
  af:	62 00                	bound  %eax,(%eax)
  b1:	69 6e 73 6c 00 6c 6f 	imul   $0x6f6c006c,0x73(%esi),%ebp
  b8:	6e                   	outsb  %ds:(%esi),(%dx)
  b9:	67 20 6c 6f          	and    %ch,0x6f(%si)
  bd:	6e                   	outsb  %ds:(%esi),(%dx)
  be:	67 20 69 6e          	and    %ch,0x6e(%bx,%di)
  c2:	74 00                	je     c4 <PR_BOOTABLE+0x44>
  c4:	72 65                	jb     12b <PR_BOOTABLE+0xab>
  c6:	61                   	popa   
  c7:	64 73 65             	fs jae 12f <PR_BOOTABLE+0xaf>
  ca:	63 74 69 6f          	arpl   %si,0x6f(%ecx,%ebp,2)
  ce:	6e                   	outsb  %ds:(%esi),(%dx)
  cf:	00 69 74             	add    %ch,0x74(%ecx)
  d2:	6f                   	outsl  %ds:(%esi),(%dx)
  d3:	61                   	popa   
  d4:	00 75 6e             	add    %dh,0x6e(%ebp)
  d7:	73 69                	jae    142 <PR_BOOTABLE+0xc2>
  d9:	67 6e                	outsb  %ds:(%si),(%dx)
  db:	65 64 20 63 68       	gs and %ah,%fs:0x68(%ebx)
  e0:	61                   	popa   
  e1:	72 00                	jb     e3 <PR_BOOTABLE+0x63>
  e3:	69 74 6f 68 00 70 75 	imul   $0x74757000,0x68(%edi,%ebp,2),%esi
  ea:	74 
  eb:	63 00                	arpl   %ax,(%eax)
  ed:	47                   	inc    %edi
  ee:	4e                   	dec    %esi
  ef:	55                   	push   %ebp
  f0:	20 43 31             	and    %al,0x31(%ebx)
  f3:	37                   	aaa    
  f4:	20 39                	and    %bh,(%ecx)
  f6:	2e 32 2e             	xor    %cs:(%esi),%ch
  f9:	31 20                	xor    %esp,(%eax)
  fb:	32 30                	xor    (%eax),%dh
  fd:	31 39                	xor    %edi,(%ecx)
  ff:	30 38                	xor    %bh,(%eax)
 101:	32 37                	xor    (%edi),%dh
 103:	20 28                	and    %ch,(%eax)
 105:	52                   	push   %edx
 106:	65 64 20 48 61       	gs and %cl,%fs:0x61(%eax)
 10b:	74 20                	je     12d <PR_BOOTABLE+0xad>
 10d:	39 2e                	cmp    %ebp,(%esi)
 10f:	32 2e                	xor    (%esi),%ch
 111:	31 2d 31 29 20 2d    	xor    %ebp,0x2d202931
 117:	6d                   	insl   (%dx),%es:(%edi)
 118:	33 32                	xor    (%edx),%esi
 11a:	20 2d 6d 74 75 6e    	and    %ch,0x6e75746d
 120:	65 3d 67 65 6e 65    	gs cmp $0x656e6567,%eax
 126:	72 69                	jb     191 <PR_BOOTABLE+0x111>
 128:	63 20                	arpl   %sp,(%eax)
 12a:	2d 6d 61 72 63       	sub    $0x6372616d,%eax
 12f:	68 3d 69 36 38       	push   $0x3836693d
 134:	36 20 2d 67 20 2d 4f 	and    %ch,%ss:0x4f2d2067
 13b:	73 20                	jae    15d <PR_BOOTABLE+0xdd>
 13d:	2d 4f 73 20 2d       	sub    $0x2d20734f,%eax
 142:	66 6e                	data16 outsb %ds:(%esi),(%dx)
 144:	6f                   	outsl  %ds:(%esi),(%dx)
 145:	2d 62 75 69 6c       	sub    $0x6c697562,%eax
 14a:	74 69                	je     1b5 <PR_BOOTABLE+0x135>
 14c:	6e                   	outsb  %ds:(%esi),(%dx)
 14d:	20 2d 66 6e 6f 2d    	and    %ch,0x2d6f6e66
 153:	73 74                	jae    1c9 <PR_BOOTABLE+0x149>
 155:	61                   	popa   
 156:	63 6b 2d             	arpl   %bp,0x2d(%ebx)
 159:	70 72                	jo     1cd <PR_BOOTABLE+0x14d>
 15b:	6f                   	outsl  %ds:(%esi),(%dx)
 15c:	74 65                	je     1c3 <PR_BOOTABLE+0x143>
 15e:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
 162:	00 6c 6f 6e          	add    %ch,0x6e(%edi,%ebp,2)
 166:	67 20 6c 6f          	and    %ch,0x6f(%si)
 16a:	6e                   	outsb  %ds:(%esi),(%dx)
 16b:	67 20 75 6e          	and    %dh,0x6e(%di)
 16f:	73 69                	jae    1da <PR_BOOTABLE+0x15a>
 171:	67 6e                	outsb  %ds:(%si),(%dx)
 173:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 178:	74 00                	je     17a <PR_BOOTABLE+0xfa>
 17a:	75 69                	jne    1e5 <PR_BOOTABLE+0x165>
 17c:	6e                   	outsb  %ds:(%esi),(%dx)
 17d:	74 33                	je     1b2 <PR_BOOTABLE+0x132>
 17f:	32 5f 74             	xor    0x74(%edi),%bl
 182:	00 69 74             	add    %ch,0x74(%ecx)
 185:	6f                   	outsl  %ds:(%esi),(%dx)
 186:	78 00                	js     188 <PR_BOOTABLE+0x108>
 188:	70 75                	jo     1ff <PR_BOOTABLE+0x17f>
 18a:	74 73                	je     1ff <PR_BOOTABLE+0x17f>
 18c:	00 73 68             	add    %dh,0x68(%ebx)
 18f:	6f                   	outsl  %ds:(%esi),(%dx)
 190:	72 74                	jb     206 <PR_BOOTABLE+0x186>
 192:	20 75 6e             	and    %dh,0x6e(%ebp)
 195:	73 69                	jae    200 <PR_BOOTABLE+0x180>
 197:	67 6e                	outsb  %ds:(%si),(%dx)
 199:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 19e:	74 00                	je     1a0 <PR_BOOTABLE+0x120>
 1a0:	73 74                	jae    216 <PR_BOOTABLE+0x196>
 1a2:	72 6c                	jb     210 <PR_BOOTABLE+0x190>
 1a4:	65 6e                	outsb  %gs:(%esi),(%dx)
 1a6:	00 64 61 74          	add    %ah,0x74(%ecx,%eiz,2)
 1aa:	61                   	popa   
 1ab:	00 70 6f             	add    %dh,0x6f(%eax)
 1ae:	72 74                	jb     224 <PR_BOOTABLE+0x1a4>
 1b0:	00 73 69             	add    %dh,0x69(%ebx)
 1b3:	67 6e                	outsb  %ds:(%si),(%dx)
 1b5:	00 72 65             	add    %dh,0x65(%edx)
 1b8:	76 65                	jbe    21f <PR_BOOTABLE+0x19f>
 1ba:	72 73                	jb     22f <PR_BOOTABLE+0x1af>
 1bc:	65 00 70 75          	add    %dh,%gs:0x75(%eax)
 1c0:	74 69                	je     22b <PR_BOOTABLE+0x1ab>
 1c2:	5f                   	pop    %edi
 1c3:	73 74                	jae    239 <PR_BOOTABLE+0x1b9>
 1c5:	72 00                	jb     1c7 <PR_BOOTABLE+0x147>
 1c7:	62 6c 61 6e          	bound  %ebp,0x6e(%ecx,%eiz,2)
 1cb:	6b 00 72             	imul   $0x72,(%eax),%eax
 1ce:	6f                   	outsl  %ds:(%esi),(%dx)
 1cf:	6f                   	outsl  %ds:(%esi),(%dx)
 1d0:	74 00                	je     1d2 <PR_BOOTABLE+0x152>
 1d2:	76 69                	jbe    23d <PR_BOOTABLE+0x1bd>
 1d4:	64 65 6f             	fs outsl %gs:(%esi),(%dx)
 1d7:	00 64 69 73          	add    %ah,0x73(%ecx,%ebp,2)
 1db:	6b 5f 73 69          	imul   $0x69,0x73(%edi),%ebx
 1df:	67 00 65 6c          	add    %ah,0x6c(%di)
 1e3:	66 68 64 66          	pushw  $0x6664
 1e7:	00 65 5f             	add    %ah,0x5f(%ebp)
 1ea:	73 68                	jae    254 <PR_BOOTABLE+0x1d4>
 1ec:	73 74                	jae    262 <PR_BOOTABLE+0x1e2>
 1ee:	72 6e                	jb     25e <PR_BOOTABLE+0x1de>
 1f0:	64 78 00             	fs js  1f3 <PR_BOOTABLE+0x173>
 1f3:	6d                   	insl   (%dx),%es:(%edi)
 1f4:	6d                   	insl   (%dx),%es:(%edi)
 1f5:	61                   	popa   
 1f6:	70 5f                	jo     257 <PR_BOOTABLE+0x1d7>
 1f8:	61                   	popa   
 1f9:	64 64 72 00          	fs fs jb 1fd <PR_BOOTABLE+0x17d>
 1fd:	65 6c                	gs insb (%dx),%es:(%edi)
 1ff:	66 68 64 72          	pushw  $0x7264
 203:	00 76 62             	add    %dh,0x62(%esi)
 206:	65 5f                	gs pop %edi
 208:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 20f:	63 65 5f             	arpl   %sp,0x5f(%ebp)
 212:	6f                   	outsl  %ds:(%esi),(%dx)
 213:	66 66 00 65 5f       	data16 data16 add %ah,0x5f(%ebp)
 218:	65 6e                	outsb  %gs:(%esi),(%dx)
 21a:	74 72                	je     28e <PR_BOOTABLE+0x20e>
 21c:	79 00                	jns    21e <PR_BOOTABLE+0x19e>
 21e:	75 69                	jne    289 <PR_BOOTABLE+0x209>
 220:	6e                   	outsb  %ds:(%esi),(%dx)
 221:	74 36                	je     259 <PR_BOOTABLE+0x1d9>
 223:	34 5f                	xor    $0x5f,%al
 225:	74 00                	je     227 <PR_BOOTABLE+0x1a7>
 227:	6c                   	insb   (%dx),%es:(%edi)
 228:	6f                   	outsl  %ds:(%esi),(%dx)
 229:	61                   	popa   
 22a:	64 5f                	fs pop %edi
 22c:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
 230:	65 6c                	gs insb (%dx),%es:(%edi)
 232:	00 70 5f             	add    %dh,0x5f(%eax)
 235:	6f                   	outsl  %ds:(%esi),(%dx)
 236:	66 66 73 65          	data16 data16 jae 29f <PR_BOOTABLE+0x21f>
 23a:	74 00                	je     23c <PR_BOOTABLE+0x1bc>
 23c:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 23f:	74 6c                	je     2ad <PR_BOOTABLE+0x22d>
 241:	6f                   	outsl  %ds:(%esi),(%dx)
 242:	61                   	popa   
 243:	64 65 72 00          	fs gs jb 247 <PR_BOOTABLE+0x1c7>
 247:	65 5f                	gs pop %edi
 249:	66 6c                	data16 insb (%dx),%es:(%edi)
 24b:	61                   	popa   
 24c:	67 73 00             	addr16 jae 24f <PR_BOOTABLE+0x1cf>
 24f:	63 6d 64             	arpl   %bp,0x64(%ebp)
 252:	6c                   	insb   (%dx),%es:(%edi)
 253:	69 6e 65 00 65 5f 6d 	imul   $0x6d5f6500,0x65(%esi),%ebp
 25a:	61                   	popa   
 25b:	63 68 69             	arpl   %bp,0x69(%eax)
 25e:	6e                   	outsb  %ds:(%esi),(%dx)
 25f:	65 00 65 5f          	add    %ah,%gs:0x5f(%ebp)
 263:	70 68                	jo     2cd <PR_BOOTABLE+0x24d>
 265:	65 6e                	outsb  %gs:(%esi),(%dx)
 267:	74 73                	je     2dc <PR_BOOTABLE+0x25c>
 269:	69 7a 65 00 65 78 65 	imul   $0x65786500,0x65(%edx),%edi
 270:	63 5f 6b             	arpl   %bx,0x6b(%edi)
 273:	65 72 6e             	gs jb  2e4 <PR_BOOTABLE+0x264>
 276:	65 6c                	gs insb (%dx),%es:(%edi)
 278:	00 6d 6f             	add    %ch,0x6f(%ebp)
 27b:	64 73 5f             	fs jae 2dd <PR_BOOTABLE+0x25d>
 27e:	61                   	popa   
 27f:	64 64 72 00          	fs fs jb 283 <PR_BOOTABLE+0x203>
 283:	73 74                	jae    2f9 <PR_BOOTABLE+0x279>
 285:	72 73                	jb     2fa <PR_BOOTABLE+0x27a>
 287:	69 7a 65 00 70 61 72 	imul   $0x72617000,0x65(%edx),%edi
 28e:	74 33                	je     2c3 <PR_BOOTABLE+0x243>
 290:	00 70 5f             	add    %dh,0x5f(%eax)
 293:	74 79                	je     30e <PR_BOOTABLE+0x28e>
 295:	70 65                	jo     2fc <PR_BOOTABLE+0x27c>
 297:	00 70 72             	add    %dh,0x72(%eax)
 29a:	6f                   	outsl  %ds:(%esi),(%dx)
 29b:	67 68 64 72 00 65    	addr16 push $0x65007264
 2a1:	5f                   	pop    %edi
 2a2:	73 68                	jae    30c <PR_BOOTABLE+0x28c>
 2a4:	65 6e                	outsb  %gs:(%esi),(%dx)
 2a6:	74 73                	je     31b <PR_BOOTABLE+0x29b>
 2a8:	69 7a 65 00 73 68 6e 	imul   $0x6e687300,0x65(%edx),%edi
 2af:	64 78 00             	fs js  2b2 <PR_BOOTABLE+0x232>
 2b2:	6d                   	insl   (%dx),%es:(%edi)
 2b3:	62 72 5f             	bound  %esi,0x5f(%edx)
 2b6:	74 00                	je     2b8 <PR_BOOTABLE+0x238>
 2b8:	65 5f                	gs pop %edi
 2ba:	74 79                	je     335 <PR_BOOTABLE+0x2b5>
 2bc:	70 65                	jo     323 <PR_BOOTABLE+0x2a3>
 2be:	00 64 72 69          	add    %ah,0x69(%edx,%esi,2)
 2c2:	76 65                	jbe    329 <PR_BOOTABLE+0x2a9>
 2c4:	73 5f                	jae    325 <PR_BOOTABLE+0x2a5>
 2c6:	61                   	popa   
 2c7:	64 64 72 00          	fs fs jb 2cb <PR_BOOTABLE+0x24b>
 2cb:	65 5f                	gs pop %edi
 2cd:	65 68 73 69 7a 65    	gs push $0x657a6973
 2d3:	00 70 61             	add    %dh,0x61(%eax)
 2d6:	72 74                	jb     34c <PR_BOOTABLE+0x2cc>
 2d8:	69 74 69 6f 6e 00 62 	imul   $0x6962006e,0x6f(%ecx,%ebp,2),%esi
 2df:	69 
 2e0:	6f                   	outsl  %ds:(%esi),(%dx)
 2e1:	73 5f                	jae    342 <PR_BOOTABLE+0x2c2>
 2e3:	73 6d                	jae    352 <PR_BOOTABLE+0x2d2>
 2e5:	61                   	popa   
 2e6:	70 5f                	jo     347 <PR_BOOTABLE+0x2c7>
 2e8:	74 00                	je     2ea <PR_BOOTABLE+0x26a>
 2ea:	6d                   	insl   (%dx),%es:(%edi)
 2eb:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2ee:	74 5f                	je     34f <PR_BOOTABLE+0x2cf>
 2f0:	69 6e 66 6f 5f 74 00 	imul   $0x745f6f,0x66(%esi),%ebp
 2f7:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2fa:	74 61                	je     35d <PR_BOOTABLE+0x2dd>
 2fc:	62 6c 65 5f          	bound  %ebp,0x5f(%ebp,%eiz,2)
 300:	6c                   	insb   (%dx),%es:(%edi)
 301:	62 61 00             	bound  %esp,0x0(%ecx)
 304:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 307:	74 31                	je     33a <PR_BOOTABLE+0x2ba>
 309:	6d                   	insl   (%dx),%es:(%edi)
 30a:	61                   	popa   
 30b:	69 6e 00 65 5f 76 65 	imul   $0x65765f65,0x0(%esi),%ebp
 312:	72 73                	jb     387 <PR_BOOTABLE+0x307>
 314:	69 6f 6e 00 70 61 72 	imul   $0x72617000,0x6e(%edi),%ebp
 31b:	74 31                	je     34e <PR_BOOTABLE+0x2ce>
 31d:	00 70 61             	add    %dh,0x61(%eax)
 320:	72 74                	jb     396 <PR_BOOTABLE+0x316>
 322:	32 00                	xor    (%eax),%al
 324:	64 72 69             	fs jb  390 <PR_BOOTABLE+0x310>
 327:	76 65                	jbe    38e <PR_BOOTABLE+0x30e>
 329:	72 00                	jb     32b <PR_BOOTABLE+0x2ab>
 32b:	66 69 72 73 74 5f    	imul   $0x5f74,0x73(%edx),%si
 331:	63 68 73             	arpl   %bp,0x73(%eax)
 334:	00 62 69             	add    %ah,0x69(%edx)
 337:	6f                   	outsl  %ds:(%esi),(%dx)
 338:	73 5f                	jae    399 <PR_BOOTABLE+0x319>
 33a:	73 6d                	jae    3a9 <PR_BOOTABLE+0x329>
 33c:	61                   	popa   
 33d:	70 00                	jo     33f <PR_BOOTABLE+0x2bf>
 33f:	6d                   	insl   (%dx),%es:(%edi)
 340:	65 6d                	gs insl (%dx),%es:(%edi)
 342:	5f                   	pop    %edi
 343:	6c                   	insb   (%dx),%es:(%edi)
 344:	6f                   	outsl  %ds:(%esi),(%dx)
 345:	77 65                	ja     3ac <PR_BOOTABLE+0x32c>
 347:	72 00                	jb     349 <PR_BOOTABLE+0x2c9>
 349:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 34c:	74 61                	je     3af <PR_BOOTABLE+0x32f>
 34e:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 352:	73 79                	jae    3cd <PR_BOOTABLE+0x34d>
 354:	6d                   	insl   (%dx),%es:(%edi)
 355:	73 00                	jae    357 <PR_BOOTABLE+0x2d7>
 357:	75 69                	jne    3c2 <PR_BOOTABLE+0x342>
 359:	6e                   	outsb  %ds:(%esi),(%dx)
 35a:	74 31                	je     38d <PR_BOOTABLE+0x30d>
 35c:	36 5f                	ss pop %edi
 35e:	74 00                	je     360 <PR_BOOTABLE+0x2e0>
 360:	6d                   	insl   (%dx),%es:(%edi)
 361:	6d                   	insl   (%dx),%es:(%edi)
 362:	61                   	popa   
 363:	70 5f                	jo     3c4 <PR_BOOTABLE+0x344>
 365:	6c                   	insb   (%dx),%es:(%edi)
 366:	65 6e                	outsb  %gs:(%esi),(%dx)
 368:	67 74 68             	addr16 je 3d3 <PR_BOOTABLE+0x353>
 36b:	00 6d 62             	add    %ch,0x62(%ebp)
 36e:	6f                   	outsl  %ds:(%esi),(%dx)
 36f:	6f                   	outsl  %ds:(%esi),(%dx)
 370:	74 5f                	je     3d1 <PR_BOOTABLE+0x351>
 372:	69 6e 66 6f 00 70 5f 	imul   $0x5f70006f,0x66(%esi),%ebp
 379:	76 61                	jbe    3dc <PR_BOOTABLE+0x35c>
 37b:	00 76 62             	add    %dh,0x62(%esi)
 37e:	65 5f                	gs pop %edi
 380:	63 6f 6e             	arpl   %bp,0x6e(%edi)
 383:	74 72                	je     3f7 <PR_BOOTABLE+0x377>
 385:	6f                   	outsl  %ds:(%esi),(%dx)
 386:	6c                   	insb   (%dx),%es:(%edi)
 387:	5f                   	pop    %edi
 388:	69 6e 66 6f 00 70 5f 	imul   $0x5f70006f,0x66(%esi),%ebp
 38f:	66 6c                	data16 insb (%dx),%es:(%edi)
 391:	61                   	popa   
 392:	67 73 00             	addr16 jae 395 <PR_BOOTABLE+0x315>
 395:	70 61                	jo     3f8 <PR_BOOTABLE+0x378>
 397:	72 73                	jb     40c <PR_BOOTABLE+0x38c>
 399:	65 5f                	gs pop %edi
 39b:	65 38 32             	cmp    %dh,%gs:(%edx)
 39e:	30 00                	xor    %al,(%eax)
 3a0:	65 5f                	gs pop %edi
 3a2:	65 6c                	gs insb (%dx),%es:(%edi)
 3a4:	66 00 62 6f          	data16 add %ah,0x6f(%edx)
 3a8:	6f                   	outsl  %ds:(%esi),(%dx)
 3a9:	74 5f                	je     40a <PR_BOOTABLE+0x38a>
 3ab:	64 65 76 69          	fs gs jbe 418 <PR_BOOTABLE+0x398>
 3af:	63 65 00             	arpl   %sp,0x0(%ebp)
 3b2:	61                   	popa   
 3b3:	6f                   	outsl  %ds:(%esi),(%dx)
 3b4:	75 74                	jne    42a <PR_BOOTABLE+0x3aa>
 3b6:	00 64 6b 65          	add    %ah,0x65(%ebx,%ebp,2)
 3ba:	72 6e                	jb     42a <PR_BOOTABLE+0x3aa>
 3bc:	65 6c                	gs insb (%dx),%es:(%edi)
 3be:	00 65 5f             	add    %ah,0x5f(%ebp)
 3c1:	70 68                	jo     42b <PR_BOOTABLE+0x3ab>
 3c3:	6f                   	outsl  %ds:(%esi),(%dx)
 3c4:	66 66 00 63 6f       	data16 data16 add %ah,0x6f(%ebx)
 3c9:	6e                   	outsb  %ds:(%esi),(%dx)
 3ca:	66 69 67 5f 74 61    	imul   $0x6174,0x5f(%edi),%sp
 3d0:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 3d4:	65 5f                	gs pop %edi
 3d6:	6d                   	insl   (%dx),%es:(%edi)
 3d7:	61                   	popa   
 3d8:	67 69 63 00 6c 61 73 	imul   $0x7473616c,0x0(%bp,%di),%esp
 3df:	74 
 3e0:	5f                   	pop    %edi
 3e1:	63 68 73             	arpl   %bp,0x73(%eax)
 3e4:	00 62 61             	add    %ah,0x61(%edx)
 3e7:	73 65                	jae    44e <PR_BOOTABLE+0x3ce>
 3e9:	5f                   	pop    %edi
 3ea:	61                   	popa   
 3eb:	64 64 72 00          	fs fs jb 3ef <PR_BOOTABLE+0x36f>
 3ef:	76 62                	jbe    453 <PR_BOOTABLE+0x3d3>
 3f1:	65 5f                	gs pop %edi
 3f3:	6d                   	insl   (%dx),%es:(%edi)
 3f4:	6f                   	outsl  %ds:(%esi),(%dx)
 3f5:	64 65 00 65 5f       	fs add %ah,%gs:0x5f(%ebp)
 3fa:	73 68                	jae    464 <PR_BOOTABLE+0x3e4>
 3fc:	6f                   	outsl  %ds:(%esi),(%dx)
 3fd:	66 66 00 6d 65       	data16 data16 add %ch,0x65(%ebp)
 402:	6d                   	insl   (%dx),%es:(%edi)
 403:	5f                   	pop    %edi
 404:	75 70                	jne    476 <PR_BOOTABLE+0x3f6>
 406:	70 65                	jo     46d <PR_BOOTABLE+0x3ed>
 408:	72 00                	jb     40a <PR_BOOTABLE+0x38a>
 40a:	76 62                	jbe    46e <PR_BOOTABLE+0x3ee>
 40c:	65 5f                	gs pop %edi
 40e:	6d                   	insl   (%dx),%es:(%edi)
 40f:	6f                   	outsl  %ds:(%esi),(%dx)
 410:	64 65 5f             	fs gs pop %edi
 413:	69 6e 66 6f 00 74 61 	imul   $0x6174006f,0x66(%esi),%ebp
 41a:	62 73 69             	bound  %esi,0x69(%ebx)
 41d:	7a 65                	jp     484 <PR_BOOTABLE+0x404>
 41f:	00 66 69             	add    %ah,0x69(%esi)
 422:	72 73                	jb     497 <PR_BOOTABLE+0x417>
 424:	74 5f                	je     485 <PR_BOOTABLE+0x405>
 426:	6c                   	insb   (%dx),%es:(%edi)
 427:	62 61 00             	bound  %esp,0x0(%ecx)
 42a:	64 72 69             	fs jb  496 <PR_BOOTABLE+0x416>
 42d:	76 65                	jbe    494 <PR_BOOTABLE+0x414>
 42f:	73 5f                	jae    490 <PR_BOOTABLE+0x410>
 431:	6c                   	insb   (%dx),%es:(%edi)
 432:	65 6e                	outsb  %gs:(%esi),(%dx)
 434:	67 74 68             	addr16 je 49f <PR_BOOTABLE+0x41f>
 437:	00 70 5f             	add    %dh,0x5f(%eax)
 43a:	6d                   	insl   (%dx),%es:(%edi)
 43b:	65 6d                	gs insl (%dx),%es:(%edi)
 43d:	73 7a                	jae    4b9 <PR_BOOTABLE+0x439>
 43f:	00 70 5f             	add    %dh,0x5f(%eax)
 442:	66 69 6c 65 73 7a 00 	imul   $0x7a,0x73(%ebp,%eiz,2),%bp
 449:	65 5f                	gs pop %edi
 44b:	70 68                	jo     4b5 <PR_BOOTABLE+0x435>
 44d:	6e                   	outsb  %ds:(%esi),(%dx)
 44e:	75 6d                	jne    4bd <PR_BOOTABLE+0x43d>
 450:	00 73 69             	add    %dh,0x69(%ebx)
 453:	67 6e                	outsb  %ds:(%si),(%dx)
 455:	61                   	popa   
 456:	74 75                	je     4cd <PR_BOOTABLE+0x44d>
 458:	72 65                	jb     4bf <PR_BOOTABLE+0x43f>
 45a:	00 65 5f             	add    %ah,0x5f(%ebp)
 45d:	73 68                	jae    4c7 <PR_BOOTABLE+0x447>
 45f:	6e                   	outsb  %ds:(%esi),(%dx)
 460:	75 6d                	jne    4cf <PR_BOOTABLE+0x44f>
 462:	00 76 62             	add    %dh,0x62(%esi)
 465:	65 5f                	gs pop %edi
 467:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 46e:	63 65 5f             	arpl   %sp,0x5f(%ebp)
 471:	6c                   	insb   (%dx),%es:(%edi)
 472:	65 6e                	outsb  %gs:(%esi),(%dx)
 474:	00 62 6f             	add    %ah,0x6f(%edx)
 477:	6f                   	outsl  %ds:(%esi),(%dx)
 478:	74 2f                	je     4a9 <PR_BOOTABLE+0x429>
 47a:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 47d:	74 31                	je     4b0 <PR_BOOTABLE+0x430>
 47f:	2f                   	das    
 480:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 483:	74 31                	je     4b6 <PR_BOOTABLE+0x436>
 485:	6d                   	insl   (%dx),%es:(%edi)
 486:	61                   	popa   
 487:	69 6e 2e 63 00 6d 6f 	imul   $0x6f6d0063,0x2e(%esi),%ebp
 48e:	64 73 5f             	fs jae 4f0 <PR_BOOTABLE+0x470>
 491:	63 6f 75             	arpl   %bp,0x75(%edi)
 494:	6e                   	outsb  %ds:(%esi),(%dx)
 495:	74 00                	je     497 <PR_BOOTABLE+0x417>
 497:	5f                   	pop    %edi
 498:	72 65                	jb     4ff <PR_BOOTABLE+0x47f>
 49a:	73 65                	jae    501 <PR_BOOTABLE+0x481>
 49c:	72 76                	jb     514 <PR_BOOTABLE+0x494>
 49e:	65 64 00 62 6f       	gs add %ah,%fs:0x6f(%edx)
 4a3:	6f                   	outsl  %ds:(%esi),(%dx)
 4a4:	74 5f                	je     505 <PR_BOOTABLE+0x485>
 4a6:	6c                   	insb   (%dx),%es:(%edi)
 4a7:	6f                   	outsl  %ds:(%esi),(%dx)
 4a8:	61                   	popa   
 4a9:	64 65 72 5f          	fs gs jb 50c <PR_BOOTABLE+0x48c>
 4ad:	6e                   	outsb  %ds:(%esi),(%dx)
 4ae:	61                   	popa   
 4af:	6d                   	insl   (%dx),%es:(%edi)
 4b0:	65 00 76 62          	add    %dh,%gs:0x62(%esi)
 4b4:	65 5f                	gs pop %edi
 4b6:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 4bd:	63 65 5f             	arpl   %sp,0x5f(%ebp)
 4c0:	73 65                	jae    527 <PR_BOOTABLE+0x4a7>
 4c2:	67 00 6d 6d          	add    %ch,0x6d(%di)
 4c6:	61                   	popa   
 4c7:	70 5f                	jo     528 <PR_BOOTABLE+0x4a8>
 4c9:	6c                   	insb   (%dx),%es:(%edi)
 4ca:	65 6e                	outsb  %gs:(%esi),(%dx)
 4cc:	00 70 5f             	add    %dh,0x5f(%eax)
 4cf:	61                   	popa   
 4d0:	6c                   	insb   (%dx),%es:(%edi)
 4d1:	69 67 6e 00 61 70 6d 	imul   $0x6d706100,0x6e(%edi),%esp
 4d8:	5f                   	pop    %edi
 4d9:	74 61                	je     53c <PR_BOOTABLE+0x4bc>
 4db:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 4df:	70 5f                	jo     540 <PR_BOOTABLE+0x4c0>
 4e1:	70 61                	jo     544 <PR_BOOTABLE+0x4c4>
 4e3:	00 73 65             	add    %dh,0x65(%ebx)
 4e6:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
 4ea:	73 5f                	jae    54b <PR_BOOTABLE+0x4cb>
 4ec:	63 6f 75             	arpl   %bp,0x75(%edi)
 4ef:	6e                   	outsb  %ds:(%esi),(%dx)
 4f0:	74 00                	je     4f2 <PR_BOOTABLE+0x472>
 4f2:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4f5:	74 2f                	je     526 <PR_BOOTABLE+0x4a6>
 4f7:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 4fa:	74 31                	je     52d <PR_BOOTABLE+0x4ad>
 4fc:	2f                   	das    
 4fd:	65 78 65             	gs js  565 <PR_BOOTABLE+0x4e5>
 500:	63 5f 6b             	arpl   %bx,0x6b(%edi)
 503:	65 72 6e             	gs jb  574 <PR_BOOTABLE+0x4f4>
 506:	65 6c                	gs insb (%dx),%es:(%edi)
 508:	2e 53                	cs push %ebx
 50a:	00                   	.byte 0x0

Disassembly of section .debug_loc:

00000000 <.debug_loc>:
   0:	00 00                	add    %al,(%eax)
   2:	00 00                	add    %al,(%eax)
   4:	00 00                	add    %al,(%eax)
   6:	00 00                	add    %al,(%eax)
   8:	00 01                	add    %al,(%ecx)
   a:	01 00                	add    %eax,(%eax)
   c:	00 00                	add    %al,(%eax)
   e:	00 01                	add    %al,(%ecx)
  10:	01 00                	add    %eax,(%eax)
  12:	2b 02                	sub    (%edx),%eax
  14:	00 00                	add    %al,(%eax)
  16:	37                   	aaa    
  17:	02 00                	add    (%eax),%al
  19:	00 02                	add    %al,(%edx)
  1b:	00 91 00 37 02 00    	add    %dl,0x23700(%ecx)
  21:	00 45 02             	add    %al,0x2(%ebp)
  24:	00 00                	add    %al,(%eax)
  26:	09 00                	or     %eax,(%eax)
  28:	73 00                	jae    2a <PROT_MODE_DSEG+0x1a>
  2a:	0c ff                	or     $0xff,%al
  2c:	ff                   	(bad)  
  2d:	ff 00                	incl   (%eax)
  2f:	1a 9f 45 02 00 00    	sbb    0x245(%edi),%bl
  35:	4e                   	dec    %esi
  36:	02 00                	add    (%eax),%al
  38:	00 09                	add    %cl,(%ecx)
  3a:	00 76 00             	add    %dh,0x0(%esi)
  3d:	0c ff                	or     $0xff,%al
  3f:	ff                   	(bad)  
  40:	ff 00                	incl   (%eax)
  42:	1a 9f 4e 02 00 00    	sbb    0x24e(%edi),%bl
  48:	51                   	push   %ecx
  49:	02 00                	add    (%eax),%al
  4b:	00 01                	add    %al,(%ecx)
  4d:	00 56 51             	add    %dl,0x51(%esi)
  50:	02 00                	add    (%eax),%al
  52:	00 51 02             	add    %dl,0x2(%ecx)
  55:	00 00                	add    %al,(%eax)
  57:	0a 00                	or     (%eax),%al
  59:	91                   	xchg   %eax,%ecx
  5a:	00 06                	add    %al,(%esi)
  5c:	0c ff                	or     $0xff,%al
  5e:	ff                   	(bad)  
  5f:	ff 00                	incl   (%eax)
  61:	1a 9f 51 02 00 00    	sbb    0x251(%edi),%bl
  67:	60                   	pusha  
  68:	02 00                	add    (%eax),%al
  6a:	00 01                	add    %al,(%ecx)
  6c:	00 53 60             	add    %dl,0x60(%ebx)
  6f:	02 00                	add    (%eax),%al
  71:	00 64 02 00          	add    %ah,0x0(%edx,%eax,1)
  75:	00 02                	add    %al,(%edx)
  77:	00 74 00 64          	add    %dh,0x64(%eax,%eax,1)
  7b:	02 00                	add    (%eax),%al
  7d:	00 65 02             	add    %ah,0x2(%ebp)
  80:	00 00                	add    %al,(%eax)
  82:	04 00                	add    $0x0,%al
  84:	73 80                	jae    6 <CR0_PE_ON+0x5>
  86:	7c 9f                	jl     27 <PROT_MODE_DSEG+0x17>
  88:	65 02 00             	add    %gs:(%eax),%al
  8b:	00 6e 02             	add    %ch,0x2(%esi)
  8e:	00 00                	add    %al,(%eax)
  90:	01 00                	add    %eax,(%eax)
  92:	53                   	push   %ebx
  93:	00 00                	add    %al,(%eax)
  95:	00 00                	add    %al,(%eax)
  97:	00 00                	add    %al,(%eax)
  99:	00 00                	add    %al,(%eax)
  9b:	00 02                	add    %al,(%edx)
  9d:	02 00                	add    (%eax),%al
  9f:	00 00                	add    %al,(%eax)
  a1:	00 00                	add    %al,(%eax)
  a3:	00 02                	add    %al,(%edx)
  a5:	02 00                	add    (%eax),%al
  a7:	2b 02                	sub    (%edx),%eax
  a9:	00 00                	add    %al,(%eax)
  ab:	51                   	push   %ecx
  ac:	02 00                	add    (%eax),%al
  ae:	00 02                	add    %al,(%edx)
  b0:	00 91 08 51 02 00    	add    %dl,0x25108(%ecx)
  b6:	00 59 02             	add    %bl,0x2(%ecx)
  b9:	00 00                	add    %al,(%eax)
  bb:	01 00                	add    %eax,(%eax)
  bd:	57                   	push   %edi
  be:	59                   	pop    %ecx
  bf:	02 00                	add    (%eax),%al
  c1:	00 5a 02             	add    %bl,0x2(%edx)
  c4:	00 00                	add    %al,(%eax)
  c6:	02 00                	add    (%eax),%al
  c8:	74 00                	je     ca <PR_BOOTABLE+0x4a>
  ca:	5a                   	pop    %edx
  cb:	02 00                	add    (%eax),%al
  cd:	00 64 02 00          	add    %ah,0x0(%edx,%eax,1)
  d1:	00 02                	add    %al,(%edx)
  d3:	00 74 04 64          	add    %dh,0x64(%esp,%eax,1)
  d7:	02 00                	add    (%eax),%al
  d9:	00 65 02             	add    %ah,0x2(%ebp)
  dc:	00 00                	add    %al,(%eax)
  de:	03 00                	add    (%eax),%eax
  e0:	77 7f                	ja     161 <PR_BOOTABLE+0xe1>
  e2:	9f                   	lahf   
  e3:	65 02 00             	add    %gs:(%eax),%al
  e6:	00 70 02             	add    %dh,0x2(%eax)
  e9:	00 00                	add    %al,(%eax)
  eb:	01 00                	add    %eax,(%eax)
  ed:	57                   	push   %edi
  ee:	00 00                	add    %al,(%eax)
  f0:	00 00                	add    %al,(%eax)
  f2:	00 00                	add    %al,(%eax)
  f4:	00 00                	add    %al,(%eax)
  f6:	00 00                	add    %al,(%eax)
  f8:	00 00                	add    %al,(%eax)
  fa:	51                   	push   %ecx
  fb:	02 00                	add    (%eax),%al
  fd:	00 6f 02             	add    %ch,0x2(%edi)
 100:	00 00                	add    %al,(%eax)
 102:	01 00                	add    %eax,(%eax)
 104:	56                   	push   %esi
 105:	6f                   	outsl  %ds:(%esi),(%dx)
 106:	02 00                	add    (%eax),%al
 108:	00 72 02             	add    %dh,0x2(%edx)
 10b:	00 00                	add    %al,(%eax)
 10d:	0e                   	push   %cs
 10e:	00 91 00 06 0c ff    	add    %dl,-0xf3fa00(%ecx)
 114:	ff                   	(bad)  
 115:	ff 00                	incl   (%eax)
 117:	1a 91 04 06 22 9f    	sbb    -0x60ddf9fc(%ecx),%dl
 11d:	00 00                	add    %al,(%eax)
 11f:	00 00                	add    %al,(%eax)
 121:	00 00                	add    %al,(%eax)
 123:	00 00                	add    %al,(%eax)
 125:	02 01                	add    (%ecx),%al
 127:	c8 01 00 00          	enter  $0x1,$0x0
 12b:	cb                   	lret   
 12c:	01 00                	add    %eax,(%eax)
 12e:	00 04 00             	add    %al,(%eax,%eax,1)
 131:	0a f7                	or     %bh,%dh
 133:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 139:	00 00                	add    %al,(%eax)
 13b:	00 00                	add    %al,(%eax)
 13d:	00 01                	add    %al,(%ecx)
 13f:	cb                   	lret   
 140:	01 00                	add    %eax,(%eax)
 142:	00 cb                	add    %cl,%bl
 144:	01 00                	add    %eax,(%eax)
 146:	00 01                	add    %al,(%ecx)
 148:	00 50 00             	add    %dl,0x0(%eax)
 14b:	00 00                	add    %al,(%eax)
 14d:	00 00                	add    %al,(%eax)
 14f:	00 00                	add    %al,(%eax)
 151:	00 01                	add    %al,(%ecx)
 153:	00 d2                	add    %dl,%dl
 155:	01 00                	add    %eax,(%eax)
 157:	00 da                	add    %bl,%dl
 159:	01 00                	add    %eax,(%eax)
 15b:	00 02                	add    %al,(%edx)
 15d:	00 31                	add    %dh,(%ecx)
 15f:	9f                   	lahf   
 160:	00 00                	add    %al,(%eax)
 162:	00 00                	add    %al,(%eax)
 164:	00 00                	add    %al,(%eax)
 166:	00 00                	add    %al,(%eax)
 168:	01 00                	add    %eax,(%eax)
 16a:	d2 01                	rolb   %cl,(%ecx)
 16c:	00 00                	add    %al,(%eax)
 16e:	da 01                	fiaddl (%ecx)
 170:	00 00                	add    %al,(%eax)
 172:	04 00                	add    $0x0,%al
 174:	0a f2                	or     %dl,%dh
 176:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 17c:	00 00                	add    %al,(%eax)
 17e:	00 00                	add    %al,(%eax)
 180:	02 00                	add    (%eax),%al
 182:	da 01                	fiaddl (%ecx)
 184:	00 00                	add    %al,(%eax)
 186:	e2 01                	loop   189 <PR_BOOTABLE+0x109>
 188:	00 00                	add    %al,(%eax)
 18a:	01 00                	add    %eax,(%eax)
 18c:	51                   	push   %ecx
 18d:	00 00                	add    %al,(%eax)
 18f:	00 00                	add    %al,(%eax)
 191:	00 00                	add    %al,(%eax)
 193:	00 00                	add    %al,(%eax)
 195:	02 00                	add    (%eax),%al
 197:	da 01                	fiaddl (%ecx)
 199:	00 00                	add    %al,(%eax)
 19b:	e2 01                	loop   19e <PR_BOOTABLE+0x11e>
 19d:	00 00                	add    %al,(%eax)
 19f:	04 00                	add    $0x0,%al
 1a1:	0a f3                	or     %bl,%dh
 1a3:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 1a9:	00 00                	add    %al,(%eax)
 1ab:	00 00                	add    %al,(%eax)
 1ad:	02 00                	add    (%eax),%al
 1af:	e2 01                	loop   1b2 <PR_BOOTABLE+0x132>
 1b1:	00 00                	add    %al,(%eax)
 1b3:	ed                   	in     (%dx),%eax
 1b4:	01 00                	add    %eax,(%eax)
 1b6:	00 02                	add    %al,(%edx)
 1b8:	00 91 05 00 00 00    	add    %dl,0x5(%ecx)
 1be:	00 00                	add    %al,(%eax)
 1c0:	00 00                	add    %al,(%eax)
 1c2:	00 02                	add    %al,(%edx)
 1c4:	00 e2                	add    %ah,%dl
 1c6:	01 00                	add    %eax,(%eax)
 1c8:	00 ed                	add    %ch,%ch
 1ca:	01 00                	add    %eax,(%eax)
 1cc:	00 04 00             	add    %al,(%eax,%eax,1)
 1cf:	0a f4                	or     %ah,%dh
 1d1:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 1d7:	00 00                	add    %al,(%eax)
 1d9:	00 00                	add    %al,(%eax)
 1db:	02 00                	add    (%eax),%al
 1dd:	ed                   	in     (%dx),%eax
 1de:	01 00                	add    %eax,(%eax)
 1e0:	00 f8                	add    %bh,%al
 1e2:	01 00                	add    %eax,(%eax)
 1e4:	00 02                	add    %al,(%edx)
 1e6:	00 91 06 00 00 00    	add    %dl,0x6(%ecx)
 1ec:	00 00                	add    %al,(%eax)
 1ee:	00 00                	add    %al,(%eax)
 1f0:	00 02                	add    %al,(%edx)
 1f2:	00 ed                	add    %ch,%ch
 1f4:	01 00                	add    %eax,(%eax)
 1f6:	00 f8                	add    %bh,%al
 1f8:	01 00                	add    %eax,(%eax)
 1fa:	00 04 00             	add    %al,(%eax,%eax,1)
 1fd:	0a f5                	or     %ch,%dh
 1ff:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 205:	00 00                	add    %al,(%eax)
 207:	00 00                	add    %al,(%eax)
 209:	02 00                	add    (%eax),%al
 20b:	f8                   	clc    
 20c:	01 00                	add    %eax,(%eax)
 20e:	00 06                	add    %al,(%esi)
 210:	02 00                	add    (%eax),%al
 212:	00 08                	add    %cl,(%eax)
 214:	00 91 07 94 01 09    	add    %dl,0x9019407(%ecx)
 21a:	e0 21                	loopne 23d <PR_BOOTABLE+0x1bd>
 21c:	9f                   	lahf   
 21d:	00 00                	add    %al,(%eax)
 21f:	00 00                	add    %al,(%eax)
 221:	00 00                	add    %al,(%eax)
 223:	00 00                	add    %al,(%eax)
 225:	02 00                	add    (%eax),%al
 227:	f8                   	clc    
 228:	01 00                	add    %eax,(%eax)
 22a:	00 06                	add    %al,(%esi)
 22c:	02 00                	add    (%eax),%al
 22e:	00 04 00             	add    %al,(%eax,%eax,1)
 231:	0a f6                	or     %dh,%dh
 233:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 239:	00 00                	add    %al,(%eax)
 23b:	00 00                	add    %al,(%eax)
 23d:	02 00                	add    (%eax),%al
 23f:	06                   	push   %es
 240:	02 00                	add    (%eax),%al
 242:	00 0b                	add    %cl,(%ebx)
 244:	02 00                	add    (%eax),%al
 246:	00 03                	add    %al,(%ebx)
 248:	00 08                	add    %cl,(%eax)
 24a:	20 9f 00 00 00 00    	and    %bl,0x0(%edi)
 250:	00 00                	add    %al,(%eax)
 252:	00 00                	add    %al,(%eax)
 254:	02 00                	add    (%eax),%al
 256:	06                   	push   %es
 257:	02 00                	add    (%eax),%al
 259:	00 0b                	add    %cl,(%ebx)
 25b:	02 00                	add    (%eax),%al
 25d:	00 04 00             	add    %al,(%eax,%eax,1)
 260:	0a f7                	or     %bh,%dh
 262:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 268:	00 00                	add    %al,(%eax)
 26a:	00 00                	add    %al,(%eax)
 26c:	02 01                	add    (%ecx),%al
 26e:	10 02                	adc    %al,(%edx)
 270:	00 00                	add    %al,(%eax)
 272:	11 02                	adc    %eax,(%edx)
 274:	00 00                	add    %al,(%eax)
 276:	04 00                	add    $0x0,%al
 278:	0a f7                	or     %bh,%dh
 27a:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 280:	00 00                	add    %al,(%eax)
 282:	00 00                	add    %al,(%eax)
 284:	00 01                	add    %al,(%ecx)
 286:	11 02                	adc    %eax,(%edx)
 288:	00 00                	add    %al,(%eax)
 28a:	11 02                	adc    %eax,(%edx)
 28c:	00 00                	add    %al,(%eax)
 28e:	01 00                	add    %eax,(%eax)
 290:	50                   	push   %eax
 291:	00 00                	add    %al,(%eax)
 293:	00 00                	add    %al,(%eax)
 295:	00 00                	add    %al,(%eax)
 297:	00 00                	add    %al,(%eax)
 299:	01 00                	add    %eax,(%eax)
 29b:	18 02                	sbb    %al,(%edx)
 29d:	00 00                	add    %al,(%eax)
 29f:	28 02                	sub    %al,(%edx)
 2a1:	00 00                	add    %al,(%eax)
 2a3:	03 00                	add    (%eax),%eax
 2a5:	08 80 9f 00 00 00    	or     %al,0x9f(%eax)
 2ab:	00 00                	add    %al,(%eax)
 2ad:	00 00                	add    %al,(%eax)
 2af:	00 01                	add    %al,(%ecx)
 2b1:	00 18                	add    %bl,(%eax)
 2b3:	02 00                	add    (%eax),%al
 2b5:	00 28                	add    %ch,(%eax)
 2b7:	02 00                	add    (%eax),%al
 2b9:	00 02                	add    %al,(%edx)
 2bb:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
 2c1:	00 00                	add    %al,(%eax)
 2c3:	00 00                	add    %al,(%eax)
 2c5:	00 01                	add    %al,(%ecx)
 2c7:	00 18                	add    %bl,(%eax)
 2c9:	02 00                	add    (%eax),%al
 2cb:	00 28                	add    %ch,(%eax)
 2cd:	02 00                	add    (%eax),%al
 2cf:	00 04 00             	add    %al,(%eax,%eax,1)
 2d2:	0a f0                	or     %al,%dh
 2d4:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 2da:	00 00                	add    %al,(%eax)
 2dc:	00 00                	add    %al,(%eax)
 2de:	00 00                	add    %al,(%eax)
 2e0:	00 00                	add    %al,(%eax)
 2e2:	04 01                	add    $0x1,%al
 2e4:	00 00                	add    %al,(%eax)
 2e6:	29 01                	sub    %eax,(%ecx)
 2e8:	00 00                	add    %al,(%eax)
 2ea:	02 00                	add    (%eax),%al
 2ec:	91                   	xchg   %eax,%ecx
 2ed:	00 29                	add    %ch,(%ecx)
 2ef:	01 00                	add    %eax,(%eax)
 2f1:	00 5e 01             	add    %bl,0x1(%esi)
 2f4:	00 00                	add    %al,(%eax)
 2f6:	01 00                	add    %eax,(%eax)
 2f8:	50                   	push   %eax
 2f9:	00 00                	add    %al,(%eax)
 2fb:	00 00                	add    %al,(%eax)
 2fd:	00 00                	add    %al,(%eax)
 2ff:	00 00                	add    %al,(%eax)
 301:	00 00                	add    %al,(%eax)
 303:	00 00                	add    %al,(%eax)
 305:	00 00                	add    %al,(%eax)
 307:	29 01                	sub    %eax,(%ecx)
 309:	00 00                	add    %al,(%eax)
 30b:	45                   	inc    %ebp
 30c:	01 00                	add    %eax,(%eax)
 30e:	00 01                	add    %al,(%ecx)
 310:	00 51 45             	add    %dl,0x45(%ecx)
 313:	01 00                	add    %eax,(%eax)
 315:	00 4c 01 00          	add    %cl,0x0(%ecx,%eax,1)
 319:	00 01                	add    %al,(%ecx)
 31b:	00 52 4c             	add    %dl,0x4c(%edx)
 31e:	01 00                	add    %eax,(%eax)
 320:	00 5e 01             	add    %bl,0x1(%esi)
 323:	00 00                	add    %al,(%eax)
 325:	01 00                	add    %eax,(%eax)
 327:	51                   	push   %ecx
 328:	00 00                	add    %al,(%eax)
 32a:	00 00                	add    %al,(%eax)
 32c:	00 00                	add    %al,(%eax)
 32e:	00 00                	add    %al,(%eax)
 330:	00 00                	add    %al,(%eax)
 332:	12 01                	adc    (%ecx),%al
 334:	00 00                	add    %al,(%eax)
 336:	58                   	pop    %eax
 337:	01 00                	add    %eax,(%eax)
 339:	00 01                	add    %al,(%ecx)
 33b:	00 56 00             	add    %dl,0x0(%esi)
 33e:	00 00                	add    %al,(%eax)
 340:	00 00                	add    %al,(%eax)
 342:	00 00                	add    %al,(%eax)
 344:	00 04 00             	add    %al,(%eax,%eax,1)
 347:	00 00                	add    %al,(%eax)
 349:	00 01                	add    %al,(%ecx)
 34b:	01 00                	add    %eax,(%eax)
 34d:	cf                   	iret   
 34e:	00 00                	add    %al,(%eax)
 350:	00 e6                	add    %ah,%dh
 352:	00 00                	add    %al,(%eax)
 354:	00 02                	add    %al,(%edx)
 356:	00 30                	add    %dh,(%eax)
 358:	9f                   	lahf   
 359:	e6 00                	out    %al,$0x0
 35b:	00 00                	add    %al,(%eax)
 35d:	f7 00 00 00 01 00    	testl  $0x10000,(%eax)
 363:	52                   	push   %edx
 364:	f7 00 00 00 fa 00    	testl  $0xfa0000,(%eax)
 36a:	00 00                	add    %al,(%eax)
 36c:	03 00                	add    (%eax),%eax
 36e:	72 7f                	jb     3ef <PR_BOOTABLE+0x36f>
 370:	9f                   	lahf   
 371:	fa                   	cli    
 372:	00 00                	add    %al,(%eax)
 374:	00 04 01             	add    %al,(%ecx,%eax,1)
 377:	00 00                	add    %al,(%eax)
 379:	01 00                	add    %eax,(%eax)
 37b:	52                   	push   %edx
 37c:	00 00                	add    %al,(%eax)
 37e:	00 00                	add    %al,(%eax)
 380:	00 00                	add    %al,(%eax)
 382:	00 00                	add    %al,(%eax)
 384:	00 00                	add    %al,(%eax)
 386:	e6 00                	out    %al,$0x0
 388:	00 00                	add    %al,(%eax)
 38a:	04 01                	add    $0x1,%al
 38c:	00 00                	add    %al,(%eax)
 38e:	01 00                	add    %eax,(%eax)
 390:	50                   	push   %eax
 391:	00 00                	add    %al,(%eax)
 393:	00 00                	add    %al,(%eax)
 395:	00 00                	add    %al,(%eax)
 397:	00 00                	add    %al,(%eax)
 399:	00 00                	add    %al,(%eax)
 39b:	ee                   	out    %al,(%dx)
 39c:	00 00                	add    %al,(%eax)
 39e:	00 fd                	add    %bh,%ch
 3a0:	00 00                	add    %al,(%eax)
 3a2:	00 01                	add    %al,(%ecx)
 3a4:	00 56 00             	add    %dl,0x0(%esi)
 3a7:	00 00                	add    %al,(%eax)
 3a9:	00 00                	add    %al,(%eax)
 3ab:	00 00                	add    %al,(%eax)
 3ad:	00 00                	add    %al,(%eax)
 3af:	00 00                	add    %al,(%eax)
 3b1:	00 00                	add    %al,(%eax)
 3b3:	01 01                	add    %eax,(%ecx)
 3b5:	00 bc 00 00 00 c4 00 	add    %bh,0xc40000(%eax,%eax,1)
 3bc:	00 00                	add    %al,(%eax)
 3be:	02 00                	add    (%eax),%al
 3c0:	91                   	xchg   %eax,%ecx
 3c1:	00 c4                	add    %al,%ah
 3c3:	00 00                	add    %al,(%eax)
 3c5:	00 cb                	add    %cl,%bl
 3c7:	00 00                	add    %al,(%eax)
 3c9:	00 07                	add    %al,(%edi)
 3cb:	00 91 00 06 70 00    	add    %dl,0x700600(%ecx)
 3d1:	22 9f cb 00 00 00    	and    0xcb(%edi),%bl
 3d7:	cb                   	lret   
 3d8:	00 00                	add    %al,(%eax)
 3da:	00 09                	add    %cl,(%ecx)
 3dc:	00 91 00 06 70 00    	add    %dl,0x700600(%ecx)
 3e2:	22 31                	and    (%ecx),%dh
 3e4:	1c 9f                	sbb    $0x9f,%al
 3e6:	cb                   	lret   
 3e7:	00 00                	add    %al,(%eax)
 3e9:	00 cf                	add    %cl,%bh
 3eb:	00 00                	add    %al,(%eax)
 3ed:	00 07                	add    %al,(%edi)
 3ef:	00 91 00 06 70 00    	add    %dl,0x700600(%ecx)
 3f5:	22 9f 00 00 00 00    	and    0x0(%edi),%bl
 3fb:	00 00                	add    %al,(%eax)
 3fd:	00 00                	add    %al,(%eax)
 3ff:	03 00                	add    (%eax),%eax
 401:	00 00                	add    %al,(%eax)
 403:	bc 00 00 00 c4       	mov    $0xc4000000,%esp
 408:	00 00                	add    %al,(%eax)
 40a:	00 02                	add    %al,(%edx)
 40c:	00 30                	add    %dh,(%eax)
 40e:	9f                   	lahf   
 40f:	c4 00                	les    (%eax),%eax
 411:	00 00                	add    %al,(%eax)
 413:	cf                   	iret   
 414:	00 00                	add    %al,(%eax)
 416:	00 01                	add    %al,(%ecx)
 418:	00 50 00             	add    %dl,0x0(%eax)
 41b:	00 00                	add    %al,(%eax)
 41d:	00 00                	add    %al,(%eax)
 41f:	00 00                	add    %al,(%eax)
 421:	00 00                	add    %al,(%eax)
 423:	00 99 01 00 00 b3    	add    %bl,-0x4cffffff(%ecx)
 429:	01 00                	add    %eax,(%eax)
 42b:	00 02                	add    %al,(%edx)
 42d:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
 433:	00 00                	add    %al,(%eax)
 435:	00 00                	add    %al,(%eax)
 437:	00 00                	add    %al,(%eax)
 439:	00 00                	add    %al,(%eax)
 43b:	01 01                	add    %eax,(%ecx)
 43d:	00 00                	add    %al,(%eax)
 43f:	00 00                	add    %al,(%eax)
 441:	00 00                	add    %al,(%eax)
 443:	00 1b                	add    %bl,(%ebx)
 445:	00 00                	add    %al,(%eax)
 447:	00 2c 00             	add    %ch,(%eax,%eax,1)
 44a:	00 00                	add    %al,(%eax)
 44c:	02 00                	add    (%eax),%al
 44e:	91                   	xchg   %eax,%ecx
 44f:	0c 2c                	or     $0x2c,%al
 451:	00 00                	add    %al,(%eax)
 453:	00 39                	add    %bh,(%ecx)
 455:	00 00                	add    %al,(%eax)
 457:	00 0a                	add    %cl,(%edx)
 459:	00 91 0c 06 70 00    	add    %dl,0x70060c(%ecx)
 45f:	22 76 00             	and    0x0(%esi),%dh
 462:	1c 9f                	sbb    $0x9f,%al
 464:	39 00                	cmp    %eax,(%eax)
 466:	00 00                	add    %al,(%eax)
 468:	46                   	inc    %esi
 469:	00 00                	add    %al,(%eax)
 46b:	00 0c 00             	add    %cl,(%eax,%eax,1)
 46e:	91                   	xchg   %eax,%ecx
 46f:	0c 06                	or     $0x6,%al
 471:	70 00                	jo     473 <PR_BOOTABLE+0x3f3>
 473:	22 76 00             	and    0x0(%esi),%dh
 476:	1c 23                	sbb    $0x23,%al
 478:	01 9f 46 00 00 00    	add    %ebx,0x46(%edi)
 47e:	4e                   	dec    %esi
 47f:	00 00                	add    %al,(%eax)
 481:	00 0a                	add    %cl,(%edx)
 483:	00 91 0c 06 73 00    	add    %dl,0x73060c(%ecx)
 489:	22 76 00             	and    0x0(%esi),%dh
 48c:	1c 9f                	sbb    $0x9f,%al
 48e:	4e                   	dec    %esi
 48f:	00 00                	add    %al,(%eax)
 491:	00 53 00             	add    %dl,0x0(%ebx)
 494:	00 00                	add    %al,(%eax)
 496:	0a 00                	or     (%eax),%al
 498:	91                   	xchg   %eax,%ecx
 499:	0c 06                	or     $0x6,%al
 49b:	70 00                	jo     49d <PR_BOOTABLE+0x41d>
 49d:	22 76 00             	and    0x0(%esi),%dh
 4a0:	1c 9f                	sbb    $0x9f,%al
 4a2:	53                   	push   %ebx
 4a3:	00 00                	add    %al,(%eax)
 4a5:	00 55 00             	add    %dl,0x0(%ebp)
 4a8:	00 00                	add    %al,(%eax)
 4aa:	12 00                	adc    (%eax),%al
 4ac:	91                   	xchg   %eax,%ecx
 4ad:	0c 06                	or     $0x6,%al
 4af:	91                   	xchg   %eax,%ecx
 4b0:	00 06                	add    %al,(%esi)
 4b2:	08 50 1e             	or     %dl,0x1e(%eax)
 4b5:	1c 70                	sbb    $0x70,%al
 4b7:	00 22                	add    %ah,(%edx)
 4b9:	91                   	xchg   %eax,%ecx
 4ba:	04 06                	add    $0x6,%al
 4bc:	1c 9f                	sbb    $0x9f,%al
 4be:	00 00                	add    %al,(%eax)
 4c0:	00 00                	add    %al,(%eax)
 4c2:	00 00                	add    %al,(%eax)
 4c4:	00 00                	add    %al,(%eax)
 4c6:	00 00                	add    %al,(%eax)
 4c8:	00 00                	add    %al,(%eax)
 4ca:	00 00                	add    %al,(%eax)
 4cc:	00 00                	add    %al,(%eax)
 4ce:	2a 00                	sub    (%eax),%al
 4d0:	00 00                	add    %al,(%eax)
 4d2:	2c 00                	sub    $0x0,%al
 4d4:	00 00                	add    %al,(%eax)
 4d6:	01 00                	add    %eax,(%eax)
 4d8:	56                   	push   %esi
 4d9:	2c 00                	sub    $0x0,%al
 4db:	00 00                	add    %al,(%eax)
 4dd:	3f                   	aas    
 4de:	00 00                	add    %al,(%eax)
 4e0:	00 01                	add    %al,(%ecx)
 4e2:	00 50 3f             	add    %dl,0x3f(%eax)
 4e5:	00 00                	add    %al,(%eax)
 4e7:	00 4e 00             	add    %cl,0x0(%esi)
 4ea:	00 00                	add    %al,(%eax)
 4ec:	01 00                	add    %eax,(%eax)
 4ee:	53                   	push   %ebx
 4ef:	4e                   	dec    %esi
 4f0:	00 00                	add    %al,(%eax)
 4f2:	00 55 00             	add    %dl,0x0(%ebp)
 4f5:	00 00                	add    %al,(%eax)
 4f7:	01 00                	add    %eax,(%eax)
 4f9:	50                   	push   %eax
 4fa:	00 00                	add    %al,(%eax)
 4fc:	00 00                	add    %al,(%eax)
 4fe:	00 00                	add    %al,(%eax)
 500:	00 00                	add    %al,(%eax)
 502:	00 00                	add    %al,(%eax)
 504:	11 00                	adc    %eax,(%eax)
 506:	00 00                	add    %al,(%eax)
 508:	1b 00                	sbb    (%eax),%eax
 50a:	00 00                	add    %al,(%eax)
 50c:	01 00                	add    %eax,(%eax)
 50e:	50                   	push   %eax
 50f:	00 00                	add    %al,(%eax)
 511:	00 00                	add    %al,(%eax)
 513:	00 00                	add    %al,(%eax)
 515:	00 00                	add    %al,(%eax)
 517:	00 00                	add    %al,(%eax)
 519:	00 00                	add    %al,(%eax)
 51b:	00 01                	add    %al,(%ecx)
 51d:	00 00                	add    %al,(%eax)
 51f:	00 00                	add    %al,(%eax)
 521:	89 00                	mov    %eax,(%eax)
 523:	00 00                	add    %al,(%eax)
 525:	9b                   	fwait
 526:	00 00                	add    %al,(%eax)
 528:	00 02                	add    %al,(%edx)
 52a:	00 91 00 9b 00 00    	add    %dl,0x9b00(%ecx)
 530:	00 ad 00 00 00 07    	add    %ch,0x7000000(%ebp)
 536:	00 91 00 06 73 00    	add    %dl,0x730600(%ecx)
 53c:	22 9f ad 00 00 00    	and    0xad(%edi),%bl
 542:	b3 00                	mov    $0x0,%bl
 544:	00 00                	add    %al,(%eax)
 546:	09 00                	or     %eax,(%eax)
 548:	91                   	xchg   %eax,%ecx
 549:	00 06                	add    %al,(%esi)
 54b:	73 00                	jae    54d <PR_BOOTABLE+0x4cd>
 54d:	22 48 1c             	and    0x1c(%eax),%cl
 550:	9f                   	lahf   
 551:	b8 00 00 00 de       	mov    $0xde000000,%eax
 556:	00 00                	add    %al,(%eax)
 558:	00 07                	add    %al,(%edi)
 55a:	00 91 00 06 73 00    	add    %dl,0x730600(%ecx)
 560:	22 9f de 00 00 00    	and    0xde(%edi),%bl
 566:	e1 00                	loope  568 <PR_BOOTABLE+0x4e8>
 568:	00 00                	add    %al,(%eax)
 56a:	0b 00                	or     (%eax),%eax
 56c:	91                   	xchg   %eax,%ecx
 56d:	00 06                	add    %al,(%esi)
 56f:	03 ec                	add    %esp,%ebp
 571:	92                   	xchg   %eax,%edx
 572:	00 00                	add    %al,(%eax)
 574:	06                   	push   %es
 575:	22 9f 00 00 00 00    	and    0x0(%edi),%bl
 57b:	00 00                	add    %al,(%eax)
 57d:	00 00                	add    %al,(%eax)
 57f:	01 00                	add    %eax,(%eax)
 581:	00 00                	add    %al,(%eax)
 583:	00 02                	add    %al,(%edx)
 585:	02 00                	add    (%eax),%al
 587:	00 00                	add    %al,(%eax)
 589:	89 00                	mov    %eax,(%eax)
 58b:	00 00                	add    %al,(%eax)
 58d:	9b                   	fwait
 58e:	00 00                	add    %al,(%eax)
 590:	00 02                	add    %al,(%edx)
 592:	00 30                	add    %dh,(%eax)
 594:	9f                   	lahf   
 595:	9b                   	fwait
 596:	00 00                	add    %al,(%eax)
 598:	00 ad 00 00 00 01    	add    %ch,0x1000000(%ebp)
 59e:	00 53 ad             	add    %dl,-0x53(%ebx)
 5a1:	00 00                	add    %al,(%eax)
 5a3:	00 b3 00 00 00 03    	add    %dh,0x3000000(%ebx)
 5a9:	00 73 68             	add    %dh,0x68(%ebx)
 5ac:	9f                   	lahf   
 5ad:	b3 00                	mov    $0x0,%bl
 5af:	00 00                	add    %al,(%eax)
 5b1:	de 00                	fiadds (%eax)
 5b3:	00 00                	add    %al,(%eax)
 5b5:	01 00                	add    %eax,(%eax)
 5b7:	53                   	push   %ebx
 5b8:	de 00                	fiadds (%eax)
 5ba:	00 00                	add    %al,(%eax)
 5bc:	e1 00                	loope  5be <PR_BOOTABLE+0x53e>
 5be:	00 00                	add    %al,(%eax)
 5c0:	05 00 03 ec 92       	add    $0x92ec0300,%eax
 5c5:	00 00                	add    %al,(%eax)
 5c7:	00 00                	add    %al,(%eax)
 5c9:	00 00                	add    %al,(%eax)
 5cb:	00 00                	add    %al,(%eax)
 5cd:	00 00                	add    %al,(%eax)
 5cf:	00 00                	add    %al,(%eax)
 5d1:	00 01                	add    %al,(%ecx)
 5d3:	01 00                	add    %eax,(%eax)
 5d5:	4f                   	dec    %edi
 5d6:	00 00                	add    %al,(%eax)
 5d8:	00 5c 00 00          	add    %bl,0x0(%eax,%eax,1)
 5dc:	00 01                	add    %al,(%ecx)
 5de:	00 53 5c             	add    %dl,0x5c(%ebx)
 5e1:	00 00                	add    %al,(%eax)
 5e3:	00 6a 00             	add    %ch,0x0(%edx)
 5e6:	00 00                	add    %al,(%eax)
 5e8:	03 00                	add    (%eax),%eax
 5ea:	73 60                	jae    64c <PR_BOOTABLE+0x5cc>
 5ec:	9f                   	lahf   
 5ed:	6a 00                	push   $0x0
 5ef:	00 00                	add    %al,(%eax)
 5f1:	78 00                	js     5f3 <PR_BOOTABLE+0x573>
 5f3:	00 00                	add    %al,(%eax)
 5f5:	01 00                	add    %eax,(%eax)
 5f7:	53                   	push   %ebx
 5f8:	00 00                	add    %al,(%eax)
 5fa:	00 00                	add    %al,(%eax)
 5fc:	00 00                	add    %al,(%eax)
 5fe:	00 00                	add    %al,(%eax)
 600:	00 00                	add    %al,(%eax)
 602:	54                   	push   %esp
 603:	00 00                	add    %al,(%eax)
 605:	00 79 00             	add    %bh,0x0(%ecx)
 608:	00 00                	add    %al,(%eax)
 60a:	01 00                	add    %eax,(%eax)
 60c:	56                   	push   %esi
 60d:	00 00                	add    %al,(%eax)
 60f:	00 00                	add    %al,(%eax)
 611:	00 00                	add    %al,(%eax)
 613:	00 00                	add    %al,(%eax)
 615:	00 00                	add    %al,(%eax)
 617:	e1 00                	loope  619 <PR_BOOTABLE+0x599>
 619:	00 00                	add    %al,(%eax)
 61b:	76 01                	jbe    61e <PR_BOOTABLE+0x59e>
 61d:	00 00                	add    %al,(%eax)
 61f:	02 00                	add    (%eax),%al
 621:	91                   	xchg   %eax,%ecx
 622:	00 00                	add    %al,(%eax)
 624:	00 00                	add    %al,(%eax)
 626:	00 00                	add    %al,(%eax)
 628:	00 00                	add    %al,(%eax)
 62a:	00 03                	add    %al,(%ebx)
 62c:	00 00                	add    %al,(%eax)
 62e:	00 02                	add    %al,(%edx)
 630:	01 00                	add    %eax,(%eax)
 632:	00 07                	add    %al,(%edi)
 634:	01 00                	add    %eax,(%eax)
 636:	00 02                	add    %al,(%edx)
 638:	00 30                	add    %dh,(%eax)
 63a:	9f                   	lahf   
 63b:	07                   	pop    %es
 63c:	01 00                	add    %eax,(%eax)
 63e:	00 33                	add    %dh,(%ebx)
 640:	01 00                	add    %eax,(%eax)
 642:	00 01                	add    %al,(%ecx)
 644:	00 50 00             	add    %dl,0x0(%eax)
 647:	00 00                	add    %al,(%eax)
 649:	00 00                	add    %al,(%eax)
 64b:	00 00                	add    %al,(%eax)
 64d:	00 02                	add    %al,(%edx)
 64f:	00 00                	add    %al,(%eax)
 651:	00 00                	add    %al,(%eax)
 653:	00 02                	add    %al,(%edx)
 655:	01 00                	add    %eax,(%eax)
 657:	00 1d 01 00 00 02    	add    %bl,0x2000001
 65d:	00 30                	add    %dh,(%eax)
 65f:	9f                   	lahf   
 660:	1d 01 00 00 1f       	sbb    $0x1f000001,%eax
 665:	01 00                	add    %eax,(%eax)
 667:	00 01                	add    %al,(%ecx)
 669:	00 56 1f             	add    %dl,0x1f(%esi)
 66c:	01 00                	add    %eax,(%eax)
 66e:	00 37                	add    %dh,(%edi)
 670:	01 00                	add    %eax,(%eax)
 672:	00 02                	add    %al,(%edx)
 674:	00 30                	add    %dh,(%eax)
 676:	9f                   	lahf   
 677:	00 00                	add    %al,(%eax)
 679:	00 00                	add    %al,(%eax)
 67b:	00 00                	add    %al,(%eax)
 67d:	00 00                	add    %al,(%eax)
 67f:	00 00                	add    %al,(%eax)
 681:	00 00                	add    %al,(%eax)
 683:	5d                   	pop    %ebp
 684:	01 00                	add    %eax,(%eax)
 686:	00 61 01             	add    %ah,0x1(%ecx)
 689:	00 00                	add    %al,(%eax)
 68b:	01 00                	add    %eax,(%eax)
 68d:	50                   	push   %eax
 68e:	61                   	popa   
 68f:	01 00                	add    %eax,(%eax)
 691:	00 7d 01             	add    %bh,0x1(%ebp)
 694:	00 00                	add    %al,(%eax)
 696:	01 00                	add    %eax,(%eax)
 698:	53                   	push   %ebx
 699:	00 00                	add    %al,(%eax)
 69b:	00 00                	add    %al,(%eax)
 69d:	00 00                	add    %al,(%eax)
 69f:	00 00                	add    %al,(%eax)

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	bc 01 00 00 bc       	mov    $0xbc000001,%esp
   5:	01 00                	add    %eax,(%eax)
   7:	00 c0                	add    %al,%al
   9:	01 00                	add    %eax,(%eax)
   b:	00 c5                	add    %al,%ch
   d:	01 00                	add    %eax,(%eax)
   f:	00 c8                	add    %cl,%al
  11:	01 00                	add    %eax,(%eax)
  13:	00 d2                	add    %dl,%dl
  15:	01 00                	add    %eax,(%eax)
  17:	00 00                	add    %al,(%eax)
  19:	00 00                	add    %al,(%eax)
  1b:	00 00                	add    %al,(%eax)
  1d:	00 00                	add    %al,(%eax)
  1f:	00 c0                	add    %al,%al
  21:	01 00                	add    %eax,(%eax)
  23:	00 c5                	add    %al,%ch
  25:	01 00                	add    %eax,(%eax)
  27:	00 c8                	add    %cl,%al
  29:	01 00                	add    %eax,(%eax)
  2b:	00 cb                	add    %cl,%bl
  2d:	01 00                	add    %eax,(%eax)
  2f:	00 00                	add    %al,(%eax)
  31:	00 00                	add    %al,(%eax)
  33:	00 00                	add    %al,(%eax)
  35:	00 00                	add    %al,(%eax)
  37:	00 e2                	add    %ah,%dl
  39:	01 00                	add    %eax,(%eax)
  3b:	00 e2                	add    %ah,%dl
  3d:	01 00                	add    %eax,(%eax)
  3f:	00 e4                	add    %ah,%ah
  41:	01 00                	add    %eax,(%eax)
  43:	00 e9                	add    %ch,%cl
  45:	01 00                	add    %eax,(%eax)
  47:	00 ec                	add    %ch,%ah
  49:	01 00                	add    %eax,(%eax)
  4b:	00 ed                	add    %ch,%ch
  4d:	01 00                	add    %eax,(%eax)
  4f:	00 00                	add    %al,(%eax)
  51:	00 00                	add    %al,(%eax)
  53:	00 00                	add    %al,(%eax)
  55:	00 00                	add    %al,(%eax)
  57:	00 ed                	add    %ch,%ch
  59:	01 00                	add    %eax,(%eax)
  5b:	00 ed                	add    %ch,%ch
  5d:	01 00                	add    %eax,(%eax)
  5f:	00 ef                	add    %ch,%bh
  61:	01 00                	add    %eax,(%eax)
  63:	00 f4                	add    %dh,%ah
  65:	01 00                	add    %eax,(%eax)
  67:	00 f7                	add    %dh,%bh
  69:	01 00                	add    %eax,(%eax)
  6b:	00 f8                	add    %bh,%al
  6d:	01 00                	add    %eax,(%eax)
  6f:	00 00                	add    %al,(%eax)
  71:	00 00                	add    %al,(%eax)
  73:	00 00                	add    %al,(%eax)
  75:	00 00                	add    %al,(%eax)
  77:	00 f8                	add    %bh,%al
  79:	01 00                	add    %eax,(%eax)
  7b:	00 f8                	add    %bh,%al
  7d:	01 00                	add    %eax,(%eax)
  7f:	00 fa                	add    %bh,%dl
  81:	01 00                	add    %eax,(%eax)
  83:	00 ff                	add    %bh,%bh
  85:	01 00                	add    %eax,(%eax)
  87:	00 05 02 00 00 06    	add    %al,0x6000002
  8d:	02 00                	add    (%eax),%al
  8f:	00 00                	add    %al,(%eax)
  91:	00 00                	add    %al,(%eax)
  93:	00 00                	add    %al,(%eax)
  95:	00 00                	add    %al,(%eax)
  97:	00 0b                	add    %cl,(%ebx)
  99:	02 00                	add    (%eax),%al
  9b:	00 10                	add    %dl,(%eax)
  9d:	02 00                	add    (%eax),%al
  9f:	00 10                	add    %dl,(%eax)
  a1:	02 00                	add    (%eax),%al
  a3:	00 11                	add    %dl,(%ecx)
  a5:	02 00                	add    (%eax),%al
  a7:	00 00                	add    %al,(%eax)
  a9:	00 00                	add    %al,(%eax)
  ab:	00 00                	add    %al,(%eax)
  ad:	00 00                	add    %al,(%eax)
  af:	00                   	.byte 0x0
