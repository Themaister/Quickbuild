. ./qb.libs.sh

# Checks presence of library using -lfoo
# $1: Variable name (HAVE_ALSA, HAVE_OSS, etc)
# $2: library name (asound -> -lasound)
# $3: function to check against
#check_lib ALSA asound snd_pcm_open
check_pkgconf ALSA alsa 1.0

# Checks the presence of a header file
check_header OSS sys/soundcard.h

check_switch C99 -std=c99
check_switch GNU99 -std=gnu99
check_switch WEXTRA -Wextra

# Creates config.mk and config.h according to variables.
VARS="ALSA OSS"
create_config_make config.mk $VARS C99 GNU99 WEXTRA
create_config_header config.h $VARS

