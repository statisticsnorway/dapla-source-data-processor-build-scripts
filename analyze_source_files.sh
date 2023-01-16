#!/bin/bash
# Exit on error
set -e
# Folders to exclude
EX1="pipelines"

# Use source_data folder as cwd
cd /workspace/automation/source_data/

# Array of files/folders in dir
list_dir=(*)

declare -a source_folders
for f in ${list_dir[@]}; do
    # Filter out EX1, EX2 and files from list_dir
    if [ -d "$f" ] && [ "$f" != "$EX1" ] ; then
        cd $f
        echo "## Found source folder: ${f}"
        # Add source folders to array
        source_folders+=("$f")
        cd ..
    fi
done

# Save array to workspace to persist data between steps
# https://cloud.google.com/build/docs/configuring-builds/pass-data-between-steps
printf "%s\n" "${source_folders[@]}" > /workspace/source_folders.txt


# Extract team name from repo name
repoName="$REPO_NAME"
prefix="/"a
suffix="-iac"
teamName=${repoName#"$prefix"}
teamName=${teamName%"$suffix"}
echo "## Using team name: $teamName"

# Store variable team name in workspace to persist data between steps
echo $teamName > /workspace/team_name.txt &&


# Install test requirements
cd pipelines/tests
python -m pip install -r requirements.txt
# Run pytests
pytest
echo " ## No errors found by pytest"
cd ../..

# Check code with pyflakes
for f in ${source_folders[@]}; do
  cd $f
    echo "## Checking code with pyflakes: ${f}"
    pyflakes $psd
    echo " ## No errors found by pyflakes"
  cd ..
done