# Copyright (c) 2016, Maxim V. Abramov
# All rights reserved.
# Look at LICENSE for more info.

## This module is used for discovery and managing Bluetooth devices and
## services. It is based on Microsoft Bluetooth protocol stack implementation
## for Windows.

import os, strutils, algorithm, sequtils
from winlean import WINBOOL, NO_ERROR
import msbt/ms_bluetoothapis, msbt/ms_bthsdpdef, msbt/ms_bthdef

export BLUETOOTH_ADDRESS, BLUETOOTH_RADIO_INFO, BLUETOOTH_DEVICE_INFO

const
  ERROR_NO_MORE_ITEMS* = OSErrorCode(259)

type
  BluetoothDeviceLocalImpl* = object of RootObj ## Local Bluetooth device -
                                                ## radio adapter.
    fRadioInfo*: BLUETOOTH_RADIO_INFO

  BluetoothDeviceLocal* = ref BluetoothDeviceLocalImpl ## Local Bluetooth
                                                       ## device - radio
                                                       ## adapter reference.

  BluetoothDeviceRemoteImpl* = object of RootObj ## Remote Bluetooth device.
    fDeviceInfo*: BLUETOOTH_DEVICE_INFO

  BluetoothDeviceRemote* = ref BluetoothDeviceRemoteImpl ## Remote Bluetooth
                                                         ## device reference.


proc CloseHandle(hObject: HANDLE): WINBOOL{.stdcall, dynlib: "kernel32",
     importc: "CloseHandle".}


proc `$`*(ba: BLUETOOTH_ADDRESS): string =
  ## Returns Bluetooth device address as a string.
  let ab = map(ba.ano_116103095.rgBytes,
               proc(b: byte): string = toHex(BiggestInt(b), 2))
  result = ab.reversed.join(":")


proc parseBluetoothAddress*(str: string): BLUETOOTH_ADDRESS =
  ## Converts a string to a Bluetooth device address.
  var intVals = map(str.split(':'),
                    proc(s: string): int = parseHexInt(s)).reversed()
  for i in 0..5:
    result.ano_116103095.rgBytes[i] = byte(intVals[i])


proc `==`*(x, y: BLUETOOTH_ADDRESS): bool =
  ## Converts a string to a Bluetooth device address.
  x.ano_116103095.ullLong == y.ano_116103095.ullLong


iterator localDeviceHandles*():
  tuple[handle: int , info: BLUETOOTH_RADIO_INFO] {.inline.} =
  ## Iterates through the local Bluetooth devices. Closes current device
  ## ''handle'' at the end of the each iteration.
  var
    findRadioParams: BLUETOOTH_FIND_RADIO_PARAMS
    findRadioHandle: HBLUETOOTH_RADIO_FIND
    radioHandle: int
    errorCode: OSErrorCode

  findRadioParams.dwSize = DWORD(sizeof(findRadioParams))
  try:
    findRadioHandle = BluetoothFindFirstRadio(addr(findRadioParams),
                                              addr(radioHandle))
    if findRadioHandle == 0:
      errorCode = osLastError()
      if errorCode != ERROR_NO_MORE_ITEMS:
        raiseOSError(errorCode)
    else:
      while true:
        var radioInfo: BLUETOOTH_RADIO_INFO
        radioInfo.dwSize = DWORD(sizeof(radioInfo))

        errorCode = BluetoothGetRadioInfo(radioHandle, addr(radioInfo))
          .OSErrorCode
        if errorCode != OSErrorCode(NO_ERROR):
          raiseOSError(errorCode)

        yield (handle: radioHandle, info: radioInfo)

        if CloseHandle(radioHandle) == 0:
          raiseOSError(osLastError())
        radioHandle = 0;

        if BluetoothFindNextRadio(findRadioHandle, addr(radioHandle)) == 0:
          errorCode = osLastError()
          if errorCode != ERROR_NO_MORE_ITEMS:
            raiseOSError(errorCode)
          break
  finally:
    if findRadioHandle != 0:
      if radioHandle != 0:
        if CloseHandle(radioHandle) == 0:
          raiseOSError(osLastError())
      if BluetoothFindRadioClose(findRadioHandle) == 0:
        raiseOSError(osLastError())


iterator getLocalDevices*(): BluetoothDeviceLocal {.inline.} =
  ## Returns all local Blutooth radio devices.
  for item in localDeviceHandles():
    yield BluetoothDeviceLocal(fRadioInfo: item.info)


proc getLocalDevice*(): BluetoothDeviceLocal =
  ## Returns default local Bluetooth radio device.
  for item in getLocalDevices():
    return item
  raiseOSError(ERROR_NO_MORE_ITEMS)


proc getLocalDevice*(address: string): BluetoothDeviceLocal =
  ## Returns local Bluetooth radio device with a specified address.
  let ba = parseBluetoothAddress(address)
  for item in getLocalDevices():
    if item.fRadioInfo.address == ba:
      return item
  raiseOSError(ERROR_NO_MORE_ITEMS)


