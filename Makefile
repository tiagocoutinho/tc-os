# sudo apt-get install nasm            # The assembler
# sudo apt-get install xorriso         # manipulate ISO fs images
# sudo apt-get install qemu-system-x86 # quick PC system emulator

arch ?= x86_64

src        := src
src_arch   := $(src)/arch/$(arch)

build      ?= build
build_arch := $(build)/arch/$(arch)
build_iso  := $(build)/isofiles
build_boot := $(build_iso)/boot

kernel     := $(build)/kernel-$(arch).bin
iso        := $(build)/os-$(arch).iso

linker_script := $(src_arch)/linker.ld
grub_cfg      := $(src_arch)/grub.cfg
asm_src_files := $(wildcard $(src_arch)/*.asm)
asm_obj_files := $(patsubst $(src_arch)/%.asm, \
	$(build_arch)/%.o, $(asm_src_files))

.PHONY: all clean run iso

all: $(kernel)

clean:
	rm -r build

run: $(iso)
	@qemu-system-x86_64 -cdrom $(iso)

iso: $(iso)

$(iso): $(kernel) $(grub_cfg)
	mkdir -p $(build_boot)/grub
	cp $(kernel) $(build_boot)/kernel.bin
	cp $(grub_cfg) $(build_boot)/grub
	grub-mkrescue -o $(iso) $(build_iso) 2> /dev/null
	rm -r $(build_iso)

$(kernel): $(asm_obj_files) $(linker_script)
	ld -n -T $(linker_script) -o $(kernel) $(asm_obj_files)

# compile assembly files
build/arch/$(arch)/%.o: src/arch/$(arch)/%.asm
	mkdir -p $(shell dirname $@)
	nasm -felf64 $< -o $@
