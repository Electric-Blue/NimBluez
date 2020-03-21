#++
#
#Copyright (c) 2000  Microsoft Corporation
#
#Module Name:
#
#        ws2bth.h
#
#Abstract:
#
#        Winsock 2 Bluetooth Annex definitions.
#
#Notes:
#
#        Change BT_* to BTH_*
#
#--
{.passC: "-mno-ms-bitfields".}

import ms_bthdef, ms_bthsdpdef, ms_bluetoothapis

const
  AF_BTH* = 32
  PF_BTH* = AF_BTH

  IOC_UNIX* = 0x00000000
  IOC_WS2* = 0x08000000
  IOC_PROTOCOL* = 0x10000000
  IOC_VENDOR* = 0x18000000

  IOCPARM_MASK* = 0x0000007F
  IOC_VOID* = 0x20000000
  IOC_OUT* = 0x40000000
  IOC_IN* = 0x80000000
  IOC_INOUT* = (IOC_IN or IOC_OUT)

template WSAIO*(x, y: untyped): untyped =
  (IOC_VOID or (x) or (y))

template WSAIOR*(x, y: untyped): untyped =
  (IOC_OUT or (x) or (y))

template WSAIOW*(x, y: untyped): untyped =
  (IOC_IN or (x) or (y))

template WSAIORW*(x, y: untyped): untyped =
  (IOC_INOUT or (x) or (y))

const
  BT_PORT_ANY* = 0xFFFFFFFF
  BT_PORT_MIN* = 0x00000001
  BT_PORT_MAX* = 0x0000FFFF
  BT_PORT_DYN_FIRST* = 0x00001001
#
# These three definitions are duplicated in winsock2.h to reserve ordinals
#
type
  SOCKADDR_BTH* {.packed.} = object
    addressFamily*: USHORT # Always AF_BTH
    btAddr*: BTH_ADDR     # Bluetooth device address
    serviceClassId*: GUID # [OPTIONAL] system will query SDP for port
    port*: ULONG          # RFCOMM channel or L2CAP PSM

  PSOCKADDR_BTH* = ptr SOCKADDR_BTH

DEFINE_GUID(SVCID_BTH_PROVIDER, 0x06AA63E0, 0x00007D60, 0x000041FF,
            0x000000AF, 0x000000B2, 0x0000003E, 0x000000E6, 0x000000D2,
            0x000000D9, 0x00000039, 0x0000002D)
const
  BTH_ADDR_STRING_SIZE* = 12
#
# Bluetooth protocol #s are assigned according to the Bluetooth
# Assigned Numbers portion of the Bluetooth Specification
#
const
  BTHPROTO_RFCOMM* = 0x00000003
  BTHPROTO_L2CAP* = 0x00000100

  SOL_RFCOMM* = BTHPROTO_RFCOMM
  SOL_L2CAP* = BTHPROTO_L2CAP
  SOL_SDP* = 0x00000101
#
# SOCKET OPTIONS
#
const
  SO_BTH_AUTHENTICATE* = 0x80000001
  SO_BTH_ENCRYPT* = 0x00000002
  SO_BTH_MTU* = 0x80000007
  SO_BTH_MTU_MAX* = 0x80000008
  SO_BTH_MTU_MIN* = 0x8000000A
#
# Socket option parameters
#
# 3-DH5 => payload of 1021 => L2cap payload of 1017 => RFComm payload of 1011
const
  RFCOMM_MAX_MTU* = 0x000003F3
  RFCOMM_MIN_MTU* = 0x00000017
#
# NAME SERVICE PROVIDER DEFINITIONS
# For calling WSASetService
# and WSALookupServiceBegin, WSALookupServiceNext, WSALookupServiceEnd
# with Bluetooth-specific extensions
#
const
  BTH_SDP_VERSION* = 1
