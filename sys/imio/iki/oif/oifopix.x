# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<syserr.h>
include	<config.h>
include	<imhdr.h>
include	<imio.h>
include	"oif.h"

# OIF_OPIX -- Open (or create) the pixel storage file.  If the image header file
# is `image.imh' the associated pixel storage file will be `imdir$image.pix',
# or some variation thereon should a collision occur.  The environment variable
# IMDIR controls where the pixfile will be placed.  The following classes of
# values are provided:
#
#	path		Put pixfile in named absolute directory regardless of
#			    where the header file is.
#	./		Put pixfile in the current directory at image creation
#			    time (special case of previous case).
#	HDR$		Put pixfile in the same directory as the header file.
#	HDR$subdir/	Put pixfiles in the subdirectory `subdir' of the
#			    directory containing the header file.  IMIO will
#			    create the subdirectory if necessary.

procedure oif_opix (im, status)

pointer	im				# image descriptor
int	status				# return status

long	pixoff
int	nchars, pfd, blklen
pointer	sp, pixhdr, pixfile
bool	strne()
int	open(), read(), fdevblk()
errchk	open, read, falloc, fdevblk
errchk	imioff, oif_wphdr, oif_mkpixfname, oif_gpixfname

begin
	status = OK
	if (IM_PFD(im) != NULL)
	    return

	call smark (sp)
	call salloc (pixhdr, LEN_IMDES + LEN_PIXHDR, TY_STRUCT)
	call salloc (pixfile, SZ_PATHNAME, TY_CHAR)

	switch (IM_ACMODE(im)) {
	case READ_ONLY, READ_WRITE, WRITE_ONLY, APPEND:
	    call oif_gpixfname (IM_PIXFILE(im), IM_HDRFILE(im), Memc[pixfile],
		SZ_PATHNAME)
	    pfd = open (Memc[pixfile], IM_ACMODE(im), STATIC_FILE)
	    call seek (pfd, BOFL)

	    nchars = LEN_PIXHDR * SZ_STRUCT
	    if (read (pfd, IM_MAGIC(pixhdr), nchars) < nchars)
		call imerr (IM_NAME(im), SYS_IMRDPIXFILE)
	    else if (strne (IM_MAGIC(pixhdr), "impix"))
		call imerr (IM_NAME(im), SYS_IMMAGOPSF)

	case NEW_COPY, NEW_FILE, TEMP_FILE:
	    # Generate the pixel file name.
	    call oif_mkpixfname (im, Memc[pixfile], SZ_PATHNAME)

	    # Compute the offset to the pixels in the pixfile.  Allow space
	    # for the pixhdr pixel storage file header and start the pixels
	    # on the next device block boundary.

	    blklen = fdevblk (Memc[pixfile])
	    pixoff = LEN_PIXHDR * SZ_STRUCT
	    call imalign (pixoff, blklen)

	    # Call IMIO to initialize the physical dimensions of the image
	    # and the absolute file offsets of the major components of the
	    # pixel storage file.

	    call imioff (im, pixoff, COMPRESS, blklen)

	    # Open the new pixel storage file (preallocate space if
	    # enabled on local system).  Save the physical pathname of
	    # the pixfile in the image header, in case "imdir$" changes.

	    if (IM_FALLOC == YES) {
		call falloc (Memc[pixfile], IM_HGMOFF(im) - 1)
		pfd = open (Memc[pixfile], READ_WRITE, STATIC_FILE)
	    } else
		pfd = open (Memc[pixfile], NEW_FILE, BINARY_FILE)

	    # Write small header into pixel storage file.  Allows detection of
	    # headerless pixfiles, and reconstruction of header if it gets lost.

	    call oif_wphdr (pfd, im, IM_HDRFILE(im))

	default:
	    call imerr (IM_NAME(im), SYS_IMACMODE)
	}

	IM_PFD(im) = pfd
	call sfree (sp)
end
