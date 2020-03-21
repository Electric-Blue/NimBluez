# Copyright (c) 2016, Maxim V. Abramov
# All rights reserved.
# Look at LICENSE for more info.

## This module implements a low-level cross-platform sockets interface for
## Bluetooth.

import os, nativesockets
from endians import swapEndian16, swapEndian32, swapEndian64

const useWinVersion = defined(Windows) or defined(nimdoc)

when useWinVersion:
  import winlean
  import msbt/ms_bluetoothapis, msbt/ms_ws2bth
  import bluetoothmsbt
else:
  from posix import InvalidSocket, getsockname, getpeername
  import bluez/bz_rfcomm, bluez/bz_l2cap
  from bluez/bz_bluetooth import SOL_L2CAP, SOL_RFCOMM
  import bluetoothbluez

export SocketHandle, SockAddr, SockLen, SockType, Port
export
 connect, close, listen, accept, send, recv, sendto, recvfrom, `==`, bindAddr,
 getSockOptInt, setSockOptInt
export InvalidSocket
export
 SOL_L2CAP, SOL_RFCOMM,
 SO_ERROR,
 SOMAXCONN,
 SO_ACCEPTCONN, SO_BROADCAST, SO_DEBUG, SO_DONTROUTE,
 SO_KEEPALIVE, SO_OOBINLINE, SO_REUSEADDR
 #MSG_PEEK


type
  ProtocolFamily* = enum  ## Protocol family of the socket.
    PF_BLUETOOTH = 31     ## for Bluetooth socket.

  BluetoothDomain* = enum ## Address family of the socket. This extends Domain
                          ## form the nativesockets.
    AF_BLUETOOTH = 31     ## for Bluetooth socket.

  BluetoothProtocol* = enum ## third argument to `socket` proc
    BTPROTO_L2CAP = 0,      ## Logical link control and adaptation protocol.
                            ## Unsupported on Windows.
    BTPROTO_RFCOMM = 3      ## Radio frequency communication.

  RfcommPort* = 0..30 ## RFCOMM channel. The valid range for requesting
                      ## a specific RFCOMM port is 1 through 30 or 0 for
                      ## automatic assign.

  L2capPort* = 0..32767 ## L2CAP port (Protocol Service Multiplexer) can take
                        ## on odd-numbered values between 1 and 32767. Reserved
                        ## (well known) port numbers are between 1 and 4095.


when useWinVersion:
  type
    RfcommAddr* = SOCKADDR_BTH
    L2capAddr* = object
else:
  type
    RfcommAddr* = sockaddr_rc
    L2capAddr* = sockaddr_l2


type
  RfcommAddrRef* = ref RfcommAddr
  L2capAddrRef* = ref L2capAddr



when useWinVersion:
  const
    nativePfBluetooth* = ms_ws2bth.PF_BTH
    nativeAfBluetooth* = ms_ws2bth.AF_BTH
    WSAEPROTONOSUPPORT = OSErrorCode(10043)
else:
  const
    nativePfBluetooth* = bz_bluetooth.PF_BLUETOOTH
    nativeAfBluetooth* = bz_bluetooth.AF_BLUETOOTH


proc toInt*(family: ProtocolFamily): cint
  ## Converts the ProtocolFamily enum to a platform-dependent ``cint``.


proc toInt*(domain: BluetoothDomain): cint
  ## Converts the BluetoothDomain enum to a platform-dependent ``cint``.


proc toInt*(protocol: BluetoothProtocol): cint
  ## Converts the BluetoothProtocol enum to a platform-dependent ``cint``.


when useWinVersion:
  proc toInt*(family: ProtocolFamily): cint =
    case family
    of PF_BLUETOOTH: result = cint(ms_ws2bth.PF_BTH)

  proc toInt*(domain: BluetoothDomain): cint =
    case domain
    of AF_BLUETOOTH: result = cint(ms_ws2bth.AF_BTH)


  proc toInt*(protocol: BluetoothProtocol): cint =
    case protocol
    of BTPROTO_L2CAP: result = cint(ms_ws2bth.BTHPROTO_L2CAP)
    of BTPROTO_RFCOMM: result = cint(ms_ws2bth.BTHPROTO_RFCOMM)

