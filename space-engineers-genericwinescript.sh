#!/bin/bash

SCRIPT_NAME=$(echo \"$0\" | xargs readlink -f)
SCRIPTDIR=$(dirname "$SCRIPT_NAME")

exec 6>display.log
/usr/bin/Xvfb -displayfd 6 &
XVFB_PID=$!
while [[ ! -s display.log ]]; do
  sleep 1
done
read -r DPY_NUM < display.log
rm display.log

wget -N https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks

export WINEPREFIX="$SCRIPTDIR/space-engineers-generic/.wine"
export WINEARCH=win64
export WINEDEBUG=-all
wine winecfg /v win10 > winescript_log.txt 2>&1
./winetricks corefonts >> winescript_log.txt 2>&1
./winetricks sound=disabled >> winescript_log.txt 2>&1
DISPLAY=:$DPY_NUM ./winetricks -q vcrun2019 >> winescript_log.txt 2>&1
DISPLAY=:$DPY_NUM ./winetricks -q --force dotnet48 >> winescript_log.txt 2>&1
rm -rf ~/.cache/winetricks ~/.cache/fontconfig

exec 6>&-
kill $XVFB_PID

exit 0
