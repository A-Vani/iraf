# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# ALTA -- Linearly map a vector into another vector of the same datatype.
#	b[i] = (a[i] + k1) * k2

procedure altal (a, b, npix, k1, k2)

long	a[ARB], b[ARB]
double	k1, k2
size_t	npix, i

begin
	do i = 1, npix
	    b[i] = (a[i] + k1) * k2
end
