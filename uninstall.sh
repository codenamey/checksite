#!/bin/bash

# Määritellään tarvittavat polut
CHECKSITE_SCRIPT="/usr/local/bin/checksite.sh"
CHECKSITE_GO="/usr/local/bin/checksite.go"  
INITD_SCRIPT="/etc/init.d/checksite"

if [ -f "$INITD_SCRIPT" ]; then
    echo "Pysäytetään checksite-palvelu..."
    sudo service checksite stop
    sudo update-rc.d -f checksite remove  
fi

if [ -f "$INITD_SCRIPT" ]; then
    echo "Poistetaan init.d-skripti..."
    sudo rm $INITD_SCRIPT
fi

if [ -f "$CHECKSITE_SCRIPT" ]; then
    echo "Poistetaan checksite.sh..."
    sudo rm $CHECKSITE_SCRIPT
fi

if [ -f "$CHECKSITE_GO" ]; then
    echo "Poistetaan checksite.go..."
    sudo rm $CHECKSITE_GO
fi

echo "Uninstall valmis."
