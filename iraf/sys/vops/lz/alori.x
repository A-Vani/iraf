# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# ALOR -- Compute the logical OR of a vector and a constant (generic).
# The logical output value is returned as an int.

procedure alori (a, b, c, npix)

int	a[ARB], b[ARB]
int	c[ARB]

size_t	npix, i

begin
	do i = 1, npix
	    if (a[i] != 0 || b[i] != 0)
		c[i] = YES
	    else
		c[i] = NO
end
