
[![Discord](https://img.shields.io/discord/463752820026376202.svg?label=reMarkable&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://discord.gg/ATqQGfu)
[![rm1](https://img.shields.io/badge/rM1-supported-green)](https://remarkable.com/store/remarkable)
[![rm2](https://img.shields.io/badge/rM2-unsupported-red)](https://remarkable.com/store/remarkable-2)

# Remarkable tablet system tools 
Please be aware that you can potentially break your remarkable tablet. Even if unlikely even bricking it behind repair.
Nobody is responsible for the actions you are taking with this scripts.

The uuu (Universial Update Utility) tool was created by NXP and made avilable under the BSD license. 
Please check here for details:
https://github.com/NXPmicro/mfgtools

This is a community effort. Please do not contact the rM-team. They are helpful but cannot provide support for third-party acitvities. 

## Preperation
### Clone this repository
```bash
git clone https://github.com/ddvk/remarkable-uuuflash.git 
cd remarkable-uuuflash
```
### Set the rM into recovery mode
* Attach the rM tablet via USB to the host machine
* Power-off the rM tablet
* Set it into upload mode, by pressing the middle (home) button and then the power button for > 3 seconds. The display will not change, there will be no feedback! 
* To control if the mode was set type:
```bash
dmesg
```
One of the last messages should be something (usb address might be different) like:
```
 hid-generic 0003:15A2:0063.0008: hiddev1,hidraw3: USB HID v1.10 Device [Freescale SemiConductor Inc  SE Blank MEGREZ] on usb-0000:00:1a.0-1.3/input0
```
Now you are ready to start the following actions from within this repository
## Actions

Depending on your system you might have to run the uuu tool with sudo rights, or as a better alternative create some udev rules.

### Boot into a recovery serial console
To boot into recovery use:
```bash
./uuu recover.uuu 
```
After the loading of the recovery image you should be able to login via a serial client
## Linux
```bash
minicom -D /dev/ttyACM0
```
or
```bash
screen /dev/ttyACM0
```
Please notice, that the name of the device might be different depending on your system. 
If this does not work, check with `dmesg` the current status, there should be a line like:
```bash
cdc_acm 1-1.3:1.2: ttyACM0: USB ACM device
```
Note that the name of the serial device might differ from distro to distro. Try again, with the correct name, if no device is shown under dmesg. Something might have gone wrong. In that case please report your problems. Please be aware that the access to the serial device might require root rights, depending on your system. 

## Windows (not yet fully tested, may need additional drivers)
You can use `putty` to establish a serial connection to the COM device it's listed as (Example: COM3). Check the `Device Manager` for unknown usb devices and/or `Event Viewer`

If your device is recognized as a "CDC Composite Gadget" after running `uuu.exe recover.uuu`, use the following steps to allow Windows to communicate with it over serial:

1. Open device manager.  
2. Right click "CDC Composite Gadget"
3. Click "Properties"
4. Go to the "Driver" tab
5. Click "Update Driver"
6. "Browse my computer for driver software"
7. "Let me pick from a list..."
8. Select "Ports (COM & LPT)"
8. Select "Microsoft" from the Manufacturer list
9. Select "USB Serial Device" from the Model list
10. Click "Next" and allow the driver to install


## macOS

### Option 1: install uuu via homebrew

For ARM and Intel based Macs you can install the necessary uuu utility via Homebrew
```
brew install uuu
```

### Option 2: Use uuu-mac provided in this repo

Included in this repo is the "uuu-mac" compiled for x86. Intel-based Macs can run this utility directly but you *also* need libzip and libusb.

ARM Macs can (theoretically) run this version of the utility under Rosetta. However it is dependent on libzip and libusb and attempts to look for them in x86-specific directories. If you attempt to run it and see an error such as below you will need to use Option 1 or find and install those libraries manually
```
$ ./uuu-mac
dyld[79392]: Library not loaded: /usr/local/opt/libusb/lib/libusb-1.0.0.dylib
...
```

On Intel Macs you can install zlib and libusb via Homebrew:
```
brew install libzip
brew install libusb
```

then start:
```
./uuu-mac ./recover.uuu
screen /dev/tty.usbmodem1A1103
```

A login prompt will appear:
```bash 
Frankenboot rmrestore /dev/ttyGS0

rmrestore login:
```
To login use `root` as user.
#### Mount flash memory
The entire visible system is the initramfs within the rM RAM. Thus, the flash memory partitions of the real system have to be mounted, if you want to access it.
* Mount the internal flash memory partitions
```bash 
mount /dev/mmcblk1p2 /mnt/
mount /dev/mmcblk1p7 /mnt/home
mount /dev/mmcblk1p1 /mnt/var/lib/uboot
```
* For convince, one can chroot into the real system.
```bash 
chroot /mnt
```
* You can now change settings or reset passwords, etc. After you finished, type 
```bash 
exit #if you used the chroot
reboot
``` 
to restart the rM tablet and boot into the normal operation mode.

### Semi Upgrade (overwriting the root with version 2.1.1.3)
Use
```bash
./uuu upgrade.uuu
```
This will overwrite both root partitions with the version 2.1.1.3, use if you really cannot fix it yourself.

### Reflash  (if nothing else helps)
** This will delete all your files, use as last resort **

Use
```bash
./uuu reflash.uuu
```
This will rewrite the bootloader, repartition the device aka (mfgtools), thus deleting home and everyting.

### Sources
- remarkable / imx_usb_tool (initramfs) [https://github.com/reMarkable/imx_usb_loader]
- uuu [https://github.com/NXPmicro/mfgtools]
- uboot (modified to ignore env variables) [to be pushed]
- zImages-fsl [SCR-4.14.98_2.0.0_ga.txt]
