#!/bin/bash
# Exit on error
set -e

# Use source_data folder as cwd
cd /workspace/automation/source_data/

# Extract team name from repo name
repoName="$REPO_NAME"
prefix="/"a
suffix="-iac"
teamName=${repoName#"$prefix"}
TEAM_NAME=${teamName%"$suffix"}
echo "## Using team name: $TEAM_NAME"

# Store variable team name in workspace to persist data between steps
echo "$TEAM_NAME" >/workspace/team_name.txt

# Get folder name from TRIGGER_NAME
FOLDER_NAME=${TRIGGER_NAME//cloud-build-pr-/}

# Build and push docker images for each source folder
cd $FOLDER_NAME
# Create docker file
echo $'FROM europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/base-image:latest\nCOPY . ./plugins' >Dockerfile

echo "## Building image for: ${FOLDER_NAME}"
set +e
docker build . -t europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$TEAM_NAME/$FOLDER_NAME:latest
docker_build_ret=$?
set -e
if [ $docker_build_ret -ne 0 ]; then exit $docker_build_ret; fi


echo "## Pushing image: ${f}"
set +e
docker push europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$TEAM_NAME/$FOLDER_NAME:latest
docker_push_ret=$?
set -e
if [ $docker_push_ret -ne 0 ]; then exit $docker_push_ret; fi
