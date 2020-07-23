Build status: [![Build Status](https://travis-ci.org/beyondcoin-project/beyondcoin_ndk.png?branch=master)](https://travis-ci.org/beyondcoin-project/beyondcoin_ndk)

This repo is a dependency of greenaddress/abcore however it is usable stand alone.

You can build using docker or using debian stretch.

There is a docker image prebuilt (see .travis.yml file) but you can build the same
image by issuing docker build . in the root of this repo.

The docker image assumes the repo is mounted as a volume to /repo.

Many thanks to https://github.com/morristech/android-ifaddrs for the ifaddrs files and to the Core and Knots team.

