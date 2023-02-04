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

Access your board[1], and perform the following commands (if have not done so):

	# pacman-key --init
	# pacman-key --populate archlinuxarm

and install `git` as it is not installed by default:

	# pacman -S git

then clone this repository and run the script as root.

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

Note that for multiple files, you may use globbing, e.g. `*.bin`.

## Example #2 (using curl)

Access your board and download the map straight into the directory:

	# cd /usr/local/share/navit/maps
	# curl -O https://foo.bar/map.bin

## Example #3 (using mount and cp)

Access your board, then mount the storage device (e.g. USB stick, here `/dev/sdc1`):

	# mount /dev/sdc1 /mnt

and copy the `map.bin` file to the target directory:

	# cp /mnt/map.bin /usr/local/share/navit/maps

# Authors

Zoltán Kéri <z@zolk3ri.name>
