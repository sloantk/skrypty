#!/bin/bash
# Date : (2009-06-04 17-00)
# Last revision : (2009-09-11 14-00)
# Wine version used : 1.1.23
# Distribution used to test : Fedora 11
# Author : NSLW
# Licence : Retail
 
[ "$PLAYONLINUX" = "/usr/share/playonlinux" ] && exit 0
source "$PLAYONLINUX/lib/sources"
 
TYTUL="DirectX End-User Runtimes"
LNG_DIRECTX="This wizard will help you to install DirectX 9.0c for one of PlayOnLinux application"
LNG_CHOOSEPREFIX="Choose a prefix for DirectX 9.0c"
LNG_DOWNLOADINGDX="Downloading DirectX 9.0c"
LNG_INSTALLINGDX="Installing DirectX 9.0c..."
LNG_SUCCESDX="$TYTUL has been installed successfully"
LNG_FAILUREDX="There is no such prefix"
LNG_VERQUESTION="Which DirectX version would you like to install?"
 
cd "$REPERTOIRE/ressources"
if [ "`sha1sum < winetricks | sed 's/ .*//'`" != "37b5aaeeeec6ecae56ca9bfeb7911ac9c909b6d3" ]; then
wget http://winezeug.googlecode.com/svn/trunk/winetricks --output-document=winetricks
fi
 
WINETRICKSDXSUM=`cat winetricks | grep \/directx | cut -d'_' -f3 | cut -d' ' -f2`
WINETRICKSDX=`cat winetricks | grep \/directx | cut -d'_' -f2`
WINETRICKSDXLINK=`cat winetricks | grep \/directx | cut -d'/' -f5,6,7,8`
 
DX9AUG2009="aug2009"
DX9AUG2009F="August 2009"
DX9AUG2009LINK="B/7/9/B79FC9D7-47B8-48B7-A75E-101DEBEB5AB4"
DX9AUG2009SUM="563b96a3d78d6038d10428f23954f083320b4019"
 
DX9MAR2009="mar2009"
DX9MAR2009F="March 2009"
DX9MAR2009LINK="3/C/4/3C46A69A-CB0F-4CCA-B1E8-248D43270D5F"
DX9MAR2009SUM="29957ee0d29b95019b082a47da5eab52f50cde0d"
 
DX9NOV2008="nov2008"
DX9NOV2008F="November 2008"
DX9NOV2008LINK="0/d/3/0d307649-9967-49fa-ab27-61f11024e97f"
DX9NOV2008SUM="0cbe95cacd413208a9f38e31b602015408025019"
 
DX9JUN2008="jun2008"
DX9JUN2008F="June 2008"
DX9JUN2008LINK="c/1/f/c1fb09b0-8a8b-45ba-8bb0-64f60bd23175"
DX9JUN2008SUM="9f6efe6f4a40ea3e1615cc70edad72aff95c737d"
 
DX9AUG2008="aug2008"
DX9AUG2008F="August 2008"
DX9AUG2008LINK="5/c/8/5c8b7216-bbc2-4215-8aa5-9dfef9cdb3df"
DX9AUG2008SUM="44b175ad7e2a2614aa91bfb816eab0279bcac61e"
 
DX9MAR2008="mar2008"
DX9MAR2008F="March 2008"
DX9MAR2008LINK="6/4/c/64c3d3d6-c5da-47eb-9db4-86e45b9f579e"
DX9MAR2008SUM="21aa91ca8e0cbb5fbb986f47a1ccdad5d2984cae"
 
DX9NOV2007="nov2007"
DX9NOV2007F="November 2007"
DX9NOV2007LINK="c/6/a/c6af7ea3-f85c-4fef-a475-5810f82def1f"
DX9NOV2007SUM="d20da499190adef74c4d7dee1ff3ad4f36fcaac1"
 
DX9AUG2007="aug2007"
DX9AUG2007F="August 2007"
DX9AUG2007LINK="7/c/6/7c657ecc-f1d3-4cf2-8ff3-de9100d98a5d"
DX9AUG2007SUM="fa25bd79d25243e2007ca565cc746b29df0a9c46"
 
DX9JUN2007="jun2007"
DX9JUN2007F="June 2007"
DX9JUN2007LINK="5/5/e/55ec0e96-a046-42c6-b6c8-2cd5742a073a"
DX9JUN2007SUM="c4e77e4eda09394044d27a1324fc928bd63f8bd3"
 
