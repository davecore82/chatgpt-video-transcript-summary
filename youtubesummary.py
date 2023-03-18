import argparse
import textwrap
from youtube_transcript_api import YouTubeTranscriptApi
from chatgpt_wrapper import ChatGPT

# Parse arguments
parser = argparse.ArgumentParser()
parser.add_argument("-y", "--youtube-id", nargs='?', default="uorqgTk0C2o", help="YouTube ID")
parser.add_argument("-l", "--language", default="en", help="Language")
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
    input_text = f"give me a comprehensive summary including any important details of the following transcript: {chunk}"
    success, response, message = bot.ask(input_text)
    if success:
        output += response
    else:
        raise RuntimeError(message)
    counter += 1

print(output)
