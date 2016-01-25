# Copyright (c) 2016, Maxim V. Abramov
# All rights reserved.
# Look at license.txt for more info.

## Simple Bluetooth local and remote devices discovery implementation.

import strutils
import ../nimbluez/bluetooth

echo "Local devices:"
for localDevice in getLocalDevices():
  echo "$1 - $2" % [localDevice.address, localDevice.name]

  echo "  Remote devices:"
  for remoteDevice in localDevice.getRemoteDevices():
    echo "  $1 - $2" % [remoteDevice.address, remoteDevice.name]

echo ""
echo "All remote devices:"
for remoteDevice in getRemoteDevices():
  echo "$1 - $2" % [remoteDevice.address, remoteDevice.name]
