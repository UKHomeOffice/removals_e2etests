#!/usr/bin/env bash
echo $@

#cleanup
rm -r nightwatch/reports/* nightwatch/screenshots/default

docker-compose up -d --build

# wait for selenium to come up
WAIT=0
while ! docker-compose run test curl -s -o /dev/null selenium:4444; do
    echo "waiting for selenium to start"
    sleep 0.5;
    WAIT=$(($WAIT + 1))
    if [ "$WAIT" -gt 15 ]; then
        echo "Error: Timeout wating for Postgres to start"
        exit 1
    fi
done

docker-compose run test nightwatch $@
exitcode=$?

docker-compose down
docker-compose rm --all

exit $exitcodeec