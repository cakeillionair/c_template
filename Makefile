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
	-DDBG

BIN_PATH := bin
OBJ_PATH := obj
SRC_PATH := src
DBG_PATH := dbg
INC_PATH := inc
DEP_PATH := dep

# TODO edit
project_name := C_PROJECT_TEMPLATE

# TODO edit
TARGET_NAME  := template
TARGET       := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DBG := $(DBG_PATH)/$(TARGET_NAME)

SRC     := $(wildcard $(SRC_PATH)/*.c)
OBJ     := $(SRC:$(SRC_PATH)/%.c=$(OBJ_PATH)/%.o)
OBJ_DBG := $(SRC:$(SRC_PATH)/%.c=$(DBG_PATH)/%.o)
DEP     := $(SRC:$(SRC_PATH)/%.c=$(DEP_PATH)/%.d)
DEP_DBG := $(SRC:$(SRC_PATH)/%.c=$(DBG_PATH)/%.d)

DISTCLEAN_LIST := \
	$(OBJ) \
	$(OBJ_DBG) \
	$(DEP) \
	$(DEP_DBG)
CLEAN_LIST     := \
	$(TARGET) \
	$(TARGET_DBG) \
	$(DISTCLEAN_LIST)

RED    := "\\e[31m"
GREEN  := "\\e[32m"
YELLOW := "\\e[33m"
PURPLE := "\\e[35m"
CYAN   := "\\e[36m"
RESET  := "\\e[0m"

default: makedir all debug

-include $(DEP)
-include $(DEP_DBG)

$(TARGET): $(OBJ)
	@$(CC) $(CFLAGS) -o $@ $^
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"
$(TARGET_DBG): $(OBJ_DBG)
	@$(CC) $(CFLAGS) $(DBGFLAGS) -o $@ $^
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"
$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c $(INC)
	@$(CC) -MMD -MF $(DEP_PATH)/$*.d $(CCFLAGS) -o $@ $< -I $(INC_PATH)
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"
$(DBG_PATH)/%.o: $(SRC_PATH)/%.c $(INC)
	@$(CC) -MMD -MF $(DBG_PATH)/$*.d $(CCFLAGS) $(DBGFLAGS) -o $@ $< -I $(INC_PATH)
	@echo -e "$(GREEN)[CREAT] $@$(RESET)"

FOLDERS := $(BIN_PATH) $(OBJ_PATH) $(DBG_PATH) $(INC_PATH) $(DEP_PATH)
makedir:
	@for file in $(FOLDERS); do \
		if mkdir $$file &> /dev/null; then \
			echo -e "$(CYAN)[MKDIR] $$file$(RESET)"; \
		fi \
	done 
cleanbuild: makedir clean all debug
all: $(TARGET)
debug: $(TARGET_DBG)
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