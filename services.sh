#!/bin/sh
set -eu
services=(
    systemd-timesyncd.service
    earlyoom.service
)

for service in "${services[@]}" ; do
    systemctl is-enabled --quiet "$service" || sudo systemctl enable "$service"
done
