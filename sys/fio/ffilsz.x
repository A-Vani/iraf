# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<mach.h>
include	<config.h>
include	<fio.h>

# FFILSZ -- Return file size in chars.  When first called, the status
# z-routine for the channel is called to get the file size.  Thereafter,
# FIO keeps track of the file size.

long procedure ffilsz (fd)

int	fd
long	file_size
include	<fio.com>

begin
	fp = fiodes[fd]
	UPDATE_IOP(fd)					# update i/o pointers

	if (FTYPE(fp) == TEXT_FILE) {			# don't keep track
	    call zcall3 (ZSTTTX(fp), FCHAN(fp), FSTT_FILSIZE, file_size)
	    file_size = file_size + (otop[fd] - bufptr[fd])

	} else {
	    # Call channel status z-routine to get file size if this is the
	    # first request.  Thereafter, FIO keeps track of file size.
	    # Beware that FILSIZE (updated by AWRITE or by us) does not
	    # necessarily include data just recently written into the current
	    # buffer.

	    if (FILSIZE(fp) < 0) {
		call zcall3 (ZSTTBF(fp), FCHAN(fp), FSTT_FILSIZE, file_size)
		file_size = (file_size + SZB_CHAR-1) / SZB_CHAR
	    } else
		file_size = FILSIZE(fp)

	    # If writing at EOF (or first block of a new file), and the buffer
	    # has not yet been flushed, file size is the offset of the file
	    # buffer plus the number of valid chars in the buffer.

	    if (BUF_MODIFIED(fd))
		file_size = max (file_size,
		    boffset[fd] + (itop[fd] - bufptr[fd]))
	}

	FILSIZE(fp) = file_size				# update fildes
	return (file_size)
end
