#!/bin/bash

# Check if the directory is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Get the target directory and convert it to an absolute path
TARGET_DIR="$(realpath "$1")"

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# Output file
OUTPUT_FILE="checksums.txt"

# Clear the output file if it already exists
> "$OUTPUT_FILE"

# Function to calculate SHA-256 checksum for eligible files
calculate_sha256sum() {
    find "$1" -type f ! -path "*/.*" ! -name "*.sh" ! -name "checksums.txt" | while read -r file; do
        checksum=$(sha256sum "$file" | awk '{print $1}')
        relative_path="${file#$1/}"
        
        # Print to terminal
        echo "File: $relative_path"
        echo "SHA256: $checksum"
        echo

        # Save to output file
        echo "$relative_path" >> "$OUTPUT_FILE"
        echo "$checksum" >> "$OUTPUT_FILE"
        echo >> "$OUTPUT_FILE"
    done
}

# Run the function
echo "Calculating SHA-256 checksums for eligible files in '$TARGET_DIR':"
calculate_sha256sum "$TARGET_DIR"

echo "Checksums saved to '$OUTPUT_FILE'."

exit 0
