# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# AIMG -- Return the imaginary part of a COMPLEX vector.

procedure aimgs (a, b, npix)

complex	a[ARB]
short	b[ARB]
size_t	npix, i

begin
	do i = 1, npix
	    b[i] = aimag (a[i])
end
