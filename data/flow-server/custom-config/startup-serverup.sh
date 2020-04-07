#!/bin/bash

# We don't need any actions here for the upgrade case
if [ "$CBF_SERVER_UPGRADE_MODE" = "1" ]; then
    exit 0
fi

log() {
    echo "$(date --iso-8601=ns | sed 's/[,\.]\([0-9][0-9][0-9]\).\+$/.\1/') * $1"
}

set -e

log "Setting general properties..."

(set -x; ectool --silent login admin changeme)

(set -x; ectool --silent modifyWorkspace "default" --local true)
(set -x; ectool --silent setProperty /server/settings/stompClientUri stomp+ssl://"$CBF_SERVER_HOST":61613)
(set -x; ectool --silent setProperty /server/settings/stompSecure true)
(set -x; ectool --silent setProperty /server/settings/ipAddress "$CBF_SERVER_HOST")
(set -x; ectool --silent setProperty /server/settings/maxUploadSize "50000000000")
(set -x; ectool --silent setProperty /server/settings/webServerHost "$CBF_WEB_FQDN")