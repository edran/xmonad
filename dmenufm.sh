#!/bin/sh
# A fuzzy file-finder and opener based on dmenu
# Requires: dmenu, exo-open
cat ~/.dmenufm_cache | dmenu -i -l 5 -nf '#839496' -nb '#002b36' -fn 'Droid Sans Mono-9' -sf "#dc322f" -sb "#073642" -b | xargs exo-open
