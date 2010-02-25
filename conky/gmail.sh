#!/bin/bash

gmail_login="sloantk" #login do skrzyki
gmail_password="sloan12tk." #hasło do konta

dane="$(wget --secure-protocol=TLSv1 --timeout=3 -t 1 -q -O - \
https://${gmail_login}:${gmail_password}@mail.google.com/mail/feed/atom \
--no-check-certificate | grep 'fullcount' \
| sed -e 's/.*<fullcount>//;s/<\/fullcount>.*//' 2>/dev/null)"

if [ -z "$dane" ]; then
echo "Connection Error !"
else
echo "$dane list(ów)"
fi

