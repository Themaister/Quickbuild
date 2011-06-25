. qb/qb.libs.sh

# Check if compiler switch is present
check_switch_c C99 -std=gnu99

# If feature C99 failed, die.
check_critical C99 "Cannot find C99 compatible compiler."

# This is a shell script after all, so we can do custom script stuff as well.
if [ "$OS" = BSD ]; then
   echo "This is BSD! :O"
   # Adds a custom define to Makefile config.
   add_define_make has_bsd 1
else
   echo "This is not BSD :D"
   add_define_make has_bsd 0
fi

# Check features. 
# If auto, HAVE_FEATURE1 etc will be set to either "yes" or "no".
# If --enable-feature1 has been used, a check will be performed and it will die should it fail.
# If --enable-feature1 has been disabled, the check will be skipped.
check_lib FEATURE1 -lc socket
check_lib FEATURE2 -lc bind
check_lib FEATURE3 -lc connect

# Checks if we can find printf in -lc. Use C++ linker.
check_lib_cxx LIBC -lc printf

# Checks if we can locate a certain header.
check_header STDIO stdio.h

# Checks if we can find a certain package.
check_pkgconf ALSA alsa

# Set the path we got from ./configure --with-feature_path= (or the default)
add_define_make feature_path $FEATURE_PATH

# Creates config.mk and config.h. Export these variables.
VARS="FEATURE1 FEATURE2 FEATURE3 LIBC STDIO ALSA"
create_config_make config.mk $VARS
create_config_header config.h $VARS