else:
  proc toInt*(family: ProtocolFamily): cint =
    case family
    of PF_BLUETOOTH: result = cint(bz_bluetooth.PF_BLUETOOTH)


  proc toInt*(domain: BluetoothDomain): cint =
    case domain
    of AF_BLUETOOTH: result = cint(bz_bluetooth.AF_BLUETOOTH)


  proc toInt*(protocol: BluetoothProtocol): cint =
    case protocol
    of BTPROTO_L2CAP: result = cint(bz_bluetooth.BTPROTO_L2CAP)
    of BTPROTO_RFCOMM: result = cint(bz_bluetooth.BTPROTO_RFCOMM)


proc htob*(d: SomeInteger): auto =
  ## Converts integers from host to Bluetooth (little endian) byte order.
  ## On machines where the host byte order is the same as Bluetooth byte order,
  ## this is a no-op; otherwise, it performs a byte swap operation.
  result = d
  when cpuEndian == bigEndian:
    var d = d
    case sizeof(d)
    of 1:
      discard
    of 2:
      swapEndian16(addr(result), addr(d))
    of 4:
      swapEndian32(addr(result), addr(d))
    of 8:
      swapEndian64(addr(result), addr(d))
    else:
      raise newException(ValueError, "Invalid value size.")


template btoh*(d: untyped): untyped =
  ## Converts integers from Bluetooth (little endian) to host byte order.
  ## On machines where the host byte order is the same as Bluetooth byte order,
  ## this is a no-op; otherwise, it performs a byte swap operation.
  htob(d)


proc htobs*(d: uint16|int16): auto =
  ## Converts 16-bit integers from host to Bluetooth byte order.
  ## On machines where the host byte order is the same as Bluetooth byte order,
  ## this is a no-op; otherwise, it performs a 2-byte swap operation.
  htob(d)


proc htobl*(d: uint32|int32): auto =
  ## Converts 32-bit integers from host to Bluetooth byte order.
  ## On machines where the host byte order is the same as Bluetooth byte order,
  ## this is a no-op; otherwise, it performs a 4-byte swap operation.
  htob(d)


proc htobll*(d: uint64|int64): auto =
  ## Converts 64-bit integers from host to Bluetooth byte order.
  ## On machines where the host byte order is the same as Bluetooth byte order,
  ## this is a no-op; otherwise, it performs a 8-byte swap operation.
  htob(d)


template btohs*(d: untyped): untyped =
  ## Converts 16-bit integers from Bluetooth to host byte order.
  ## On machines where the host byte order is the same as Bluetooth byte order,
  ## this is a no-op; otherwise, it performs a 2-byte swap operation.
  htobs(d)


template btohl*(d: untyped): untyped =
  ## Converts 32-bit integers from Bluetooth to host byte order.
  ## On machines where the host byte order is the same as Bluetooth byte order,
  ## this is a no-op; otherwise, it performs a 4-byte swap operation.
  htobl(d)


template btohll*(d: untyped): untyped =
  ## Converts 64-bit integers from Bluetooth to host byte order.
  ## On machines where the host byte order is the same as Bluetooth byte order,
  ## this is a no-op; otherwise, it performs a 8-byte swap operation.
  htobll(d)


when not useWinVersion:
  proc htobBdaddr*(d: bdaddr_t): bdaddr_t =
    ## Converts bdaddr_t from host toBluetooth byte order.
    ## On machines where the host byte order is the same as Bluetooth,
    ## this is a no-op; otherwise, it performs a 6-byte swap operation.
    when cpuEndian == bigEndian:
      for i in countup(0, 5):
        result[5 - i] = d[i]
    else:
      result = d

  template btohBdaddr*(d: untyped): untyped =
    ## Converts bdaddr_t from Bluetooth to host byte order.
    ## On machines where the host byte order is the same as Bluetooth,
    ## this is a no-op; otherwise, it performs a 6-byte swap operation.
    htobBdaddr(d)


