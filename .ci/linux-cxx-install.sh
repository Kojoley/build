#!/bin/sh

# Usage:
# LLVM_OS: LLVM OS release to obtain clang binaries. Only needed for clang install.
# LLVM_VER: The LLVM toolset version to point the repo at.
# PACKAGES: Compiler packages to install.

if command -v sudo ; then
    SUDO="sudo -E"
fi

# APT_GET="${SUDO} apt-get -o Acquire::Retries=3 -yq --no-install-suggests --no-install-recommends"
APT_GET="${SUDO} apt-get -o Acquire::Retries=3 -yq"

set -e
if [ -n "${PACKAGES}" ] ; then
echo ">>>>>"
echo ">>>>> APT: UPDATE.."
echo ">>>>>"
${APT_GET} update

if [ -n "${REPO}" ] ; then
     echo ">>>>>"
     echo ">>>>> APT: INSTALL apt-add-repository.."
     echo ">>>>>"
     ${APT_GET} install wget software-properties-common
     echo ">>>>>"
     echo ">>>>> APT: ADD REPO.."
     echo ">>>>>"
     case ${REPO} in
         ppa)
             ${SUDO} apt-add-repository -y "ppa:ubuntu-toolchain-r/test"
             ;;
         llvm*)
             . $(ls /etc/os-release 2>/dev/null || echo /usr/lib/os-release)
             wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | ${SUDO} apt-key add -
             ${SUDO} apt-add-repository "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}${REPO##llvm} main"
             ;;
     esac
fi

echo ">>>>>"
echo ">>>>> APT: INSTALL: ${PACKAGES}.."
echo ">>>>>"
${APT_GET} install python3 ${PACKAGES}
fi

# Use, modification, and distribution are
# subject to the Boost Software License, Version 1.0. (See accompanying
# file LICENSE.txt)
#
# Copyright Rene Rivera 2020-2023.
