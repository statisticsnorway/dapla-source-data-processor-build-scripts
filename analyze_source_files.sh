#!/bin/bash

# This script verifies user supplied scripts for a source using pyflakes and pytest.

# Exit on error
set -e

# Fetch environment variables form disk
export FOLDER_NAME=$(cat /workspace/FOLDER_NAME.txt)
export TEAM_NAME=$(cat /workspace/TEAM_NAME.txt)

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
