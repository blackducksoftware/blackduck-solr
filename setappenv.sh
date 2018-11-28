#!/bin/sh
set -e

ZK_HOST=${HUB_ZOOKEEPER_HOST:-zookeeper}:${HUB_ZOOKEEPER_PORT:-2181}/blackduck/hub/solrcloud
COLLECTION_NAME=${COLLECTION_NAME:-project}

# Defaults
SOLR_OPTS="$SOLR_OPTS -Dsolr.data.dir=$SOLR_HOME/cores.data"
SOLR_OPTS="$SOLR_OPTS -Dbootstrap_confdir=$SOLR_HOME/cores.conf/project/conf"
SOLR_OPTS="$SOLR_OPTS -Dcollection.configName=${COLLECTION_NAME}"
SOLR_OPTS="$SOLR_OPTS -DzkHost=${ZK_HOST}" 
SOLR_OPTS="$SOLR_OPTS -Xms512m -Xmx${HUB_MAX_MEMORY:-512m}"
SOLR_OPTS="$SOLR_OPTS -Dblackduck.hub.applicationName=${HUB_APPLICATION_NAME:-hub-solr}"
SOLR_OPTS="$SOLR_OPTS -Dhost=${HUB_SOLR_HOST:-solr}"

# HUB_LOGSTASH_HOST/PORT
SOLR_OPTS="$SOLR_OPTS -Dblackduck.hub.logstash.host=${HUB_LOGSTASH_HOST:-logstash}"
SOLR_OPTS="$SOLR_OPTS -Dblackduck.hub.logstash.port=${HUB_LOGSTASH_PORT:-4560}"
SOLR_OPTS="$SOLR_OPTS -Dblackduck.hub.application.logHome=${SOLR_HOME}/logs"

export SOLR_OPTS

SOLR_TIMEZONE="${TZ:-UTC}"

export SOLR_TIMEZONE