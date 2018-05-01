
.PHONY = clean run-qemu

run-qemu:Image
	- qemu-system-i386 -boot a -fda Image
setup: setup.s ld-bootblock.ld
	- as --32 setup.s -o setup.o
	- ld -T ld-bootblock.ld setup.o -o setup
	- objcopy -O binary setup
bootblock: bootblock.s ld-bootblock.ld
	- as --32 bootblock.s -o bootblock.o
	- ld -T ld-bootblock.ld bootblock.o -o bootblock
	- objcopy -O binary bootblock
Image:setup bootblock
	- dd if=bootblock of=Image bs=512 count=1
	- dd if=setup of=Image bs=512 count=4 seek=1
clean:
	- rm -f *.o
	- rm bootblock

