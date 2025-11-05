BIN_DIR = Bin
ASM_DIR = SRCASM
OBJ_DIR = Object
C_DIR = SRCC
BUILD_DIR = Build

ASM_SRC = $(wildcard SRCASM/boot.asm SRCASM/postBoot.asm)
C_SRC = $(wildcard SRCC/*.c )

BIN_OBJ = $(patsubst $(ASM_DIR)/%.asm,$(BIN_DIR)/%.bin,$(ASM_SRC)) $(patsubst $(C_DIR)/%.c,$(BIN_DIR)/%.bin,$(C_SRC))


run:$(BUILD_DIR)/boot.img
	bochs -f "bochsrc.txt"

debug:$(BUILD_DIR)/boot.img
	bochs -f "bochsrc.txt" -dbg

build:$(BIN_OBJ)
	cat $^ > $(BUILD_DIR)/boot.img

$(BUILD_DIR)/boot.img:$(BIN_OBJ)
	cat $^ > $@


$(BIN_DIR)/Kernel.bin:$(OBJ_DIR)/KernelEntry.o $(OBJ_DIR)/Kernel.o
	.\Tools\bin\i686-elf-ld.exe -T ./linker.ld -o $@ $^ --oformat binary

$(OBJ_DIR)/KernelEntry.o:$(ASM_DIR)/KernelEntry.asm
	nasm $< -f elf -o $@

$(BIN_DIR)/%.bin:$(ASM_DIR)/%.asm
	nasm $< -f bin -o $@

$(OBJ_DIR)/%.o: $(C_DIR)/%.c
	.\Tools\bin\i686-elf-gcc.exe -ffreestanding -fno-pic -fno-pie -mno-red-zone -nostdlib -nostartfiles -c $< -o $@


clean:
	rm -rf $(OBJ_DIR) $(BUILD_DIR) $(BIN_DIR)
	mkdir $(OBJ_DIR) $(BUILD_DIR) $(BIN_DIR)

