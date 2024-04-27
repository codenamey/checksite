#!/bin/bash

GOCACHE_PATH="/tmp/cache"
CHECKSITE_SCRIPT="/usr/local/bin/checksite.sh"
INITD_SCRIPT="/etc/init.d/checksite"

if ! command -v go &> /dev/null
then
    echo "Go ei ole asennettu. Asennetaan Go..."
    # Tässä käytetään Debian/Ubuntu asennuskomentoa esimerkkinä
    sudo apt update && sudo apt install -y golang
    if [ $? -ne 0 ]; then
        echo "Go:n asennus epäonnistui."
        exit 1
    fi
else
    echo "Go on jo asennettu. (Versio: $(go version))"
fi

if [ ! -d "$GOCACHE_PATH" ]; then
    echo "Luodaan GOCACHE-hakemisto: $GOCACHE_PATH"
    mkdir -p "$GOCACHE_PATH"
fi

echo "Asetetaan oikeudet hakemistoon $GOCACHE_PATH"
chmod 755 "$GOCACHE_PATH"

export GOCACHE="$GOCACHE_PATH"
echo "GOCACHE asetettu: $GOCACHE"

if ! grep -q "export GOCACHE=$GOCACHE_PATH" ~/.bashrc; then
    echo "export GOCACHE=$GOCACHE_PATH" >> ~/.bashrc
    echo "GOCACHE-ympäristömuuttuja lisätty ~/.bashrc-tiedostoon."
fi

if [ ! -f "$CHECKSITE_SCRIPT" ]; then
    echo "Kopioidaan checksite.sh skripti /usr/local/bin/ hakemistoon..."
    cp checksite.sh $CHECKSITE_SCRIPT
    chmod +x $CHECKSITE_SCRIPT
fi

if [ ! -f "$INITD_SCRIPT" ]; then
    echo "Kopioidaan checksite init.d-skripti /etc/init.d/ hakemistoon..."
    cp checksite_init_script $INITD_SCRIPT
    chmod +x $INITD_SCRIPT
    sudo update-rc.d checksite defaults  
fi

sudo service checksite start

echo "Asennus on valmis. Muutokset tulevat voimaan, kun käynnistät seuraavan kerran komentotulkin uudelleen tai lataat .bashrc:n uudelleen."
