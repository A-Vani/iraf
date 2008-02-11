# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<mach.h>

# AHGM -- Accumulate the histogram of the input vector.  The output vector
# HGM (the histogram) should be cleared prior to the first call.

procedure ahgml (data, npix, hgm, nbins, z1, z2)

long 	data[ARB]		# data vector
size_t	npix			# number of pixels
int	hgm[ARB]		# output histogram
size_t	nbins			# number of bins in histogram
long	z1, z2			# greyscale values of first and last bins

long	z
real	dz
size_t	bin, i

begin
	dz = real (nbins - 1) / real (z2 - z1)
	if (abs (dz - 1.0) < (EPSILONR * 2.0)) {
	    do i = 1, npix {
		z = data[i]
		if (z >= z1 && z <= z2) {
		    bin = z - z1
		    bin = bin + 1
		    hgm[bin] = hgm[bin] + 1
		}
	    }
	} else {
	    do i = 1, npix {
		z = data[i]
		if (z >= z1 && z <= z2) {
		    bin = (z - z1) * dz
		    bin = bin + 1
		    hgm[bin] = hgm[bin] + 1
		}
	    }
	}
end
