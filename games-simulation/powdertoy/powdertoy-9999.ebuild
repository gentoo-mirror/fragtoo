# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils fdo-mime git-r3 scons-utils

DESCRIPTION="Desktop version of the classic 'falling sand' physics sandbox"
HOMEPAGE="http://powdertoy.co.uk/"
EGIT_REPO_URI="https://github.com/simtr/The-Powder-Toy.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 +fftw +lua"

DEPEND="app-arch/bzip2
	lua? ( dev-lang/lua )
	dev-util/scons
	media-libs/libsdl
	fftw? ( sci-libs/fftw:3.0/3 )
	sys-libs/zlib"
RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/${PN}-disable-sse-config-automagic.patch
)

src_compile() {
	# If cpu_flags_x86_sse is disabled, build the Powder Toy without any SSE support,
	# even if the cpu_flags_x86_sse2 or cpu_flags_x86_sse3 use flags are enabled.

	# Also pass the project-specific debugging and sumbols flags so that the
	# Powder Toy binary isn't automatically stripped by the project's SConscript.
	# This lets portage decide whether or not to strip the binary.

	scons_args="--debugging --symbols --beta"

	ewarn "This is a beta build (aka snapshot) of the Powder Toy."
	ewarn "Saves created in one beta build may not work properly in another."
	ewarn "See this thread in the Powder Toy forum for more details:"
	ewarn "http://powdertoy.co.uk/Discussions/Thread/View.html?Thread=20456"
	ewarn ""

	if ! use cpu_flags_x86_sse ; then
		if use cpu_flags_x86_sse2 || use cpu_flags_x86_sse3 ; then
			ewarn "cpu_flags_x86_sse2 and/or cpu_flags_x86_sse3 is enabled, but cpu_flags_x86_sse is disabled"
			ewarn "This software will be built without any SSE optimizations."
		fi
		scons_args+=" --no-sse"
	elif use cpu_flags_x86_sse ; then
		scons_args+=" --sse"
	fi

	if use cpu_flags_x86_sse && use cpu_flags_x86_sse2 ; then
		scons_args+=" --sse2"
	fi

	if use cpu_flags_x86_sse && use cpu_flags_x86_sse3 ; then
		scons_args+=" --sse3"
	fi

	if ! use lua ; then
		scons_args+=" --nolua"
	fi

	if ! use fftw ; then
		scons_args+=" --nofft"
	fi

	escons ${scons_args}
}

src_install() {
	dodir "/usr/bin/"

	# Copy the binary over to the specified path. The name of the binary will differ
	# depending on the architecture the powder toy is built on, as well as whether or
	# not it was built with sse support.
	# See http://powdertoy.co.uk/Wiki/W/Compiling_TPT%2B%2B_on_debian/ubuntu.html

	# Regardless of the name of the resulting binary, install it with the name of
	# "powdertoy" for the sake of consistency.
	if ! use cpu_flags_x86_sse && use amd64 ; then
		newbin "${S}/build/powder64-legacy" "${PN}"
	elif ! use cpu_flags_x86_sse && ! use amd64 ; then
		newbin "${S}/build/powder-legacy" "${PN}"
	elif use cpu_flags_x86_sse && use amd64 ; then
		newbin "${S}/build/powder64" "${PN}"
	else
		newbin "${S}/build/powder" "${PN}"
	fi

	# Install icons
	sizes="16 24 48 32 256"
	for size in ${sizes} ; do
		doicon "${S}/resources/icon/powder-${size}.png"
	done

	# Install .desktop file and docs
	# Fix desktop file so that it uses the right icon and points to the right binary/symlink
	sed 's:Icon=powder:Icon=/usr/share/pixmaps/powder-48.png:' -i "${S}/resources/powder.desktop" || die "Install failed!"
	sed "s/Exec=powder/Exec=${PN}/" -i "${S}/resources/powder.desktop" || die "Install failed!"
	domenu "${S}/resources/powder.desktop"
	dodoc README.md TODO
}

pkg_postinst() {
	# Tell the user how to launch the Powder Toy after it's installed.
	ewarn "The \"powder\" binary has been renamed to \"powdertoy\" to"
	ewarn "avoid a conflict with games-roguelike/powder"
	ewarn ""
	elog "To launch the Powder Toy, just type: \"powdertoy\"."
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}

