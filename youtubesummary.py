#!/usr/bin/env python3

import argparse
import textwrap
from youtube_transcript_api import YouTubeTranscriptApi
from chatgpt_wrapper import ChatGPT

# Parse arguments
parser = argparse.ArgumentParser()
parser.add_argument("-y", "--youtube-id", nargs='?', default="uorqgTk0C2o", help="YouTube ID")
parser.add_argument("-l", "--language", default="en", help="Language")
parser.add_argument("-v", "--verbose", type=int, choices=[1, 2, 3], default=2, help="Verbose level (1, 2, or 3)")
args = parser.parse_args()

# Set variables
chunk_size = 15500
counter = 1
output = ""

# Download transcript and split into chunks
transcript = YouTubeTranscriptApi.get_transcript(args.youtube_id, languages=[args.language])
transcript_text = ' '.join([entry['text'] for entry in transcript])
chunks = textwrap.wrap(transcript_text, chunk_size)

bot = ChatGPT()

# Process each chunk with ChatGPT and append to output
for chunk in chunks:
    output += f"CHUNK {counter}\n"
    if args.language == "fr":
        input_text = "donne ta réponse en français, "
    # Modify input_text based on the value of args.verbose
    if args.verbose == 1:
        input_text += f"TLDR: {chunk}"
    elif args.verbose == 2:
        input_text += f"Can you provide a comprehensive summary of the given text? The summary should cover all the key points and main ideas presented in the original text, while also condensing the information into a concise and easy-to-understand format. Please ensure that the summary includes relevant details and examples that support the main ideas, while avoiding any unnecessary information or repetition. The length of the summary should be appropriate for the length and complexity of the original text, providing a clear and accurate overview without omitting any important information: {chunk}"
    elif args.verbose == 3:
        input_text += f"give me a super highly detailed bulleted list of all the details in this video transcript: {chunk}"
    print(input_text)
    success, response, message = bot.ask(input_text)
    if success:
        output += response
    else:
        raise RuntimeError(message)
    counter += 1

print(output)
