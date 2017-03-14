#!/bin/bash

[ $UID != 0 ] && echo "Inicialo con sudo" && exit 1

_LB_PATH=/var/gensys/live-build/gecosv3-lite

_ACT_PATH=$(pwd)

_BUILD_DATE=$(date +%Y%m%d-%H%M)
_LOG_FILE="$_LB_PATH/log/lb_build-$_BUILD_DATE.log"
_ERROR_LOG_FILE="$_LB_PATH/log/lb_build-$_BUILD_DATE.error.log"
test -h $_LB_PATH/log/lb_build.log && rm $_LB_PATH/log/lb_build.log
ln -s $_LOG_FILE $_LB_PATH/log/lb_build.log
test -h $_LB_PATH/log/lb_build.error.log && rm $_LB_PATH/log/lb_build.error.log
ln -s $_ERROR_LOG_FILE $_LB_PATH/log/lb_build.error.log


pushd ${_LB_PATH}
LIVE_BUILD=${_LB_PATH} lb clean 2>${_ERROR_LOG_FILE} | tee -a ${_LOG_FILE}
LIVE_BUILD=${_LB_PATH} lb config 2>${_ERROR_LOG_FILE} | tee -a ${_LOG_FILE}
LIVE_BUILD=${_LB_PATH} lb build 2>${_ERROR_LOG_FILE} | tee -a ${_LOG_FILE}
#LIVE_BUILD=${_LB_PATH} lb bootstrap 2>${_ERROR_LOG_FILE} | tee -a ${_LOG_FILE}
#LIVE_BUILD=${_LB_PATH} lb chroot 2>${_ERROR_LOG_FILE} | tee -a ${_LOG_FILE}
#LIVE_BUILD=${_LB_PATH} lb binary 2>${_ERROR_LOG_FILE} | tee -a ${_LOG_FILE}
#LIVE_BUILD=${_LB_PATH} lb source 2>${_ERROR_LOG_FILE} | tee -a ${_LOG_FILE}
popd ${_ACT_PATH}

mkdir -p /srv/gecos-lite.mnt
mount -o loop ${_LB_PATH}/binary.hybrid.iso /srv/gecos-lite.mnt
rm -fr /srv/gecos-lite
mkdir -p /srv/gecos-lite
cp -a /srv/gecos-lite.mnt/* /srv/gecos-lite
cp -a /srv/gecos-lite.mnt/.disk /srv/gecos-lite/.disk
cp -a /srv/gecos-lite.mnt/preseed/* /var/gensys/deb-repositories/isos/preseed-gecos/
umount /srv/gecos-lite.mnt
