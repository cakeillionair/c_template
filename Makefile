SHELL := bash

CC      := gcc
CFLAGS  := \
	-std=c23 \
	-Wall \
	-Wextra \
	-O2
CCFLAGS  := $(CFLAGS) -c
DBGFLAGS := \
	-Og \
	-fsanitize=address \
	-DDEBUG

BIN_PATH := bin
OBJ_PATH := obj
SRC_PATH := src
DBG_PATH := dbg
INC_PATH := inc

// TODO edit
project_name := C_PROJECT_TEMPLATE

// TODO edit
TARGET_NAME  := template
TARGET       := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DEBUG := $(DBG_PATH)/$(TARGET_NAME)

SRC       := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*)))
OBJ       := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ_DEBUG := $(addprefix $(DBG_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
INC       := $(foreach x, $(INC_PATH), $(wildcard $(addprefix $(x)/*,.h*)))

DISTCLEAN_LIST := \
	$(OBJ) \
	$(OBJ_DEBUG)
CLEAN_LIST     := \
	$(TARGET) \
	$(TARGET_DEBUG) \
	$(DISTCLEAN_LIST)

RED    := "\\e[31m"
GREEN  := "\\e[32m"
YELLOW := "\\e[33m"
PURPLE := "\\e[35m"
CYAN   := "\\e[36m"
RESET  := "\\e[0m"

default: makedir all

$(TARGET): $(OBJ)
	@$(CC) $(CFLAGS) -o $@ $^
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"
$(TARGET_DEBUG): $(OBJ_DEBUG)
	@$(CC) $(CFLAGS) $(DBGFLAGS) -o $@ $^
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"
$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c* $(INC)
	@$(CC) $(CCFLAGS) -o $@ $< -I $(INC_PATH)
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"
$(DBG_PATH)/%.o: $(SRC_PATH)/%.c* $(INC)
	@$(CC) $(CCFLAGS) $(DBGFLAGS) -o $@ $< -I $(INC_PATH)
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"

FOLDERS := $(BIN_PATH) $(OBJ_PATH) $(DBG_PATH) $(INC_PATH)
makedir:
	@for file in $(FOLDERS); do \
		if mkdir $$file &> /dev/null; then \
			echo -e "$(CYAN)[MKDIR] $$file$(RESET)"; \
		fi \
	done 
cleanbuild: makedir clean all debug
all: $(TARGET)
debug: $(TARGET_DEBUG)
clean:
	@for file in $(CLEAN_LIST); do \
	    if rm $$file &> /dev/null; then \
	    	echo -e "$(RED)[CLEAN] $$file$(RESET)"; \
		fi \
	done
distclean:
	@for file in $(DISTCLEAN_LIST); do \
	    if rm $$file &> /dev/null; then \
	    	echo -e "$(RED)[CLEAN] $$file$(RESET)"; \
		fi \
	done