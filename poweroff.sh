#!/bin/bash

zenity --question --no-wrap --text "Na pewno wyłączyć komputer" --ok-label=Wyłącz
if [ $? = 0 ]; then
	sudo poweroff
fi
