# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# AAVG -- Compute the mean and standard deviation (sigma) of a sample.
# All pixels are used.

procedure aavgx (a, npix, mean, sigma)

complex	a[ARB]
size_t	npix
real	mean, sigma, lcut, hcut
size_t	junk
size_t	awvgx()
data	lcut /0./, hcut /0./

begin
	junk = awvgx (a, npix, mean, sigma, lcut, hcut)
end
