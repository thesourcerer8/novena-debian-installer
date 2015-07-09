# novena-debian-installer
Modifies a Debian installer to be useable for Novena

At the moment it is designed to do a normal installation, where the root partition will end up in /dev/sda2
If you have a different partitioning layout, please adapt the uEnv*.txt accordingly

To use the installer, you can get a ready-made image, copy that to a MicroSD card, and then boot your Novena from that MicroSD card.

To build the image yourself, take the standard Novena Micro-SD image, enlarge the boot partition, run makeinstall.sh on a Novena system, and then copy the files that are generated in boot/ to the boot partition.

The installer will automatically rename the uInitrd to uInitrd-install at the end of the installation, to make sure that the system boots after the installation instead of looping in the installer.
If you want to run the installer again after an installation is completed, just rename uInitrd-install back to uInitrd on the MicroSD card, and the installer will run again on the next boot.
