#!/bin/sh

if
  #Sprawdzamy czy istnieje plik, którego nazwa jest pierwszym argumentem wywołania
  [ -e zenity ]
then
  #Jeśli nie istnieje, to kończymy wyświetlając odpowiedni komunikat i przekazując do systemu informację
  #o błędnym zakończeniu: exit 1
  echo "Zainstaluj program "zenity""
  exit 1
fi

zenity --info --text="Skrypt służy do masowego nadawania (zmiany) uprawnień katalogom (755) i plikom (644) w tych katalogach."
#
katalog=`zenity --file-selection --directory`

find $katalog -type d -print0 | xargs -0 chmod 755 && find $katalog -type f -print0 | xargs -0 chmod 644 && zenity --info --text=Zrobione
