#!/bin/bash

cd $(dirname $0)

ARGS="$@"
[ -z "$ARGS" ] && ARGS='--env default'

if [[ "$ARGS" != *"--env default"* ]] ; then
    CRED="../mycredentials"
    [ ! -f $CRED ] && echo "Could not find credentials file: $CRED" && exit 1
    set -o allexport
    source $CRED
    set +o allexport
fi

./node_modules/.bin/nightwatch $ARGS
