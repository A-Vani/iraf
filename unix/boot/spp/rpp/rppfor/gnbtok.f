      INTEGER FUNCTION GNBTOK (TOKEN, TOKSIZ)
      INTEGER TOKEN (100)
      INTEGER TOKSIZ
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
      INTEGER GETTOK
      CALL SKPBLK
23000 CONTINUE
      GNBTOK = GETTOK (TOKEN, TOKSIZ)
23001 IF (.NOT.(GNBTOK .NE. 32))GOTO 23000
23002 CONTINUE
      RETURN
      END
C     LOGIC0  LOGICAL_COLUMN
