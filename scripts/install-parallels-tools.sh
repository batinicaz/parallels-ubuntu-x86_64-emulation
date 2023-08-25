#!/bin/bash
set -euo pipefail
iso_path="/home/vagrant/prl-tools-lin-arm.iso"
mnt_dir='/mnt/parallels'

mkdir -p "${mnt_dir}"
mount -o loop "${iso_path}" "${mnt_dir}"

${mnt_dir}/install --install-unattended-with-deps

umount "${mnt_dir}"
rm -rfv "${mnt_dir}"
rm -fv "${iso_path}"
