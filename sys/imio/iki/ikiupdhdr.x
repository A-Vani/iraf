# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include <syserr.h>
include <imhdr.h>
include	<imio.h>
include "iki.h"

# IKI_UPDHDR -- Update the image header.

procedure iki_updhdr (im)

pointer	im			# image descriptor
int	status
include	"iki.com"

begin
	call zcall2 (IKI_UPDHDR(IM_KERNEL(im)), im, status)
	if (status == ERR)
	    call syserrs (SYS_IKIUPDHDR, IM_NAME(im))
end
