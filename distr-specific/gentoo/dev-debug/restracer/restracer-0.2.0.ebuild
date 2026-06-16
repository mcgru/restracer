# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

PATCH_LEVEL="2"
USER=larkvirtual
PROJECT=restracer

DESCRIPTION="A resource tracing, debugging and profiling tool"
HOMEPAGE="https://github.com/${USER}/${PROJECT}"
SRC_URI="https://github.com/${USER}/${PROJECT}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="static"

DEPEND="
	dev-cpp/libxmlpp[static-libs(+)?]
	dev-util/pkgconfig
	demidecode? ( sys-apps/dmidecode )
	static? (
		dev-cpp/glibmm[static-libs(+)]
		dev-libs/libsigc++[static-libs(+)]
		dev-libs/glib[static-libs(+)]
		dev-libs/libxml2[static-libs(+)]
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
}

src_compile() {
	local myldflags=""
	use static && myldflags="LDFLAGS=-static"
	emake release CC="$(tc-getCC)" CXX="$(tc-getCXX)" ${myldflags}
}

src_install() {
	emake install DESTDIR="${D}/usr"
}

pkg_postinst() {
	elog "To use restracer, run \`restracer my_prog\`"
	elog "Please refer to README file for more info."
}
