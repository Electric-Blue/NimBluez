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

import bz_bluetooth
import bz_hci


type
  hci_request* = object
    ogf*: uint16
    ocf*: uint16
    event*: cint
    cparam*: pointer
    clen*: cint
    rparam*: pointer
    rlen*: cint

  hci_version* = object
    manufacturer*: uint16
    hci_ver*: uint8
    hci_rev*: uint16
    lmp_ver*: uint8
    lmp_subver*: uint16


proc hci_open_dev*(dev_id: cint): cint {.cdecl, importc: "hci_open_dev",
    dynlib: "libbluetooth.so".}
proc hci_close_dev*(dd: cint): cint {.cdecl, importc: "hci_close_dev",
                                      dynlib: "libbluetooth.so".}
proc hci_send_cmd*(dd: cint; ogf: uint16; ocf: uint16; plen: uint8;
                   param: pointer): cint {.cdecl, importc: "hci_send_cmd",
    dynlib: "libbluetooth.so".}
proc hci_send_req*(dd: cint; req: ptr hci_request; timeout: cint): cint {.cdecl,
    importc: "hci_send_req", dynlib: "libbluetooth.so".}
proc hci_create_connection*(dd: cint; bdaddr: ptr bdaddr_t; ptype: uint16;
                            clkoffset: uint16; rswitch: uint8;
                            handle: ptr uint16; to: cint): cint {.cdecl,
    importc: "hci_create_connection", dynlib: "libbluetooth.so".}
proc hci_disconnect*(dd: cint; handle: uint16; reason: uint8; to: cint): cint {.
    cdecl, importc: "hci_disconnect", dynlib: "libbluetooth.so".}
proc hci_inquiry*(dev_id: cint; len: cint; num_rsp: cint; lap: ptr uint8;
                  ii: ptr ptr inquiry_info; flags: clong): cint {.cdecl,
    importc: "hci_inquiry", dynlib: "libbluetooth.so".}
proc hci_devinfo*(dev_id: cint; di: ptr hci_dev_info): cint {.cdecl,
    importc: "hci_devinfo", dynlib: "libbluetooth.so".}
proc hci_devba*(dev_id: cint; bdaddr: ptr bdaddr_t): cint {.cdecl,
    importc: "hci_devba", dynlib: "libbluetooth.so".}
proc hci_devid*(str: cstring): cint {.cdecl, importc: "hci_devid",
                                      dynlib: "libbluetooth.so".}
proc hci_read_local_name*(dd: cint; len: cint; name: cstring; to: cint): cint {.
    cdecl, importc: "hci_read_local_name", dynlib: "libbluetooth.so".}
proc hci_write_local_name*(dd: cint; name: cstring; to: cint): cint {.cdecl,
    importc: "hci_write_local_name", dynlib: "libbluetooth.so".}
proc hci_read_remote_name*(dd: cint; bdaddr: ptr bdaddr_t; len: cint;
                           name: cstring; to: cint): cint {.cdecl,
    importc: "hci_read_remote_name", dynlib: "libbluetooth.so".}
proc hci_read_remote_name_with_clock_offset*(dd: cint; bdaddr: ptr bdaddr_t;
    pscan_rep_mode: uint8; clkoffset: uint16; len: cint; name: cstring;
    to: cint): cint {.cdecl, importc: "hci_read_remote_name_with_clock_offset",
                      dynlib: "libbluetooth.so".}
proc hci_read_remote_name_cancel*(dd: cint; bdaddr: ptr bdaddr_t; to: cint): cint {.
    cdecl, importc: "hci_read_remote_name_cancel", dynlib: "libbluetooth.so".}
proc hci_read_remote_version*(dd: cint; handle: uint16; ver: ptr hci_version;
                              to: cint): cint {.cdecl,
    importc: "hci_read_remote_version", dynlib: "libbluetooth.so".}
proc hci_read_remote_features*(dd: cint; handle: uint16;
                               features: ptr uint8; to: cint): cint {.cdecl,
    importc: "hci_read_remote_features", dynlib: "libbluetooth.so".}
