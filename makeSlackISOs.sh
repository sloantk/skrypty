#!/bin/bash
#
# Shell script to build (unofficial) Slackware-current ISOs
# 
# Lars Strand - larstra (at) ifi uio no
#
# Last update: Wed May 20 15:54:58 CEST 2009
#

DATE=`date +"%d_%b_%Y"`
MD5SUM="/usr/bin/md5sum"
VERSION="12.2"

CURRENT="slackware-current-$DATE-DVD.iso"
STABLE="slackware-$VERSION-DVD.iso"
CURRENT64="slackware64-current-$DATE-DVD.iso"
STABLE64="slackware64-$VERSION-DVD.iso"

LOC_CURRENT="/usit/spheniscus/ftp/linux/slackware/slackware-current"
LOC_STABLE="/usit/spheniscus/ftp/linux/slackware/slackware-$VERSION"
LOC_CURRENT64="/usit/spheniscus/ftp/linux/slackware/slackware64-current"
LOC_STABLE64="/usit/spheniscus/ftp/linux/slackware/slackware64-$VERSION"

DUMP="/usit/spheniscus/ftp/linux/slackware/.current-ISOs"
MKISOFS="/hom/larsks/src/cdrtools-2.01/mkisofs/OBJ/i686-linux-cc/mkisofs"

# remove the old build
rm -rf $DUMP/*

# build DVD CURRENT ISO
cd $LOC_CURRENT/

$MKISOFS -o $DUMP/$CURRENT \
-R -J -V "Slackware-current DVD" \
-x ./source \
-hide-rr-moved \
-v -d -N -no-emul-boot -boot-load-size 4 -boot-info-table \
-sort isolinux/iso.sort \
-b isolinux/isolinux.bin \
-c isolinux/isolinux.boot \
-p "Slackware-current build from slackware.no - NOT OFFICIAL" \
-publisher "Slackware-current build from slackware.no - NOT OFFICIAL" \
-A "Slackware-current DVD - build $DATE" .

# build DVD STABLE ISO
cd $LOC_STABLE/

$MKISOFS -o $DUMP/$STABLE \
-R -J -V "Slackware-$VERSION DVD" \
-x ./source \
-hide-rr-moved \
-v -d -N -no-emul-boot -boot-load-size 4 -boot-info-table \
-sort isolinux/iso.sort \
-b isolinux/isolinux.bin \
-c isolinux/isolinux.boot \
-p "Slackware-$VERSION build from slackware.no - NOT OFFICIAL" \
-publisher "Slackware-$VERSION build from slackware.no - NOT OFFICIAL" \
-A "Slackware-$VERSION DVD - build $DATE" .

# build DVD CURRENT 64 ISO
cd $LOC_CURRENT64/

$MKISOFS -o $DUMP/$CURRENT64 \
-R -J -V "Slackware64-current DVD" \
-x ./source \
-hide-rr-moved \
-v -d -N -no-emul-boot -boot-load-size 4 -boot-info-table \
-sort isolinux/iso.sort \
-b isolinux/isolinux.bin \
-c isolinux/isolinux.boot \
-p "Slackware64-current build from slackware.no - NOT OFFICIAL" \
-publisher "Slackware64-current build from slackware.no - NOT OFFICIAL" \
-A "Slackware64-current DVD - build $DATE" .

### Not yet available
## build DVD STABLE ISO
#cd $LOC_STABLE64/
#
#$MKISOFS -o $DUMP/$STABLE64 \
#-R -J -V "Slackware64-$VERSION DVD" \
#-x ./source \
#-hide-rr-moved \
#-v -d -N -no-emul-boot -boot-load-size 4 -boot-info-table \
#-sort isolinux/iso.sort \
#-b isolinux/isolinux.bin \
#-c isolinux/isolinux.boot \
#-p "Slackware64-$VERSION build from slackware.no - NOT OFFICIAL" \
#-publisher "Slackware64-$VERSION build from slackware.no - NOT OFFICIAL" \
#-A "Slackware64-$VERSION DVD - build $DATE" .


# jump to right build location
cd $DUMP

# copy the Changelog, so folks know what's included
cp -l $LOC_CURRENT/ChangeLog.txt ChangeLog-current.txt
cp -l $LOC_CURRENT64/ChangeLog.txt ChangeLog64-current.txt

# copy the stable Changelog as well
cp -l $LOC_STABLE/ChangeLog.txt ChangeLog-Slackware-$VERSION-DVD.txt
# cp -l $LOC_STABLE64/ChangeLog.txt ChangeLog-Slackware64-$VERSION-DVD.txt

# make MD5 sums of the ISOs
$MD5SUM $CURRENT > CHECKSUMS.md5
$MD5SUM $STABLE >> CHECKSUMS.md5
$MD5SUM $CURRENT64 >> CHECKSUMS.md5
#$MD5SUM $STABLE64 >> CHECKSUMS.md5

# bump warning
echo "** WARNING! **
This is experimental current ISO builds. They are NOT official,
so use at your own risk! 

If you have any comments/suggestions/error-reports regarding these ISOs, 
let me know so I can improve the build-script! You'll find the script
at: http://www.slackware.no/makeSlackISOs.sh

New build every Tuesday at 0500 CEST

Enjoy!

larstra (at) ifi uio no
" > README.TXT

# end
