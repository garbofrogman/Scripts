#!/usr/bin/env bash

PIPEWIRE=~/.config/pipewire/filter-chain.conf.d

mkdir -p $PIPEWIRE
mkdir ~/.ladspa

wget -O ${PIPEWIRE}/deepfilter-mono-source.conf https://raw.githubusercontent.com/Rikorose/DeepFilterNet/refs/heads/main/ladspa/filter-chain-configs/deepfilter-mono-source.conf
wget -O ~/.ladspa/libdeep_filter_ladspa.so https://github.com/Rikorose/DeepFilterNet/releases/download/v0.5.6/libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so

# Edit pipewire conf file
# Name the module so it can be programmatically selected
sed -i "/args = {/a\            node.name \= \"noise_cancel\""
# Edit plugin path
sed -i "s/plugin =.*/plugin = \/home\/george\/.ladspa\/libdeep_filter_ladspa.so/" $PIPEWIRE/deepfilter-mono-source.conf
# Set attenuation limit
sed -i "s/(dB)\" .*/(dB)\" 20/" $PIPEWIRE/deepfilter-mono-source.conf

systemctl restart --user pipewire.service

# Start this with:
# pipewire -c filter-chain.conf
