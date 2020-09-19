#!/bin/bash
# Usage: seat-setup.sh GREETER
#
# Config example for greetd:
#   command = "/etc/greetd/seat-setup.sh sway --config /etc/greetd/sway-config"
#
# This resolves XDG_RUNTIME_DIR is not set issue in Exherbo
#
# See "Running Weston" section of https://wayland.freedesktop.org/building.html
# Since we are running outside of user session we need some environment prepared.
# We should remember that we run under greeter user.

set -ex

if [[ -z "$XDG_RUNTIME_DIR" ]]; then
    reldir="xdg-run-vt${XDG_VTNR}-uid${UID}"
    for baserundir in /dev/shm /var/tmp /tmp; do
        if ! [[ -d "$baserundir/$reldir" ]]; then
            mkdir "$baserundir/$reldir" || continue
            chmod 0700 "$baserundir/$reldir"
        fi
        export XDG_RUNTIME_DIR="$baserundir/$reldir"
        break
    done
    if [[ -z "$XDG_RUNTIME_DIR" ]]; then
        echo "Failed to find usable dir" >&2
        exit 1
    fi
fi

### put more setup here if needed ###

#####################################

exec "$@"