#
# [OPTIONAL] passed in BLOB member of WSAQUERYSET
# QUERYSET and its lpBlob member are copied & converted
# to unicode in the system for non-unicode applications.
# However, nothing is copied back upon return.  In
# order for the system to return data such as pRecordHandle,
# it much have an extra level of indirection from lpBlob
#
type
  BTH_SET_SERVICE* = object
    pSdpVersion*: PULONG #
                         # This version number will change when/if the binary format of
                         # SDP records change, affecting the format of pRecord.
                         # Set to BTH_SDP_VERSION by client, and returned by system
                         #
    #
    # Handle to SDP record.  When BTH_SET_SERVICE structure is later
    # passed to WSASetService RNRSERVICE_DELETE, this handle identifies the
    # record to delete.
    #
    pRecordHandle*: ptr HANDLE #
                               # COD_SERVICE_* bit(s) associated with this SDP record, which will be
                               # advertised when the local radio is found during device inquiry.
                               # When the last SDP record associated with a bit is deleted, that
                               # service bit is no longer reported in repsonse to inquiries
                               #
    fCodService*: ULONG   # COD_SERVICE_* bits
    Reserved*: array[5, ULONG] # Reserved by system.  Must be zero.
    ulRecordLength*: ULONG # length of pRecord which follows
    pRecord*: array[1, UCHAR] # SDP record as defined by bluetooth spec

  PBTH_SET_SERVICE* = ptr BTH_SET_SERVICE
#
# Default device inquiry duration in seconds
#
# The application thread will be blocked in WSALookupServiceBegin
# for the duration of the device inquiry, so this value needs to
# be balanced against the chance that a device that is actually
# present might not being found by Bluetooth in this time
#
# Paging improvements post-1.1 will cause devices to be
# found generally uniformly in the 0-6 sec timeperiod
#
const
  SDP_DEFAULT_INQUIRY_SECONDS* = 6
  SDP_MAX_INQUIRY_SECONDS* = 60
#
# Default maximum number of devices to search for
#
const
  SDP_DEFAULT_INQUIRY_MAX_RESPONSES* = 255
  SDP_SERVICE_SEARCH_REQUEST* = 1
  SDP_SERVICE_ATTRIBUTE_REQUEST* = 2
  SDP_SERVICE_SEARCH_ATTRIBUTE_REQUEST* = 3
#
# [OPTIONAL] input restrictions on device inquiry
# Passed in BLOB of LUP_CONTAINERS (device) search
#
type
  BTH_QUERY_DEVICE* = object
    LAP*: ULONG           # reserved: must be 0 (GIAC inquiry only)
    length*: UCHAR        # requested length of inquiry (seconds)

  PBTH_QUERY_DEVICE* = ptr BTH_QUERY_DEVICE
#
# [OPTIONAL] Restrictions on searching for a particular service
# Passed in BLOB of !LUP_CONTAINERS (service) search
#
type
  BTH_QUERY_SERVICE* = object
    `type`*: ULONG        # one of SDP_SERVICE_*
    serviceHandle*: ULONG
    uuids*: array[MAX_UUIDS_IN_QUERY, SdpQueryUuid]
    numRange*: ULONG
    pRange*: array[1, SdpAttributeRange]

  PBTH_QUERY_SERVICE* = ptr BTH_QUERY_SERVICE
#
# BTHNS_RESULT_*
#
# Bluetooth specific flags returned from WSALookupServiceNext
# in WSAQUERYSET.dwOutputFlags in response to device inquiry
#
#
# Local device is paired with remote device
#
const
  BTHNS_RESULT_DEVICE_CONNECTED* = 0x00010000
  BTHNS_RESULT_DEVICE_REMEMBERED* = 0x00020000
  BTHNS_RESULT_DEVICE_AUTHENTICATED* = 0x00040000
#
# SOCKET IOCTLs
#
const
  SIO_RFCOMM_SEND_COMMAND* = WSAIORW(IOC_VENDOR, 101)
  SIO_RFCOMM_WAIT_COMMAND* = WSAIORW(IOC_VENDOR, 102)
