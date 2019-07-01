SUMMARY = "My custom packagegroup"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = "\
    packagegroup-custom-base \
    packagegroup-custom-utils \
    packagegroup-custom-network \
    packagegroup-custom-devel \
    packagegroup-custom-security \
    packagegroup-custom-test \
    packagegroup-custom-library \
    packagegroup-custom-admin \
   "

SUMMARY_packagegroup-custom-base = ""
RDEPENDS_packagegroup-custom-base = "\
    ${@bb.utils.contains("TARGET_FEATURES", "utils", "packagegroup-custom-utils", "",d)} \
   "

SUMMARY_packagegroup-custom-utils = ""
RDEPENDS_packagegroup-custom-utils = "\
    htop \
    cronie \
   "

SUMMARY_packagegroup-custom-network = ""
RDEPENDS_packagegroup-custom-network = "\
    openssh-sftp \
    openssh-sftp-server \
    tcpdump \
    ntp \
    ntp-utils \
    nginx \
    fcgi \
    openvpn \
    openvpn-sample \
    nftables \
    resolvconf \
   "

SUMMARY_packagegroup-custom-devel = ""
RDEPENDS_packagegroup-custom-devel = "\
    gdb \
    gdbserver \
    gcc-sanitizers \
   "

SUMMARY_packagegroup-custom-security = ""
RDEPENDS_packagegroup-custom-security = "\
    trousers \
    tpm-tools \
    openssl-tpm-engine \
   "

SUMMARY_packagegroup-custom-test = ""
RDEPENDS_packagegroup-custom-test = "\
    rt-tests \
    hwlatdetect \
   "

SUMMARY_packagegroup-custom-library = ""
RDEPENDS_packagegroup-custom-library = "\
    ldd \
    sqlite3 \
   " 

SUMMARY_packagegroup-custom-admin = ""
RDEPENDS_packagegroup-custom-admin = "\
    sudo \
   "

