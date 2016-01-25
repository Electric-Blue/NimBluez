# NimBluez

Modules for access to system [Bluetooth](https://www.bluetooth.com/) resources for the [Nim](http://nim-lang.org/) programming language.

Use [nimbluez.bluetooth](https://github.com/Electric-Blue/NimBluez/nimbluez/bluetooth.nim) module for cross-platform discovery and managing Bluetooth devices and services.

For cross-platform low-level sockets interface implementation for Bluetooth use
[nimbluez.bluetoothnativesockets](https://github.com/Electric-Blue/NimBluez/nimbluez/bluetoothnativesockets.nim).

You can find wrappers for [BlueZ](http://www.bluez.org/) in [nimbluez/bluez](https://github.com/Electric-Blue/NimBluez/nimbluez/bluez/) folder.
For [Microsoft Bluetooth](https://msdn.microsoft.com/en-us/library/windows/desktop/aa362761%28v=vs.85%29.aspx) protocol stack wrappers look at [nimbluez/msbt](https://github.com/Electric-Blue/NimBluez/nimbluez/msbt/).

## Installation
To install using [Nimble](https://github.com/nim-lang/nimble) run the following:
```
$ nimble install nimbluez
```

## Examples

.. code-block:: nim
  # Simple discovery example.  
  import nimbluez.bluetooth

  echo "All visible remote devices:"
  for remoteDevice in getRemoteDevices():
    echo remoteDevice.address, " - ", remoteDevice.name

.. code-block:: nim
  # Simple server example.
  # Attention! This code
  import nimbluez/bluetoothnativesockets

  var serverSocket = newBluetoothNativeSocket(SOCK_STREAM, BTPROTO_RFCOMM)
  discard serverSocket.bindAddr(RfcommPort(0))
  discard serverSocket.listen()
  var
    clientSocket: SocketHandle
    clientAddress: string
  clientSocket = serverSocket.acceptRfcommAddr(clientAddress)
  var
    message: string
  message = clientSocket.recv()
  echo message
  clientSocket.close()
  serverSocket.close()

.. code-block:: nim
  # Simple client example.
  import nimbluez/bluetoothnativesockets

  var clientSocket = newBluetoothNativeSocket(SOCK_STREAM, BTPROTO_RFCOMM)
  discard clientSocket.connect(RfcommPort(1), "00:02:72:0F:5C:87")
  discard clientSocket.send("Hi there!")
  clientSocket.close()

For more examples look at [examples]() folder.
