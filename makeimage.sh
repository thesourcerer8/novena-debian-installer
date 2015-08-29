echo Fetching base Initial-Ramdisk:
wget -O initrd.gz http://linux.citylink.co.nz/debian/dists/stable/main/installer-armhf/current/images/netboot/initrd.gz

echo Fetching Novena Update Hooks:
wget -O hooks.tgz http://www2.futureware.at/novena/hooks.tgz

echo Fetching Kosagi Key: 
wget -O kosagi.gpg.key http://bunniefoo.com/kosagi-deb/kosagi.gpg.key
gpg  --recv-key 602d46ae38d68b72 ; gpg --export -a >repo.gpg.key
wget -O newkey.gpg.key https://github.com/xobs/kosagi-repo/raw/master/etc/apt/trusted.gpg.d/kosagi.gpg

echo Installing necessay tools:
sudo apt-get install u-boot-tools

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
cp /lib/firmware/ar3k/AthrBT_0x11020000.dfu lib/firmware/

echo Copying preseed
cp ../preseed.cfg preseed.cfg

echo Copying Kosagi repo key
cp ../kosagi.gpg.key kosagi.gpg.key
cp ../repo.gpg.key repo.gpg.key
cp ../newkey.gpg.key newkey.gpg.key

echo Copying fdisk for partitioning
cp /sbin/fdisk sbin/fdisk

echo Copying mkimage
cp /usr/bin/mkimage bin/mkimage

cp /lib/arm-linux-gnueabihf/libblkid.so.1 /lib/arm-linux-gnueabihf/libuuid.so.1 /lib/arm-linux-gnueabihf/libsmartcols.so.1 /lib/arm-linux-gnueabihf/libc.so.6 lib/arm-linux-gnueabihf/

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
