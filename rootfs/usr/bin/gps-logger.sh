#!/bin/sh

gpspipe -r | grep GPRMC | awk 'NR%2==0' | curtail -s 100M /data/gps.log