#
# These IOCTLs are for test/validation/conformance and may only be
# present in debug/checked builds of the system
#
const
  SIO_BTH_PING* = WSAIORW(IOC_VENDOR, 8)
  SIO_BTH_INFO* = WSAIORW(IOC_VENDOR, 9)
  SIO_RFCOMM_SESSION_FLOW_OFF* = WSAIORW(IOC_VENDOR, 103)
  SIO_RFCOMM_TEST* = WSAIORW(IOC_VENDOR, 104)
  SIO_RFCOMM_USECFC* = WSAIORW(IOC_VENDOR, 105)
#      RESERVED                          _WSAIORW (IOC_VENDOR, 106)
#
# SOCKET IOCTL DEFINITIONS
#
when not defined(BIT):
  template BIT*(b: untyped): untyped =
    (1 shl (b))

#
# Structure definition from Bluetooth RFCOMM spec, TS 07.10 5.4.6.3.7
#
# Signals field values
const
#  MSC_EA_BIT* = EA_BIT
  MSC_FC_BIT* = BIT(1)    # Flow control, clear if we can receive
  MSC_RTC_BIT* = BIT(2)   # Ready to communicate, set when ready
  MSC_RTR_BIT* = BIT(3)   # Ready to receive, set when ready
  MSC_RESERVED* = (BIT(4) or BIT(5)) # Reserved by spec, must be 0
  MSC_IC_BIT* = BIT(6)    # Incoming call
  MSC_DV_BIT* = BIT(7)    # Data valid
                          # Break field values
  MSC_BREAK_BIT* = BIT(1) # Set if sending break
template MSC_SET_BREAK_LENGTH*(b, l: untyped): untyped =
  ((b) = ((b) and 0x00000003) or (((l) and 0x0000000F) shl 4))

type
  RFCOMM_MSC_DATA* = object
    Signals*: UCHAR
    Break*: UCHAR

  PRFCOMM_MSC_DATA* = ptr RFCOMM_MSC_DATA
#
# Structure definition from Bluetooth RFCOMM spec, TS 07.10 5.4.6.3.10
#
const
  RLS_ERROR* = 0x00000001
  RLS_OVERRUN* = 0x00000002
  RLS_PARITY* = 0x00000004
  RLS_FRAMING* = 0x00000008
type
  RFCOMM_RLS_DATA* = object
    LineStatus*: UCHAR

  PRFCOMM_RLS_DATA* = ptr RFCOMM_RLS_DATA
#
# Structure definition from Bluetooth RFCOMM spec, TS 07.10 5.4.6.3.9
#
const
  RPN_BAUD_2400* = 0
  RPN_BAUD_4800* = 1
  RPN_BAUD_7200* = 2
  RPN_BAUD_9600* = 3
  RPN_BAUD_19200* = 4
  RPN_BAUD_38400* = 5
  RPN_BAUD_57600* = 6
  RPN_BAUD_115200* = 7
  RPN_BAUD_230400* = 8
  RPN_DATA_5* = 0x00000000
  RPN_DATA_6* = 0x00000001
  RPN_DATA_7* = 0x00000002
  RPN_DATA_8* = 0x00000003
  RPN_STOP_1* = 0x00000000
  RPN_STOP_1_5* = 0x00000004
  RPN_PARITY_NONE* = 0x00000000
  RPN_PARITY_ODD* = 0x00000008
  RPN_PARITY_EVEN* = 0x00000018
  RPN_PARITY_MARK* = 0x00000028
  RPN_PARITY_SPACE* = 0x00000038
  RPN_FLOW_X_IN* = 0x00000001
  RPN_FLOW_X_OUT* = 0x00000002
  RPN_FLOW_RTR_IN* = 0x00000004
  RPN_FLOW_RTR_OUT* = 0x00000008
  RPN_FLOW_RTC_IN* = 0x00000010
  RPN_FLOW_RTC_OUT* = 0x00000020
  RPN_PARAM_BAUD* = 0x00000001
  RPN_PARAM_DATA* = 0x00000002
  RPN_PARAM_STOP* = 0x00000004
  RPN_PARAM_PARITY* = 0x00000008
  RPN_PARAM_P_TYPE* = 0x00000010
  RPN_PARAM_XON* = 0x00000020
  RPN_PARAM_XOFF* = 0x00000040
  RPN_PARAM_X_IN* = 0x00000001
  RPN_PARAM_X_OUT* = 0x00000002
  RPN_PARAM_RTR_IN* = 0x00000004
  RPN_PARAM_RTR_OUT* = 0x00000008
  RPN_PARAM_RTC_IN* = 0x00000010
  RPN_PARAM_RTC_OUT* = 0x00000020
