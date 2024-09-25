# Bambu Studio setup script

Quickly setup Bambu Studio as a proper application in Ubuntu, with a one liner
to upgrade to the latest version from
https://github.com/bambulab/BambuStudio/releases.

Run:

```
./upgrade_bambu.sh
./upgrade_orca.sh
```

Then press the WinKey, type Bambu, right click and "Add to Favorites"

May have to accept the ssl certificate, and install en_GB.UTF-8 locale.


## ChromeOS

Linux on ChromeOS doesn't support fuse. To run without fuse, do:

```
sudo apt install libwebkit2gtk-4.0-dev
./Bambu_Studio.AppImage --appimage-extract
./squashfs-root/AppRun
```

## License

`BambuStudio_128px.png` source:
https://github.com/bambulab/BambuStudio/blob/master/resources/images/BambuStudio_128px.png

`OrcaSlicer_128px.png` source:
https://github.com/SoftFever/OrcaSlicer/blob/main/resources/images/OrcaSlicer_128px.png
