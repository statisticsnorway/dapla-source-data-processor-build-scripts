#!/bin/bash
# Exit on error
set -e

# Use source_data folder as cwd
cd /workspace/automation/source_data/

# Read source_folder array from workspace
readarray -t source_folders < /workspace/source_folders.txt

# Use source_data folder as cwd
cd /workspace/automation/source_data/

# Read team name from workspace
# https://cloud.google.com/build/docs/configuring-builds/pass-data-between-steps
teamName=$(cat /workspace/team_name.txt)
echo "Using team name: $teamName"

# Build and push docker images for each source folder
for f in ${source_folders[@]}; do
  cd $f
  # Create docker file
  echo $'FROM europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/base-image:latest\nCOPY . ./plugins' > Dockerfile
  echo "## Building image for: ${f}"
  echo $(docker build . -t europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$teamName/$f:latest)
  echo "## Pushing image: ${f}"
  echo $(docker push europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$teamName/$f:latest)
  cd ..
done

