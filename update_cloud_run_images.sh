#!/bin/bash

# Deploys the last version of the source image to cloud run.

# Exit on error
set -e

sh /workspace/dapla-source-data-processor-build-scripts/get_env_vars.sh

# Update image used by every cloud run for source_folder.
cd /workspace/automation/source_data/$FOLDER_NAME
echo "## Updating image used by cloud run for: ${FOLDER_NAME}"

set +e
gcloud run deploy source-$FOLDER_NAME-processor --image europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$TEAM_NAME/$FOLDER_NAME:latest --region europe-north1
gcloud_ret=$?
set -e
if [ $gcloud_ret -ne 0 ]; then exit $gcloud_ret; fi
