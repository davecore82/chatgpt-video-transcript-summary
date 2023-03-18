#!/bin/bash

set -euo pipefail

# Default language
LANGUAGE="en"

# Parse arguments
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -l|--language)
        LANGUAGE="$2"
        shift 2
        ;;
        *)
        YOUTUBEID="$1"
        shift
        ;;
    esac
done

# Check if YouTube ID argument is provided
if [[ -z "${YOUTUBEID+x}" ]]; then
  echo "Error: You need to provide the YouTube ID."
  exit 1
fi

# Set variables
FILE="/tmp/transcript.txt"
OUTPUT_FILE="/tmp/chatgpt-output.txt"
CHUNK_SIZE=15500
COUNTER=1

# Clean up previous output and temporary files
rm -f "$OUTPUT_FILE"
rm -f /tmp/x??

# Download transcript and split into chunks
youtube_transcript_api --language "$LANGUAGE" --format text "$YOUTUBEID" > "$FILE"
cd /tmp
split -b "$CHUNK_SIZE" "$FILE"

# Process each chunk with ChatGPT and append to output file
for file in /tmp/x??
do
    echo "CHUNK $COUNTER" >> "$OUTPUT_FILE"
    chatgpt "give me a comprehensive summary including any important details of the following transcript: $(cat "$file")" >> "$OUTPUT_FILE"
    ((COUNTER+=1))
done

# Clean up temporary files
rm -f /tmp/x??

# Open output file in TextEdit (Mac-specific)
if command -v open >/dev/null; then
    open -a TextEdit "$OUTPUT_FILE"
fi

