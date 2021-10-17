# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Hollywood tactical shooter based on the ioquake3 engine"
HOMEPAGE="https://urbanterror.info"
SRC_URI="http://cdn.urbanterror.info/urt/43/releases/zips/UrbanTerror434_full.zip"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	media-libs/libsdl
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg:0
"

DEPEND="${RDEPEND}"

src_install() {
	mv UrbanTerror* /opt/urbanterror
	ln -s /opt/urbanterror/Quake3-UrT.$(arch) /usr/bin/urbanterror
}