DX9APR2007="apr2007"
DX9APR2007F="April 2007"
DX9APR2007LINK="2/9/8/298c04e4-9b99-4b16-8a69-5ab32330a5c7"
DX9APR2007SUM="94f0721be2b3b0867aad78294a63bc37cbdb427c"
 
DX9FEB2007="feb2007"
DX9FEB2007F="February 2007"
DX9FEB2007LINK="4/2/2/42219f33-9597-4ae0-a7a1-cccabc893ca2"
DX9FEB2007SUM="bb962f833e1f3f54e13fb9ae0440900aafc27769"
 
DX9DEC2006="dec2006"
DX9DEC2006F="December 2006"
DX9DEC2006LINK="8/c/9/8c968ecc-8402-49f3-aacb-dc4c5d230a9a"
DX9DEC2006SUM="9143e8a08ba454ac2c35d179f8f180db271af0dd"
 
DX9DEC2006="dec2006"
DX9DEC2006F="December 2006"
DX9DEC2006LINK="8/c/9/8c968ecc-8402-49f3-aacb-dc4c5d230a9a"
DX9DEC2006SUM="9143e8a08ba454ac2c35d179f8f180db271af0dd"
 
DX9OCT2006="oct2006"
DX9OCT2006F="October 2006"
DX9OCT2006LINK="d/4/6/d46cc24d-33df-4727-aa89-9512513c67d3"
DX9OCT2006SUM="be873a14d21bd503ff02620d55ed0bd933a9acea"
 
DX9AUG2006="aug2006"
DX9AUG2006F="August 2006"
DX9AUG2006LINK="2/1/e/21e186a5-30b8-4cc0-888a-db4abb111405"
DX9AUG2006SUM="c188db2de1a5c0d86666cfbb59a3fef089d1a429"
 
DX9JUN2006="jun2006"
DX9JUN2006F="June 2006"
DX9JUN2006LINK="a/9/d/a9d1c07d-541c-4b69-b136-f2a0d35e6fd6"
DX9JUN2006SUM="3963ace6fa4566dbcec72e879c8887c491ee2f2e"
 
DX9APR2006="apr2006"
DX9APR2006F="April 2006"
DX9APR2006LINK="3/9/7/3972f80c-5711-4e14-9483-959d48a2d03b"
DX9APR2006SUM="56be9e3425bf9ddbe45b7ecb84826a7b3ccc9c7e"
 
DX9FEB2006="feb2006"
DX9FEB2006F="February 2006"
DX9FEB2006LINK="2/4/3/243865fc-c896-497e-9a66-bcc3f596741e"
DX9FEB2006SUM="94f0721be2b3b0867aad78294a63bc37cbdb427c"
 
DX9DEC2005="dec2006"
DX9DEC2005F="December 2005"
DX9DEC2005LINK="1/1/d/11d253f5-be20-41eb-8985-29a44c601264"
DX9DEC2005SUM="97c50fd55dc5b6d60bbf984d7e127aebe6c4cb35"
 
POL_SetupWindow_Init
POL_SetupWindow_free_presentation "$TYTUL" "$LNG_DIRECTX"
POL_SetupWindow_games "$LNG_CHOOSEPREFIX" "$TYTUL"
PREFIX=$(detect_wineprefix "$APP_ANSWER")
 
#checking if there is such prefix
if [ -e "$PREFIX" ]; then
select_prefix "$PREFIX"
else
POL_SetupWindow_message "$LNG_FAILUREDX" "$TYTUL"
POL_SetupWindow_Close
exit
fi
 
	cd "$REPERTOIRE/ressources/"
	#determining which Version is the latest
	wget http://mulx.playonlinux.com/wine/linux-i386/LIST --output-document=LIST
	cat LIST | sed -e 's/\.//g' | cut -d';' -f2 | sort -n | tail -n1 >& LatestVersion.txt
 
	x=`cat LatestVersion.txt | cut -c1-1`
	y=`cat LatestVersion.txt | cut -c2-2`
	z=`cat LatestVersion.txt | cut -c3-4`
 
	LATESTVERSION=$x.$y.$z
	POL_SetupWindow_install_wine "$LATESTVERSION"
	Use_WineVersion "$LATESTVERSION"
 
