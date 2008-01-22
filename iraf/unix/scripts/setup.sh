#!/bin/sh

########################################################################
########################################################################

set_irafenv() {
  #
  IRAFARCH="$MACH"
  #
  if [ "$iraf" = "" ]; then
    iraf="${PREFIX}/iraf/iraf/"
  fi
  export iraf MACH IRAFARCH
  #
  HOSTID="unix"
  host="${iraf}unix/"
  #
  hconfig="${host}config/"
  hlib="${host}lib/"
  hbin="${host}bin/"
  hscripts="${host}scripts/"
  hinclude="${host}include/"
  tmp="/tmp/"
  export HOSTID host hconfig hlib hbin hscripts hinclude tmp
  #
  CC="gcc"
  F77="${hscripts}f77.sh"
  F2C="${hbin}f2c.e"
  RANLIB="ranlib"
  export CC F77 F2C RANLIB
  #
  # basic settings
  #
  HSI_CF="-O -Wall -I$hinclude -DPREFIX=\\\"$PREFIX\\\""
  HSI_XF="-Inolibc -w -/Wunused"
  HSI_XF="-Wall"
  HSI_FF="-O -Wall"
  HSI_LF=""
  HSI_F77LIBS=""
  HSI_LFLAGS=""
  HSI_OSLIBS=""
  #
  mkzflags="'lflags=-Nxz -/Wl,-Bstatic'"
  #
  XC_CFLAGS="-Wall"
  XC_FFLAGS="-Wall"
  #XC_CFLAGS="-I$hinclude -Wall"
  #XC_FFLAGS="-Ns1602 -Nx512"
  #
  # architecture-dependent settings
  #
  F=""
  if [ "$ARCHITECTURE" = "i386" ]; then
    F="$F -DI386"
  elif [ "$ARCHITECTURE" = "x86_64" ]; then
    F="$F -DX86_64"
  fi
  #
  if [ "$SPP_DATA_MODEL" = "ilp64" ]; then
    F="$F -DSPP_ILP64"
  elif [ "$SPP_DATA_MODEL" = "lp64" ]; then
    F="$F -DSPP_LP64"
  fi
  HSI_CF="$HSI_CF $F"
  XC_CFLAGS="$XC_CFLAGS $F"
  XC_FFLAGS="$XC_FFLAGS $F"
  F=""
  #
  # OS-dependent settings
  #
  if [ "$OPERATING_SYSTEM" = "linux" ]; then
    HSI_CF="$HSI_CF -DLINUX -DPOSIX -DSYSV"
  fi
  #
  if [ "$1" = "novos" ]; then
    HSI_CF="$HSI_CF -DNOVOS"
    HSI_LIBS="${hlib}libboot.a ${hlib}libos.a"
  else
    HSI_LIBS="${hlib}libboot.a ${iraf}lib/libsys.a ${iraf}lib/libvops.a ${hlib}libos.a"
  fi
  export HSI_CF HSI_XF HSI_FF HSI_LF HSI_F77LIBS HSI_LFLAGS HSI_OSLIBS
  export mkzflags HSI_LIBS
  export XC_CFLAGS XC_FFLAGS

  # see tables/lib/zzsetenv.def
  #tables=${iraf}tables/
  #tablesbin=${tables}bin/
  #tableslib=${tables}lib/
  #export tables tablesbin tableslib

  # see noao/lib/zzsetenv.def
  #noao=${iraf}noao/
  #noaobin=${noao}bin/
  #noaolib=${noao}lib/
  #export noao noaobin noaolib

  cincludes="$hinclude"
  export cincludes
  #pkglibs=${noaobin},${noaolib},${tablesbin},${tableslib}
  #export pkglibs

  #PATH=${PREFIX}/iraf/local/bin:$PATH
}

########################################################################

