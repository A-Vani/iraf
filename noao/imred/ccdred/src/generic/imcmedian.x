include	<imhdr.h>

.help imcmedian
.nf ----------------------------------------------------------------------------
              COMBINING IMAGES: MEDIAN ALGORITHM

The input images are combined by scaling and taking the median.
The exposure time of the output image is the scaled and weighted
average of the input exposure times.  If some of the input images are
real datatypes and the output image is short datatype there may be
some truncation.

PROCEDURES:

    IMC_MEDIAN -- Combine the images by scaling and taking the median.
    MEDIAN -- Median of lines (no scaling).
    SCMEDIAN -- Scaled median of lines.
.endhelp -----------------------------------------------------------------------


# IMC_MEDIAN -- Combine the images by scaling and taking the median.
# Each input image, given by an array of image pointers, is
# scaled and then a median is computed.  The output image header
# is updated to include a scaled and weighted exposure time and the number
# of images combined.

procedure imc_medians (log, in, out, sig, nimages)

int	log			# Log file descriptor
pointer	in[nimages]		# Input images
pointer	out			# Output images
pointer	sig			# Sigma image
int	nimages			# Number of input images

int	i, j, nc
pointer	sp, data, scales, zeros, wts, outdata, sigdata, v1, v2
bool	scale, imc_scales()
pointer	imgnls()
pointer	impnlr()

begin
	if (nimages == 1) {
	    call imc_copys (in[1], out)
	    return
	}

	call smark (sp)
	call salloc (data, nimages, TY_REAL)
	call salloc (scales, nimages, TY_REAL)
	call salloc (zeros, nimages, TY_REAL)
	call salloc (wts, nimages, TY_REAL)
	call salloc (v1, IM_MAXDIM, TY_LONG)
	call salloc (v2, IM_MAXDIM, TY_LONG)
	call amovkl (long(1), Meml[v1], IM_MAXDIM)
	call amovkl (long(1), Meml[v2], IM_MAXDIM)

	# Get the scaling factors and weights.
	scale = imc_scales ("median", log, 0., 0., in, out, Memr[scales],
	    Memr[zeros], Memr[wts], nimages)

	# For each line get input and ouput image lines and call a procedure
	# to perform the median on the line.

	nc = IM_LEN(out,1)
	if (scale) {
	    while (impnlr (out, outdata, Meml[v1]) != EOF) {
		do i = 1, nimages {
		    call amovl (Meml[v2], Meml[v1], IM_MAXDIM)
		    j = imgnls (in[i], Memi[data+i-1], Meml[v1])
		}
		call scmedians (Memi[data], Memr[scales], Memr[zeros], nimages,
		    Memr[outdata], nc)
		if (sig != NULL) {
		    call amovl (Meml[v2], Meml[v1], IM_MAXDIM)
		    j = impnlr (sig, sigdata, Meml[v1])
		    call wtsigmas (Memi[data], Memr[scales], Memr[zeros],
			Memr[wts], nimages, Memr[outdata], Memr[sigdata], nc)
		}
		call amovl (Meml[v1], Meml[v2], IM_MAXDIM)
	    }
	} else {
	    while (impnlr (out, outdata, Meml[v1]) != EOF) {
		do i = 1, nimages {
		    call amovl (Meml[v2], Meml[v1], IM_MAXDIM)
		    j = imgnls (in[i], Memi[data+i-1], Meml[v1])
		}
		call medians (Memi[data], nimages, Memr[outdata], nc)
		if (sig != NULL) {
		    call amovl (Meml[v2], Meml[v1], IM_MAXDIM)
		    j = impnlr (sig, sigdata, Meml[v1])
		    call sigmas (Memi[data], nimages, Memr[outdata],
			Memr[sigdata], nc)
		}
		call amovl (Meml[v1], Meml[v2], IM_MAXDIM)
	    }
	}

	call sfree (sp)
end


# SCMEDIAN -- Median of lines with scaling.

