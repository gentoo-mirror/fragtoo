# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The Free & Open Source Vehicle Simulator"
HOMEPAGE="https://www.rigsofrods.org/"
SRC_URI="https://github.com/RigsOfRods/rigs-of-rods/archive/refs/tags/${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+angelscript"

RDEPEND=">=dev-games/mygui-3.2.2
		>=dev-games/ogre-1.8
		=dev-games/ois-1.3
		angelscript? ( >=dev-libs/angelscript-2.31.2 )
		>=dev-libs/boost-1.50
		dev-libs/openssl
		>=dev-libs/rapidjson-1.1.0
		>=dev-util/cmake-2.8
		>=gui-libs/gtk-2.0
		media-libs/openal
		net-misc/curl
		>=sys-devel/gcc-4.8"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	cmake -GNinja -DCMAKE_BUILD_TYPE=Release .
}

src_compile() {
	ninja
}

src_install() {
	ninja zip_and_copy_resources
}
