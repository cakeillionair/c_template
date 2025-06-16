SHELL := bash

CC      := gcc
CFLAGS  := \
	-std=c99 \
	-Wall \
	-Wextra
CCFLAGS  := $(CFLAGS) -c
DBGFLAGS := \
	-O0 \
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
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"
	@$(CC) $(CFLAGS) -o $@ $^
$(TARGET_DEBUG): $(OBJ_DEBUG)
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"
	@$(CC) $(CFLAGS) $(DBGFLAGS) -o $@ $^
$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"
	@$(CC) $(CCFLAGS) -o $@ $^ -I $(INC_PATH)
$(DBG_PATH)/%.o: $(SRC_PATH)/%.c*
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"
	@$(CC) $(CCFLAGS) $(DBGFLAGS) -o $@ $^ -I $(INC_PATH)

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