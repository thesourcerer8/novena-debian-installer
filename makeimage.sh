echo Fetching base Initial-Ramdisk:
wget http://linux.citylink.co.nz/debian/dists/stable/main/installer-armhf/current/images/netboot/initrd.gz

echo Installing necessay tools:
sudo apt-get install u-boot-tools

echo Unpacking Ramdisk
gunzip <initrd.gz >initrd-unpacked

echo Creating workspace
mkdir cpio
cd cpio

echo Unpacking Ramdisk
cpio -i <../initrd-unpacked

echo Copying missing modules into new ramdisk
cp -r /lib/modules/* lib/modules/

echo Copying preseed
cp ../preseed.cfg preseed.cfg

echo Creating new ramdisk image
find . | cpio -H newc -o >../newinitrd

cd ..

echo Packing ramdisk image
gzip <newinitrd >newinitrd.gz

mkdir boot
mkimage -A arm -T ramdisk -C none -n uInitrd -d ./newinitrd.gz ./boot/uInitrd

cp uEnv.txt boot/uEnv.txt

echo "Now copy boot/uInitrd and boot/uEnv.txt into the boot partition"
