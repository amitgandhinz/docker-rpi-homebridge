#! /bin/sh

# Fix avahi
sed -i "s/rlimit-nproc=3/#rlimit-nproc=3/" /etc/avahi/avahi-daemon.conf
dbus-daemon --system
avahi-daemon -D
service dbus start
service avahi-daemon start

# Install desired plugins
# sed  -e 's/\r/\n/g' /root/.homebridge/plugins/plugins.txt
cat /root/.homebridge/plugins/plugins.txt | od -c
dos2unix /root/.homebridge/plugins/plugins.txt
cat /root/.homebridge/plugins/plugins.txt | od -c
cat /root/.homebridge/plugins/plugins.txt | xargs npm install -g --unsafe-perm

# Start service
homebridge
