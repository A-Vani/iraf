include	<imhdr.h>
include	<imset.h>
include	<error.h>
include	<syserr.h>

define	SUM		1	# Sum of the images
define	AVERAGE		2	# Average of the images
define	MEDIAN		3	# Median of the images
define	MINREJECT	4	# Reject minimum
define	MAXREJECT	5	# Reject maximin
define	MINMAXREJECT	6	# Reject minimum and maximum
# 	newline		7
define	THRESHOLD	8	# Absolute threshold clip
define	SIGCLIP		9	# Sigma clip using sigma at each point
define	AVSIGCLIP	10	# Sigma clip using average sigma

# IMCOMBINE -- Combine images
#
# The memory and open file descriptor limits are checked and an attempt
# to recover is made either by setting the image pixel files to be
# closed after I/O or by notifying the calling program that memory
# ran out and the IMIO buffer size should be reduced.  After the checks
# a procedure for the selected combine option is called.


procedure imcombines (log, in, nimages, out, sig, bufsize, option)

int	log			# Log file descriptor
pointer	in[nimages]		# Input IMIO pointers
int	nimages			# Number of input images
pointer	out			# Output IMIO pointer
pointer	sig			# Sigma IMIO pointer
int	bufsize			# IMIO buffer size
int	option			# Combine option

char	str[1]
int	i, j, fd, stropen(), errcode(), imstati()
pointer	data, imgl1s()
pointer	impl1r()

begin
	# Reserve FD for string operations.
	fd = stropen (str, 1, NEW_FILE)

	# Do I/O to the output images.
	i = IM_LEN(out, 1)
	call imseti (out, IM_BUFSIZE, bufsize)
	data = impl1r (out)
	call aclrr (Memr[data], i)
	if (sig != NULL) {
	    data = impl1r (sig)
	    call aclrr (Memr[data], i)
	}

	# Do I/O from the input images.
	do i = 1, nimages {
	    call imseti (in[i], IM_BUFSIZE, bufsize)
	    iferr (data = imgl1s (in[i])) {
		switch (errcode()) {
	        case SYS_MFULL:
		    call strclose (fd)
		    call erract (EA_ERROR)
		default:
		    if (imstati (in[i], IM_CLOSEFD) == YES) {
			call strclose (fd)
			call error (1, "combine - Too many images to combine")
		    }
		    do j = i-2, nimages
		        call imseti (in[j], IM_CLOSEFD, YES)
	            data = imgl1s (in[i])
		}
	    }
	}
	call strclose (fd)
	if (log != NULL)
	    call close (log)

	switch (option) {
	case SUM:
	    call imc_sums (log, in, out, nimages)
	case AVERAGE:
	    call imc_averages (log, in, out, sig, nimages)
	case MEDIAN:
	    call imc_medians (log, in, out, sig, nimages)
	case SIGCLIP:
	    call imc_sigclips (log, in, out, sig, nimages)
	case AVSIGCLIP:
	    call imc_asigclips (log, in, out, sig, nimages)
	case THRESHOLD:
	    call imc_thresholds (log, in, out, sig, nimages)
	case MINREJECT:
	    call imc_minrejs (log, in, out, sig, nimages)
	case MAXREJECT:
	    call imc_maxrejs (log, in, out, sig, nimages)
	case MINMAXREJECT:
	    call imc_mmrejs (log, in, out, sig, nimages)
	}
end

procedure imcombiner (log, in, nimages, out, sig, bufsize, option)

int	log			# Log file descriptor
pointer	in[nimages]		# Input IMIO pointers
int	nimages			# Number of input images
pointer	out			# Output IMIO pointer
pointer	sig			# Sigma IMIO pointer
int	bufsize			# IMIO buffer size
int	option			# Combine option

char	str[1]
int	i, j, fd, stropen(), errcode(), imstati()
pointer	data, imgl1r()
pointer	impl1r()

begin
	# Reserve FD for string operations.
	fd = stropen (str, 1, NEW_FILE)

	# Do I/O to the output images.
	i = IM_LEN(out, 1)
	call imseti (out, IM_BUFSIZE, bufsize)
	data = impl1r (out)
	call aclrr (Memr[data], i)
	if (sig != NULL) {
	    data = impl1r (sig)
	    call aclrr (Memr[data], i)
	}

	# Do I/O from the input images.
	do i = 1, nimages {
	    call imseti (in[i], IM_BUFSIZE, bufsize)
	    iferr (data = imgl1r (in[i])) {
		switch (errcode()) {
	        case SYS_MFULL:
		    call strclose (fd)
		    call erract (EA_ERROR)
		default:
		    if (imstati (in[i], IM_CLOSEFD) == YES) {
			call strclose (fd)
			call error (1, "combine - Too many images to combine")
		    }
		    do j = i-2, nimages
		        call imseti (in[j], IM_CLOSEFD, YES)
	            data = imgl1r (in[i])
		}
	    }
	}
	call strclose (fd)
	if (log != NULL)
	    call close (log)

	switch (option) {
	case SUM:
	    call imc_sumr (log, in, out, nimages)
	case AVERAGE:
	    call imc_averager (log, in, out, sig, nimages)
	case MEDIAN:
	    call imc_medianr (log, in, out, sig, nimages)
	case SIGCLIP:
	    call imc_sigclipr (log, in, out, sig, nimages)
	case AVSIGCLIP:
	    call imc_asigclipr (log, in, out, sig, nimages)
	case THRESHOLD:
	    call imc_thresholdr (log, in, out, sig, nimages)
	case MINREJECT:
	    call imc_minrejr (log, in, out, sig, nimages)
	case MAXREJECT:
	    call imc_maxrejr (log, in, out, sig, nimages)
	case MINMAXREJECT:
	    call imc_mmrejr (log, in, out, sig, nimages)
	}
end

