# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# AUPX -- Unpack the real and imaginary components of a complex vector into
# two output vectors of some other type.

procedure aupxi (a, b, c, npix)

complex	a[ARB]			# input vector
int	b[ARB], c[ARB]	# output vectors
size_t	npix
size_t	i

begin
	do i = 1, npix {
		b[i] = real  (a[i])
		c[i] = aimag (a[i])
	}
end
