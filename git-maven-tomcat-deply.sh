#!/bin/bash
BRANCH="dev"
TODAY=$(date +"%Y-%m-%d")
PRO_NAME="mkt-admin"
GIT_HOME="/home/app/git_repo/mkt-admin"
TOMCAT_NAME="tomcat-pay-8080"
TOMCAT_HOME=/usr/local/${TOMCAT_NAME}
cd ${GIT_HOME}
git fetch
git checkout ${BRANCH}
echo "Start pull code..."
git pull
mvn clean install -Dmaven.test.skip=true -e -U
cd $TOMCAT_HOME
echo "Shutdown Tomcat..."
./bin/shutdown.sh
sleep 20
echo "Testing Tomcat status..."
TOMCAT_PID=$( ps aux | grep ${_TOMCAT_NAME} | grep -v grep | awk '{print $2}' )
echo "Get Tomcat PID: " $TOMCAT_PID
if [[ ${TOMCAT_PID} ]]   # if PID exists 
then
  echo "PID exists, cannot shutdown Tomcat successfully."
  #echo "Killing..."
  #kill -9 ${_TOMCAT_PID}
  #sleep 5
  echo "Exiting..." 
  exit 1
else 
  echo "PID is not exists, ready for start."
fi
rm -rf webapps/${PRO_NAME}*
rm -rf work/*
cp ${GIT_HOME}/target/mkt-admin.war webapps/
sleep 1
echo "Start Tomcat..."
./bin/startup.sh
tailf logs/localhost.${TODAY}.log

