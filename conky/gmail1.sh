    #!/bin/bash

    gmail_login="sloantk"
    gmail_password="sloan12tk."

    dane="$(wget --secure-protocol=TLSv1 --timeout=3 -t 1 -q -O - \
https://${gmail_login}:${gmail_password}@mail.google.com/mail/feed/atom \
--no-check-certificate | grep 'fullcount' \
| sed -e 's/.*<fullcount>//;s/<\/fullcount>.*//' 2>/dev/null)"

    #if [ -z "$dane" ]; then
    #echo "Connection Error !"
    #else
    #echo "GMail: $dane msg(s)"
    #fi

    if [ -z "$dane" ]; then
    echo "Błąd połączenia"
    else
    let wynik=$dane;
    if [ $wynik = 0 ]; then
    echo "Nie masz nowych wiadomości."
    elif [ $wynik = 1 ]; then
    echo "Masz 1 nową wiadomość."
    else
    if [ $wynik -lt 5 ]; then
    echo "Masz $wynik nowe wiadomości."
    else
    echo "Masz $wynik nowych wiadomości."
    fi
    fi
    fi  
