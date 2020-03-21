# Copyright (c) 2016, Maxim V. Abramov
# All rights reserved.
# Look at LICENSE for more info.

## Simple Bluetooth local and remote devices discovery implementation.

import strutils
import ../nimbluez/bluetooth

echo "Local devices:"
for localDevice in getLocalDevices():
  echo "$1 - $2 - $3" % [localDevice.address,
                         localDevice.name,
                         localDevice.classOfDevice.int.toBin(24)]

  echo "  Remote devices:"
  for remoteDevice in localDevice.getRemoteDevices():
    echo "  $1 - $2 - $3" % [remoteDevice.address,
                             remoteDevice.name,
                             remoteDevice.classOfDevice.int.toBin(24)]

echo ""
echo "All remote devices:"
for remoteDevice in getRemoteDevices():
  echo "$1 - $2 - $3" % [remoteDevice.address,
                         remoteDevice.name,
                         remoteDevice.classOfDevice.int.toBin(24)]
