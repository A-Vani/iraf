include "../lib/apphotdef.h"
include "../lib/centerdef.h"
include "../lib/center.h"

# APCINIT - Procedure to initialize the centering structure.

procedure apcinit (ap, function, cbox, fwhmpsf, noise)

pointer	ap		# pointer to the apphot structure
int	function	# centering algorithm
real	cbox		# half width of centering box
real	fwhmpsf		# FWHM of the PSF
int	noise		# noise function

begin
	# Allocate space.
	call malloc (ap, LEN_APSTRUCT, TY_STRUCT)
	AP_IMNAME(ap) = EOS
	AP_CWX(ap) = INDEFR
	AP_CWY(ap) = INDEFR
	AP_WX(ap) = INDEFR
	AP_WY(ap) = INDEFR
	AP_SCALE(ap) = DEF_SCALE
	AP_FWHMPSF(ap) = fwhmpsf
	AP_POSITIVE(ap) = DEF_POSITIVE
	AP_DATAMIN(ap) = DEF_DATAMIN
	AP_DATAMAX(ap) = DEF_DATAMAX
	AP_EXPOSURE(ap) = EOS
	AP_ITIME(ap) = DEF_ITIME

	# Setup the noise structure.
	call ap_noisesetup (ap, noise)
	    
	# Initialize the centering parameters.
	call ap_ctrsetup (ap, function, cbox)

	# Display the options.
	call ap_dispsetup (ap)

	# Unused structures are set to null.
	AP_PSKY(ap) = NULL
	AP_PPSF(ap) = NULL
	AP_PPHOT(ap) = NULL
	AP_POLY(ap) = NULL
	AP_RPROF(ap) = NULL
end


# AP_CTRSETUP -- Procedure to setup the centering array parameters.

procedure ap_ctrsetup (ap, function, cbox)

pointer	ap		# pointer to apphot structure
int	function	# centering function
real	cbox		# radius of centering aperture

pointer	ctr

begin
	# Allocate space for the centering structure.
	call malloc (AP_PCENTER(ap), LEN_CENSTRUCT, TY_STRUCT)
	ctr = AP_PCENTER(ap)
	AP_CXCUR(ctr) = INDEFR
	AP_CYCUR(ctr) = INDEFR

	AP_CAPERT(ctr) = cbox
	AP_CENTERFUNCTION(ctr) = function
	switch (function) {
	case AP_CENTROID1D:
	    call strcpy ("centroid", AP_CSTRING(ctr), SZ_FNAME)
	case AP_GAUSS1D:
	    call strcpy ("gauss", AP_CSTRING(ctr), SZ_FNAME)
	case AP_NONE:
	    call strcpy ("none", AP_CSTRING(ctr), SZ_FNAME)
	case AP_OFILT1D:
	    call strcpy ("ofilter", AP_CSTRING(ctr), SZ_FNAME)
	default:
	    AP_CENTERFUNCTION(ctr) = DEF_CENTERFUNCTION
	    call strcpy ("centroid", AP_CSTRING(ctr), SZ_FNAME)
	}
	AP_MAXSHIFT(ctr) = DEF_MAXSHIFT
	AP_MINSNRATIO(ctr) = DEF_MINSNRATIO
	AP_CLEAN(ctr) = DEF_CLEAN
	AP_RCLEAN(ctr) = DEF_RCLEAN
	AP_RCLIP(ctr) = DEF_RCLIP
	AP_SIGMACLEAN(ctr) = DEF_CLEANSIGMA
	AP_CMAXITER(ctr) = DEF_CMAXITER

	AP_NCTRPIX(ctr) = 0
	AP_CTRPIX(ctr) = NULL
	AP_XCTRPIX(ctr) = NULL
	AP_YCTRPIX(ctr) = NULL

	AP_XCENTER(ctr) = INDEFR
	AP_YCENTER(ctr) = INDEFR
	AP_XERR(ctr) = INDEFR
	AP_YERR(ctr) = INDEFR
end
