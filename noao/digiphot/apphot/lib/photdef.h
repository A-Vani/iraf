# PHOT header file

define	LEN_PHOTSTRUCT		(25 +  SZ_FNAME + SZ_LINE +  2)

# photmetry aperture parameters

define	AP_NAPERTS		Memi[$1]	# Number of apertures
define	AP_PXCUR		Memr[$1+1]	# X aperture center
define	AP_PYCUR		Memr[$1+2]	# Y aperture center
define	AP_NMAXAP		Memi[$1+3]	# Maximum number of apertures
define	AP_APERTS		Memi[$1+4]	# Pointer to aperture array
define	AP_APIX			Memi[$1+5]	# Pointer to pixels
define	AP_XAPIX		Memi[$1+6]	# Pointer to x coords array
define	AP_YAPIX		Memi[$1+7]	# Pointer to y coords array
define	AP_NAPIX		Memi[$1+8]	# Number of pixels
define	AP_LENABUF		Memi[$1+9]	# Size of pixels buffer
define	AP_AXC			Memr[$1+10]	# X center of subraster
define	AP_AYC			Memr[$1+11]	# X center of subraster
define	AP_ANX			Memi[$1+12]	# X dimension of subraster
define	AP_ANY			Memi[$1+13]	# Y dimension of subraster

# photometry output

define	AP_MAGS			Memi[$1+14]	# Pointer to magnitude array
define	AP_MAGERRS		Memi[$1+15]	# Pointer to mag errors array
define	AP_AREA			Memi[$1+16]	# Pointer to areas array
define	AP_SUMS			Memi[$1+17]	# Pointer to aperture sums array

# photometry parameters

define	AP_ZMAG		Memr[$1+18]		# Zero point of magnitude scale
define	AP_PWEIGHTS	Memi[$1+20]		# Weighting function for ophot
define	AP_PWSTRING	Memc[P2C($1+22)]	# Weights string
define	AP_APSTRING	Memc[P2C($1+22+SZ_FNAME+1)] # Apertures string

# phot default defintions

define	DEF_ZMAG		26.0
define	DEF_APERTS		"3.0"
define	DEF_PWEIGHTS		AP_PWCONSTANT
