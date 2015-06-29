#!/bin/bash

echo Installing improved scripts...
adb -e remount
adb -e wait-for-device
adb -e push improved/system/bin/check-archive.sh /system/bin
adb -e shell chmod 755 /system/bin/check-archive.sh
adb -e push improved/system/bin/flash-archive.sh /system/bin
adb -e shell chmod 755 /system/bin/flash-archive.sh

echo Done!
