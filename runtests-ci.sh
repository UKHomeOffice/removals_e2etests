#!/usr/bin/env bash
set -e

export BRANCH=origin/$TRAVIS_BRANCH
export DOCKER_BRANCH=$(echo $BRANCH | sed -e "s/\//_/g")

docker pull quay.io/ukhomeofficedigital/removals-api:${DOCKER_BRANCH} || docker pull quay.io/ukhomeofficedigital/removals-api:origin_master
docker tag quay.io/ukhomeofficedigital/removals-api:${DOCKER_BRANCH} ibm-backend || docker tag quay.io/ukhomeofficedigital/removals-api:origin_master ibm-backend
docker pull quay.io/ukhomeofficedigital/removals-wallboard:${DOCKER_BRANCH} || docker pull quay.io/ukhomeofficedigital/removals-wallboard:origin_master
docker tag quay.io/ukhomeofficedigital/removals-wallboard:${DOCKER_BRANCH} ibm-frontend || docker tag quay.io/ukhomeofficedigital/removals-wallboard:origin_master ibm-frontend


./runtests.sh --env docker