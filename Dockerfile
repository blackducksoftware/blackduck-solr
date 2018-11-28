FROM blackducksoftware/hub-docker-common:1.0.1 as docker-common
FROM solr:6.6.3-alpine

ARG VERSION
ARG LASTCOMMIT
ARG BUILDTIME
ARG BUILD

LABEL com.blackducksoftware.hub.vendor="Black Duck Software, Inc." \
      com.blackducksoftware.hub.version="$VERSION" \
      com.blackducksoftware.hub.lastCommit="$LASTCOMMIT" \
      com.blackducksoftware.hub.buildTime="$BUILDTIME" \
      com.blackducksoftware.hub.build="$BUILD"

ENV BLACKDUCK_RELEASE_INFO "com.blackducksoftware.hub.vendor=Black Duck Software, Inc. \
com.blackducksoftware.hub.version=$VERSION \
com.blackducksoftware.hub.lastCommit=$LASTCOMMIT \
com.blackducksoftware.hub.buildTime=$BUILDTIME \
com.blackducksoftware.hub.build=$BUILD"

USER root
RUN echo -e "$BLACKDUCK_RELEASE_INFO" > /etc/blackduckrelease

ENV HUB_APPLICATION_NAME="hub-solr"
ENV BLACKDUCK_HOME="/opt/blackduck/hub"
ENV SOLR_HOME="$BLACKDUCK_HOME/solr"
ENV FILEBEAT_VERSION 5.5.2

COPY log4j.properties /opt/solr/server/resources/log4j.properties
COPY setappenv.sh /docker-entrypoint-initdb.d
COPY prestartcmds.sh /docker-entrypoint-initdb.d
COPY filebeat-startup.sh /docker-entrypoint-initdb.d
COPY --from=docker-common healthcheck.sh /usr/local/bin/docker-healthcheck.sh
COPY solr "$SOLR_HOME/"

# custom data directory
RUN set -e \
     && apk add --no-cache --virtual .hub-solr-run-deps \
    		jq \
    		curl \
    		tzdata \
     && mkdir -p $SOLR_HOME/cores.data $SOLR_HOME/logs \
     && chown -R solr:root $SOLR_HOME/cores.data $SOLR_HOME/cores.conf $SOLR_HOME/logs "/opt/solr/server/logs" \
     && chmod -R 775 $SOLR_HOME/cores.data $SOLR_HOME/cores.conf $SOLR_HOME/logs "/opt/solr/server/logs"\
     && rm /usr/bin/nc \
     && curl -L https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$FILEBEAT_VERSION-linux-x86_64.tar.gz | \
 	   tar xz -C $BLACKDUCK_HOME \
	 && mv $BLACKDUCK_HOME/filebeat-$FILEBEAT_VERSION-linux-x86_64 $BLACKDUCK_HOME/filebeat \
	 && chmod g+wx $BLACKDUCK_HOME/filebeat

COPY filebeat.yml $BLACKDUCK_HOME/filebeat/filebeat.yml
RUN chmod 644 $BLACKDUCK_HOME/filebeat/filebeat.yml 

VOLUME [ "$SOLR_HOME/cores.data" ]
USER solr
