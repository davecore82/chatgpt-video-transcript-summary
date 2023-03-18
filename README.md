# YouTube Transcript Summarizer

This Python script uses the ChatGPT API to create summaries of YouTube video transcripts. The level of detail in the summary can be adjusted by setting the verbosity level. The script downloads a video transcript, splits it into chunks, and processes each chunk with ChatGPT to generate a summarized version.

## Usage

```bash
python3 summarize_transcript.py --youtube-id YOUTUBE_ID --language LANGUAGE --verbose VERBOSITY_LEVEL
```

- Replace `YOUTUBE_ID` with the ID of the YouTube video you want to summarize.
- Replace `LANGUAGE` with the language code of the video's transcript (e.g., "en" for English or "fr" for French).
- Replace `VERBOSITY_LEVEL` with an integer (1, 2, or 3) to set the level of detail in the summary.

## Example

```bash
python3 summarize_transcript.py --youtube-id dQw4w9WgXcQ --language en --verbose 1
```

This command will generate a summary of the transcript for the YouTube video with ID "dQw4w9WgXcQ" in English, with verbosity level 1 (the least detailed summary).
