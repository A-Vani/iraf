include "../lib/apphot.h"
include "../lib/noise.h"
include "../lib/center.h"
include "../lib/fitsky.h"

# AP_TMEASURE -- Procedure to measure the fluxes and effective areas of a set of
# apertures assuming a conical weighting function.

procedure ap_tmeasure (ap, im, wx, wy, c1, c2, l1, l2, aperts, sums, areas,
        naperts)

pointer	ap			# pointer to apphot structure
pointer	im			# pointer to image
real	wx, wy			# center of subraster
int	c1, c2			# column limits
int	l1, l2			# line limits
real	aperts[ARB]		# array of apertures
real	sums[ARB]		# array of sums
real	areas[ARB]		# aperture areas
int	naperts			# number of apertures

int	i, j, k, yindex, nx, positive
pointer	buf, sp, sump, sumpw
real	xc, yc, apmaxsq, fwhmpsf, skyval, varsky, dy2, r2, r, fctn
real	prof, var, weight, norm

int	apstati()
pointer	imgs2r()
real	apstatr()

begin
	# Initialize.
	call smark (sp)
	call salloc (sump, naperts, TY_REAL)
	call salloc (sumpw, naperts, TY_REAL)
	call aclrr (Memr[sump], naperts)
	call aclrr (Memr[sumpw], naperts)

	# Setup some apphot parameters.
	fwhmpsf = apstatr (ap, FWHMPSF) * apstatr (ap, SCALE)
	positive = apstati (ap, POSITIVE)
	if (positive == YES) {
	    skyval = apstatr (ap, SKY_MODE)
	    varsky = apstatr (ap, SKY_SIGMA) ** 2
	} else {
	    skyval = 0.0
	    varsky = (apstatr (ap, READNOISE) / apstatr (ap, EPADU)) ** 2
	}

	# Set up some array boundary parameters.
	nx = c2 - c1 + 1
	xc = wx - c1 + 1
	yc = wy - l1 + 1
	apmaxsq = (aperts[naperts] + 0.5) ** 2

	# Clear out the accumulaters
	call aclrr (sums, naperts)
	call aclrr (areas, naperts)

	# Loop over the pixels.
	do j = l1, l2 {
	    buf = imgs2r (im, c1, c2, j, j)
	    if (buf == NULL)
		return
	    yindex = j - l1 + 1
	    dy2 = (yindex - yc) ** 2
	    do i = 1, nx {
		r2 = (i - xc) ** 2 + dy2
		if (r2 > apmaxsq)
		    next
		var = abs (Memr[buf+i-1] - skyval) + varsky
		if (var <= 0.0)
		    next
		r = sqrt (r2)
		prof = max (1.0 - r / fwhmpsf, 0.0)
		if (prof <= 0.0)
		    next
		weight = prof / var
		r = r - 0.5
		do k = 1, naperts {
		    if (r > aperts[k])
			next
		    fctn = max (0.0, min (1.0, aperts[k] - r))
		    Memr[sump+k-1] = Memr[sump+k-1] + prof
		    Memr[sumpw+k-1] = Memr[sumpw+k-1] + prof * weight
		    sums[k] = sums[k] + weight * fctn * Memr[buf+i-1]
		    areas[k] = areas[k] + weight * fctn
		}
	    }
	}

	# Normalize.
	do k = 1, naperts {
	    if (Memr[sumpw+k-1] <= 0.0)
	        norm = 0.0
	    else
	        norm = Memr[sump+k-1] / Memr[sumpw+k-1]
	    sums[k] = sums[k] * norm
	    areas[k] = areas[k] * norm
	}

	call sfree (sp)
end
