include <gset.h>
include <pkg/gtools.h>
include <math.h>
include "../lib/apphot.h"
include "../lib/noise.h"
include "../lib/display.h"
include "../lib/phot.h"
include "../lib/fitsky.h"
include "../lib/center.h"

define	CRADIUS	3
define	RADIUS	15.0

# AP_RADSETUP -- Procedure to set up phot interactively using a radial profile
# plot of a bright star.

procedure ap_radsetup (ap, im, wx, wy, gd, out, stid)

pointer	ap			# pointer to apphot structure
pointer	im			# pointer to the IRAF image
real	wx, wy			# cursor coordinates
pointer	gd			# pointer to graphics stream
int	out			# output file descriptor
int	stid			# output file sequence number

int	nx, ny, nsky, cier, sier, pier, lenbuf
pointer	gt, sp, r, skypix, coords, str
real	xcenter, ycenter, xc, yc, radius, rmin, rmax, imin, imax
real	u1, u2, v1, v2, x1, x2, y1, y2
real	fwhmpsf, capert, annulus, dannulus,  sigma3, threshold

int	ap_skypix(), nscan(), scan(), apfitcenter()
int	apfitsky(), apwmag(), apstati()
pointer	ap_gtinit()
real	apstatr(), ap_cfwhmpsf(), ap_ccapert(), ap_cannulus(), ap_cdannulus()
real	ap_csigma(), ap_ccthresh()

begin
	# Check for open graphics stream
	if (gd == NULL)
	    return
	call greactivate (gd, 0)
	call gclear (gd)

	# Get a rough value for the center.
	call ap_ictr (im, wx, wy, CRADIUS, apstati (ap, POSITIVE), xcenter,
	    ycenter)

	# Compute the extraction box.
	call printf ("Half width of extraction box (%4.1f) pixels:")
	    call pargr (RADIUS)
	call flush (STDOUT)
	if (scan () == EOF)
	    radius = RADIUS
	else {
	    call gargr (radius)
	    if (nscan () < 1)
	        radius = RADIUS
	}

	# Initialize.
	lenbuf = PI * radius * (radius + 1.0)
	call smark (sp)
	call salloc (str, SZ_LINE, TY_CHAR)
	call salloc (r, lenbuf, TY_REAL)
	call salloc (skypix, lenbuf, TY_REAL)
	call salloc (coords, lenbuf, TY_INT)

	# Fetch the sky pixels and reset to original sky annuli.
	nsky = ap_skypix (im, xcenter, ycenter, 0.0, radius, Memr[skypix],
	    Memi[coords], xc, yc, nx, ny)
	if (nsky <= 0) {
	    call gdeactivate (gd, 0)
	    return
	}

	# Compute the radius values and intensity values.
	call ap_xytor (Memi[coords], Memr[r], nsky, xc, yc, nx)
	call alimr (Memr[r], nsky, rmin, rmax)
	call alimr (Memr[skypix], nsky, imin, imax)

	# Store the viewport and window coordinates.
	call ggview (gd, u1, u2, v1, v2)
	call ggwind (gd, x1, x2, y1, y2)

	# Plot the radial profiles.
	call apstats (ap, IMNAME, Memc[str], SZ_FNAME)
	gt = ap_gtinit (Memc[str], xcenter, ycenter)
	call ap_rset (gd, gt, 0.0, rmax, imin, imax, apstatr (ap, SCALE))
	call ap_plotrad (gd, gt, Memr[r], Memr[skypix], nsky, "plus")

	# Mark the FWHM of the PSF on the plot.
	fwhmpsf = ap_cfwhmpsf (ap, gd, rmin, rmax, imin, imax)

	# Mark the centering aperture on the plot.
	capert = ap_ccapert (ap, gd, rmin, rmax, imin, imax)

	# Mark the inner sky radius.
	annulus = ap_cannulus (ap, gd, rmin, rmax, imin, imax)

	# Mark the outer sky radius.
	dannulus = ap_cdannulus (ap, gd, annulus, rmin, rmax, imin, imax)

	# Estimate the mean sky.
	sigma3 = ap_csigma (ap, gd, rmin, rmax, imin, imax)

	# Estimate the minimum (maximum) sky level.
	threshold = ap_ccthresh (ap, gd, rmin, rmax, imin, imax)

	# Mark the apertures.
	call ap_caper (ap, gd, Memc[str], rmin, rmax, imin, imax)

	# Interactive setup is complete.
	call printf (
	    "Interactive setup is complete. Type w to save parameters.\n")

	# Update the important parameters.
	call apsetr (ap, FWHMPSF, fwhmpsf)
	call apsetr (ap, CAPERT, capert)
	call apsetr (ap, ANNULUS, annulus)
	call apsetr (ap, DANNULUS, dannulus)
	call apsetr (ap, CTHRESHOLD, threshold)
	if (! IS_INDEFR (sigma3))
	    sigma3 = sigma3 / 3.0
	call apsetr (ap, SKYSIGMA, sigma3)
	if (Memc[str] != EOS)
	    call apsets (ap, APERTS, Memc[str])

	# Update the database file.
	if (out != NULL && stid > 1) {
	    call ap_rparam (out, KY_FWHMPSF, apstatr (ap, FWHMPSF),
		UN_FWHMPSF, "full width half maximum of the psf")
	    call ap_rparam (out, KY_CAPERT, 2.0 * apstatr (ap, CAPERT),
		UN_CAPERT, "centering box width")
	    call ap_rparam (out, KY_ANNULUS, apstatr (ap, ANNULUS),
		UN_ANNULUS, "inner radius of the sky annulus")
	    call ap_rparam (out, KY_DANNULUS, apstatr (ap, DANNULUS),
	        UN_DANNULUS, "width of the sky annulus")
	    call ap_rparam (out, KY_CTHRESHOLD, apstatr (ap, CTHRESHOLD),
		UN_CTHRESHOLD, "threshold for centering")
	    call ap_rparam (out, KY_SKYSIGMA, apstatr (ap, SKYSIGMA),
		UN_SKYSIGMA, "standard deviation of 1 sky pixel")
	    call apstats (ap, APERTS, Memc[str], SZ_LINE)
	    call ap_sparam (out, KY_APERTS, Memc[str], UN_APERTS,
		"list of apertures")
	}

	# Restore the viewport and window coordinates.
	call gsview (gd, u1, u2, v1, v2)
	call gswind (gd, x1, x2, y1, y2)

	call gdeactivate (gd, 0)
	call ap_gtfree (gt)
	call sfree (sp)

	# Compute and print the answer.
	cier = apfitcenter (ap, im, xcenter, ycenter)
	if (! IS_INDEFR (apstatr (ap, XCENTER)) &&
	    ! IS_INDEFR (apstatr (ap, YCENTER)))
	    sier = apfitsky (ap, im, apstatr (ap, XCENTER), apstatr (ap,
	        YCENTER), NULL, gd)
	if (! IS_INDEFR (apstatr (ap, SKY_MODE)))
	    pier = apwmag (ap, im, apstatr (ap, XCENTER), apstatr (ap,
		YCENTER), apstati (ap, POSITIVE), apstatr (ap, SKY_MODE),
		apstatr (ap, SKY_SIGMA), apstati (ap, NSKY))
	call appplot (ap, im, 0, cier, sier, pier, gd, apstati (ap, RADPLOTS))
	call ap_qpmag (ap, cier, sier, pier)
end
