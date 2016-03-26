#!/bin/sh
PREREQ=""
prereqs()
{
   echo "$PREREQ"
}

case $1 in
	prereqs)
		prereqs
		exit 0
	;;
esac

. /usr/share/initramfs-tools/hook-functions
# Begin real processing below this line


#echo "Calling hook once " >>/tmp/hook.txt
#date >>/tmp/hook.txt
#pwd >>/tmp/hook.txt
#set >>/tmp/hook.txt

#mkdir $DESTDIR/lib/firmware
cp -r /lib/firmware $DESTDIR/lib/
cp -r /lib/modules/$1 $DESTDIR/lib/modules/
rm -rf $DESTDIR/lib/modules/$1/build/

#/bin/bash
