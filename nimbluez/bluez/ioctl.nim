# ioctl command encoding: 32 bits total, command in lower 16 bits,
#  size of the parameter structure in the lower 14 bits of the
#  upper 16 bits.
#  Encoding the size of the parameter structure in the ioctl request
#  is useful for catching programs compiled with old versions
#  and to avoid overwriting user space outside the user buffer area.
#  The highest 2 bits are reserved for indicating the ``access mode''.
#  NOTE: This limits the max parameter size to 16kB -1 !
#
#
#  The following is for compatibility across the various Linux
#  platforms.  The generic ioctl numbering scheme doesn't really enforce
#  a type field.  De facto, however, the top 8 bits of the lower 16
#  bits are indeed used as a type field, so we might just as well make
#  this explicit here.  Please be sure to use the decoding macros
#  below from now on.
#

{.deadCodeElim: on.}

const
  IOC_NRBITS* = 8
  IOC_TYPEBITS* = 8

#
#  Let any architecture override either of the following before
#  including this file.
#

const
  IOC_SIZEBITS* = 14
  IOC_DIRBITS* = 2

const
  IOC_NRMASK* = ((1 shl IOC_NRBITS) - 1)
  IOC_TYPEMASK* = ((1 shl IOC_TYPEBITS) - 1)
  IOC_SIZEMASK* = ((1 shl IOC_SIZEBITS) - 1)
  IOC_DIRMASK* = ((1 shl IOC_DIRBITS) - 1)
  IOC_NRSHIFT* = 0
  IOC_TYPESHIFT* = (IOC_NRSHIFT + IOC_NRBITS)
  IOC_SIZESHIFT* = (IOC_TYPESHIFT + IOC_TYPEBITS)
  IOC_DIRSHIFT* = (IOC_SIZESHIFT + IOC_SIZEBITS)

#
#  Direction bits, which any architecture can choose to override
#  before including this file.
#

const
  IOC_NONE* = 0
  IOC_WRITE* = 1
  IOC_READ* = 2

template IOC_TYPECHECK*(t: untyped): untyped =
  (sizeof((t)))

# used to create numbers

template IO*(`type`, nr: untyped): untyped =
  (((IOC_NONE) shl IOC_DIRSHIFT) or (((`type`)) shl IOC_TYPESHIFT) or
      (((nr)) shl IOC_NRSHIFT) or ((0) shl IOC_SIZESHIFT))

template IOR*(`type`, nr, size: untyped): untyped =
  (((IOC_READ) shl IOC_DIRSHIFT) or (((`type`)) shl IOC_TYPESHIFT) or
      (((nr)) shl IOC_NRSHIFT) or (((IOC_TYPECHECK(size))) shl IOC_SIZESHIFT))

template IOW*(`type`, nr, size: untyped): untyped =
  (((IOC_WRITE) shl IOC_DIRSHIFT) or (((`type`)) shl IOC_TYPESHIFT) or
      (((nr)) shl IOC_NRSHIFT) or (((IOC_TYPECHECK(size))) shl IOC_SIZESHIFT))

template IOWR*(`type`, nr, size: untyped): untyped =
  (((IOC_READ or IOC_WRITE) shl IOC_DIRSHIFT) or
      (((`type`)) shl IOC_TYPESHIFT) or (((nr)) shl IOC_NRSHIFT) or
      (((IOC_TYPECHECK(size))) shl IOC_SIZESHIFT))

template IOR_BAD*(`type`, nr, size: untyped): untyped =
  (((IOC_READ) shl IOC_DIRSHIFT) or (((`type`)) shl IOC_TYPESHIFT) or
      (((nr)) shl IOC_NRSHIFT) or ((sizeof((size))) shl IOC_SIZESHIFT))

template IOW_BAD*(`type`, nr, size: untyped): untyped =
  (((IOC_WRITE) shl IOC_DIRSHIFT) or (((`type`)) shl IOC_TYPESHIFT) or
      (((nr)) shl IOC_NRSHIFT) or ((sizeof((size))) shl IOC_SIZESHIFT))

template IOWR_BAD*(`type`, nr, size: untyped): untyped =
  (((IOC_READ or IOC_WRITE) shl IOC_DIRSHIFT) or
      (((`type`)) shl IOC_TYPESHIFT) or (((nr)) shl IOC_NRSHIFT) or
      ((sizeof((size))) shl IOC_SIZESHIFT))

# used to decode ioctl numbers..

template IOC_DIR*(nr: untyped): untyped =
  (((nr) shr IOC_DIRSHIFT) and IOC_DIRMASK)

template IOC_TYPE*(nr: untyped): untyped =
  (((nr) shr IOC_TYPESHIFT) and IOC_TYPEMASK)

template IOC_NR*(nr: untyped): untyped =
  (((nr) shr IOC_NRSHIFT) and IOC_NRMASK)

template IOC_SIZE*(nr: untyped): untyped =
  (((nr) shr IOC_SIZESHIFT) and IOC_SIZEMASK)

# ...and for the drivers/sound files...

const
  IOC_IN* = (IOC_WRITE shl IOC_DIRSHIFT)
  IOC_OUT* = (IOC_READ shl IOC_DIRSHIFT)
  IOC_INOUT* = ((IOC_WRITE or IOC_READ) shl IOC_DIRSHIFT)
  IOCSIZE_MASK_S* = (IOC_SIZEMASK shl IOC_SIZESHIFT)
  IOCSIZE_SHIFT_S* = (IOC_SIZESHIFT)
