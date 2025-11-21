#! /bin/bash
# TODO use rsync for this
notify-send "Backing up Zomboid sandbox save to external"
rm -r "/mnt/91fb9e14-338d-4580-b83f-70d768c597eb/Zomboid save backup/"*
cp -r /home/george/Zomboid/Saves/Sandbox/* "/mnt/91fb9e14-338d-4580-b83f-70d768c597eb/Zomboid save backup/"
