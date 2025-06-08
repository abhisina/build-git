#!/usr/bin/env bash
set -x #echo on
set -e #Exists on errors

#alias ll="ls -al"

SCRIPTPATH=$(cd $(dirname "$BASH_SOURCE") && pwd)
echo "SCRIPTPATH = $SCRIPTPATH"
pushd ${SCRIPTPATH}

#Workaround for build outside github: "env" file should then contain exports of github variables.
if [ -f "./env" ];
then
  source ./env
fi

if [ "$GITHUB_REF_NAME" = "" ];
then
	echo "Please define tag for this release (GITHUB_REF_NAME)"
	exit 1
fi

export VERSION=$(echo $GITHUB_REF_NAME)
wget https://www.kernel.org/pub/software/scm/git/git-${VERSION}.tar.gz
tar zxf git-${VERSION}.tar.gz
mv git-${VERSION} git-${VERSION}-src
pushd git-${VERSION}-src
./configure --prefix=$PWD/../git-${VERSION} --with-curl --with-openssl
make install
popd
tar czf git-${VERSION}.tar.gz git-${VERSION}