#!/bin/bash
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOGSEARCH_SERVER_PATH=/usr/lib/ambari-logsearch-portal
LOGFEEDER_PATH=/usr/lib/ambari-logsearch-logfeeder
SOLR_LOCATION=/usr/lib/ambari-infra-solr
ZKCLI=$SOLR_SERVER_LOCATION/server/scripts/cloud-scripts/zkcli.sh

command="$1"

function create_configs() {
  cp -r /root/config/solr/solr.xml /root/logsearch_solr_index/data/
  cp -r /root/config/solr/zoo.cfg /root/logsearch_solr_index/data/

  rm -rf /etc/ambari-logsearch-portal/conf/solr_configsets/hadoop_logs
  rm -rf /etc/ambari-logsearch-portal/conf/solr_configsets/audit_logs
  rm -rf /etc/ambari-logsearch-portal/conf/solr_configsets/history

  cp -r /root/config/solr/config_sets/hadoop_logs /etc/ambari-logsearch-portal/conf/solr_configsets/
  cp -r /root/config/solr/config_sets/audit_logs /etc/ambari-logsearch-portal/conf/solr_configsets/
  cp -r /root/config/solr/config_sets/history /etc/ambari-logsearch-portal/conf/solr_configsets/

  cp /root/config/logsearch/HadoopServiceConfig.json /etc/ambari-logsearch-portal/conf/
  cp /root/config/logsearch/schema_fields.json /usr/lib/ambari-logsearch-portal/classes/webapps/app/static/schema_fields.json
  cp /root/config/logfeeder/grok-patterns /usr/lib/ambari-logsearch-logfeeder/classes/
}

function start_solr() {
  echo "Starting Solr..."
  /root/solr-$SOLR_VERSION/bin/solr start -cloud -s /root/logsearch_solr_index/data -verbose
  #/root/solr-$SOLR_VERSION/bin/solr start -cloud -s /root/logsearch_solr_index/data -verbose -force
  touch /var/log/ambari-logsearch-solr/solr.log
}

function start_logsearch() {
  $LOGSEARCH_SERVER_PATH/run.sh
  touch /var/log/ambari-logsearch-portal/logsearch-app.log
}

function start_logfeeder() {
  $LOGFEEDER_PATH/run.sh
  touch /var/log/ambari-logsearch-logfeeder/logsearch-logfeeder.log
}

function log() {
  component_log=${COMPONENT_LOG:-"logsearch"}
  case $component_log in
    "logfeeder")
      tail -f /var/log/ambari-logsearch-logfeeder/logsearch-logfeeder.log
     ;;
    "solr")
      tail -f /var/log/ambari-logsearch-solr/solr.log
     ;;
     *)
      tail -f /var/log/ambari-logsearch-portal/logsearch-app.log
     ;;
  esac
}

create_configs
start_solr
start_logsearch
start_logfeeder
log
