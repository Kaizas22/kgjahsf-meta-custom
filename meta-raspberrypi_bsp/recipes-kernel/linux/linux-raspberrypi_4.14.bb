LINUX_VERSION ?= "4.14.98"

SRCREV = "5d63a4595d32a8505590d5fea5c4ec1ca79fd49d"
SRC_URI = " \
    git://github.com/raspberrypi/linux.git;branch=rpi-4.14.y \
    file://0001-menuconfig-check-lxdiaglog.sh-Allow-specification-of.patch \
    "

require linux-raspberrypi.inc

S = "${WORKDIR}/linux-${PV}"

#python () {
#    # Add tasks in the correct order, specifically for linux-yocto to avoid race condition.
#    # sstatesig.py:sstate_rundepfilter has special support that excludes this dependency
#    # so that do_kernel_configme does not need to run again when do_unpack_and_patch
#    # gets added or removed (by adding or removing archiver.bbclass).
#    if bb.data.inherits_class('archiver', d):
#        bb.build.addtask('do_configure', '', 'do_unpack_and_patch', d)
#}

