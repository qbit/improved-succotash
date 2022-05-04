# Module for Xfce related ports, divided into five categories:
# core, goodie, artwork, thunar plugins, panel plugins.

XFCE_DESKTOP_VERSION=	4.16.0
CATEGORIES+=	x11/xfce4

USE_GMAKE?=	Yes
EXTRACT_SUFX?=	.tar.bz2

# needed for all ports but *-themes
.if !defined(XFCE_NO_SRC)
LIBTOOL_FLAGS?=	--tag=disable-static

MODULES+=	textproc/intltool
.endif

# if version is not defined, it's the DE version
.if !defined(XFCE_VERSION)
XFCE_VERSION=	${XFCE_DESKTOP_VERSION}
.endif

XFCE_BRANCH=	${XFCE_VERSION:C/^([0-9]+\.[0-9]+).*/\1/}

# Set to 'yes' if there are .desktop files under share/applications/.
.if defined(MODXFCE_DESKTOP_FILE) && ${MODXFCE_DESKTOP_FILE:L} == "yes"
MODXFCE_RUN_DEPENDS+=	devel/desktop-file-utils
.endif

# Set to 'yes' if there are icon files under share/icons/.
.if defined(MODXFCE_ICON_CACHE) && ${MODXFCE_ICON_CACHE:L} == "yes"
MODXFCE_RUN_DEPENDS+=  x11/gtk+3,-guic
.endif

.if defined(XFCE_PLUGIN)
HOMEPAGE?=	https://docs.xfce.org/panel-plugins/xfce4-${XFCE_PLUGIN}-plugin/start

MASTER_SITES?=	https://archive.xfce.org/src/panel-plugins/xfce4-${XFCE_PLUGIN}-plugin/${XFCE_BRANCH}/
MASTER_SITES_GIT?=	https://gitlab.xfce.org/panel-plugins/xfce4-${XFCE_PLUGIN}-plugin/-/archive/${XFCE_COMMIT}/
DISTNAME?=	xfce4-${XFCE_PLUGIN}-plugin-${XFCE_VERSION}
DISTNAME_GIT?=	xfce4-${XFCE_PLUGIN}-plugin-${XFCE_COMMIT}
PKGNAME?=	xfce4-${XFCE_PLUGIN}-${XFCE_VERSION}

MODXFCE_LIB_DEPENDS=	x11/xfce4/xfce4-panel
MODXFCE_WANTLIB?=	xfce4panel-2.0
MODXFCE_PURGE_LA?=	lib/xfce4/panel/plugins lib/xfce4/panel-plugins
.elif defined(XFCE_GOODIE)
HOMEPAGE?=	https://docs.xfce.org/apps/${XFCE_GOODIE}/start

DEBUG_PACKAGES=	${BUILD_PACKAGES}
MASTER_SITES?=	https://archive.xfce.org/src/apps/${XFCE_GOODIE:L}/${XFCE_BRANCH}/
MASTER_SITES_GIT?=	https://gitlab.xfce.org/apps/${XFCE_GOODIE:L}/-/archive/${XFCE_COMMIT}/
DISTNAME?=	${XFCE_GOODIE}-${XFCE_VERSION}
DISTNAME_GIT?=	${XFCE_GOODIE}-${XFCE_COMMIT}
PKGNAME?=	${XFCE_GOODIE}-${XFCE_VERSION}
.elif defined(XFCE_ARTWORK)
HOMEPAGE?=	https://www.xfce.org/projects/

MASTER_SITES?=	https://archive.xfce.org/src/art/${XFCE_ARTWORK}/${XFCE_BRANCH}/
DISTNAME?=	${XFCE_ARTWORK}-${XFCE_VERSION}
.elif defined(THUNAR_PLUGIN)
HOMEPAGE?=	https://docs.xfce.org/xfce/thunar/${THUNAR_PLUGIN:S/thunar-//:S/-plugin//}

MASTER_SITES?=	https://archive.xfce.org/src/thunar-plugins/${THUNAR_PLUGIN}/${XFCE_BRANCH}/
DISTNAME?=	${THUNAR_PLUGIN}-${XFCE_VERSION}
PKGNAME?=	${DISTNAME:S/-plugin//}
MODXFCE_PURGE_LA ?=	lib/thunarx-2
.elif defined(XFCE_PROJECT)
HOMEPAGE?=	https://docs.xfce.org/xfce/${XFCE_PROJECT}/start

DEBUG_PACKAGES=	${BUILD_PACKAGES}
MASTER_SITES?=	https://archive.xfce.org/src/xfce/${XFCE_PROJECT:L}/${XFCE_BRANCH}/
MASTER_SITES_GIT?=	https://gitlab.xfce.org/xfce/${XFCE_PROJECT:L}/-/archive/${XFCE_COMMIT}/
DISTNAME?=	${XFCE_PROJECT}-${XFCE_VERSION}
DISTNAME_GIT?=	${XFCE_PROJECT}-${XFCE_COMMIT}
PKGNAME?=	${XFCE_PROJECT}-${XFCE_VERSION}
PORTROACH+=	limitw:1,even
.endif

.if defined(XFCE_COMMIT)
DISTNAME =	${DISTNAME_GIT}
MASTER_SITES =	${MASTER_SITES_GIT}
CONFIGURE_ARGS +=	--enable-maintainer-mode --enable-debug
AUTOMAKE_VERSION =	1.14
AUTOCONF_VERSION =	2.69
MODXFCE4_gen =	cd ${WRKSRC} && env NOCONFIGURE=yes \
		AUTOCONF_VERSION=${AUTOCONF_VERSION} AUTOMAKE_VERSION=${AUTOMAKE_VERSION} \
		./autogen.sh
BUILD_DEPENDS +=	${MODGNU_AUTOCONF_DEPENDS} \
			${MODGNU_AUTOMAKE_DEPENDS} \
			x11/xfce4/xfce4-dev-tools

.endif

# remove useless .la file
MODXFCE_PURGE_LA ?=
.if !empty(MODXFCE_PURGE_LA)
MODXFCE4_post-install = for f in ${MODXFCE_PURGE_LA} ; do \
		rm -f ${PREFIX}/$${f}/*.la ; done
.endif

LIB_DEPENDS+=	${MODXFCE_LIB_DEPENDS}
WANTLIB+=	${MODXFCE_WANTLIB}
RUN_DEPENDS+=	${MODXFCE_RUN_DEPENDS}
CFLAGS+=	-std=gnu99
CONFIGURE_ENV+=	CPPFLAGS="-I${LOCALBASE}/include -I${X11BASE}/include" \
		LDFLAGS="-L${LOCALBASE}/lib"
