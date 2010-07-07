TEMP_C=.tmp.c
TEMP_EXE=.tmp

[ -z $CC ] && CC=cc
[ -z $CXX ] && CXX=c++

PKG_CONF_USED=""

check_lib()
{
   tmpval="HAVE_$1"
   eval tmpval=\$$tmpval
   [ "$tmpval" = "no" ] && return 0

   echo -n "Checking function $3 in -l$2 ... "
   echo "void $3(void); int main(void) { $3(); return 0; }" > $TEMP_C

   eval HAVE_$1=no
   answer=no
   $CC -o $TEMP_EXE $TEMP_C -l$2 2>/dev/null >/dev/null && answer=yes && eval HAVE_$1=yes

   echo $answer

   rm -rf $TEMP_C $TEMP_EXE
   [ "$tmpval" = "yes" ] && [ "$answer" = "no" ] && echo "Forced to build with library $2, but cannot locate. Exiting ..." && exit 1
}

check_pkgconf()
{
   tmpval="HAVE_$1"
   eval tmpval=\$$tmpval
   [ "$tmpval" = "no" ] && return 0

   echo -n "Checking presence of package $2 ... "
   eval HAVE_$1=no
   eval $1_CFLAGS=""
   eval $1_LIBS=""
   answer=no
   minver=0.0
   [ ! -z $3 ] && minver=$3
   pkg-config --atleast-version=$minver --exists "$2" && eval HAVE_$1=yes && eval $1_CFLAGS="`pkg-config $2 --cflags`" && eval $1_LIBS="`pkg-config $2 --libs`" && answer=yes
   echo $answer

   PKG_CONF_USED="$PKG_CONF_USED $1"

   [ "$tmpval" = "yes" ] && [ "$answer" = "no" ] && echo "Forced to build with package $2, but cannot locate. Exiting ..." && exit 1
}

check_header()
{
   tmpval="HAVE_$1"
   eval tmpval=\$$tmpval
   [ "$tmpval" = "no" ] && return 0

   echo -n "Checking presence of header file $2 ... "
   echo "#include<$2>" > $TEMP_C
   echo "int main(void) { return 0; }" >> $TEMP_C
   eval HAVE_$1=no
   answer=no

   $CC -o $TEMP_EXE $TEMP_C 2>/dev/null >/dev/null && answer=yes && eval HAVE_$1=yes

   echo $answer

   rm -rf $TEMP_C $TEMP_EXE
   [ "$tmpval" = "yes" ] && [ "$answer" = "no" ] && echo "Build assumed that $2 exists, but cannot locate. Exiting ..." && exit 1
}

check_switch()
{
   echo -n "Checking for availability of switch $2 ... "
   echo "int main(void) { return 0; }" > $TEMP_C
   eval HAVE_$1=no
   answer=no
   $CC -o $TEMP_EXE $TEMP_C $2 2>/dev/null >/dev/null && answer=yes && eval HAVE_$1=yes

   echo $answer

   rm -rf $TEMP_C $TEMP_EXE
}

create_config_header()
{
   outfile="$1"
   shift

   name="`echo __$outfile | sed 's|[\./]|_|g' | tr '[a-z]' '[A-Z]'`"
   echo "#ifndef $name" > "$outfile"
   echo "#define $name" >> "$outfile"
   echo "" >> "$outfile"
   echo "#define PACKAGE_NAME \"$PACKAGE_NAME\"" >> "$outfile"
   echo "#define PACKAGE_VERSION \"$PACKAGE_VERSION\"" >> "$outfile"

   while [ ! -z "$1" ]
   do
      tmpval="HAVE_$1"
      eval tmpval=\$$tmpval
      [ $tmpval = yes ] && echo "#define HAVE_$1 1" >> "$outfile"
      shift
   done

   echo "" >> "$outfile"
   echo "#endif" >> "$outfile"
}

create_config_make()
{
   outfile="$1"
   shift

   rm -rf "$outfile"
   touch "$outfile"
   echo "CC = $CC" >> "$outfile"
   echo "CXX = $CXX" >> "$outfile"
   echo "CFLAGS = $CFLAGS" >> "$outfile"
   echo "CXXFLAGS = $CXXFLAGS" >> "$outfile"

   while [ ! -z "$1" ]
   do
      tmpval="HAVE_$1"
      eval tmpval=\$$tmpval
      if [ $tmpval = yes ]; then
         echo "HAVE_$1 = 1" >> "$outfile"
      elif [ $tmpval = no ]; then
         echo "HAVE_$1 = 0" >> "$outfile"
      fi

      if [ ! -z "`echo $PKG_CONF_USED | grep $1`" ]; then
         tmpval="$1_CFLAGS"
         eval tmpval=\$$tmpval
         echo "$1_CFLAGS = $tmpval" >> "$outfile"

         tmpval="$1_LIBS"
         eval tmpval=\$$tmpval
         echo "$1_LIBS = $tmpval" >> "$outfile"
      fi

      shift
   done
}


