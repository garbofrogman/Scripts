#!/usr/bin/env bash

# TODO 
# Create a function to handle user confirmation instead of individual prompts for [Y/n]
# Add option to boot the VM after install


echo "This script is intended to be used in a BTRFS filesystem. It will create a vm in $HOME/vm using qemu-desktop. It will create the directory and install qemu-desktop if needed. Continue? [Y/n]: " continue
if [ ${continue,,} == "n" ]; then
  echo "Exiting."
  exit 0
fi

if [ ! -d ~/vm ]; then
  echo "Creating $HOME/vm directory"
  mkdir ~/vm
else
  echo "~/vm already exists."
  if [ $(lsattr -l $HOME | grep "/vm" | awk '{print $2}') == "No_COW" ]; then
    echo "Copy-On-Write already disabled for ~/vm"
  else
    echo "Disabling Copy-On-Write for $HOME/vm"
    chattr +C ~/vm # Disable BTRFS Copy-On-Write
  fi
fi

if ! pacman -Qs qemu-desktop >/dev/null; then
  echo "Installing qemu-desktop..."
  sudo pacman -S extra/virglrenderer --asdeps >/dev/null # Because this fails to resolve from cachyos v3 extras repo when downloading dependencies (as of writing this 2025-10-23)
  sudo pacman -S qemu-desktop >/dev/null
  echo "Installed qemu-desktop."
else
  echo "qemu-desktop already installed."
fi

echo ""
read -p "Create VM now? [Y/n] " create

if [ "${create,,}" == "n" ]; then
  echo "Exiting."
  exit 0
fi

# Ask vm options from user
while true; do
  read -p "Name of image file to create: " iname
  if [ -e $HOME/vm/${iname} ]; then
    echo "$HOME/vm/$iname already exists. Try again."
  else
    break
  fi
done

echo "The VM will take up minimal space and grow as more is needed."
regint='^[0-9]+$'
while true; do
  read -p "Enter maximum size of VM disk in GiB: " size
  if [[ ! $size =~ $regint ]]; then
    echo "Try again. Must be a whole number."
  else
    break
  fi
done

echo "Creating $HOME/vm/$iname with ${size}GiB max size."
read -p "Is this correct? If not, the script will exit and you can try again [Y/n]: " confirm
if [ "${confirm,,}" == "n" ]; then
  echo "Exiting..."
  exit 0
fi

# Make the disk image
echo "Creating disk image..."
qemu-img create --format qcow2 $HOME/vm/$iname -o nocow=on ${size}G

while true; do
  read -p "Enter the path to the installation .iso: " isopath
  if [ ! -e $isopath ]; then
    echo "$isopath not found. Try again."
  else
    break
  fi
done

while true; do
  read -p "Enter how much RAM to allocate (in GiB): " ram
  if [[ ! $ram =~ $regint ]]; then
    echo "Try again. Must be a whole number."
  else
    break
  fi
done

mkdir ~/vm/OVMF
cp /usr/share/edk2/x64/OVMF_CODE.4m.fd ~/vm/OVMF

qemu-system-x86_64 -cdrom ${isopath} \
  -boot order=d \
  -drive file=${HOME}/vm/${iname},format=qcow2 \
  -m ${ram}G \
  -accel kvm \
  &&

# WIP trying to figure out how to actually run the VM lol...........
# qemu-system-x86_64 -enable-kvm -cpu host -m 16G \
# -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
# -drive if=pflash,format=raw,file=/home/george/vm/OVMF/OVMF_CODE.4m.fd \
# $HOME/vm/$iname
