#
#
#   BlueZ - Bluetooth protocol stack for Linux
#
#   Copyright (C) 2000-2001  Qualcomm Incorporated
#   Copyright (C) 2002-2003  Maxim Krasnyansky <maxk@qualcomm.com>
#   Copyright (C) 2002-2010  Marcel Holtmann <marcel@holtmann.org>
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

import ioctl
import bz_bluetooth

const
  HCI_MAX_DEV* = 16
  HCI_MAX_ACL_SIZE* = 1024
  HCI_MAX_SCO_SIZE* = 255
  HCI_MAX_EVENT_SIZE* = 260
  HCI_MAX_FRAME_SIZE* = (HCI_MAX_ACL_SIZE + 4)

# HCI dev events

const
  HCI_DEV_REG_EV* = 1
  HCI_DEV_UNREG_EV* = 2
  HCI_DEV_UP_EV* = 3
  HCI_DEV_DOWN_EV* = 4
  HCI_DEV_SUSPEND_EV* = 5
  HCI_DEV_RESUME_EV* = 6

# HCI bus types

const
  HCI_VIRTUAL* = 0
  HCI_USB* = 1
  HCI_PCCARD* = 2
  HCI_UART* = 3
  HCI_RS232* = 4
  HCI_PCI* = 5
  HCI_SDIO* = 6

# HCI controller types

const
  HCI_BREDR* = 0x00000000
  HCI_AMP* = 0x00000001

# HCI device flags

const
  HCI_UP_FLAG* = 0
  HCI_INIT_FLAG* = 1
  HCI_RUNNING_FLAG* = 2
  HCI_PSCAN_FLAG* = 3
  HCI_ISCAN_FLAG* = 4
  HCI_AUTH_FLAG* = 5
  HCI_ENCRYPT_FLAG* = 6
  HCI_INQUIRY_FLAG* = 7
  HCI_RAW_FLAG* = 8

# LE address type

const
  LE_PUBLIC_ADDRESS* = 0x00000000
  LE_RANDOM_ADDRESS* = 0x00000001

# HCI ioctl defines

const
  HCIDEVUP* = IOW(ord('H'), 201, int)
  HCIDEVDOWN* = IOW(ord('H'), 202, int)
  HCIDEVRESET* = IOW(ord('H'), 203, int)
  HCIDEVRESTAT* = IOW(ord('H'), 204, int)
  HCIGETDEVLIST* = IOR(ord('H'), 210, int)
  HCIGETDEVINFO* = IOR(ord('H'), 211, int)
  HCIGETCONNLIST* = IOR(ord('H'), 212, int)
  HCIGETCONNINFO* = IOR(ord('H'), 213, int)
  HCIGETAUTHINFO* = IOR(ord('H'), 215, int)
  HCISETRAW* = IOW(ord('H'), 220, int)
  HCISETSCAN* = IOW(ord('H'), 221, int)
  HCISETAUTH* = IOW(ord('H'), 222, int)
  HCISETENCRYPT* = IOW(ord('H'), 223, int)
  HCISETPTYPE* = IOW(ord('H'), 224, int)
  HCISETLINKPOL* = IOW(ord('H'), 225, int)
  HCISETLINKMODE* = IOW(ord('H'), 226, int)
  HCISETACLMTU* = IOW(ord('H'), 227, int)
  HCISETSCOMTU* = IOW(ord('H'), 228, int)
  HCIBLOCKADDR* = IOW(ord('H'), 230, int)
  HCIUNBLOCKADDR* = IOW(ord('H'), 231, int)
  HCIINQUIRY* = IOR(ord('H'), 240, int)

