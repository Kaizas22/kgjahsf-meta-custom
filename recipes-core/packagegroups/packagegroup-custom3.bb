SUMMARY = "My custom packagegroup3"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = "\
    packagegroup-custom3-utils \
   "

RDEPENDS_packagegroup-custom3-utils = "\
    rauc \
    dbus \
    pciutils \
    e2fsprogs \
   "
