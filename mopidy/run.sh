#!/bin/bash
set -e

local_scan=$(cat /data/options.json | jq -r '.local_scan // empty')
options=$(cat /data/options.json | jq -r 'if .options then [.options[] | "-o "+.name+"="+.value ] | join(" ") else "" end')
config="/var/lib/mopidy/.config/mopidy/mopidy.conf"

# Target ALSA card 
CARD_INDEX=`cat /proc/asound/cards | egrep '\[ALSA' | awk '{ print $1 }'`
sed -i 's/defaults\.pcm\.card [0-1]/defaults\.pcm\.card $CARD_INDEX/g' /usr/share/alsa/alsa.conf
sed -i 's/defaults\.ctl\.card [0-1]/defaults\.ctl\.card $CARD_INDEX/g' /usr/share/alsa/alsa.conf

if  [ "$local_scan" == "true" ]; then
    mopidy --config $config $options local scan
fi
mopidy --config $config $options
