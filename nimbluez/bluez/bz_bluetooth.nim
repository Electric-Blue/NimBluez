#
#
#   BlueZ - Bluetooth protocol stack for Linux
#
#   Copyright (C) 2000-2001  Qualcomm Incorporated
#   Copyright (C) 2002-2003  Maxim Krasnyansky <maxk@qualcomm.com>
#   Copyright (C) 2002-2010  Marcel Holtmann <marcel@holtmann.org>
#
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
#

{.deadCodeElim: on.}

import endians

const
  AF_BLUETOOTH* = 31
  PF_BLUETOOTH* = AF_BLUETOOTH

const
  BTPROTO_L2CAP* = 0
  BTPROTO_HCI* = 1
  BTPROTO_SCO* = 2
  BTPROTO_RFCOMM* = 3
  BTPROTO_BNEP* = 4
  BTPROTO_CMTP* = 5
  BTPROTO_HIDP* = 6
  BTPROTO_AVDTP* = 7
  SOL_HCI* = 0
  SOL_L2CAP* = 6
  SOL_SCO* = 17
  SOL_RFCOMM* = 18

const
  BT_SECURITY* = 4

const
  BLUETOOTH_MAX_NAME_SIZE* = (248)

type
  bt_security* = object
    level*: uint8
    key_size*: uint8


const
  BT_SECURITY_SDP* = 0
  BT_SECURITY_LOW* = 1
  BT_SECURITY_MEDIUM* = 2
  BT_SECURITY_HIGH* = 3
  BT_DEFER_SETUP* = 7
  BT_FLUSHABLE* = 8
  BT_FLUSHABLE_OFF* = 0
  BT_FLUSHABLE_ON* = 1
  BT_CHANNEL_POLICY* = 10

# BR/EDR only (default policy)
#    AMP controllers cannot be used.
#    Channel move requests from the remote device are denied.
#    If the L2CAP channel is currently using AMP, move the channel to BR/EDR.
#

const
  BT_CHANNEL_POLICY_BREDR_ONLY* = 0

# BR/EDR Preferred
#    Allow use of AMP controllers.
#    If the L2CAP channel is currently on AMP, move it to BR/EDR.
#    Channel move requests from the remote device are allowed.
#

const
  BT_CHANNEL_POLICY_BREDR_PREFERRED* = 1

# AMP Preferred
#    Allow use of AMP controllers
#    If the L2CAP channel is currently on BR/EDR and AMP controller
#      resources are available, initiate a channel move to AMP.
#    Channel move requests from the remote device are allowed.
#    If the L2CAP socket has not been connected yet, try to create
#      and configure the channel directly on an AMP controller rather
#      than BR/EDR.
#

const
  BT_CHANNEL_POLICY_AMP_PREFERRED* = 2

# Connection and socket states

const
  BT_CONNECTED* = 1           # Equal to TCP_ESTABLISHED to make net code happy
  BT_OPEN* = 2
  BT_BOUND* = 3
  BT_LISTEN* = 4
  BT_CONNECT* = 5
  BT_CONNECT2* = 6
  BT_CONFIG* = 7
  BT_DISCONN* = 8
  BT_CLOSED* = 9

# Byte order conversions

proc htobs*(d: uint16): uint16 =
  when cpuEndian == bigEndian:
    swapEndian16(result, d)
  else:
   result = d

proc htobl*(d: uint32): uint32 =
  when cpuEndian == bigEndian:
   swapEndian32(result, d)
  else:
   result = d

proc htobll*(d: uint64): uint64 =
  when cpuEndian == bigEndian:
    swapEndian64(result, d)
  else:
    result = d

template btohs*(d: untyped): untyped =
  htobs(d)

template btohl*(d: untyped): untyped =
  htobl(d)

template btohll*(d: untyped): untyped =
  htobll(d)

type
  uint128* = object
    data*: array[16, uint8]

proc btoh128*(src: ptr uint128; dst: ptr uint128) {.inline, cdecl.} =
  when cpuEndian == bigEndian:
    var i: cint
    for i in countup(0, 15):
      dst.data[15 - i] = src.data[i]
  else:
    copyMem(dst, src, sizeof((uint128)))

template htob128*(x, y: untyped): untyped =
  btoh128(x, y)

