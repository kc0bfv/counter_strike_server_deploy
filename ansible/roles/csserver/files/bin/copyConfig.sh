#!/bin/bash

. ~/bin/steam_install_properties

helpMsg() {
	echo "copyConfig.sh -{g,s,h}"
	echo "Copy the server specific configuration over."
	echo ""
	echo "-2 - CS 2.0 Config"
	echo "-g - CS:GO Config"
	echo "-s - CS:Source Config"
	echo "-h - Help (this)"
}

cstwo() {
	cp "${csgoConfigFolder}/autoexec.cfg" "${cs2CFGFolder}"
	cp "${csgoConfigFolder}/server.cfg" "${cs2CFGFolder}"
	cp "${csgoConfigFolder}/motd.txt" "${cs2CFGFolder}/motd.txt"
	cp "${csgoConfigFolder}/motd.txt" "${cs2CFGFolder}/motd.htm"

    cp "${cstwoConfigFolder}/gamemode_competitive_server.cfg" "${cs2CFGFolder}"
}

csgo() {
	gamemodes="armsrace casual competitive deathmatch demolition"

	for gamemode in $gamemodes; do
		gamemodeCFG="gamemode_${gamemode}_server.cfg"
		cp "${csgoConfigFolder}/common.cfg" "${csgoCFGFolder}/${gamemodeCFG}"
		cat "${csgoConfigFolder}/${gamemodeCFG}" >> "${csgoCFGFolder}/${gamemodeCFG}"
	done

	cp "${csgoConfigFolder}/autoexec.cfg" "${csgoCFGFolder}"
	cp "${csgoConfigFolder}/server.cfg" "${csgoCFGFolder}"
	cp "${csgoConfigFolder}/maplist_armsrace.txt" "${csgoCFGFolder}"
	cp "${csgoConfigFolder}/maplist_casual.txt" "${csgoCFGFolder}"
	cp "${csgoConfigFolder}/maplist_competitive.txt" "${csgoCFGFolder}"
	cp "${csgoConfigFolder}/maplist_demolition.txt" "${csgoCFGFolder}"
	cp "${csgoConfigFolder}/botprofile.db" "${csgoServerFolder}"
	cp "${csgoConfigFolder}/gamemodes_server.txt" "${csgoServerFolder}"
	cp "${csgoConfigFolder}/motd.txt" "${csgoServerFolder}/motd.txt"
	cp "${csgoConfigFolder}/motd.txt" "${csgoServerFolder}/motd.htm"
	cp "${csgoConfigFolder}/admins_simple.ini" "${csgoServerFolder}/addons/sourcemod/configs/admins_simple.ini"
	cp "${csgoConfigFolder}/webapi_authkey.txt" "${csgoServerFolder}/"
	cp "${csgoConfigFolder}/mapchooser.cfg" "${csgoCFGFolder}/sourcemod/"

	"${homeDir}/bin/buildMapcycle.sh" > "${csgoServerFolder}/mapcycle.txt"
	"${homeDir}/bin/add_maps_to_competitive.sh"
}

cssrc () {
	echo "Not Implemented Yet"
}

if [ "$1" == "-2" ]; then
	cstwo
elif [ "$1" == "-g" ]; then
	csgo
elif [ "$1" == "-s" ]; then
	cssrc
elif [ "$1" == "-h" ]; then
	helpMsg
else
	helpMsg
fi
