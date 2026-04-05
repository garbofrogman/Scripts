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
# Set attenuation limit (100 is default/ maximum)
sed -i "s/(dB)\" .*/(dB)\" 100/" $PIPEWIRE/deepfilter-mono-source.conf
# Set maximum volume (because mic was super loud)
sed -i "/capture.props = /a\                channelmix.max-volume = 0.5" $PIPEWIRE/deepfilter-mono-source.conf

systemctl restart --user pipewire.service

# Start this with:
# pipewire -c filter-chain.conf
#
# Available properties (found using `pw-cli e input.noise_cancel 2` while this filter-chain config is in use)
#
#   String "DeepFilter Mono:Attenuation Limit (dB)"
#   Float 20.000000
#   String "DeepFilter Mono:Min processing threshold (dB)"
#   Float -15.000000
#   String "DeepFilter Mono:Max ERB processing threshold (dB)"
#   Float 35.000000
#   String "DeepFilter Mono:Max DF processing threshold (dB)"
#   Float 35.000000
#   String "DeepFilter Mono:Min Processing Buffer (frames)"
#   Float 0.000000
#   String "DeepFilter Mono:Post Filter Beta"
#   Float 0.000000
