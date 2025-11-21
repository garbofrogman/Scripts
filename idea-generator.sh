#!/usr/bin/env bash

players=("singleplayer" "multiplayer")
mood=("exciting" "chill" "funny" "suspenseful" "spooky" "difficult")
type=("action" "exploration" "funny" "chill" "puzzle" "roguelike" "rhythm" "psychedelic")
genre=("action" "adventure" "puzzle" "rpg" "sim" "strategy" "arcade")
gfx=("3D" "2D" "isometric" "crazy")

echo "Make a(n) ${mood[$((1 + $RANDOM % 6))]} \
  ${players[$((0 + $RANDOM % 2))]} \
  ${genre[$((0 + $RANDOM % 7))]} game with ${gfx[$((0 + $RANDOM % 4))]} graphics \
  and ${type[$((1 + $RANDOM % 7))]} vibes."
