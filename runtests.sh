#!/usr/bin/env bash

if [[ $@ == *"docker"* ]]
then
    export COMPOSE_FILE=docker-compose.yml:docker-compose.locale2e.yml
else
    export COMPOSE_FILE=docker-compose.yml
fi


if [ ! -e mycredentials ] ; then
    touch mycredentials
    echo "KEYCLOAK_USER=$KEYCLOAK_USER
    KEYCLOAK_PASS=$KEYCLOAK_PASS" > mycredentials
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

#docker wait removalse2etests_waiter_1
docker-compose logs waiter

docker ps -a

docker inspect ircbdautomationtests_test_1
docker inspect ircbdautomationtests_selenium_1
docker inspect ircbdautomationtests_waiter_1

echo travis_fold:end:DOCKER_COMPOSE_UP

echo travis_fold:start:LINT
docker-compose run --rm -T test npm run lint $@
lintcode=$?
echo travis_fold:end:LINT

docker-compose run --rm -T test nightwatch $@
nightwatchcode=$?

docker-compose run --rm -T test nightwatch-html-reporter -d reports -t cover -b false

if [ $(($lintcode + $nightwatchcode)) -ne 0 ]; then
	echo "Lint exit code: $lintcode"
	echo "Test exit code: $nightwatchcode"
	echo "Failure."
	exit 1
fi
