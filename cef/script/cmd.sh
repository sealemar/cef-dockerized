#!/bin/bash

set -e

archive_subpath="/host-mount"

function announce() {
    local dt=$(date +'%Y.%m.%dT%H:%M:%S')
    local bn=$(basename $0)
    echo
    echo "---------------------------------------"
    echo "$bn - $dt - $1"
    echo "---------------------------------------"
    echo
}

. $(dirname $0)/set_env.sh
announce "Environment was set to"
env

announce "Running: python /app/automate/automate-git.py --download-dir=/app/chromium_git --depot-tools-dir=/app/depot_tools ${extra_automate_args}"
python /app/automate/automate-git.py --download-dir=/app/chromium_git --depot-tools-dir=/app/depot_tools --build-target=cefsimple ${extra_automate_args}

date=$(date +'%Y.%m.%dT%H:%M:%S')
archive_location="${archive_subpath}/cef-chromium_git-${arch}-${date}.7z"
announce "Archiving artifacts to ${archive_location}"

# Create a 7z archive of /app/chromium_git recursively excluding all '.git' subfolders
time 7z a -xr0'!*.git' "${archive_location}" /app/chromium_git
announce "Artifacts archived to ${archive_location}"
ls -lh "${archive_location}"
announce "Done!"
