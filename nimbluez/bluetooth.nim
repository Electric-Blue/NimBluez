# Copyright (c) 2016, Maxim V. Abramov
# All rights reserved.
# Look at LICENSE for more info.

## This cross-platform module is used for discovery and managing Bluetooth
## devices and services.

const useWinVersion = defined(Windows) or defined(nimdoc)

when useWinVersion:
  import bluetoothmsbt

  export BLUETOOTH_ADDRESS, BLUETOOTH_RADIO_INFO, BLUETOOTH_DEVICE_INFO
  export ERROR_NO_MORE_ITEMS

else:
  import bluetoothbluez

  export bdaddr_t, inquiry_info

export BluetoothDeviceLocalImpl, BluetoothDeviceLocal
export BluetoothDeviceRemoteImpl, BluetoothDeviceRemote
export getLocalDevice, getLocalDevices
export getRemoteDevice, getRemoteDevices
export address, name, classOfDevice
