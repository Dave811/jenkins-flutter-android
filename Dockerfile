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
RUN apt install -y git wget unzip gnupg2 systemd supervisor bash curl file xz-utils zip
RUN apt install -y openjdk-8-jdk

RUN wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
RUN sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'

RUN apt update -y
RUN apt install -y jenkins
RUN systemctl enable --now jenkins

# Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
RUN chown -R jenkins:jenkins /usr/local/flutter
USER jenkins
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter doctor -v
USER root
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Add Files for Supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /home/commands/
COPY afterJenkins.sh /home/commands/afterJenkins.sh


EXPOSE 8080

CMD ["/usr/bin/supervisord"]