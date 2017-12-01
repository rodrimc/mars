#Dependencies
LUA						= lua5.3

#paths
server all: BASE_PATH					= include
server all: MARS_PATH 				= $(BASE_PATH)/mars
server all: MARS_UTIL_PATH    = $(MARS_PATH)/util
server all: MARS_SERVER_PATH  = $(MARS_PATH)/server
server all: MARS_CLIENT_PATH  = $(MARS_PATH)/client

#all target
all: SRC 						= $(error set SRC to a CÉU program)
all: SRC_SED 				= $(SRC://=\/)
all: MODULES 				= play lua5.3 libuv
all: SRC_NAME				= $(notdir $(SRC))
all: MAESTRO 				= $(BASE_PATH)/sync/maestro.ceu
all: EVTS  					= $(MARS_UTIL_PATH)/mars-compile-evts.lua
all: INPUT_GEN  	  = $(MARS_UTIL_PATH)/mars-input-gen.lua

#server target
server: MODULES 					= lua5.3 libuv
server: SRC_NAME					= $(notdir $(SRC))
server: LUA_SERVER				= $(MARS_SERVER_PATH)/mars-server.lua

#both targets
server all: LUA_PEERS_MODULE  = $(MARS_UTIL_PATH)/peers.lua
server all: override CFLAGS := $(shell pkg-config $(MODULES) --libs --cflags)\
																-lpthread $(CFLAGS) -lm -DDEBUG -g

#variables
BIN					= $(SRC_NAME:%.ceu=%)
BUILD_PATH 	= build
TEMP 				:= $(BUILD_PATH)/temp-$(shell date --iso=ns).ceu

all:
	mkdir -p $(BUILD_PATH)
	cp $(LUA_PEERS_MODULE) $(BUILD_PATH)/
	cp $(MAESTRO) $(TEMP)
	sed s:SRC:"\"$(SRC_SED)\"":g -i $(TEMP)
	$(LUA) $(EVTS) $(TEMP) $(SRC)
	$(LUA) $(INPUT_GEN) $(IDF) $(SRC) $(BUILD_PATH)/inputs.ceu
	ceu --pre --pre-args="-I$(CEU_DIR)/include -I$(CEU_MEDIA_DIR)/include	-I./ \
						-I$(CEU_UV_DIR)/include -I$(CEU_LIB_DIR) -I./include"  	 				 \
	          --pre-input=$(TEMP)																							 \
	    --ceu --ceu-err-unused=pass --ceu-err-uninitialized=pass							 \
						--ceu-features-exception=true --ceu-features-thread=true				 \
						--ceu-features-lua=true																					 \
						--ceu-output=output.c \
	    --env --env-types=$(CEU_DIR)/env/types.h															 \
	          --env-threads=$(CEU_DIR)/env/threads.h													 \
	          --env-main=$(CEU_DIR)/env/main.c																 \
	          --env-output=/tmp/x.c																						 \
	    --cc --cc-args="$(CFLAGS)"																						 \
	         --cc-output=build/$(BIN)
	rm $(TEMP)

server:
	mkdir -p $(BUILD_PATH)
	cp $(LUA_PEERS_MODULE) $(BUILD_PATH)/
	cp $(LUA_SERVER) $(BUILD_PATH)/
	ceu --pre --pre-args="-I$(CEU_DIR)/include -I$(CEU_MEDIA_DIR)/include		\
						-I$(CEU_UV_DIR)/include -I$(CEU_LIB_DIR) -I./include"					\
	          --pre-input=$(SRC)																						\
	    --ceu --ceu-err-unused=pass --ceu-err-uninitialized=pass						\
						--ceu-features-exception=true --ceu-features-thread=true			\
						--ceu-features-lua=true																				\
						--ceu-output=output.c \
	    --env --env-types=$(CEU_DIR)/env/types.h														\
	          --env-threads=$(CEU_DIR)/env/threads.h												\
	          --env-main=$(CEU_DIR)/env/main.c															\
	          --env-output=/tmp/x.c																					\
	    --cc --cc-args="$(CFLAGS) -I./include"															\
	         --cc-output=build/$(BIN)

clean:
	rm -rf $(BUILD_PATH)
