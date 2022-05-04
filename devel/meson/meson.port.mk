# to figure out dependencies, meson(1) uses pkg-config(1) then fallback to
# cmake(1); we do not want to enforce a dependency on devel/cmake, so teach
# dpb(1) to not junk at configure time (which could create a race between
# finding foo.cmake and junking it if cmake is found & used)
DPB_PROPERTIES +=	noconfigurejunk

BUILD_DEPENDS +=	devel/meson>=0.62.1v0
SEPARATE_BUILD ?=	Yes

.if empty(CONFIGURE_STYLE)
CONFIGURE_STYLE=	meson
.endif

# from ${LOCALBASE}/bin/meson:
# Warn if the locale is not UTF-8. This can cause various unfixable issues
# such as os.stat not being able to decode filenames with unicode in them.
# There is no way to reset both the preferred encoding and the filesystem
# encoding, so we can just warn about it.
CONFIGURE_ENV +=	LC_CTYPE="en_US.UTF-8"
MAKE_ENV +=		LC_CTYPE="en_US.UTF-8"

# don't pick up llvm-ar(1)
CONFIGURE_ENV +=	AR="ar"

MODMESON_CONFIGURE_ENV +=	CC="${CC}" CFLAGS="${CFLAGS}" \
				CXX="${CXX}" CXXFLAGS="${CXXFLAGS}"

# SHARED_LIBS: default to '0.0' if unset
MODMESON_CONFIGURE_ENV +=	MODMESON_PORT_BUILD=yes

MODMESON_CONFIGURE_ARGS +=	--buildtype=plain \
				--prefix "${PREFIX}" \
				--mandir="${PREFIX}/man" \
				--sysconfdir="${SYSCONFDIR}" \
				--localstatedir="${LOCALSTATEDIR}" \
				--sharedstatedir="/var/db" \
				--auto-features=enabled \
				--wrap-mode=nodownload

MODMESON_WANTCOLOR ?=	No
.if ${MODMESON_WANTCOLOR:L} == "no"
MODMESON_CONFIGURE_ENV +=	TERM="dumb"
.endif

.for solib sover in ${SHARED_LIBS}
MODMESON_CONFIGURE_ENV +=	LIB${solib}_VERSION=${sover}
.endfor

_MODMESON_STRIP = --strip
.if !empty(INSTALL_STRIP)
MODMESON_CONFIGURE_ARGS += ${_MODMESON_STRIP${DEBUG_PACKAGES}}
.endif

.if ${CONFIGURE_STYLE} == "meson"
CONFIGURE_ARGS +=	${MODMESON_CONFIGURE_ARGS}
CONFIGURE_ENV +=	${MODMESON_CONFIGURE_ENV}
MODMESON_configure=	${SETENV} ${CONFIGURE_ENV} ${LOCALBASE}/bin/meson \
				${CONFIGURE_ARGS} ${WRKSRC} ${WRKBUILD}

.   if !target(do-build)
do-build:
	exec ${SETENV} ${MAKE_ENV} \
		${LOCALBASE}/bin/meson compile -C ${WRKBUILD} -v -j ${MAKE_JOBS}
.   endif

.   if !target(do-install)
do-install:
	exec ${SETENV} ${MAKE_ENV} ${FAKE_SETUP} \
		${LOCALBASE}/bin/meson install --no-rebuild -C ${WRKBUILD}
.   endif

.   if !target(do-test)
do-test:
	exec ${SETENV} ${ALL_TEST_ENV} \
		${LOCALBASE}/bin/meson test --num-processes ${MAKE_JOBS} \
			--print-errorlogs -C ${WRKBUILD}
.   endif
.endif
