CEU_DIR    = /home/rcms/workspace/ceu
CEU_MEDIA_DIR = /home/rcms/workspace/ceu-media
CEU_UV_DIR = /home/rcms/workspace/ceu-libuv

CFLAGS = `pkg-config play lua5.3 libuv --libs --cflags` -l pthread

SRC_NAME= $(notdir $(SRC))
BIN = $(SRC_NAME:%.ceu=%)

all:
	ceu --pre --pre-args="-I$(CEU_DIR)/include -I$(CEU_MEDIA_DIR)/include -I$(CEU_UV_DIR)/include -I./include" \
	          --pre-input=$(SRC)                                  \
	    --ceu --ceu-err-unused=pass --ceu-err-uninitialized=pass            \
	    --env --env-types=$(CEU_DIR)/env/types.h                         \
	          --env-threads=$(CEU_DIR)/env/threads.h                     \
	          --env-main=$(CEU_DIR)/env/main.c                           \
	          --env-output=/tmp/x.c                                         \
	    --cc --cc-args="$(CFLAGS)" \
	         --cc-output=/tmp/$(BIN)
	/tmp/$(BIN)
