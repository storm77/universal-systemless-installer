#!/system/bin/sh

IC=/cache/xposed.img
ID=/data/xposed.img
IMGDIR=/xposed
APPDIR=/cache/app

log_xposed() { echo $1;log -p i -t Xposed "$0: $1";}
log_xposed_exit() { echo $1;log -p i -t Xposed "$0: $1";exit 1;}

#disabled
[ -f /data/data/de.robv.android.xposed.installer/conf/disabled ] \
  && log_xposed_exit "xposed disabled by user"

#image in /cache
if [ "$1" == "--cache" ] && [ -f $IC ]; then
 log_xposed "move from /cache to /data"
 mv -f $IC $ID
 if [ -f $APPDIR/*-1 ]; then
  log_xposed "found /cache/app/*-1 , moving to /data/app"
  mv -f $APPDIR/*-1 /data/app
 fi
 reboot
fi

#image not found in /data
[ -f $ID ] \
  || log_xposed_exit "$ID not found, nothing to do"

#bind mounts already executed
[ `getprop xposed.mount` -eq 1 ] \
  && log_xposed_exit "bind mounts already executed"

#start
mountpoint -q $IMGDIR
if [ $? -ne 0 ]; then
 log_xposed "init image mount failed, starting manual mount"
 e2fsck -p $ID
 chcon u:object_r:system_data_file:s0 $ID
 chmod 0600 $ID
 mount -o ro,noatime $ID $IMGDIR && log_xposed "manual loop mount success"
else
 log_xposed "init image mount success, starting bind mount:"
 find $IMGDIR -type f|while read file;do
  mount -o bind $file /system/${file#$IMGDIR/}
 done
 setprop xposed.mount 1
fi

