# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Riot is a free multiplayer first-person shooter based on Godot Engine"
HOMEPAGE="https://riot.mersh.com/ https://git.mersh.com/riot/riot/"
SRC_URI="https://git.mersh.com/riot/riot/archive/master.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_compile() {
	emake
}

src_install() {
	emake install
}
