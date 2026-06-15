# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs
#inherit git-r3

PATCH_LEVEL="2"
USER=larkvirtual
PROJECT=restracer

DESCRIPTION="A resource tracing, debugging and profiling tool"
HOMEPAGE="https://github.com/${USER}/${PROJECT}"
SRC_URI="https://github.com/${USER}/${PROJECT}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

DEPEND="
	dev-cpp/libxmlpp
	dev-util/pkgconfig
	demidecode? ( sys-apps/dmidecode )
"
RDEPEND="${DEPEND}"

src_prepare() {
#        eapply -p1 "${WORKDIR}/patches/01_all_gcc-cflags.patch"
#        eapply_user
}

#src_compile() {
#        emake CXX="$(tc-getCXX)"
#}


#src_install() {
#}

pkg_postinst() {
        elog "To use restracer, run \`restracer my_prog\`"
        elog "Please refer to README file for more info."
}
