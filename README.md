# novena-debian-installer
Modifies a Debian installer to be useable for Novena

At the moment it is designed to do a installation from a MicroSD card to a SSD or Harddisk on the SATA port, where the root partition will end up in /dev/sda2, or the system uses an LUKS encrypted partition.
If you have a different partitioning layout, please adapt the uEnv*.txt accordingly.

To use the installer, you can get a ready-made image from http://www2.futureware.at/novena/novena-installer-microsd.img (sha512sum is fb4a59938ea2fea47af401825c532e5637e62e839abc4c638334e4aedb067e81b4eb886e61653c39d02c365dc55636c7f83c5b96f3ea1c48f6793c1c7efa42d0), copy that to a MicroSD card with dd or some other imaging tool, and then boot your Novena from that MicroSD card.

To build the image yourself, take the standard Novena Micro-SD image ( http://repo.novena.io/novena/images/novena-mmc-disk-r1.img ), enlarge the boot partition (or copy the files and create a new msdos partition), run makeinstall.sh on a Novena system, and then copy the files that are generated in boot/ to the boot partition.

The installer will automatically rename the uInitrd to uInitrd-install at the end of the installation, to make sure that the system boots after the installation instead of looping in the installer.
If you want to run the installer again after an installation is completed, just rename uInitrd-install back to uInitrd on the MicroSD card, and the installer will run again on the next boot.

To properly handle kernel updates, 2 hook scripts are installed:
The first one /etc/initramfs-tools/hooks/novena.hook.sh works inside mkinitramfs to add missing kernel modules and firmware images. The second one /etc/kernel/postinst.d/zzz-novena-mkimage runs after mkinitramfs to convert the image to U-Boot format and to copy it onto the SD-card. If you have a non-standard Novena configuration, you might have to adapt those scripts to your environment.

