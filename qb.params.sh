COMMAND_LINE_OPTS=""

add_command_line_opt()
{
   COMMAND_LINE_OPTS="$COMMAND_LINE_OPTS:\"$1\" \"$2\" \"$3\":"
   eval HAVE_$1=$3
}

## lvl. 43 regex dragon awaits thee.
print_help()
{
   echo "==================="
   echo " Quickbuild script"
   echo "==================="
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


