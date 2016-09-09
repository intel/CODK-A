# Curie Open Development Kit - A

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

Default app blinks the pin-13 LED on Arduino 101 board

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
