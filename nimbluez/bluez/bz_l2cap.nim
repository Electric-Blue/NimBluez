#
#
#   BlueZ - Bluetooth protocol stack for Linux
#
#   Copyright (C) 2000-2001  Qualcomm Incorporated
#   Copyright (C) 2002-2003  Maxim Krasnyansky <maxk@qualcomm.com>
#   Copyright (C) 2002-2010  Marcel Holtmann <marcel@holtmann.org>
#   Copyright (c) 2012       Code Aurora Forum. All rights reserved.
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

import bz_bluetooth

# L2CAP defaults

const
  L2CAP_DEFAULT_MTU* = 672
  L2CAP_DEFAULT_FLUSH_TO* = 0x0000FFFF

# L2CAP socket address

type
  sockaddr_l2* = object
    l2_family*: cushort
    l2_psm*: cushort
    l2_bdaddr*: bdaddr_t
    l2_cid*: cushort
    l2_bdaddr_type*: uint8


# L2CAP socket options

const
  L2CAP_OPTIONS* = 0x00000001

type
  l2cap_options* = object
    omtu*: uint16
    imtu*: uint16
    flush_to*: uint16
    mode*: uint8
    fcs*: uint8
    max_tx*: uint8
    txwin_size*: uint16


const
  L2CAP_CONNINFO* = 0x00000002

type
  l2cap_conninfo* = object
    hci_handle*: uint16
    dev_class*: array[3, uint8]


const
  L2CAP_LM* = 0x00000003
  L2CAP_LM_MASTER* = 0x00000001
  L2CAP_LM_AUTH* = 0x00000002
  L2CAP_LM_ENCRYPT* = 0x00000004
  L2CAP_LM_TRUSTED* = 0x00000008
  L2CAP_LM_RELIABLE* = 0x00000010
  L2CAP_LM_SECURE* = 0x00000020

# L2CAP command codes

const
  L2CAP_COMMAND_REJ* = 0x00000001
  L2CAP_CONN_REQ* = 0x00000002
  L2CAP_CONN_RSP* = 0x00000003
  L2CAP_CONF_REQ* = 0x00000004
  L2CAP_CONF_RSP* = 0x00000005
  L2CAP_DISCONN_REQ* = 0x00000006
  L2CAP_DISCONN_RSP* = 0x00000007
  L2CAP_ECHO_REQ* = 0x00000008
  L2CAP_ECHO_RSP* = 0x00000009
  L2CAP_INFO_REQ* = 0x0000000A
  L2CAP_INFO_RSP* = 0x0000000B
  L2CAP_CREATE_REQ* = 0x0000000C
  L2CAP_CREATE_RSP* = 0x0000000D
  L2CAP_MOVE_REQ* = 0x0000000E
  L2CAP_MOVE_RSP* = 0x0000000F
  L2CAP_MOVE_CFM* = 0x00000010
  L2CAP_MOVE_CFM_RSP* = 0x00000011

# L2CAP extended feature mask

const
  L2CAP_FEAT_FLOWCTL* = 0x00000001
  L2CAP_FEAT_RETRANS* = 0x00000002
  L2CAP_FEAT_BIDIR_QOS* = 0x00000004
  L2CAP_FEAT_ERTM* = 0x00000008
  L2CAP_FEAT_STREAMING* = 0x00000010
  L2CAP_FEAT_FCS* = 0x00000020
  L2CAP_FEAT_EXT_FLOW* = 0x00000040
  L2CAP_FEAT_FIXED_CHAN* = 0x00000080
  L2CAP_FEAT_EXT_WINDOW* = 0x00000100
  L2CAP_FEAT_UCD* = 0x00000200

# L2CAP fixed channels

const
  L2CAP_FC_L2CAP* = 0x00000002
  L2CAP_FC_CONNLESS* = 0x00000004
  L2CAP_FC_A2MP* = 0x00000008

# L2CAP structures

type
  l2cap_hdr* {.packed.} = object
    len*: uint16
    cid*: uint16


const
  L2CAP_HDR_SIZE* = 4

type
  l2cap_cmd_hdr* {.packed.} = object
    code*: uint8
    ident*: uint8
    len*: uint16


const
  L2CAP_CMD_HDR_SIZE* = 4

type
  l2cap_cmd_rej* {.packed.} = object
    reason*: uint16


const
  L2CAP_CMD_REJ_SIZE* = 2

type
  l2cap_conn_req* {.packed.} = object
    psm*: uint16
    scid*: uint16


const
  L2CAP_CONN_REQ_SIZE* = 4

type
  l2cap_conn_rsp* {.packed.} = object
    dcid*: uint16
    scid*: uint16
    result*: uint16
    status*: uint16


