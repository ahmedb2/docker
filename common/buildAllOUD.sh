#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: buildAll.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2018.03.13
# Revision...:  
# Purpose....: Build script to build all oehrlis/xxx docker images
# Notes......: 
# Reference..: --
# License....: Licensed under the Universal Permissive License v 1.0 as 
#              shown at http://oss.oracle.com/licenses/upl.
# -----------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# -----------------------------------------------------------------------------

# - Customization -----------------------------------------------------------at ses
# - End of Customization ----------------------------------------------------

# - Default Values ----------------------------------------------------------

DOCKER_BUILD_DIR="$(cd $(dirname $0)/.. 2>&1 >/dev/null; pwd -P)"
echo "--------------------------------------------------------------------------------"
echo " Build all image from $DOCKER_BUILD_DIR...."
orarepo_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' orarepo)

# get the latest oraclelinux slim image
docker pull oraclelinux:7-slim

# send build trigger to trivadisbds
#echo "### Send build trigger to trivadisbds ##########################################"
#curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "11.1.2.3.180116"}' -X POST https://registry.hub.docker.com/u/trivadisbds/oud/trigger/0266ebf2-cac2-414e-a1af-f6de992d7708/
#curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "12.2.1.3.180322"}' -X POST https://registry.hub.docker.com/u/trivadisbds/oud/trigger/0266ebf2-cac2-414e-a1af-f6de992d7708/
#curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "12.2.1.3.180417"}' -X POST https://registry.hub.docker.com/u/trivadisbds/oudsm/trigger/92f5b20b-4d03-4902-91e8-09ba8aaba04e/
#curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "11.1.1.7.171017"}' -X POST https://registry.hub.docker.com/u/trivadisbds/odsee/trigger/362c8a54-e5f7-43df-8e64-0dee4b4ca70c/

# first build java
# echo "--------------------------------------------------------------------------------"
# echo "### Build Java #################################################################"
# cd $DOCKER_BUILD_DIR/OracleJava
# time $DOCKER_BUILD_DIR/OracleJava/java-8/build.sh

# build ODSEE
# echo "### Build ODSEE ################################################################"
# cd $DOCKER_BUILD_DIR/OracleODSEE/11.1.1.7.0
# docker rmi oracle/odsee:11.1.1.7.0
# time docker build --add-host=orarepo:${orarepo_ip} -t oracle/odsee:11.1.1.7.181016 .

# build OUD 11.1.2.3.0
echo "### Build OUD 11.1.2.3.0 #######################################################"
cd $DOCKER_BUILD_DIR/OracleOUD/11.1.2.3.0
time docker build --add-host=orarepo:${orarepo_ip} -t oracle/oud:11.1.2.3.181016 .

echo "### Build OUD 12.2.1.3.0 #######################################################"
cd $DOCKER_BUILD_DIR/OracleOUD/12.2.1.3.0
time docker build --add-host=orarepo:${orarepo_ip} -t oracle/oud:12.2.1.3.180829 .
docker image prune --force


# build OUD Containers
# cd $DOCKER_BUILD_DIR/OracleOUD
# for version in 1?.?.?.?; do
#     echo "### Build $version #######################################################"
#     cd $DOCKER_BUILD_DIR/OracleDatabase/$version
#     time docker build --add-host=orarepo:${orarepo_ip} --force-rm --no-cache -t oracle/database:$version .
#     docker image prune --force
# done
# build OUDSM
# echo "### Build OUDSM 12.2.1.3.0 #####################################################"
# cd $DOCKER_BUILD_DIR/OracleOUDSM/12.2.1.3.0
# time docker build --add-host=orarepo:${orarepo_ip} -t oracle/oudsm:12.2.1.3.181016 .
# docker image prune --force