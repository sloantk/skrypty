#!/bin/bash

apt-get update 2> /tmp/keymissing; for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); do echo -e "\nProcessing key: $key"; sudo gpg --keyserver subkeys.pgp.net --recv $key && sudo gpg --export --armor $key | sudo apt-key add -; done
