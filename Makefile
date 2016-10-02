NASM = nasm -f elf64
LD = ld -nmagic

BIN = kernel.bin
LINKER = linker.ld

elf: boot
	$(LD) -o $(BIN) -T $(LINKER) multiboot_header.o boot.o

boot:
	$(NASM) multiboot_header.asm
	$(NASM) boot.asm

clean:
	rm -f *.o $(BIN)
