# novena-debian-installer
Modifies a Debian installer to be useable for Novena

At the moment it is designed to do a installation from a MicroSD card to a SSD or Harddisk on the SATA port, where the root partition will end up in /dev/sda2, or the system uses an LUKS encrypted partition.
If you have a different partitioning layout, please adapt the uEnv*.txt accordingly.

To use the installer, you can get a ready-made image from http://www2.futureware.at/novena/novena-installer-microsd.img (sha512sum is fb4a59938ea2fea47af401825c532e5637e62e839abc4c638334e4aedb067e81b4eb886e61653c39d02c365dc55636c7f83c5b96f3ea1c48f6793c1c7efa42d0), copy that to a MicroSD card with dd or some other imaging tool, and then boot your Novena from that MicroSD card.

To build the image yourself, take the standard Novena Micro-SD image ( http://repo.novena.io/novena/images/novena-mmc-disk-r1.img ), enlarge the boot partition (or copy the files and create a new msdos partition), run makeimage.sh on a Novena system, and then copy the files that are generated in boot/ to the boot partition.

The installer will automatically rename the uInitrd to uInitrd-install at the end of the installation, to make sure that the system boots after the installation instead of looping in the installer.
If you want to run the installer again after an installation is completed, just rename uInitrd-install back to uInitrd on the MicroSD card, and the installer will run again on the next boot.

To properly handle kernel updates, 3 hook scripts are installed:
The first one /etc/initramfs-tools/hooks/novena-hook.sh works inside mkinitramfs to add missing kernel modules and firmware images. The second one /etc/kernel/postinst.d/z-kernel-backup backs up any old boot images in case something goes wrong. The third one /etc/kernel/postinst.d/zzz-novena-mkimage runs after mkinitramfs to convert the image to U-Boot format and to copy it onto the SD-card. If you have a non-standard Novena configuration, you might have to adapt those scripts to your environment.

Note that you will have to change the UUID in uEnv.txt to your system. When you get to the recovery, go to /dev/disk/by-uuid to find the correct one. Assuming you picked "place all in one partition", the right UUID should be the second from the right. However, if it isnt, the process of elimination will figure it out.

Also note, if you are installing a new SSD (from http://www.kosagi.com/w/index.php?title=Novena_Main_Page):
If the *rootfs_ssd* flag is set in the EEPROM, then the root parameter is set to **PARTUUID=4e6f7653-03**. If the *rootfs_ssd* flag is not set, or if booting into recovery mode, then the root parameter is set to **PARTUUID=4e6f764d-03**. This means that you should set your disk up such that the root partition is partition 3 (i.e. /dev/sda3), and set your disk ID correctly. To set the diskid, run fdisk on the disk, then go into Expert mode ('x'), then:

    For MBR partition tables: Change ID ('i') to 0x4e6f7653.
    For GPT partition tables: Change partition UUID ('u'). Note: fdisk wants the UUID in full 8-4-4-4-12 format, so you will want to make up some additional digits, e.g. 4e6f764d-0300-0000-0000-012345678901.

Most of the novena specific packages are installed, but the following are not installed:

 - firmware-senoko
 - novena-whack-lcd
 - novena-bluetooth-reset
 - novena-heirloom

Installing firmware-senoko is recommended after install. 
