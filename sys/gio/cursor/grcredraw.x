# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<gio.h>
include	"grc.h"

# GRC_REDRAW -- Redraw the screen, and, if the "axes" flag is set, draw the axes
# of the plot.

procedure grc_redraw (rc, stream, sx, sy)

pointer	rc			# rcursor descriptor
int	stream			# graphics stream
real	sx, sy			# screen coords of cursor

begin
	call gtr_redraw (stream)
	if (RC_AXES(rc) == YES)
	    call grc_axes (stream, sx, sy)
end