type
  RFCOMM_RPN_DATA* = object
    Baud*: UCHAR
    Data*: UCHAR
    FlowControl*: UCHAR
    XonChar*: UCHAR
    XoffChar*: UCHAR
    ParameterMask1*: UCHAR
    ParameterMask2*: UCHAR

  PRFCOMM_RPN_DATA* = ptr RFCOMM_RPN_DATA
const
  RFCOMM_CMD_NONE* = 0
  RFCOMM_CMD_MSC* = 1
  RFCOMM_CMD_RLS* = 2
  RFCOMM_CMD_RPN* = 3
  RFCOMM_CMD_RPN_REQUEST* = 4
  RFCOMM_CMD_RPN_RESPONSE* = 5
#      RESERVED_CMD                6
type
  INNER_C_UNION_112492126* {.union.} = object
    MSC*: RFCOMM_MSC_DATA
    RLS*: RFCOMM_RLS_DATA
    RPN*: RFCOMM_RPN_DATA

type
  RFCOMM_COMMAND* = object
    CmdType*: ULONG       # one of RFCOMM_CMD_*
    Data*: INNER_C_UNION_112492126

  PRFCOMM_COMMAND* = ptr RFCOMM_COMMAND
#
# These structures are for test/validation/conformance and may only be
# present in debug/checked builds of the system
#
type
  INNER_C_UNION_301228124* {.union.} = object
    connectionlessMTU*: USHORT
    data*: array[MAX_L2CAP_INFO_DATA_LENGTH, UCHAR]

type
  BTH_PING_REQ* = object
    btAddr*: BTH_ADDR
    dataLen*: UCHAR
    data*: array[MAX_L2CAP_PING_DATA_LENGTH, UCHAR]

  PBTH_PING_REQ* = ptr BTH_PING_REQ
  BTH_PING_RSP* = object
    dataLen*: UCHAR
    data*: array[MAX_L2CAP_PING_DATA_LENGTH, UCHAR]

  PBTH_PING_RSP* = ptr BTH_PING_RSP
  BTH_INFO_REQ* = object
    btAddr*: BTH_ADDR
    infoType*: USHORT

  PBTH_INFO_REQ* = ptr BTH_INFO_REQ
  BTH_INFO_RSP* = object
    result*: USHORT
    dataLen*: UCHAR
    ano_2541354110*: INNER_C_UNION_301228124

  PBTH_INFO_RSP* = ptr BTH_INFO_RSP
#
# WinCE compatible struct names
#
type
  BTHNS_SETBLOB* = BTH_SET_SERVICE
  PBTHNS_SETBLOB* = ptr BTH_SET_SERVICE
  BTHNS_INQUIRYBLOB* = BTH_QUERY_DEVICE
  PBTHNS_INQUIRYBLOB* = ptr BTH_QUERY_DEVICE
  BTHNS_RESTRICTIONBLOB* = BTH_QUERY_SERVICE
  PBTHNS_RESTRICTIONBLOB* = ptr BTH_QUERY_SERVICE
