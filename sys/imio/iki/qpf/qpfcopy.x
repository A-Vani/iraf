# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<error.h>
include	"qpf.h"

# QPF_COPY -- Copy an image.  A special operator is provided for fast, blind
# copies of entire images.

procedure qpf_copy (old_root, old_extn, new_root, new_extn, status)

char	old_root[ARB]		#I old image root name
char	old_extn[ARB]		#I old image extn
char	new_root[ARB]		#I new image root name
char	new_extn[ARB]		#I new extn
int	status			#O output status

pointer	sp
pointer	oldname, newname
errchk	qp_copy

begin
	call smark (sp)
	call salloc (oldname, SZ_PATHNAME, TY_CHAR)
	call salloc (newname, SZ_PATHNAME, TY_CHAR)

	# Get filename of old and new images.
	call iki_mkfname (old_root, old_extn, Memc[oldname], SZ_PATHNAME)
	call iki_mkfname (new_root, QPF_EXTN, Memc[newname], SZ_PATHNAME)

	# Copy the datafile.
	iferr (call qp_copy (Memc[oldname], Memc[newname])) {
	    call erract (EA_WARN)
	    status = ERR
	} else
	    status = OK

	call sfree (sp)
end
