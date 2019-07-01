require conf/distro/poky.conf

# Distro versions for each machine arch
# Controls
DISTRO_VERSION_axcf2152 ?= "2019.6"
DISTRO_VERSION_rfc480-64 ?= "2019.6"
DISTRO_VERSION_axcf3152 ?= "9999.0"
# Gateways
DISTRO_VERSION_ksp0610 ?= "1.0.3"
# HMIs
# CPUs

# Log information on images and packages
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT ?= "1"
USER_CLASSES += "buildstats"

# Prelink images
USER_CLASSES += "image-prelink"

# Optimize lib sizes with mklibs
USER_CLASSES += "image-mklibs"

# A list of packaging systems used in generated images
PACKAGE_CLASSES ?= "package_deb"

# Generate mirror tarballs for sources fetched from version control systems.
# This helps us to create a full source mirror.
BB_GENERATE_MIRROR_TARBALLS ?= "1"

# Create the directory /usr/share/common-licenses for open-source licenses
# and create an license.manifest.
COPY_LIC_DIRS ?= "1"
COPY_LIC_MANIFEST ?= "1"

# A list of preferred providers
include conf/distro/include/default-providers-pxc.inc

# A list of preferred package versions
include conf/distro/include/default-versions-pxc.inc

# A list of maintainers for packages
include conf/distro/include/maintainers-pxc.inc

# Security flags
require conf/distro/include/security_flags-pxc.inc
