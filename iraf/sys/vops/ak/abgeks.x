# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# ABGEK -- Vector boolean greater than or equals constant.  C[i], type INT,
# is set to 1 if A[i] is greater than or equal to B, else C[i] is set to zero.

procedure abgeks (a, b, c, npix)

short	a[ARB]
short	b
int	c[ARB]
size_t	npix
size_t	i

begin
	# The case b==0 is perhaps worth optimizing.  On many machines this
	# will save a memory fetch.

	if (b == 0) {
	    do i = 1, npix
		if (a[i] >= 0)
		    c[i] = 1
		else
		    c[i] = 0
	} else {
	    do i = 1, npix
		if (a[i] >= b)
		    c[i] = 1
		else
		    c[i] = 0
	}
end
