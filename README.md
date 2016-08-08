# CODK-A

Curie Open Development Kit - A

  - Firmware: Arduino 101 Firmware
  - Software: Arduino sketches or `*.cpp`

### Supported Platforms
 - Ubuntu 14.04 - 64 bit

### Installation
```
mkdir CODK && cd $_
git clone https://github.com/01org/CODK-A.git
cd CODK-A
sudo make install-dep
make setup
```

### Compile
- Firmware: `make compile-firmware`
- Software: `make compile-software`
- Both: `make compile`

### Upload

##### Using USB/DFU
- Firmware: `make upload-firmware-dfu`
- Software: `make upload-software-dfu`
- Both: `make upload`

##### Using JTAG
- Firmware: `make upload-firmware-jtag`
- Software: `make upload-software-jtag`
- Both: `make upload-jtag`

### Debug
- Coming soon
