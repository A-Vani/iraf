/* RINDEX -- Return pointer to the last occurrence of a character in a string,
 * or null if the char is not found.
 */
char *
rindex (str, ch)
char	*str;
register int ch;
{
	register char	*ip;
	register int	cch;
	char	*last;

	for (ip=str, last=0;  (cch = *ip);  ip++)
	    if (cch == ch)
		last = ip;

	return (last);
}
