# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<pmset.h>
include	"qpio.h"

define	RLI_NEXTLINE	9998
define	RLI_INITIALIZE	9999

# QPIO_GETEVENTS -- Return a sequence of events sharing the same mask value
# which satisfy the current event attribute filter.  The returned events will
# be only those in a rectangular subregion of the image (specified by a prior
# call to qpio_setrange) which are also visible through the current mask.
# Sequences of events are returned in storage order until the region is
# exhausted, at which time EOF is returned.
#
# NOTE - If debug statements (printfs) are placed in this code they will cause
# i/o problems at runtime due to reentrancy, since this routine is called in
# a low level FIO pseudodevice driver (QPF).  This is also true of any of the
# routines called by this procedure, and of the related routine QPIO_READPIX.

int procedure qpio_getevents (io, o_ev, maskval, maxev, o_nev)

pointer	io			#I QPIO descriptor
pointer	o_ev[maxev]		#O receives the event struct pointers
int	maskval			#O receives the mask value of the events
int	maxev			#I max events out
int	o_nev			#O same as function value (nev_out|EOF)

bool	useindex, lineio, bbused, rmused
pointer	pl, rl, rp, bp, ex, ev, op, bbmask
int	x1, x2, y1, y2, xs, xe, ys, ye, x, y
int	v[NDIM], szs_event, mval, nev, npix, off, evi, evtop, temp, i

int	qpio_rbucket(), qpex_evaluate(), btoi()
bool	pl_linenotempty(), pl_sectnotempty()

define	swap {temp=$1;$1=$2;$2=temp}
define	putevent_  91
define	again_     92
define	done_      93
define	exit_      94

begin
	pl = IO_PL(io)		# pixel list (region mask) descriptor
	rl = IO_RL(io)		# range list buffer
	bp = IO_BP(io)		# bucket buffer (type short)
	ex = IO_EX(io)		# QPEX (EAF) descriptor

	# The following is executed when the first i/o is performed on a new
	# region, to select the most efficient type of i/o to be performed,
	# and initialize the i/o parameters for that case.  The type of i/o
	# to be performed depends upon whether or not an index can be used,
	# and whether or not there is a region mask (RM) or bounding box (BB).
	# The presence or absence of an event attribute filter (EAF) is not
	# separated out as a special case, as it is quick and easy to test
	# for the presence of an EAF and apply one it if it exists.

	if (IO_ACTIVE(io) == NO) {
	    # Check for an index.  We have an index if the event list is
	    # indexed, and the index is defined on the Y-coordinate we will
	    # be using for extraction.

	    useindex = (IO_INDEXLEN(io) == IO_NLINES(io) &&
			IO_EVYOFF(io)   == IO_IXYOFF(io) &&
			IO_NOINDEX(io)  == NO)

	    # Initialize the V and VN vectors.
	    do i = 1, NDIM {
		IO_VN(io,i) = IO_VE(io,i) - IO_VS(io,i) + 1
		if (IO_VN(io,i) < 0) {
		    swap (IO_VS(io,i), IO_VE(io,i))
		    IO_VN(io,i) = -IO_VN(io,i)
		}
	    }
	    call amovi (IO_VS(io,1), IO_V(io,1), NDIM)

	    # Determine if full lines are to be accessed, and if a bounding
	    # box (subraster of the image) is defined.

	    lineio = (IO_VS(io,1) == 1 && IO_VE(io,1) == IO_NCOLS(io))
	    bbused = (!lineio || IO_VS(io,2) > 1 || IO_VE(io,2) < IO_NLINES(io))

	    # Determine if region mask data is to be used.  This is the case
	    # only if a region mask is defined, and it is nonzero within the
	    # given bounding box.

	    rmused = false
	    if (pl != NULL)
		if (pl_sectnotempty (pl, IO_VS(io,1), IO_VE(io,1), NDIM))
		    rmused = true

	    # Select the optimal type of i/o to be used for extraction.
	    if (bbused || rmused) {
		if (useindex)
		    IO_IOTYPE(io) = INDEX_RMorBB
		else
		    IO_IOTYPE(io) = NoINDEX_RMorBB

	    } else {
		# If we are reading the entire image (no bounding box) and
		# we are not using a mask, then there is no point in using
		# indexed i/o.

		IO_IOTYPE(io) = NoINDEX_NoRMorBB
		useindex = false
	    }

	    # Initialize the range list data if it will be used.
	    if (useindex) {
		# Dummy range specifying full line segment.
		RLI_LEN(rl)   = RL_FIRST
		RLI_AXLEN(rl) = IO_NCOLS(io)

		rp = rl + ((RL_FIRST - 1) * RL_LENELEM)
		Memi[rp+RL_XOFF] = IO_VS(io,1)
		Memi[rp+RL_NOFF] = IO_VN(io,1)
		Memi[rp+RL_VOFF] = 1

		IO_RLI(io) = RLI_INITIALIZE
	    }

	    # Get the populated mask subraster if it will be used.
	    bbmask = IO_BBMASK(io)
	    if (IO_IOTYPE(io) == NoINDEX_RMorBB && rmused) {
		npix = IO_VN(io,1) * IO_VN(io,2)
		if (bbmask == NULL)
		    call malloc (bbmask, npix, TY_INT)
		else
		    call realloc (bbmask, npix, TY_INT)
		call amovi (IO_VS(io,1), v, NDIM)

		op = bbmask
		do i = IO_VS(io,2), IO_VE(io,2) {
		    v[2]= i
		    call pl_glpi (pl, v, Memi[op],
			IO_MDEPTH(io), IO_VN(io,1), PIX_SRC)
		    op = op + IO_VN(io,1)
		}
	    } else if (bbmask != NULL)
		call mfree (bbmask, TY_INT)

	    # Update the QPIO descriptor.
	    IO_LINEIO(io)   = btoi(lineio)
	    IO_RMUSED(io)   = btoi(rmused)
	    IO_BBUSED(io)   = btoi(bbused)
	    IO_BBMASK(io)   = bbmask

	    IO_EVI(io)      = 1
	    IO_BKNO(io)     = 0
	    IO_BKLASTEV(io) = 0

	    IO_ACTIVE(io) = YES
	}

	# Initialize event extraction parameters.
	szs_event = IO_EVENTLEN(io)
	maskval = 0
	nev = 0

	# Extract events using the most efficient type of i/o for the given
	# selection critera (index, mask, BB, EAF, etc.).
