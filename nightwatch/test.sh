#!/bin/bash

cd $(dirname $0)

ARGS="$@"
[ -z "$ARGS" ] && ARGS='--env default'

if [[ "$ARGS" != *"--env default"* ]] ; then
    CRED="../mycredentials"
    if [ -f $CRED ] ; then
        set -o allexport
        source $CRED
        set +o allexport
    else
        echo "WARNING: No KeyCloak credentials found, creating blank file: $CRED"
        printf "KEYCLOAK_USER=\nKEYCLOAK_PASS=" > $CRED
    fi
fi

./node_modules/.bin/nightwatch $ARGS
