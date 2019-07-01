require recipes-image/images/include/custom-users.inc 
#require recipes-image/images/include/custom-permissions.inc

IMAGE_BASE_INSTALL = "\
    packagegroup-custom-base \
    packagegroup-custom-utils \
    packagegroup-custom-network \
    packagegroup-custom-devel \
    packagegroup-custom-security \
    packagegroup-custom-test \
    packagegroup-custom-library \
    packagegroup-custom-admin \
   "

IMAGE_2_BASE_INSTALL = "\
    packagegroup-custom2-devel \
   "

IMAGE_3_BASE_INSTALL = "\
    packagegroup-custom3-utils \
   "

IMAGE_BASENAME = "test-image-base"
EXTRA_IMAGE_FEATURES = "dev-pkgs package-management"

#IMAGE_INSTALL_append = " packagegroup-custom-base"
IMAGE_INSTALL_append = "${IMAGE_BASE_INSTALL} ${IMAGE_2_BASE_INSTALL} ${IMAGE_3_BASE_INSTALL}"
IMAGE_INSTALL_remove = " make-mod-scripts"
#IMAGE_INSTALL_append_pn-custom-image-dev = "${IMAGE_2_BASE_INSTALL}"
#IMAGE_FEATURES_append = "ssh-server-openssh"
#IMAGE_INSTALL_append = " packagegroup-custom"

inherit core-image
