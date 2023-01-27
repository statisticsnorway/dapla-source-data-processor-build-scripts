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

# Install test requirements
cd /workspace/dapla-source-data-processor-build-scripts/tests
python -m pip install -r requirements.txt
# Run pytests
pytest
echo " ## No errors found by pytest"

cd /workspace/automation/source_data/
# Check code with pyflakes
for f in ${source_folders[@]}; do
  cd $f
  echo "## Checking code with pyflakes: ${f}"
  pyflakes $psd
  echo " ## No errors found by pyflakes"
  cd ..
done
