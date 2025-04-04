#!/bin/bash
# Copyright 2024 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd "$(dirname $0)"

# Always recreate the app just in case.
# It refers to "OrcaSlicer.AppImage" instead of the real file name. This is
# because the desktop file is cached and not refreshed when updated. This makes
# it so upgrading doesn't require to restart the user session.
LINK="$HOME/.local/share/applications/OrcaSlicer.desktop"
if [ ! -f "$LINK" ]; then
  sed -e "s#PATH#$PWD#g" OrcaSlicer.desktop > "$LINK"
fi

# Take the latest version.
DATA="$(curl -s https://api.github.com/repos/SoftFever/OrcaSlicer/releases/latest)"
#DATA="$(curl -s https://api.github.com/repos/SoftFever/OrcaSlicer/releases)"
# v01.07.01.62
#DATA="$(curl -s https://api.github.com/repos/SoftFever/OrcaSlicer/releases/114743228)"
#echo "$DATA"
SCRIPT="import json,sys;
e = [i['browser_download_url'] for i in json.load(sys.stdin)['assets']];
print([i for i in e if i.endswith('.AppImage')][0]);"
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
if [ -f OrcaSlicer.AppImage ]; then
  rm OrcaSlicer.AppImage
fi
ln -s "$FILE" OrcaSlicer.AppImage
