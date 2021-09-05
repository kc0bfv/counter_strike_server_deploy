cat ~/Steam/server/csgo/cfg/maplist_* | sort > /tmp/maplistMaps
find Steam/server/csgo/maps/ -iname "*.bsp" | sed "s#Steam/server/csgo/maps/##; s/\.bsp//;" | sort > /tmp/allMaps

diff /tmp/maplistMaps /tmp/allMaps
