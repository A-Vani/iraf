      SUBROUTINE ENTRKW
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
      INTEGER SIF(3)
      INTEGER SELSE(5)
      INTEGER SWHILE(6)
      INTEGER SDO(3)
      INTEGER SBREAK(6)
      INTEGER SNEXT(5)
      INTEGER SFOR(4)
      INTEGER SREPT(7)
      INTEGER SUNTIL(6)
      INTEGER SRET(7)
      INTEGER SSTR(7)
      INTEGER SSWTCH(7)
      INTEGER SCASE(5)
      INTEGER SDEFLT(8)
      INTEGER SEND(4)
      INTEGER SERRC0(7)
      INTEGER SIFERR(6)
      INTEGER SIFNO0(8)
      INTEGER STHEN(5)
      INTEGER SBEGIN(6)
      INTEGER SPOINT(8)
      INTEGER SGOTO(5)
      DATA SIF(1)/105/,SIF(2)/102/,SIF(3)/-2/
      DATA SELSE(1)/101/,SELSE(2)/108/,SELSE(3)/115/,SELSE(4)/101/,SELSE
     *(5)/-2/
      DATA SWHILE(1)/119/,SWHILE(2)/104/,SWHILE(3)/105/,SWHILE(4)/108/,S
     *WHILE(5)/101/,SWHILE(6)/-2/
      DATA SDO(1)/100/,SDO(2)/111/,SDO(3)/-2/
      DATA SBREAK(1)/98/,SBREAK(2)/114/,SBREAK(3)/101/,SBREAK(4)/97/,SBR
     *EAK(5)/107/,SBREAK(6)/-2/
      DATA SNEXT(1)/110/,SNEXT(2)/101/,SNEXT(3)/120/,SNEXT(4)/116/,SNEXT
     *(5)/-2/
      DATA SFOR(1)/102/,SFOR(2)/111/,SFOR(3)/114/,SFOR(4)/-2/
      DATA SREPT(1)/114/,SREPT(2)/101/,SREPT(3)/112/,SREPT(4)/101/,SREPT
     *(5)/97/,SREPT(6)/116/,SREPT(7)/-2/
      DATA SUNTIL(1)/117/,SUNTIL(2)/110/,SUNTIL(3)/116/,SUNTIL(4)/105/,S
     *UNTIL(5)/108/,SUNTIL(6)/-2/
      DATA SRET(1)/114/,SRET(2)/101/,SRET(3)/116/,SRET(4)/117/,SRET(5)/1
     *14/,SRET(6)/110/,SRET(7)/-2/
      DATA SSTR(1)/115/,SSTR(2)/116/,SSTR(3)/114/,SSTR(4)/105/,SSTR(5)/1
     *10/,SSTR(6)/103/,SSTR(7)/-2/
      DATA SSWTCH(1)/115/,SSWTCH(2)/119/,SSWTCH(3)/105/,SSWTCH(4)/116/,S
     *SWTCH(5)/99/,SSWTCH(6)/104/,SSWTCH(7)/-2/
      DATA SCASE(1)/99/,SCASE(2)/97/,SCASE(3)/115/,SCASE(4)/101/,SCASE(5
     *)/-2/
      DATA SDEFLT(1)/100/,SDEFLT(2)/101/,SDEFLT(3)/102/,SDEFLT(4)/97/,SD
     *EFLT(5)/117/,SDEFLT(6)/108/,SDEFLT(7)/116/,SDEFLT(8)/-2/
      DATA SEND(1)/101/,SEND(2)/110/,SEND(3)/100/,SEND(4)/-2/
      DATA SERRC0(1)/101/,SERRC0(2)/114/,SERRC0(3)/114/,SERRC0(4)/99/,SE
     *RRC0(5)/104/,SERRC0(6)/107/,SERRC0(7)/-2/
      DATA SIFERR(1)/105/,SIFERR(2)/102/,SIFERR(3)/101/,SIFERR(4)/114/,S
     *IFERR(5)/114/,SIFERR(6)/-2/
      DATA SIFNO0(1)/105/,SIFNO0(2)/102/,SIFNO0(3)/110/,SIFNO0(4)/111/,S
     *IFNO0(5)/101/,SIFNO0(6)/114/,SIFNO0(7)/114/,SIFNO0(8)/-2/
      DATA STHEN(1)/116/,STHEN(2)/104/,STHEN(3)/101/,STHEN(4)/110/,STHEN
     *(5)/-2/
      DATA SBEGIN(1)/98/,SBEGIN(2)/101/,SBEGIN(3)/103/,SBEGIN(4)/105/,SB
     *EGIN(5)/110/,SBEGIN(6)/-2/
      DATA SPOINT(1)/112/,SPOINT(2)/111/,SPOINT(3)/105/,SPOINT(4)/110/,S
     *POINT(5)/116/,SPOINT(6)/101/,SPOINT(7)/114/,SPOINT(8)/-2/
      DATA SGOTO(1)/103/,SGOTO(2)/111/,SGOTO(3)/116/,SGOTO(4)/111/,SGOTO
     *(5)/-2/
      CALL ENTER (SIF, -99, RKWTBL)
      CALL ENTER (SELSE, -87, RKWTBL)
      CALL ENTER (SWHILE, -95, RKWTBL)
      CALL ENTER (SDO, -96, RKWTBL)
      CALL ENTER (SBREAK, -79, RKWTBL)
      CALL ENTER (SNEXT, -78, RKWTBL)
      CALL ENTER (SFOR, -94, RKWTBL)
      CALL ENTER (SREPT, -93, RKWTBL)
      CALL ENTER (SUNTIL, -70, RKWTBL)
      CALL ENTER (SRET, -77, RKWTBL)
      CALL ENTER (SSTR, -75, RKWTBL)
      CALL ENTER (SSWTCH, -92, RKWTBL)
      CALL ENTER (SCASE, -91, RKWTBL)
      CALL ENTER (SDEFLT, -90, RKWTBL)
      CALL ENTER (SEND, -82, RKWTBL)
      CALL ENTER (SERRC0, -84, RKWTBL)
      CALL ENTER (SIFERR, -98, RKWTBL)
      CALL ENTER (SIFNO0, -97, RKWTBL)
      CALL ENTER (STHEN, -86, RKWTBL)
      CALL ENTER (SBEGIN, -83, RKWTBL)
      CALL ENTER (SPOINT, -88, RKWTBL)
      CALL ENTER (SGOTO, -76, RKWTBL)
      RETURN
      END
C     SIFNO0  SIFNOERR
C     LOGIC0  LOGICAL_COLUMN
C     SERRC0  SERRCHK
