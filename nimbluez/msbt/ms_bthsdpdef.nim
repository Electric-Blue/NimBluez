#
#    Copyright (C) Microsoft.  All rights reserved.
#

from winlean import GUID, HANDLE

export GUID, HANDLE

type
  WCHAR* = uint16
  LPWSTR* = ptr WCHAR
  LPCWSTR* = ptr WCHAR
  PWSTR* = LPWSTR
#   GUID* {.final, pure.} = object
#     D1*: int32
#     D2*: int16
#     D3*: int16
#     D4*: array [0..7, int8]
  BOOL* = int32
  CHAR* = char
  UCHAR* = uint8
  BYTE* = byte
  LONG* = int32
  ULONG* = uint32
  PULONG* = ptr ULONG
  DWORD* = uint32
  LPSTR* = cstring
  LPDWORD* = ptr DWORD
  ULONGLONG* = uint64
  LONGLONG* = int64
  USHORT* = uint16
  SHORT* = int16
#   HANDLE* = int32
  SYSTEMTIME* {.final, pure.} = object
    wYear*: int16
    wMonth*: int16
    wDayOfWeek*: int16
    wDay*: int16
    wHour*: int16
    wMinute*: int16
    wSecond*: int16
    wMilliseconds*: int16
  LPVOID* = pointer
  PVOID* = pointer
  HWND* = HANDLE
  LPBYTE* = ptr int8


type
  SDP_LARGE_INTEGER_16* = object
    LowPart*: ULONGLONG
    HighPart*: LONGLONG

  SDP_ULARGE_INTEGER_16* = object
    LowPart*: ULONGLONG
    HighPart*: ULONGLONG

  PSDP_ULARGE_INTEGER_16* = ptr SDP_ULARGE_INTEGER_16
  LPSDP_ULARGE_INTEGER_16* = ptr SDP_ULARGE_INTEGER_16
  PSDP_LARGE_INTEGER_16* = ptr SDP_LARGE_INTEGER_16
  LPSDP_LARGE_INTEGER_16* = ptr SDP_LARGE_INTEGER_16

  NodeContainerType* = enum
    NodeContainerTypeSequence, NodeContainerTypeAlternative

  SDP_ERROR* = USHORT
  PSDP_ERROR* = ptr USHORT

  SDP_TYPE* = enum
    SDP_TYPE_NIL = 0x00000000, SDP_TYPE_UINT = 0x00000001,
    SDP_TYPE_INT = 0x00000002, SDP_TYPE_UUID = 0x00000003,
    SDP_TYPE_STRING = 0x00000004, SDP_TYPE_BOOLEAN = 0x00000005,
    SDP_TYPE_SEQUENCE = 0x00000006, SDP_TYPE_ALTERNATIVE = 0x00000007,
    SDP_TYPE_URL = 0x00000008, SDP_TYPE_CONTAINER = 0x00000020
#  9 - 31 are reserved
# allow for a little easier type checking / sizing for integers and UUIDs
# ((SDP_ST_XXX & 0xF0) >> 4) == SDP_TYPE_XXX
# size of the data (in bytes) is encoded as ((SDP_ST_XXX & 0xF0) >> 8)

  SDP_SPECIFICTYPE* = enum
    SDP_ST_NONE = 0x00000000, SDP_ST_UINT8 = 0x00000010,
    SDP_ST_INT8 = 0x00000020, SDP_ST_UINT16 = 0x00000110,
    SDP_ST_INT16 = 0x00000120, SDP_ST_UUID16 = 0x00000130,
    SDP_ST_UINT32 = 0x00000210, SDP_ST_INT32 = 0x00000220,
    SDP_ST_UINT64 = 0x00000310, SDP_ST_INT64 = 0x00000320,
    SDP_ST_UINT128 = 0x00000410, SDP_ST_INT128 = 0x00000420,
    SDP_ST_UUID128 = 0x00000430
const
  SDP_ST_UUID32* = SDP_ST_INT32
type
  SdpAttributeRange* = object
    minAttribute*: USHORT
    maxAttribute*: USHORT

  SdpQueryUuidUnion* {.union.} = object
    uuid128*: GUID
    uuid32*: ULONG
    uuid16*: USHORT

  SdpQueryUuid* = object
    u*: SdpQueryUuidUnion
    uuidType*: USHORT
