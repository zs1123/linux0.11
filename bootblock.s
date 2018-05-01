.code16

.global _bootstart

.equ INITSEG,0x9000
.equ BOOTSEG,0x07c0
.equ SETUPSEG,0x9020
.equ SYSSEG,0x1000
.text
ljmp $BOOTSEG,$_bootstart

_bootstart:
	mov $BOOTSEG,%ax
	mov %ax,%ds

	mov $INITSEG,%ax
	mov %ax,%es
	mov $256,%cx
	xor %si,%si
	xor %di,%di
	rep movsw
	
	ljmp $INITSEG,$go
go:
	mov %cs,%ax
	mov %ax,%ds
	mov %ax,%es
	mov %ax,%ss
	mov $0xff00,%sp
load_setup:
	mov $0x0000,%dx
	mov $0x0002,%cx
	mov $INITSEG,%ax
	mov %ax,%es
	mov $0x0200,%bx
	mov $0x02,%ah
	mov $4,%al
	int $0x13
	jnc demo_load_ok
	jmp load_setup

demo_load_ok:

	mov $0x3,%ah
	xor %bh,%bh
	int $0x10
	mov $INITSEG,%ax
	mov %ax,%es
	mov $_string,%bp
	mov $0x1301,%ax
	mov $0x000d,%bx
	mov $0xd,%cx
	int $0x10
	
	


	
	ljmp $SETUPSEG,$0

	

_string:
	.ascii "hello world\r\n"
.=510



signature:
	.word 0xaa55