procedure scmedians (data, scales, zeros, nimages, median, npts)

pointer	data[nimages]		# Input data line pointers
real	scales[nimages]		# Image scale factors
real	zeros[nimages]		# Image zero levels
int	nimages			# Number of images
real	median[npts]		# Output data line
int	npts			# Number of output points

int	i, j
real	s, z
pointer	sp, ptr1
pointer	work[7], ptr2

begin
	call smark (sp)
	if (nimages < 8) {
	    do i = 1, nimages {
	        call salloc (work[i], npts, TY_REAL)
		ptr1 = data[i]
		ptr2 = work[i]
		s = scales[i]
		z = zeros[i]
		do j = 1, npts {
		    Memr[ptr2] = Mems[ptr1] / s - z
		    ptr1 = ptr1 + 1
		    ptr2 = ptr2 + 1
		}
	    }
	    call imc_amedr (work, nimages, median, npts)
	} else {
	    call salloc (ptr1, nimages, TY_REAL)
	    call imc_ssoks (data, scales, zeros, Memr[ptr1], nimages,
	        median, npts)
	}
	call sfree (sp)
end


# MEDIAN -- Median of lines with no scaling.

procedure medians (data, nimages, median, npts)

pointer	data[nimages]		# Input data line pointers
int	nimages			# Number of images
real	median[npts]		# Output data line
int	npts			# Number of output points

pointer	sp, work

begin
	if (nimages < 8)
	    call imc_ameds (data, nimages, median, npts)
	else {
	    call smark (sp)
	    call salloc (work, nimages, TY_SHORT)
	    call imc_soks (data, Mems[work], nimages, median, npts)
	    call sfree (sp)
	}
end

# IMC_SOK -- Select median with no scaling.
# 
# This is a modifications of the VOPS ASOK procedure.  The algorithm used
# is selection by tail recursion (Gonnet 1984).  In each iteration a pivot key
# is selected (somewhat arbitrarily) from the array.  The array is then split
# into two subarrays, those with key values less than or equal to the pivot key
# and those with values greater than the pivot.  The size of the two subarrays
# determines which contains the median value, and the process is repeated
# on that subarray, and so on until all of the elements of the subarray
# are equal, e.g., there is only one element left in the subarray.  For a
# randomly ordered array the expected running time is O(3.38N).  The selection
# is carried out in place, leaving the array in a partially ordered state.
#
# N.B.: Behaviour is O(N) if the input array is sorted.
# N.B.: The cases ksel=1 and ksel=npix, i.e., selection of the minimum and
# maximum values, are more efficiently handled by ALIM which is O(2N).

procedure imc_soks (data, a, npix, median, npts)

pointer	data[npix]		# Data vectors
short	a[npix]			# work array
int	npix			# number of pixels
real	median[npts]		# median vector (returned)
int	npts			# number of points in vector

int	ksel, lo, up, i, j, k, l
short	temp

begin
	ksel = (npix + 1) / 2
	do l = 1, npts {
	    i = l - 1
	    do j = 1, npix
		a[j] = Mems[data[j]+i]

	    lo = 1
	    up = npix
	    k  = max (lo, min (up, ksel))

	    while (up >= k && k >= lo) {
	        i = lo
	        j = up
	        temp = a[k];  a[k] = a[lo];  a[lo] = temp

	        # Split array into two.
	        while (i < j) {
		    while (a[j] > temp)
		        j = j - 1
		    a[i] = a[j]
		    while (i < j && a[i] <= temp)
		        i = i + 1
		    a[j] = a[i]
	        }
	        a[i] = temp

	        # Select the subarray containing the Kth element.
	        if (k < i)
		    up = i - 1
	        else
		    lo = i + 1
	    }

	    median[l] = a[k]
	}
end


