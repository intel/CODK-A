DISCONTINUATION OF PROJECT.

This project will no longer be maintained by Intel.

Intel has ceased development and contributions including, but not limited to, maintenance, bug fixes, new releases, or updates, to this project. 

Intel no longer accepts patches to this project.

If you have an ongoing need to use this project, are interested in independently developing it, or would like to maintain patches for the open source software community, please create your own fork of this project. 
# Curie Open Development Kit - A

For Intel Community Support, product questions, or help troubleshooting, visit
ICS: [https://communities.intel.com/community/tech/intel-curie](https://communities.intel.com/community/tech/intel-curie)

|

### Contents

  - x86: Arduino 101 Firmware
  - ARC: Arduino sketches or `*.cpp`

### Supported Platforms
 - Ubuntu 14.04 - 64 bit

### Installation
```
mkdir -p ~/CODK && cd $_
git clone https://github.com/01org/CODK-A.git
cd CODK-A
make clone
sudo make install-dep
make setup
export CODK_DIR=$(pwd)
```

### Compile
- x86: `make compile-x86`
- ARC: `make compile-arc`
- Both: `make compile`

### Upload

##### Using USB/DFU
- x86: `make upload-x86-dfu`
- ARC: `make upload-arc-dfu`
- Both: `make upload`

##### Using JTAG
- x86: `make upload-x86-jtag`
- ARC: `make upload-arc-jtag`
- Both: `make upload-jtag`

Default app prints the ASCII table over the serial port.
To see the output, connect at 9600 bps to the CDC ACM virtual serial port
the Arduino 101 shows up under, e.g. `/dev/ttyACM0`.

#### BLE Firmware
Curie ODK requires an updated BLE firmware. If you're on a factory version, please update.    
The script will prompt you to manually reset the board.
- BLE: `make upload-ble-dfu`

### Debug
Connect JTAG and open three terminal tabs

##### Tab 1: Debug Server
`make debug-server`

##### Tab 2: x86
`make debug-x86`    
`(gdb) target remote localhost:3334`

##### Tab 3: ARC
`make debug-arc`    
`(gdb) target remote localhost:3333`
