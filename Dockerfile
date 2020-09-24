# Copyright 2020 EPAM Systems.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM epamedp/edp-jenkins-base-agent:1.0.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV MAVEN_VERSION=3.6.3
ENV PATH=$PATH:/opt/apache-maven-${MAVEN_VERSION}/bin

USER root

RUN yum remove -y java-11-openjdk-headless.x86_64 && \
    yum install -y java-1.8.0-openjdk-devel.x86_64 && \
    yum clean all -y

# Install Maven
RUN curl -L --output /tmp/apache-maven-bin.zip https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip && \
    unzip -q /tmp/apache-maven-bin.zip -d /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven && \
    rm /tmp/apache-maven-bin.zip

WORKDIR $HOME/.m2

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable
COPY contrib/bin/configure-agent /usr/local/bin/configure-agent
COPY ./contrib/settings.xml $HOME/.m2/

RUN chown -R "1001:0" "$HOME" && \
    chmod -R "g+rw" "$HOME"

USER 1001