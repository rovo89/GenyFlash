# GenyFlash

## Introduction
Genymotion is a great and fast Android emulator.

Unfortunately, its support for flashing ZIP archives is pretty limited.
You can drag'n'drop files onto the emulator window, but that just copies the
files contained in the `system` sub-folder of the archive to the `/system`
partition. This result in wrong permissions (e.g. for executables) and other
inconsistencies. In many cases, flashable archives contain more logic in their
`update-binary` or `updater-script`, which is ignored by Genymotion.

This repository contains improved scripts that try to simulate custom recoveries
better than that. After installing them, prepared archives should be installed
properly when you drop them on emulator window.

## How it works
Genymotion contains two scripts in `/system/bin` that are called on drag'n'drop:
- `check-archive.sh` checks whether the dropped file is a flashable archive.
- `flash-archive.sh` extracts the file and copies the files to the appropriate place.

The improved scripts check for `META-INF/com/google/android/update-binary` in the
archive, which is executed by custom recoveries. If found, this file is executed
in recovery mode. Any output is redirected to `logcat` (as it doesn't seem to be
possible to send it back to the UI). This binary has to take care of all required
steps, i.e. the default copying of `/system` files isn't done.

> **NOTE**: Due to some traps described below, this logic is currently
applied only to archives that contain a file called
`META-INF/com/google/android/genymotion-ready`.
> You can use a [template](template/genymotion-ready) for this.

## Installation
Simply start the virtual device and execute [install.bat](install.bat).
If you want to return to the old behavior, you can execute [uninstall.bat](uninstall.bat).

## Traps
The file `update-binary` can be any executable file. Most Android devices are running
with an ARM processor, but Genymotion runs on x86. So there's a good chance that the
binary isn't executable on Genymotion. The script will fail in this case.

Many archives contain a standard `update-binary` that interprets and executes another
file called `updater-script` in Edify format. These scripts might contain commands
that don't execute well on a running system (e.g. unmounting the system or data
partition) or don't consider other special circumstances that might occur in the
emulator.

It's also possible to use an ordinary shell script as `updater-binary`. That's a way
to build archives that are flashable on different platforms. However, these scripts
often refer to `/sbin/sh`, which is usually available in custom recoveries but not
on Genymotion. The same might apply to `/tmp` and other files/directories.

Ideas to handle these traps can be found on https://github.com/rovo89/GenyFlash/issues.

## License
The changes to the Genymotion scripts are released under the
[MIT license](https://tldrlegal.com/license/mit-license).

Additionally, I explicitly grant Genymobile (the company behind Genymotion) the
permission to include these changes partly or completely in their VM images.
I believe it would be a nice improvement if such support was available out-of-the-box.