set_mach () {

  ARG_MACH="`echo $1 | tr 'A-Z' 'a-z'`"
  
  if [ "$ARG_MACH" = "auto" ]; then
    #
    UNAME_M="`uname -m | tr 'A-Z' 'a-z'`"
    ARCHITECTURE="`echo $UNAME_M | sed -e 's/^i[3456]86$/i386/'`"
    OPERATING_SYSTEM="`uname -s | tr 'A-Z' 'a-z'`"
    VENDOR="generic"
    #
  else
    #
    ARCHITECTURE="`echo $ARG_MACH | sed -e 's/-.*//'`"
    OPERATING_SYSTEM="`echo $ARG_MACH | sed -e 's/^[^-]*-//' -e 's/-.*//'`"
    VENDOR="`echo $ARG_MACH | sed -e 's/^.*-//'`"
    #
  fi

  if [ "$ARCHITECTURE" = "x86_64" ]; then
    #SPP_DATA_MODEL="lp64"
    SPP_DATA_MODEL="ilp64"
  else
    SPP_DATA_MODEL="ilp32"
  fi
  
  MACH="${ARCHITECTURE}-${OPERATING_SYSTEM}-${VENDOR}"
}

########################################################################

set_config () {

  # zsvjmp.s settings
  #if [ -f ${host}as.${MACH}/zsvjmp.${SPP_DATA_MODEL}.s ]; then
  #  ( cd ${host}as.${MACH} ; rm -f zsvjmp.s ; ln -s zsvjmp.${SPP_DATA_MODEL}.s zsvjmp.s )
  #fi
  # mach.h, iraf.h settings
  #if [ -f ${hconfig}iraf.${SPP_DATA_MODEL}.h ]; then
    #( cd ${hconfig} ; rm -f iraf.h ; ln -s iraf.${SPP_DATA_MODEL}.h iraf.h )
    #( cd ${hconfig} ; rm -f mach.h ; ln -s mach.${SPP_DATA_MODEL}.h mach.h )
  #  ( cd ${hconfig} ; rm -f f2c.h ; ln -s f2c.${SPP_DATA_MODEL}.h f2c.h )
    #( cd ${hconfig} ; rm -f entxkw.f ; ln -s entxkw.${SPP_DATA_MODEL}.f entxkw.f )
  #else
  #  echo "[ERROR] No such data model: ${SPP_DATA_MODEL}"
  #  exit 1
  #fi

  # mkpkg.inc settings

  LFLAGS="-Nz"
  #if [ "$OPERATING_SYSTEM" = "freebsd" ]; then
  #  LFLAGS="-z -/static"
  #fi

  cat <<EOF > ${hconfig}mkpkg.inc
# Global (possibly system dependent) definitions for MKPKG.

\$verbose

\$set	MACH		= \$(IRAFARCH)	# machine/fpu type
\$set	HOSTID		= unix		# host system name
\$set	SITEID		= noao		# site name

\$set	XFLAGS		= "-c"		# default XC compile flags
\$set	XVFLAGS		= "-c"		# VOPS XC compile flags
\$set	LFLAGS		= "$LFLAGS"		# default XC link flags

\$set	USE_LIBMAIN	= yes		# update lib\$libmain.o (root object)
\$set	USE_KNET	= yes		# use the KI (network interface)
\$set	USE_SHLIB	= no		# use (update) the shared library
\$set	USE_CCOMPILER	= yes		# use the C compiler
\$set	USE_GENERIC	= yes		# use the generic preprocessor
\$set	USE_NSPP	= no		# make the NCAR/NSPP graphics kernel
\$set	USE_IIS         = no		# make the IIS display control package
\$set	USE_CALCOMP	= no		# make the Calcomp graphics kernel
\$set	LIB_CALCOMP	= "-lcalcomp"	# name of host system calcomp library

\$special "sys\$osb/":		aclrb.c		host\$sys/aclrb.c
				bytmov.c	host\$sys/bytmov.c
				ieeer.x		host\$sys/ieeer.c
				ieeed.x		host\$sys/ieeed.c
				;

\$special "sys\$vops/ak/":	aclrc.x		host\$sys/aclrc.c
				aclrs.x		host\$sys/aclrs.c
				aclri.x		host\$sys/aclri.c
				aclrl.x		host\$sys/aclrl.c
				aclrp.x		host\$sys/aclrp.c
				aclrr.x		host\$sys/aclrr.c
				aclrd.x		host\$sys/aclrd.c
				;

\$special "sys\$vops/lz/":	amovc.x		host\$sys/amovc.c
				amovs.x		host\$sys/amovs.c
				amovi.x		host\$sys/amovi.c
				amovl.x		host\$sys/amovl.c
				amovp.x		host\$sys/amovp.c
				amovr.x		host\$sys/amovr.c
				amovd.x		host\$sys/amovd.c
				;

\$set	XBIG	= '& "\$xc -c -w -/Nx512 -/Ns3072 &"'
\$special "sys\$fmtio/":		evvexpr.x	\$(XBIG)	;

\$set    XNL     = '& "\$xc -c -/NL400 &"'
\$special "math\$slalib/":        obs.f           \$(XNL)  ;

EOF

}

