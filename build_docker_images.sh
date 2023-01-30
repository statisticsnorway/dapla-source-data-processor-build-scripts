#!/bin/bash
# Exit on error
set -e

./get_env_vars.sh

# Build and push docker images for each source folder
cd /workspace/automation/source_data/$FOLDER_NAME
# Create docker file
echo $'FROM europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/base-image:latest\nCOPY . ./plugins' >Dockerfile

echo "## Building image for: ${FOLDER_NAME}"
set +e
docker build . -t europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$TEAM_NAME/$FOLDER_NAME:latest
docker_build_ret=$?
set -e
if [ $docker_build_ret -ne 0 ]; then exit $docker_build_ret; fi


echo "## Pushing image: ${FOLDER_NAME}"
set +e
docker push europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$TEAM_NAME/$FOLDER_NAME:latest
docker_push_ret=$?
set -e
if [ $docker_push_ret -ne 0 ]; then exit $docker_push_ret; fi
