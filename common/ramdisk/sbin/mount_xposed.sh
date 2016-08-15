#!/system/bin/sh
[ "$1" == "--regular" ] && rm -f /data/xposed.log
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>/data/xposed.log 2>&1
log_xposed() { log -p i -t Xposed "$0: $*";}
log_xposed_exit() { log_xposed $*;exit 1;}

log_xposed "running script: $0: $*";set -x
[ "`getprop xposed.mount`" -eq "1" ] \
 && log_xposed_exit "script already executed"

IC=/cache/xposed.img
ID=/data/xposed.img
IMGDIR=/xposed
APPDIR=/cache/app

try_mount(){
 for n in 0 1 2 3 4 5 6 7;do
  LD=/dev/block/loop$n
  [ -b $LD ] \
   || mknod -m600 $LD b 7 $n \
   || log_xposed_exit "unable to create loop device"
  losetup -s $LD \
   && continue
  losetup $LD $ID \
   || continue
  mount -t ext4 -o ro,noatime $LD $IMGDIR \
   && break
 done
}

#data not mounted
mountpoint -q /data \
 || log_xposed_exit "data not mounted, nothing to do"

#data in /cache
if [ -f $IC ]; then
 log_xposed "found $IC, moving to /data"
 mv -f $IC $ID
 if [ -f $APPDIR/*-1 ]; then
  log_xposed "found /cache/app/*-1 , moving to /data/app"
  mv -f $APPDIR/*-1 /data/app
 fi
 if [ -f /cache/boot*.img ]; then
  log_xposed "found boot image backup in /cache, moving to /data"
  cp -f  /cache/boot*.img /data
 fi
 reboot
fi

#disabled
[ -f /data/data/de.robv.android.xposed.installer/conf/disabled ] \
 && log_xposed_exit "xposed disabled by user"

#image not found in /data
[ -f $ID ] \
 || log_xposed_exit "$ID not found, nothing to do"

#start
if ! mountpoint -q $IMGDIR; then
 log_xposed "start mounting process..."
 e2fsck -p $ID
 chcon u:object_r:system_data_file:s0 $ID
 chmod 0600 $ID
 try_mount \
  && log_xposed "success" \
  || log_xposed_exit "unable to mount xposed.img"
fi

#bindmount
if [ "`getprop xposed.mount`" -ne "1" ]; then
 log_xposed "starting bind mount:"
 find $IMGDIR -type f|while read file;do
  [ -f /system/${file#$IMGDIR/} ] \
   && mount -o bind $file /system/${file#$IMGDIR/}
 done
 setprop xposed.mount 1
fi

exit 0

