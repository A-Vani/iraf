# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<mach.h>
include	<config.h>
include	"ki.h"

# KI_ENVRESET -- Update the value of an environment variable on all currently
# connected nodes.

procedure ki_envreset (name, value)

char	name[ARB]		# name of environment variable
char	value[ARB]		# value of environment variable

int	node, junk
pointer	sp, buf, op
int	gstrcpy(), ki_send()
include	"kii.com"
include	"kinode.com"
define	quit_ 91

begin
	call smark (sp)
	call salloc (buf, SZ_LINE, TY_CHAR)

	# Format the SET statement to be sent to each node.
	op = buf + gstrcpy ("set ", Memc[buf], SZ_LINE)
	op = op + gstrcpy (name, Memc[op], SZ_LINE - 4)
	Memc[op] = '=';  op = op + 1
	Memc[op] = '"';  op = op + 1
	op = op + gstrcpy (value, Memc[op], SZ_LINE - (op - buf))
	Memc[op] = '"';  op = op + 1
	Memc[op] = '\n';  op = op + 1
	Memc[op] = EOS

	# Transmit the SET statement to each node currently running a kernel
	# server process.  This is done without reading back a status value
	# to permit pipelining of multiple set environment packets.

	for (node=1;  node <= n_nnodes;  node=node+1) {
	    if (n_kschan[node] == NULL)
		next

	    # Set up control packet.
	    p_sbuflen = gstrcpy (Memc[buf], p_sbuf, SZ_SBUF)
	    p_arg[1] = p_sbuflen

	    # Transmit packet.
	    if (ki_send (node, KI_ENVINIT, 0) == ERR)
		goto quit_
	}

	call sfree (sp)
	return
quit_
	call zclsks (n_kschan[node], junk)
	n_kschan[node] = NULL
	call sfree (sp)
end
