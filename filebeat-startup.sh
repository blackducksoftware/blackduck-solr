#!/bin/bash

if [ -z "$(pidof .$$BLACKDUCK_HOME/filebeat/filebeat)"]; 
then
    echo "Attempting to start "$($BLACKDUCK_HOME/filebeat/filebeat --version)
    $BLACKDUCK_HOME/filebeat/filebeat -c $BLACKDUCK_HOME/filebeat/filebeat.yml start &
fi

