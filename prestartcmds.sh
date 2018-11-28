#!/bin/sh
set -e

# ensure that there is no pre-existing lock file before starting
rm -f "$SOLR_HOME/cores.data/project/index/write.lock"
