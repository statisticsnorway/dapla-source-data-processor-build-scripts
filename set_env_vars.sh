# Extract team name from repo name
repoName="$REPO_NAME"
prefix="/"a
suffix="-iac"
TEAM_NAME=${repoName#"$prefix"}
TEAM_NAME=${TEAM_NAME%"$suffix"}
echo "## Using team name: $TEAM_NAME"

# Get folder name from TRIGGER_NAME
FOLDER_NAME=${TRIGGER_NAME//cloud-build-pr-/}
echo "## Source folder: $FOLDER_NAME"
