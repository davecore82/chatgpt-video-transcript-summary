#!/bin/bash

set -euo pipefail # enable strict error handling

readonly FILE="transcript.txt"
readonly OUTPUT_FILE="chatgpt-output.txt"
readonly NO_TIMESTAMP_FILE="transcript-no-timestamps.txt"
readonly CHUNK_SIZE=12000

if [ ! -f "$FILE" ]; then
    echo "Error: File $FILE not found!" >&2
    exit 1
fi

# remove output file if it exists
if [ -f "$OUTPUT_FILE" ]; then
    rm -f "$OUTPUT_FILE"
fi

# remove temporary files if they exist
trap 'rm -f "$NO_TIMESTAMP_FILE" x??' EXIT

# remove timestamp lines and split into chunks
grep -vE '^[0-9]' "$FILE" > "$NO_TIMESTAMP_FILE"
split -b "$CHUNK_SIZE" "$NO_TIMESTAMP_FILE"

# process each chunk with ChatGPT and append to output file
for i in x??
do
    chatgpt "give me a comprehensive summary including any important details of the following text: $(cat "$i")" >> "$OUTPUT_FILE"
done

# open output file in TextEdit (Mac-specific)
if command -v open >/dev/null; then
    open -a TextEdit "$OUTPUT_FILE"
fi

