# Copyright (c) 2016, Maxim V. Abramov
# All rights reserved.
# Look at LICENSE for more info.

## Simple Bluetooth client implementation based on sockets and RFCOMM protocol.

import os
import ../nimbluez/bluetoothnativesockets

let
  serverPort = RfcommPort(15)
  serverAddress =
    "provide_your_server_address_string_here"
  #  "00:02:72:0F:5C:87"
  #  "AC:7B:A1:55:E6:4A"

var clientSocket = newBluetoothNativeSocket(SOCK_STREAM, BTPROTO_RFCOMM)
if clientSocket == InvalidSocket:
  raiseOSError(osLastError())
try:
  echo "Client socket created: ", repr(clientSocket)

  var name = getRfcommAddr(serverPort, serverAddress)
  if connect(clientSocket,
             cast[ptr SockAddr](addr(name)),
             sizeof(name).SockLen) < 0'i32:
    raiseOSError(osLastError())
  echo "Connection established."

  var message = "What time you got?"

  echo "Sending message:"
  echo "  ", message
  let sentLen = clientSocket.send(cstring(message), cint(message.len), cint(0))
  if sentLen < 0'i32:
    raiseOSError(osLastError())
  echo "Characters sent: ", sentLen

  echo "Receiving message:"
  message = ""
  message.setLen(1000)
  let recvLen = recv(clientSocket, cstring(message), cint(message.len), cint(0))
  if recvLen < 0'i32:
    raiseOSError(osLastError())
  message.setLen(recvLen)
  echo "  ", message
  echo "Characters received: ", recvLen
finally:
  clientSocket.close()
  echo "Client socket closed."
