include	<mach.h>
include	"epix.h"
 
# EP_SEARCH -- Search input data for maximum or minimum pixel in search radius.
# Return the new aperture positions.  The magnitude of the search radius
# defines the range to be searched (bounded by the raster dimension) and
# the sign of the radius determines whether a minimum or maximum is sought.
 
procedure ep_search (ep, data, nx, ny, ap, xa, ya, xb, yb)
 
pointer	ep			# EPIX pointer
real	data[nx,ny]		# Subraster
int	nx, ny			# Subraster size
int	ap			# Aperture type
int	xa, ya, xb, yb		# Aperture (initial and final)
 
real	xc, yc, dx, dy, search2, dj2, r2, dmax
int	i, j, i1, i2, j1, j2, imax, jmax
 
begin
	if (EP_SEARCH(ep) == 0.)
	    return
 
	xa = xa - EP_X1(ep) + 1
	xb = xb - EP_X1(ep) + 1
	xc = (xa + xb) / 2.
	dx = abs (xb - xa) / 2.
 
	ya = ya - EP_Y1(ep) + 1
	yb = yb - EP_Y1(ep) + 1
	yc = (ya + yb) / 2.
	dy = abs (yb - ya) / 2.
 
	if (EP_SEARCH(ep) > 0.) {
	    i1 = max (1., min (xa, xb) - EP_SEARCH(ep)) + dx
	    i2 = min (real (nx), max (xa, xb) + EP_SEARCH(ep)) - dx
	    j1 = max (1., min (ya, yb) - EP_SEARCH(ep)) + dy
	    j2 = min (real (ny), max (ya, yb) + EP_SEARCH(ep)) - dy
	    dmax = -MAX_REAL
	} else {
	    i1 = max (1., min (xa, xb) + EP_SEARCH(ep)) + dx
	    i2 = min (real (nx), max (xa, xb) - EP_SEARCH(ep)) - dx
	    j1 = max (1., min (ya, yb) + EP_SEARCH(ep)) + dy
	    j2 = min (real (ny), max (ya, yb) - EP_SEARCH(ep)) - dy
	    dmax = MAX_REAL
	}
 
	switch (ap) {
	case 1:
	    search2 = EP_SEARCH(ep) ** 2
	    do j = j1, j2 {
	        dj2 = (j - yc) ** 2
	        do i = i1, i2 {
		    r2 = dj2 + (i - xc) ** 2
		    if (r2 > search2)
		        next
 
		    if (EP_SEARCH(ep) > 0.) {
		        if (data[i,j] > dmax) {
		            dmax = data[i,j]
		            imax = i
		            jmax = j
		        }
		    } else {
		        if (data[i,j] < dmax) {
		            dmax = data[i,j]
		            imax = i
		            jmax = j
		        }
		    }
	        }
	    }
	default:
	    do j = j1, j2 {
	        do i = i1, i2 {
		    if (EP_SEARCH(ep) > 0.) {
		        if (data[i,j] > dmax) {
		            dmax = data[i,j]
		            imax = i
		            jmax = j
		        }
		    } else {
		        if (data[i,j] < dmax) {
		            dmax = data[i,j]
		            imax = i
		            jmax = j
		        }
		    }
		}
	    }
	}
 
	xa = xa + (imax - xc) + EP_X1(ep) - 1
	xb = xb + (imax - xc) + EP_X1(ep) - 1
	ya = ya + (jmax - yc) + EP_Y1(ep) - 1
	yb = yb + (jmax - yc) + EP_Y1(ep) - 1
end
