###############################################################################
# EDIT
###############################################################################

CEU_DIR ?= /home/rodrigocosta/workspace/ceu

###############################################################################
# DO NOT EDIT
###############################################################################

CUR_DIR ?= .
ARCH_DIR ?= $(CUR_DIR)/arch
include $(CEU_DIR)/Makefile

ifneq ($(MAKECMDGOALS),link)
ifeq ("$(wildcard $(CUR_DIR)/arch/up)","")
$(error run "make link")
endif
endif

link:
	rm -f arch/up
	ln -s `readlink -f $(CEU_DIR)/arch` $(CUR_DIR)/arch/up
