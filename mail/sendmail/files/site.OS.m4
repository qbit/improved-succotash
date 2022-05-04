# OpenBSD Sendmail port configuration, generated from __file__
dnl
dnl Target directories
dnl ==================
define(`confHFDIR',		`${TRUEPREFIX}/share/examples/sendmail')dnl
define(`confINCLUDEDIR',	`${TRUEPREFIX}/include')dnl
define(`confLIBDIR',		`${TRUEPREFIX}/lib')dnl
define(`confUBINDIR',		`${TRUEPREFIX}/bin')dnl
define(`confSBINDIR',		`${TRUEPREFIX}/sbin')dnl
define(`confEBINDIR',		`${TRUEPREFIX}/libexec')dnl
define(`confMBINDIR',		`${TRUEPREFIX}/libexec/sendmail/')dnl
dnl Overriden in PLIST
define(`confMSPQOWN',		`root')
define(`confGBINGRP',		`wheel')
dnl Manpages handling
dnl =================
define(`confMANROOT',		`${TRUEPREFIX}/man/man')dnl
define(`confMANROOTMAN',	`${TRUEPREFIX}/man/man')dnl
dnl define(`confNO_MAN_BUILD',	`Yes')dnl
define(`confINSTALL_RAWMAN',	'Yes')dnl
define(`confDONT_INSTALL_CATMAN', 'Yes')dnl
dnl FIXME
define(`confNO_STATISTICS_INSTALL')dnl
dnl Features we want
dnl ================
APPENDDEF(`confENVDEF', `-DNEEDSGETIPNODE')dnl
APPENDDEF(`confENVDEF', `-DNETINET6')dnl
APPENDDEF(`confENVDEF', `-DSM_CONF_SHM')dnl
APPENDDEF(`confMAPDEF', `-DSOCKETMAP')dnl
APPENDDEF(`conf_libmilter_ENVDEF', `-DMILTER')
APPENDDEF(`conf_sendmail_ENVDEF', `-DMILTER')
dnl (START)TLS
APPENDDEF(`confENVDEF', `-DSTARTTLS')dnl
APPENDDEF(`confENVDEF', `-D_FFR_TLS_EC')dnl
APPENDDEF(`confENVDEF', `-D_FFR_TLS_SE_OPTS')dnl
APPENDDEF(`confLIBS', `-lssl -lcrypto')dnl
dnl Flavors
dnl =======
ifelse(`${WANT_LOCALBASE}', `Yes',dnl
	`APPENDDEF(`confINCDIRS', `-I${LOCALBASE}/include')dnl
	 APPENDDEF(`confLIBDIRS', `-L${LOCALBASE}/lib')')dnl
dnl
ifelse(`${WANT_LDAP}', `Yes',dnl
	`APPENDDEF(`confMAPDEF', `-DLDAPMAP')dnl
dnl Explicitely link against liblber, ld.lld does not automatically
dnl follow inter-libraries deps like binutils-2.17 ld does.
	 APPENDDEF(`confLIBS', `-lldap -llber')')dnl
dnl
ifelse(`${WANT_SMTP_AUTH}', `Yes',dnl
	`APPENDDEF(`conf_sendmail_ENVDEF', `-DSASL')dnl
	 APPENDDEF(`conf_sendmail_LIBS', `-lsasl2')dnl
	 APPENDDEF(`confINCDIRS', `-I${LOCALBASE}/include/sasl')')dnl
dnl Misc
dnl ====
dnl we do have poll(2), so use it
APPENDDEF(`conf_libmilter_ENVDEF', `-DSM_CONF_POLL')dnl
