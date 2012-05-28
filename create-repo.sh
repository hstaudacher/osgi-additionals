#!/bin/sh
                
usage() {
  echo "Usage:"
  echo "  $0 <runtime-dir>"
}

fail() {
  echo Composite Repository Tool
  if [ $# -gt 0 ]; then
    echo "Error: $1"
  fi
  usage
  exit 1
}

if [ -z "$1" ]; then
  fail "Missing runtime dir, must point to an Eclipse installation"
fi

if [ ! -d "$1/plugins" ]; then
  fail "Invalid RUNTIME_DIR: $1, must point to an Eclipse installation"
fi    

# Find Equinox launcher
launcher=$1/plugins/`ls -1 $1/plugins 2> /dev/null | grep launcher_ | tail -n 1`
echo "Using Equinox launcher: $launcher"
         
echo 'Clearing old repository'
rm -rf artifacts.jar
rm -rf content.jar   
         
current_dir=`pwd`
echo 'Create p2 repository from plugins folder'
java -jar $launcher \
   -application org.eclipse.equinox.p2.publisher.FeaturesAndBundlesPublisher \
   -metadataRepository file:$current_dir \
   -artifactRepository file:$current_dir \
   -source $current_dir \
   -configs ANY \
   -compress \
   -publishArtifacts \
   || fail