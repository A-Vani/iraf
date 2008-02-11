# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# ABEQ -- Vector boolean equals.  C[i], type INT, is set to 1 if A[i] equals
# B[i], else C[i] is set to zero.

procedure abeqi (a, b, c, npix)

int	a[ARB], b[ARB]
int	c[ARB]
size_t	npix
size_t	i

begin
	do i = 1, npix
	    if (a[i] == b[i])
		c[i] = 1
	    else
		c[i] = 0
end
