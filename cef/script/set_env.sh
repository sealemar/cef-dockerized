#!/bin/bash

export PATH=/app/depot_tools:$PATH

if [ "${arch}" = "arm64" ] ; then
    export GYP_DEFINES="target_arch=arm64"
    export GN_DEFINES="is_official_build=true use_sysroot=true use_allocator=none symbol_level=1 enable_nacl=false use_cups=false"
    export CEF_INSTALL_SYSROOT="arm64"
    export install_build_deps_sh_arch="--arm"
    export no_nacl=""
    export extra_automate_args="--arm64-build"
    export ninja_debug_args="-C out/Debug_GN_arm64"
    export ninja_release_args="-C out/Release_GN_arm64"
else
    export CEF_USE_GN=1
    export GYP_DEFINES="disable_nacl=1 use_sysroot=1 buildtype=Official use_allocator=none"
    export GN_DEFINES="is_official_build=true use_sysroot=true use_allocator=none symbol_level=1 enable_nacl=false use_cups=false"

    export install_build_deps_sh_arch="--no-arm"
    export no_nacl="--no-nacl"
    export ninja_debug_args="-C out/Debug_GN_x64"
    export ninja_release_args="-C out/Release_GN_x64"
    export extra_automate_args="--x64-build"

    export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
fi
