/* Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.
 */

#define	import_spp
#define	import_libc
#define	import_xnames
#include <iraf.h>

#define	MAX_STRLEN	1024

/* C_UNGETLINE -- Push a string back into the input stream.  Pushback is last
 * in first out, i.e., the last string pushed back is the first one read by
 * GETC.  Strings (and single characters) may be pushed back until the FIO
 * pushback buffer overflows.
 */
c_ungetline (fd, str)
int	fd;			/* file				*/
char	*str;			/* string to be pushed back	*/
{
	XCHAR	spp_str[MAX_STRLEN];

	iferr (UNGETLINE (&fd, c_strupk (str, spp_str, MAX_STRLEN)))
	    return (ERR);
	else
	    return (OK);
}
