# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include <math/iminterp.h>
include "im1interpdef.h"

# ASIEVAL -- This procedure finds the interpolated value assuming that
# x lands in the array, i.e. 1 <= x <= npts.

real procedure asieval (asi, x)

pointer	asi		# interpolator descriptor
real x			# x value

real value

begin
	switch (ASI_TYPE(asi))	{	# switch on interpolator type
	
	case II_NEAREST:
	    call ii_nearest (x, value, 1,
	    		    COEFF(ASI_COEFF(asi) + ASI_OFFSET(asi)))
	    return (value)

	case II_LINEAR:
	    call ii_linear (x, value, 1,
	    		   COEFF(ASI_COEFF(asi) + ASI_OFFSET(asi)))
	    return (value)

	case II_POLY3:
	    call ii_poly3 (x, value, 1, COEFF(ASI_COEFF(asi) + ASI_OFFSET(asi)))
	    return (value)

	case II_POLY5:
	    call ii_poly5 (x, value, 1, COEFF(ASI_COEFF(asi) + ASI_OFFSET(asi)))
	    return (value)

	case II_SPLINE3:
	    call ii_spline3 (x, value, 1,
	    		    COEFF(ASI_COEFF(asi) + ASI_OFFSET(asi)))
	    return (value)
	
	default:
	    call error (0, "ASIEVAL: Unknown interpolator type.")
	}
end
