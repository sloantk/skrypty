#!/bin/bash

files=(`zenity --file-selection --title "Wybierz pliki do zmniejszenia" --multiple --separator " "`)

if [ $files == "" ]
then
        exit
fi

fnum=${#files[@]}
percent=$[100/$fnum]
current=$percent

scale=(`zenity --scale --title "Rozmiar miniatury" --text "Wybierz maksymalny rozmiar wysokości lub szerokości - obraz będzie zmniejszony proporcjonalnie" --max-value 1024`)

if [ $scale == 0 ]
then
        exit
fi

(for file in ${files[*]};
do
        type=`file -b -i $file`
        if [ ${type:0:5} == 'image' ]
        then            
                convert $file -resize "$scale"x"$scale" $file
        fi
        
        current=$[$current+$percent]
        echo $current
        
done) | zenity --progress --title "Zmniejszanie obrazków" --text "Postęp" --au