proc newBluetoothNativeSocket*(sockType: SockType = SOCK_STREAM,
                               protocol: BluetoothProtocol = BTPROTO_RFCOMM):
                                 SocketHandle =
  ## Creates a new Bluetooth socket; returns `InvalidSocket` if an error occurs.
  result =
    newNativeSocket(toInt(ProtocolFamily.PF_BLUETOOTH),
                    toInt(sockType),
                    toInt(protocol))


proc getRfcommAddr*(port = RfcommPort(0), address = ""): RfcommAddr
  ## Creates and fills Bluetooth address structure for RFCOMM protocol.


proc getL2capAddr*(port = L2capPort(0), address = ""): L2capAddr
  ## Creates and fills Bluetooth address structure for L2CAP protocol.


proc getRfcommLocalName*(socket: SocketHandle): RfcommAddr
  ## Returns the RFCOMM socket's associated port number.


proc getL2capLocalName*(socket: SocketHandle): L2capAddr
  ## Returns the L2CAP socket's associated port number.


proc getRfcommPeerName*(socket: SocketHandle): RfcommAddr
  ## Returns the RFCOMM socket's associated port number.


proc getL2capPeerName*(socket: SocketHandle): L2capAddr
  ## Returns the L2CAP socket's associated port number.


proc getAddrString*(sockAddr: RfcommAddr): string
  ## Returns the string representation of a Bluetooth address.


proc getAddrString*(sockAddr: L2capAddr): string
  ## Returns the string representation of a Bluetooth address.


proc getAddrPort*(sockAddr: RfcommAddr): RfcommPort
  ## Returns port of a Bluetooth address.


proc getAddrPort*(sockAddr: L2capAddr): L2capPort
  ## Returns port of a Bluetooth address.