again_
	switch (IO_IOTYPE(io)) {
	case NoINDEX_NoRMorBB:
	    # This is the simplest case; no index, region mask, or bounding
	    # box.  Read and output all events in sequence.

	    # Refill the event bucket?
	    if (IO_EVI(io) > IO_BKLASTEV(io))
		if (qpio_rbucket (io, IO_EVI(io)) == EOF)
		    goto exit_

	    # Copy out the event pointers.
	    ev = bp + (IO_EVI(io) - IO_BKFIRSTEV(io)) * szs_event
	    nev = min (maxev, IO_BKLASTEV(io) - IO_EVI(io) + 1)

	    do i = 1, nev {
		o_ev[i] = ev
		ev = ev + szs_event
	    }

	    IO_EVI(io) = IO_EVI(io) + nev
	    maskval = 1

	case NoINDEX_RMorBB:
	    # Fully general selection, including any combination of bounding
	    # box, region mask, or EAF, but no index, either because there is
	    # no index for this event list, or the index is for a different Y
	    # attribute than the one being used for extraction.

	    bbused = (IO_BBUSED(io) == YES)
	    x1 = IO_VS(io,1);  x2 = IO_VE(io,1)
	    y1 = IO_VS(io,2);  y2 = IO_VE(io,2)

	    # Refill the event bucket?
	    while (IO_EVI(io) > IO_BKLASTEV(io)) {
		# Get the next bucket.
		if (qpio_rbucket (io, IO_EVI(io)) == EOF)
		    goto exit_

		# Reject buckets that do not contain any events lying
		# within the specified bounding box, if any.

		if (bbused) {
		    ev = IO_MINEVB(io)
			xs = Mems[ev+IO_EVXOFF(io)]
			ys = Mems[ev+IO_EVYOFF(io)]
		    ev = IO_MAXEVB(io)
			xe = Mems[ev+IO_EVXOFF(io)]
			ye = Mems[ev+IO_EVYOFF(io)]

		    if (xs > x2 || xe < x1 || ys > y2 || ye < y1)
			IO_EVI(io) = IO_BKLASTEV(io) + 1
		}
	    }

	    # Copy out any events which pass the region mask and which share
	    # the same mask value.  Note that in this case, to speed mask
	    # value lookup at random mask coordinates, the region mask for
	    # the bounding box is stored as a populated array in the QPIO
	    # descriptor.

	    ev = bp + (IO_EVI(io) - IO_BKFIRSTEV(io) - 1) * szs_event
	    bbmask = IO_BBMASK(io)
	    mval = 0

	    do i = IO_EVI(io), IO_BKLASTEV(io) {
		# Get event x,y coordinates in whatever coord system.
		ev = ev + szs_event
		x = Mems[ev+IO_EVXOFF(io)]
		y = Mems[ev+IO_EVYOFF(io)]

		# Reject events lying outside the bounding box.
		if (bbused)
		    if (x < x1 || x > x2 || y < y1 || y > y2)
			next

		# Take a shortcut if no region mask is in effect for this BB.
		if (bbmask == NULL)
		    goto putevent_

		# Get the region mask pixel value.
		off = (y - y1) * IO_VN(io,2) + x - x1
		mval = Memi[bbmask+off]

		# Accumulate points lying in the first nonzero mask range
		# encountered.

		if (mval != 0) {
		    if (maskval == 0)
			maskval = mval
		    if (mval == maskval) {
putevent_		if (nev >= maxev)
			    break
			nev = nev + 1
			o_ev[nev] = ev
		    } else
			break
		}
	    }

	    IO_EVI(io) = i

	case INDEX_NoRMorBB, INDEX_RMorBB:
	    # General extraction for indexed data.  Process successive ranges
	    # and range lists until we get at least one event which lies within
	    # the bounding box, within a range, and which passes the event
	    # attribute filter, if one is in use.

	    # If the current range list (mask line) has been exhausted, advance
	    # to the next line which contains both ranges and events.  A range
	    # list is used to specify the bounding box even if we don't have
	    # a nonempty region mask within the BB.

	    if (IO_RLI(io) > RLI_LEN(rl)) {
		repeat {
		    y = IO_V(io,2)
		    if (IO_RLI(io) == RLI_INITIALIZE)
			IO_RLI(io) = RL_FIRST
		    else
			y = y + 1

		    if (y > IO_VE(io,2)) {
			if (nev <= 0) {
			    o_nev = EOF
			    return (EOF)
			} else
			    goto done_
		    }

		    IO_V(io,2) = y
		    evi = Memi[IO_YOFFVP(io)+y-1]

		    if (evi > 0) {
			if (IO_RMUSED(io) == YES) {
			    if (IO_LINEIO(io) == YES) {
				if (!pl_linenotempty (pl,IO_V(io,1)))
				    next
			    } else {
				v[1] = IO_V(io,1);  v[2] = y
				if (!pl_sectnotempty (pl,IO_V(io,1),v,NDIM))
				    next
			    }
			    call pl_glri (pl, IO_V(io,1), Memi[rl],
				IO_MDEPTH(io), IO_VN(io,1), PIX_SRC)
			}
			IO_RLI(io) = RL_FIRST
		    }
		} until (IO_RLI(io) <= RLI_LEN(rl))

		IO_EVI(io) = evi
		IO_EV1(io) = evi
		IO_EV2(io) = Memi[IO_YLENVP(io)+y-1] + evi - 1
	    }

	    # Refill the event bucket?
	    if (IO_EVI(io) > IO_BKLASTEV(io))
		if (qpio_rbucket (io, IO_EVI(io)) == EOF)
		    goto exit_

	    # Compute current range parameters and initialize event pointer.
	    rp = rl + (IO_RLI(io) - 1) * RL_LENELEM
	    x1 = Memi[rp+RL_XOFF]
	    x2 = x1 + Memi[rp+RL_NOFF] - 1
	    maskval = Memi[rp+RL_VOFF]

	    ev = bp + (IO_EVI(io) - IO_BKFIRSTEV(io)) * szs_event
	    evtop = min (IO_EV2(io), IO_BKLASTEV(io))

	    # Extract events from bucket which lie within the current range
	    # of the current line.  This is the inner loop of indexed event
	    # extraction, ignoring event attribute filtering.

	    do i = IO_EVI(io), evtop {
		x = Mems[ev+IO_EVXOFF(io)]		# X is assumed SHORT
		if (x >= x1) {
		    if (x > x2) {
			IO_RLI(io) = IO_RLI(io) + 1
			break
		    } else if (nev >= maxev)
			break
		    nev = nev + 1
		    o_ev[nev] = ev
		}
		ev = ev + szs_event
	    }

	    IO_EVI(io) = i
	    if (i > IO_EV2(io))
		IO_RLI(io) = RLI_NEXTLINE
	}
done_
	# Apply the event attribute filter if one is defined; repeat
	# the whole process if we don't end up with any events.

	if (nev > 0)
	    if (ex != NULL)
		nev = qpex_evaluate (ex, o_ev, o_ev, nev)
	if (nev <= 0)
	    goto again_
exit_
	o_nev = nev
	if (o_nev <= 0)
	    o_nev = EOF

	return (o_nev)
end
