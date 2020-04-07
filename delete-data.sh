#!/bin/bash

read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo
    echo Deleting data
    echo -------------------------
    echo
    rm -Rfv data/db/*
    rm -Rfv data/db/.user_scripts_initialized
    rm -Rfv data/flow-web/*
    rm -Rfv data/flow-server/custom-config/security
    rm -Rfv data/flow-server/custom-config/keystore
    rm -Rfv data/flow-server/custom-config/passkey
    rm -Rfv data/flow-server/plugins-data/*
    rm -Rfv data/flow-repository/data/*
    rm -Rfv data/flow-devopsinsight/data/*
else
    echo Exit
fi