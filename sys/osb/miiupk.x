# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<mii.h>

# MIIUPK -- Unpack a MII array of type mii_type into a SPP array of type
# spp_type.  The mii_types are defined in mii.h.

procedure miiupk (mii, spp, nelems, mii_datatype, spp_datatype)

int	mii[ARB]		# output MII format array
int	spp[ARB]		# input array of SPP integers
int	nelems			# number of integers to be converted
int	mii_datatype		# MII datatype code
int	spp_datatype		# SPP datatype code

begin
	switch (mii_datatype) {
	case MII_BYTE:
	    call miiupk8  (mii, spp, nelems, spp_datatype)
	case MII_SHORT:
	    call miiupk16 (mii, spp, nelems, spp_datatype)
	case MII_LONG:
	    call miiupk32 (mii, spp, nelems, spp_datatype)
	}
end
