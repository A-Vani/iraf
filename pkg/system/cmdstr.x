# Copyright(c) 1986 Association of Universities for Research in Astronomy Inc.

include	<ctype.h>

define	SZ_CMDSTR	4096

# CMDSTR -- Read the output of LPARAM and format a command string giving
# the values of all parameters.

procedure t_cmdstr()

bool	hidden, hparam
pointer	sp, ltask, ibuf, obuf, ip, op, nl, last
int	getline(), gstrcpy(), strncmp()
bool	clgetb()

begin
	call smark (sp)
	call salloc (ltask, SZ_FNAME, TY_CHAR)
	call salloc (ibuf, SZ_LINE, TY_CHAR)
	call salloc (obuf, SZ_CMDSTR, TY_CHAR)

	# Get the task name and whether to print hidden parameters.
	call clgstr ("task", Memc[ltask], SZ_FNAME)
	hidden = clgetb ("hidden")

	op = obuf + gstrcpy (Memc[ltask], Memc[obuf], SZ_CMDSTR)
	Memc[op] = ' ';  op = op + 1
	Memc[op] = '(';  op = op + 1

	last = NULL
	nl   = NULL

	while (getline (STDIN, Memc[ibuf]) != EOF) {
	    ip = ibuf

	    # Skip white space.
	    while (IS_WHITE (Memc[ip]))
		ip = ip + 1

	    # Check if the parameter is hidden and skip it if desired.
	    if (Memc[ip] == '(') {
		if (!hidden)
		    next
		hparam = true
		ip = ip + 1
	    } else
		hparam = false

	    # Check if parameter name is "mode" and skip it.
	    if (strncmp (Memc[ip], "mode", 4) == 0)
		next

	    # Copy or skip parameter name.
	    while (!IS_WHITE (Memc[ip])) {
		if (hparam) {
		    Memc[op] = Memc[ip]
		    op = op + 1
	        }
		ip = ip + 1
	    }

	    # Copy or skip = and skip whitespace.
	    if (hparam) {
	        Memc[op] = '='
	        op = op + 1
	    }
	    ip = ip + 3

	    # Copy parameter value.  It is an error if there is no value.
	    if (IS_WHITE (Memc[ip]) || (Memc[ip] == ')'))
		call error (1, "Undefined parameter value")

	    # If the parameter is a quoted string copy until the closing quote,
	    # otherwise copy until whitespace or ).

	    if (Memc[ip] == '"') {
		Memc[op] = Memc[ip]
		ip = ip + 1
		op = op + 1
		while (Memc[ip] != '"') {
		    Memc[op] = Memc[ip]
		    ip = ip + 1
		    op = op + 1
		}
		Memc[op] = Memc[ip]
		ip = ip + 1
		op = op + 1

	    } else {
		while (!IS_WHITE(Memc[ip]) && (Memc[ip] != ')')) {
		    Memc[op] = Memc[ip]
		    ip = ip + 1
		    op = op + 1
		}
	    }

	    # Add a comma and a space.
	    Memc[op] = ','
	    op = op + 1
	    Memc[op] = ' '
	    op = op + 1

	    # Replace the last break with a new line if the line exceeds max.
	    if ((op - nl > 80) && (last > 0)) {
		Memc[last] = '\n'
		nl = last
	    }
	    last = op - 1
	}

	# Replace last comma and space by a parenthesis and EOS.
	if (Memc[op-2] == ',')
	    op = op - 2

	Memc[op] = ')'
	op = op + 1
	Memc[op] = EOS

	# Print the command string and finish up.
	call putline (STDOUT, Memc[obuf])
	call putci   (STDOUT, '\n')

	call sfree (sp)
end
