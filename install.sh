#!/bin/sh

# Script that makes Speedsaver ready on Arch Linux.
#
# Author: Zoltán Kéri <z@zolk3ri.name>
# Version: v0.0.1

if [ "$(id -u)" -ne 0 ]; then
  echo "$0: you must be root."
  exit 1
fi

cleanup() {
  echo "Exiting prematurely..."

  rm -rf "$HOME"/ArduiPi_OLED
  rm -rf "$HOME"/navit

  exit 1
}

trap cleanup INT TERM

run() {
  if [ -z ${QUIET+x} ]; then
    QUIET=true
  fi

  if "$QUIET"; then
    "$@" >/dev/null 2>&1
  else
    "$@"
  fi
}

cd "$HOME" || echo "Failed to change directory to $HOME, exiting."

echo "-> Initializing pacman keyring"
run pacman-key --init
echo "-> Populating pacman keyring (archlinuxarm)"
run pacman-key --populate archlinuxarm

echo "-> Performing a full system upgrade"
run pacman --noconfirm -Syu

echo "-> Installing the necessary packages"
run pacman --noconfirm -S base-devel git meson cmake ninja glib2 chrony gpsd

echo "-> Fetching, compiling, and installing ArduiPi_OLED"
run git clone https://github.com/Speedsaver/ArduiPi_OLED
run cd ArduiPi_OLED && run make && run make install && cd ..

echo "-> Fetching, compiling, and installing navit"
run git clone https://github.com/Speedsaver/navit
cd navit && run meson setup build && cd build && run ninja \
  && run ninja install && cd ../..

echo "-> Configuring chronyd"
run cp rootfs/etc/chrony.conf /etc
echo "-> Enabling service: chronyd"
run systemctl enable chronyd
echo "-> Starting service: chronyd"
run systemctl start chronyd

echo "-> Configuring gpsd"
run cp rootfs/etc/default/gpsd /etc/default
echo "-> Enabling service: gpsd"
run systemctl enable gpsd
echo "-> Starting service: gpsd"
run systemctl start gpsd

echo "-> Copying files to /usr/local/share/navit"
if [ ! -d /usr/local/share/navit/maps ]; then
  run mkdir -p /usr/local/share/navit/maps
fi
cp -r rootfs/usr/share/navit/* /usr/local/share/navit

echo "-> Copying files to /usr/local/share/speedsaver"
if [ ! -d /usr/local/share/speedsaver ]; then
  run mkdir -p /usr/local/share/speedsaver
fi
run cp -r rootfs/usr/share/speedsaver/* /usr/local/share/speedsaver

echo "-> Copying gps-logger.sh to /usr/local/bin"
run cp rootfs/usr/bin/gps-logger.sh /usr/local/bin
run chmod +x /usr/local/bin/gps-logger.sh
echo "-> Copying gps-logger.service to /etc/systemd/system"
run cp rootfs/etc/systemd/system/gps-logger.service /etc/systemd/system
#echo "-> Enabling service: gps-logger"
#systemctl enable gps-logger.service

echo "-> Copying journald.conf to /etc/systemd"
run cp rootfs/etc/systemd/journald.conf /etc/systemd

echo "-> Copying amixer.service to /etc/systemd/system"
run cp rootfs/etc/systemd/system/amixer.service /etc/systemd/system
echo "-> Enabling service: amixer"
run systemctl enable amixer.service
run systemctl start amixer.service

echo "-> Copying bootup-sound.service to /etc/systemd/system"
run cp rootfs/etc/systemd/system/bootup-sound.service /etc/systemd/system
echo "-> Enabling service: bootup-sound"
run systemctl enable bootup-sound.service

echo "-> Copying navit.service to /etc/systemd/system"
run cp rootfs/etc/systemd/system/navit.service /etc/systemd/system
echo "-> Enabling service: navit"
run systemctl enable navit.service

printf "\nSuccess!\n"
printf "Place the map files here: /usr/local/share/navit/maps\n"
printf "After that, simply reboot the system.\n\n"
printf "Drive safely!\n"
