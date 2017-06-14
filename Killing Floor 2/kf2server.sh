#!/bin/bash
PIDKF2=`ps -ef | grep KFServer.exe | grep 7777 | awk '{print $2}'`
PIDxvfb=`ps -ef | grep "Xvfb :99" | awk '{print $2}'`
key="$1"
case $key in
    -u | --update)
    echo "Updating server."
    if [ -n PIDKF2 ] 
    then
        {kill $PIDKF2} 2>/dev/null
        {kill $PIDxvfb } 2>/dev/null
    fi
    # start the update on the server
    cd /home/steam/
    ./steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +login anonymous +force_install_dir ./kf2server +app_update 232130 +quit
    echo Update job finished!
    shift
    ;;
    -s | --start)
    echo "Starting server."
    WINEDEBUG="fixme-all" xvfb-run wine /home/steam/steamcmd/kf2server/Binaries/Win64/KFServer.exe kf-bioticslab?difficulty=1 -port=7777 &
    shift
    ;;
    -r | --restart)
    echo "Restarting server."
    if [ -n PIDKF2 ] 
    then
        {kill $PIDKF2} 2>/dev/null
        {kill $PIDxvfb} 2>/dev/null
    fi
    # then start the server on port 7777
    WINEDEBUG="fixme-all" xvfb-run wine /home/steam/steamcmd/kf2server/Binaries/Win64/KFServer.exe kf-bioticslab?difficulty=1 -port=7777 &
    shift
    ;;
    -k | --kill)
    if [ -n PIDKF2 ] 
    then
        kill $PIDKF2 #2>/dev/null
        kill $PIDxvfb #2>/dev/null
    fi
    shift
    ;;
    *)

    ;;
esac
shift
