# NimBluez

Modules for access to system [Bluetooth](https://www.bluetooth.com/) resources for the [Nim](http://nim-lang.org/) programming language.

Use `nimbluez/bluetooth` module for cross-platform discovery and managing Bluetooth devices and services.

For cross-platform low-level sockets interface implementation use `nimbluez/bluetoothnativesockets`.

You can find wrappers for [BlueZ](http://www.bluez.org/) in `nimbluez/bluez` folder.
For [Microsoft Bluetooth](https://msdn.microsoft.com/en-us/library/windows/desktop/aa362761%28v=vs.85%29.aspx) protocol stack wrappers look at `nimbluez/msbt`.

## Installation
To install using [Nimble](https://github.com/nim-lang/nimble) run the following:
```
$ nimble install nimbluez
```

### Linux
You may need to install `libbluetooth-dev`, if you see error `could not load: libbluetooth.so` on application start.
```
# for Ubuntu
 sudo apt install libbluetooth-dev
```

## Examples

```nim
# Simple discovery example.  
import nimbluez/bluetooth

echo "All visible remote devices:"
for remoteDevice in getRemoteDevices():
  echo remoteDevice.address, " - ", remoteDevice.name
```

```nim
# Simple server example.
# Attention! This code does not contain error handling.
import nimbluez/bluetoothnativesockets

var serverSocket = newBluetoothNativeSocket(SOCK_STREAM, BTPROTO_RFCOMM)
var name = getRfcommAddr(RfcommPort(1))
discard bindAddr(serverSocket,
                 cast[ptr SockAddr](addr(name)),
                 sizeof(name).SockLen)
discard serverSocket.listen()
var
  clientName = getRfcommAddr()
  clientNameLen = sizeof(clientName).SockLen
var clientSocket = accept(serverSocket,
                          cast[ptr SockAddr](addr(clientName)),
                          addr(clientNameLen))
var message: string = ""
message.setLen(1000)
let recvLen = clientSocket.recv(cstring(message), cint(message.len), cint(0))
message.setLen(recvLen)
echo message
clientSocket.close()
serverSocket.close()
```

```nim
# Simple client example.
# Attention! This code does not contain error handling.
import nimbluez/bluetoothnativesockets

var socket = newBluetoothNativeSocket(SOCK_STREAM, BTPROTO_RFCOMM)
var name = getRfcommAddr(RfcommPort(1), "00:02:72:0F:5C:87")
discard connect(socket, cast[ptr SockAddr](addr(name)), sizeof(name).SockLen)
var message = "Hi there!"
discard send(socket, cstring(message), cint(message.len), cint(0))
socket.close()
```
For more examples look at `examples` folder.
