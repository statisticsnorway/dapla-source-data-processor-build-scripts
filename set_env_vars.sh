#!/bin/bash

# This scripts extracts technical team name and source folder name, from REPO_NAME and TRIGGER_NAME provided by cloud build.
# The respective values are stored in the environment variables TEAM_NAME and FOLDER_NAME.
# https://cloud.google.com/build/docs/configuring-builds/substitute-variable-values

# Exit on error
set -e

# Extract team name from repo name
repoName="$REPO_NAME"
prefix="/"a
suffix="-iac"
TEAM_NAME=${repoName#"$prefix"}
TEAM_NAME=${TEAM_NAME%"$suffix"}
echo "## Using team name: $TEAM_NAME"

# Get folder name from TRIGGER_NAME
if [[ "$TRIGGER_NAME" == *"pr-"* ]]; then
  FOLDER_NAME=${TRIGGER_NAME//pr-/}
fi

if [[ "$TRIGGER_NAME" == *"push-"* ]]; then
  FOLDER_NAME=${TRIGGER_NAME//push-/}
fi

echo "## Source folder: $FOLDER_NAME"

# Save variables between steps
echo $FOLDER_NAME > /workspace/FOLDER_NAME.txt
echo $TEAM_NAME > /workspace/TEAM_NAME.txt
