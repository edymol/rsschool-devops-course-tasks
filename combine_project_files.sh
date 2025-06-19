#!/bin/bash

# Define the output file name
OUTPUT_FILE="all_project_files.txt"

# Clear the output file if it exists, or create it
> "$OUTPUT_FILE"

# Define the starting directory for the search
# THIS IS THE CRITICAL CHANGE: Start search within the 'terraform/' directory
BASE_DIR="terraform/"

echo "Starting to combine files from: $(pwd)/$BASE_DIR"

# Find files based on specific extensions and exclude others
# -type f: Only regular files
# -not -path './.terraform/*': Exclude any file/directory under ./.terraform/
# -not -name "*.tfstate": Exclude .tfstate files
# -not -name "*.tfstate.backup": Exclude .tfstate.backup files
# -not -name "*.terraform.lock.hcl": Exclude the lock file
# \( ... -o ... \): Groups multiple -name conditions with OR logic
find "$BASE_DIR" -type f \
    -not -path '*/.terraform/*' \
    -not -name "*.tfstate" \
    -not -name "*.tfstate.backup" \
    -not -name "*.terraform.lock.hcl" \
    \( -name "*.tf" -o -name "*.tfvars" -o -name "*.config" -o -name "*.sh" -o -name "*.md" \) \
    -print0 | while IFS= read -r -d $'\0' filepath; do

    # Skip the script itself and the output file to avoid self-inclusion or infinite loops
    # Using realpath to get absolute paths for comparison, more robust
    script_path=$(realpath "$0")
    output_path=$(realpath "./$OUTPUT_FILE")
    # For filepath, we need to consider its full path, which find already gives us relative to BASE_DIR
    current_filepath=$(realpath "$filepath")

    # Important: The 'filepath' from find will be like "terraform/ec2/main.tf"
    # When comparing, ensure you're not accidentally skipping the script/output file if they happen to be named
    # something similar inside a sub-directory, which is unlikely but possible.
    # The realpath comparison is the most robust for this.

    if [[ "$current_filepath" == "$script_path" ]] || [[ "$current_filepath" == "$output_path" ]]; then
        continue
    fi

    echo "--- FILE: $filepath ---" >> "$OUTPUT_FILE"
    cat "$filepath" >> "$OUTPUT_FILE"
    echo -e "\n\n" >> "$OUTPUT_FILE" # Add some space between file contents
done

echo "All specified files combined into '$OUTPUT_FILE'"
echo "Check '$OUTPUT_FILE' for content."
