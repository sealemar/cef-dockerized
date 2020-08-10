#!/bin/bash

if [ ${arch} = "arm64" ] ; then
    /app/chromium_git/chromium/src/build/linux/sysroot_scripts/install-sysroot.py --arch=arm64
fi
