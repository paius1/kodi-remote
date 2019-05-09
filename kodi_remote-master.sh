#!/bin/bash 

# VARIABLES
  KODI_HOST='mythtv'
  KODI_PORT='8080'
  KODI_USER='kodi'
  KODI_PASS=''
  
# FUNCTIONS

  function kodi_req {
echo value = $1
    output=$(curl -s -i -X POST --header "Content-Type: application/json" -d "$1" http://$KODI_USER:$KODI_PASS@$KODI_HOST:$KODI_PORT/jsonrpc)  

    if [[ $2 = true ]];
    then
	  echo $output
    fi 
  }

  function parse_json {
   key=$1
   awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$key'\042/){print $(i+1)}}}' | tr -d '"' 
  }

# Get Active players first
  output=`kodi_req '{"jsonrpc": "2.0", "method": "Player.GetActivePlayers", "id": 99}' true`
  player_id=`echo $output | parse_json "playerid"` 
  echo "Player ID = $player_id"

    case "$1" in
	1)
	echo rewind
#	   kodi_req '{"jsonrpc":"2.0", "method": "Player.SetSpeed", "params": {"playerid": '${player_id}',"speed": "decrement"}, "id": 1}'
	   kodi_req '{"jsonrpc":"2.0", "method": "Player.Seek", "params": {"playerid": '${player_id}',"value": "smallbackward"}, "id": 1}'
	;;
	2)
	echo play previous
	   kodi_req '{"jsonrpc": "2.0", "method": "Player.GoTo", "params": { "playerid": '${player_id}', "to": "previous" }, "id": 1}'
	;;
	3)
	echo show player
	   kodi_req '{"jsonrpc": "2.0", "method": "Input.'showOSD'"}'
	;;
	4)
	echo move left
	   kodi_req '{"jsonrpc": "2.0", "method": "Input.'Left'"}'
	;;
	5)
	echo go home
	   kodi_req '{"jsonrpc": "2.0", "method": "Input.'Home'"}'
	;;
	6)
	echo volume down
	   kodi_req '{ "jsonrpc": "2.0", "method": "Application.SetVolume", "params": { "volume": "decrement" }, "id": 1 }'
	;;
	8)
	echo play.pause
	   kodi_req '{"jsonrpc": "2.0", "method": "Player.PlayPause", "params": { "playerid": '$player_id' }, "id": 1}'
	;;
	9)
	echo stop playback
	   kodi_req '{"jsonrpc": "2.0", "method": "Player.Stop", "params": { "playerid": '$player_id' }, "id": 1}'
	;;
	10)
	echo move up
	   kodi_req '{"jsonrpc": "2.0", "method": "Input.'Up'"}'
	;;
	11)
	echo ok.enter
	   kodi_req '{"jsonrpc": "2.0", "method": "Input.'Select'"}'	
	;;
	12)
	echo move down
	   kodi_req '{"jsonrpc": "2.0", "method": "Input.'Down'"}'
	;;
	13)
	echo mute
	   curl -s --user "$KODI_USER:$KODI_PASS" --header "Content-Type:application/json" --data '{"jsonrpc":"2.0", "method":"Application.SetMute", "params":{"mute":"toggle"}, "id":1}' "http://$KODI_HOST:$KODI_PORT/jsonrpc"
	;;
	15)
	echo fast forward
#	   kodi_req '{"jsonrpc":"2.0", "method": "Player.SetSpeed", "params": {"playerid": '${player_id}',"speed": "increment"}, "id": 1}'
	   kodi_req '{"jsonrpc":"2.0", "method": "Player.Seek", "params": {"playerid": '${player_id}',"value": "smallforward"}, "id": 1}'
	;;
	16)
	echo play next
	   kodi_req '{"jsonrpc": "2.0", "method": "Player.GoTo", "params": { "playerid": '${player_id}', "to": "next" }, "id": 1}'
	;;
	17)
	echo info
	   kodi_req '{"jsonrpc": "2.0", "method": "Input.'Info'"}'
	;;
	18)
	echo move right
	   kodi_req '{"jsonrpc": "2.0", "method": "Input.'Right'"}'
	;;
	19)
	echo go back
	   kodi_req '{"jsonrpc": "2.0", "method": "Input.'Back'"}'
	;;
	20)
	echo volume up
	   kodi_req '{ "jsonrpc": "2.0", "method": "Application.SetVolume", "params": { "volume": "increment" }, "id": 1 }'
	;;
	21)
	echo context menu
	   kodi_req '{ "jsonrpc": "2.0", "method": "Input.ContextMenu", "id": 1}'
	;;
	*)
	echo dont know
 	;;
    esac

exit 0
