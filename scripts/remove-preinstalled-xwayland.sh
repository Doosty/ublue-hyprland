#!/usr/bin/env bash
set -oue pipefail

rpm-ostree override remove "xorg-x11-server-Xwayland"
