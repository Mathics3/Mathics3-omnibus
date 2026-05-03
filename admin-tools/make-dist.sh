#!/bin/bash
PACKAGE=mathics3_omnibus

# FIXME put some of the below in a common routine
function finish {
  cd $owd
}

cd $(dirname ${BASH_SOURCE[0]})
owd=$(pwd)
trap finish EXIT

if ! source ./pyenv-versions ; then
    exit $?
fi


cd ..
source mathics3_omnibus/version.py
echo $__version__

pyversion=3.13
if ! pyenv local $pyversion ; then
    exit $?
fi
rm -fr build
python -m build --wheel
python -m build --sdist
finish
