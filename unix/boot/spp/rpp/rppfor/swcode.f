      SUBROUTINE SWCODE (LAB)
      INTEGER LAB
      COMMON /CDEFIO/ BP, BUF (4096)
      INTEGER BP
      INTEGER BUF
      COMMON /CFNAME/ FCNAME (30)
      INTEGER FCNAME
      COMMON /CFOR/ FORDEP, FORSTK (200)
      INTEGER FORDEP
      INTEGER FORSTK
      COMMON /CGOTO/ XFER
      INTEGER XFER
      COMMON /CLABEL/ LABEL, RETLAB, MEMFLG, COL, LOGIC0
      INTEGER LABEL
      INTEGER RETLAB
      INTEGER MEMFLG
      INTEGER COL
      INTEGER LOGIC0
      COMMON /CLINE/ LEVEL, LINECT (5), INFILE (5), FNAMP, FNAMES ( 150)
      INTEGER LEVEL
      INTEGER LINECT
      INTEGER INFILE
      INTEGER FNAMP
      INTEGER FNAMES
      COMMON /CMACRO/ CP, EP, EVALST (500), DEFTBL
      INTEGER CP
      INTEGER EP
      INTEGER EVALST
      INTEGER DEFTBL
      COMMON /COUTLN/ OUTP, OUTBUF (74)
      INTEGER OUTP
      INTEGER OUTBUF
      COMMON /CSBUF/ SBP, SBUF(2048), SMEM(240)
      INTEGER SBP
      INTEGER SBUF
      INTEGER SMEM
      COMMON /CSWTCH/ SWTOP, SWLAST, SWSTAK(1000), SWVNUM, SWVLEV, SWVST
     *K(10), SWINRG
      INTEGER SWTOP
      INTEGER SWLAST
      INTEGER SWSTAK
      INTEGER SWVNUM
      INTEGER SWVLEV
      INTEGER SWVSTK
      INTEGER SWINRG
      COMMON /CKWORD/ RKWTBL
      INTEGER RKWTBL
      COMMON /CLNAME/ FKWTBL, NAMTBL, GENTBL, ERRTBL, XPPTBL
      INTEGER FKWTBL
      INTEGER NAMTBL
      INTEGER GENTBL
      INTEGER ERRTBL
      INTEGER XPPTBL
      COMMON /ERCHEK/ ERNAME, BODY, ESP, ERRSTK(30)
      INTEGER ERNAME
      INTEGER BODY
      INTEGER ESP
      INTEGER ERRSTK
      INTEGER MEM( 60000)
      COMMON/CDSMEM/MEM
      INTEGER TOK (100)
      INTEGER LABGEN, GNBTOK
      LAB = LABGEN (2)
      SWVNUM = SWVNUM + 1
      SWVLEV = SWVLEV + 1
      IF (.NOT.(SWVLEV .GT. 10))GOTO 23000
      CALL BADERR (27Hswitches nested too deeply.)
23000 CONTINUE
      SWVSTK(SWVLEV) = SWVNUM
      IF (.NOT.(SWLAST + 3 .GT. 1000))GOTO 23002
      CALL BADERR (22Hswitch table overflow.)
23002 CONTINUE
      SWSTAK (SWLAST) = SWTOP
      SWSTAK (SWLAST + 1) = 0
      SWSTAK (SWLAST + 2) = 0
      SWTOP = SWLAST
      SWLAST = SWLAST + 3
      XFER = 0
      CALL OUTTAB
      CALL SWVAR (SWVNUM)
      CALL OUTCH (61)
      CALL BALPAR
      CALL OUTDWE
      CALL OUTGO (LAB)
      CALL INDENT (1)
      XFER = 1
23004 IF (.NOT.(GNBTOK (TOK, 100) .EQ. 10))GOTO 23005
      GOTO 23004
23005 CONTINUE
      IF (.NOT.(TOK (1) .NE. 123))GOTO 23006
      CALL SYNERR (39Hmissing left brace in switch statement.)
      CALL PBSTR (TOK)
23006 CONTINUE
      RETURN
      END
C     LOGIC0  LOGICAL_COLUMN
