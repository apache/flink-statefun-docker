#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This file was taken from Apache Flink, and modified to include another entry point

# Start/stop a Flink JobManager.
USAGE="Usage: standalone-job.sh ((start|start-foreground))|stop [args]"

STARTSTOP=$1
ENTRY_POINT_NAME="statefun"

if [[ $STARTSTOP != "start" ]] && [[ $STARTSTOP != "start-foreground" ]] && [[ $STARTSTOP != "stop" ]]; then
  echo $USAGE
  exit 1
fi

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. "$bin"/config.sh

# Startup parameters
ARGS=("--configDir" "${FLINK_CONF_DIR}" "${@:2}")

if [[ $STARTSTOP == "start" ]] || [[ $STARTSTOP == "start-foreground" ]]; then
    # Add cluster entry point specific JVM options
    export FLINK_ENV_JAVA_OPTS="${FLINK_ENV_JAVA_OPTS} ${FLINK_ENV_JAVA_OPTS_JM}"
    parseJmJvmArgsAndExportLogs "${ARGS[@]}"
fi

if [[ $STARTSTOP == "start-foreground" ]]; then
    exec "${FLINK_BIN_DIR}"/flink-console.sh ${ENTRY_POINT_NAME} "${ARGS[@]}"
else
    "${FLINK_BIN_DIR}"/flink-daemon.sh ${STARTSTOP} ${ENTRY_POINT_NAME} "${ARGS[@]}"
fi
