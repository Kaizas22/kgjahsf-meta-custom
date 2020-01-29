require recipes-image/images/include/custom-users.inc 
#require recipes-image/images/include/custom-permissions.inc

#IMAGE_BASE_INSTALL = "\
#    packagegroup-custom-base \
#    packagegroup-custom-utils \
#    packagegroup-custom-network \
#    packagegroup-custom-devel \
#    packagegroup-custom-security \
#    packagegroup-custom-test \
#    packagegroup-custom-library \
#    packagegroup-custom-admin \
#   "

#IMAGE_2_BASE_INSTALL = "\
#    packagegroup-custom2-devel \
#   "

#IMAGE_3_BASE_INSTALL = "\
#    packagegroup-custom3-utils \
#   "

#EXTRA_IMAGE_FEATURES = "dev-pkgs package-management"

#IMAGE_INSTALL_append = "${IMAGE_BASE_INSTALL} ${IMAGE_2_BASE_INSTALL} ${IMAGE_3_BASE_INSTALL}"
IMAGE_INSTALL_append = " htop"
IMAGE_FEATURES_append = " ssh-server-openssh"

inherit core-image

TOOLCHAIN_TARGET_TASK_append = " libc-staticdev cmake"

do_populate_sdk_prepend() {
    IMAGE_BASENAME = "custom-image-sdk"
}
