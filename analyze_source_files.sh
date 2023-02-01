#!/bin/bash

# This script verifies user supplied scripts for a source using pyflakes and pytest.

# Exit on error
set -e

source ./get_env_vars.sh

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
