. qb/qb.params.sh

PACKAGE_NAME=foo
PACKAGE_VERSION=13.37

# Disabled by default, needs to be enabled explicitly.
add_command_line_enable FEATURE1 "Enable feature1." no

# Enabled by default, needs to be disabled explicitly.
add_command_line_enable FEATURE2 "Disable feature2." yes

# Will be checked for automatically.
add_command_line_enable FEATURE3 "Enable feature3." auto

# Add a --with-feature-path= option to set a user value.
add_command_line_string FEATURE_PATH "Path to cool library" "-lcool"

