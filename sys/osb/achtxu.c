/* Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.
 */

#define	import_spp
#define import_knames
#include <iraf.h>

/* ACHT_U -- Pack an SPP datatype array into an unsigned short integer.
 * [MACHDEP]: The underscore appended to the procedure name is OS dependent.
 */
ACHTXU (a, b, npix)
XCOMPLEX	*a;
XUSHORT	*b;
XINT	*npix;
{
	register XCOMPLEX		*ip;
	register XUSHORT	*op;
	register int		n = *npix;

	if (sizeof(*op) > sizeof(*ip)) {
	    for (ip = &a[n], op = &b[n];  ip > a;  )
		    *--op = (int) (--ip)->r;
	} else {
	    for (ip=a, op=b;  --n >= 0;  )
		    *op++ = (int) (ip++)->r;
	}
}
