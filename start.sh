#!/bin/bash

flutter upgrade
flutter precache
flutter doctor

java -jar jenkins.war