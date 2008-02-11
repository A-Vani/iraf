# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# AWSU -- Vector weighted sum.  C = A * k1 + B * k2

procedure awsus (a, b, c, npix, k1, k2)

short	a[ARB], b[ARB], c[ARB]
real	k1, k2
size_t	npix, i

begin
	do i = 1, npix
	    c[i] = a[i] * k1 + b[i] * k2
end
