# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An Enhanced Printer Spooler"
HOMEPAGE="http://www.lprng.com"
SRC_URI="http://sourceforge.net/projects/lprng/files/lprng/lprng-3.8.C.tar.gz"

LICENSE="GPL-2 Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="ssl"
RDEPEND="app-shells/bash"
DEPEND="dev-libs/openssl"

src_configure() {
	./configure --prefix=/usr --sysconfdir=/etc/lprng --localstatedir=/var\
	--mandir=/usr/share/man --libexecdir=/usr/lib/lprng\
	--with-userid=daemon --with-groupid=lp\
	--sbindir=/usr/bin
}

src_compile() {
	emake
}

src_install() {
	emake MAKEPACKAGE=YES DESTDIR="${D}" install
}
