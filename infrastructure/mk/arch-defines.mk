# $OpenBSD: arch-defines.mk,v 1.89 2021/12/20 08:30:13 sthen Exp $
#
# ex:ts=4 sw=4 filetype=make:
#
#	derived from bsd.port.mk in 2011
#	This file is in the public domain.
#	It is actually a part of bsd.port.mk that won't be included manually.
#

# architecture constants

ARCH ?!= uname -m

ALL_ARCHS = aarch64 alpha amd64 arm arm64 armv7 hppa i386 landisk loongson \
	luna88k m88k macppc mips64 mips64el octeon powerpc64 riscv64 sgi \
	sh sparc64
# normally only list MACHINE_ARCH (uname -p) names in these variables,
# but not all powerpc have apm(4), hence the use of macppc
APM_ARCHS = arm64 amd64 i386 loongson macppc sparc64
BE_ARCHS = hppa m88k mips64 powerpc powerpc64 sparc64
LE_ARCHS = aarch64 alpha amd64 arm i386 mips64el riscv64 sh
LP64_ARCHS = aarch64 alpha amd64 mips64 mips64el powerpc64 riscv64 sparc64
GCC4_ARCHS = alpha hppa sh sparc64
GCC3_ARCHS = m88k
# XXX easier for ports that depend on mono
MONO_ARCHS = aarch64 amd64 i386
OCAML_NATIVE_ARCHS = aarch64 amd64 i386
OCAML_NATIVE_DYNLINK_ARCHS = aarch64 amd64 i386
GO_ARCHS = aarch64 amd64 arm armv7 i386 mips64
RUST_ARCHS = aarch64 amd64 i386 sparc64

# arches where the base compiler is clang
CLANG_ARCHS = aarch64 amd64 arm i386 mips64 mips64el powerpc powerpc64 riscv64
# arches using LLVM's linker (ld.lld); others use binutils' ld.bfd
LLD_ARCHS = aarch64 amd64 arm i386 powerpc powerpc64 riscv64

# arches where ports devel/llvm builds - populates llvm ONLY_FOR_ARCHS
# as well as available for PROPERTIES checks.
LLVM_ARCHS = aarch64 amd64 arm i386 mips64 mips64el powerpc powerpc64 riscv64 sparc64
# arches where ports-gcc >4.9 exists.  To be used again for modules
GCC49_ARCHS = aarch64 alpha amd64 arm hppa i386 mips64 mips64el powerpc powerpc64 sparc64

# arches where there is a C++11 compiler, either clang in base or ports-gcc
CXX11_ARCHS = ${CLANG_ARCHS} ${GCC49_ARCHS}
DEBUGINFO_ARCHS = aarch64 amd64

.for PROP in ALL APM BE LE LP64 CLANG GCC4 GCC3 GCC49 MONO LLVM \
                     CXX11 OCAML_NATIVE OCAML_NATIVE_DYNLINK GO \
                     LLD RUST DEBUGINFO
.  for A B in ${MACHINE_ARCH} ${ARCH}
.    if !empty(${PROP}_ARCHS:M$A) || !empty(${PROP}_ARCHS:M$B)
PROPERTIES += ${PROP:L}
.    endif
.  endfor
.endfor

.if ${PROPERTIES:Mclang}
LIBCXX = c++ c++abi pthread
LIBECXX = c++ c++abi pthread
.else
LIBCXX = stdc++ pthread
LIBECXX = estdc++>=17 pthread
.endif

.if ${PROPERTIES:Mlld} || defined(USE_LLD) && ${USE_LLD:L} == yes
# see llvm/tools/lld/ELF/Driver.cpp
_LLD_EMUL_aarch64 = aarch64elf
_LLD_EMUL_amd64 = elf_amd64
_LLD_EMUL_arm = armelf
_LLD_EMUL_i386 = elf_i386
_LLD_EMUL_mips64 = elf64btsmip
_LLD_EMUL_mips64el = elf64ltsmip
_LLD_EMUL_powerpc = elf32ppc
_LLD_EMUL_powerpc64 = elf64ppc
_LLD_EMUL_riscv64 = elf64lriscv
_LLD_EMUL_sparc64 = elf64_sparc
.endif

.if defined(_LLD_EMUL_${MACHINE_ARCH})
LLD_EMUL = -m${_LLD_EMUL_${MACHINE_ARCH}}
.else
LLD_EMUL =
.endif

# system version wide specifics
_SYSTEM_VERSION = 1
_SYSTEM_VERSION-aarch64 = 6
_SYSTEM_VERSION-amd64 = 6
_SYSTEM_VERSION-arm = 6
_SYSTEM_VERSION-i386 = 4
_SYSTEM_VERSION-mips64 = 3
_SYSTEM_VERSION-mips64el = 2
_SYSTEM_VERSION-powerpc = 4
_SYSTEM_VERSION-powerpc64 = 2
_SYSTEM_VERSION-riscv64 = 1
_SYSTEM_VERSION-${MACHINE_ARCH} ?= 0
_SYSTEM_VERSION-${ARCH} ?= 0

# added to version for all clang arches
_SYSTEM_VERSION-clang = 1

# @version = ${_SYSTEM_VERSION} + ${_SYSTEM_VERSION-${MACHINE_ARCH}}
_PKG_ARGS_VERSION += -V ${_SYSTEM_VERSION} -V ${_SYSTEM_VERSION-${MACHINE_ARCH}}
.if ${ARCH} != ${MACHINE_ARCH}
_PKG_ARGS_VERSION += -V ${_SYSTEM_VERSION-${ARCH}}
.endif

# + ${_SYSTEM_VERSION-prop} for any prop that's true
.for _i in ${PROPERTIES}
.  if defined(_SYSTEM_VERSION-${_i})
_PKG_ARGS_VERSION += -V ${_SYSTEM_VERSION-${_i}}
.  endif
.endfor
