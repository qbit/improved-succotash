# sync with asterisk-sounds/Makefile and asterisk-sounds/*sounds/Makefile
MODAS_CODECS ?=	gsm alaw ulaw g722 g729 wav # sln16 siren7 siren14

CATEGORIES +=	telephony
DISTNAME =	${MODAS_NAME}-${MODAS_LANG:C/(.+)/\1-/}${MODAS_CODEC}-${MODAS_VER}
FULLPKGNAME ?=  ${DISTNAME}
MASTER_SITES ?= http://downloads.asterisk.org/pub/telephony/sounds/releases/
HOMEPAGE =	http://www.asterisk.org/
COMMENT =	${MODAS_DESC}

EXTRACT_ONLY =
NO_BUILD =	Yes
NO_TEST =	Yes
PKG_ARCH =	*

_LN-en_AU =	Australian English
_LN-en =	English
_LN-es =	Spanish
_LN-fr =	French
_LN-it =	Italian
_LN-ru =	Russian

MODAS_LANGNAME = ${_LN-${MODAS_LANG}}
MODAS_CODEC =	${FLAVOR}

FLAVORS ?=	${MODAS_CODECS}
FLAVOR ?=	gsm

.if defined(MODAS_LANG)
.  for c in ${MODAS_CODECS}
SUPDISTFILES += ${MODAS_NAME}-${MODAS_LANG}-$c-${MODAS_VER}${EXTRACT_SUFX}
.  endfor
.else
.  for c in ${MODAS_CODECS}
SUPDISTFILES += ${MODAS_NAME}-$c-${MODAS_VER}${EXTRACT_SUFX}
.  endfor
.endif

_T = ${MODAS_NAME:S/asterisk-//}

MODAS_INST ?=	share/asterisk/sounds/${MODAS_LANG}
SUBST_VARS +=	MODAS_INST L MODAS_LANGNAME MODAS_CODEC MODAS_VER

do-install:
	${INSTALL_DATA_DIR} ${PREFIX}/${MODAS_INST}
	${GZIP_CMD} -dc ${FULLDISTDIR}/${DISTNAME}${EXTRACT_SUFX} | \
	    ${TAR} xf - -C ${PREFIX}/${MODAS_INST}
