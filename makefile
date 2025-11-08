#-- Directories --
BIN_DIR   = Bin
OBJ_DIR   = Object
BUILD_DIR = Build
C_DIR     = SRCC
MAC_DIR   = $(C_DIR)/Macros
DRV_DIR   = $(C_DIR)/drivers
KRN_DIR   = $(C_DIR)/kernel
ASM_DIR   = SRCASM
TOOLS     = ./Tools/bin
#-- Directories --

#-- Shortcuts --
CC = $(TOOLS)/i686-elf-gcc.exe
LD = $(TOOLS)/i686-elf-ld.exe
ASM = nasm
#-- Shortcuts --

#-- Flags --
CFLAGS = -I $(C_DIR) -ffreestanding -fno-pic -fno-pie -mno-red-zone -nostdlib -nostartfiles
#-- Flags --


#-- Source Files --
C_SOURCES  = $(wildcard $(C_DIR)/*.c $(MAC_DIR)/*.c $(DRV_DIR)/*.c $(KRN_DIR)/*.c)
ASM_SOURCES = $(wildcard $(ASM_DIR)/boot.asm $(ASM_DIR)/postBoot.asm)
#-- Source Files --


#-- Flattened Objects --
OBJ_LIST = $(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(C_SOURCES)))
ASM_OBJ  = $(OBJ_DIR)/KernelEntry.o
#-- Flattened Objects --


#-- Output Binaries --
BIN_LIST = $(patsubst $(ASM_DIR)/%.asm,$(BIN_DIR)/%.bin,$(ASM_SOURCES)) \
           $(BIN_DIR)/Kernel.bin
#-- Output Binaries --


#-- Build Targets --
all: run

run: $(BUILD_DIR)/boot.img
	bochs -f "bochsrc.txt"

debug: $(BUILD_DIR)/boot.img
	bochs -f "bochsrc.txt" -dbg

build: $(BIN_LIST)
	cat $^ > $(BUILD_DIR)/boot.img

$(BUILD_DIR)/boot.img: $(BIN_LIST)
	cat $^ > $@
#-- Build Targets --



#-- Assembly Assembling --
$(BIN_DIR)/%.bin: $(ASM_DIR)/%.asm
	$(ASM) $< -f bin -o $@

$(ASM_OBJ): $(ASM_DIR)/KernelEntry.asm
	$(ASM) $< -f elf -o $@
#-- Assembly Assembling --


#-- C Compilation --
$(OBJ_DIR)/%.o: $(C_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(MAC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(DRV_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(KRN_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@
#-- C Compilation --


$(BIN_DIR)/Kernel.bin: $(ASM_OBJ) $(OBJ_LIST)
	$(LD) -T ./linker.ld -o $@ $^ --oformat binary


clean:
	rm -rf $(OBJ_DIR) $(BUILD_DIR) $(BIN_DIR)
	mkdir $(OBJ_DIR) $(BUILD_DIR) $(BIN_DIR)
