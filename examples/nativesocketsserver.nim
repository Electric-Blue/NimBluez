# Copyright (c) 2016, Maxim V. Abramov
# All rights reserved.
# Look at LICENSE for more info.

## Simple Bluetooth server implementation based on sockets and RFCOMM protocol.

import os
import ../nimbluez/bluetoothnativesockets

var
  serverPort = RfcommPort(15)
  serverAddress =
    ""
  #  "00:02:72:0F:5C:87"
  #  "AC:7B:A1:55:E6:4A"

var serverSocket = newBluetoothNativeSocket(SOCK_STREAM, BTPROTO_RFCOMM)
if serverSocket == InvalidSocket:
  raiseOSError(osLastError())
try:
  var name = getRfcommAddr(serverPort, serverAddress)
  if bindAddr(serverSocket,
              cast[ptr SockAddr](addr(name)),
              sizeof(name).SockLen) < 0'i32:
      raiseOSError(osLastError())
  if serverSocket.listen() < 0'i32:
    raiseOSError(osLastError())
  echo "Server socket created: ", repr(serverSocket)
  (serverAddress, serverPort) = serverSocket.getRfcommLocalAddr()
  echo "Address: ", serverAddress, ", port: ", serverPort

  while true:
    echo "Waiting for incoming connections..."
    var
      sockAddr = getRfcommAddr()
      addrLen = sizeof(sockAddr).SockLen
    var clientSocket = accept(serverSocket,
                              cast[ptr SockAddr](addr(sockAddr)),
                              addr(addrLen))
    if clientSocket == InvalidSocket:
      raiseOSError(osLastError())
    try:
      var
        clientAddress: string
        clientPort: RfcommPort
      (clientAddress, clientPort) = clientSocket.getRfcommPeerAddr()
      echo "Connection from ", clientAddress, " on port: ", clientPort
      echo "Client socket: ", repr(clientSocket)

      var message = ""
      message.setLen(1000)
      while true:
        echo "Receiving message:"
        let recvLen = clientSocket.recv(cstring(message),
                                        cint(message.len),
                                        cint(0))
        if recvLen < 0'i32:
          message.setLen(0)
          echo osErrorMsg(osLastError())
          break
        message.setLen(recvLen)
        if recvLen == 0'i32:
          break
        echo "  ", message
        echo "Characters received: ", recvLen

        message = "Seven twenty-two in the A.M."
        echo "Sending message:"
        echo "  ", message
        let sentLen = clientSocket.send(cstring(message),
                                        cint(message.len),
                                        cint(0))
        if sentLen < 0'i32:
          raiseOSError(osLastError())
        echo "Characters sent: ", sentLen
    finally:
      clientSocket.close()
      echo "Client socket closed."
finally:
  serverSocket.close()
  echo "Server socket closed."