########################################################################

output_makefile () {

  ARG_DIR=$1
  ARG_INFILE=$2
  ARG_ADDITIONAL_DEFS=$3

  echo Making $ARG_DIR/Makefile.
  cat <<EOF > $ARG_DIR/Makefile

MACH        = $MACH
CC          = $CC
F77         = $F77
F2C         = $F2C
HSI_CF      = $HSI_CF
HSI_FF      = $HSI_FF
HSI_LF      = $HSI_LF
HSI_F77LIBS = $HSI_F77LIBS
RANLIB      = $RANLIB
HSI_LIBS    = $HSI_LIBS
$ARG_ADDITIONAL_DEFS

EOF

  cat $ARG_DIR/$ARG_INFILE >> $ARG_DIR/Makefile

}

########################################################################

install_file() {

  F="$1"
  if [ ! -d $F ]; then
    echo Installing $F
    D=`echo ./$F | sed -e 's/\/[^\/]*$//'`
    if [ ! -d $DESTDIR/$PREFIX/iraf/$D ]; then
      mkdir -p -m 755 $DESTDIR/$PREFIX/iraf/$D
    fi
    cp -p $F $DESTDIR/$PREFIX/iraf/$D/.
  fi

}

########################################################################
########################################################################

LANG=C

COMMAND=$1
ARG_MACH=$2
PREFIX=$3
#
BINDIR=$4
DESTDIR=$5

ARCHITECTURE=""
OPERATING_SYSTEM=""
VENDOR=""
SPP_DATA_MODEL=""

if [ "$USER" = "" ]; then
    USER=`whoami`
fi

################################

set_mach "$ARG_MACH"

export ARCHITECTURE OPERATING_SYSTEM VENDOR SPP_DATA_MODEL

#echo debug: $ARCHITECTURE :: $OPERATING_SYSTEM :: $VENDOR
#echo debug: $MACH
#echo $ARCHITECTURE

if [ "`echo $COMMAND | grep '^make_check_'`" != "" ]; then
  COMMAND="`echo $COMMAND | sed -e 's/^make_check_/make_/'`"
  F2C_AUTO_INCLUDE="true"
  export F2C_AUTO_INCLUDE
fi

case "$COMMAND" in
"set_env")
  #
  set_irafenv vos
  #
  ;;

