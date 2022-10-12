# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg optfeature

DESCRIPTION="A Wine+Roblox management application"
HOMEPAGE="https://gitlab.com/brinkervii/grapejuice.git"
SRC_URI="https://gitlab.com/brinkervii/grapejuice/-/archive/v${PV}/grapejuice-v${PV}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-arch/unzip
	dev-libs/gobject-introspection
	dev-libs/openssl[abi_x86_32]
	dev-python/click
	dev-python/pygobject
	dev-python/packaging
	dev-python/pip
	dev-python/psutil
	dev-python/requests
	dev-python/setuptools
	dev-python/unidecode
	dev-util/desktop-file-utils
	dev-util/gtk-update-icon-cache
	media-libs/libpulse[abi_x86_32]
	media-libs/mesa
	net-libs/gnutls[abi_x86_32]
	x11-libs/cairo
	x11-libs/gtk+
	x11-misc/shared-mime-info
	x11-misc/xdg-user-dirs
	x11-misc/xdg-utils"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	mv ${WORKDIR}/grapejuice-v${PV} ${S}
}

src_compile() {
	cd ${S}
	export PYTHONPATH="${S}/src"
	python3 -m grapejuice_packaging linux_package
}

src_install() {
	export PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
	tar -xf ${S}/dist/linux_package/*.tar.gz -C ${D}
	mv "${D}/usr/lib/python3/dist-packages" "${D}/usr/lib/python${PYTHON_VERSION}"
	rm -r "${D}/usr/lib/python3"
	default
}

xdg_pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	optfeature "Wine is required to run Roblox, but left out of depends to let the user decide on custom builds" app-emulation/wine
	optfeature "Required for PRIME systems running XOrg, where XRandR based profiling is desired" x11-apps/xrandr
}

xdg_pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
