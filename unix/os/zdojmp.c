#include <stdio.h>
#define import_spp
#define	import_kernel
#define	import_knames
#include <iraf.h>

/* ZDOJMP -- Restore the saved processor context (non-local goto).  See also
 * as$zsvjmp.s, where most of the work is done.
 */
ZDOJMP (jmpbuf, status)
XINT	*jmpbuf;
XINT	*status;
{
	*((int *)jmpbuf[0]) = *status;
	longjmp (&jmpbuf[1], *status);
}
