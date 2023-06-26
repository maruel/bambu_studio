#!/bin/bash
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

set -eu

cd "$(dirname $0)"

# Always recreate the app just in case.
# It refers to "Bambu_Studio.AppImage" instead of the real file name. This is
# because the desktop file is cached and not refreshed when updated. This makes
# it so upgrading doesn't require to restart the user session.
LINK="$HOME/.local/share/applications/Bambu_Studio.desktop"
if [ ! -f "$LINK" ]; then
  sed -e "s#PATH#$PWD#g" Bambu_Studio.desktop > "$LINK"
fi

# TODO: Should use jq or python. This is not safe.
URL="$(curl -s https://api.github.com/repos/bambulab/BambuStudio/releases/latest \
  | grep '"browser_download_url"' \
  | grep ubuntu \
  | grep -oh 'https.*AppImage')"
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
