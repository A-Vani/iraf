# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include <math/iminterp.h>
include "im1interpdef.h"

define	TEMP	Memr[$1]

# ASIFIT -- fit interpolant to data

procedure asifit (asi, datain, npix)

pointer	asi		# interpolant descriptor
real	datain[ARB]	# data array
int	npix		# nunber of data points

int	i
pointer	c0ptr, cdataptr, cnptr, temp

begin
	# check data array for size
	# allocate space for the coefficient array

	switch (ASI_TYPE(asi)) {

	case II_SPLINE3:
	    if (npix < 4)
		call error (0, "ASIFIT: too few points for SPLINE3")
	    else {
		ASI_NCOEFF(asi) = npix + 3
		ASI_OFFSET(asi) = 1
		if (ASI_COEFF(asi) != NULL) {
		    call mfree (ASI_COEFF(asi), TY_REAL)
		}
		call malloc (ASI_COEFF(asi), ASI_NCOEFF(asi), TY_REAL)
		call malloc (temp, ASI_NCOEFF(asi), TY_REAL)
	    }

	case II_POLY5:
	    if (npix < 6)
		call error (0,"ASIFIT: too few points for POLY5")
	    else {
		ASI_NCOEFF(asi) = npix + 5
		ASI_OFFSET(asi) = 2
		if (ASI_COEFF(asi) != NULL)
		    call mfree (ASI_COEFF(asi), TY_REAL)
		call malloc (ASI_COEFF(asi), ASI_NCOEFF(asi), TY_REAL)
	    }

	case II_POLY3:
	    if (npix < 4)
		call error (0, "ASIFIT: too few points for POLY3")
	    else {
		ASI_NCOEFF(asi) = npix + 3
		ASI_OFFSET(asi) = 1
		if (ASI_COEFF(asi) != NULL)
		    call mfree (ASI_COEFF(asi), TY_REAL)
		call malloc (ASI_COEFF(asi), ASI_NCOEFF(asi), TY_REAL)
	    }

	case II_LINEAR:
	    if (npix < 2)
		call error (0, "ASIFIT: too few points for LINEAR")
	    else {
		ASI_NCOEFF(asi) = npix + 1
		ASI_OFFSET(asi) = 0
		if (ASI_COEFF(asi) != NULL)
		    call mfree (ASI_COEFF(asi), TY_REAL)
	        call malloc (ASI_COEFF(asi), ASI_NCOEFF(asi), TY_REAL)
	    }

	default:
	    if (npix < 1)
		call error (0," ASIFIT: too few points for NEAREST")
	    else {
		ASI_NCOEFF(asi) = npix
		ASI_OFFSET(asi) = 0
		if (ASI_COEFF(asi) != NULL)
		    call mfree (ASI_COEFF(asi), TY_REAL)
		call malloc (ASI_COEFF(asi), ASI_NCOEFF(asi), TY_REAL)
	    }

	}


	# define the pointers
	# (c0ptr + 1) points to first element in coefficient array
	# (cdataptr + 1) points to first data element in coefficient array
	# (cnptr + 1) points to the first element after the last data point in
	# coefficient array

	c0ptr = ASI_COEFF(asi) - 1
	cdataptr = ASI_COEFF(asi) - 1 + ASI_OFFSET(asi)
	cnptr = cdataptr + npix

	# put data into interpolant structure
	do i = 1, npix 
	    COEFF(cdataptr + i) = datain[i]


	# specify end conditions
	switch (ASI_TYPE(asi)) {

	case II_SPLINE3:
	    # specify natural end conditions - second deriv. zero
	    COEFF(c0ptr + 1) = 0.
	    COEFF(cnptr + 1) = 0.
	    COEFF(cnptr + 2) = 0.	# if x = npts

	    # fit spline - generate b-spline coefficients.
	    call ii_spline (COEFF(ASI_COEFF(asi)), TEMP(temp), npix)
	    call mfree (temp, TY_REAL)

	case II_NEAREST:
	    # no end conditions required

	case II_LINEAR:
	    COEFF(cnptr + 1) = 2. * COEFF(cdataptr + npix) -	# if x = npts
	    		       COEFF(cdataptr + npix - 1)

	case II_POLY3:
	    COEFF(c0ptr + 1) = 2. * COEFF(cdataptr + 1) - COEFF(cdataptr + 2) 
	    COEFF(cnptr + 1) = 2. * COEFF(cdataptr + npix) -
	    		       COEFF(cdataptr + npix - 1)
	    COEFF(cnptr + 2) = 2. * COEFF(cdataptr + npix) -
	    		       COEFF(cdataptr + npix - 2) 

	case II_POLY5:
	    COEFF(c0ptr + 1) = 2. * COEFF(cdataptr + 1) - COEFF(cdataptr + 3)
	    COEFF(c0ptr + 2) = 2. * COEFF(cdataptr + 1) - COEFF(cdataptr + 2)
	    COEFF(cnptr + 1) = 2. * COEFF(cdataptr + npix) -
	    		       COEFF(cdataptr + npix - 1)
	    COEFF(cnptr + 2) = 2. * COEFF(cdataptr + npix) -
	    		       COEFF(cdataptr + npix - 2)
	    COEFF(cnptr + 3) = 2. * COEFF(cdataptr + npix) -
	    		       COEFF(cdataptr + npix - 3)
	}
end