proc hci_read_remote_ext_features*(dd: cint; handle: uint16; page: uint8;
                                   max_page: ptr uint8; features: ptr uint8;
                                   to: cint): cint {.cdecl,
    importc: "hci_read_remote_ext_features", dynlib: "libbluetooth.so".}
proc hci_read_clock_offset*(dd: cint; handle: uint16; clkoffset: ptr uint16;
                            to: cint): cint {.cdecl,
    importc: "hci_read_clock_offset", dynlib: "libbluetooth.so".}
proc hci_read_local_version*(dd: cint; ver: ptr hci_version; to: cint): cint {.
    cdecl, importc: "hci_read_local_version", dynlib: "libbluetooth.so".}
proc hci_read_local_commands*(dd: cint; commands: ptr uint8; to: cint): cint {.
    cdecl, importc: "hci_read_local_commands", dynlib: "libbluetooth.so".}
proc hci_read_local_features*(dd: cint; features: ptr uint8; to: cint): cint {.
    cdecl, importc: "hci_read_local_features", dynlib: "libbluetooth.so".}
proc hci_read_local_ext_features*(dd: cint; page: uint8;
                                  max_page: ptr uint8; features: ptr uint8;
                                  to: cint): cint {.cdecl,
    importc: "hci_read_local_ext_features", dynlib: "libbluetooth.so".}
proc hci_read_bd_addr*(dd: cint; bdaddr: ptr bdaddr_t; to: cint): cint {.cdecl,
    importc: "hci_read_bd_addr", dynlib: "libbluetooth.so".}
proc hci_read_class_of_dev*(dd: cint; cls: ptr uint8; to: cint): cint {.cdecl,
    importc: "hci_read_class_of_dev", dynlib: "libbluetooth.so".}
proc hci_write_class_of_dev*(dd: cint; cls: uint32; to: cint): cint {.cdecl,
    importc: "hci_write_class_of_dev", dynlib: "libbluetooth.so".}
proc hci_read_voice_setting*(dd: cint; vs: ptr uint16; to: cint): cint {.
    cdecl, importc: "hci_read_voice_setting", dynlib: "libbluetooth.so".}
proc hci_write_voice_setting*(dd: cint; vs: uint16; to: cint): cint {.cdecl,
    importc: "hci_write_voice_setting", dynlib: "libbluetooth.so".}
proc hci_read_current_iac_lap*(dd: cint; num_iac: ptr uint8; lap: ptr uint8;
                               to: cint): cint {.cdecl,
    importc: "hci_read_current_iac_lap", dynlib: "libbluetooth.so".}
proc hci_write_current_iac_lap*(dd: cint; num_iac: uint8; lap: ptr uint8;
                                to: cint): cint {.cdecl,
    importc: "hci_write_current_iac_lap", dynlib: "libbluetooth.so".}
proc hci_read_stored_link_key*(dd: cint; bdaddr: ptr bdaddr_t; all: uint8;
                               to: cint): cint {.cdecl,
    importc: "hci_read_stored_link_key", dynlib: "libbluetooth.so".}
proc hci_write_stored_link_key*(dd: cint; bdaddr: ptr bdaddr_t;
                                key: ptr uint8; to: cint): cint {.cdecl,
    importc: "hci_write_stored_link_key", dynlib: "libbluetooth.so".}
proc hci_delete_stored_link_key*(dd: cint; bdaddr: ptr bdaddr_t; all: uint8;
                                 to: cint): cint {.cdecl,
    importc: "hci_delete_stored_link_key", dynlib: "libbluetooth.so".}
proc hci_authenticate_link*(dd: cint; handle: uint16; to: cint): cint {.cdecl,
    importc: "hci_authenticate_link", dynlib: "libbluetooth.so".}
proc hci_encrypt_link*(dd: cint; handle: uint16; encrypt: uint8; to: cint): cint {.
    cdecl, importc: "hci_encrypt_link", dynlib: "libbluetooth.so".}
proc hci_change_link_key*(dd: cint; handle: uint16; to: cint): cint {.cdecl,
    importc: "hci_change_link_key", dynlib: "libbluetooth.so".}
