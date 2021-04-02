#!/usr/bin/env sh

set -x

# set rtorrent user and group id
RT_UID=${USR_ID:=1000}
RT_GID=${GRP_ID:=1000}

# update uids and gids
groupadd -g $RT_GID rtorrent
useradd -u $RT_UID -g $RT_GID -d /home/rtorrent -m -s /bin/bash rtorrent

# arrange dirs and configs
mkdir -p /downloads/.rtorrent/session 
mkdir -p /downloads/.rtorrent/watch
mkdir -p /downloads/.log/rtorrent
if [ ! -e /downloads/.rtorrent/.rtorrent.rc ]; then
    cp /root/.rtorrent.rc /downloads/.rtorrent/
    sed -i 's/network\.port_range\.set *=.*$/network.port_range.set = '$INCOMING_PORT'/g' /downloads/.rtorrent/.rtorrent.rc
    sed -i 's/network\.port_random\.set *=.*$/network.port_random.set = no/g' /downloads/.rtorrent/.rtorrent.rc
    sed -i 's/dht\.port\.set *=.*$/dht.port.set = '$DHT_PORT'/g' /downloads/.rtorrent/.rtorrent.rc
fi
ln -s /downloads/.rtorrent/.rtorrent.rc /home/rtorrent/
chown -R rtorrent:rtorrent /downloads/.rtorrent
chown -R rtorrent:rtorrent /home/rtorrent
chown -R rtorrent:rtorrent /downloads/.log/rtorrent

rm -f /downloads/.rtorrent/session/rtorrent.lock

# run
su --login --command="TERM=xterm rtorrent" rtorrent 
