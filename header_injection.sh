#!/bin/bash
# Check if the correct number of arguments is provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <author_name> <company_name> <date> <project_name>"
    echo "Example: $0 \"John Doe\" \"Your Company Name\" \"14/08/24\" \"MyProject\""
    exit 1
fi
# Arguments
author_name="$1"
company_name="$2"
date="$3"
project_name="$4"
# Set the root directory (current directory by default)
root_directory="./"
file_extensions=("*.swift" "*.h" "*.m")
# Declare the copyright text directly in the script, using placeholders
copyright="//
//  FileName
//  $project_name
//
//  Created by $author_name on $date.
//  Copyright © $(date +%Y) $company_name. All rights reserved.
//
"
# Find all files with the specified extensions
find "$root_directory" -type f \( -name "${file_extensions[0]}" -o -name "${file_extensions[1]}" -o -name "${file_extensions[2]}" \) | while IFS= read -r file; do
    filename=$(basename "$file")
    # Replace FileName in copyright text with the actual filename
    copyright_text="${copyright//FileName/$filename}"
    # Save the original content
    content=$(<"$file")
    # Write the copyright text followed by the original content
    {
        echo "$copyright_text"
        echo "$content"
    } > "$file"
done