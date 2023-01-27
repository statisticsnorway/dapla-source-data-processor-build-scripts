#!/bin/bash
# Exit on error
set -e

# Extract team name from repo name
repoName="$REPO_NAME"
prefix="/"a
suffix="-iac"
teamName=${repoName#"$prefix"}
teamName=${teamName%"$suffix"}
echo "## Using team name: $teamName"

# Get folder name from TRIGGER_NAME
FOLDER_NAME=${TRIGGER_NAME//cloud-build-pr-/}

# Install test requirements
cd /workspace/dapla-source-data-processor-build-scripts/tests
python -m pip install -r requirements.txt
# Run pytests
pytest
echo " ## No errors found by pytest"

# Check code with pyflakes
cd /workspace/automation/source_data/$FOLDER_NAME
echo "## Checking code with pyflakes: ${FOLDER_NAME}"
pyflakes process_source_data.py
echo " ## No errors found by pyflakes"
