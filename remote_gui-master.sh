#!/usr/bin/env bash

# remote control GUI using yad
# requires script to react to each button press e.g. kodi_remote-master.sh
# uses xdotool but could use wmctrl

# is this necessary? Can't remember

cd ~/bin

# 
# Screen Placement for consistency. I use all tray to place this in the systray
# and keep it close to the tray icon

RIGHT=1250
DOWN=650

# Nothing to do here but make sure the window is visible
pidof yad > /dev/null && xdotool search --name 'KODI Remote' windowactivate && exit 0

# This is the remote control layout

yad --window-icon=$HOME/.icons/kodi.svg \
	--skip-taskbar \
	--separator="," --geometry=+${RIGHT}+${DOWN} \
	--title="KODI Remote" \
	--borders=25 \
	--buttons-layout=center \
	--no-buttons \
	--form --align=left --columns=3 \
\
\
	--field="!gtk-media-forward-rtl!Rewind":FBTN  "bash -c '~/bin/kodi_remote-master.sh 1'"\
	--field=" !gtk-media-previous-ltr!Play Previous":FBTN "bash -c '~/bin/kodi_remote-master.sh 2'" \
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
	--field=" !media-tape-symbolic!Show Player":FBTN "bash -c '~/bin/kodi_remote-master.sh 3'" \
	--field=" !gtk-go-forward-rtl":FBTN "bash -c '~/bin/kodi_remote-master.sh 4'" \
	--field=" !go-home!Main Menu":FBTN "bash -c '~/bin/kodi_remote-master.sh 5'" \
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
	--field=" !zoom-out!Volume Down":FBTN "bash -c '~/bin/kodi_remote-master.sh 6'" \
	--field=" !document-export!Send Text":FBTN "bash -c '~/bin/kodi_remote-master.sh 7'"\
\
\
	--field="!gtk-media-pause!Play/Pause":FBTN "bash -c '~/bin/kodi_remote-master.sh 8'" \
	--field="!gtk-media-stop!Stop":FBTN "bash -c '~/bin/kodi_remote-master.sh 9'" \
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
	--field="!gtk-go-up":FBTN "bash -c '~/bin/kodi_remote-master.sh 10'" \
	--field="OK":FBTN "bash -c '~/bin/kodi_remote-master.sh 11'" \
	--field="!gtk-go-down":FBTN "bash -c '~/bin/kodi_remote-master.sh 12'" \
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
	--field="!audio-input-microphone-muted-symbolic!Mute:FBTN" "bash -c '~/bin/kodi_remote-master.sh 13'"\
	--field=" ":LBL  "bash -c '~/bin/kodi_remote-master.sh 14'"\
\
\
	--field=" !gtk-media-forward-ltr!Fast Forward":FBTN "bash -c '~/bin/kodi_remote-master.sh 15'" \
	--field="!gtk-media-previous-rtl!Play Next":FBTN "bash -c '~/bin/kodi_remote-master.sh 16'" \
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
	--field="!dialog-information-symbolic!Media Info":FBTN "bash -c '~/bin/kodi_remote-master.sh 17'" \
	--field="!gtk-go-back-rtl":FBTN "bash -c '~/bin/kodi_remote-master.sh 18'" \
	--field="!edit-undo!Go Back":FBTN "bash -c '~/bin/kodi_remote-master.sh 19'" \
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
        --field="":LBL  "bash -c '~/bin/kodi_remote-master.sh 0'"\
	--field="!zoom-in!Volume Up":FBTN "bash -c '~/bin/kodi_remote-master.sh 20'" \
	--field="!drive-multidisk-symbolic!Context Menu":FBTN "bash -c '~/bin/kodi_remote-master.sh 21'"  

 exit 0
