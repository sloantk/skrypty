#!/bin/sh
mkdir wav
for file in *.mp3 ; do
   lame --decode "$file" "wav/$file.wav"
done
#
cd wav
{
  echo "CD_DA"
  for file in *.wav ; do
    echo "TRACK AUDIO"
    # echo "PREGAP 00:02:00"  # insert a 2-second silent gap before each track
    echo "FILE \"$file\" 0"
  done
} > toc
#
cdrdao read-cddb toc
#cdrdao write --device /dev/sr0 toc
