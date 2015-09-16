#!/bin/bash

# directory containing this script
PROJECT_DIR=$(cd $(dirname $0) ; pwd)

EXTENSION_SRC=$PROJECT_DIR/xwalk-echo-extension-src
APP_SRC=$PROJECT_DIR/xwalk-echo-app

# get Ivy
if [ ! -f $EXTENSION_SRC/tools/ivy-2.4.0.jar ] ; then
  echo
  echo "********* DOWNLOADING IVY..."
  echo
  wget http://www.mirrorservice.org/sites/ftp.apache.org/ant/ivy/2.4.0/apache-ivy-2.4.0-bin.zip
  mv apache-ivy-2.4.0-bin.zip $EXTENSION_SRC/tools
  cd $EXTENSION_SRC/tools
  unzip apache-ivy-2.4.0-bin.zip
  mv apache-ivy-2.4.0/ivy-2.4.0.jar .
fi

# build the extension
echo
echo "********* BUILDING EXTENSION..."
echo
cd $EXTENSION_SRC
ant

# location of Crosswalk Android (downloaded during extension build)
XWALK_DIR=$EXTENSION_SRC/lib/`ls lib/ | grep 'crosswalk-'`

# build the apks
echo
echo "********* BUILDING ANDROID APK FILES..."
cd $XWALK_DIR
python make_apk.py --fullscreen --enable-remote-debugging --manifest=$APP_SRC/manifest.json --extensions=$EXTENSION_SRC/xwalk-echo-extension/ --package=org.crosswalkproject.sample

# back to where we started
cd $PROJECT_DIR
