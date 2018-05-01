.code16

.text
.equ SETUPSEG,0x9020
.equ INITSEG,0x9000
.equ LEN,0x13

SHOW_TEXT:
	mov $SETUPSEG,%ax
	mov %ax,%es
	mov $0x3,%ah
	xor %bh,%bh
	int $0x10
	
	mov $0x000a,%bx
	mov $0x1301,%ax
	mov $MSG,%bp
	mov $LEN,%cx
	int $0x10
	
	ljmp $SETUPSEG,$_start
_start:
#save data
	#save cursor position
	mov $INITSEG,%ax
	mov %ax,%ds
	mov $0x03,%ah
	xor %bh,%bh
	int $0x10
	mov %ds,%ds:0
	#save extend memory
	mov $0x88,%ah
	int $0x15
	mov %ax,%ds:0
	#save display mode
	
	mov $0x0f,%ah
	int $0x10
	mov %bx,%ds:4
	mov %ax,%ds:6
	#save VGA 
	mov $0x12,%ah
	mov $0x10,%bl
	int $0x10
	mov %ax,%ds:8
	mov %bx,%ds:10
	mov %cx,%ds:12
#copy disk info
	mov $0x0000,%ax
	mov %ax,%ds
	lds %ds:4*0x41,%di
	mov $INITSEG,%ax
	mov %ax,%es
	mov $0x0080,%di
	mov $0x10,%cx
	rep movsb
	
	mov $0x0000,%ax
	mov %ax,%ds
	lds %ds:4*0x46,%si
	mov $INITSEG,%ax
	mov %ax,%es
	mov $0x0090,%di
	mov $0x10,%cx
	rep movsb
	
#check disk 
	mov $0x1500,%ax
	mov $0x81,%al
	jc no_disk1
	cmp $3,%ah
	je is_disk1

no_disk1:
	mov $INITSEG,%ax
	mov %ax,%es
	mov $0x0090,%di
	mov $0x10,%cx
	mov $0x00,%ax
	rep stosb
is_disk1:
	cli
	mov $0x0000,%ax
	cld
do_move:
	mov %ax,%es
	add $0x1000,%ax
	cmp $0x9000,%ax
	jz end_move
	mov %ax,%ds
	xor %di,%di
	xor %si,%si
	mov $0x8000,%cx
	rep movsw
	jmp do_move
end_move:
	mov $SETUPSEG,%ax
	mov %ax,%ds
	lgdt gdt_48
enable_a20:
	in $0x92,%al
	or $0x02,%al	
	out %al,$0x92
	
	mov %cr0,%eax
	bts $0,%eax
	mov %eax,%cr0



	.equ sel_cs0,0x0008
	mov $0x10,%ax
	mov %ax,%ds
	mov %ax,%es
	mov %ax,%fs
	mov %ax,%gs
	ljmp $sel_cs0,$0




gdt_48:
	.word 0x800
	.word 0x200+gdt,0x9

gdt:
	.word 0,0,0,0
	.word 0x07ff
	.word 0x0000
	.word 0x9a00
	.word 0x00c0

	.word 0x07ff
	.word 0x0000
	.word 0x9200
	.word 0x00c0



MSG:

	.ascii "load disk success\r\n"


