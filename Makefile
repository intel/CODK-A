TOP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CODK_SW_URL := https://github.com/01org/CODK-A-Software.git
CODK_SW_DIR := $(TOP_DIR)/arduino101_software
CODK_SW_TAG ?= master
CODK_FW_URL := https://github.com/01org/CODK-A-Firmware.git
CODK_FW_DIR := $(TOP_DIR)/arduino101_firmware
CODK_FW_TAG ?= master
CODK_BL_URL := https://github.com/01org/CODK-A-Bootloader.git
CODK_BL_DIR := $(CODK_FW_DIR)/bsp/bootable/bootloader
CODK_BL_TAG ?= master
CODK_FLASHPACK_URL := https://github.com/01org/CODK-A-Flashpack.git
CODK_FLASHPACK_DIR := $(TOP_DIR)/arduino101_flashpack
CODK_FLASHPACK_TAG ?= master

CODK_DIR ?= $(TOP_DIR)
FWPROJ_DIR ?= $(CODK_FW_DIR)/projects/arduino101/
SWPROJ_DIR ?= $(CODK_SW_DIR)/examples/Blink/

help:
	
check-root:
	@if [ `whoami` != root ]; then echo "Please run as sudoer/root" && exit 1 ; fi

install-dep: check-root
	$(MAKE) install-dep -C $(CODK_SW_DIR)
	$(MAKE) one_time_setup -C $(FWPROJ_DIR)

setup: firmware-setup software-setup

clone: $(CODK_SW_DIR) $(CODK_FW_DIR) $(CODK_BL_DIR) $(CODK_FLASHPACK_DIR)

$(CODK_SW_DIR):
	git clone -b $(CODK_SW_TAG) $(CODK_SW_URL) $(CODK_SW_DIR)

$(CODK_FW_DIR):
	git clone -b $(CODK_FW_TAG) $(CODK_FW_URL) $(CODK_FW_DIR)

$(CODK_BL_DIR):
	git clone -b $(CODK_BL_TAG) $(CODK_BL_URL) $(CODK_BL_DIR)

$(CODK_FLASHPACK_DIR):
	git clone -b $(CODK_FLASHPACK_TAG) $(CODK_FLASHPACK_URL) $(CODK_FLASHPACK_DIR)

firmware-setup:
	@echo "Setting up firmware"

software-setup:
	@echo "Setting up software"
	@$(MAKE) -C $(CODK_SW_DIR) setup

compile: compile-firmware compile-software

compile-firmware:
	$(MAKE) setup image -C $(FWPROJ_DIR)

compile-software:
	$(MAKE) -C $(SWPROJ_DIR) compile

upload: upload-dfu

upload-dfu: upload-firmware-dfu upload-software-dfu

upload-firmware-dfu:
	cd $(CODK_FLASHPACK_DIR) && ./create_flasher.sh
	cd $(CODK_FLASHPACK_DIR) && ./flash_dfu.sh

upload-software-dfu:
	$(MAKE) -C $(SWPROJ_DIR) upload

upload-jtag: upload-firmware-jtag upload-software-jtag

upload-firmware-jtag:
	cd $(CODK_FLASHPACK_DIR) && ./create_flasher.sh
	cd $(CODK_FLASHPACK_DIR) && ./flash_jtag.sh

upload-software-jtag:
	# To-do

clean: clean-firmware clean-software

clean-firmware:
	-rm -rf out pub flashpack.zip

clean-software:
	$(MAKE) -C $(SWPROJ_DIR) clean-all
