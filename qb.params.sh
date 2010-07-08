COMMAND_LINE_OPTS=""

add_command_line_opt()
{
   COMMAND_LINE_OPTS="$COMMAND_LINE_OPTS:\"$1\" \"$2\" \"$3\":"
   eval HAVE_$1=$3
}

## lvl. 43 regex dragon awaits thee.
print_help()
{
   echo "===================="
   echo " Quickbuild script"
   echo "===================="
   echo "Package: $PACKAGE_NAME"
   echo "Version: $PACKAGE_VERSION"
   echo ""
   echo "General environment variables:"
   echo "CC:         C compiler"
   echo "CFLAGS:     C compiler flags"
   echo "CXX:        C++ compiler"
   echo "CXXFLAGS:   C++ compiler flags"
   echo ""
   echo "General options:"
   echo "--prefix=\$path: Install path prefix"
   echo "--help: Show this help"
   echo ""
   echo "Custom options:"

   tmpopts="$COMMAND_LINE_OPTS"
   while [ ! -z "$tmpopts" ]
   do
      subopts="`echo $tmpopts | sed 's|^:"\([^"]\+\)"."\([^"]\+\)"."\([^"]\+\)":.*$|"\1":"\2":"\3"|'`"
      tmpopts="`echo $tmpopts | sed 's|^\W\+$||'`"
      tmpopts="`echo $tmpopts | sed 's|^:"[^"]\+"."[^"]\+"."[^"]\+":||'`"
      print_sub_opt "$subopts"
   done
   
}

print_sub_opt()
{
   arg1="`echo $1 | sed 's|^"\([^"]\+\)":"\([^"]\+\)":"\([^"]\+\)"$|\1|'`"
   arg2="`echo $1 | sed 's|^"\([^"]\+\)":"\([^"]\+\)":"\([^"]\+\)"$|\2|'`"
   arg3="`echo $1 | sed 's|^"\([^"]\+\)":"\([^"]\+\)":"\([^"]\+\)"$|\3|'`"

   lowertext="`echo $arg1 | tr '[A-Z]' '[a-z]'`"
   echo -n "--enable-$lowertext: "
   echo $arg2

   echo "--disable-$lowertext"
}

parse_input()
{
   ### Parse stuff :V

   while [ ! -z "$1" ]
   do
      prefix="`echo $1 | sed -e 's|^--prefix=\(\S\S*\)$|\1|' -e 's|\(\S\S*\)/|\1|'`"

      if [ "$prefix" != "$1" ]; then
         PREFIX="$prefix"
         shift
         continue
      fi

      case "$1" in

         --enable-*)
            enable=`echo $1 | sed 's|^--enable-||'`
            [ -z "`echo $COMMAND_LINE_OPTS | grep -i $enable`" ] && print_help && exit 1
            eval HAVE_`echo $enable | tr '[a-z]' '[A-Z]'`=yes
            ;;

         --disable-*)
            disable=`echo $1 | sed 's|^--disable-||'`
            [ -z "`echo $COMMAND_LINE_OPTS | grep -i $disable`" ] && print_help && exit 1
            eval HAVE_`echo $disable | tr '[a-z]' '[A-Z]'`=no
            ;;

         -h|--help)
            print_help
            exit 0
            ;;
         *)
            print_help
            exit 1
            ;;

      esac

      shift

   done
}


