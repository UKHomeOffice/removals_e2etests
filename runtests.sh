#!/usr/bin/env bash

if [[ $@ == *"docker"* ]]
then
COMPOSE_FILE=docker-compose.yml:docker-compose.locale2e.yml
    export COMPOSE_FILE=docker-compose.yml:docker-compose.locale2e.yml
#  DOCKERARGS="-f docker-compose.yml -f docker-compose.locale2e.yml"
fi

trap tidyup EXIT
function tidyup {
    docker-compose $DOCKERARGS down
    docker-compose $DOCKERARGS rm --all
}

#cleanup
rm -fr nightwatch/reports/* nightwatch/screenshots/default

docker-compose $DOCKERARGS up -d --build

# wait for selenium to come up
WAIT=0
while ! docker-compose $DOCKERARGS run test curl -s -o /dev/null selenium:4444; do
    echo "waiting for selenium to start"
    sleep 0.5;
    WAIT=$(($WAIT + 1))
    if [ "$WAIT" -gt 15 ]; then
        echo "Error: Timeout wating for Selenium to start"
        exit 1
    fi
done

docker-compose $DOCKERARGS run test nightwatch $@
exitcode=$?
docker-compose $DOCKERARGS run nightwatch-html-reporter -d reports -t cover -b false

exit $exitcodeec