# IMC_SSOK -- Scaled median of vectors.
#
# This is a modifications of the VOPS ASOK procedure.  The algorithm used
# is selection by tail recursion (Gonnet 1984).  In each iteration a pivot key
# is selected (somewhat arbitrarily) from the array.  The array is then split
# into two subarrays, those with key values less than or equal to the pivot key
# and those with values greater than the pivot.  The size of the two subarrays
# determines which contains the median value, and the process is repeated
# on that subarray, and so on until all of the elements of the subarray
# are equal, e.g., there is only one element left in the subarray.  For a
# randomly ordered array the expected running time is O(3.38N).  The selection
# is carried out in place, leaving the array in a partially ordered state.
#
# N.B.: Behaviour is O(N) if the input array is sorted.
# N.B.: The cases ksel=1 and ksel=npix, i.e., selection of the minimum and
# maximum values, are more efficiently handled by ALIM which is O(2N).

procedure imc_ssoks (data, scales, zeros, a, npix, median, npts)

pointer	data[npix]		# Data vectors
real	scales[npix]		# scales
real	zeros[npix]		# zeros
real	a[npix]			# work array
real	median[npts]		# median vector (returned)
int	npix			# number of pixels
int	npts			# number of points in vector

int	ksel, lo, up, i, j, k, l
real	temp

begin
	ksel = (npix + 1) / 2
	do l = 1, npts {
	    i = l - 1
	    do j = 1, npix
		a[j] = Mems[data[j]+i] / scales[j] - zeros[j]

	    lo = 1
	    up = npix
	    k  = max (lo, min (up, ksel))

	    while (up >= k && k >= lo) {
	        i = lo
	        j = up
	        temp = a[k];  a[k] = a[lo];  a[lo] = temp

	        # Split array into two.
	        while (i < j) {
		    while (a[j] > temp)
		        j = j - 1
		    a[i] = a[j]
		    while (i < j && a[i] <= temp)
		        i = i + 1
		    a[j] = a[i]
	        }
	        a[i] = temp

	        # Select the subarray containing the Kth element.
	        if (k < i)
		    up = i - 1
	        else
		    lo = i + 1
	    }

	    median[l] = a[k]
	}
end


# IMC_AMED -- Given an array of vector pointers for each element in the vectors
# find the median.  This algorithm is good for small numbers of vectors.
# It is specialized to return median as a real vector if the input is integer.

procedure imc_ameds (a, nvecs, median, npts)

pointer	a[nvecs]			# Array of vector pointers
int	nvecs				# Number of vectors
real	median[npts]			# Median vector
int	npts				# Number of points in the vectors

int	i, j, nleft
pointer	k, l
short	val1, val2, val3

begin
	nleft = nvecs
	while (nleft > 3) {
	    do i = 0, npts - 1 {
	        l = a[1] + i
	        val1 = Mems[l]
	        do j = 2, nleft {
		    k = a[j] + i
		    val2 = Mems[k]
	            if (val2 > val1) {
		        l = k
		        val1 = val2
		    }
	        }
	        if (l != k)
	            Mems[l] = Mems[k]
	    }
	    nleft = nleft - 1
	    if (nleft == 3)
		 break
	    do i = 0, npts - 1 {
	        l = a[1] + i
	        val1 = Mems[l]
	        do j = 2, nleft {
		    k = a[j] + i
		    val2 = Mems[k]
	            if (val2 < val1) {
		        l = k
		        val1 = val2
		    }
	        }
	        if (l != k)
	            Mems[l] = Mems[k]
	    }
	    nleft = nleft - 1
	}

	if (nleft == 3) {
	    do i = 1, npts {
	        j = i - 1
	        val1 = Mems[a[1]+j]
	        val2 = Mems[a[2]+j]
	        val3 = Mems[a[3]+j]
	        if (val1 < val2) {
		    if (val2 < val3)		# abc
		        median[i] = val2
		    else if (val1 < val3)	# acb
		        median[i] = val3
		    else			# cab
		        median[i] = val1
	        } else {
		    if (val2 > val3)		# cba
		        median[i] = val2
		    else if (val1 > val3)	# bca
		        median[i] = val3
		    else			# bac
		        median[i] = val1
	        }
	    }
	} else if (nleft == 2) {
	    do i = 1, npts {
		j = i - 1
		val1 = Mems[a[1]+j]
		val2 = Mems[a[2]+j]
		if (val1 < val2)
		    median[i] = val1
		else
		    median[i] = val2
	    }
	} else {
	    call achtsr (Mems[a[1]], median, npts)
	}
