# PHP PECL module

MODULES +=	lang/php

FLAVORS ?= php74 php80 php81
FLAVOR ?= php80

# MODPECL_DEFAULTV is used in PLISTs so that @pkgpath markers are only
# applied for packages built against the "ports default" version of PHP,
# this allows updates from old removed versions without additional per-
# flavour PFRAG files.
MODPECL_DEFAULTV ?= "@comment "
MODPHP_VERSION = ${FLAVOR:C/php([0-9])([0-9])/\1.\2/}
.if ${FLAVOR} == php80
MODPECL_DEFAULTV = ""
.endif
MODPHP_BUILDDEP = Yes

CATEGORIES +=	www

_PECL_PREFIX =	pecl${MODPHP_VERSION:S/.//}
PKGNAME ?=	${_PECL_PREFIX}-${DISTNAME:S/pecl-//:L}
FULLPKGNAME ?=	${PKGNAME}
_PECLMOD ?=	${DISTNAME:S/pecl-//:C/-[0-9].*//:L}

SUBST_VARS +=	MODPECL_DEFAULTV

.if !defined(MASTER_SITES) && !defined(GH_PROJECT)
MASTER_SITES ?=	https://pecl.php.net/get/
HOMEPAGE ?=	https://pecl.php.net/package/${_PECLMOD}
EXTRACT_SUFX ?=	.tgz
.endif

AUTOCONF_VERSION ?= 2.71
AUTOMAKE_VERSION ?= 1.16

LIBTOOL_FLAGS += --tag=disable-static

DESTDIRNAME ?=	INSTALL_ROOT

BUILD_DEPENDS += www/pear \
	${MODGNU_AUTOCONF_DEPENDS} \
	${MODGNU_AUTOMAKE_DEPENDS}

MODPHP_DO_SAMPLE ?= ${_PECLMOD}
MODPHP_DO_PHPIZE ?= Yes

.if !target(do-test) && ${NO_TEST:L:Mno}
TEST_TARGET =	test
TEST_FLAGS =	NO_INTERACTION=1
USE_GMAKE ?=	Yes
TEST_ENV +=	TEST_PHP_EXECUTABLE=${MODPHP_BIN} \
		TEST_PHP_CGI_EXECUTABLE=${MODPHP_BIN:S/php/php-cgi/} \
		TEST_PHPDBG_EXECUTABLE=${MODPHP_BIN:S/php/phpdbg/}
.endif
