# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include <imhdr.h>
include <pmset.h>
include	<plio.h>

# PM_ROP -- Perform a rasterop operation from the source mask to the
# destination mask at the given offsets.  The source and destination need
# not be the same size or dimensionality, but out of bounds references are
# not permitted.  If the source is of lesser dimensionality than the
# indicated section of the destination, then the source will be rewound
# and reread as necessary to operate upon the entire destination subregion,
# e.g., a line source mask may be applied to successive lines of a plane,
# or a plane mask may be applied to successive planes of a 3D mask.
# The source and destination masks may be the same if desired, but if the 
# source and destination regions overlap feedback may occur (this could be
# fixed).  With some rasterops, e.g, PIX_SET or PIX_CLR, no source mask is
# required, and pm_src=NULL is permitted.

procedure pm_rop (pm_src, vs_src, pm_dst, vs_dst, vn, rop)

pointer	pm_src			#I source mask or NULL
long	vs_src[PM_MAXDIM]	#I start vector in source mask
pointer	pm_dst			#I destination mask (required)
long	vs_dst[PM_MAXDIM]	#I start vector in destination mask
long	vn[PM_MAXDIM]		#I vector giving subregion size
long	rop			#I rasterop

int	i
include	"pmio.com"

begin
	if (PM_MAPXY(pm_src) == YES || PM_MAPXY(pm_dst) == YES) {
	    call imaplv (PM_REFIM(pm_src), vs_src, v1, PM_MAXDIM)
	    call aaddl (vs_src, vn, v2, PM_MAXDIM)
	    call aminl (v2, IM_LEN(PM_REFIM(pm_src),1), v2, PM_MAXDIM)
	    call imaplv (PM_REFIM(pm_src), v2, v3, PM_MAXDIM)
	    call aminl (v1, v3, v1, PM_MAXDIM)

	    call imaplv (PM_REFIM(pm_dst), vs_dst, v2, PM_MAXDIM)
	    call aaddl (vs_dst, vn, v3, PM_MAXDIM)
	    call imaplv (PM_REFIM(pm_dst), v3, v4, PM_MAXDIM)

	    do i = 1, PM_MAXDIM
		if (v2[i] > v4[i]) {
		    v3[i] = v2[i] - v4[i] + 1
		    v2[i] = v4[i]
		} else
		    v3[i] = v4[i] - v2[i] + 1

	    call pl_rop (pm_src, v1, pm_dst, v2, v3, rop)

	} else
	    call pl_rop (pm_src, vs_src, pm_dst, vs_dst, vn, rop)
end
