#!/bin/bash

# Check if the number of arguments provided is correct
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory_path> <file_pattern>"
    exit 1
fi

# Extract directory path and file pattern from command line arguments
directory_path="$1"
file_pattern="$2"

# Count the number of files matching the pattern in the directory (excluding .done files)
file_count=$(find "$directory_path" -maxdepth 1 -type f ! -name '*.done' -name "$file_pattern" | wc -l)

# Change directory to the specified path
# cd "$directory_path" || exit
# Count the number of files matching the pattern in the directory (excluding .done files)
# file_count=$(ls -1 "$file_pattern" 2>/dev/null | grep -v "\.done$" | wc -l)


# Check if the file count is not exactly 1
if [ "$file_count" -ne 1 ]; then
    echo "Error: Expected 1 file matching pattern '$file_pattern' (excluding .done files) in directory '$directory_path', but found $file_count files."
    exit 1
fi

echo "Success: Found 1 file matching pattern '$file_pattern' (excluding .done files) in directory '$directory_path'."
