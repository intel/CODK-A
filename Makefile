TOP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CODK_ARC_URL := https://github.com/01org/CODK-A-ARC.git
CODK_ARC_DIR := $(TOP_DIR)/arc
CODK_ARC_TAG ?= master
CODK_X86_URL := https://github.com/01org/CODK-A-X86.git
CODK_X86_DIR := $(TOP_DIR)/x86
CODK_X86_TAG ?= master
CODK_BL_URL := https://github.com/01org/CODK-A-Bootloader.git
CODK_BL_DIR := $(CODK_X86_DIR)/bsp/bootable/bootloader
CODK_BL_TAG ?= master
CODK_FLASHPACK_URL := https://github.com/01org/CODK-A-Flashpack.git
CODK_FLASHPACK_DIR := $(TOP_DIR)/flashpack
CODK_FLASHPACK_TAG ?= master

CODK_DIR ?= $(TOP_DIR)
X86_PROJ_DIR ?= $(CODK_X86_DIR)/projects/arduino101/
ARC_PROJ_DIR ?= $(CODK_ARC_DIR)/examples/ASCIITable/

help:
	
check-root:
	@if [ `whoami` != root ]; then echo "Please run as sudoer/root" && exit 1 ; fi

install-dep: check-root
	$(MAKE) install-dep -C $(CODK_ARC_DIR)
	$(MAKE) one_time_setup -C $(X86_PROJ_DIR)

setup: x86-setup arc-setup

clone: $(CODK_ARC_DIR) $(CODK_X86_DIR) $(CODK_BL_DIR) $(CODK_FLASHPACK_DIR)

$(CODK_ARC_DIR):
	git clone -b $(CODK_ARC_TAG) $(CODK_ARC_URL) $(CODK_ARC_DIR)

$(CODK_X86_DIR):
	git clone -b $(CODK_X86_TAG) $(CODK_X86_URL) $(CODK_X86_DIR)
	ln -s $(abspath $(CODK_X86_DIR)) $(TOP_DIR)firmware

$(CODK_BL_DIR):
	git clone -b $(CODK_BL_TAG) $(CODK_BL_URL) $(CODK_BL_DIR)

$(CODK_FLASHPACK_DIR):
	git clone -b $(CODK_FLASHPACK_TAG) $(CODK_FLASHPACK_URL) $(CODK_FLASHPACK_DIR)

x86-setup:
	@echo "Setting up x86"

arc-setup:
	@echo "Setting up ARC"
	@$(MAKE) -C $(CODK_ARC_DIR) setup

compile: compile-x86 compile-arc

compile-x86:
	$(MAKE) setup image -C $(X86_PROJ_DIR)

compile-arc:
	CODK_DIR=$(CODK_DIR) $(MAKE) -C $(ARC_PROJ_DIR) compile

upload: upload-dfu

upload-dfu: upload-x86-dfu upload-arc-dfu

upload-x86-dfu:
	cd $(CODK_FLASHPACK_DIR) && ./create_flasher.sh
	cd $(CODK_FLASHPACK_DIR) && ./flash_dfu.sh

upload-arc-dfu:
	CODK_DIR=$(CODK_DIR) $(MAKE) -C $(ARC_PROJ_DIR) upload

upload-jtag: upload-x86-jtag upload-arc-jtag

upload-x86-jtag:
	cd $(CODK_FLASHPACK_DIR) && ./create_flasher.sh
	cd $(CODK_FLASHPACK_DIR) && ./flash_jtag.sh

upload-arc-jtag:
	# To-do

clean: clean-x86 clean-arc

clean-x86:
	-rm -rf out pub flashpack.zip

clean-arc:
	CODK_DIR=$(CODK_DIR) $(MAKE) -C $(ARC_PROJ_DIR) clean-all

debug-server:
	$(CODK_FLASHPACK_DIR)/bin/openocd.l64 -f $(CODK_FLASHPACK_DIR)/scripts/interface/ftdi/flyswatter2.cfg -f $(CODK_FLASHPACK_DIR)/scripts/board/quark_se.cfg

debug-x86:
	gdb $(TOP_DIR)/out/current/firmware/quark.elf

debug-arc:
	$(CODK_ARC_DIR)/arc32/bin/arc-elf32-gdb $(ARC_PROJ_DIR)/arc-debug.elf
