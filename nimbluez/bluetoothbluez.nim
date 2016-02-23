# Copyright (c) 2016, Maxim V. Abramov
# All rights reserved.
# Look at LICENSE for more info.

## This module is used for discovery and managing Bluetooth devices and
## services. It is based on BlueZ Bluetooth protocol stack implementation for
## Linux.

import os
from strutils import strip
import bluez/bz_bluetooth, bluez/bz_hci, bluez/bz_hci_lib

export bdaddr_t, inquiry_info


type
  BluetoothDeviceLocalImpl* = object of RootObj ## Local Bluetooth device -
                                                ## radio adapter.
    fDevId*: cint

  BluetoothDeviceLocal* = ref BluetoothDeviceLocalImpl ## Local Bluetooth
                                                       ## device - raadio
                                                       ## adapter reference.

  BluetoothDeviceRemoteImpl* = object of RootObj ## Remote Bluetooth device.
    fInquiryInfo*: inquiry_info

  BluetoothDeviceRemote* = ref BluetoothDeviceRemoteImpl ## Remote Bluetooth
                                                         ## device reference.


proc `$`*(pBdaddr: bdaddr_t): string =
  ## Returns Bluetooth device address as a string.
  const addressLen = 17
  result = ""
  result.setLen(addressLen)
  var pBdaddr = pBdaddr
  let resultLen = ba2str(addr(pBdaddr), result)
  if resultLen < 0:
    raiseOSError(osLastError())
  result.setLen(resultLen)


proc parseBluetoothAddress*(str: string): bdaddr_t =
  ## Converts a string to a Bluetooth device address.
  let resultLen = str2ba(str, addr(result))
  if resultLen < 0:
    raiseOSError(osLastError())


proc getLocalDevice*(address: string): BluetoothDeviceLocal =
  ## Returns local Bluetooth radio device with a specified address.
  let devId = hci_devid(address)
  if devId < 0:
    raiseOSError(osLastError())
  return BluetoothDeviceLocal(fDevId: devId)


proc getLocalDevice*(): BluetoothDeviceLocal =
  ## Returns default local Bluetooth radio device.
  let devId = hci_get_route(nil)
  if devId < 0:
    raiseOSError(osLastError())
  return BluetoothDeviceLocal(fDevId: devId)


proc getLocalDevices*(): seq[BluetoothDeviceLocal] =
  ## Returns all local Blutooth radio devices.
  result = @[]

  proc devInfo(dd: cint; dev_id: cint; arg: clong): cint {.cdecl.} =
    let refdevs = cast[ptr seq[BluetoothDeviceLocal]](arg)
    refdevs[].add(BluetoothDeviceLocal(fDevId: dev_id))

  discard hci_for_each_dev(HCI_UP_FLAG, devInfo, cast[clong](addr(result)));


proc getRemoteDevice*(address: string): BluetoothDeviceRemote =
  ## Returns remote Bluetooth device with a specified address.
  new(result)
  if str2ba(address, addr(result.fInquiryInfo.bdaddr)) < 0:
    raiseOSError(osLastError())


proc getRemoteDevices*(device: BluetoothDeviceLocal; duration = 8;
                       flushCache = true): seq[BluetoothDeviceRemote] =
  ## Returns all remote Bluetooth devices visible for the specified local
  ## Bluetooth radio device.
  const maxInquiryInfos = 255
  var inquiryInfos: array[maxInquiryInfos, inquiry_info]
  var pInquiryInfo = addr(inquiryInfos[0])

  let flags = if flushCache: IREQ_CACHE_FLUSH else: 0

  let numInquiryInfos = hci_inquiry(cint(device.fDevId), cint(duration),
                                    cint(maxInquiryInfos), nil,
                                    addr(pInquiryInfo), clong(flags))
  if numInquiryInfos < 0:
    raiseOSError(osLastError())

  result = @[]

  for i in 0..(numInquiryInfos - 1):
    result.add(BluetoothDeviceRemote(fInquiryInfo: inquiryInfos[i]))


proc getRemoteDevices*(duration = 8;
                       flushCache = true): seq[BluetoothDeviceRemote] =
  ## Returns all remote Bluetooth devices visible for the default local
  ## Bluetooth radio device.
  return getLocalDevice().getRemoteDevices(duration, flushCache)


proc address*(device: BluetoothDeviceLocal): string =
  ## Returns local Bluetooth device address as a string.
  var bdaddr = bdaddr_t()
  if hci_devba(device.fDevId, addr(bdaddr)) < 0:
    raiseOSError(osLastError())
  return $bdaddr


proc address*(device: BluetoothDeviceRemote): string =
  ## Returns remote Bluetooth device address as a string.
  return $device.fInquiryInfo.bdaddr


proc name*(device: BluetoothDeviceLocal): string =
  ## Returns local Bluetooth device name.
  var socket = hci_open_dev(cint(device.fDevId))
  if socket < 0:
    raiseOSError(osLastError())
  try:
    result = ""
    result.setLen(BLUETOOTH_MAX_NAME_SIZE)
    if hci_read_local_name(socket, cint(len(result)), result, 0) < 0:
      raiseOSError(osLastError())
    result = result.strip(false, true, {'\0'})
  finally:
    if hci_close_dev(socket) < 0:
      raiseOSError(osLastError())


proc name*(device: BluetoothDeviceRemote,
           localDevice: BluetoothDeviceLocal = nil): string =
  ## Returns remote Bluetooth device name.
  var localDevice = localDevice
  if localDevice == nil:
    localDevice = getLocalDevice()

  var socket = hci_open_dev(localDevice.fDevId)
  if socket < 0:
    raiseOSError(osLastError())

  try:
    result = ""
    result.setLen(BLUETOOTH_MAX_NAME_SIZE)
    if hci_read_remote_name(socket, addr(device.fInquiryInfo.bdaddr),
                            cint(len(result)), result, 0) < 0:
      raiseOSError(osLastError())
    result = result.strip(false, true, {'\0'})
  finally:
    if hci_close_dev(socket) < 0:
      raiseOSError(osLastError())

proc classOfDevice*(device: BluetoothDeviceLocal): uint32 =
  ## Returns class of local Bluetooth device.
  var socket = hci_open_dev(cint(device.fDevId))
  if socket < 0:
    raiseOSError(osLastError())
  try:
    var c: array[3, uint8]
    if hci_read_class_of_dev(socket, addr(c[0]), 0) < 0:
      raiseOSError(osLastError())
    result = (c[2].uint32 shl 16) or (c[1].uint32 shl 8) or c[0]
  finally:
    if hci_close_dev(socket) < 0:
      raiseOSError(osLastError())


proc classOfDevice*(device: BluetoothDeviceRemote): uint32 =
  ## Returns class of remote Bluetooth device.
  let c = device.fInquiryInfo.dev_class
  result = (c[2].uint32 shl 16) or (c[1].uint32 shl 8) or c[0]
