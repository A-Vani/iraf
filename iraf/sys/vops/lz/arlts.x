# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

# ARLT -- Replace if less than.  If A[i] is less than FLOOR replace by NEWVAL.

procedure arlts (a, npix, floor, newval)

short	a[ARB]
size_t	npix
short	floor, newval
size_t	i

begin

	do i = 1, npix
	    if (a[i] < floor)
		a[i] = newval
end
