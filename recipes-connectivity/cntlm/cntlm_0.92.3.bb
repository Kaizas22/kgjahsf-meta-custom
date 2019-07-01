SUMMARY = "Fast NTLM authentication proxy with tunneling"
DESCRIPTION = "Cntlm is a fast and efficient NTLM proxy, with support for TCP/IP tunneling, authenticated connection caching, ACLs, proper daemon logging and behaviour and much more. It has up to ten times faster responses than similar NTLM proxies, while using by orders or magnitude less RAM and CPU."
SECTION = "network"

HOMEPAGE = "http://cntlm.sourceforge.net/"
AUTHOR = "David Kubicek <dave@awk.cz>"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=94d55d512a9ba36caa9b7df079bae19f"

RDEPENDS_${PN} = "glibc"

SRC_URI = "https://sourceforge.net/projects/${PN}/files/${PN}/${PN}%20${PV}/${PN}-${PV}.tar.gz"
SRC_URI[md5sum] = "0d7fcfbfbef0546306b896be246caa88"
SRC_URI[sha256sum] = "9c3ad10924d43f7248df9ecd33cbc033afbd7ea8d9545de0d68a2782fed76298"

S = "${WORKDIR}/${PN}-${PV}"

EXTRA_OEMAKE_prepend = "\
    'CC=${CC}' \
"

TARGET_CC_ARCH += "${LDFLAGS}"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

do_configure() {
    ./configure
    oe_runmake
}

do_install() {
    oe_runmake install DESTDIR=${D} PREFIX=${D}
    #install -D ${D}/${sbindir}
    #install -m 755 ${S}/${PN} ${D}${sbindir} 
}

FILES_${PN} = "\
    ${sysconfdir}/cntlm.conf \
    ${sbindir} \
"
