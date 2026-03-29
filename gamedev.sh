#!/usr/bin/env bash

# KITTYPID=

rm /tmp/godot.pipe 2>&1
kitty kitten @ launch --title Output nvim --listen /tmp/godot.pipe &
# KITTYPID=$!
godot >/dev/null 2>&1

# kill $KITTYPID
