#!/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd "$(dirname $0)"

if [ ! -f /lib/x86_64-linux-gnu/libfuse.so.2 ]; then
  echo "sudo apt install libfuse2"
  exit 1
fi

# Always recreate the app just in case.
# It refers to "Bambu_Studio.AppImage" instead of the real file name. This is
# because the desktop file is cached and not refreshed when updated. This makes
# it so upgrading doesn't require to restart the user session.
LINK="$HOME/.local/share/applications/Bambu_Studio.desktop"
if [ ! -f "$LINK" ]; then
  mkdir -p "$HOME/.local/share/applications"
  sed -e "s#PATH#$PWD#g" Bambu_Studio.desktop > "$LINK"
fi

# Take the latest version. It happened in the past that they forgot to provide
# the Ubuntu build for a version, it seems to be 100% manual. In this case, use
# a specific older version.
DATA="$(curl -s https://api.github.com/repos/bambulab/BambuStudio/releases/latest)"
#DATA="$(curl -s https://api.github.com/repos/bambulab/BambuStudio/releases)"
# v01.07.01.62
#DATA="$(curl -s https://api.github.com/repos/bambulab/BambuStudio/releases/114743228)"
#echo "$DATA"
SCRIPT="import json,sys;
e = [i['browser_download_url'] for i in json.load(sys.stdin)['assets']];
print([i for i in e if 'ubuntu' in i][0]);"
URL="$(echo "$DATA" | python3 -c "$SCRIPT")"
FILE="$(basename $URL)"

if [ -f "$FILE" ]; then
  echo "$FILE is already latest"
else
  echo "Downloading $URL"
  curl -sSL "$URL" -o "$FILE"
fi

# Always +x the file just in case.
chmod +x "$FILE"

# Always recreate the symlink just in case.
if [ -f Bambu_Studio.AppImage ]; then
  rm Bambu_Studio.AppImage
fi
ln -s "$FILE" Bambu_Studio.AppImage
