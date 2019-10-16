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
        --class=kodi_remote \
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
	--field="!drive-multidisk-symbolic!Context Menu":FBTN "bash -c '~/bin/kodi_remote-master.sh 21'"  2>/dev/null &
    yadPID=$!

finish() {
    kill -0 $yadPID 2>/dev/null  && { kill $yadPID >/dev/null 2>&1; wait $yadPID >/dev/null 2>&1; }
}
  trap  finish EXIT INT

  until [[ $WINDOW_ID ]]; do
      WINDOW_ID=$(wmctrl -l | grep 'KODI Remote' | awk '{print $1}')
  done

    WINDOW_ID="${WINDOW_ID/x0/x}"
    KEYBOARD_NAME="Full Width Keyboard" # from xinput --list
    KEYBOARD_ID=$(  xinput --list | grep -i  "$KEYBOARD_NAME" | grep -o 'id=[0-9]\+' | grep -o '[0-9]\+')
    STATE1=$(xinput --query-state "$KEYBOARD_ID" | grep 'key\[' | sort)
    STATE2=STATE1

  while [ -e /proc/"$yadPID" ]; do
        current_window=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f2)
        sleep 0.1

        if [ "$current_window" = "$WINDOW_ID" ]; then
           
           # Repeat up down left right volup voldwn skip if modifier down
             key=$(xinput --query-state "$KEYBOARD_ID" | grep down | grep -o 'key\[[0-9]\+' | grep -o  '[0-9]\+')
             case "$key" in
                # modifier key is down
                37*|64*|105*|108*|133*|134*|135*) 
                    continue
                ;;
                # up down keypad_up keypad_down left right volup voldwn
                20|21|27|41|83|85|111|113|114|116) 
                   i=
                ;;
             esac
           
           # This finds a change of state on the keyboard  
             STATE2=$(xinput --query-state "$KEYBOARD_ID" | grep 'key\[' | sort)
             [[ "$i" ]] && key=$(comm -13 <(echo "$STATE1") <(echo "$STATE2")  | grep down | grep -o 'key\[[0-9]\+' | grep -o  '[0-9]\+')
             ((i++))
             STATE1=$STATE2
             [[ ! $key ]] && continue
#  uncomment next lines to output keystrokes to stdout
  echo KEY "$key"
#  continue
             case "$key" in
                27|83) echo rewind
                    ~/bin/kodi_remote.sh 1
                  ;;
                112) echo play previous
                    ~/bin/kodi_remote.sh 2
                  ;;
                33) echo show player
                    ~/bin/kodi_remote.sh 3
                  ;;
                113) echo move left
                    ~/bin/kodi_remote.sh 4
                  ;;
                43) echo go home
                    ~/bin/kodi_remote.sh 5
                  ;;
                20) 
                    echo volume DOWN
                    ~/bin/kodi_remote.sh 6
                  ;;
                28) echo send text
                    ~/bin/kodi_remote.sh 7
                  ;;
                65) echo play.pause
                    ~/bin/kodi_remote.sh 8
                  ;;
                39) echo stop playback
                    ~/bin/kodi_remote.sh 9
                  ;;
                111) 
                    echo move up 
                    ~/bin/kodi_remote.sh 10
                  ;;
                36) echo ok.enter
                    ~/bin/kodi_remote.sh 11
                  ;;
                116) echo move down
                    ~/bin/kodi_remote.sh 12
                  ;;
                58) echo mute
                    ~/bin/kodi_remote.sh 13
                  ;;
                43) echo switch host
                    ~/bin/kodi_remote.sh 14
                ;; 
                41|85) echo fast forward
                    ~/bin/kodi_remote.sh 15
                  ;;
                117) echo play next
                    ~/bin/kodi_remote.sh 16
                  ;;
                31) echo info
                    ~/bin/kodi_remote.sh 17
                  ;;
                114) echo move right
                    ~/bin/kodi_remote.sh 18
                  ;;
                22) echo go back
                    ~/bin/kodi_remote.sh 19
                  ;;
                21) echo volume UP
                    ~/bin/kodi_remote.sh 20
                  ;;
                54) echo context menu
                    ~/bin/kodi_remote.sh 21
                  ;;
                *) echo dont know
                  ;;
             esac
        fi
  done
exit 0