proc getRemoteDevice*(address: string): BluetoothDeviceRemote =
  ## Returns remote Bluetooth device with a specified address.
  new(result)
  result.fDeviceInfo.Address = address.parseBluetoothAddress


iterator remoteDeviceInfos*(radioHandle: HANDLE;
                            timeoutMultiplier: UCHAR;
                            issueInquiry: BOOL):
                            BLUETOOTH_DEVICE_INFO {.inline.} =
  ## Iterates through the all remote Bluetooth devices visible for the
  ## specified local Bluetooth radio device.
  var
    deviceSearchParams: BLUETOOTH_DEVICE_SEARCH_PARAMS
    deviceFindHandle: HBLUETOOTH_DEVICE_FIND
    errorCode: OSErrorCode
    deviceInfo: BLUETOOTH_DEVICE_INFO

  deviceSearchParams.dwSize = DWORD(sizeof(deviceSearchParams))
  deviceSearchParams.fReturnAuthenticated = BOOL(true)
  deviceSearchParams.fReturnRemembered = BOOL(true)
  deviceSearchParams.fReturnUnknown = BOOL(true)
  deviceSearchParams.fReturnConnected = BOOL(true)
  deviceSearchParams.fIssueInquiry = issueInquiry
  deviceSearchParams.cTimeoutMultiplier = timeoutMultiplier
  deviceSearchParams.hRadio = radioHandle

  deviceInfo.dwSize = DWORD(sizeof(deviceInfo))

  try:
    deviceFindHandle = BluetoothFindFirstDevice(addr(deviceSearchParams),
                                                addr(deviceInfo))
    if deviceFindHandle == 0:
      errorCode = osLastError()
      if errorCode != ERROR_NO_MORE_ITEMS:
        raiseOSError(errorCode)
    else:
      yield deviceInfo

      while true:
        var deviceInfoLoop: BLUETOOTH_DEVICE_INFO
        deviceInfoLoop.dwSize = DWORD(sizeof(deviceInfoLoop))

        if BluetoothFindNextDevice(deviceFindHandle, addr(deviceInfoLoop)) == 0:
          errorCode = osLastError()
          if errorCode != ERROR_NO_MORE_ITEMS:
            raiseOSError(errorCode)
          break

        yield deviceInfoLoop
  finally:
    if deviceFindHandle != 0:
      if BluetoothFindDeviceClose(deviceFindHandle) == 0:
        raiseOSError(errorCode)


proc getRemoteDevices*(device: BluetoothDeviceLocal = nil;
                       duration: int = 8;
                       flushCache: bool = true): seq[BluetoothDeviceRemote] =
  ## Returns all remote Bluetooth devices visible for the specified or default
  ## local Bluetooth radio device.
  result = @[]

  if device != nil:
    for item in localDeviceHandles():
      if item.info.address == device.fRadioInfo.address:
        for deviceInfo in remoteDeviceInfos(item.handle, UCHAR(duration),
                                            BOOL(flushCache)):
          result.add(BluetoothDeviceRemote(fDeviceInfo: deviceInfo))
  else:
    for deviceInfo in remoteDeviceInfos(0, UCHAR(duration), BOOL(flushCache)):
      result.add(BluetoothDeviceRemote(fDeviceInfo: deviceInfo))


proc address*(device: BluetoothDeviceLocal): string =
  ## Returns local Bluetooth device address as a string.
  $device.fRadioInfo.address


proc address*(device: BluetoothDeviceRemote): string =
  ## Returns remote Bluetooth device address as a string.
  $device.fDeviceInfo.Address


proc name*(device: BluetoothDeviceLocal): string =
  ## Returns local Bluetooth device name.
  var buf: array[BLUETOOTH_MAX_NAME_SIZE + 1, WCHAR]
  copyMem(addr(buf), addr(device.fRadioInfo.szName), BLUETOOTH_MAX_NAME_SIZE)
  return cast[WideCString](addr(buf)) $ BLUETOOTH_MAX_NAME_SIZE


proc name*(device: BluetoothDeviceRemote): string =
  ## Returns remote Bluetooth device name.
  var buf: array[BLUETOOTH_MAX_NAME_SIZE + 1, WCHAR]
  copyMem(addr(buf), addr(device.fDeviceInfo.szName), BLUETOOTH_MAX_NAME_SIZE)
  return cast[WideCString](addr(buf)) $ BLUETOOTH_MAX_NAME_SIZE


proc classOfDevice*(device: BluetoothDeviceLocal): uint32 =
  ## Returns class of local Bluetooth device.
  result = device.fRadioInfo.ulClassofDevice


proc classOfDevice*(device: BluetoothDeviceRemote): uint32 =
  ## Returns class of remote Bluetooth device.
  result = device.fDeviceInfo.ulClassofDevice
