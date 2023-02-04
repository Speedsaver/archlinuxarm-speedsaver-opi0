archlinuxarm-speedsaver-opi0
============================

`rootfs/` contains the files necessary for Speedsaver.

`install.sh` is the script that makes Speedsaver ready on Arch Linux.

For documentation consult file `install.sh`.

# Basics

Use the instructions provided [here](https://github.com/Speedsaver/archlinuxarm-orangepi-zero) to install Arch Linux on the SD card.

By default `sshd` is enabled and starts at boot.
The default user is `alarm`, and its password is `alarm`.
The default root password is `root`.

The `install.sh` script serves the purpose of automating the set up of `Speedsaver`.
All you have to do is access your board[1] and run the script as root.
You can specify verbosity via the environment variable `QUIET`. For example:

    # QUIET=false ./install.sh

[1] Use the serial console or SSH to the IP address given to the board.

# Adding maps

There are at least three ways to add maps.
The directory is `/usr/local/share/navit/maps` on the board with Arch Linux.
Do not forget to restart `navit` after adding the maps:

    # systemctl restart navit

## Example #1 (using scp)

On your local machine (to copy the file through SSH):

	$ scp /home/local/map.bin alarm@alarm:/home/alarm/

then access your board and run the following command (as root):

	# mv /home/alarm/map.bin /usr/local/share/navit/maps

## Example #2 (using curl)

Access your board and download the map straight into the directory:

	# cd /usr/local/share/navit/maps
	# curl -O https://foo.bar/map.bin

## Example #3 (using mount and cp)

Mount the storage device (e.g. USB stick, here `/dev/sdc1`):

	# mount /dev/sdc1 /mnt
	# cp /mnt/map.bin /usr/local/share/navit/maps

# Authors

Zoltán Kéri <z@zolk3ri.name>
