include	<math.h>

# AST_HJD -- Helocentric Julian Day

procedure ast_hjd (ra, dec, epoch, t, hjd)

double	ra		# Right ascension of observation (hours)
double	dec		# Declination of observation (degrees)
double	epoch		# Julian epoch of observation
double	lt		# Light travel time in seconds
double	hjd		# Helocentric Julian Day

double	jd, t, manom, lperi, oblq, eccen, tanom, slong, r, d, l, b, rsun
double	ast_julday()

begin
	# JD is the geocentric Julian date.
	# T is the number of Julian centuries since J1900.

	jd = ast_julday (epoch)
	t = (jd - 2415020) / 36525.

	# MANOM is the mean anomaly of the Earth's orbit (degrees)
	# LPERI is the mean longitude of perihelion (degrees)
	# OBLQ is the mean obliquity of the ecliptic (degrees)
	# ECCEN is the eccentricity of the Earth's orbit (dimensionless)

	manom = 358.47583 + t * (35999.04975 - t * (0.000150 + t * 0.000003))
	lperi = 101.22083 + t * (1.7191733 + t * (0.000453 + t * 0.000003))
	oblq = 23.452294 - t * (0.0130125 + t * (0.00000164 - t * 0.000000503))
	eccen = 0.01675104 - t * (0.00004180 + t * 0.000000126)

	# Convert to principle angles
	manom = mod (manom, 360.0D0)
	lperi = mod (lperi, 360.0D0)

	# Convert to radians
	r = DEGTORAD(ra * 15)
	d = DEGTORAD(dec)
	manom = DEGTORAD(manom)
	lperi = DEGTORAD(lperi)
	oblq = DEGTORAD(oblq)

	# TANOM is the true anomaly (approximate formula) (radians)
	tanom = manom + (2 * eccen - 0.25 * eccen**3) * sin (manom) +
	    1.25 * eccen**2 * sin (2 * manom) +
	    13./12. * eccen**3 * sin (3 * manom)

	# SLONG is the true longitude of the Sun seen from the Earth (radians)
	slong = lperi + tanom + PI

	# L and B are the longitude and latitude of the star in the orbital
	# plane of the Earth (radians)

	call ast_coord (double (0.), double (0.), double (-HALFPI),
	    HALFPI - oblq, r, d, l, b)

	# R is the distance to the Sun.
	rsun = (1. - eccen**2) / (1. + eccen * cos (tanom))

	# LT is the light travel difference to the Sun.
	lt = -0.005770 * rsun * cos (b) * cos (l - slong)
	hjd = jd + lt
end
