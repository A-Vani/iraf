# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# AMODK -- Compute the modulus of a vector by a constant (generic).

procedure amodkl (a, b, c, npix)

long	a[ARB]
long	b
long	c[ARB]
size_t	npix, i
long	modl()

begin
	do i = 1, npix
	    c[i] = modl (a[i], b)
end
