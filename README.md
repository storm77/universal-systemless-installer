# universal-systemless-installer
Universal Systemless Installer for Xposed Framework

##########################################################################################
              >>> Xposed Universal Systemless Installer v0.1b by st0rm <<<
##########################################################################################

features:
   universal: works on all devices xposed is written for (auto-detect cpu and sdk)
 futureproof: compatible with any future versions of xposed-framework ( v87+ )
trustability: installs and patches the official xposed-framework zipfiles
  compatible: also works with any unofficial release although not tested
      secure: xposed.img is mounted read-only
       small: smallest possible footprint for xposed.img

requirements:
 twrp     (tested with 3.0+)
 supersu  (tested with 2.65+)

##########################################################################################
 Urls/Credits
##########################################################################################
 http://dl-xda.xposed.info/framework 		: rovo89 - xposed framework
 http://download.chainfire.eu/supersu 		: chainfire - systemless idea & tools
 http://topjohnwu.github.io/ 			: topjohnwu - systemless xposed idea
 https://github.com/dvdandroid/XposedInstaller : dvdandroid - xposed-installer

##########################################################################################
FAQ

why did you write it?
 i thought i could do a better job, you decide

is it safe?
 its the first release and beta, make no assumptions, backup your device

howto install ?
 >>> WARNING: it will overwrite /data/xposed.img without prompt! <<<
 1. download the xposed-usi-v*.zip
 2. download the proper xposed-v*-sdk*-*.zip version for your device
    and place it alongside or in a subfolder (auto-detect)
 3. download the XposedInstaller_by_dvdandroid.apk
    and place it alongside or in a subfolder (auto-detect)

 4. install the xposed-usi-v*.zip
 5. reboot

how do i know what version of xposed i need ?
 run the xposed installer by dvdandroid
 or run the xposed-usi-*.zip
 both will show which version you need
##########################################################################################

bugs/problems:
 probably, i only have one device
 (and an old one at that, donate and i will get a new one)
 
donate:
 bitcoin address: 1HPRug5MFDp2eA3rr4kDEhV1gEguinRnpQ
