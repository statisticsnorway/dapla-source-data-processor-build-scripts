
CHANGED_FILES=$(git diff --name-only main -- automation/source_data/)

# Check if the variable CHANGED_FILES is not empty
if [ "$(git branch --show-current)" == "main" ]; then
  echo "Running on main."
  echo "should_run_fetch_sources=true"
elif [ -z "$CHANGED_FILES" ]; then
  echo "Error: No changes detected in automation/source_data/ compared to main branch."
  echo "should_run_fetch_sources=false"
else
  echo "Changes detected in automation/source_data/"
  echo "should_run_fetch_sources=true"
fi