end

# IMC_MEDIAN -- Combine the images by scaling and taking the median.
# Each input image, given by an array of image pointers, is
# scaled and then a median is computed.  The output image header
# is updated to include a scaled and weighted exposure time and the number
# of images combined.

procedure imc_medianr (log, in, out, sig, nimages)

int	log			# Log file descriptor
pointer	in[nimages]		# Input images
pointer	out			# Output images
pointer	sig			# Sigma image
int	nimages			# Number of input images

int	i, j, nc
pointer	sp, data, scales, zeros, wts, outdata, sigdata, v1, v2
bool	scale, imc_scales()
pointer	imgnlr()
pointer	impnlr()

begin
	if (nimages == 1) {
	    call imc_copyr (in[1], out)
	    return
	}

	call smark (sp)
	call salloc (data, nimages, TY_REAL)
	call salloc (scales, nimages, TY_REAL)
	call salloc (zeros, nimages, TY_REAL)
	call salloc (wts, nimages, TY_REAL)
	call salloc (v1, IM_MAXDIM, TY_LONG)
	call salloc (v2, IM_MAXDIM, TY_LONG)
	call amovkl (long(1), Meml[v1], IM_MAXDIM)
	call amovkl (long(1), Meml[v2], IM_MAXDIM)

	# Get the scaling factors and weights.
	scale = imc_scales ("median", log, 0., 0., in, out, Memr[scales],
	    Memr[zeros], Memr[wts], nimages)

	# For each line get input and ouput image lines and call a procedure
	# to perform the median on the line.

	nc = IM_LEN(out,1)
	if (scale) {
	    while (impnlr (out, outdata, Meml[v1]) != EOF) {
		do i = 1, nimages {
		    call amovl (Meml[v2], Meml[v1], IM_MAXDIM)
		    j = imgnlr (in[i], Memi[data+i-1], Meml[v1])
		}
		call scmedianr (Memi[data], Memr[scales], Memr[zeros], nimages,
		    Memr[outdata], nc)
		if (sig != NULL) {
		    call amovl (Meml[v2], Meml[v1], IM_MAXDIM)
		    j = impnlr (sig, sigdata, Meml[v1])
		    call wtsigmar (Memi[data], Memr[scales], Memr[zeros],
			Memr[wts], nimages, Memr[outdata], Memr[sigdata], nc)
		}
		call amovl (Meml[v1], Meml[v2], IM_MAXDIM)
	    }
	} else {
	    while (impnlr (out, outdata, Meml[v1]) != EOF) {
		do i = 1, nimages {
		    call amovl (Meml[v2], Meml[v1], IM_MAXDIM)
		    j = imgnlr (in[i], Memi[data+i-1], Meml[v1])
		}
		call medianr (Memi[data], nimages, Memr[outdata], nc)
		if (sig != NULL) {
		    call amovl (Meml[v2], Meml[v1], IM_MAXDIM)
		    j = impnlr (sig, sigdata, Meml[v1])
		    call sigmar (Memi[data], nimages, Memr[outdata],
			Memr[sigdata], nc)
		}
		call amovl (Meml[v1], Meml[v2], IM_MAXDIM)
	    }
	}

	call sfree (sp)
end


# SCMEDIAN -- Median of lines with scaling.

procedure scmedianr (data, scales, zeros, nimages, median, npts)

pointer	data[nimages]		# Input data line pointers
real	scales[nimages]		# Image scale factors
real	zeros[nimages]		# Image zero levels
int	nimages			# Number of images
real	median[npts]		# Output data line
int	npts			# Number of output points

