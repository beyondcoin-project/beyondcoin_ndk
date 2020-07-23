#! /bin/bash
set -e

repo=$1
commit=$2
toolchain=$3
target_host=$4
bits=$5

git clone $repo beyondcoin
cd beyondcoin
git checkout $commit

patch -p1 < /repo/0001-depends-zeromq-4.2.3.patch
patch -p1 < /repo/0002-depends-patch-pthread_set_name_np-out-of-zeromq.patch
patch -p1 < /repo/0003-build-add-missing-leveldb-defines.patch
patch -p1 < /repo/0004-depends-disable-Werror-for-zmqlib-release-causes-ndk.patch
patch -p1 < /repo/0005-build-avoid-getifaddrs-when-unavailable.patch
patch -p1 < /repo/0006-ndk-fixes.patch


export PATH=/opt/$toolchain/bin:${PATH}
export AR=$target_host-ar
export AS=$target_host-clang
export CC=$target_host-clang
export CXX=$target_host-clang++
export LD=$target_host-ld
export STRIP=$target_host-strip
export LDFLAGS="-pie -static-libstdc++"

num_jobs=4
if [ -f /proc/cpuinfo ]; then
    num_jobs=$(grep ^processor /proc/cpuinfo | wc -l)
fi
cd depends
make HOST=$target_host NO_QT=1 -j $num_jobs

cd ..

./autogen.sh
./configure --prefix=$PWD/depends/$target_host ac_cv_c_bigendian=no ac_cv_sys_file_offset_bits=$bits --disable-bench --enable-experimental-asm --disable-tests --disable-man --without-utils --without-libs --with-daemon

make -j $num_jobs
make install

$STRIP depends/$target_host/bin/beyondcoind

repo_name=$(basename $(dirname ${repo}))

tar -zcf /repo/${target_host}_${repo_name}.tar.gz -C depends/$target_host/bin beyondcoind
