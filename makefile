
target  := grbl_hc32l13x

drivers	:= $(wildcard driver/*.c)
srcs	+= $(wildcard user/*.c)
startups := user/startup_hc32l13x


LIBDIR	:= -L lib
LIBS	:= -lc -lm -lnosys -ldriver
LDFLAG	:= $(LIBDIR) $(LIBS)

CC      = arm-none-eabi-
AS 		= $(CC)gcc -x assembler-with-cpp
INCLUDE += -Iinclude -Iinclude/cmsis -Iinclude/driver -Iconfig
CFLAG	:= -mthumb -specs=nano.specs
CPU 	:= -mcpu=cortex-m0

OBJS 	:= $(patsubst %.c, %.o, $(drivers) $(srcs)) $(startups).o


all : startup liba link
	$(info )
	$(info )
	$(info )
	$(info )
	$(info )
	$(info )
	$(info ****************** build finish ******************)
	@/bin/bash -c 'ls -lh $(target).*'
	
	
startup:
	$(CC)gcc $(CFLAG) $(CPU) $(INCLUDE) -c $(startups).s -o $(startups).o  -lnosys

link : $(patsubst %.c, %.o, $(srcs)) $(startups).o
	$(CC)gcc $^ -Tuser/hc32l13x.lds $(LDFLAG) -Wl,-Map=$(target).map -o $(target).elf  
	$(CC)objdump -d $(target).elf  > $(target).dis
	$(CC)objcopy -O binary -S $(target).elf $(target).bin

liba : $(patsubst %.c, %.o, $(drivers))
	$(info $^)
	mkdir lib -p
	ar -rcs lib/libdriver.a $^


%.o : %.c
	$(CC)gcc $(CFLAG) $(CPU) $(INCLUDE) $(LDFLAG) -c $^ -o $@

%.o : %.s
	$(CC)gcc $(CFLAG) $(CPU) $(INCLUDE) $(LDFLAG) -c $^ -o str.o

.PHONY:clean
clean:
	rm -rf $(OBJS) lib/* *.elf *.dis *.map *.bin
	clear
#$(CC)ld -Tuser/hc32l13x.lds -o $(target).elf $^ -Map=$(target).map 

#$(CC)gcc $(CFLAG) $(CPU) -o $(target) $^ $(LDFLAG)

#-Map=$(target).map
#$(CC)gcc $^ -Tuser/hc32l13x.lds $(LDFLAG) -Wl,-Map=$(target).map,--cref -o $(target).elf 

#$(info $(srcs))
#$(info $(OBJS))
