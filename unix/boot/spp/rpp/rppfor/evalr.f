      SUBROUTINE EVALR (ARGSTK, I, J)
      INTEGER ARGSTK (100), I, J
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
      INTEGER ARGNO, K, M, N, T, TD, INSTR0, DELIM
      EXTERNAL INDEX
      INTEGER INDEX, LENGTH
      INTEGER DIGITS(11)
      DATA DIGITS(1)/48/,DIGITS(2)/49/,DIGITS(3)/50/,DIGITS(4)/51/,DIGIT
     *S(5)/52/,DIGITS(6)/53/,DIGITS(7)/54/,DIGITS(8)/55/,DIGITS(9)/56/,D
     *IGITS(10)/57/,DIGITS(11)/-2/
      T = ARGSTK (I)
      TD = EVALST (T)
      IF (.NOT.(TD .EQ. -10))GOTO 23000
      CALL DOMAC (ARGSTK, I, J)
      GOTO 23001
23000 CONTINUE
      IF (.NOT.(TD .EQ. -12))GOTO 23002
      CALL DOINCR (ARGSTK, I, J)
      GOTO 23003
23002 CONTINUE
      IF (.NOT.(TD .EQ. -13))GOTO 23004
      CALL DOSUB (ARGSTK, I, J)
      GOTO 23005
23004 CONTINUE
      IF (.NOT.(TD .EQ. -11))GOTO 23006
      CALL DOIF (ARGSTK, I, J)
      GOTO 23007
23006 CONTINUE
      IF (.NOT.(TD .EQ. -14))GOTO 23008
      CALL DOARTH (ARGSTK, I, J)
      GOTO 23009
23008 CONTINUE
      INSTR0 = 0
      K = T + LENGTH (EVALST (T)) - 1
23010 IF (.NOT.(K .GT. T))GOTO 23012
      IF (.NOT.(EVALST(K) .EQ. 39 .OR. EVALST(K) .EQ. 34))GOTO 23013
      IF (.NOT.(INSTR0 .EQ. 0))GOTO 23015
      DELIM = EVALST(K)
      INSTR0 = 1
      GOTO 23016
23015 CONTINUE
      INSTR0 = 0
23016 CONTINUE
      CALL PUTBAK (EVALST(K))
      GOTO 23014
23013 CONTINUE
      IF (.NOT.(EVALST(K-1) .NE. 36 .OR. INSTR0 .EQ. 1))GOTO 23017
      CALL PUTBAK (EVALST (K))
      GOTO 23018
23017 CONTINUE
      ARGNO = INDEX (DIGITS, EVALST (K)) - 1
      IF (.NOT.(ARGNO .GE. 0 .AND. ARGNO .LT. J - I))GOTO 23019
      N = I + ARGNO + 1
      M = ARGSTK (N)
      CALL PBSTR (EVALST (M))
23019 CONTINUE
      K = K - 1
23018 CONTINUE
23014 CONTINUE
23011 K = K - 1
      GOTO 23010
23012 CONTINUE
      IF (.NOT.(K .EQ. T))GOTO 23021
      CALL PUTBAK (EVALST (K))
23021 CONTINUE
23009 CONTINUE
23007 CONTINUE
23005 CONTINUE
23003 CONTINUE
23001 CONTINUE
      RETURN
      END
C     LOGIC0  LOGICAL_COLUMN
C     INSTR0  IN_STRING