proc hci_switch_role*(dd: cint; bdaddr: ptr bdaddr_t; role: uint8; to: cint): cint {.
    cdecl, importc: "hci_switch_role", dynlib: "libbluetooth.so".}
proc hci_park_mode*(dd: cint; handle: uint16; max_interval: uint16;
                    min_interval: uint16; to: cint): cint {.cdecl,
    importc: "hci_park_mode", dynlib: "libbluetooth.so".}
proc hci_exit_park_mode*(dd: cint; handle: uint16; to: cint): cint {.cdecl,
    importc: "hci_exit_park_mode", dynlib: "libbluetooth.so".}
proc hci_read_inquiry_scan_type*(dd: cint; `type`: ptr uint8; to: cint): cint {.
    cdecl, importc: "hci_read_inquiry_scan_type", dynlib: "libbluetooth.so".}
proc hci_write_inquiry_scan_type*(dd: cint; `type`: uint8; to: cint): cint {.
    cdecl, importc: "hci_write_inquiry_scan_type", dynlib: "libbluetooth.so".}
proc hci_read_inquiry_mode*(dd: cint; mode: ptr uint8; to: cint): cint {.
    cdecl, importc: "hci_read_inquiry_mode", dynlib: "libbluetooth.so".}
proc hci_write_inquiry_mode*(dd: cint; mode: uint8; to: cint): cint {.cdecl,
    importc: "hci_write_inquiry_mode", dynlib: "libbluetooth.so".}
proc hci_read_afh_mode*(dd: cint; mode: ptr uint8; to: cint): cint {.cdecl,
    importc: "hci_read_afh_mode", dynlib: "libbluetooth.so".}
proc hci_write_afh_mode*(dd: cint; mode: uint8; to: cint): cint {.cdecl,
    importc: "hci_write_afh_mode", dynlib: "libbluetooth.so".}
proc hci_read_ext_inquiry_response*(dd: cint; fec: ptr uint8;
                                    data: ptr uint8; to: cint): cint {.cdecl,
    importc: "hci_read_ext_inquiry_response", dynlib: "libbluetooth.so".}
proc hci_write_ext_inquiry_response*(dd: cint; fec: uint8; data: ptr uint8;
                                     to: cint): cint {.cdecl,
    importc: "hci_write_ext_inquiry_response", dynlib: "libbluetooth.so".}
proc hci_read_simple_pairing_mode*(dd: cint; mode: ptr uint8; to: cint): cint {.
    cdecl, importc: "hci_read_simple_pairing_mode", dynlib: "libbluetooth.so".}
proc hci_write_simple_pairing_mode*(dd: cint; mode: uint8; to: cint): cint {.
    cdecl, importc: "hci_write_simple_pairing_mode", dynlib: "libbluetooth.so".}
proc hci_read_local_oob_data*(dd: cint; hash: ptr uint8;
                              randomizer: ptr uint8; to: cint): cint {.cdecl,
    importc: "hci_read_local_oob_data", dynlib: "libbluetooth.so".}
proc hci_read_inquiry_transmit_power_level*(dd: cint; level: ptr int8;
    to: cint): cint {.cdecl, importc: "hci_read_inquiry_transmit_power_level",
                      dynlib: "libbluetooth.so".}
proc hci_write_inquiry_transmit_power_level*(dd: cint; level: int8; to: cint): cint {.
    cdecl, importc: "hci_write_inquiry_transmit_power_level",
    dynlib: "libbluetooth.so".}
proc hci_read_transmit_power_level*(dd: cint; handle: uint16; `type`: uint8;
                                    level: ptr int8; to: cint): cint {.cdecl,
    importc: "hci_read_transmit_power_level", dynlib: "libbluetooth.so".}
proc hci_read_link_policy*(dd: cint; handle: uint16; policy: ptr uint16;
                           to: cint): cint {.cdecl,
    importc: "hci_read_link_policy", dynlib: "libbluetooth.so".}
proc hci_write_link_policy*(dd: cint; handle: uint16; policy: uint16;
                            to: cint): cint {.cdecl,
    importc: "hci_write_link_policy", dynlib: "libbluetooth.so".}
