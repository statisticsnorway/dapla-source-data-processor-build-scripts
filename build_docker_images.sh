#!/bin/bash
# Exit on error
set -e

# Use source_data folder as cwd
cd /workspace/automation/source_data/

# Array of files/folders in dir
list_dir=(*)

declare -a source_folders
for f in ${list_dir[@]}; do
  if [ -d "$f" ]; then
    cd $f
    echo "## Found source folder: ${f}"
    # Add source folders to array
    source_folders+=("$f")
    cd ..
  fi
done

# Extract team name from repo name
repoName="$REPO_NAME"
prefix="/"a
suffix="-iac"
teamName=${repoName#"$prefix"}
teamName=${teamName%"$suffix"}
echo "## Using team name: $teamName"

# Build and push docker images for each source folder
for f in ${source_folders[@]}; do
  cd $f
  # Create docker file
  echo $'FROM europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/base-image:latest\nCOPY . ./plugins' >Dockerfile
  echo "## Building image for: ${f}"
  echo $(docker build . -t europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$teamName/$f:latest)
  echo "## Pushing image: ${f}"
  echo $(docker push europe-north1-docker.pkg.dev/artifact-registry-14da/ssb-docker/ssb/statistikktjenester/automation/source_data/$teamName/$f:latest)
  cd ..
done
