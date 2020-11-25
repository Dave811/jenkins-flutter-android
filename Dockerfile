FROM thyrlian/android-sdk:latest

# Info
LABEL maintainer="d.hasshoff97@gmail.com"
LABEL description="A Docker Image to build and run Flutter on Jenkins in Unraid"

# Root user
USER root

# Upgrade to latest
RUN apt update -y && apt upgrade -y

# JAVA
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8

# Install dependencies
RUN apt install -y git wget unzip gnupg2 systemd supervisor bash curl file xz-utils zip openjdk-8-jdk

# Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter upgrade
RUN flutter precache
RUN flutter doctor

# Jenkins
RUN mkdir -p /home/jenkins/
RUN cd /home/jenkins
ARG JENKINS_VERSION=2.249.3
RUN wget https://get.jenkins.io/war-stable/${JENKINS_VERSION}/jenkins.war

# Add Files for Supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY start.sh /home/jenkins/start.sh

EXPOSE 8080

CMD ["/usr/bin/supervisord"]