const
  L2CAP_CONN_RSP_SIZE* = 8

# connect result

const
  L2CAP_CR_SUCCESS* = 0x00000000
  L2CAP_CR_PEND* = 0x00000001
  L2CAP_CR_BAD_PSM* = 0x00000002
  L2CAP_CR_SEC_BLOCK* = 0x00000003
  L2CAP_CR_NO_MEM* = 0x00000004

# connect status

const
  L2CAP_CS_NO_INFO* = 0x00000000
  L2CAP_CS_AUTHEN_PEND* = 0x00000001
  L2CAP_CS_AUTHOR_PEND* = 0x00000002

type
  l2cap_conf_req* {.packed.} = object
    dcid*: uint16
    flags*: uint16
    data*: array[0, uint8]


const
  L2CAP_CONF_REQ_SIZE* = 4

type
  l2cap_conf_rsp* {.packed.} = object
    scid*: uint16
    flags*: uint16
    result*: uint16
    data*: array[0, uint8]


const
  L2CAP_CONF_RSP_SIZE* = 6
  L2CAP_CONF_SUCCESS* = 0x00000000
  L2CAP_CONF_UNACCEPT* = 0x00000001
  L2CAP_CONF_REJECT* = 0x00000002
  L2CAP_CONF_UNKNOWN* = 0x00000003
  L2CAP_CONF_PENDING* = 0x00000004
  L2CAP_CONF_EFS_REJECT* = 0x00000005

type
  l2cap_conf_opt* {.packed.} = object
    `type`*: uint8
    len*: uint8
    val*: array[0, uint8]


const
  L2CAP_CONF_OPT_SIZE* = 2
  L2CAP_CONF_MTU* = 0x00000001
  L2CAP_CONF_FLUSH_TO* = 0x00000002
  L2CAP_CONF_QOS* = 0x00000003
  L2CAP_CONF_RFC* = 0x00000004
  L2CAP_CONF_FCS* = 0x00000005
  L2CAP_CONF_EFS* = 0x00000006
  L2CAP_CONF_EWS* = 0x00000007
  L2CAP_CONF_MAX_SIZE* = 22
  L2CAP_MODE_BASIC* = 0x00000000
  L2CAP_MODE_RETRANS* = 0x00000001
  L2CAP_MODE_FLOWCTL* = 0x00000002
  L2CAP_MODE_ERTM* = 0x00000003
  L2CAP_MODE_STREAMING* = 0x00000004
  L2CAP_SERVTYPE_NOTRAFFIC* = 0x00000000
  L2CAP_SERVTYPE_BESTEFFORT* = 0x00000001
  L2CAP_SERVTYPE_GUARANTEED* = 0x00000002

type
  l2cap_disconn_req* {.packed.} = object
    dcid*: uint16
    scid*: uint16


const
  L2CAP_DISCONN_REQ_SIZE* = 4

type
  l2cap_disconn_rsp* {.packed.} = object
    dcid*: uint16
    scid*: uint16


const
  L2CAP_DISCONN_RSP_SIZE* = 4

type
  l2cap_info_req* {.packed.} = object
    `type`*: uint16


const
  L2CAP_INFO_REQ_SIZE* = 2

type
  l2cap_info_rsp* {.packed.} = object
    `type`*: uint16
    result*: uint16
    data*: array[0, uint8]


const
  L2CAP_INFO_RSP_SIZE* = 4

# info type

const
  L2CAP_IT_CL_MTU* = 0x00000001
  L2CAP_IT_FEAT_MASK* = 0x00000002

# info result

const
  L2CAP_IR_SUCCESS* = 0x00000000
  L2CAP_IR_NOTSUPP* = 0x00000001

type
  l2cap_create_req* {.packed.} = object
    psm*: uint16
    scid*: uint16
    id*: uint8


const
  L2CAP_CREATE_REQ_SIZE* = 5

type
  l2cap_create_rsp* {.packed.} = object
    dcid*: uint16
    scid*: uint16
    result*: uint16
    status*: uint16


const
  L2CAP_CREATE_RSP_SIZE* = 8

type
  l2cap_move_req* {.packed.} = object
    icid*: uint16
    id*: uint8


const
  L2CAP_MOVE_REQ_SIZE* = 3

type
  l2cap_move_rsp* {.packed.} = object
    icid*: uint16
    result*: uint16


const
  L2CAP_MOVE_RSP_SIZE* = 4

type
  l2cap_move_cfm* {.packed.} = object
    icid*: uint16
    result*: uint16


const
  L2CAP_MOVE_CFM_SIZE* = 4

type
  l2cap_move_cfm_rsp* {.packed.} = object
    icid*: uint16


const
  L2CAP_MOVE_CFM_RSP_SIZE* = 2
