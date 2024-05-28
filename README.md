# HP MSM460 OpenWrt flashing instructions

NOTE: You can find a repo with up-to-date instructions as well as
the required files here:

https://github.com/blocktrron/msm460-flashing

## Required files

### Command file

You need a command-file with the following content (padded to 131072 bytes).
```
U-BOOT setenv ethaddr 02:03:04:05:06:07; setenv ipaddr 192.168.1.1;
setenv serverip 192.168.1.66; tftpboot 0x3000000 msm460-uboot.bin;
nand device; nand erase 0 0xC0000; nand write 0x3000000 0x0 0xC0000; reset
```

If you copy paste these, remove the newlines!

### U-Boot

You can download the required U-Boot from this repository:

https://github.com/blocktrron/u-boot-msm/releases

## Preperation

Prepare a TFTP server serving two files:

 - U-Boot NAND image as `msm460-uboot.bin`.
 - OpenWrt factory image as `msm460-factory.bin`
 - Command-file names `commands.tftp`

You can start a TFTP server in the current directory using dnsmasq:

```bash
sudo dnsmasq --no-daemon --listen-address=0.0.0.0 \
    --port=0 --enable-tftp=enxd0 --tftp-root="$(pwd)" \
    --user=root --group=root
```
Replace `enxd0` with the name of your network interface.

## Procedure

1. Assign yourself the IP-Address 192.168.1.66/24.
3. Connect the Router to the PC while keeping the reset button pressed.
4. The LEDs will eventually begin to flash.
   They will start to flash faster after around 15 seconds.
5. Release the reset button.
6. Start a new shell
7. Make sure you are currently in the directory where the tftp server is located.
8. Run the following command:

```bash
tftp 192.168.1.1 -m binary -c put commands.tftp nflashd.cccc9999
```

You get the message "Transfer timed out."
To find out if you have been successfull please check the blinking LED Pattern.

![](images/blink-pattern.gif)

