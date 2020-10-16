##文件基于sdcc编译器编译宏晶单片机写的程序
#适用型号：stc8a8k64s4a12
#          stc89c51
#          stc89c52
#          也可以添加其他型号（1.注意头文件格式 如果是keil 型的请使用它带
#          工具keil2sdcc.pl 信息来源NOTE 96 PAGE sdcc Compiler User Guid。
#          之后再次手动修改 
#          2.修改下面XRAM_SIZE IRAM_SIZE CODE_SIZE等等）
# 声明此文件可能有错，请使用时验证
# 如果有侵权行为 请告知
#该文件遵循GNU GPL协议
#作者zhizaitianxia
#联系1173053923@qq.com
#使用说明 1.使用环境linux 软件安装 sdcc  stcgal(github)
#         2.修改TARGET  它是目标文件名（注意修改时不要键入多余的空格末尾
#         符号等等不然不知道错在哪里）
#         3.添加文件路径 头文件路径  .c文件路径  下面示意Drivers目录下有 bsp_led目录，
#         该目录含有（led.c led.c） 最后的目录不可以有\符号
#         4.编译  命令行命令  如果使用stc8a8k64s4a12单片机  make MCU=stc8a8k64s4a12
#         此时会编译文件，如果没有错误在输出字符末尾有 OK 字样 其他问题请耐心在网上找答案
#         5.烧录 编译成功后，连接线断开供电（个人建议如果使用电脑供电，断开地线）
#         烧录时stcgal可以选择很多选项（请参考stcgal文档）  这里只选了一个 频率 FRE
#         如果保持原先频率 命令行 make burn  此时命令行输出waiting for MCU 字样，供电
#         如果要改变频率   命令行 make FRE=12000 burn   这是12Mz(值4000-30000) 供电
#           

######################################
# target    目标文件名
######################################
TARGET = led
#######################################


# C includes
C_INCLUDES_DIR= \
  Drivers/bsp_led \
  Inc \
  Src \
  User
C_INCLUDES =$(patsubst %,-I%,$(C_INCLUDES_DIR))
######################################
# source
######################################
# C sources

C_SOURCES_DIR = \
  Drivers/bsp_led \
  Inc \
  Src \
  User


C_SOURCES = $(foreach var,$(C_SOURCES_DIR),$(wildcard $(var)/*.c))

# ASM sources
ASM_SOURCES =  \

#配置
#型号参数
#MCU  型号stc89c51
#XRAM_LOC   内部扩展的外部ram  起始地址
#XRAM_SIZE  内部扩展的外部ram 的大小
#CODE_SIZE  程序存储器大小
MCU ?=stc89c51

ifeq ($(MCU),stc89c52)
    XRAM_LOC :=0x0100
    IRAM_SIZE :=0xff
    XRAM_SIZE :=0xff
    CODE_SIZE :=0x2000
else ifeq ($(MCU),stc8a8k64s4a12)
    XRAM_LOC :=0x0100
    IRAM_SIZE :=0xff
    XRAM_SIZE :=0x1f01
    CODE_SIZE :=0x10000
else
    XRAM_LOC ?=0x0100
    IRAM_SIZE ?=0xff
    XRAM_SIZE ?=0xff
    CODE_SIZE ?=0x1000
endif

#通用
#编译 参数
MCU_SPEED ?=--opt-code-speed

CFLAGS :=$(MCU_SPEED)
#优化 or 链接 参数
MODEL =
#MODEL =--model-large
SET_IRAM_SIZE :=--iram-size $(IRAM_SIZE)
SET_XRAM_SIZE :=--xram-size $(XRAM_SIZE)
SET_XRAM_LOC  :=--xram-loc $(XRAM_LOC)
SET_CODE_SIZE :=--code-size $(CODE_SIZE)
ASFLAGS +=$(MODEL) $(SET_IRAM_SIZE) $(SET_XRAM_SIZE) $(SET_XRAM_LOC) $(SET_CODE_SIZE)

#burn 下载时的参数选择
#FRE  频率  4000--30000khz
FRE ?=
# paths
#######################################
# Build path
BUILD_DIR = build


#######################################
# binaries  
# CC 编译器名称
# LDS  连接器 将编译好的文件连接
# CP 输出文件 将文件转换为hex
#
#######################################
PREFIX = sdcc

CC = $(PREFIX)  -mmcs51
LDS = $(PREFIX)  -mmcs51
CP =packihx

#all
all:$(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).ihx
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.rel)))
vpath %.c $(sort $(dir $(C_SOURCES)))

$(BUILD_DIR):
	mkdir $@
$(BUILD_DIR)/%.rel: %.c | $(BUILD_DIR)
	$(CC) -c  $(CFLAGS)  $(C_INCLUDES) $< -o  $@
$(BUILD_DIR)/$(TARGET).ihx:$(OBJECTS)  Makefile | $(BUILD_DIR)
	$(LDS)  $(ASFLAGS)  $(OBJECTS) -o $@
$(BUILD_DIR)/%.hex:$(BUILD_DIR)/%.ihx | $(BUILD_DIR)
	$(CP) $^ > $@

#######################################
# clean up
#######################################
.PHONY:clean
clean:
	-rm -fR $(BUILD_DIR)
print:
	@echo $(C_SOURCES)
	@echo $(OBJECTS)
.PHONY:burn
burn:
ifeq ($(FRE),)
	stcgal -a  ./build/$(TARGET).hex
else
	stcgal -a -t $(FRE) ./build/$(TARGET).hex
endif

