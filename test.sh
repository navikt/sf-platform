#! /bin/bash
# Read the current sfdx-project.json
input_file="sfdx-project.json"
PACKAGE_NAMES="platform-data-model,platform-data-model-2,custom-metadata-dao,feature-toggle"
NEXT="NEXT"
LATEST="LATEST"

# Validate inputs
if [ -z "$PACKAGE_NAMES" ]; then
  echo "::error::Package names are required"
  exit 1
fi

# Split the package names into an array
IFS=',' read -ra PACKAGE_NAMES_ARRAY <<< "$PACKAGE_NAMES"
# Check if the package names are valid
if [ ${#PACKAGE_NAMES_ARRAY[@]} -eq 0 ]; then
  echo "::error::No valid package names provided"
  exit 1
fi

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "::error::Input file $input_file does not exist"
  exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "::error::jq is not installed. Please install jq to run this action."
  exit 1
fi

# Loop through each package name and update the version
for PACKAGE_NAME in "${PACKAGE_NAMES_ARRAY[@]}"; do
  # Check if the package exists in the sfdx-project.json
  if ! jq -e --arg pkg "$PACKAGE_NAME" '.packageDirectories[] | select(.package == $pkg)' "$input_file" > /dev/null; then
    echo "::error::Package $PACKAGE_NAME not found in $input_file"
    continue;
  fi

  version_number=$(jq -r --arg pkg "$PACKAGE_NAME" '(.packageDirectories[] | select(.package == $pkg) | .versionNumber)' "$input_file")

  IFS='.' read -r major minor patch build <<< "$version_number"

  patch=$((patch + 1))
  
  version_number="$major.$minor.$patch"
  
  if [ -z "$build" ]; then
    version_number_next="$version_number"
    dependency_version_number="$version_number"
  else
    version_number_next="$version_number.$NEXT"
    dependency_version_number="$version_number.$LATEST"
  fi

  # Update versionNumber for the specified package
  jq --arg pkg "$PACKAGE_NAME" --arg ver "$version_number_next" --arg dep_ver "$dependency_version_number" \
    '(.packageDirectories[] | select(.package == $pkg) | .versionNumber) |= $ver | 
    (.packageDirectories[].dependencies?[]? | select(.package == $pkg) | .versionNumber) |= $dep_ver' \
    "$input_file" > tmp.json && mv tmp.json "$input_file"
  echo "Updated versionNumber for package $PACKAGE_NAME to $version_number_next in $input_file"
done