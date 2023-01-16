#!/bin/bash
# Exit on error
set -e
# Read source_folder array from workspace
readarray -t source_folders < /workspace/source_folders.txt

# Use source_data folder as cwd
cd /workspace/automation/source_data/

# Read team name from workspace
# https://cloud.google.com/build/docs/configuring-builds/pass-data-between-steps
teamName=$(cat /workspace/team_name.txt)
echo "## Using team name: $teamName"

# Update image used by every cloud run instance.
for f in ${source_folders[@]}; do
  cd $f
    echo "## Updating image used by cloud run for: ${f}"
    echo $(gcloud run deploy source-$f-processor --image europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$teamName/$f:latest --region europe-north1)
  cd ..
done
