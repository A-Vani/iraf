# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<error.h>
include	<ctype.h>
include	"crtpict.h"

# CRT_ULUT -- Generates a look up table from data supplied by user.  The
# data is read from a two column text file of intensity, greyscale values.
# The input data are sorted, then mapped to the x range [0-4096].  A 
# piecewise linear look up table of 4096 values is then constructed from 
# the (x,y) pairs given.  A pointer to the look up table, as well as the z1 
# and z2 intensity endpoints, is returned.

procedure crt_ulut (fname, z1, z2, lut)

char	fname[SZ_FNAME]		# Name of file with intensity, greyscale values
real	z1			# Intensity mapped to minimum gs value
real	z2			# Intensity mapped to maximum gs value
pointer	lut			# Look up table - pointer is returned

size_t	sz_val
pointer	sp, x, y
int	j, x1, x2, y1
long	i
size_t	nvalues
real	delta_gs, delta_xv, slope
int	iint()
errchk	crt_rlut, crt_sort, malloc

begin
	call smark (sp)
	sz_val = SZ_BUF
	call salloc (x, sz_val, TY_REAL)
	call salloc (y, sz_val, TY_REAL)

	# Read intensities and greyscales from the user's input file.  The
	# intensity range is then mapped into a standard range and the 
	# values sorted.

	call crt_rlut (fname, Memr[x], Memr[y], nvalues)
	call alimr (Memr[x], nvalues, z1, z2)
	call amapr (Memr[x], Memr[x], nvalues, z1, z2, STARTPT, ENDPT)
	call crt_sort (Memr[x], Memr[y], nvalues)

	# Fill lut in straight line segments - piecewise linear
	sz_val = SZ_BUF
	call malloc (lut, sz_val, TY_SHORT)
	do i = 1, nvalues-1 {
	    delta_gs = Memr[y+i] - Memr[y+i-1]
	    delta_xv = Memr[x+i] - Memr[x+i-1]
	    slope = delta_gs / delta_xv
	    x1 = iint(Memr[x+i-1]) 
	    x2 = iint(Memr[x+i])
	    y1 = iint(Memr[y+i-1])
	    do j = x1, x2-1
		Mems[lut+j-1] = y1 + slope * (j-x1)
	}

	call sfree (sp)
end


# CRT_RLUT -- Read text file of x, y, values.

procedure crt_rlut (utab, x, y, nvalues)

char	utab[SZ_FNAME]		# Name of list file
real	x[SZ_BUF]		# Array of x values, filled on return
real	y[SZ_BUF]		# Array of y values, filled on return
size_t	nvalues			# Number of values in x, y vectors - returned

size_t	sz_val
int	n, fd
pointer	sp, lbuf, ip
real	xval, yval
int	getline(), open()
errchk	open, sscan, getline, malloc

begin
	call smark (sp)
	sz_val = SZ_LINE
	call salloc (lbuf, sz_val, TY_CHAR)

	iferr (fd = open (utab, READ_ONLY, TEXT_FILE))
	    call error (0, "Error opening user table")

	n = 0

	while (getline (fd, Memc[lbuf]) != EOF) {
	    # Skip comment lines and blank lines.
	    if (Memc[lbuf] == '#')
		next
	    for (ip=lbuf;  IS_WHITE(Memc[ip]);  ip=ip+1)
		;
	    if (Memc[ip] == '\n' || Memc[ip] == EOS)
		next

	    # Decode the points to be plotted.
	    call sscan (Memc[ip])
		call gargr (xval)
		call gargr (yval)

	    n = n + 1
	    if (n > SZ_BUF) 
	        call error (0,
		    "Intensity transformation table cannot exceed 4096 values")

	    x[n] = xval
	    y[n] = yval
	}

	nvalues = n
	call close (fd)
	call sfree (sp)
end


# CRT_SORT -- Bubble sort of paired arrays.  

procedure crt_sort (xvals, yvals, nvals)

real	xvals[nvals]		# Array of x values
real	yvals[nvals]		# Array of y values
size_t	nvals			# Number of values in each array

long	i, j
real	temp
define	swap	{temp=$1;$1=$2;$2=temp}

begin
	for (i = nvals; i > 1; i = i - 1)
	    for (j = 1; j < i; j = j + 1) 
		if (xvals[j] > xvals[j+1]) {
		    # Out of order; exchange y values
		    swap (xvals[j], xvals[j+1])
		    swap (yvals[j], yvals[j+1])
		}
end
