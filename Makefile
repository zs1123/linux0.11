
.PHONY = clean run-qemu all
all:Image



run-qemu:Image
	- qemu-system-i386 -boot a -fda ./boot/Image
setup: setup.s ld-bootblock.ld
	- as --32 setup.s -o setup.o
	- ld -T ld-bootblock.ld setup.o -o ./boot/setup
	- objcopy -O binary ./boot/setup
bootblock: bootblock.s ld-bootblock.ld
	- as --32 bootblock.s -o bootblock.o
	- ld -T ld-bootblock.ld bootblock.o -o ./boot/bootblock
	- objcopy -O binary ./boot/bootblock

system: system.s ld-bootblock.ld
	- as --32 system.s -o system.o
	- ld -T ld-bootblock.ld system.o -o ./boot/system
	- objcopy -O binary ./boot/system
Image:setup bootblock system
	- dd if=./boot/bootblock of=./boot/Image bs=512 count=1
	- dd if=./boot/setup of=./boot/Image bs=512 count=4 seek=1
	- dd if=./boot/system of=./boot/Image bs=512  seek=5
clean:
	- rm -f *.o
	- rm ./boot/*

