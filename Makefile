TARGET=demo.hex
EXECUTABLE=demo.elf

CC=arm-none-eabi-gcc
#LD=arm-none-eabi-ld
LD=arm-none-eabi-gcc
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
CP=arm-none-eabi-objcopy
OD=arm-none-eabi-objdump

BIN=$(CP) -O ihex

DEFS = -DUSE_STDPERIPH_DRIVER -DSTM32F401xC -DMANGUSTA_DISCOVERY -DHSE_VALUE=8000000

MCU = cortex-m4
MCFLAGS = -mcpu=$(MCU) -mthumb -mlittle-endian -mfpu=fpv4-sp-d16 -mfloat-abi=hard  -specs=nosys.specs
#-mfpu=fpa -mfloat-abi=hard -mthumb-interwork
STM32_INCLUDES = -I $(STM32_BSP) \
	-I $(STM32_CMSIS)/Device/ST/STM32F4xx/Include/ \
	-I $(STM32_CMSIS)/Include/ \
	-I $(STM32_HAL)/Inc/ \
	-I Inc/
OPTIMIZE       = -Os

CFLAGS	= $(MCFLAGS)  $(OPTIMIZE)  $(DEFS) -I./ -I./ $(STM32_INCLUDES)  -Wl,-T,STM32F401CC_FLASH.ld
AFLAGS	= $(MCFLAGS)

SRC = Src/main.c \
	Src/stm32f4xx_it.c \
	Src/system_stm32f4xx.c \
	Src/stm32f401_discovery.c \
	$(STM32_HAL)Src/*.c \


STARTUP = startup_stm32f401xc.s

OBJDIR = .
OBJ = $(SRC:%.c=$(OBJDIR)/%.o)
OBJ += Startup.o


all: $(TARGET)

$(TARGET): $(EXECUTABLE)
	$(CP) -O ihex $^ $@

$(EXECUTABLE): $(SRC) $(STARTUP)
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f Startup.lst  $(TARGET)  $(EXECUTABLE) *.lst $(OBJ) $(AUTOGEN)  *.out *.map \
	 *.dmp
