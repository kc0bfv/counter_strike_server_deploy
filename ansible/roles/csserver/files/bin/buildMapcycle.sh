#!/bin/bash

. ~/bin/steam_install_properties

cd "${csgoServerFolder}/maps" &> /dev/null
for i in *.bsp workshop/*/*.bsp; do
	echo $i | cut -f 1 -d "." | grep --invert "training1" | grep --invert "_se$" | grep --invert "dz_" | grep --invert "coop_"
done
cd - &> /dev/null