POL_SetupWindow_menu "$LNG_VERQUESTION" "DirectX" "$DX9AUG2009F~$DX9MAR2009F~$DX9NOV2008F~$DX9JUN2008F~$DX9AUG2008F~$DX9MAR2008F~$DX9NOV2007F~$DX9AUG2007F~$DX9JUN2007F~$DX9APR2007F~$DX9FEB2007F~$DX9DEC2006F~$DX9OCT2006F~$DX9AUG2006F~$DX9JUN2006F~$DX9APR2006F~$DX9FEB2006F~$DX9DEC2005F" "~"
if [ "$APP_ANSWER" == "$DX9FEB2006F" ]; then
DXVER=$DX9FEB2006
DXLINK=$DX9FEB2006LINK
DXSUM=$DX9FEB2006SUM
elif [ "$APP_ANSWER" == "$DX9DEC2006F" ]
then
DXVER=$DX9DEC2006
DXLINK=$DX9DEC2006LINK
DXSUM=$DX9DEC2006SUM
elif [ "$APP_ANSWER" == "$DX9FEB2007F" ]
then
DXVER=$DX9FEB2007
DXLINK=$DX9FEB2007LINK
DXSUM=$DX9FEB2007SUM
elif [ "$APP_ANSWER" == "$DX9APR2007F" ]
then
DXVER=$DX9APR2007
DXLINK=$DX9APR2007LINK
DXSUM=$DX9APR2007SUM
elif [ "$APP_ANSWER" == "$DX9AUG2007F" ]
then
DXVER=$DX9AUG2007
DXLINK=$DX9AUG2007LINK
DXSUM=$DX9AUG2007SUM
elif [ "$APP_ANSWER" == "$DX9JUN2007F" ]
then
DXVER=$DX9JUN2007
DXLINK=$DX9JUN2007LINK
DXSUM=$DX9JUN2007SUM
elif [ "$APP_ANSWER" == "$DX9NOV2007F" ]
then
DXVER=$DX9NOV2007
DXLINK=$DX9NOV2007LINK
DXSUM=$DX9NOV2007SUM
elif [ "$APP_ANSWER" == "$DX9MAR2008F" ]
then
DXVER=$DX9MAR2008
DXLINK=$DX9MAR2008LINK
DXSUM=$DX9MAR2008SUM
elif [ "$APP_ANSWER" == "$DX9AUG2008F" ]
then
DXVER=$DX9AUG2008
DXLINK=$DX9AUG2008LINK
DXSUM=$DX9AUG2008SUM
elif [ "$APP_ANSWER" == "$DX9JUN2008F" ]
then
DXVER=$DX9JUN2008
DXLINK=$DX9JUN2008LINK
DXSUM=$DX9JUN2008SUM
elif [ "$APP_ANSWER" == "$DX9NOV2008F" ]
then
DXVER=$DX9NOV2008
DXLINK=$DX9NOV2008LINK
DXSUM=$DX9NOV2008SUM
elif [ "$APP_ANSWER" == "$DX9MAR2009F" ]
then
DXVER=$DX9MAR2009
DXLINK=$DX9MAR2009LINK
DXSUM=$DX9MAR2009SUM
elif [ "$APP_ANSWER" == "$DX9AUG2009F" ]
then
DXVER=$DX9AUG2009
DXLINK=$DX9AUG2009LINK
DXSUM=$DX9AUG2009SUM
fi
 
#downloading DirectX
if [ ! -e "$HOME/.winetrickscache/directx_${DXVER}_redist.exe" ]; then
mkdir "$HOME/.winetrickscache"
cd "$HOME/.winetrickscache"
POL_SetupWindow_download "$LNG_DOWNLOADINGDX" "$TYTUL" "http://download.microsoft.com/download/$DXLINK/directx_${DXVER}_redist.exe"
fi
 
cd "$REPERTOIRE/ressources"
#modyfing winetricks
cd "$WINEPREFIX/drive_c/windows/temp"
cat "$REPERTOIRE/ressources/winetricks" | sed -e "s/$WINETRICKSDX/$DXVER/" | sed -e "s/$WINETRICKSDXSUM/$DXSUM/" | sed -e "s%$WINETRICKSDXLINK%$DXLINK%" > winetricks
 
#installing DirectX
POL_SetupWindow_wait_next_signal "$LNG_INSTALLINGDX" "$TYTUL"
bash winetricks -q directx9
if [ "`echo $?`" == "1" ]; then
POL_SetupWindow_message_image "File corrupted. Please try again" "DirectX corrupted" "/usr/share/playonlinux/themes/tango/warning.png"
rm -fr "$HOME/.winetrickscache/directx_${DXVER}_redist.exe"
POL_SetupWindow_Close
exit
fi
POL_SetupWindow_detect_exit
POL_SetupWindow_reboot
 
POL_SetupWindow_message "$LNG_SUCCESDX" "$TYTUL"
 
POL_SetupWindow_Close
exit
