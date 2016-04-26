#!/bin/bash

ENV=$1
[ -z "$ENV" ] && ENV='default'

if [ "$ENV" != "default" ] ; then
    CRED="../mycredentials"
    [ ! -f $CRED ] && echo "Could not find credentials file: $CRED" && exit 1
    CRED="env `cat $CRED`"
fi

$CRED ./node_modules/.bin/nightwatch --env $ENV
