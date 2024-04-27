import anthropic
import os

def read_api_key(key):
    file_path = os.path.join(os.path.expanduser("~"), "." + key)
    try:
        with open(file_path, "r") as file:
            content = file.read().strip()
            return content
    except FileNotFoundError:
        return ""

anthropic_key = read_api_key("anthropic")
openai_key = read_api_key("openai")

client = anthropic.Anthropic(
    api_key=anthropic_key,
)

with client.messages.stream(
    max_tokens=1024,
    messages=[{"role": "user", "content": "Write hello world in java"}],
    model="claude-3-opus-20240229",
) as stream:
  for text in stream.text_stream:
      print(text, end="", flush=True)
