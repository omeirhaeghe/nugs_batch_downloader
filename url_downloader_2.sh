#!/bin/bash

# Check if file argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <url_list_file>"
    echo "Example: $0 urls.txt"
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found!"
    exit 1
fi

# Check if ./main exists and is executable
if [ ! -x "./main" ]; then
    echo "Error: './main' not found or not executable!"
    echo "Make sure the 'main' executable is in the current directory."
    exit 1
fi

URL_FILE="$1"
TOTAL_URLS=$(wc -l < "$URL_FILE")
CURRENT=1

echo "Starting download of $TOTAL_URLS URLs from '$URL_FILE'"
echo "----------------------------------------"

# Read the file line by line
while IFS= read -r url; do
    # Trim whitespace from the line
    url=$(echo "$url" | xargs)
    
    # Skip empty lines and lines starting with #
    if [[ -z "$url" || "$url" == \#* ]]; then
        continue
    fi
    
    echo "[$CURRENT/$TOTAL_URLS] Downloading: $url"
    
    # Execute the download command
    if ./main "$url"; then
        echo "✓ Success: $url"
    else
        echo "✗ Failed: $url (Exit code: $?)"
    fi
    
    echo "----------------------------------------"
    ((CURRENT++))
    
    # Optional: Add a small delay between downloads
    # sleep 1
    
done < "$URL_FILE"

echo "Download process completed!"