#include <stdio.h>
#define import_spp
#define	import_kernel
#include <iraf.h>

#define	SZ_PROCNAME	32

/* Allocate ZFD, the global data structure for the kernel file i/o system.
 * Also allocate a buffer for the process name, used by the error handling
 * code to identify the process generating an abort.
 */
struct	fiodes zfd[MAXOFILES] = STDIO_FILES;
char	os_process_name[SZ_PROCNAME];
PKCHAR	osfn_bkgfile[SZ_PATHNAME/sizeof(PKCHAR)+1];
int	save_prtype = 0;
