#!/bin/bash

check=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
while [ check=="No such file or directory" ]; do
  echo 'Waiting for Jenkins to start ...'
  sleep 1000
done
echo 'Jenkins started.'

# Start server.
echo 'Get Secret...'
cat /var/lib/jenkins/secrets/initialAdminPassword