when not defined(NO_HCI_DEFS):
  # HCI Packet types
  const
    HCI_COMMAND_PKT* = 0x00000001
    HCI_ACLDATA_PKT* = 0x00000002
    HCI_SCODATA_PKT* = 0x00000003
    HCI_EVENT_PKT* = 0x00000004
    HCI_VENDOR_PKT* = 0x000000FF
  # HCI Packet types
  const
    HCI_2DH1* = 0x00000002
    HCI_3DH1* = 0x00000004
    HCI_DM1* = 0x00000008
    HCI_DH1* = 0x00000010
    HCI_2DH3* = 0x00000100
    HCI_3DH3* = 0x00000200
    HCI_DM3* = 0x00000400
    HCI_DH3* = 0x00000800
    HCI_2DH5* = 0x00001000
    HCI_3DH5* = 0x00002000
    HCI_DM5* = 0x00004000
    HCI_DH5* = 0x00008000
    HCI_HV1* = 0x00000020
    HCI_HV2* = 0x00000040
    HCI_HV3* = 0x00000080
    HCI_EV3* = 0x00000008
    HCI_EV4* = 0x00000010
    HCI_EV5* = 0x00000020
    HCI_2EV3* = 0x00000040
    HCI_3EV3* = 0x00000080
    HCI_2EV5* = 0x00000100
    HCI_3EV5* = 0x00000200
    SCO_PTYPE_MASK* = (HCI_HV1 or HCI_HV2 or HCI_HV3)
    ACL_PTYPE_MASK* = (
      HCI_DM1 or HCI_DH1 or HCI_DM3 or HCI_DH3 or HCI_DM5 or HCI_DH5)
  # HCI Error codes
  const
    HCI_UNKNOWN_COMMAND* = 0x00000001
    HCI_NO_CONNECTION* = 0x00000002
    HCI_HARDWARE_FAILURE* = 0x00000003
    HCI_PAGE_TIMEOUT* = 0x00000004
    HCI_AUTHENTICATION_FAILURE* = 0x00000005
    HCI_PIN_OR_KEY_MISSING* = 0x00000006
    HCI_MEMORY_FULL* = 0x00000007
    HCI_CONNECTION_TIMEOUT* = 0x00000008
    HCI_MAX_NUMBER_OF_CONNECTIONS* = 0x00000009
    HCI_MAX_NUMBER_OF_SCO_CONNECTIONS* = 0x0000000A
    HCI_ACL_CONNECTION_EXISTS* = 0x0000000B
    HCI_COMMAND_DISALLOWED* = 0x0000000C
    HCI_REJECTED_LIMITED_RESOURCES* = 0x0000000D
    HCI_REJECTED_SECURITY* = 0x0000000E
    HCI_REJECTED_PERSONAL* = 0x0000000F
    HCI_HOST_TIMEOUT* = 0x00000010
    HCI_UNSUPPORTED_FEATURE* = 0x00000011
    HCI_INVALID_PARAMETERS* = 0x00000012
    HCI_OE_USER_ENDED_CONNECTION* = 0x00000013
    HCI_OE_LOW_RESOURCES* = 0x00000014
    HCI_OE_POWER_OFF* = 0x00000015
    HCI_CONNECTION_TERMINATED* = 0x00000016
    HCI_REPEATED_ATTEMPTS* = 0x00000017
    HCI_PAIRING_NOT_ALLOWED* = 0x00000018
    HCI_UNKNOWN_LMP_PDU* = 0x00000019
    HCI_UNSUPPORTED_REMOTE_FEATURE* = 0x0000001A
    HCI_SCO_OFFSET_REJECTED* = 0x0000001B
    HCI_SCO_INTERVAL_REJECTED* = 0x0000001C
    HCI_AIR_MODE_REJECTED* = 0x0000001D
    HCI_INVALID_LMP_PARAMETERS* = 0x0000001E
    HCI_UNSPECIFIED_ERROR* = 0x0000001F
    HCI_UNSUPPORTED_LMP_PARAMETER_VALUE* = 0x00000020
    HCI_ROLE_CHANGE_NOT_ALLOWED* = 0x00000021
    HCI_LMP_RESPONSE_TIMEOUT* = 0x00000022
    HCI_LMP_ERROR_TRANSACTION_COLLISION* = 0x00000023
    HCI_LMP_PDU_NOT_ALLOWED* = 0x00000024
    HCI_ENCRYPTION_MODE_NOT_ACCEPTED* = 0x00000025
    HCI_UNIT_LINK_KEY_USED* = 0x00000026
    HCI_QOS_NOT_SUPPORTED* = 0x00000027
    HCI_INSTANT_PASSED* = 0x00000028
    HCI_PAIRING_NOT_SUPPORTED* = 0x00000029
    HCI_TRANSACTION_COLLISION* = 0x0000002A
    HCI_QOS_UNACCEPTABLE_PARAMETER* = 0x0000002C
    HCI_QOS_REJECTED* = 0x0000002D
    HCI_CLASSIFICATION_NOT_SUPPORTED* = 0x0000002E
    HCI_INSUFFICIENT_SECURITY* = 0x0000002F
    HCI_PARAMETER_OUT_OF_RANGE* = 0x00000030
    HCI_ROLE_SWITCH_PENDING* = 0x00000032
    HCI_SLOT_VIOLATION* = 0x00000034
    HCI_ROLE_SWITCH_FAILED* = 0x00000035
    HCI_EIR_TOO_LARGE* = 0x00000036
    HCI_SIMPLE_PAIRING_NOT_SUPPORTED* = 0x00000037
    HCI_HOST_BUSY_PAIRING* = 0x00000038
  # ACL flags
  const
    ACL_START_NO_FLUSH* = 0x00000000
    ACL_CONT* = 0x00000001
    ACL_START* = 0x00000002
    ACL_ACTIVE_BCAST* = 0x00000004
    ACL_PICO_BCAST* = 0x00000008
  # Baseband links
  const
    SCO_LINK* = 0x00000000
    ACL_LINK* = 0x00000001
    ESCO_LINK* = 0x00000002
  # LMP features
  const
    LMP_3SLOT* = 0x00000001
    LMP_5SLOT* = 0x00000002
    LMP_ENCRYPT* = 0x00000004
    LMP_SOFFSET* = 0x00000008
    LMP_TACCURACY* = 0x00000010
    LMP_RSWITCH* = 0x00000020
    LMP_HOLD* = 0x00000040
    LMP_SNIFF* = 0x00000080
    LMP_PARK* = 0x00000001
    LMP_RSSI* = 0x00000002
    LMP_QUALITY* = 0x00000004
    LMP_SCO* = 0x00000008
    LMP_HV2* = 0x00000010
    LMP_HV3* = 0x00000020
    LMP_ULAW* = 0x00000040
    LMP_ALAW* = 0x00000080
    LMP_CVSD* = 0x00000001
    LMP_PSCHEME* = 0x00000002
    LMP_PCONTROL* = 0x00000004
    LMP_TRSP_SCO* = 0x00000008
    LMP_BCAST_ENC* = 0x00000080
    LMP_EDR_ACL_2M* = 0x00000002
    LMP_EDR_ACL_3M* = 0x00000004
    LMP_ENH_ISCAN* = 0x00000008
    LMP_ILACE_ISCAN* = 0x00000010
    LMP_ILACE_PSCAN* = 0x00000020
    LMP_RSSI_INQ* = 0x00000040
    LMP_ESCO* = 0x00000080
    LMP_EV4* = 0x00000001
    LMP_EV5* = 0x00000002
    LMP_AFH_CAP_SLV* = 0x00000008
    LMP_AFH_CLS_SLV* = 0x00000010
    LMP_NO_BREDR* = 0x00000020
    LMP_LE* = 0x00000040
    LMP_EDR_3SLOT* = 0x00000080
    LMP_EDR_5SLOT* = 0x00000001
    LMP_SNIFF_SUBR* = 0x00000002
    LMP_PAUSE_ENC* = 0x00000004
    LMP_AFH_CAP_MST* = 0x00000008
    LMP_AFH_CLS_MST* = 0x00000010
    LMP_EDR_ESCO_2M* = 0x00000020
    LMP_EDR_ESCO_3M* = 0x00000040
    LMP_EDR_3S_ESCO* = 0x00000080
    LMP_EXT_INQ* = 0x00000001
    LMP_LE_BREDR* = 0x00000002
    LMP_SIMPLE_PAIR* = 0x00000008
    LMP_ENCAPS_PDU* = 0x00000010
    LMP_ERR_DAT_REP* = 0x00000020
    LMP_NFLUSH_PKTS* = 0x00000040
    LMP_LSTO* = 0x00000001
    LMP_INQ_TX_PWR* = 0x00000002
    LMP_EPC* = 0x00000004
    LMP_EXT_FEAT* = 0x00000080
  # Extended LMP features
  const
    LMP_HOST_SSP* = 0x00000001
    LMP_HOST_LE* = 0x00000002
    LMP_HOST_LE_BREDR* = 0x00000004
  # Link policies
  const
    HCI_LP_RSWITCH* = 0x00000001
    HCI_LP_HOLD* = 0x00000002
    HCI_LP_SNIFF* = 0x00000004
    HCI_LP_PARK* = 0x00000008
  # Link mode
  const
    HCI_LM_ACCEPT* = 0x00008000
    HCI_LM_MASTER* = 0x00000001
    HCI_LM_AUTH* = 0x00000002
    HCI_LM_ENCRYPT* = 0x00000004
    HCI_LM_TRUSTED* = 0x00000008
    HCI_LM_RELIABLE* = 0x00000010
    HCI_LM_SECURE* = 0x00000020
  # Link Key types
  const
    HCI_LK_COMBINATION* = 0x00000000
    HCI_LK_LOCAL_UNIT* = 0x00000001
    HCI_LK_REMOTE_UNIT* = 0x00000002
    HCI_LK_DEBUG_COMBINATION* = 0x00000003
    HCI_LK_UNAUTH_COMBINATION* = 0x00000004
    HCI_LK_AUTH_COMBINATION* = 0x00000005
    HCI_LK_CHANGED_COMBINATION* = 0x00000006
    HCI_LK_INVALID* = 0x000000FF
  # -----  HCI Commands -----
  # Link Control
  const
    OGF_LINK_CTL* = 0x00000001
    OCF_INQUIRY* = 0x00000001
  type
    inquiry_cp* {.packed.} = object
      lap*: array[3, uint8]
      length*: uint8        # 1.28s units
      num_rsp*: uint8

  const
    INQUIRY_CP_SIZE* = 5
  type
    status_bdaddr_rp* {.packed.} = object
      status*: uint8
      bdaddr*: bdaddr_t

  const
    STATUS_BDADDR_RP_SIZE* = 7
    OCF_INQUIRY_CANCEL* = 0x00000002
    OCF_PERIODIC_INQUIRY* = 0x00000003
  type
    periodic_inquiry_cp* {.packed.} = object
      max_period*: uint16   # 1.28s units
      min_period*: uint16   # 1.28s units
      lap*: array[3, uint8]
      length*: uint8        # 1.28s units
      num_rsp*: uint8

  const
    PERIODIC_INQUIRY_CP_SIZE* = 9
    OCF_EXIT_PERIODIC_INQUIRY* = 0x00000004
    OCF_CREATE_CONN* = 0x00000005
  type
    create_conn_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      pkt_type*: uint16
      pscan_rep_mode*: uint8
      pscan_mode*: uint8
      clock_offset*: uint16
      role_switch*: uint8

  const
    CREATE_CONN_CP_SIZE* = 13
    OCF_DISCONNECT* = 0x00000006
  type
    disconnect_cp* {.packed.} = object
      handle*: uint16
      reason*: uint8

  const
    DISCONNECT_CP_SIZE* = 3
    OCF_ADD_SCO* = 0x00000007
  type
    add_sco_cp* {.packed.} = object
      handle*: uint16
      pkt_type*: uint16

  const
    ADD_SCO_CP_SIZE* = 4
    OCF_CREATE_CONN_CANCEL* = 0x00000008
  type
    create_conn_cancel_cp* {.packed.} = object
      bdaddr*: bdaddr_t

  const
    CREATE_CONN_CANCEL_CP_SIZE* = 6
    OCF_ACCEPT_CONN_REQ* = 0x00000009
  type
    accept_conn_req_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      role*: uint8

  const
    ACCEPT_CONN_REQ_CP_SIZE* = 7
    OCF_REJECT_CONN_REQ* = 0x0000000A
  type
    reject_conn_req_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      reason*: uint8

  const
    REJECT_CONN_REQ_CP_SIZE* = 7
    OCF_LINK_KEY_REPLY* = 0x0000000B
  type
    link_key_reply_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      link_key*: array[16, uint8]

  const
    LINK_KEY_REPLY_CP_SIZE* = 22
    OCF_LINK_KEY_NEG_REPLY* = 0x0000000C
    OCF_PIN_CODE_REPLY* = 0x0000000D
  type
    pin_code_reply_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      pin_len*: uint8
      pin_code*: array[16, uint8]

  const
    PIN_CODE_REPLY_CP_SIZE* = 23
    OCF_PIN_CODE_NEG_REPLY* = 0x0000000E
    OCF_SET_CONN_PTYPE* = 0x0000000F
  type
    set_conn_ptype_cp* {.packed.} = object
      handle*: uint16
      pkt_type*: uint16

  const
    SET_CONN_PTYPE_CP_SIZE* = 4
    OCF_AUTH_REQUESTED* = 0x00000011
  type
    auth_requested_cp* {.packed.} = object
      handle*: uint16

  const
    AUTH_REQUESTED_CP_SIZE* = 2
    OCF_SET_CONN_ENCRYPT* = 0x00000013
  type
    set_conn_encrypt_cp* {.packed.} = object
      handle*: uint16
      encrypt*: uint8

  const
    SET_CONN_ENCRYPT_CP_SIZE* = 3
    OCF_CHANGE_CONN_LINK_KEY* = 0x00000015
  type
    change_conn_link_key_cp* {.packed.} = object
      handle*: uint16

  const
    CHANGE_CONN_LINK_KEY_CP_SIZE* = 2
    OCF_MASTER_LINK_KEY* = 0x00000017
  type
    master_link_key_cp* {.packed.} = object
      key_flag*: uint8

  const
    MASTER_LINK_KEY_CP_SIZE* = 1
    OCF_REMOTE_NAME_REQ* = 0x00000019
  type
    remote_name_req_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      pscan_rep_mode*: uint8
      pscan_mode*: uint8
      clock_offset*: uint16

  const
    REMOTE_NAME_REQ_CP_SIZE* = 10
    OCF_REMOTE_NAME_REQ_CANCEL* = 0x0000001A
  type
    remote_name_req_cancel_cp* {.packed.} = object
      bdaddr*: bdaddr_t

  const
    REMOTE_NAME_REQ_CANCEL_CP_SIZE* = 6
    OCF_READ_REMOTE_FEATURES* = 0x0000001B
  type
    read_remote_features_cp* {.packed.} = object
      handle*: uint16

  const
    READ_REMOTE_FEATURES_CP_SIZE* = 2
    OCF_READ_REMOTE_EXT_FEATURES* = 0x0000001C
  type
    read_remote_ext_features_cp* {.packed.} = object
      handle*: uint16
      page_num*: uint8

  const
    READ_REMOTE_EXT_FEATURES_CP_SIZE* = 3
    OCF_READ_REMOTE_VERSION* = 0x0000001D
  type
    read_remote_version_cp* {.packed.} = object
      handle*: uint16

  const
    READ_REMOTE_VERSION_CP_SIZE* = 2
    OCF_READ_CLOCK_OFFSET* = 0x0000001F
  type
    read_clock_offset_cp* {.packed.} = object
      handle*: uint16

  const
    READ_CLOCK_OFFSET_CP_SIZE* = 2
    OCF_READ_LMP_HANDLE* = 0x00000020
    OCF_SETUP_SYNC_CONN* = 0x00000028
  type
    setup_sync_conn_cp* {.packed.} = object
      handle*: uint16
      tx_bandwith*: uint32
      rx_bandwith*: uint32
      max_latency*: uint16
      voice_setting*: uint16
      retrans_effort*: uint8
      pkt_type*: uint16

  const
    SETUP_SYNC_CONN_CP_SIZE* = 17
    OCF_ACCEPT_SYNC_CONN_REQ* = 0x00000029
  type
    accept_sync_conn_req_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      tx_bandwith*: uint32
      rx_bandwith*: uint32
      max_latency*: uint16
      voice_setting*: uint16
      retrans_effort*: uint8
      pkt_type*: uint16

  const
    ACCEPT_SYNC_CONN_REQ_CP_SIZE* = 21
    OCF_REJECT_SYNC_CONN_REQ* = 0x0000002A
  type
    reject_sync_conn_req_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      reason*: uint8

  const
    REJECT_SYNC_CONN_REQ_CP_SIZE* = 7
    OCF_IO_CAPABILITY_REPLY* = 0x0000002B
  type
    io_capability_reply_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      capability*: uint8
      oob_data*: uint8
      authentication*: uint8

  const
    IO_CAPABILITY_REPLY_CP_SIZE* = 9
    OCF_USER_CONFIRM_REPLY* = 0x0000002C
  type
    user_confirm_reply_cp* {.packed.} = object
      bdaddr*: bdaddr_t

  const
    USER_CONFIRM_REPLY_CP_SIZE* = 6
    OCF_USER_CONFIRM_NEG_REPLY* = 0x0000002D
    OCF_USER_PASSKEY_REPLY* = 0x0000002E
  type
    user_passkey_reply_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      passkey*: uint32

  const
    USER_PASSKEY_REPLY_CP_SIZE* = 10
    OCF_USER_PASSKEY_NEG_REPLY* = 0x0000002F
    OCF_REMOTE_OOB_DATA_REPLY* = 0x00000030
  type
    remote_oob_data_reply_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      hash*: array[16, uint8]
      randomizer*: array[16, uint8]

  const
    REMOTE_OOB_DATA_REPLY_CP_SIZE* = 38
    OCF_REMOTE_OOB_DATA_NEG_REPLY* = 0x00000033
    OCF_IO_CAPABILITY_NEG_REPLY* = 0x00000034
  type
    io_capability_neg_reply_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      reason*: uint8

  const
    IO_CAPABILITY_NEG_REPLY_CP_SIZE* = 7
    OCF_CREATE_PHYSICAL_LINK* = 0x00000035
  type
    create_physical_link_cp* {.packed.} = object
      handle*: uint8
      key_length*: uint8
      key_type*: uint8
      key*: array[32, uint8]

  const
    CREATE_PHYSICAL_LINK_CP_SIZE* = 35
    OCF_ACCEPT_PHYSICAL_LINK* = 0x00000036
    OCF_DISCONNECT_PHYSICAL_LINK* = 0x00000037
  type
    disconnect_physical_link_cp* {.packed.} = object
      handle*: uint8
      reason*: uint8

  const
    DISCONNECT_PHYSICAL_LINK_CP_SIZE* = 2
    OCF_CREATE_LOGICAL_LINK* = 0x00000038
  type
    create_logical_link_cp* {.packed.} = object
      handle*: uint8
      tx_flow*: array[16, uint8]
      rx_flow*: array[16, uint8]

  const
    CREATE_LOGICAL_LINK_CP_SIZE* = 33
    OCF_ACCEPT_LOGICAL_LINK* = 0x00000039
    OCF_DISCONNECT_LOGICAL_LINK* = 0x0000003A
  type
    disconnect_logical_link_cp* {.packed.} = object
      handle*: uint16

  const
    DISCONNECT_LOGICAL_LINK_CP_SIZE* = 2
    OCF_LOGICAL_LINK_CANCEL* = 0x0000003B
  type
    cancel_logical_link_cp* {.packed.} = object
      handle*: uint8
      tx_flow_id*: uint8

  const
    LOGICAL_LINK_CANCEL_CP_SIZE* = 2
  type
    cancel_logical_link_rp* {.packed.} = object
      status*: uint8
      handle*: uint8
      tx_flow_id*: uint8

  const
    LOGICAL_LINK_CANCEL_RP_SIZE* = 3
    OCF_FLOW_SPEC_MODIFY* = 0x0000003C
  # Link Policy
  const
    OGF_LINK_POLICY* = 0x00000002
    OCF_HOLD_MODE* = 0x00000001
  type
    hold_mode_cp* {.packed.} = object
      handle*: uint16
      max_interval*: uint16
      min_interval*: uint16

  const
    HOLD_MODE_CP_SIZE* = 6
    OCF_SNIFF_MODE* = 0x00000003
  type
    sniff_mode_cp* {.packed.} = object
      handle*: uint16
      max_interval*: uint16
      min_interval*: uint16
      attempt*: uint16
      timeout*: uint16

  const
    SNIFF_MODE_CP_SIZE* = 10
    OCF_EXIT_SNIFF_MODE* = 0x00000004
  type
    exit_sniff_mode_cp* {.packed.} = object
      handle*: uint16

  const
    EXIT_SNIFF_MODE_CP_SIZE* = 2
    OCF_PARK_MODE* = 0x00000005
  type
    park_mode_cp* {.packed.} = object
      handle*: uint16
      max_interval*: uint16
      min_interval*: uint16

  const
    PARK_MODE_CP_SIZE* = 6
    OCF_EXIT_PARK_MODE* = 0x00000006
  type
    exit_park_mode_cp* {.packed.} = object
      handle*: uint16

  const
    EXIT_PARK_MODE_CP_SIZE* = 2
    OCF_QOS_SETUP* = 0x00000007
  type
    hci_qos* {.packed.} = object
      service_type*: uint8  # 1 = best effort
      token_rate*: uint32   # Byte per seconds
      peak_bandwidth*: uint32 # Byte per seconds
      latency*: uint32      # Microseconds
      delay_variation*: uint32 # Microseconds

  const
    HCI_QOS_CP_SIZE* = 17
  type
    qos_setup_cp* {.packed.} = object
      handle*: uint16
      flags*: uint8         # Reserved
      qos*: hci_qos

  const
    QOS_SETUP_CP_SIZE* = (3 + HCI_QOS_CP_SIZE)
    OCF_ROLE_DISCOVERY* = 0x00000009
  type
    role_discovery_cp* {.packed.} = object
      handle*: uint16

  const
    ROLE_DISCOVERY_CP_SIZE* = 2
  type
    role_discovery_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      role*: uint8

  const
    ROLE_DISCOVERY_RP_SIZE* = 4
    OCF_SWITCH_ROLE* = 0x0000000B
  type
    switch_role_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      role*: uint8

  const
    SWITCH_ROLE_CP_SIZE* = 7
    OCF_READ_LINK_POLICY* = 0x0000000C
  type
    read_link_policy_cp* {.packed.} = object
      handle*: uint16

  const
    READ_LINK_POLICY_CP_SIZE* = 2
  type
    read_link_policy_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      policy*: uint16

  const
    READ_LINK_POLICY_RP_SIZE* = 5
    OCF_WRITE_LINK_POLICY* = 0x0000000D
  type
    write_link_policy_cp* {.packed.} = object
      handle*: uint16
      policy*: uint16

  const
    WRITE_LINK_POLICY_CP_SIZE* = 4
  type
    write_link_policy_rp* {.packed.} = object
      status*: uint8
      handle*: uint16

  const
    WRITE_LINK_POLICY_RP_SIZE* = 3
    OCF_READ_DEFAULT_LINK_POLICY* = 0x0000000E
    OCF_WRITE_DEFAULT_LINK_POLICY* = 0x0000000F
    OCF_FLOW_SPECIFICATION* = 0x00000010
    OCF_SNIFF_SUBRATING* = 0x00000011
  type
    sniff_subrating_cp* {.packed.} = object
      handle*: uint16
      max_latency*: uint16
      min_remote_timeout*: uint16
      min_local_timeout*: uint16

  const
    SNIFF_SUBRATING_CP_SIZE* = 8
  # Host Controller and Baseband
  const
    OGF_HOST_CTL* = 0x00000003
    OCF_SET_EVENT_MASK* = 0x00000001
  type
    set_event_mask_cp* {.packed.} = object
      mask*: array[8, uint8]

  const
    SET_EVENT_MASK_CP_SIZE* = 8
    OCF_RESET* = 0x00000003
    OCF_SET_EVENT_FLT* = 0x00000005
  type
    set_event_flt_cp* {.packed.} = object
      flt_type*: uint8
      cond_type*: uint8
      condition*: array[0, uint8]

  const
    SET_EVENT_FLT_CP_SIZE* = 2
  # Filter types
  const
    FLT_CLEAR_ALL* = 0x00000000
    FLT_INQ_RESULT* = 0x00000001
    FLT_CONN_SETUP* = 0x00000002
  # INQ_RESULT Condition types
  const
    INQ_RESULT_RETURN_ALL* = 0x00000000
    INQ_RESULT_RETURN_CLASS* = 0x00000001
    INQ_RESULT_RETURN_BDADDR* = 0x00000002
  # CONN_SETUP Condition types
  const
    CONN_SETUP_ALLOW_ALL* = 0x00000000
    CONN_SETUP_ALLOW_CLASS* = 0x00000001
    CONN_SETUP_ALLOW_BDADDR* = 0x00000002
  # CONN_SETUP Conditions
  const
    CONN_SETUP_AUTO_OFF* = 0x00000001
    CONN_SETUP_AUTO_ON* = 0x00000002
    OCF_FLUSH* = 0x00000008
    OCF_READ_PIN_TYPE* = 0x00000009
  type
    read_pin_type_rp* {.packed.} = object
      status*: uint8
      pin_type*: uint8

  const
    READ_PIN_TYPE_RP_SIZE* = 2
    OCF_WRITE_PIN_TYPE* = 0x0000000A
  type
    write_pin_type_cp* {.packed.} = object
      pin_type*: uint8

  const
    WRITE_PIN_TYPE_CP_SIZE* = 1
    OCF_CREATE_NEW_UNIT_KEY* = 0x0000000B
    OCF_READ_STORED_LINK_KEY* = 0x0000000D
  type
    read_stored_link_key_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      read_all*: uint8

  const
    READ_STORED_LINK_KEY_CP_SIZE* = 7
  type
    read_stored_link_key_rp* {.packed.} = object
      status*: uint8
      max_keys*: uint16
      num_keys*: uint16

  const
    READ_STORED_LINK_KEY_RP_SIZE* = 5
    OCF_WRITE_STORED_LINK_KEY* = 0x00000011
  type
    write_stored_link_key_cp* {.packed.} = object
      num_keys*: uint8      # variable length part

  const
    WRITE_STORED_LINK_KEY_CP_SIZE* = 1
  type
    write_stored_link_key_rp* {.packed.} = object
      status*: uint8
      num_keys*: uint8

  const
    READ_WRITE_LINK_KEY_RP_SIZE* = 2
    OCF_DELETE_STORED_LINK_KEY* = 0x00000012
  type
    delete_stored_link_key_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      delete_all*: uint8

  const
    DELETE_STORED_LINK_KEY_CP_SIZE* = 7
  type
    delete_stored_link_key_rp* {.packed.} = object
      status*: uint8
      num_keys*: uint16

  const
    DELETE_STORED_LINK_KEY_RP_SIZE* = 3
    HCI_MAX_NAME_LENGTH* = 248
    OCF_CHANGE_LOCAL_NAME* = 0x00000013
  type
    change_local_name_cp* {.packed.} = object
      name*: array[HCI_MAX_NAME_LENGTH, uint8]

  const
    CHANGE_LOCAL_NAME_CP_SIZE* = 248
    OCF_READ_LOCAL_NAME* = 0x00000014
  type
    read_local_name_rp* {.packed.} = object
      status*: uint8
      name*: array[HCI_MAX_NAME_LENGTH, uint8]

  const
    READ_LOCAL_NAME_RP_SIZE* = 249
    OCF_READ_CONN_ACCEPT_TIMEOUT* = 0x00000015
  type
    read_conn_accept_timeout_rp* {.packed.} = object
      status*: uint8
      timeout*: uint16

  const
    READ_CONN_ACCEPT_TIMEOUT_RP_SIZE* = 3
    OCF_WRITE_CONN_ACCEPT_TIMEOUT* = 0x00000016
  type
    write_conn_accept_timeout_cp* {.packed.} = object
      timeout*: uint16

  const
    WRITE_CONN_ACCEPT_TIMEOUT_CP_SIZE* = 2
    OCF_READ_PAGE_TIMEOUT* = 0x00000017
  type
    read_page_timeout_rp* {.packed.} = object
      status*: uint8
      timeout*: uint16

  const
    READ_PAGE_TIMEOUT_RP_SIZE* = 3
    OCF_WRITE_PAGE_TIMEOUT* = 0x00000018
  type
    write_page_timeout_cp* {.packed.} = object
      timeout*: uint16

  const
    WRITE_PAGE_TIMEOUT_CP_SIZE* = 2
    OCF_READ_SCAN_ENABLE* = 0x00000019
  type
    read_scan_enable_rp* {.packed.} = object
      status*: uint8
      enable*: uint8

  const
    READ_SCAN_ENABLE_RP_SIZE* = 2
    OCF_WRITE_SCAN_ENABLE* = 0x0000001A
    SCAN_DISABLED* = 0x00000000
    SCAN_INQUIRY* = 0x00000001
    SCAN_PAGE* = 0x00000002
    OCF_READ_PAGE_ACTIVITY* = 0x0000001B
  type
    read_page_activity_rp* {.packed.} = object
      status*: uint8
      interval*: uint16
      window*: uint16

  const
    READ_PAGE_ACTIVITY_RP_SIZE* = 5
    OCF_WRITE_PAGE_ACTIVITY* = 0x0000001C
  type
    write_page_activity_cp* {.packed.} = object
      interval*: uint16
      window*: uint16

  const
    WRITE_PAGE_ACTIVITY_CP_SIZE* = 4
    OCF_READ_INQ_ACTIVITY* = 0x0000001D
  type
    read_inq_activity_rp* {.packed.} = object
      status*: uint8
      interval*: uint16
      window*: uint16

  const
    READ_INQ_ACTIVITY_RP_SIZE* = 5
    OCF_WRITE_INQ_ACTIVITY* = 0x0000001E
  type
    write_inq_activity_cp* {.packed.} = object
      interval*: uint16
      window*: uint16

  const
    WRITE_INQ_ACTIVITY_CP_SIZE* = 4
    OCF_READ_AUTH_ENABLE* = 0x0000001F
    OCF_WRITE_AUTH_ENABLE* = 0x00000020
    AUTH_DISABLED* = 0x00000000
    AUTH_ENABLED* = 0x00000001
    OCF_READ_ENCRYPT_MODE* = 0x00000021
    OCF_WRITE_ENCRYPT_MODE* = 0x00000022
    ENCRYPT_DISABLED* = 0x00000000
    ENCRYPT_P2P* = 0x00000001
    ENCRYPT_BOTH* = 0x00000002
    OCF_READ_CLASS_OF_DEV* = 0x00000023
  type
    read_class_of_dev_rp* {.packed.} = object
      status*: uint8
      dev_class*: array[3, uint8]

  const
    READ_CLASS_OF_DEV_RP_SIZE* = 4
    OCF_WRITE_CLASS_OF_DEV* = 0x00000024
  type
    write_class_of_dev_cp* {.packed.} = object
      dev_class*: array[3, uint8]

  const
    WRITE_CLASS_OF_DEV_CP_SIZE* = 3
    OCF_READ_VOICE_SETTING* = 0x00000025
  type
    read_voice_setting_rp* {.packed.} = object
      status*: uint8
      voice_setting*: uint16

  const
    READ_VOICE_SETTING_RP_SIZE* = 3
    OCF_WRITE_VOICE_SETTING* = 0x00000026
  type
    write_voice_setting_cp* {.packed.} = object
      voice_setting*: uint16

  const
    WRITE_VOICE_SETTING_CP_SIZE* = 2
    OCF_READ_AUTOMATIC_FLUSH_TIMEOUT* = 0x00000027
    OCF_WRITE_AUTOMATIC_FLUSH_TIMEOUT* = 0x00000028
    OCF_READ_NUM_BROADCAST_RETRANS* = 0x00000029
    OCF_WRITE_NUM_BROADCAST_RETRANS* = 0x0000002A
    OCF_READ_HOLD_MODE_ACTIVITY* = 0x0000002B
    OCF_WRITE_HOLD_MODE_ACTIVITY* = 0x0000002C
    OCF_READ_TRANSMIT_POWER_LEVEL* = 0x0000002D
  type
    read_transmit_power_level_cp* {.packed.} = object
      handle*: uint16
      `type`*: uint8

  const
    READ_TRANSMIT_POWER_LEVEL_CP_SIZE* = 3
  type
    read_transmit_power_level_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      level*: int8

  const
    READ_TRANSMIT_POWER_LEVEL_RP_SIZE* = 4
    OCF_READ_SYNC_FLOW_ENABLE* = 0x0000002E
    OCF_WRITE_SYNC_FLOW_ENABLE* = 0x0000002F
    OCF_SET_CONTROLLER_TO_HOST_FC* = 0x00000031
    OCF_HOST_BUFFER_SIZE* = 0x00000033
  type
    host_buffer_size_cp* {.packed.} = object
      acl_mtu*: uint16
      sco_mtu*: uint8
      acl_max_pkt*: uint16
      sco_max_pkt*: uint16

  const
    HOST_BUFFER_SIZE_CP_SIZE* = 7
    OCF_HOST_NUM_COMP_PKTS* = 0x00000035
  type
    host_num_comp_pkts_cp* {.packed.} = object
      num_hndl*: uint8      # variable length part

  const
    HOST_NUM_COMP_PKTS_CP_SIZE* = 1
    OCF_READ_LINK_SUPERVISION_TIMEOUT* = 0x00000036
  type
    read_link_supervision_timeout_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      timeout*: uint16

  const
    READ_LINK_SUPERVISION_TIMEOUT_RP_SIZE* = 5
    OCF_WRITE_LINK_SUPERVISION_TIMEOUT* = 0x00000037
  type
    write_link_supervision_timeout_cp* {.packed.} = object
      handle*: uint16
      timeout*: uint16

  const
    WRITE_LINK_SUPERVISION_TIMEOUT_CP_SIZE* = 4
  type
    write_link_supervision_timeout_rp* {.packed.} = object
      status*: uint8
      handle*: uint16

  const
    WRITE_LINK_SUPERVISION_TIMEOUT_RP_SIZE* = 3
    OCF_READ_NUM_SUPPORTED_IAC* = 0x00000038
    MAX_IAC_LAP* = 0x00000040
    OCF_READ_CURRENT_IAC_LAP* = 0x00000039
  type
    read_current_iac_lap_rp* {.packed.} = object
      status*: uint8
      num_current_iac*: uint8
      lap*: array[MAX_IAC_LAP, array[3, uint8]]

  const
    READ_CURRENT_IAC_LAP_RP_SIZE* = 2 + 3 * MAX_IAC_LAP
    OCF_WRITE_CURRENT_IAC_LAP* = 0x0000003A
  type
    write_current_iac_lap_cp* {.packed.} = object
      num_current_iac*: uint8
      lap*: array[MAX_IAC_LAP, array[3, uint8]]

  const
    WRITE_CURRENT_IAC_LAP_CP_SIZE* = 1 + 3 * MAX_IAC_LAP
    OCF_READ_PAGE_SCAN_PERIOD_MODE* = 0x0000003B
    OCF_WRITE_PAGE_SCAN_PERIOD_MODE* = 0x0000003C
    OCF_READ_PAGE_SCAN_MODE* = 0x0000003D
    OCF_WRITE_PAGE_SCAN_MODE* = 0x0000003E
    OCF_SET_AFH_CLASSIFICATION* = 0x0000003F
  type
    set_afh_classification_cp* {.packed.} = object
      map*: array[10, uint8]

  const
    SET_AFH_CLASSIFICATION_CP_SIZE* = 10
  type
    set_afh_classification_rp* {.packed.} = object
      status*: uint8

  const
    SET_AFH_CLASSIFICATION_RP_SIZE* = 1
    OCF_READ_INQUIRY_SCAN_TYPE* = 0x00000042
  type
    read_inquiry_scan_type_rp* {.packed.} = object
      status*: uint8
      `type`*: uint8

  const
    READ_INQUIRY_SCAN_TYPE_RP_SIZE* = 2
    OCF_WRITE_INQUIRY_SCAN_TYPE* = 0x00000043
  type
    write_inquiry_scan_type_cp* {.packed.} = object
      `type`*: uint8

  const
    WRITE_INQUIRY_SCAN_TYPE_CP_SIZE* = 1
  type
    write_inquiry_scan_type_rp* {.packed.} = object
      status*: uint8

  const
    WRITE_INQUIRY_SCAN_TYPE_RP_SIZE* = 1
    OCF_READ_INQUIRY_MODE* = 0x00000044
  type
    read_inquiry_mode_rp* {.packed.} = object
      status*: uint8
      mode*: uint8

  const
    READ_INQUIRY_MODE_RP_SIZE* = 2
    OCF_WRITE_INQUIRY_MODE* = 0x00000045
  type
    write_inquiry_mode_cp* {.packed.} = object
      mode*: uint8

  const
    WRITE_INQUIRY_MODE_CP_SIZE* = 1
  type
    write_inquiry_mode_rp* {.packed.} = object
      status*: uint8

  const
    WRITE_INQUIRY_MODE_RP_SIZE* = 1
    OCF_READ_PAGE_SCAN_TYPE* = 0x00000046
    OCF_WRITE_PAGE_SCAN_TYPE* = 0x00000047
    PAGE_SCAN_TYPE_STANDARD* = 0x00000000
    PAGE_SCAN_TYPE_INTERLACED* = 0x00000001
    OCF_READ_AFH_MODE* = 0x00000048
  type
    read_afh_mode_rp* {.packed.} = object
      status*: uint8
      mode*: uint8

  const
    READ_AFH_MODE_RP_SIZE* = 2
    OCF_WRITE_AFH_MODE* = 0x00000049
  type
    write_afh_mode_cp* {.packed.} = object
      mode*: uint8

  const
    WRITE_AFH_MODE_CP_SIZE* = 1
  type
    write_afh_mode_rp* {.packed.} = object
      status*: uint8

  const
    WRITE_AFH_MODE_RP_SIZE* = 1
    HCI_MAX_EIR_LENGTH* = 240
    OCF_READ_EXT_INQUIRY_RESPONSE* = 0x00000051
  type
    read_ext_inquiry_response_rp* {.packed.} = object
      status*: uint8
      fec*: uint8
      data*: array[HCI_MAX_EIR_LENGTH, uint8]

  const
    READ_EXT_INQUIRY_RESPONSE_RP_SIZE* = 242
    OCF_WRITE_EXT_INQUIRY_RESPONSE* = 0x00000052
  type
    write_ext_inquiry_response_cp* {.packed.} = object
      fec*: uint8
      data*: array[HCI_MAX_EIR_LENGTH, uint8]

  const
    WRITE_EXT_INQUIRY_RESPONSE_CP_SIZE* = 241
  type
    write_ext_inquiry_response_rp* {.packed.} = object
      status*: uint8

  const
    WRITE_EXT_INQUIRY_RESPONSE_RP_SIZE* = 1
    OCF_REFRESH_ENCRYPTION_KEY* = 0x00000053
  type
    refresh_encryption_key_cp* {.packed.} = object
      handle*: uint16

  const
    REFRESH_ENCRYPTION_KEY_CP_SIZE* = 2
  type
    refresh_encryption_key_rp* {.packed.} = object
      status*: uint8

  const
    REFRESH_ENCRYPTION_KEY_RP_SIZE* = 1
    OCF_READ_SIMPLE_PAIRING_MODE* = 0x00000055
  type
    read_simple_pairing_mode_rp* {.packed.} = object
      status*: uint8
      mode*: uint8

  const
    READ_SIMPLE_PAIRING_MODE_RP_SIZE* = 2
    OCF_WRITE_SIMPLE_PAIRING_MODE* = 0x00000056
  type
    write_simple_pairing_mode_cp* {.packed.} = object
      mode*: uint8

  const
    WRITE_SIMPLE_PAIRING_MODE_CP_SIZE* = 1
  type
    write_simple_pairing_mode_rp* {.packed.} = object
      status*: uint8

  const
    WRITE_SIMPLE_PAIRING_MODE_RP_SIZE* = 1
    OCF_READ_LOCAL_OOB_DATA* = 0x00000057
  type
    read_local_oob_data_rp* {.packed.} = object
      status*: uint8
      hash*: array[16, uint8]
      randomizer*: array[16, uint8]

  const
    READ_LOCAL_OOB_DATA_RP_SIZE* = 33
    OCF_READ_INQ_RESPONSE_TX_POWER_LEVEL* = 0x00000058
  type
    read_inq_response_tx_power_level_rp* {.packed.} = object
      status*: uint8
      level*: int8

  const
    READ_INQ_RESPONSE_TX_POWER_LEVEL_RP_SIZE* = 2
    OCF_READ_INQUIRY_TRANSMIT_POWER_LEVEL* = 0x00000058
  type
    read_inquiry_transmit_power_level_rp* {.packed.} = object
      status*: uint8
      level*: int8

  const
    READ_INQUIRY_TRANSMIT_POWER_LEVEL_RP_SIZE* = 2
    OCF_WRITE_INQUIRY_TRANSMIT_POWER_LEVEL* = 0x00000059
  type
    write_inquiry_transmit_power_level_cp* {.packed.} = object
      level*: int8

  const
    WRITE_INQUIRY_TRANSMIT_POWER_LEVEL_CP_SIZE* = 1
  type
    write_inquiry_transmit_power_level_rp* {.packed.} = object
      status*: uint8

  const
    WRITE_INQUIRY_TRANSMIT_POWER_LEVEL_RP_SIZE* = 1
    OCF_READ_DEFAULT_ERROR_DATA_REPORTING* = 0x0000005A
  type
    read_default_error_data_reporting_rp* {.packed.} = object
      status*: uint8
      reporting*: uint8

  const
    READ_DEFAULT_ERROR_DATA_REPORTING_RP_SIZE* = 2
    OCF_WRITE_DEFAULT_ERROR_DATA_REPORTING* = 0x0000005B
  type
    write_default_error_data_reporting_cp* {.packed.} = object
      reporting*: uint8

  const
    WRITE_DEFAULT_ERROR_DATA_REPORTING_CP_SIZE* = 1
  type
    write_default_error_data_reporting_rp* {.packed.} = object
      status*: uint8

  const
    WRITE_DEFAULT_ERROR_DATA_REPORTING_RP_SIZE* = 1
    OCF_ENHANCED_FLUSH* = 0x0000005F
  type
    enhanced_flush_cp* {.packed.} = object
      handle*: uint16
      `type`*: uint8

  const
    ENHANCED_FLUSH_CP_SIZE* = 3
    OCF_SEND_KEYPRESS_NOTIFY* = 0x00000060
  type
    send_keypress_notify_cp* {.packed.} = object
      bdaddr*: bdaddr_t
      `type`*: uint8

  const
    SEND_KEYPRESS_NOTIFY_CP_SIZE* = 7
  type
    send_keypress_notify_rp* {.packed.} = object
      status*: uint8

  const
    SEND_KEYPRESS_NOTIFY_RP_SIZE* = 1
    OCF_READ_LOGICAL_LINK_ACCEPT_TIMEOUT* = 0x00000061
  type
    read_log_link_accept_timeout_rp* {.packed.} = object
      status*: uint8
      timeout*: uint16

  const
    READ_LOGICAL_LINK_ACCEPT_TIMEOUT_RP_SIZE* = 3
    OCF_WRITE_LOGICAL_LINK_ACCEPT_TIMEOUT* = 0x00000062
  type
    write_log_link_accept_timeout_cp* {.packed.} = object
      timeout*: uint16

  const
    WRITE_LOGICAL_LINK_ACCEPT_TIMEOUT_CP_SIZE* = 2
    OCF_SET_EVENT_MASK_PAGE_2* = 0x00000063
    OCF_READ_LOCATION_DATA* = 0x00000064
    OCF_WRITE_LOCATION_DATA* = 0x00000065
    OCF_READ_FLOW_CONTROL_MODE* = 0x00000066
    OCF_WRITE_FLOW_CONTROL_MODE* = 0x00000067
    OCF_READ_ENHANCED_TRANSMIT_POWER_LEVEL* = 0x00000068
  type
    read_enhanced_transmit_power_level_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      level_gfsk*: int8
      level_dqpsk*: int8
      level_8dpsk*: int8

  const
    READ_ENHANCED_TRANSMIT_POWER_LEVEL_RP_SIZE* = 6
    OCF_READ_BEST_EFFORT_FLUSH_TIMEOUT* = 0x00000069
  type
    read_best_effort_flush_timeout_rp* {.packed.} = object
      status*: uint8
      timeout*: uint32

  const
    READ_BEST_EFFORT_FLUSH_TIMEOUT_RP_SIZE* = 5
    OCF_WRITE_BEST_EFFORT_FLUSH_TIMEOUT* = 0x0000006A
  type
    write_best_effort_flush_timeout_cp* {.packed.} = object
      handle*: uint16
      timeout*: uint32

  const
    WRITE_BEST_EFFORT_FLUSH_TIMEOUT_CP_SIZE* = 6
  type
    write_best_effort_flush_timeout_rp* {.packed.} = object
      status*: uint8

  const
    WRITE_BEST_EFFORT_FLUSH_TIMEOUT_RP_SIZE* = 1
    OCF_READ_LE_HOST_SUPPORTED* = 0x0000006C
  type
    read_le_host_supported_rp* {.packed.} = object
      status*: uint8
      le*: uint8
      simul*: uint8

  const
    READ_LE_HOST_SUPPORTED_RP_SIZE* = 3
    OCF_WRITE_LE_HOST_SUPPORTED* = 0x0000006D
  type
    write_le_host_supported_cp* {.packed.} = object
      le*: uint8
      simul*: uint8

  const
    WRITE_LE_HOST_SUPPORTED_CP_SIZE* = 2
  # Informational Parameters
  const
    OGF_INFO_PARAM* = 0x00000004
    OCF_READ_LOCAL_VERSION* = 0x00000001
  type
    read_local_version_rp* {.packed.} = object
      status*: uint8
      hci_ver*: uint8
      hci_rev*: uint16
      lmp_ver*: uint8
      manufacturer*: uint16
      lmp_subver*: uint16

  const
    READ_LOCAL_VERSION_RP_SIZE* = 9
    OCF_READ_LOCAL_COMMANDS* = 0x00000002
  type
    read_local_commands_rp* {.packed.} = object
      status*: uint8
      commands*: array[64, uint8]

  const
    READ_LOCAL_COMMANDS_RP_SIZE* = 65
    OCF_READ_LOCAL_FEATURES* = 0x00000003
  type
    read_local_features_rp* {.packed.} = object
      status*: uint8
      features*: array[8, uint8]

  const
    READ_LOCAL_FEATURES_RP_SIZE* = 9
    OCF_READ_LOCAL_EXT_FEATURES* = 0x00000004
  type
    read_local_ext_features_cp* {.packed.} = object
      page_num*: uint8

  const
    READ_LOCAL_EXT_FEATURES_CP_SIZE* = 1
  type
    read_local_ext_features_rp* {.packed.} = object
      status*: uint8
      page_num*: uint8
      max_page_num*: uint8
      features*: array[8, uint8]

  const
    READ_LOCAL_EXT_FEATURES_RP_SIZE* = 11
    OCF_READ_BUFFER_SIZE* = 0x00000005
  type
    read_buffer_size_rp* {.packed.} = object
      status*: uint8
      acl_mtu*: uint16
      sco_mtu*: uint8
      acl_max_pkt*: uint16
      sco_max_pkt*: uint16

  const
    READ_BUFFER_SIZE_RP_SIZE* = 8
    OCF_READ_COUNTRY_CODE* = 0x00000007
    OCF_READ_BD_ADDR* = 0x00000009
  type
    read_bd_addr_rp* {.packed.} = object
      status*: uint8
      bdaddr*: bdaddr_t

  const
    READ_BD_ADDR_RP_SIZE* = 7
  # Status params
  const
    OGF_STATUS_PARAM* = 0x00000005
    OCF_READ_FAILED_CONTACT_COUNTER* = 0x00000001
  type
    read_failed_contact_counter_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      counter*: uint8

  const
    READ_FAILED_CONTACT_COUNTER_RP_SIZE* = 4
    OCF_RESET_FAILED_CONTACT_COUNTER* = 0x00000002
  type
    reset_failed_contact_counter_rp* {.packed.} = object
      status*: uint8
      handle*: uint16

  const
    RESET_FAILED_CONTACT_COUNTER_RP_SIZE* = 4
    OCF_READ_LINK_QUALITY* = 0x00000003
  type
    read_link_quality_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      link_quality*: uint8

  const
    READ_LINK_QUALITY_RP_SIZE* = 4
    OCF_READ_RSSI* = 0x00000005
  type
    read_rssi_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      rssi*: int8

  const
    READ_RSSI_RP_SIZE* = 4
    OCF_READ_AFH_MAP* = 0x00000006
  type
    read_afh_map_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      mode*: uint8
      map*: array[10, uint8]

  const
    READ_AFH_MAP_RP_SIZE* = 14
    OCF_READ_CLOCK* = 0x00000007
  type
    read_clock_cp* {.packed.} = object
      handle*: uint16
      which_clock*: uint8

  const
    READ_CLOCK_CP_SIZE* = 3
  type
    read_clock_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      clock*: uint32
      accuracy*: uint16

  const
    READ_CLOCK_RP_SIZE* = 9
    OCF_READ_LOCAL_AMP_INFO* = 0x00000009
  type
    read_local_amp_info_rp* {.packed.} = object
      status*: uint8
      amp_status*: uint8
      total_bandwidth*: uint32
      max_guaranteed_bandwidth*: uint32
      min_latency*: uint32
      max_pdu_size*: uint32
      controller_type*: uint8
      pal_caps*: uint16
      max_amp_assoc_length*: uint16
      max_flush_timeout*: uint32
      best_effort_flush_timeout*: uint32

  const
    READ_LOCAL_AMP_INFO_RP_SIZE* = 31
    OCF_READ_LOCAL_AMP_ASSOC* = 0x0000000A
  type
    read_local_amp_assoc_cp* {.packed.} = object
      handle*: uint8
      len_so_far*: uint16
      max_len*: uint16

    read_local_amp_assoc_rp* {.packed.} = object
      status*: uint8
      handle*: uint8
      rem_len*: uint16
      frag*: array[0, uint8]

  const
    OCF_WRITE_REMOTE_AMP_ASSOC* = 0x0000000B
  type
    write_remote_amp_assoc_cp* {.packed.} = object
      handle*: uint8
      length_so_far*: uint16
      assoc_length*: uint16
      fragment*: array[HCI_MAX_NAME_LENGTH, uint8]

  const
    WRITE_REMOTE_AMP_ASSOC_CP_SIZE* = 253
  type
    write_remote_amp_assoc_rp* {.packed.} = object
      status*: uint8
      handle*: uint8

  const
    WRITE_REMOTE_AMP_ASSOC_RP_SIZE* = 2
  # Testing commands
  const
    OGF_TESTING_CMD* = 0x0000003E
    OCF_READ_LOOPBACK_MODE* = 0x00000001
    OCF_WRITE_LOOPBACK_MODE* = 0x00000002
    OCF_ENABLE_DEVICE_UNDER_TEST_MODE* = 0x00000003
    OCF_WRITE_SIMPLE_PAIRING_DEBUG_MODE* = 0x00000004
  type
    write_simple_pairing_debug_mode_cp* {.packed.} = object
      mode*: uint8

  const
    WRITE_SIMPLE_PAIRING_DEBUG_MODE_CP_SIZE* = 1
  type
    write_simple_pairing_debug_mode_rp* {.packed.} = object
      status*: uint8

  const
    WRITE_SIMPLE_PAIRING_DEBUG_MODE_RP_SIZE* = 1
  # LE commands
  const
    OGF_LE_CTL* = 0x00000008
    OCF_LE_SET_EVENT_MASK* = 0x00000001
  type
    le_set_event_mask_cp* {.packed.} = object
      mask*: array[8, uint8]

  const
    LE_SET_EVENT_MASK_CP_SIZE* = 8
    OCF_LE_READ_BUFFER_SIZE* = 0x00000002
  type
    le_read_buffer_size_rp* {.packed.} = object
      status*: uint8
      pkt_len*: uint16
      max_pkt*: uint8

  const
    LE_READ_BUFFER_SIZE_RP_SIZE* = 4
    OCF_LE_READ_LOCAL_SUPPORTED_FEATURES* = 0x00000003
  type
    le_read_local_supported_features_rp* {.packed.} = object
      status*: uint8
      features*: array[8, uint8]

  const
    LE_READ_LOCAL_SUPPORTED_FEATURES_RP_SIZE* = 9
    OCF_LE_SET_RANDOM_ADDRESS* = 0x00000005
  type
    le_set_random_address_cp* {.packed.} = object
      bdaddr*: bdaddr_t

  const
    LE_SET_RANDOM_ADDRESS_CP_SIZE* = 6
    OCF_LE_SET_ADVERTISING_PARAMETERS* = 0x00000006
  type
    le_set_advertising_parameters_cp* {.packed.} = object
      min_interval*: uint16
      max_interval*: uint16
      advtype*: uint8
      own_bdaddr_type*: uint8
      direct_bdaddr_type*: uint8
      direct_bdaddr*: bdaddr_t
      chan_map*: uint8
      filter*: uint8

  const
    LE_SET_ADVERTISING_PARAMETERS_CP_SIZE* = 15
    OCF_LE_READ_ADVERTISING_CHANNEL_TX_POWER* = 0x00000007
  type
    le_read_advertising_channel_tx_power_rp* {.packed.} = object
      status*: uint8
      level*: uint8

  const
    LE_READ_ADVERTISING_CHANNEL_TX_POWER_RP_SIZE* = 2
    OCF_LE_SET_ADVERTISING_DATA* = 0x00000008
  type
    le_set_advertising_data_cp* {.packed.} = object
      length*: uint8
      data*: array[31, uint8]

  const
    LE_SET_ADVERTISING_DATA_CP_SIZE* = 32
    OCF_LE_SET_SCAN_RESPONSE_DATA* = 0x00000009
  type
    le_set_scan_response_data_cp* {.packed.} = object
      length*: uint8
      data*: array[31, uint8]

  const
    LE_SET_SCAN_RESPONSE_DATA_CP_SIZE* = 32
    OCF_LE_SET_ADVERTISE_ENABLE* = 0x0000000A
  type
    le_set_advertise_enable_cp* {.packed.} = object
      enable*: uint8

  const
    LE_SET_ADVERTISE_ENABLE_CP_SIZE* = 1
    OCF_LE_SET_SCAN_PARAMETERS* = 0x0000000B
  type
    le_set_scan_parameters_cp* {.packed.} = object
      `type`*: uint8
      interval*: uint16
      window*: uint16
      own_bdaddr_type*: uint8
      filter*: uint8

  const
    LE_SET_SCAN_PARAMETERS_CP_SIZE* = 7
    OCF_LE_SET_SCAN_ENABLE* = 0x0000000C
  type
    le_set_scan_enable_cp* {.packed.} = object
      enable*: uint8
      filter_dup*: uint8

  const
    LE_SET_SCAN_ENABLE_CP_SIZE* = 2
    OCF_LE_CREATE_CONN* = 0x0000000D
  type
    le_create_connection_cp* {.packed.} = object
      interval*: uint16
      window*: uint16
      initiator_filter*: uint8
      peer_bdaddr_type*: uint8
      peer_bdaddr*: bdaddr_t
      own_bdaddr_type*: uint8
      min_interval*: uint16
      max_interval*: uint16
      latency*: uint16
      supervision_timeout*: uint16
      min_ce_length*: uint16
      max_ce_length*: uint16

  const
    LE_CREATE_CONN_CP_SIZE* = 25
    OCF_LE_CREATE_CONN_CANCEL* = 0x0000000E
    OCF_LE_READ_WHITE_LIST_SIZE* = 0x0000000F
  type
    le_read_white_list_size_rp* {.packed.} = object
      status*: uint8
      size*: uint8

  const
    LE_READ_WHITE_LIST_SIZE_RP_SIZE* = 2
    OCF_LE_CLEAR_WHITE_LIST* = 0x00000010
    OCF_LE_ADD_DEVICE_TO_WHITE_LIST* = 0x00000011
  type
    le_add_device_to_white_list_cp* {.packed.} = object
      bdaddr_type*: uint8
      bdaddr*: bdaddr_t

  const
    LE_ADD_DEVICE_TO_WHITE_LIST_CP_SIZE* = 7
    OCF_LE_REMOVE_DEVICE_FROM_WHITE_LIST* = 0x00000012
  type
    le_remove_device_from_white_list_cp* {.packed.} = object
      bdaddr_type*: uint8
      bdaddr*: bdaddr_t

  const
    LE_REMOVE_DEVICE_FROM_WHITE_LIST_CP_SIZE* = 7
    OCF_LE_CONN_UPDATE* = 0x00000013
  type
    le_connection_update_cp* {.packed.} = object
      handle*: uint16
      min_interval*: uint16
      max_interval*: uint16
      latency*: uint16
      supervision_timeout*: uint16
      min_ce_length*: uint16
      max_ce_length*: uint16

  const
    LE_CONN_UPDATE_CP_SIZE* = 14
    OCF_LE_SET_HOST_CHANNEL_CLASSIFICATION* = 0x00000014
  type
    le_set_host_channel_classification_cp* {.packed.} = object
      map*: array[5, uint8]

  const
    LE_SET_HOST_CHANNEL_CLASSIFICATION_CP_SIZE* = 5
    OCF_LE_READ_CHANNEL_MAP* = 0x00000015
  type
    le_read_channel_map_cp* {.packed.} = object
      handle*: uint16

  const
    LE_READ_CHANNEL_MAP_CP_SIZE* = 2
  type
    le_read_channel_map_rp* {.packed.} = object
      status*: uint8
      handle*: uint16
      map*: array[5, uint8]

  const
    LE_READ_CHANNEL_MAP_RP_SIZE* = 8
    OCF_LE_READ_REMOTE_USED_FEATURES* = 0x00000016
  type
    le_read_remote_used_features_cp* {.packed.} = object
      handle*: uint16

  const
    LE_READ_REMOTE_USED_FEATURES_CP_SIZE* = 2
    OCF_LE_ENCRYPT* = 0x00000017
  type
    le_encrypt_cp* {.packed.} = object
      key*: array[16, uint8]
      plaintext*: array[16, uint8]

  const
    LE_ENCRYPT_CP_SIZE* = 32
  type
    le_encrypt_rp* {.packed.} = object
      status*: uint8
      data*: array[16, uint8]

  const
    LE_ENCRYPT_RP_SIZE* = 17
    OCF_LE_RAND* = 0x00000018
  type
    le_rand_rp* {.packed.} = object
      status*: uint8
      random*: uint64

  const
    LE_RAND_RP_SIZE* = 9
    OCF_LE_START_ENCRYPTION* = 0x00000019
  type
    le_start_encryption_cp* {.packed.} = object
      handle*: uint16
      random*: uint64
      diversifier*: uint16
      key*: array[16, uint8]

  const
    LE_START_ENCRYPTION_CP_SIZE* = 28
    OCF_LE_LTK_REPLY* = 0x0000001A
  type
    le_ltk_reply_cp* {.packed.} = object
      handle*: uint16
      key*: array[16, uint8]

  const
    LE_LTK_REPLY_CP_SIZE* = 18
  type
    le_ltk_reply_rp* {.packed.} = object
      status*: uint8
      handle*: uint16

  const
    LE_LTK_REPLY_RP_SIZE* = 3
    OCF_LE_LTK_NEG_REPLY* = 0x0000001B
  type
    le_ltk_neg_reply_cp* {.packed.} = object
      handle*: uint16

  const
    LE_LTK_NEG_REPLY_CP_SIZE* = 2
  type
    le_ltk_neg_reply_rp* {.packed.} = object
      status*: uint8
      handle*: uint16

  const
    LE_LTK_NEG_REPLY_RP_SIZE* = 3
    OCF_LE_READ_SUPPORTED_STATES* = 0x0000001C
  type
    le_read_supported_states_rp* {.packed.} = object
      status*: uint8
      states*: uint64

  const
    LE_READ_SUPPORTED_STATES_RP_SIZE* = 9
    OCF_LE_RECEIVER_TEST* = 0x0000001D
  type
    le_receiver_test_cp* {.packed.} = object
      frequency*: uint8

  const
    LE_RECEIVER_TEST_CP_SIZE* = 1
    OCF_LE_TRANSMITTER_TEST* = 0x0000001E
  type
    le_transmitter_test_cp* {.packed.} = object
      frequency*: uint8
      length*: uint8
      payload*: uint8

  const
    LE_TRANSMITTER_TEST_CP_SIZE* = 3
    OCF_LE_TEST_END* = 0x0000001F
  type
    le_test_end_rp* {.packed.} = object
      status*: uint8
      num_pkts*: uint16

  const
    LE_TEST_END_RP_SIZE* = 3
  # Vendor specific commands
  const
    OGF_VENDOR_CMD* = 0x0000003F
  # ---- HCI Events ----
  const
    EVT_INQUIRY_COMPLETE* = 0x00000001
    EVT_INQUIRY_RESULT* = 0x00000002
  type
    inquiry_info* {.packed.} = object
      bdaddr*: bdaddr_t
      pscan_rep_mode*: uint8
      pscan_period_mode*: uint8
      pscan_mode*: uint8
      dev_class*: array[3, uint8]
      clock_offset*: uint16

  const
    INQUIRY_INFO_SIZE* = 14
    EVT_CONN_COMPLETE* = 0x00000003
  type
    evt_conn_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      bdaddr*: bdaddr_t
      link_type*: uint8
      encr_mode*: uint8

  const
    EVT_CONN_COMPLETE_SIZE* = 13
    EVT_CONN_REQUEST* = 0x00000004
  type
    evt_conn_request* {.packed.} = object
      bdaddr*: bdaddr_t
      dev_class*: array[3, uint8]
      link_type*: uint8

  const
    EVT_CONN_REQUEST_SIZE* = 10
    EVT_DISCONN_COMPLETE* = 0x00000005
  type
    evt_disconn_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      reason*: uint8

  const
    EVT_DISCONN_COMPLETE_SIZE* = 4
    EVT_AUTH_COMPLETE* = 0x00000006
  type
    evt_auth_complete* {.packed.} = object
      status*: uint8
      handle*: uint16

  const
    EVT_AUTH_COMPLETE_SIZE* = 3
    EVT_REMOTE_NAME_REQ_COMPLETE* = 0x00000007
  type
    evt_remote_name_req_complete* {.packed.} = object
      status*: uint8
      bdaddr*: bdaddr_t
      name*: array[HCI_MAX_NAME_LENGTH, uint8]

  const
    EVT_REMOTE_NAME_REQ_COMPLETE_SIZE* = 255
    EVT_ENCRYPT_CHANGE* = 0x00000008
  type
    evt_encrypt_change* {.packed.} = object
      status*: uint8
      handle*: uint16
      encrypt*: uint8

  const
    EVT_ENCRYPT_CHANGE_SIZE* = 5
    EVT_CHANGE_CONN_LINK_KEY_COMPLETE* = 0x00000009
  type
    evt_change_conn_link_key_complete* {.packed.} = object
      status*: uint8
      handle*: uint16

  const
    EVT_CHANGE_CONN_LINK_KEY_COMPLETE_SIZE* = 3
    EVT_MASTER_LINK_KEY_COMPLETE* = 0x0000000A
  type
    evt_master_link_key_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      key_flag*: uint8

  const
    EVT_MASTER_LINK_KEY_COMPLETE_SIZE* = 4
    EVT_READ_REMOTE_FEATURES_COMPLETE* = 0x0000000B
  type
    evt_read_remote_features_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      features*: array[8, uint8]

  const
    EVT_READ_REMOTE_FEATURES_COMPLETE_SIZE* = 11
    EVT_READ_REMOTE_VERSION_COMPLETE* = 0x0000000C
  type
    evt_read_remote_version_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      lmp_ver*: uint8
      manufacturer*: uint16
      lmp_subver*: uint16

  const
    EVT_READ_REMOTE_VERSION_COMPLETE_SIZE* = 8
    EVT_QOS_SETUP_COMPLETE* = 0x0000000D
  type
    evt_qos_setup_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      flags*: uint8         # Reserved
      qos*: hci_qos

  const
    EVT_QOS_SETUP_COMPLETE_SIZE* = (4 + HCI_QOS_CP_SIZE)
    EVT_CMD_COMPLETE* = 0x0000000E
  type
    evt_cmd_complete* {.packed.} = object
      ncmd*: uint8
      opcode*: uint16

  const
    EVT_CMD_COMPLETE_SIZE* = 3
    EVT_CMD_STATUS* = 0x0000000F
  type
    evt_cmd_status* {.packed.} = object
      status*: uint8
      ncmd*: uint8
      opcode*: uint16

  const
    EVT_CMD_STATUS_SIZE* = 4
    EVT_HARDWARE_ERROR* = 0x00000010
  type
    evt_hardware_error* {.packed.} = object
      code*: uint8

  const
    EVT_HARDWARE_ERROR_SIZE* = 1
    EVT_FLUSH_OCCURRED* = 0x00000011
  type
    evt_flush_occured* {.packed.} = object
      handle*: uint16

  const
    EVT_FLUSH_OCCURRED_SIZE* = 2
    EVT_ROLE_CHANGE* = 0x00000012
  type
    evt_role_change* {.packed.} = object
      status*: uint8
      bdaddr*: bdaddr_t
      role*: uint8

  const
    EVT_ROLE_CHANGE_SIZE* = 8
    EVT_NUM_COMP_PKTS* = 0x00000013
  type
    evt_num_comp_pkts* {.packed.} = object
      num_hndl*: uint8      # variable length part

  const
    EVT_NUM_COMP_PKTS_SIZE* = 1
    EVT_MODE_CHANGE* = 0x00000014
  type
    evt_mode_change* {.packed.} = object
      status*: uint8
      handle*: uint16
      mode*: uint8
      interval*: uint16

  const
    EVT_MODE_CHANGE_SIZE* = 6
    EVT_RETURN_LINK_KEYS* = 0x00000015
  type
    evt_return_link_keys* {.packed.} = object
      num_keys*: uint8      # variable length part

  const
    EVT_RETURN_LINK_KEYS_SIZE* = 1
    EVT_PIN_CODE_REQ* = 0x00000016
  type
    evt_pin_code_req* {.packed.} = object
      bdaddr*: bdaddr_t

  const
    EVT_PIN_CODE_REQ_SIZE* = 6
    EVT_LINK_KEY_REQ* = 0x00000017
  type
    evt_link_key_req* {.packed.} = object
      bdaddr*: bdaddr_t

  const
    EVT_LINK_KEY_REQ_SIZE* = 6
    EVT_LINK_KEY_NOTIFY* = 0x00000018
  type
    evt_link_key_notify* {.packed.} = object
      bdaddr*: bdaddr_t
      link_key*: array[16, uint8]
      key_type*: uint8

  const
    EVT_LINK_KEY_NOTIFY_SIZE* = 23
    EVT_LOOPBACK_COMMAND* = 0x00000019
    EVT_DATA_BUFFER_OVERFLOW* = 0x0000001A
  type
    evt_data_buffer_overflow* {.packed.} = object
      link_type*: uint8

  const
    EVT_DATA_BUFFER_OVERFLOW_SIZE* = 1
    EVT_MAX_SLOTS_CHANGE* = 0x0000001B
  type
    evt_max_slots_change* {.packed.} = object
      handle*: uint16
      max_slots*: uint8

  const
    EVT_MAX_SLOTS_CHANGE_SIZE* = 3
    EVT_READ_CLOCK_OFFSET_COMPLETE* = 0x0000001C
  type
    evt_read_clock_offset_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      clock_offset*: uint16

  const
    EVT_READ_CLOCK_OFFSET_COMPLETE_SIZE* = 5
    EVT_CONN_PTYPE_CHANGED* = 0x0000001D
  type
    evt_conn_ptype_changed* {.packed.} = object
      status*: uint8
      handle*: uint16
      ptype*: uint16

  const
    EVT_CONN_PTYPE_CHANGED_SIZE* = 5
    EVT_QOS_VIOLATION* = 0x0000001E
  type
    evt_qos_violation* {.packed.} = object
      handle*: uint16

  const
    EVT_QOS_VIOLATION_SIZE* = 2
    EVT_PSCAN_REP_MODE_CHANGE* = 0x00000020
  type
    evt_pscan_rep_mode_change* {.packed.} = object
      bdaddr*: bdaddr_t
      pscan_rep_mode*: uint8

  const
    EVT_PSCAN_REP_MODE_CHANGE_SIZE* = 7
    EVT_FLOW_SPEC_COMPLETE* = 0x00000021
  type
    evt_flow_spec_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      flags*: uint8
      direction*: uint8
      qos*: hci_qos

  const
    EVT_FLOW_SPEC_COMPLETE_SIZE* = (5 + HCI_QOS_CP_SIZE)
    EVT_INQUIRY_RESULT_WITH_RSSI* = 0x00000022
  type
    inquiry_info_with_rssi* {.packed.} = object
      bdaddr*: bdaddr_t
      pscan_rep_mode*: uint8
      pscan_period_mode*: uint8
      dev_class*: array[3, uint8]
      clock_offset*: uint16
      rssi*: int8

  const
    INQUIRY_INFO_WITH_RSSI_SIZE* = 14
  type
    inquiry_info_with_rssi_and_pscan_mode* {.packed.} = object
      bdaddr*: bdaddr_t
      pscan_rep_mode*: uint8
      pscan_period_mode*: uint8
      pscan_mode*: uint8
      dev_class*: array[3, uint8]
      clock_offset*: uint16
      rssi*: int8

  const
    INQUIRY_INFO_WITH_RSSI_AND_PSCAN_MODE_SIZE* = 15
    EVT_READ_REMOTE_EXT_FEATURES_COMPLETE* = 0x00000023
  type
    evt_read_remote_ext_features_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      page_num*: uint8
      max_page_num*: uint8
      features*: array[8, uint8]

  const
    EVT_READ_REMOTE_EXT_FEATURES_COMPLETE_SIZE* = 13
    EVT_SYNC_CONN_COMPLETE* = 0x0000002C
  type
    evt_sync_conn_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      bdaddr*: bdaddr_t
      link_type*: uint8
      trans_interval*: uint8
      retrans_window*: uint8
      rx_pkt_len*: uint16
      tx_pkt_len*: uint16
      air_mode*: uint8

  const
    EVT_SYNC_CONN_COMPLETE_SIZE* = 17
    EVT_SYNC_CONN_CHANGED* = 0x0000002D
  type
    evt_sync_conn_changed* {.packed.} = object
      status*: uint8
      handle*: uint16
      trans_interval*: uint8
      retrans_window*: uint8
      rx_pkt_len*: uint16
      tx_pkt_len*: uint16

  const
    EVT_SYNC_CONN_CHANGED_SIZE* = 9
    EVT_SNIFF_SUBRATING* = 0x0000002E
  type
    evt_sniff_subrating* {.packed.} = object
      status*: uint8
      handle*: uint16
      max_tx_latency*: uint16
      max_rx_latency*: uint16
      min_remote_timeout*: uint16
      min_local_timeout*: uint16

  const
    EVT_SNIFF_SUBRATING_SIZE* = 11
    EVT_EXTENDED_INQUIRY_RESULT* = 0x0000002F
  type
    extended_inquiry_info* {.packed.} = object
      bdaddr*: bdaddr_t
      pscan_rep_mode*: uint8
      pscan_period_mode*: uint8
      dev_class*: array[3, uint8]
      clock_offset*: uint16
      rssi*: int8
      data*: array[HCI_MAX_EIR_LENGTH, uint8]

  const
    EXTENDED_INQUIRY_INFO_SIZE* = 254
    EVT_ENCRYPTION_KEY_REFRESH_COMPLETE* = 0x00000030
  type
    evt_encryption_key_refresh_complete* {.packed.} = object
      status*: uint8
      handle*: uint16

  const
    EVT_ENCRYPTION_KEY_REFRESH_COMPLETE_SIZE* = 3
    EVT_IO_CAPABILITY_REQUEST* = 0x00000031
  type
    evt_io_capability_request* {.packed.} = object
      bdaddr*: bdaddr_t

  const
    EVT_IO_CAPABILITY_REQUEST_SIZE* = 6
    EVT_IO_CAPABILITY_RESPONSE* = 0x00000032
  type
    evt_io_capability_response* {.packed.} = object
      bdaddr*: bdaddr_t
      capability*: uint8
      oob_data*: uint8
      authentication*: uint8

  const
    EVT_IO_CAPABILITY_RESPONSE_SIZE* = 9
    EVT_USER_CONFIRM_REQUEST* = 0x00000033
  type
    evt_user_confirm_request* {.packed.} = object
      bdaddr*: bdaddr_t
      passkey*: uint32

  const
    EVT_USER_CONFIRM_REQUEST_SIZE* = 10
    EVT_USER_PASSKEY_REQUEST* = 0x00000034
  type
    evt_user_passkey_request* {.packed.} = object
      bdaddr*: bdaddr_t

  const
    EVT_USER_PASSKEY_REQUEST_SIZE* = 6
    EVT_REMOTE_OOB_DATA_REQUEST* = 0x00000035
  type
    evt_remote_oob_data_request* {.packed.} = object
      bdaddr*: bdaddr_t

  const
    EVT_REMOTE_OOB_DATA_REQUEST_SIZE* = 6
    EVT_SIMPLE_PAIRING_COMPLETE* = 0x00000036
  type
    evt_simple_pairing_complete* {.packed.} = object
      status*: uint8
      bdaddr*: bdaddr_t

  const
    EVT_SIMPLE_PAIRING_COMPLETE_SIZE* = 7
    EVT_LINK_SUPERVISION_TIMEOUT_CHANGED* = 0x00000038
  type
    evt_link_supervision_timeout_changed* {.packed.} = object
      handle*: uint16
      timeout*: uint16

  const
    EVT_LINK_SUPERVISION_TIMEOUT_CHANGED_SIZE* = 4
    EVT_ENHANCED_FLUSH_COMPLETE* = 0x00000039
  type
    evt_enhanced_flush_complete* {.packed.} = object
      handle*: uint16

  const
    EVT_ENHANCED_FLUSH_COMPLETE_SIZE* = 2
    EVT_USER_PASSKEY_NOTIFY* = 0x0000003B
  type
    evt_user_passkey_notify* {.packed.} = object
      bdaddr*: bdaddr_t
      passkey*: uint32
      entered*: uint8

  const
    EVT_USER_PASSKEY_NOTIFY_SIZE* = 11
    EVT_KEYPRESS_NOTIFY* = 0x0000003C
  type
    evt_keypress_notify* {.packed.} = object
      bdaddr*: bdaddr_t
      `type`*: uint8

  const
    EVT_KEYPRESS_NOTIFY_SIZE* = 7
    EVT_REMOTE_HOST_FEATURES_NOTIFY* = 0x0000003D
  type
    evt_remote_host_features_notify* {.packed.} = object
      bdaddr*: bdaddr_t
      features*: array[8, uint8]

  const
    EVT_REMOTE_HOST_FEATURES_NOTIFY_SIZE* = 14
    EVT_LE_META_EVENT* = 0x0000003E
  type
    evt_le_meta_event* {.packed.} = object
      subevent*: uint8
      data*: array[0, uint8]

  const
    EVT_LE_META_EVENT_SIZE* = 1
    EVT_LE_CONN_COMPLETE* = 0x00000001
  type
    evt_le_connection_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      role*: uint8
      peer_bdaddr_type*: uint8
      peer_bdaddr*: bdaddr_t
      interval*: uint16
      latency*: uint16
      supervision_timeout*: uint16
      master_clock_accuracy*: uint8

  const
    EVT_LE_CONN_COMPLETE_SIZE* = 18
    EVT_LE_ADVERTISING_REPORT* = 0x00000002
  type
    le_advertising_info* {.packed.} = object
      evt_type*: uint8
      bdaddr_type*: uint8
      bdaddr*: bdaddr_t
      length*: uint8
      data*: array[0, uint8]

  const
    LE_ADVERTISING_INFO_SIZE* = 9
    EVT_LE_CONN_UPDATE_COMPLETE* = 0x00000003
  type
    evt_le_connection_update_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      interval*: uint16
      latency*: uint16
      supervision_timeout*: uint16

  const
    EVT_LE_CONN_UPDATE_COMPLETE_SIZE* = 9
    EVT_LE_READ_REMOTE_USED_FEATURES_COMPLETE* = 0x00000004
  type
    evt_le_read_remote_used_features_complete* {.packed.} = object
      status*: uint8
      handle*: uint16
      features*: array[8, uint8]

  const
    EVT_LE_READ_REMOTE_USED_FEATURES_COMPLETE_SIZE* = 11
    EVT_LE_LTK_REQUEST* = 0x00000005
  type
    evt_le_long_term_key_request* {.packed.} = object
      handle*: uint16
      random*: uint64
      diversifier*: uint16

  const
    EVT_LE_LTK_REQUEST_SIZE* = 12
    EVT_PHYSICAL_LINK_COMPLETE* = 0x00000040
  type
    evt_physical_link_complete* {.packed.} = object
      status*: uint8
      handle*: uint8

  const
    EVT_PHYSICAL_LINK_COMPLETE_SIZE* = 2
    EVT_CHANNEL_SELECTED* = 0x00000041
    EVT_DISCONNECT_PHYSICAL_LINK_COMPLETE* = 0x00000042
  type
    evt_disconn_physical_link_complete* {.packed.} = object
      status*: uint8
      handle*: uint8
      reason*: uint8

  const
    EVT_DISCONNECT_PHYSICAL_LINK_COMPLETE_SIZE* = 3
    EVT_PHYSICAL_LINK_LOSS_EARLY_WARNING* = 0x00000043
  type
    evt_physical_link_loss_warning* {.packed.} = object
      handle*: uint8
      reason*: uint8

  const
    EVT_PHYSICAL_LINK_LOSS_WARNING_SIZE* = 2
    EVT_PHYSICAL_LINK_RECOVERY* = 0x00000044
  type
    evt_physical_link_recovery* {.packed.} = object
      handle*: uint8

  const
    EVT_PHYSICAL_LINK_RECOVERY_SIZE* = 1
    EVT_LOGICAL_LINK_COMPLETE* = 0x00000045
  type
    evt_logical_link_complete* {.packed.} = object
      status*: uint8
      log_handle*: uint16
      handle*: uint8
      tx_flow_id*: uint8

  const
    EVT_LOGICAL_LINK_COMPLETE_SIZE* = 5
    EVT_DISCONNECT_LOGICAL_LINK_COMPLETE* = 0x00000046
    EVT_FLOW_SPEC_MODIFY_COMPLETE* = 0x00000047
  type
    evt_flow_spec_modify_complete* {.packed.} = object
      status*: uint8
      handle*: uint16

  const
    EVT_FLOW_SPEC_MODIFY_COMPLETE_SIZE* = 3
    EVT_NUMBER_COMPLETED_BLOCKS* = 0x00000048
    EVT_AMP_STATUS_CHANGE* = 0x0000004D
  type
    evt_amp_status_change* {.packed.} = object
      status*: uint8
      amp_status*: uint8

  const
    EVT_AMP_STATUS_CHANGE_SIZE* = 2
    EVT_TESTING* = 0x000000FE
    EVT_VENDOR* = 0x000000FF
  # Internal events generated by BlueZ stack
  const
    EVT_STACK_INTERNAL* = 0x000000FD
  type
    evt_stack_internal* {.packed.} = object
      `type`*: uint16
      data*: array[0, uint8]

  const
    EVT_STACK_INTERNAL_SIZE* = 2
    EVT_SI_DEVICE* = 0x00000001
  type
    evt_si_device* {.packed.} = object
      event*: uint16
      dev_id*: uint16

  const
    EVT_SI_DEVICE_SIZE* = 4
  # --------  HCI Packet structures  --------
  const
    HCI_TYPE_LEN* = 1
  type
    hci_command_hdr* {.packed.} = object
      opcode*: uint16       # OCF & OGF
      plen*: uint8

  const
    HCI_COMMAND_HDR_SIZE* = 3
  type
    hci_event_hdr* {.packed.} = object
      evt*: uint8
      plen*: uint8

  const
    HCI_EVENT_HDR_SIZE* = 2
  type
    hci_acl_hdr* {.packed.} = object
      handle*: uint16       # Handle & Flags(PB, BC)
      dlen*: uint16

  const
    HCI_ACL_HDR_SIZE* = 4
  type
    hci_sco_hdr* {.packed.} = object
      handle*: uint16
      dlen*: uint8

  const
    HCI_SCO_HDR_SIZE* = 3
  type
    hci_msg_hdr* {.packed.} = object
      device*: uint16
      `type`*: uint16
      plen*: uint16

  const
    HCI_MSG_HDR_SIZE* = 6
  # Command opcode pack/unpack
  template cmd_opcode_pack*(ogf, ocf: untyped): untyped =
    (uint16)((ocf and 0x000003FF) or (ogf shl 10))

  template cmd_opcode_ogf*(op: untyped): untyped =
    (op shr 10)

  template cmd_opcode_ocf*(op: untyped): untyped =
    (op and 0x000003FF)

  # ACL handle and flags pack/unpack
  template acl_handle_pack*(h, f: untyped): untyped =
    (uint16)((h and 0x00000FFF) or (f shl 12))

  template acl_handle*(h: untyped): untyped =
    (h and 0x00000FFF)

  template acl_flags*(h: untyped): untyped =
    (h shr 12)

