## RM recovery / upgrade flashing
tools for flashing and recovering the remarkable with uuu. 
should work under linux and windows

### for recovery serial console 
- ./uuu recover.uuu
- minicom -D /dev/ttyACM0


### Semi Upgrade (overwriting the root with 2113)
- ./uuu upgrade.uuu

### Sources
- remarkable / imx_usb_tool (initramfs)
- uuu tool
- uboot (modified to ignore env variables)
- zImages-fsl

