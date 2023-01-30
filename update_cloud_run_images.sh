#!/bin/bash
# Exit on error
set -e

# Use source_data folder as cwd
cd /workspace/automation/source_data/

# Read team name from workspace
# https://cloud.google.com/build/docs/configuring-builds/pass-data-between-steps
TEAM_NAME=$(cat /workspace/team_name.txt)
echo "## Using team name: $TEAM_NAME"

# Get folder name from TRIGGER_NAME
FOLDER_NAME=${TRIGGER_NAME//cloud-build-pr-/}

# Update image used by every cloud run for source_folder.
cd $FOLDER_NAME
echo "## Updating image used by cloud run for: ${FOLDER_NAME}"

set +e
gcloud run deploy source-$f-processor --image europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$TEAM_NAME/$FOLDER_NAME:latest --region europe-north1
gcloud_ret=$?
set -e
if [ $gcloud_ret -ne 0 ]; then exit $gcloud_ret; fi
