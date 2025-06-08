#!/usr/bin/env bash
set -euxo pipefail

SCRIPTPATH=$(cd $(dirname "$BASH_SOURCE") && pwd)
echo "SCRIPTPATH = $SCRIPTPATH"
pushd ${SCRIPTPATH}

if [ -f "./env" ];
then
  source ./env
fi

if [ "$GITHUB_REF_NAME" = "" ];
then
	echo "Please define tag for this release (GITHUB_REF_NAME)"
	exit 1
fi

export VERSION=$(echo $GITHUB_REF_NAME | cut -d'-' -f1)
wget https://www.kernel.org/pub/software/scm/git/git-${VERSION}.tar.gz
tar zxf git-${VERSION}.tar.gz
rm git-${VERSION}.tar.gz
mv git-${VERSION} git-${VERSION}-src
pushd git-${VERSION}-src
./configure --prefix=$PWD/../git-${VERSION} --with-curl --with-openssl
make -j4 install
popd
tar czf "${SCRIPTPATH}/git-${VERSION}.tar.gz" git-${VERSION}
popd
pwd
ls -l