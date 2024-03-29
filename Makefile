# Make file for the potatOs
# for now only bootloader

AS=yasm 
bootloader=bootloader.asm
load_kernel=kernel_load.asm
kernel=kernel.cpp 
includes=
VM=qemu-system-x86_64
BUILD_DIR=./build
FINAL=./os

.phony: all bootloader clean kernel

all:bootloader  kernel
	dd if=/dev/zero of=$(FINAL)/potatOs.img bs=512 count=10
	cat $(BUILD_DIR)/bootloader.bin $(BUILD_DIR)/Kernel.bin > $(BUILD_DIR)/os.img
	dd if=$(BUILD_DIR)/os.img  of=$(FINAL)/potatOs.img conv=notrunc bs=512

bootloader: make_dir $(bootloader)
	$(AS) $(bootloader) $(includes) -f bin -o $(BUILD_DIR)/bootloader.bin 
	
kernel:
	i386-elf-gcc -ffreestanding -m32 -g -c $(kernel) -o $(BUILD_DIR)/kernel.o
	$(AS) $(load_kernel) -f elf -o $(BUILD_DIR)/kernel_load.o
	i386-elf-ld -o $(BUILD_DIR)/Kernel.bin -Tlinker.ld $(BUILD_DIR)/kernel_load.o $(BUILD_DIR)/kernel.o --oformat binary 
	
run:all
	$(VM) $(FINAL)/potatOs.img -monitor stdio
	
make_dir: clean
	@mkdir $(BUILD_DIR) $(FINAL)

test: 
	yasm test.asm  -o test.img 

clean: 
	@touch a.img 
	@echo "Cleaning..."
	@rm -rf build *.o os *.img
