# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include "ids.h"

# IDS_GRSTREAM -- Set the FD of the graphics/image stream, to which
# we return cell arrays and cursor values.

procedure ids_grstream (stream)

int stream

include "ids.com"

begin
	i_in = stream
end
