# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# ABAV -- Vector block average.  Each pixel in the output vector is the
# average of the input vector over a block of pixels.  The input vector must
# be at least (nblocks * npix_per_block) pixels in length.

procedure abavd (a, b, nblocks, npix_per_block)

double	a[ARB]			# input vector
double	b[nblocks]		# output vector
size_t	nblocks			# number of blocks (pixels in output vector)
size_t	npix_per_block		# number of input pixels per block

double	sum, width

size_t	i, j
size_t	block_offset, next_block, block_length

begin
	block_offset = 1
	block_length = npix_per_block
	    width = block_length

	if (block_length <= 1)
	    call amovd (a[block_offset], b, nblocks)
	else {
	    do j = 1, nblocks {
		next_block = block_offset + block_length
		sum = 0
		do i = block_offset, next_block - 1
		    sum = sum + a[i]
		b[j] = sum / width
		block_offset = next_block
	    }
	}
end
