CEU_DIR    = /home/rodrigocosta/workspace/ceu
CEU_MEDIA_DIR = /home/rodrigocosta/workspace/ceu-media
CEU_UV_DIR = /home/rodrigocosta/workspace/ceu-libuv

all: PROG = $(error set PROG variable to point to a CÉU program)
all: PROG_SED = $(PROG://=\/)

CFLAGS = `pkg-config play lua5.3 libuv --libs --cflags` -l pthread

SRC_NAME= $(notdir $(SRC))
BIN = $(SRC_NAME:%.ceu=%)

BUILD_PATH = build

TEMP = temp.ceu

all:
	mkdir -p $(BUILD_PATH)
	cp $(SRC) $(TEMP)
	sed s:PROG:"\"$(PROG_SED)\"":g -i $(TEMP)
	ceu --pre --pre-args="-I$(CEU_DIR)/include -I$(CEU_MEDIA_DIR)/include		\
						-I$(CEU_UV_DIR)/include -I./include"													\
	          --pre-input=$(TEMP)																						\
	    --ceu --ceu-err-unused=pass --ceu-err-uninitialized=pass						\
	    --env --env-types=$(CEU_DIR)/env/types.h														\
	          --env-threads=$(CEU_DIR)/env/threads.h												\
	          --env-main=$(CEU_DIR)/env/main.c															\
	          --env-output=/tmp/x.c																					\
	    --cc --cc-args="$(CFLAGS)"																					\
	         --cc-output=build/$(BIN)																				\
					 --ceu --ceu-features-lua=true --ceu-features-thread=true
	rm $(TEMP)
	$(BUILD_PATH)/$(BIN)

server:
	mkdir -p $(BUILD_PATH)
	ceu --pre --pre-args="-I$(CEU_DIR)/include -I$(CEU_MEDIA_DIR)/include		\
						-I$(CEU_UV_DIR)/include -I./include"													\
	          --pre-input=$(SRC)																						\
	    --ceu --ceu-err-unused=pass --ceu-err-uninitialized=pass						\
	    --env --env-types=$(CEU_DIR)/env/types.h														\
	          --env-threads=$(CEU_DIR)/env/threads.h												\
	          --env-main=$(CEU_DIR)/env/main.c															\
	          --env-output=/tmp/x.c																					\
	    --cc --cc-args="$(CFLAGS)"																					\
	         --cc-output=build/$(BIN)																				\
					 --ceu --ceu-features-lua=true --ceu-features-thread=true
	$(BUILD_PATH)/$(BIN)

clean:
	rm -rf $(BUILD_PATH)
	rm temp.ceu
