#!/usr/bin/env bash

if [[ $@ == *"docker"* ]]
then
    export COMPOSE_FILE=docker-compose.yml:docker-compose.locale2e.yml
else
    export COMPOSE_FILE=docker-compose.yml
fi


if [ ! -e mycredentials ] ; then
    touch mycredentials
fi

trap tidyup EXIT
function tidyup {
    docker-compose down
    docker-compose rm -f
}

#cleanup
rm -fr nightwatch/reports/* nightwatch/screenshots/default
mkdir -p nightwatch/reports nightwatch/screenshots/default

echo travis_fold:start:DOCKER_COMPOSE_UP
docker-compose up -d --build --force-recreate

echo "waiting for everything to be up"

docker wait removalse2etests_waiter_1
docker-compose logs waiter

echo travis_fold:end:DOCKER_COMPOSE_UP

docker-compose run --rm -T test nightwatch $@
exitcode=$?

docker-compose run --rm -T test nightwatch-html-reporter -d reports -t cover -b false

exit $exitcode
