#!/bin/bash

set -euo pipefail

# Check if YouTube ID argument is provided
if [[ $# -eq 0 ]]; then
  echo "Error: You need to provide the YouTube ID."
  exit 1
fi

# Set variables
YOUTUBEID="$1"
FILE="/tmp/transcript.txt"
OUTPUT_FILE="/tmp/chatgpt-output.txt"
CHUNK_SIZE=15500
COUNTER=1

# Clean up previous output and temporary files
rm -f "$OUTPUT_FILE"
rm -f /tmp/x??

# Download transcript and split into chunks
youtube_transcript_api --format text "$YOUTUBEID" > "$FILE"
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

