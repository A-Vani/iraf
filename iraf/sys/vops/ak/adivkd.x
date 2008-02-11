# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# ADIVK -- Divide a vector by a constant (generic).  No divide by zero checking
# is performed.

procedure adivkd (a, b, c, npix)

double	a[ARB]
double	b
double	c[ARB]
size_t	npix, i

begin
	do i = 1, npix
	    c[i] = a[i] / b
end
