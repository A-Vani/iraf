# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include <math/gsurfit.h>

include "gsurfitdef.h"

# GSRESTORE -- Procedure to restore the surface fit stored by GSSAVE
# to the surface descriptor for use by the evaluating routines. The
# surface parameters, surface type, xorder (or number of polynomial
# pieces in x), yorder (or number of polynomial pieces in y), xterms,
# xmin, xmax and ymin and ymax, are stored in the first
# eight elements of the real array fit, followed by the GS_NCOEFF(sf)
# surface coefficients. The coefficient of B(i,x) * B(j,y)
# is stored in element number 6 + (j - 1) * GS_NXCOEFF(sf) + i of the
# array fit.

procedure gsrestore (sf, fit)

pointer	sf		# surface descriptor
real	fit[ARB]	# array containing the surface parameters and
			# coefficients

int	surface_type, xorder, yorder
real	xmin, xmax, ymin, ymax	

begin
	# allocate space for the surface descriptor
	call calloc (sf, LEN_GSSTRUCT, TY_STRUCT)

	xorder = int (GS_SAVEXORDER(fit))
	if (xorder < 1)
	    call error (0, "GSRESTORE: Illegal x order.")
	yorder = int (GS_SAVEYORDER(fit))
	if (yorder < 1)
	    call error (0, "GSRESTORE: Illegal y order.")

	xmin = GS_SAVEXMIN(fit)
	xmax = GS_SAVEXMAX(fit)
	if (xmax <= xmin)
	    call error (0, "GSRESTORE: Illegal x range.")
	ymin = GS_SAVEYMIN(fit)
	ymax = GS_SAVEYMAX(fit)
	if (ymax <= ymin)
	    call error (0, "GSRESTORE: Illegal y range.")

	# set surface type dependent surface descriptor parameters
	surface_type = int (GS_SAVETYPE(fit))
	switch (surface_type) {
	case GS_LEGENDRE, GS_CHEBYSHEV, GS_POLYNOMIAL:
	    GS_NXCOEFF(sf) = xorder
	    GS_XORDER(sf) = xorder
	    GS_XMIN(sf) = xmin
	    GS_XMAX(sf) = xmax
	    GS_XRANGE(sf) = 2. / (xmax - xmin)
	    GS_XMAXMIN(sf) =  - (xmax + xmin) / 2.
	    GS_NYCOEFF(sf) = yorder
	    GS_YORDER(sf) = yorder
	    GS_YMIN(sf) = ymin
	    GS_YMAX(sf) = ymax
	    GS_YRANGE(sf) = 2. / (ymax - ymin)
	    GS_YMAXMIN(sf) =  - (ymax + ymin) / 2.
	    GS_XTERMS(sf) = GS_SAVEXTERMS(fit)
	    if (GS_XTERMS(sf) == NO)
		GS_NCOEFF(sf) = GS_NXCOEFF(sf) + GS_NYCOEFF(sf) - 1
	    else
		GS_NCOEFF(sf) = GS_NXCOEFF(sf) * GS_NYCOEFF(sf)
	default:
	    call error (0, "GSRESTORE: Unknown surface type.")
	}

	# set remaining curve parameters
	GS_TYPE(sf) = surface_type

	# allocate space for the coefficient array
	GS_XBASIS(sf) = NULL
	GS_YBASIS(sf) = NULL
	GS_MATRIX(sf) = NULL
	GS_CHOFAC(sf) = NULL
	GS_VECTOR(sf) = NULL
	GS_COEFF(sf) = NULL
	GS_WZ(sf) = NULL

	call malloc (GS_COEFF(sf), GS_NCOEFF(sf), TY_REAL)

	# restore coefficient array
	call amovr (fit[GS_SAVECOEFF+1], COEFF(GS_COEFF(sf)), GS_NCOEFF(sf))
end
