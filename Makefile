#Dependencies
CEU_DIR    		= modules/ceu
CEU_UV_DIR 		= modules/ceu-libuv
CEU_MEDIA_DIR	= modules/ceu-media
LUA						= lua5.3

#paths
BASE_PATH					= include
MARS_PATH 				= $(BASE_PATH)/mars
MARS_UTIL_PATH    = $(MARS_PATH)/util
MARS_SERVER_PATH  = $(MARS_PATH)/server
MARS_CLIENT_PATH  = $(MARS_PATH)/client
MARS_LUA_UTIL			= $(MARS_UTIL_PATH)/mars-util.lua

#all target
all: SRC 						= $(error set SRC to a CÉU program)
all: SRC_SED 				= $(SRC://=\/)
all: MODULES 				= play lua5.3 libuv
all: SRC_NAME				= $(notdir $(SRC))
all: MAESTRO 				= $(BASE_PATH)/sync/maestro.ceu
all: EVTS  					= $(MARS_UTIL_PATH)/mars-compile-evts.lua
all: INPUT_GEN  	  = $(MARS_UTIL_PATH)/mars-input-gen.lua
all: LUA_CLIENT		  = $(MARS_CLIENT_PATH)/mars-client.lua
all: CC_ARGS				= -DCEU_MEDIA_WCLOCK_DISABLE -DCEU_UV_WCLOCK_DISABLE

#server target
server: MODULES 					= lua5.3 libuv
server: SRC_NAME					= $(notdir $(SRC))
server: LUA_SERVER				= $(MARS_SERVER_PATH)/mars-server.lua

#both targets
server all: LUA_PEERS_MODULE   = $(MARS_UTIL_PATH)/peers.lua
server all: override CC_ARGS  := $(shell pkg-config $(MODULES) --libs --cflags)\
	-lpthread $(CC_ARGS) -lm -DDEBUG -g
server all: override CEU_ARGS :=

#variables
BIN					= $(SRC_NAME:%.ceu=%)
	BUILD_PATH 	= build
	TEMP 				:= $(BUILD_PATH)/temp-$(shell date --iso=ns).ceu

all:
	mkdir -p $(BUILD_PATH)
	cp $(LUA_PEERS_MODULE) $(BUILD_PATH)/
	cp $(MARS_LUA_UTIL) $(BUILD_PATH)/
	cp $(LUA_CLIENT) $(BUILD_PATH)/
	cp $(MAESTRO) $(TEMP)
	sed s:SRC:"\"$(SRC_SED)\"":g -i $(TEMP)
	$(LUA) $(EVTS) $(TEMP) $(SRC)
	$(LUA) $(INPUT_GEN) $(IDF) $(SRC) $(TEMP)
	ceu --pre --pre-args="-I$(CEU_DIR)/include -I$(CEU_MEDIA_DIR)/include	-I./ \
		-I$(CEU_UV_DIR)/include  -I./include $(CEU_ARGS)"  	 				 						 \
		--pre-input=$(TEMP)																							 				 \
		--ceu --ceu-err-unused=pass --ceu-err-uninitialized=pass							 	 \
		--ceu-features-exception=true --ceu-features-thread=true				 				 \
		--ceu-features-lua=true																					 				 \
		--ceu-output=output.c 																					 				 \
		--env --env-types=$(CEU_DIR)/env/types.h															 	 \
		--env-threads=$(CEU_DIR)/env/threads.h													 				 \
		--env-main=$(CEU_DIR)/env/main.c																 				 \
		--env-output=/tmp/x.c																						 				 \
		--cc --cc-args="$(CC_ARGS)"																						 	 \
		--cc-output=build/$(BIN)
	rm $(TEMP)

server:
	mkdir -p $(BUILD_PATH)
	cp $(LUA_PEERS_MODULE) $(BUILD_PATH)/
	cp $(LUA_SERVER) $(BUILD_PATH)/
	cp $(MARS_LUA_UTIL) $(BUILD_PATH)/
	ceu --pre --pre-args="-I$(CEU_DIR)/include -I$(CEU_MEDIA_DIR)/include			 \
		-I$(CEU_UV_DIR)/include -I./include $(CEU_ARGS)"												 \
		--pre-input=$(SRC)																											 \
		--ceu --ceu-err-unused=pass --ceu-err-uninitialized=pass								 \
		--ceu-features-exception=true --ceu-features-thread=true								 \
		--ceu-features-lua=true																									 \
		--ceu-output=output.c 																									 \
		--env --env-types=$(CEU_DIR)/env/types.h																 \
		--env-threads=$(CEU_DIR)/env/threads.h																	 \
		--env-main=$(CEU_DIR)/env/main.c																				 \
		--env-output=/tmp/x.c																										 \
		--cc --cc-args="$(CC_ARGS) -I./include"																	 \
		--cc-output=build/$(BIN)

clean:
	rm -rf $(BUILD_PATH)
