# ILP32.H -- Datatype Definitions.  These definitions are automatically
# included in every SPP program.  See also hconfig$mach.h.

define	SZ_BOOL		2		# sizes of the primitive types in chars
define	SZ_CHAR		1
define	SZ_SHORT	1
define	SZ_INT		2
define	SZ_LONG		2
define	SZ_REAL		2
define	SZ_DOUBLE	4
define	SZ_COMPLEX	4
define	SZ_POINTER	2
define	SZ_SIZE_T	2
define	SZ_STRUCT	2
define	SZ_USHORT	1

define	INDEFS		(-32767)
define	INDEFL		(-2147483647)
define	INDEFI		INDEFL
define	INDEFZ		INDEFL

define	INDEFR		1.6e38
define	INDEFD		1.6d308
define	INDEFX		(INDEF,INDEF)
define	INDEF		INDEFR

define	IS_INDEFS	(($1)==INDEFS)
define	IS_INDEFL	(($1)==INDEFL)
define	IS_INDEFI	(($1)==INDEFI)
define	IS_INDEFR	(($1)==INDEFR)
define	IS_INDEFD	(($1)==INDEFD)
define	IS_INDEFX	(real($1)==INDEFR)
define	IS_INDEFZ	(($1)==INDEFZ)
define	IS_INDEF	(($1)==INDEFR)

define	P2C	((($1)-1)*2+1)
define	P2S	((($1)-1)*2+1)
define	P2I	($1)
define	P2B	($1)
define	P2L	($1)
define	P2R	($1)
define	P2D	((($1)-1)/2+1)
define	P2X	((($1)-1)/2+1)
define	P2Z	($1)

define	MAX_SHORT	32767		# largest numbers
define	MAX_INT		2147483647
define	MAX_LONG	2147483647
define	NBITS_BYTE	8		# nbits in a machine byte
define	NBITS_SHORT	16		# nbits in a short	
define	NBITS_INT	32		# nbits in an integer	
define	NBITS_LONG	32		# nbits in an long   	