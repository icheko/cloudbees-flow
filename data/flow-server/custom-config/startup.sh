#!/bin/bash

# We don't need any actions here for the upgrade case
if [ "$CBF_SERVER_UPGRADE_MODE" = "1" ]; then
    exit 0
fi

log() {
    echo "$(date --iso-8601=ns | sed 's/[,\.]\([0-9][0-9][0-9]\).\+$/.\1/') * $1"
}

set -e

(
    wait_server_state() {
        SERVER_STATE=$(ectool getServerStatus --timeout 5000 --serverStateOnly 1)

        while [ "$SERVER_STATE" != "$1" ]; do
            if [[ "$SERVER_STATE" == "failed" ]]; then
                log "ERROR: Server failed to run failing initialization attempt"
                exit 2
            else
                log "Server state is ${SERVER_STATE}, waiting for $1"
            fi
            PREV_STATE=${SERVER_STATE}
            SERVER_STATE=$(ectool getServerStatus --timeout 5000 --serverStateOnly 1)
            sleep 5
        done

        log "Server has state: $SERVER_STATE"
    }

    log "Waiting for CloudBees Flow server up..."
    log "Waiting for bundled database to be up"
    sleep 60

    wait_server_state "databaseConfiguration"

    log "Configuring CloudBees Flow server database..."
    if ! ectool --silent --timeout 36000 setDatabaseConfiguration \
            --databaseType "$CBF_DB_TYPE" \
            --databaseName "$CBF_DB_NAME" --userName "$CBF_DB_USER" \
            --password "$CBF_DB_PASSWORD" --hostName "$CBF_DB_HOST"
    then
        log "ERROR: could not configure CloudBees Flow server."
        exit 1
    fi
    if [ -d /custom-config ]; then
        cp /opt/cbflow/conf/passkey /custom-config/passkey
    fi
    log "Database '${CBF_DB_TYPE}' configured on CloudBees Flow server"

) &