"boot_makefiles")
  #
  iraf="`pwd`/iraf/"
  set_irafenv novos
  set_config
  #
  echo "Architecture   : $ARCHITECTURE"
  echo "OS             : $OPERATING_SYSTEM"
  echo "Vendor         : $VENDOR"
  echo "SPP Data Model : $SPP_DATA_MODEL"
  sleep 1
  #
  #mkdir -p iraf/unix/bin
  #mkdir -p iraf/unix/include
  #mkdir -p iraf/unix/lib
  chmod 755 iraf/unix/scripts/*.sh
  #
  #( cd iraf/unix/include ; rm -f iraf ; ln -s ../hlib/libc iraf )
  #( cd iraf/unix/include ; rm -f iraf.h ; ln -s ../hlib/libc/iraf.h . )
  #( cd iraf/unix/include ; rm -f f2c.h ; ln -s ../config/f2c.h . )
  #( cd iraf/unix/f2c/src ; rm -f f2c.h ; ln -s ../../include/f2c.h . )
  #( cd iraf/unix/f2c/libf2c ; rm -f f2c.h ; ln -s ../../include/f2c.h . )
  #( cd iraf/unix/boot/spp/rpp/rppfor ; rm -f entxkw.f ; ln -s ../../../../config/entxkw.f . )
  #
  output_makefile iraf/unix/include makefile.in
  #
  # F2C
  #F="`echo $HSI_CF | tr ' ' '\n' | grep -e '-DSPP' -e '-I' | tr '\n' ' '`"
  # See also MAX_OUTPUT_SIZE in niceprintf.h
  F="-DDEF_C_LINE_LENGTH=5120"
  #
  echo Makeing iraf/unix/f2c/src/Makefile.
  ( cd iraf/unix/f2c/src    ; cat makefile.u | \
    sed -e 's|^\(CFLAGS = \)\(.*\)|\1\2 -Wall '"$F"'|' > Makefile )
  #
  echo Makeing iraf/unix/f2c/libf2c/Makefile.
  if [ "$SPP_DATA_MODEL" = "lp64" ]; then
    ( cd iraf/unix/f2c/libf2c ; cat makefile.u | \
    sed -e 's/^\(OFILES = \)\(.*\)/\1$(QINT) \2/' \
        -e 's|^\(CFLAGS = \)\(.*\)|\1\2 -Wall '"$F"'|' > Makefile )
  else
    ( cd iraf/unix/f2c/libf2c ; cat makefile.u | \
    sed -e 's|^\(CFLAGS = \)\(.*\)|\1\2 -Wall '"$F"'|' > Makefile )
  fi
  #
  output_makefile iraf/unix/os makefile.in
  output_makefile iraf/unix/gdev/sgidev makefile.in
  output_makefile iraf/unix/boot/bootlib makefile.in
  output_makefile iraf/unix/boot/generic makefile.in
  output_makefile iraf/unix/boot/mkpkg makefile.in
  output_makefile iraf/unix/boot/rmbin makefile.in
  output_makefile iraf/unix/boot/rmfiles makefile.in
  output_makefile iraf/unix/boot/rtar makefile.in
  output_makefile iraf/unix/boot/wtar makefile.in
  output_makefile iraf/unix/boot/spp makefile.in
  output_makefile iraf/unix/boot/spp/xpp makefile.in
  output_makefile iraf/unix/boot/spp/rpp/rppfor makefile.in
  output_makefile iraf/unix/boot/spp/rpp/ratlibf makefile.in
  output_makefile iraf/unix/boot/spp/rpp/ratlibc makefile.in
  output_makefile iraf/unix/boot/spp/rpp makefile.in
  output_makefile iraf/unix/boot/xyacc makefile.in
  output_makefile iraf/unix/gdev/sgidev makefile.in
  #
  F="iraf/unix/config/Makefile"
  D="DEFS ="
  cat <<EOF | cpp -P $HSI_CF > $F 
#include <iraf/endian.h>
#if __BYTE_ORDER == __LITTLE_ENDIAN
X_MARK_X foo;
#endif
EOF
  S=$?
  if [ ! $S = 0 ]; then
    exit $S
  fi
  if [ "`grep 'X_MARK_X' $F`" != "" ]; then
    D="$D -DBYTE_LITTLE"
  fi
  cat <<EOF | cpp -P $HSI_CF > $F
#include <iraf/endian.h>
#if __FLOAT_WORD_ORDER == __LITTLE_ENDIAN
X_MARK_X foo;
#endif
EOF
  S=$?
  if [ ! $S = 0 ]; then
    exit $S
  fi
  if [ "`grep 'X_MARK_X' $F`" != "" ]; then
    D="$D -DFLOAT_LITTLE"
  fi
  output_makefile iraf/unix/config makefile.in "$D"
  #
  ;;

"make_iraf")
  #
  iraf="`pwd`/iraf/"
  set_irafenv novos
  set_config
  #
  mkdir -p tmp_bin
  ( cd tmp_bin
  for i in `ls ../iraf/unix/bin/ | grep '\.e$'` ; do
    F=`echo $i | sed -e 's/\.e$//'`
    rm -f $F
    ln -s ../iraf/unix/bin/$i $F
  done
  )
  #
  PATH="`pwd`/tmp_bin:$PATH"
  export PATH
  ( cd iraf ; mkpkg )
  ;;

"reboot_makefiles")
  #
  iraf="`pwd`/iraf/"
  set_irafenv vos
  set_config
  #
  output_makefile iraf/unix/os makefile.in
  output_makefile iraf/unix/gdev/sgidev makefile.in
  output_makefile iraf/unix/boot/bootlib makefile.in
  output_makefile iraf/unix/boot/generic makefile.in
  output_makefile iraf/unix/boot/mkpkg makefile.in
  output_makefile iraf/unix/boot/rmbin makefile.in
  output_makefile iraf/unix/boot/rmfiles makefile.in
  output_makefile iraf/unix/boot/rtar makefile.in
  output_makefile iraf/unix/boot/wtar makefile.in
  output_makefile iraf/unix/boot/spp makefile.in
  output_makefile iraf/unix/boot/spp/xpp makefile.in
  output_makefile iraf/unix/boot/spp/rpp/rppfor makefile.in
  output_makefile iraf/unix/boot/spp/rpp/ratlibf makefile.in
  output_makefile iraf/unix/boot/spp/rpp/ratlibc makefile.in
  output_makefile iraf/unix/boot/spp/rpp makefile.in
  output_makefile iraf/unix/boot/xyacc makefile.in
  output_makefile iraf/unix/gdev/sgidev makefile.in
  #
  ;;

"make_tables")
  #
  iraf="`pwd`/iraf/"
  set_irafenv vos
  set_config
  #
  mkdir -p tmp_bin
  ( cd tmp_bin
  for i in `ls ../iraf/unix/bin/ | grep '\.e$'` ; do
    F=`echo $i | sed -e 's/\.e$//'`
    rm -f $F
    ln -s ../iraf/unix/bin/$i $F
  done
  )
  #
  PATH="`pwd`/tmp_bin:$PATH"
  export PATH
  extlibs="${iraf}tables/lib/"
  export extlibs
  ( cd iraf/tables ; tables="${iraf}tables/" mkpkg -p tables )
  #( cd iraf/tables/base ; for i in `ls|grep '\.a$'`; do mv $i ../lib/.; done )
  ;;

"make_noao")
  #
  iraf="`pwd`/iraf/"
  set_irafenv vos
  set_config
  #
  mkdir -p tmp_bin
  ( cd tmp_bin
  for i in `ls ../iraf/unix/bin/ | grep '\.e$'` ; do
    F=`echo $i | sed -e 's/\.e$//'`
    rm -f $F
    ln -s ../iraf/unix/bin/$i $F
  done
  )
  #
  PATH="`pwd`/tmp_bin:$PATH"
  export PATH
  extlibs="${iraf}/noao/lib/,${iraf}tables/lib/"
  export extlibs
  tables="${iraf}tables/"
  export tables
  ( cd iraf/noao ; noao="${iraf}noao/" mkpkg -p noao )
  #( cd iraf/noao/base ; for i in `ls|grep '\.a$'`; do mv $i ../lib/. ; done )
  ;;

"make_install")
  #
  mkdir -p $DESTDIR/$PREFIX/iraf
  S=$?
  if [ ! $S = 0 ]; then
    exit $S
  fi
  #
  for i in COPYRIGHTS iraf/tags \
           iraf/unix/README \
           iraf/unix/bin/alloc.e iraf/unix/bin/sgi*  \
           iraf/unix/scripts/setup.sh \
           iraf/bin \
           iraf/unix/config \
           iraf/base iraf/config iraf/dev \
           iraf/doc iraf/math iraf/sys \
           iraf/pkg iraf/tables iraf/noao ; do
    L=`find $i -print | grep -v -e '\.[acfhlorxy]$' -e '\.[fhx]\....$' -e '\.inc$' -e '\.inc\.orig$' -e '\.com$' -e '\.bd$' -e '\.gy$' -e '\.gh$' -e '\.gc$' -e '\.gx$' -e '\.gx\.old$' -e '/omkpkg$' -e '/mkpkg$' -e '/mkpkg\.[^e][^/]*$' -e '/[mM]akefile[^/]*$' -e '/configure[^/]*$' -e '/strip\.[^/]*$' -e '/strip$' | grep -v -e '~$' -e '/\.svn'`
    for j in $L ; do
      install_file $j
    done
  done
  mkdir -p -m 755 $DESTDIR/$PREFIX/iraf/iraf/config
  mkdir -p -m 777 $DESTDIR/$PREFIX/iraf/imdirs
  #
  mkdir -p $DESTDIR/dev
  S=$?
  if [ ! $S = 0 ]; then
    exit $S
  fi
  ( cd $DESTDIR/dev
    echo "Creating /dev/imtli"
    rm -f imtli ; mknod -m 777 imtli p
    echo "Creating /dev/imtlo"
    rm -f imt1o ; mknod -m 777 imt1o p
    rm -f imt1 ; ln -s imt1o imt1
  )
  S=$?
  if [ ! $S = 0 ]; then
    exit $S
  fi
  #
  mkdir -p $DESTDIR/$BINDIR
  S=$?
  if [ ! $S = 0 ]; then
    exit $S
  fi
  #
  cat iraf/unix/scripts/mkiraf.sh | \
      sed -e 's|^PREFIX=.*|PREFIX='"$PREFIX"'|' > $DESTDIR/$BINDIR/mkiraf
  chmod 755 $DESTDIR/$BINDIR/mkiraf
  cat iraf/unix/scripts/cl.sh | \
      sed -e 's|^PREFIX=.*|PREFIX='"$PREFIX"'|' > $DESTDIR/$BINDIR/cl
  chmod 755 $DESTDIR/$BINDIR/cl
  for i in sgidispatch ; do
    F=$DESTDIR/$BINDIR/$i
    echo '#!/bin/sh' > $F
    echo '' >> $F
    echo ". $PREFIX/iraf/iraf/unix/scripts/setup.sh set_env auto $PREFIX" >> $F
    echo "exec $PREFIX/iraf/iraf/unix/bin/$i.e \$@" >> $F
    chmod 755 $F
  done
  #
  if [ "$USER" = "root" ]; then
    chown -R root:root $DESTDIR/*
    S=$?
    if [ ! $S = 0 ]; then
      exit $S
    fi
  fi
  ;;

"make_install_devel")
  #
  mkdir -p $DESTDIR/$PREFIX/iraf
  S=$?
  if [ ! $S = 0 ]; then
    exit $S
  fi
  #
  for i in iraf/mkpkg \
           iraf/unix/config \
           iraf/base iraf/config iraf/dev \
           iraf/doc iraf/math iraf/sys \
           iraf/pkg iraf/tables iraf/noao ; do
    L=`find $i -print | grep -e '\.[acfhlorxy]$' -e '\.[fhx]\....$' -e '\.inc$' -e '\.inc\.orig$' -e '\.com$' -e '\.bd$' -e '\.gy$' -e '\.gh$' -e '\.gc$' -e '\.gx$' -e '\.gx\.old$' -e '/omkpkg$' -e '/mkpkg$' -e '/mkpkg\.[^e][^/]*$' -e '/[mM]akefile[^/]*$' -e '/configure[^/]*$' -e '/strip\.[^/]*$' -e '/strip$' | grep -v -e '\.[aoe]$' | grep -v -e '~$' -e '/\.svn'`
    for j in $L ; do
      install_file $j
    done
  done
  for i in INSTALL Makefile \
           iraf/unix/as* iraf/unix/boot iraf/unix/f2c \
           iraf/unix/gdev iraf/unix/include iraf/unix/mkpkg \
           iraf/unix/mkpkg.sh iraf/unix/os iraf/unix/portkit \
           iraf/unix/scripts iraf/unix/shlib iraf/unix/sun ; do
    L=`find $i -print | grep -v -e 'unix/scripts/setup.sh$' -e '\.[aoe]$' | grep -v -e '~$' -e '/\.svn'`
    for j in $L ; do
      install_file $j
    done
  done
  for i in iraf/unix/bin \
           iraf/unix/lib iraf/lib iraf/noao/lib iraf/tables/lib ; do
    L=`find $i -print | grep -v -e 'unix/bin/alloc\.e$' -e 'unix/bin/sgi.*$' | grep -v -e '~$' -e '/\.svn'`
    for j in $L ; do
      install_file $j
    done
  done
  #
  mkdir -p -m 755 $DESTDIR/$PREFIX/iraf/iraf/config
  #
  mkdir -p $DESTDIR/$BINDIR
  S=$?
  if [ ! $S = 0 ]; then
    exit $S
  fi
  #
  ( cd $DESTDIR/$BINDIR/ ; rm -f mkmlist ; \
    ln -sf $PREFIX/iraf/iraf/unix/scripts/mkmlist.sh . )
  for i in generic mkpkg rmbin rmfiles rpp rtar wtar xc xpp xyacc; do
    F=$DESTDIR/$BINDIR/$i
    echo '#!/bin/sh' > $F
    echo '' >> $F
    echo ". $PREFIX/iraf/iraf/unix/scripts/setup.sh set_env auto $PREFIX" >> $F
    echo "exec $PREFIX/iraf/iraf/unix/bin/$i.e \$@" >> $F
    chmod 755 $F
  done
  #
  if [ "$USER" = "root" ]; then
    chown -R root:root $DESTDIR/*
    S=$?
    if [ ! $S = 0 ]; then
      exit $S
    fi
  fi
  ;;

*)
  echo "[setup.sh] Unknown command: $COMMAND"
  exit 1
  ;;
esac

