# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include <gki.h>
include	<gset.h>
include	"sgi.h"

# SGI_RESET -- Reset the state of the transform common, i.e., in response to
# a clear or a cancel.  Initialize all attribute packets to their default
# values and set the current state of the device to undefined, forcing the
# device state to be reset when the next output instruction is executed.

procedure sgi_reset()

pointer	pl, pm, fa, tx
include	"sgi.com"

begin
	# Set pointers to attribute substructures.
	pl = SGI_PLAP(g_kt)
	pm = SGI_PMAP(g_kt)
	fa = SGI_FAAP(g_kt)
	tx = SGI_TXAP(g_kt)

	# Initialize the attribute packets.
	PL_LTYPE(pl)	= 1
	PL_WIDTH(pl)	= GKI_PACKREAL(1.)
	PL_COLOR(pl)	= 1
	PM_LTYPE(pm)	= 1
	PM_WIDTH(pm)	= GKI_PACKREAL(1.)
	PM_COLOR(pm)	= 1
	FA_STYLE(fa)	= 1
	FA_COLOR(fa)	= 1
	TX_UP(tx)	= 90
	TX_SIZE(tx)	= GKI_PACKREAL(1.)
	TX_PATH(tx)	= GT_RIGHT
	TX_HJUSTIFY(tx)	= GT_LEFT
	TX_VJUSTIFY(tx)	= GT_BOTTOM
	TX_FONT(tx)	= GT_ROMAN
	TX_COLOR(tx)	= 1
	TX_SPACING(tx)	= 0.0

	# Set the device attributes to undefined, forcing them to be reset
	# when the next output instruction is executed.

	SGI_TYPE(g_kt)		= -1
	SGI_WIDTH(g_kt)		= -1
	SGI_COLOR(g_kt)		= -1
	SGI_TXSIZE(g_kt)	= -1
	SGI_TXFONT(g_kt)	= -1
end