when useWinVersion:
  proc getRfcommAddr*(port = RfcommPort(0), address = ""): RfcommAddr =
    result.addressFamily = htobs(
      toInt(BluetoothDomain.AF_BLUETOOTH).uint16)
    if address != "":
      result.btAddr = htobll(
        parseBluetoothAddress(address).ano_116103095.ullLong)
    #result.serviceClassId =
    result.port = htobl(if port == 0: 0xFFFFFFFF'u32 else: port.uint32)


  proc getL2capAddr*(port = L2capPort(0), address = ""): L2capAddr =
    raiseOSError(WSAEPROTONOSUPPORT)


  proc getRfcommLocalName*(socket: SocketHandle): RfcommAddr =
    var name = getRfcommAddr()
    var nameLen = sizeof(name).SockLen
    if getsockname(socket,
                   cast[ptr SockAddr](addr(name)),
                   addr(nameLen)) == -1'i32:
      raiseOSError(osLastError())
    result = name


  proc getL2capLocalName*(socket: SocketHandle): L2capAddr =
    raiseOSError(WSAEPROTONOSUPPORT)


  proc getRfcommPeerName*(socket: SocketHandle): RfcommAddr =
    var name = getRfcommAddr()
    var nameLen = sizeof(name).SockLen
    if getpeername(socket,
                   cast[ptr SockAddr](addr(name)),
                   addr(nameLen)) == -1'i32:
      raiseOSError(osLastError())
    result = name


  proc getL2capPeerName*(socket: SocketHandle): L2capAddr =
    raiseOSError(WSAEPROTONOSUPPORT)


  proc getAddrString*(sockAddr: RfcommAddr): string =
    result = $cast[BLUETOOTH_ADDRESS](btohll(sockAddr.btAddr.int64))


  proc getAddrString*(sockAddr: L2capAddr): string =
    raiseOSError(WSAEPROTONOSUPPORT)


  proc getAddrPort*(sockAddr: RfcommAddr): RfcommPort =
    result = btohl(sockAddr.port)


  proc getAddrPort*(sockAddr: L2capAddr): L2capPort =
    raiseOSError(WSAEPROTONOSUPPORT)


else:
  proc getRfcommAddr*(port = RfcommPort(0), address = ""): RfcommAddr =
    result.rc_family = htobs(toInt(BluetoothDomain.AF_BLUETOOTH).uint16)
    if address != "":
      result.rc_bdaddr = htobBdaddr(parseBluetoothAddress(address))
    if port != RfcommPort(0):
      result.rc_channel = uint8(port)


  proc getL2capAddr*(port = L2capPort(0), address = ""): L2capAddr =
    result.l2_family = htobs(toInt(BluetoothDomain.AF_BLUETOOTH).uint16)
    if address != "":
      result.l2_bdaddr = htobBdaddr(parseBluetoothAddress(address))
    if port != L2capPort(0):
      result.l2_psm = htobs(cushort(port))


  proc getRfcommLocalName*(socket: SocketHandle): RfcommAddr =
    var name = getRfcommAddr()
    var nameLen = sizeof(name).SockLen
    if getsockname(socket,
                   cast[ptr SockAddr](addr(name)),
                   addr(namelen)) == -1'i32:
      raiseOSError(osLastError())
    result = name


  proc getL2capLocalName*(socket: SocketHandle): L2capAddr =
    var name = getL2capAddr()
    var nameLen = sizeof(name).SockLen
    if getsockname(socket,
                   cast[ptr SockAddr](addr(name)),
                   addr(nameLen)) == -1'i32:
      raiseOSError(osLastError())
    result = name


  proc getRfcommPeerName*(socket: SocketHandle): RfcommAddr =
    var name = getRfcommAddr()
    var nameLen = sizeof(name).SockLen
    if getpeername(socket,
                   cast[ptr SockAddr](addr(name)),
                   addr(nameLen)) == -1'i32:
      raiseOSError(osLastError())
    result = name


  proc getL2capPeerName*(socket: SocketHandle): L2capAddr =
    var name = getL2capAddr()
    var nameLen = sizeof(name).SockLen
    if getpeername(socket,
                   cast[ptr SockAddr](addr(name)),
                   addr(nameLen)) == -1'i32:
      raiseOSError(osLastError())
    result = name


  proc getAddrString*(sockAddr: RfcommAddr): string =
    result = $btohBdaddr(sockAddr.rc_bdaddr)


  proc getAddrString*(sockAddr: L2capAddr): string =
    result = $btohBdaddr(sockAddr.l2_bdaddr)


  proc getAddrPort*(sockAddr: RfcommAddr): RfcommPort =
    result = sockAddr.rc_channel


  proc getAddrPort*(sockAddr: L2capAddr): L2capPort =
    result = btohs(sockAddr.l2_psm)


proc getRfcommSockName*(socket: SocketHandle): RfcommPort =
  ## Returns the RFCOMM socket's associated port number.
  var name = getRfcommLocalName(socket)
  result = getAddrPort(name)


proc getL2capSockName*(socket: SocketHandle): L2capPort =
  ## Returns the L2CAP socket's associated port number.
  var name = getL2capLocalName(socket)
  result = getAddrPort(name)


proc getRfcommLocalAddr*(socket: SocketHandle): (string, RfcommPort) =
  ## Returns the socket's local address and port number.
  ##
  ## Similar to POSIX's `getsockname`:idx:.
  var name = getRfcommLocalName(socket)
  result = (getAddrString(name), getAddrPort(name))


proc getL2capLocalAddr*(socket: SocketHandle): (string, L2capPort) =
  ## Returns the socket's local address and port number.
  ##
  ## Similar to POSIX's `getsockname`:idx:.
  var name = getL2capLocalName(socket)
  result = (getAddrString(name), getAddrPort(name))


proc getRfcommPeerAddr*(socket: SocketHandle): (string, RfcommPort) =
  ## Returns the socket's peer address and port number.
  ##
  ## Similar to POSIX's `getpeername`:idx:
  var name = getRfcommAddr()
  var nameLen = sizeof(name).SockLen
  if getpeername(socket,
                 cast[ptr SockAddr](addr(name)),
                 addr(namelen)) == -1'i32:
    raiseOSError(osLastError())
  result = (getAddrString(name), getAddrPort(name))


proc getL2capPeerAddr*(socket: SocketHandle): (string, L2capPort) =
  ## Returns the socket's peer address and port number.
  ##
  ## Similar to POSIX's `getpeername`:idx:
  var name = getL2capAddr()
  var nameLen = sizeof(name).SockLen
  if getpeername(socket,
                 cast[ptr SockAddr](addr(name)),
                 addr(namelen)) == -1'i32:
    raiseOSError(osLastError())
  result = (getAddrString(name), getAddrPort(name))
