#!/bin/bash

MAPLIST_CONFIG_DIR="$HOME/serverConfigs/csgo"
ML_COMP="$MAPLIST_CONFIG_DIR/maplist_competitive.txt"
ML_CASU="$MAPLIST_CONFIG_DIR/maplist_casual.txt"
ML_ARMS="$MAPLIST_CONFIG_DIR/maplist_armsrace.txt"
ML_DEMO="$MAPLIST_CONFIG_DIR/maplist_demolition.txt"

for MAP in $(~/bin/buildMapcycle.sh); do
    grep -q "$MAP" "$ML_COMP"; IN_COMP=$?
    grep -q "$MAP" "$ML_CASU"; IN_CASU=$?
    grep -q "$MAP" "$ML_ARMS"; IN_ARMS=$?
    grep -q "$MAP" "$ML_DEMO"; IN_DEMO=$?

    # If it's not in any of those files...
    if [[ $IN_COMP -eq 1 && $IN_CASU -eq 1 && $IN_ARMS -eq 1 && $IN_DEMO -eq 1 ]]; then
        echo $MAP >> "$ML_COMP"
    fi
done
