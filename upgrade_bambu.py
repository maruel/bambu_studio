#!/usr/bin/env python3
# Copyright 2023 Marc-Antoine Ruel. All rights reserved.
# Use of this source code is governed under the Apache License, Version 2.0
# that can be found in the LICENSE file.

import json
import os
import sys
import urllib.request

THIS_DIR = os.path.dirname(os.path.abspath(__file__))

def main():
    os.chdir(THIS_DIR)
    if not os.path.isfile("/lib/x86_64-linux-gnu/libfuse.so.2"):
        print("sudo apt install libfuse2", file=sys.stderr)
        return 1
    # It refers to "Bambu_Studio.AppImage" instead of the real file name. This is
    # because the desktop file is cached and not refreshed when updated. This makes
    # it so upgrading doesn't require to restart the user session.
    link = os.path.expanduser("~/.local/share/applications/Bambu_Studio.desktop")
    if not os.path.isfile(link):
        os.makedirs(os.path.expanduser("~/.local/share/applications"))
        with open("bambu_Studio.desktop") as f:
            data = f.read()
        data = data.replace("PATH", THIS_DIR)
        with open(link, "w") as f:
            f.write(data)
    # Take the latest version. It happened in the past that they forgot to provide
    # the Ubuntu build for a version, it seems to be 100% manual. In this case, use
    # a specific older version.
    url = None
    with urllib.request.urlopen("https://api.github.com/repos/bambulab/BambuStudio/releases/latest") as data:
        for i in json.load(data)['assets']:
            # print(i['browser_download_url'])
            if 'ubuntu-20' in i['browser_download_url']:
                url = i['browser_download_url']
                break
    if not url:
        print("No Ubuntu build found", file=sys.stderr)
        return 1
    filename = os.path.basename(url)
    if os.path.isfile(filename):
        print(f"{filename} is already latest")
        return 0
    print(f"Downloading {url}")
    urllib.request.urlretrieve(url, filename)
    os.chmod(filename, 0o755)
    if os.path.isfile("Bambu_Studio.AppImage"):
        os.remove("Bambu_Studio.AppImage")
    os.symlink(filename, "Bambu_Studio.AppImage")
    return 0


if __name__ == "__main__":
    sys.exit(main())
