. ./qb.params.sh

PACKAGE_NAME=rsound
PACKAGE_VERSION=0.9.4

# Adds a command line opt to ./configure --help
# $1: Variable (HAVE_ALSA, HAVE_OSS, etc)   
# $2: Comment                 
# $3: Default arg. auto implies that HAVE_ALSA will be set according to library checks later on.
add_command_line_opt ALSA "Enable ALSA support" auto
add_command_line_opt OSS "Enable OSS support" auto

