include	"ecidentify.h"

# EC_DOFIT -- Fit an echelle function to the features.  Eliminate INDEF points.

procedure ec_dofit (ec, interactive)

pointer	ec			# EC pointer
int	interactive		# Interactive fit?

int	i, j, k, nfit
double	xmin, xmax, ymin, ymax
pointer	gt1, ecf
pointer	sp, x, y, z, w, gt_init()
errchk	ecf_fit

begin
	# Count number of points and determine the order range.
	j = ORDER(ec,1)
	k = ORDER(ec,1)
	nfit = 0
	for (i=1; i<=EC_NFEATURES(ec); i=i+1) {
	    if (IS_INDEFD (PIX(ec,i)) || IS_INDEFD (USER(ec,i)))
		next
	    j = min (j, ORDER(ec,i))
	    k = max (k, ORDER(ec,i))
	    nfit = nfit + 1
	}

	# Require at least 4 points and more than one order.
	if (nfit < 4 || j == k) {
	    if (EC_ECF(ec) != NULL) {
	        call dgs_free (EC_ECF(ec))
		call ecf_setd ("shift", 0.D0)
	        EC_NEWGRAPH(ec) = YES
	        EC_NEWECF(ec) = YES
	    }
	    return
	}

	# Allocate arrays for points to be fit and fill them in.
	call smark (sp)
	call salloc (x, nfit, TY_DOUBLE)
	call salloc (y, nfit, TY_DOUBLE)
	call salloc (z, nfit, TY_DOUBLE)
	call salloc (w, nfit, TY_DOUBLE)

	do i = 1, nfit {
	    if (IS_INDEFD (PIX(ec,i)) || IS_INDEFD (USER(ec,i)))
		next
	    Memd[x+i-1] = PIX(ec,i)
	    Memd[y+i-1] = AP(ec,i)
	    Memd[z+i-1] = USER(ec,i)
	    Memd[w+i-1] = 1.
	}

	# Initialize fit limits.
	xmin = 1
	xmax = EC_NPTS(ec)
	call alimi (APS(ec,1), EC_NLINES(ec), i, j)
	ymin = i
	ymax = j

	call ecf_setd ("xmin", xmin)
	call ecf_setd ("xmax", xmax)
	call ecf_setd ("ymin", ymin)
	call ecf_setd ("ymax", ymax)

	# Fit the echelle dispersion function.
	ecf = EC_ECF(ec)
	if (interactive == YES) {
	    gt1 = gt_init()
	    call ecf_fit (ecf, EC_GP(ec), gt1, Memd[x], Memd[y],
		Memd[z], Memd[w], nfit)
	    call gt_free (gt1)
	} else
	    call ecf_fit (ecf, NULL, NULL, Memd[x], Memd[y], Memd[z],
		Memd[w], nfit)
	EC_ECF(ec) = ecf

	# Remove any deleted points.
	j = 0
	k = 0
	do i = 1, EC_NFEATURES(ec) {
    	    if (IS_INDEFD (PIX(ec,j+1)) || IS_INDEFD (USER(ec,j+1))) {
		j = j + 1
		next
	    }
	    k = k + 1
	    if (Memd[w+k-1] != 0.) {
	        j = j + 1
    	        AP(ec,j) = AP(ec,k)
    	        LINE(ec,j) = LINE(ec,k)
    	        ORDER(ec,j) = ORDER(ec,k)
    	        PIX(ec,j) = PIX(ec,k)
    	        FIT(ec,j) = FIT(ec,k)
    	        USER(ec,j) = USER(ec,k)
    	        FWIDTH(ec,j) = FWIDTH(ec,k)
    	        FTYPE(ec,j) = FTYPE(ec,k)
	    }
	}
	EC_NFEATURES(ec) = j

	# Set flags.
	EC_NEWECF(ec) = YES
	EC_NEWGRAPH(ec) = YES

	call sfree (sp)
end