int	i, j
real	s, z
pointer	sp, ptr1

begin
	call smark (sp)
	if (nimages < 8) {
	    do i = 1, nimages {
		ptr1 = data[i]
		s = scales[i]
		z = zeros[i]
		do j = 1, npts {
		    Memr[ptr1] = Memr[ptr1] / s - z
		    ptr1 = ptr1 + 1
		}
	    }
	    call imc_amedr (data, nimages, median, npts)
	} else {
	    call salloc (ptr1, nimages, TY_REAL)
	    call imc_ssokr (data, scales, zeros, Memr[ptr1], nimages,
		median, npts)
	}
	call sfree (sp)
end


# MEDIAN -- Median of lines with no scaling.

procedure medianr (data, nimages, median, npts)

pointer	data[nimages]		# Input data line pointers
int	nimages			# Number of images
real	median[npts]		# Output data line
int	npts			# Number of output points

pointer	sp, work

begin
	if (nimages < 8)
	    call imc_amedr (data, nimages, median, npts)
	else {
	    call smark (sp)
	    call salloc (work, nimages, TY_REAL)
	    call imc_sokr (data, Memr[work], nimages, median, npts)
	    call sfree (sp)
	}
end

# IMC_SOK -- Select median with no scaling.
# 
# This is a modifications of the VOPS ASOK procedure.  The algorithm used
# is selection by tail recursion (Gonnet 1984).  In each iteration a pivot key
# is selected (somewhat arbitrarily) from the array.  The array is then split
# into two subarrays, those with key values less than or equal to the pivot key
# and those with values greater than the pivot.  The size of the two subarrays
# determines which contains the median value, and the process is repeated
# on that subarray, and so on until all of the elements of the subarray
# are equal, e.g., there is only one element left in the subarray.  For a
# randomly ordered array the expected running time is O(3.38N).  The selection
# is carried out in place, leaving the array in a partially ordered state.
#
# N.B.: Behaviour is O(N) if the input array is sorted.
# N.B.: The cases ksel=1 and ksel=npix, i.e., selection of the minimum and
# maximum values, are more efficiently handled by ALIM which is O(2N).

procedure imc_sokr (data, a, npix, median, npts)

pointer	data[npix]		# Data vectors
real	a[npix]			# work array
int	npix			# number of pixels
real	median[npts]		# median vector (returned)
int	npts			# number of points in vector

int	ksel, lo, up, i, j, k, l
real	temp

begin
	ksel = (npix + 1) / 2
	do l = 1, npts {
	    i = l - 1
	    do j = 1, npix
		a[j] = Memr[data[j]+i]

	    lo = 1
	    up = npix
	    k  = max (lo, min (up, ksel))

	    while (up >= k && k >= lo) {
	        i = lo
	        j = up
	        temp = a[k];  a[k] = a[lo];  a[lo] = temp

	        # Split array into two.
	        while (i < j) {
		    while (a[j] > temp)
		        j = j - 1
		    a[i] = a[j]
		    while (i < j && a[i] <= temp)
		        i = i + 1
		    a[j] = a[i]
	        }
	        a[i] = temp

	        # Select the subarray containing the Kth element.
	        if (k < i)
		    up = i - 1
	        else
		    lo = i + 1
	    }

	    median[l] = a[k]
	}
end


# IMC_SSOK -- Scaled median of vectors.
#
# This is a modifications of the VOPS ASOK procedure.  The algorithm used
# is selection by tail recursion (Gonnet 1984).  In each iteration a pivot key
# is selected (somewhat arbitrarily) from the array.  The array is then split
# into two subarrays, those with key values less than or equal to the pivot key
# and those with values greater than the pivot.  The size of the two subarrays
# determines which contains the median value, and the process is repeated
# on that subarray, and so on until all of the elements of the subarray
# are equal, e.g., there is only one element left in the subarray.  For a
# randomly ordered array the expected running time is O(3.38N).  The selection
# is carried out in place, leaving the array in a partially ordered state.
#
# N.B.: Behaviour is O(N) if the input array is sorted.
# N.B.: The cases ksel=1 and ksel=npix, i.e., selection of the minimum and
# maximum values, are more efficiently handled by ALIM which is O(2N).

