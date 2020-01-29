SUMMARY = "My custom packagegroup2"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = "\
    packagegroup-custom2-base \
    packagegroup-custom2-devel \
    packagegroup-custom2-library \
   "

RDEPENDS_packagegroup-custom2-base = "\
    packagegroup-custom2-devel \
    packagegroup-custom2-library \
   "

RDEPENDS_packagegroup-custom2-devel = "\
    lttng-tools \
   "

RDEPENDS_packagegroup-custom2-library = "\
    openssl \
   "
