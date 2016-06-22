#!/usr/bin/env bash
set -e

export BRANCH=$(git rev-parse --abbrev-ref HEAD)

rm -rf be fe

git clone https://github.com/UKHomeOffice/removals_integration.git be
git clone https://github.com/UKHomeOffice/removals_wallboard.git fe
cd be
git checkout $BRANCH || true
cd ../fe
git checkout $BRANCH || true
cd ..

./runtests.sh --env docker