# HCI Socket options

const
  HCI_DATA_DIR* = 1
  HCI_FILTER* = 2
  HCI_TIME_STAMP* = 3

# HCI CMSG flags

const
  HCI_CMSG_DIR* = 0x00000001
  HCI_CMSG_TSTAMP* = 0x00000002

type
  sockaddr_hci* = object
    hci_family*: cushort
    hci_dev*: cushort
    hci_channel*: cushort


const
  HCI_DEV_NONE* = 0x0000FFFF
  HCI_CHANNEL_RAW* = 0
  HCI_CHANNEL_MONITOR* = 2
  HCI_CHANNEL_CONTROL* = 3

type
  hci_filter* = object
    type_mask*: uint32
    event_mask*: array[2, uint32]
    opcode*: uint16


const
  HCI_FLT_TYPE_BITS* = 31
  HCI_FLT_EVENT_BITS* = 63
  HCI_FLT_OGF_BITS* = 63
  HCI_FLT_OCF_BITS* = 127

# Ioctl requests structures

type
  hci_dev_stats* = object
    err_rx*: uint32
    err_tx*: uint32
    cmd_tx*: uint32
    evt_rx*: uint32
    acl_tx*: uint32
    acl_rx*: uint32
    sco_tx*: uint32
    sco_rx*: uint32
    byte_rx*: uint32
    byte_tx*: uint32

  hci_dev_info* = object
    dev_id*: uint16
    name*: array[8, char]
    bdaddr*: bdaddr_t
    flags*: uint32
    `type`*: uint8
    features*: array[8, uint8]
    pkt_type*: uint32
    link_policy*: uint32
    link_mode*: uint32
    acl_mtu*: uint16
    acl_pkts*: uint16
    sco_mtu*: uint16
    sco_pkts*: uint16
    stat*: hci_dev_stats

  hci_conn_info* = object
    handle*: uint16
    bdaddr*: bdaddr_t
    `type`*: uint8
    `out`*: uint8
    state*: uint16
    link_mode*: uint32

  hci_dev_req* = object
    dev_id*: uint16
    dev_opt*: uint32

  hci_dev_list_req* = object
    dev_num*: uint16
    # dev_req*: array[0, hci_dev_req] # hci_dev_req structures
    dev_req*: array[HCI_MAX_DEV, hci_dev_req] # hci_dev_req structures

  hci_conn_list_req* = object
    dev_id*: uint16
    conn_num*: uint16
    conn_info*: array[0, hci_conn_info]

  hci_conn_info_req* = object
    bdaddr*: bdaddr_t
    `type`*: uint8
    conn_info*: array[0, hci_conn_info]

  hci_auth_info_req* = object
    bdaddr*: bdaddr_t
    `type`*: uint8

  hci_inquiry_req* = object
    dev_id*: uint16
    flags*: uint16
    lap*: array[3, uint8]
    length*: uint8
    num_rsp*: uint8


const
  IREQ_CACHE_FLUSH* = 0x00000001
