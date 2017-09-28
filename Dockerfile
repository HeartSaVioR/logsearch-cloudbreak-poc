#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM centos:centos6
ENV HOME /root
RUN echo root:changeme | chpasswd
RUN yum clean all -y && yum update -y
RUN yum -y install vim wget rpm-build sudo which telnet tar openssh-server openssh-clients ntp git python-setuptools python-devel httpd lsof

# download & install logsearch RPM packages
RUN wget -cqO- https://github.com/oleewere/logsearch-cloudbreak-poc/releases/download/logsearch-rpms/ambari-infra-solr-2.5.1.0-0.noarch.rpm -O ambari-infra-solr.rpm && sudo rpm -i ambari-infra-solr.rpm
RUN wget -cqO- https://github.com/oleewere/logsearch-cloudbreak-poc/releases/download/logsearch-rpms/ambari-infra-solr-client-2.5.1.0-0.noarch.rpm -O ambari-infra-solr-client.rpm && sudo rpm -i ambari-infra-solr-client.rpm
RUN wget -cqO- https://github.com/oleewere/logsearch-cloudbreak-poc/releases/download/logsearch-rpms/ambari-logsearch-logfeeder-2.5.1.0-0.noarch.rpm -O ambari-logsearch-portal.rpm && sudo rpm -i ambari-logsearch-portal.rpm
RUN wget -cqO- https://github.com/oleewere/logsearch-cloudbreak-poc/releases/download/logsearch-rpms/ambari-logsearch-portal-2.5.1.0-0.noarch.rpm -O ambari-logsearch-logfeeder.rpm && sudo rpm -i ambari-logsearch-logfeeder.rpm

# install java
ENV JAVA_VERSION 8u131
ENV BUILD_VERSION b11
RUN wget --no-check-certificate --no-cookies --header "Cookie:oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/d54c1d3a095b4ff2b6607d096fa80163/jdk-$JAVA_VERSION-linux-x64.rpm -O jdk-8-linux-x64.rpm
RUN rpm -ivh jdk-8-linux-x64.rpm
ENV JAVA_HOME /usr/java/default/
ENV PATH $PATH:$JAVA_HOME/bin

WORKDIR /root