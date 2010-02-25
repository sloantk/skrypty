#!/bin/bash

zenity --question --no-wrap --text "Na pewno uruchomić ponownie komputer" --ok-label=Uruchom ponownie
if [ $? = 0 ]; then
	sudo reboot
fi