proc hci_read_link_supervision_timeout*(dd: cint; handle: uint16;
                                        timeout: ptr uint16; to: cint): cint {.
    cdecl, importc: "hci_read_link_supervision_timeout", dynlib: "libbluetooth.so".}
proc hci_write_link_supervision_timeout*(dd: cint; handle: uint16;
    timeout: uint16; to: cint): cint {.cdecl,
    importc: "hci_write_link_supervision_timeout", dynlib: "libbluetooth.so".}
proc hci_set_afh_classification*(dd: cint; map: ptr uint8; to: cint): cint {.
    cdecl, importc: "hci_set_afh_classification", dynlib: "libbluetooth.so".}
proc hci_read_link_quality*(dd: cint; handle: uint16;
                            link_quality: ptr uint8; to: cint): cint {.cdecl,
    importc: "hci_read_link_quality", dynlib: "libbluetooth.so".}
proc hci_read_rssi*(dd: cint; handle: uint16; rssi: ptr int8; to: cint): cint {.
    cdecl, importc: "hci_read_rssi", dynlib: "libbluetooth.so".}
proc hci_read_afh_map*(dd: cint; handle: uint16; mode: ptr uint8;
                       map: ptr uint8; to: cint): cint {.cdecl,
    importc: "hci_read_afh_map", dynlib: "libbluetooth.so".}
proc hci_read_clock*(dd: cint; handle: uint16; which: uint8;
                     clock: ptr uint32; accuracy: ptr uint16; to: cint): cint {.
    cdecl, importc: "hci_read_clock", dynlib: "libbluetooth.so".}
proc hci_for_each_dev*(flag: cint; `func`: proc (dd: cint; dev_id: cint;
    arg: clong): cint {.cdecl.}; arg: clong): cint {.cdecl,
    importc: "hci_for_each_dev", dynlib: "libbluetooth.so".}
proc hci_get_route*(bdaddr: ptr bdaddr_t): cint {.cdecl,
    importc: "hci_get_route", dynlib: "libbluetooth.so".}
proc hci_dtypetostr*(`type`: cint): cstring {.cdecl, importc: "hci_dtypetostr",
    dynlib: "libbluetooth.so".}
proc hci_dflagstostr*(flags: uint32): cstring {.cdecl,
    importc: "hci_dflagstostr", dynlib: "libbluetooth.so".}
proc hci_ptypetostr*(ptype: cuint): cstring {.cdecl, importc: "hci_ptypetostr",
    dynlib: "libbluetooth.so".}
proc hci_strtoptype*(str: cstring; val: ptr cuint): cint {.cdecl,
    importc: "hci_strtoptype", dynlib: "libbluetooth.so".}
proc hci_scoptypetostr*(ptype: cuint): cstring {.cdecl,
    importc: "hci_scoptypetostr", dynlib: "libbluetooth.so".}
proc hci_strtoscoptype*(str: cstring; val: ptr cuint): cint {.cdecl,
    importc: "hci_strtoscoptype", dynlib: "libbluetooth.so".}
proc hci_lptostr*(ptype: cuint): cstring {.cdecl, importc: "hci_lptostr",
    dynlib: "libbluetooth.so".}
proc hci_strtolp*(str: cstring; val: ptr cuint): cint {.cdecl,
    importc: "hci_strtolp", dynlib: "libbluetooth.so".}
proc hci_lmtostr*(ptype: cuint): cstring {.cdecl, importc: "hci_lmtostr",
    dynlib: "libbluetooth.so".}
proc hci_strtolm*(str: cstring; val: ptr cuint): cint {.cdecl,
    importc: "hci_strtolm", dynlib: "libbluetooth.so".}
proc hci_cmdtostr*(cmd: cuint): cstring {.cdecl, importc: "hci_cmdtostr",
    dynlib: "libbluetooth.so".}
proc hci_commandstostr*(commands: ptr uint8; pref: cstring; width: cint): cstring {.
    cdecl, importc: "hci_commandstostr", dynlib: "libbluetooth.so".}