procedure imc_ssokr (data, scales, zeros, a, npix, median, npts)

pointer	data[npix]		# Data vectors
real	scales[npix]		# scales
real	zeros[npix]		# zeros
real	a[npix]			# work array
real	median[npts]		# median vector (returned)
int	npix			# number of pixels
int	npts			# number of points in vector

int	ksel, lo, up, i, j, k, l
real	temp

begin
	ksel = (npix + 1) / 2
	do l = 1, npts {
	    i = l - 1
	    do j = 1, npix
		a[j] = Memr[data[j]+i] / scales[j] - zeros[j]

	    lo = 1
	    up = npix
	    k  = max (lo, min (up, ksel))

	    while (up >= k && k >= lo) {
	        i = lo
	        j = up
	        temp = a[k];  a[k] = a[lo];  a[lo] = temp

	        # Split array into two.
	        while (i < j) {
		    while (a[j] > temp)
		        j = j - 1
		    a[i] = a[j]
		    while (i < j && a[i] <= temp)
		        i = i + 1
		    a[j] = a[i]
	        }
	        a[i] = temp

	        # Select the subarray containing the Kth element.
	        if (k < i)
		    up = i - 1
	        else
		    lo = i + 1
	    }

	    median[l] = a[k]
	}
end


# IMC_AMED -- Given an array of vector pointers for each element in the vectors
# find the median.  This algorithm is good for small numbers of vectors.
# It is specialized to return median as a real vector if the input is integer.

procedure imc_amedr (a, nvecs, median, npts)

pointer	a[nvecs]			# Array of vector pointers
int	nvecs				# Number of vectors
real	median[npts]			# Median vector
int	npts				# Number of points in the vectors

int	i, j, nleft
pointer	k, l
real	val1, val2, val3

begin
	nleft = nvecs
	while (nleft > 3) {
	    do i = 0, npts - 1 {
	        l = a[1] + i
	        val1 = Memr[l]
	        do j = 2, nleft {
		    k = a[j] + i
		    val2 = Memr[k]
	            if (val2 > val1) {
		        l = k
		        val1 = val2
		    }
	        }
	        if (l != k)
	            Memr[l] = Memr[k]
	    }
	    nleft = nleft - 1
	    if (nleft == 3)
		 break
	    do i = 0, npts - 1 {
	        l = a[1] + i
	        val1 = Memr[l]
	        do j = 2, nleft {
		    k = a[j] + i
		    val2 = Memr[k]
	            if (val2 < val1) {
		        l = k
		        val1 = val2
		    }
	        }
	        if (l != k)
	            Memr[l] = Memr[k]
	    }
	    nleft = nleft - 1
	}

	if (nleft == 3) {
	    do i = 1, npts {
	        j = i - 1
	        val1 = Memr[a[1]+j]
	        val2 = Memr[a[2]+j]
	        val3 = Memr[a[3]+j]
	        if (val1 < val2) {
		    if (val2 < val3)		# abc
		        median[i] = val2
		    else if (val1 < val3)	# acb
		        median[i] = val3
		    else			# cab
		        median[i] = val1
	        } else {
		    if (val2 > val3)		# cba
		        median[i] = val2
		    else if (val1 > val3)	# bca
		        median[i] = val3
		    else			# bac
		        median[i] = val1
	        }
	    }
	} else if (nleft == 2) {
	    do i = 1, npts {
		j = i - 1
		val1 = Memr[a[1]+j]
		val2 = Memr[a[2]+j]
		if (val1 < val2)
		    median[i] = val1
		else
		    median[i] = val2
	    }
	} else {
	    call amovr (Memr[a[1]], median, npts)
	}
end

