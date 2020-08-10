# A Dockerized environment to build Chromium Embedded Framework (CEF)

This is a [docker](https://www.docker.com/) environment to build [CEF (Chromium Embedded Framework)](https://bitbucket.org/chromiumembedded/cef/src). It builds CEF for x64 and for ARM64.


## Pre-requisites

1. [Install Docker](https://docs.docker.com/get-docker/)
2. _(optional)_ [Install docker-compose](https://docs.docker.com/compose/install/)
3. _(optional)_ [Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/)


## Run

To build for ARM64:

```
$ cef_arch=arm64 docker-compose run --rm cef
```

To build for x64:

```
$ cef_arch=x64 docker-compose run --rm cef
```

The environment will:

1. Build CEF artifacts
2. Archive them (with 7z)
    1. The format of a filename of a resulting archive is `cef-chromium_git-{cef_arch}-{date}T{time}.7z`
3. Put them to `./cef/output` on the host OS


## What to expect

1. It takes many hours to build CEF for x64 and even more hours to build for ARM64.
2. It builds Debug and Release artifacts in one pass.


Sizes of resulting images:

```
$ docker images
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
cef                      x64                 c0af0fb651fc        5 hours ago         61.7GB
cef                      arm64               2478382404a1        13 hours ago        65.1GB
```

Sizes of 7z artifacts:

```
$ ls -lh ~/code/cef-dockerized/cef/output/
total 17G
-rw-r--r-- 1 root   root   5.2G Aug  9 09:42 cef-chromium_git-arm64-2020.08.09T16:14:59.7z
-rw-r--r-- 1 root   root   6.2G Aug  9 17:22 cef-chromium_git-x64-2020.08.09T23:57:22.7z
```

Sizes of unzipped artifacts:

```
$ du -ch -d0 ~/tmp/cef-chromium_git-x64-2020.08.09T23\:57\:22/
31G     ~/tmp/cef-chromium_git-x64-2020.08.09T23:57:22/

$ ls -lh ~/tmp/cef-chromium_git-x64-2020.08.09T23:57:22/chromium_git/chromium/src/out/Release_GN_x64/libcef.so
812M Aug  9 16:44 libcef.so

$ ls -lh ~/tmp/cef-chromium_git-x64-2020.08.09T23:57:22/chromium_git/chromium/src/out/Release_GN_x64/cefsimple
2.4M Aug  9 16:44 cefsimple
```

There are also all sorts of static libraries that are generated during a build

```
$ find ~/tmp/cef-chromium_git-x64-2020.08.09T23:57:22/chromium_git/chromium/src/out/Release_GN_x64/cefsimple -name '*.a' | wc -l
1269
```


## Refs

1. [MasterBuildQuickStart: Linux Setup](https://bitbucket.org/chromiumembedded/cef/wiki/MasterBuildQuickStart.md#markdown-header-linux-setup)
2. [AutomatedBuildSetup](https://bitbucket.org/chromiumembedded/cef/wiki/AutomatedBuildSetup.md)
3. [CEF Forum](https://magpcss.org/ceforum/)
