#!/usr/bin/env bash
set -oue pipefail

# fix ublue base-main booting into a black screen 
systemctl enable getty@tty1