# Bluetooth unaligned access
##def bt_get_unaligned(ptr)			\
#({						\
# struct __attribute__((packed)) {	\
#  __typeof__(*(ptr)) __v;		\
# } *__p = (__typeof__(__p)) (ptr);	\
# __p->__v;				\
#})
#
##def bt_put_unaligned(val, ptr)		\
#do {						\
# struct __attribute__((packed)) {	\
#  __typeof__(*(ptr)) __v;		\
# } *__p = (__typeof__(__p)) (ptr);	\
# __p->__v = (val);			\
#} while(0)
#
##if __BYTE_ORDER == __LITTLE_ENDIAN
#static inline uint64_t bt_get_le64(const void *ptr)
#{
# return bt_get_unaligned((const uint64_t *) ptr);
#}
#
#static inline uint64_t bt_get_be64(const void *ptr)
#{
# return bswap_64(bt_get_unaligned((const uint64_t *) ptr));
#}
#
#static inline uint32_t bt_get_le32(const void *ptr)
#{
# return bt_get_unaligned((const uint32_t *) ptr);
#}
#
#static inline uint32_t bt_get_be32(const void *ptr)
#{
# return bswap_32(bt_get_unaligned((const uint32_t *) ptr));
#}
#
#static inline uint16_t bt_get_le16(const void *ptr)
#{
# return bt_get_unaligned((const uint16_t *) ptr);
#}
#
#static inline uint16_t bt_get_be16(const void *ptr)
#{
# return bswap_16(bt_get_unaligned((const uint16_t *) ptr));
#}
##elif __BYTE_ORDER == __BIG_ENDIAN
#static inline uint64_t bt_get_le64(const void *ptr)
#{
# return bswap_64(bt_get_unaligned((const uint64_t *) ptr));
#}
#
#static inline uint64_t bt_get_be64(const void *ptr)
#{
# return bt_get_unaligned((const uint64_t *) ptr);
#}
#
#static inline uint32_t bt_get_le32(const void *ptr)
#{
# return bswap_32(bt_get_unaligned((const uint32_t *) ptr));
#}
#
#static inline uint32_t bt_get_be32(const void *ptr)
#{
# return bt_get_unaligned((const uint32_t *) ptr);
#}
#
#static inline uint16_t bt_get_le16(const void *ptr)
#{
# return bswap_16(bt_get_unaligned((const uint16_t *) ptr));
#}
#
#static inline uint16_t bt_get_be16(const void *ptr)
#{
# return bt_get_unaligned((const uint16_t *) ptr);
#}
##else
##error "Unknown byte order"
##endif

# BD Address

type
  bdaddr_t* = object {.packed.}
    b*: array[6, uint8]


# BD Address type

const
  BDADDR_BREDR* = 0x00000000
  BDADDR_LE_PUBLIC* = 0x00000001
  BDADDR_LE_RANDOM* = 0x00000002

let
  BDADDR_ANY* = bdaddr_t(b: [0'u8, 0'u8, 0'u8, 0'u8, 0'u8, 0'u8])
  BDADDR_ALL* =  bdaddr_t(b: [0xff'u8, 0xff'u8, 0xff'u8, 0xff'u8, 0xff'u8, 0xff'u8])
  BDADDR_LOCAL* = bdaddr_t(b: [0'u8, 0'u8, 0'u8, 0xff'u8, 0xff'u8, 0xff'u8])

# Copy, swap, convert BD Address

proc bacmp*(ba1: ptr bdaddr_t; ba2: ptr bdaddr_t): cint {.inline, cdecl.} =
  return cint(equalMem(ba1, ba2, sizeof(bdaddr_t)))

proc bacpy*(dst: ptr bdaddr_t; src: ptr bdaddr_t) {.inline, cdecl.} =
  copyMem(dst, src, sizeof(bdaddr_t))

proc baswap*(dst: ptr bdaddr_t; src: ptr bdaddr_t) {.cdecl, importc: "baswap",
    dynlib: "libbluetooth.so".}
proc strtoba*(str: cstring): ptr bdaddr_t {.cdecl, importc: "strtoba",
    dynlib: "libbluetooth.so".}
proc batostr*(ba: ptr bdaddr_t): cstring {.cdecl, importc: "batostr",
    dynlib: "libbluetooth.so".}
proc ba2str*(ba: ptr bdaddr_t; str: cstring): cint {.cdecl, importc: "ba2str",
    dynlib: "libbluetooth.so".}
proc str2ba*(str: cstring; ba: ptr bdaddr_t): cint {.cdecl, importc: "str2ba",
    dynlib: "libbluetooth.so".}
proc ba2oui*(ba: ptr bdaddr_t; oui: cstring): cint {.cdecl, importc: "ba2oui",
    dynlib: "libbluetooth.so".}
proc bachk*(str: cstring): cint {.cdecl, importc: "bachk",
                                  dynlib: "libbluetooth.so".}
proc baprintf*(format: cstring): cint {.varargs, cdecl, importc: "baprintf",
                                        dynlib: "libbluetooth.so".}
proc bafprintf*(stream: ptr FILE; format: cstring): cint {.varargs, cdecl,
    importc: "bafprintf", dynlib: "libbluetooth.so".}
proc basprintf*(str: cstring; format: cstring): cint {.varargs, cdecl,
    importc: "basprintf", dynlib: "libbluetooth.so".}
proc basnprintf*(str: cstring; size: csize; format: cstring): cint {.varargs,
    cdecl, importc: "basnprintf", dynlib: "libbluetooth.so".}
proc bt_malloc*(size: csize): pointer {.cdecl, importc: "bt_malloc",
                                        dynlib: "libbluetooth.so".}
proc bt_free*(`ptr`: pointer) {.cdecl, importc: "bt_free",
                                dynlib: "libbluetooth.so".}
proc bt_error*(code: uint16): cint {.cdecl, importc: "bt_error",
                                     dynlib: "libbluetooth.so".}
proc bt_compidtostr*(id: cint): cstring {.cdecl, importc: "bt_compidtostr",
    dynlib: "libbluetooth.so".}
