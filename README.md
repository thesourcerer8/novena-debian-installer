# novena-debian-installer
Modifies a Debian installer to be useable for Novena

About

At the moment it is designed to do a installation from a MicroSD card to a SSD or Harddisk on the SATA port, where the root partition will end up in /dev/sda2, or the system uses an LUKS encrypted partition.
If you have a different partitioning layout, please adapt the uEnv*.txt accordingly.

To use the installer, you can get a ready-made image from http://www2.futureware.at/novena/novena-installer-microsd.img (sha512sum is fb4a59938ea2fea47af401825c532e5637e62e839abc4c638334e4aedb067e81b4eb886e61653c39d02c365dc55636c7f83c5b96f3ea1c48f6793c1c7efa42d0), copy that to a MicroSD card with dd or some other imaging tool, and then boot your Novena from that MicroSD card.

When asked what kernel to install, select "none".

If you are not going to run a GUI, you can run the following command to remove uneeded novena packages:

apt-get remove novena-eeprom-gui pulseaudio-novena xorg-novena ntpdate kosagi-repo libdrm-armada-dev libdrm-armada2 libdrm-armada2-dbg xserver-xorg-video-armada xserver-xorg-video-armada-dbg xserver-xorg-video-armada-etnaviv



To build the image yourself, take the standard Novena Micro-SD image ( http://repo.novena.io/novena/images/novena-mmc-disk-r1.img ), enlarge the boot partition (or copy the files and create a new msdos partition), run makeinstall.sh on a Novena system, and then copy the files that are generated in boot/ to the boot partition.

The installer will automatically rename the uInitrd to uInitrd-install at the end of the installation, to make sure that the system boots after the installation instead of looping in the installer.
If you want to run the installer again after an installation is completed, just rename uInitrd-install back to uInitrd on the MicroSD card, and the installer will run again on the next boot.

To properly handle kernel updates, 2 hook scripts are installed:
The first one /etc/initramfs-tools/hooks/novena.hook.sh works inside mkinitramfs to add missing kernel modules and firmware images. The second one /etc/kernel/postinst.d/zzz-novena-mkimage runs after mkinitramfs to convert the image to U-Boot format and to copy it onto the SD-card. If you have a non-standard Novena configuration, you might have to adapt those scripts to your environment.

Most of the novena specific packages are installed, but the following are not installed:

- firmware-senoko
- novena-whack-lcd
- novena-bluetooth-reset
- novena-heirloom

Installing firmware-senoko is recommended after install (this is not installed automatically due to possible user intervention, leaving the user with a broken installer).


KNOWN BUGS

If you get a problem with the clock set up, the install will fail. you must disconnect AC and battery power and restart the install. This is related to problems described here: http://www.kosagi.com/forums/viewtopic.php?id=369

CONTRIBUTORS

- xobs
- chris4795
