# Copyright (c) 2016, Maxim V. Abramov
# All rights reserved.
# Look at LICENSE for more info.

## This module implements a high-level cross-platform sockets interface for
## Bluetooth.
## This module is just a draft yet.

import os
import bluetoothnativesockets

proc bindAddr*(socket: SocketHandle, port = RfcommPort(0), address = ""): cint =
  ## Binds a Bluetooth RFCOMM socket.
  var name = getRfcommAddr(port, address)
  result = bindAddr(socket,
                    cast[ptr SockAddr](addr(name)),
                    sizeof(name).SockLen)


proc bindAddr*(socket: SocketHandle, port: L2capPort, address = ""): cint =
  ## Binds a Bluetooth L2CAP socket.
  var name = getL2capAddr(port, address)
  result = bindAddr(socket,
                    cast[ptr SockAddr](addr(name)),
                    sizeof(name).SockLen)


proc acceptRfcommAddr*(server: SocketHandle,
                       address: var string): SocketHandle =
  ## Enables incoming connection attempts on a Bluetooth RFCOMM socket.
  var sockAddr = getRfcommAddr()
  var addrLen = sizeof(sockAddr).SockLen
  result = accept(server, cast[ptr SockAddr](addr(sockAddr)), addr(addrLen))
  address = getAddrString(sockAddr)


proc acceptL2capAddr*(server: SocketHandle, address: var string): SocketHandle =
  ## Enables incoming connection attempts on a Bluetooth L2CAP socket.
  var sockAddr = getL2capAddr()
  var addrLen = sizeof(sockAddr).SockLen
  result = accept(server, cast[ptr SockAddr](addr(sockAddr)), addr(addrLen))
  address = getAddrString(sockAddr)


proc connect*(socket: SocketHandle, port: RfcommPort, address: string): cint =
  ## Connects to a target Bluetooth device, using a previously created Bluetooth RFCOMM socket.
  var name = getRfcommAddr(port, address)
  result = connect(socket, cast[ptr SockAddr](addr(name)), sizeof(name).SockLen)


proc connect*(socket: SocketHandle, port: L2capPort, address: string): cint =
  ## Connects to a target Bluetooth device, using a previously created Bluetooth L2CAP socket.
  var name = getL2capAddr(port, address)
  result = connect(socket, cast[ptr SockAddr](addr(name)), sizeof(name).SockLen)


proc send*(socket: SocketHandle, message: string): cint =
  ## Sends data on a connected socket.
  result = send(socket, cstring(message), cint(message.len), cint(0)).cint


proc recv*(socket: SocketHandle): string =
  ## Receives data from a connected socket.
  result = ""
  result.setLen(1000)
  let recvLen = recv(socket, cstring(result), cint(result.len), cint(0))
  if recvLen < 0'i32:
    raiseOSError(osLastError())
  result.setLen(recvLen)
