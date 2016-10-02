# sudo apt-get install nasm            # The assembler
# sudo apt-get install xorriso         # manipulate ISO fs images
# sudo apt-get install qemu-system-x86 # quick PC system emulator

LD = ld -nmagic
NASM = nasm -f elf64
GRUB = grub-mkrescue

BIN = isofiles/boot/kernel.bin
LINKER = linker.ld
OS = os.iso
ARCH := $(shell getconf LONG_BIT)

all: elf grub

grub:
	grub-mkrescue -o $(OS) isofiles

elf: boot
	$(LD) -o $(BIN) -T $(LINKER) multiboot_header.o boot.o

boot:
	$(NASM) multiboot_header.asm
	$(NASM) boot.asm

clean:
	rm -f *.o $(BIN) $(OS)

start:
	qemu-system-x86_64 -cdrom $(OS)
