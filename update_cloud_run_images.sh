#!/bin/bash

# Deploys the last version of the source image to cloud run.

# Exit on error
set -e

echo "## Updating image used by cloud run for: ${FOLDER_NAME} in environment:${ENV_NAME}"

set +e
gcloud run deploy $PROCESSOR_NAME --image europe-north1-docker.pkg.dev/artifact-registry-5n/ssb-docker/ssb/statistikktjenester/automation/source_data/$TEAM_NAME/$FOLDER_NAME:$ENV_NAME --region europe-north1 --project $PROJECT_ID
gcloud_ret=$?
set -e
if [ $gcloud_ret -ne 0 ]; then exit $gcloud_ret; fi
