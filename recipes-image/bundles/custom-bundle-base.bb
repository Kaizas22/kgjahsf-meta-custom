inherit bundle

RAUC_BUNDLE_SLOTS = "rootfs"
RAUC_SLOT_rootfs = "custom-image-base"
RAUC_SLOT_rootfs[fstype] = "ext3"

RAUC_KEY_FILE = "/home/kaiza/yocto/demo.key.pem"
RAUC_CERT_FILE = "/home/kaiza/yocto/demo.cert.pem"

HOSTNAME ?= "test"

do_rename() {
    bbwarn "Test Warning!"
    type = d.getVar
    mv ${S}/${RAUC_SLOT_rootfs}-${MACHINE}.${RAUC_SLOT_rootfs[fstype]} ${S}/${HOSTNAME}-image-base-${MACHINE}.${RAUC_SLOT_rootfs[fstype]}
}

#addtask rename after do_unpack before do_bundle
