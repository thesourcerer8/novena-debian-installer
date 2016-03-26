echo Fetching base Initial-Ramdisk:
wget -O initrd.gz http://ftp.us.debian.org/debian/dists/stable/main/installer-armhf/current/images/netboot/initrd.gz

echo making tgz file
tar -zcvf hooks.tgz etc

echo Fetching Kosagi Key: 
echo 4C0E70D9 is the new key
wget -O kosagi.gpg https://github.com/xobs/kosagi-repo/raw/master/etc/apt/trusted.gpg.d/kosagi.gpg

echo Installing necessary tools:
sudo apt-get install u-boot-tools lvm2 cryptsetup
sudo apt-get --reinstall install linux-image-novena
echo Please ensure that u-boot-tools, lvm2, and cryptsetup installed

echo Unpacking Ramdisk
gunzip <initrd.gz >initrd-unpacked

echo Creating workspace
rm -rf ./cpio/
mkdir cpio
cd cpio

echo Unpacking Ramdisk
cpio -i <../initrd-unpacked

echo Copying missing modules into new ramdisk
cp -r /lib/modules/* lib/modules/

echo Copying Bluetooth firmware
mkdir lib/firmware
mkdir lib/firmware/ar3k
cp /lib/firmware/ar3k/AthrBT_0x11020000.dfu lib/firmware/ar3k/
cp /lib/firmware/ar3k/ramps_0x11020000_40.dfu lib/firmware/ar3k/

echo Copying preseed
cp ../preseed.cfg preseed.cfg

echo Copying Kosagi repo key
cp ../kosagi.gpg kosagi.gpg

cp ../hooks.tgz hooks.tgz

echo Creating new ramdisk image
find . | cpio -H newc -o >../newinitrd 

cd ..

echo Packing ramdisk image
gzip <newinitrd >newinitrd.gz

rm -- ./boot/*
mkdir boot
mkimage -A arm -T ramdisk -C none -n uInitrd -d ./newinitrd.gz ./boot/uInitrd

cp uEnv.txt boot/uEnv.txt

echo "Now copy boot/uInitrd and boot/uEnv.txt into the /boot partition"
echo "If you want to rerun the installer later on, just rename uInitrd-install to uInitrd again"