proc hci_vertostr*(ver: cuint): cstring {.cdecl, importc: "hci_vertostr",
    dynlib: "libbluetooth.so".}
proc hci_strtover*(str: cstring; ver: ptr cuint): cint {.cdecl,
    importc: "hci_strtover", dynlib: "libbluetooth.so".}
proc lmp_vertostr*(ver: cuint): cstring {.cdecl, importc: "lmp_vertostr",
    dynlib: "libbluetooth.so".}
proc lmp_strtover*(str: cstring; ver: ptr cuint): cint {.cdecl,
    importc: "lmp_strtover", dynlib: "libbluetooth.so".}
proc lmp_featurestostr*(features: ptr uint8; pref: cstring; width: cint): cstring {.
    cdecl, importc: "lmp_featurestostr", dynlib: "libbluetooth.so".}
proc hci_set_bit*(nr: cint; `addr`: pointer) {.inline, cdecl.} =
  cast[ptr uint32](cast[int](`addr`) + (nr shr 5))[] =
    uint32(int(cast[ptr uint32](cast[int](`addr`) + (nr shr 5))[]) or (1 shl (nr and 31)))

proc hci_clear_bit*(nr: cint; `addr`: pointer) {.inline, cdecl.} =
  cast[ptr uint32](cast[int](`addr`) + (nr shr 5))[] =
    uint32(int(cast[ptr uint32](cast[int](`addr`) + (nr shr 5))[]) and not (1 shl (nr and 31)))

proc hci_test_bit*(nr: cint; `addr`: pointer): cint {.inline, cdecl.} =
  return cint(int(cast[ptr uint32](cast[int](`addr`) + (nr shr 5))[]) and (1 shl (nr and 31)))

# HCI filter tools

proc hci_filter_clear*(f: ptr hci_filter) {.inline, cdecl.} =
  zeroMem(f, sizeof((f[])))

proc hci_filter_set_ptype*(t: cint; f: ptr hci_filter) {.inline, cdecl.} =
  hci_set_bit(if (t == HCI_VENDOR_PKT): 0 else: (t and HCI_FLT_TYPE_BITS),
              addr(f.type_mask))

proc hci_filter_clear_ptype*(t: cint; f: ptr hci_filter) {.inline, cdecl.} =
  hci_clear_bit(if (t == HCI_VENDOR_PKT): 0 else: (t and HCI_FLT_TYPE_BITS),
                addr(f.type_mask))

proc hci_filter_test_ptype*(t: cint; f: ptr hci_filter): cint {.inline, cdecl.} =
  return hci_test_bit(if (t == HCI_VENDOR_PKT): 0 else: (t and
      HCI_FLT_TYPE_BITS), addr(f.type_mask))

proc hci_filter_all_ptypes*(f: ptr hci_filter) {.inline, cdecl.} =
  f.type_mask = 0x000000FF

proc hci_filter_set_event*(e: cint; f: ptr hci_filter) {.inline, cdecl.} =
  hci_set_bit((e and HCI_FLT_EVENT_BITS), addr(f.event_mask))

proc hci_filter_clear_event*(e: cint; f: ptr hci_filter) {.inline, cdecl.} =
  hci_clear_bit((e and HCI_FLT_EVENT_BITS), addr(f.event_mask))

proc hci_filter_test_event*(e: cint; f: ptr hci_filter): cint {.inline, cdecl.} =
  return hci_test_bit((e and HCI_FLT_EVENT_BITS), addr(f.event_mask))

proc hci_filter_all_events*(f: ptr hci_filter) {.inline, cdecl.} =
  for i in low(f.event_mask)..high(f.event_mask):
    f.event_mask[i] = 0x000000FF

proc hci_filter_set_opcode*(opcode: uint16; f: ptr hci_filter) {.inline, cdecl.} =
  f.opcode = opcode

proc hci_filter_clear_opcode*(f: ptr hci_filter) {.inline, cdecl.} =
  f.opcode = 0

proc hci_filter_test_opcode*(opcode: uint16; f: ptr hci_filter): bool {.inline,
    cdecl.} =
  return int16(f.opcode) == int16(opcode)
