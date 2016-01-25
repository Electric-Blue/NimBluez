#
#
#   BlueZ - Bluetooth protocol stack for Linux
#
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

import ioctl, bz_bluetooth

# RFCOMM defaults

const
  RFCOMM_DEFAULT_MTU* = 127
  RFCOMM_PSM* = 3

# RFCOMM socket address

type
  sockaddr_rc* = object
    rc_family*: uint16
    rc_bdaddr*: bdaddr_t
    rc_channel*: uint8


# RFCOMM socket options

const
  RFCOMM_CONNINFO* = 0x00000002

type
  rfcomm_conninfo* = object
    hci_handle*: uint16
    dev_class*: array[3, uint8]


const
  RFCOMM_LM* = 0x00000003
  RFCOMM_LM_MASTER* = 0x00000001
  RFCOMM_LM_AUTH* = 0x00000002
  RFCOMM_LM_ENCRYPT* = 0x00000004
  RFCOMM_LM_TRUSTED* = 0x00000008
  RFCOMM_LM_RELIABLE* = 0x00000010
  RFCOMM_LM_SECURE* = 0x00000020

# RFCOMM TTY support

const
  RFCOMM_MAX_DEV* = 256
  RFCOMMCREATEDEV* = IOW(ord('R'), 200, int)
  RFCOMMRELEASEDEV* = IOW(ord('R'), 201, int)
  RFCOMMGETDEVLIST* = IOR(ord('R'), 210, int)
  RFCOMMGETDEVINFO* = IOR(ord('R'), 211, int)

type
  rfcomm_dev_req* = object
    dev_id*: int16
    flags*: uint32
    src*: bdaddr_t
    dst*: bdaddr_t
    channel*: uint8


const
  RFCOMM_REUSE_DLC* = 0
  RFCOMM_RELEASE_ONHUP* = 1
  RFCOMM_HANGUP_NOW* = 2
  RFCOMM_TTY_ATTACHED* = 3

type
  rfcomm_dev_info* = object
    id*: int16
    flags*: uint32
    state*: uint16
    src*: bdaddr_t
    dst*: bdaddr_t
    channel*: uint8

  rfcomm_dev_list_req* = object
    dev_num*: uint16
    dev_info*: array[0, rfcomm_dev_info]

