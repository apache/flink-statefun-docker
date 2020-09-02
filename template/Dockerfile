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

FROM flink:%%FLINK_VERSION%%

ENV STATEFUN_VERSION=%%STATEFUN_VERSION%% \
    GPG_KEY=%%GPG_KEY%%

ENV ROLE worker
ENV MASTER_HOST localhost
ENV STATEFUN_HOME /opt/statefun
ENV STATEFUN_MODULES $STATEFUN_HOME/modules

# Cleanup flink-lib
RUN rm -fr $FLINK_HOME/lib/flink-table*jar

# Copy our distriubtion template
COPY flink-distribution/ $FLINK_HOME/

# Install Stateful Functions dependencies in Flink lib
ENV DIST_JAR_URL=https://repo.maven.apache.org/maven2/org/apache/flink/statefun-flink-distribution/${STATEFUN_VERSION}/statefun-flink-distribution-${STATEFUN_VERSION}.jar \
    DIST_ASC_URL=https://repo.maven.apache.org/maven2/org/apache/flink/statefun-flink-distribution/${STATEFUN_VERSION}/statefun-flink-distribution-${STATEFUN_VERSION}.jar.asc \
    CORE_JAR_URL=https://repo.maven.apache.org/maven2/org/apache/flink/statefun-flink-core/${STATEFUN_VERSION}/statefun-flink-core-${STATEFUN_VERSION}.jar \
    CORE_ASC_URL=https://repo.maven.apache.org/maven2/org/apache/flink/statefun-flink-core/${STATEFUN_VERSION}/statefun-flink-core-${STATEFUN_VERSION}.jar.asc

RUN set -ex; \
  wget -nv -O statefun-flink-distribution.jar "$DIST_JAR_URL"; \
  wget -nv -O statefun-flink-distribution.jar.asc "$DIST_ASC_URL"; \
  wget -nv -O statefun-flink-core.jar "$CORE_JAR_URL"; \
  wget -nv -O statefun-flink-core.jar.asc "$CORE_ASC_URL"; \
  \
  export GNUPGHOME="$(mktemp -d)"; \
  for server in ha.pool.sks-keyservers.net $(shuf -e \
                          hkp://p80.pool.sks-keyservers.net:80 \
                          keyserver.ubuntu.com \
                          hkp://keyserver.ubuntu.com:80 \
                          pgp.mit.edu) ; do \
      gpg --batch --keyserver "$server" --recv-keys "$GPG_KEY" && break || : ; \
  done && \
  gpg --batch --verify statefun-flink-distribution.jar.asc statefun-flink-distribution.jar; \
  gpg --batch --verify statefun-flink-core.jar.asc statefun-flink-core.jar; \
  gpgconf --kill all; \
  rm -rf "$GNUPGHOME" statefun-flink-distribution.jar.asc statefun-flink-core.jar.asc; \
  \
  mkdir -p $FLINK_HOME/lib; \
  mv statefun-flink-distribution.jar $FLINK_HOME/lib; \
  mv statefun-flink-core.jar $FLINK_HOME/lib;

# add user modules
USER root

RUN mkdir -p $STATEFUN_MODULES && \
    useradd --system --home-dir $STATEFUN_HOME --uid=9998 --gid=flink statefun && \
    chown -R statefun:flink $STATEFUN_HOME && \
    chmod -R g+rw $STATEFUN_HOME

# add filesystem plugins
RUN mkdir -p $FLINK_HOME/plugins/s3-fs-presto && \
    mv $FLINK_HOME/opt/flink-s3-fs-presto-%%FLINK_VERSION%%.jar $FLINK_HOME/plugins/s3-fs-presto
RUN mkdir -p $FLINK_HOME/plugins/swift-fs-hadoop && \
    mv $FLINK_HOME/opt/flink-swift-fs-hadoop-%%FLINK_VERSION%%.jar $FLINK_HOME/plugins/swift-fs-hadoop
RUN mkdir -p $FLINK_HOME/plugins/oss-fs-hadoop && \
    mv $FLINK_HOME/opt/flink-oss-fs-hadoop-%%FLINK_VERSION%%.jar $FLINK_HOME/plugins/oss-fs-hadoop
RUN mkdir -p $FLINK_HOME/plugins/azure-fs-hadoop && \
    mv $FLINK_HOME/opt/flink-azure-fs-hadoop-%%FLINK_VERSION%%.jar $FLINK_HOME/plugins/azure-fs-hadoop

# entry point 
ADD docker-entry-point.sh /docker-entry-point.sh

ENTRYPOINT ["/docker-entry-point.sh"]
