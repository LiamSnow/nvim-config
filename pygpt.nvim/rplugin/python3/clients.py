import anthropic
from openai import OpenAI

def make_clients(keys):
    return {
        "anthropic": anthropic.Anthropic(api_key=keys['anthropic']),
        "openai": OpenAI(api_key=keys['openai']),
        "perplexity": OpenAI(api_key=keys['perplexity'], base_url="https://api.perplexity.ai"),
        "deepseek": OpenAI(api_key=keys['deepseek'], base_url="https://api.deepseek.com"),
    }

def run(message, end_line, bufnr, params, self):
    match params['client']:
        case "anthropic":
            run_anthropic(message, end_line, bufnr, params, self.config['models']['anthropic'], self.clients['anthropic'], self)
        case "openai":
            run_openai(message, end_line, bufnr, params, self.config['models']['openai'], self.clients['openai'], self)
        case "perplexity":
            run_perplexity(message, end_line, bufnr, params, self.config['models']['perplexity'], self.clients['perplexity'], self)
        case "deepseek":
            run_openai(message, end_line, bufnr, params, self.config['models']['deepseek'], self.clients['deepseek'], self)
        case _:
            bufnr.append(f"Invalid client: {params['client']}")

def run_anthropic(message, end_line, bufnr, params, model, client, self):
    try:
        self.stream_cancelled = False
        with client.messages.stream(
            max_tokens=params['max_tokens'],
            system=params['system'],
            temperature=params['temperature'],
            messages=[
                {"role": "user", "content": message}
            ],
            model=model,
        ) as stream:
            bufnr.append("", end_line)
            bufnr.append("<RESPONSE>", end_line+1)
            end_line += 2

            # add stream line by line to buffer
            buffer_text = ""
            buffer_lines = []
            for text in stream.text_stream:
                if (self.stream_cancelled):
                    stream.close()
                    return

                buffer_text += text
                if "\n" in text:
                    lines = buffer_text.split("\n")
                    buffer_lines.extend(lines[:-1])
                    buffer_text = lines[-1]

                    if len(buffer_lines) >= 5:
                        bufnr.append(buffer_lines, end_line)
                        end_line += len(buffer_lines)
                        buffer_lines = []

            # append remaining lines
            if buffer_lines:
                bufnr.append(buffer_lines, end_line)
                end_line += len(buffer_lines)
            if buffer_text:
                bufnr.append(buffer_text, end_line)
                end_line += 1
            bufnr.append("<END RESPONSE>", end_line)
    except anthropic.APIConnectionError as e:
        self.nvim.err_write(f"PyGPT: Anthropic API Connection Error {e.__cause__}\n")
    except anthropic.RateLimitError as e:
        self.nvim.err_write("PyGPT: Anthropic Rate Limit Error\n")
    except anthropic.APIStatusError as e:
        self.nvim.err_write(f"PyGPT: Anthropic Error status={e.status_code} response={e.response}\n")

def run_openai(message, end_line, bufnr, params, model, client, self):
    print(model)
    response = client.chat.completions.create(
        max_completion_tokens=params['max_tokens'],
        temperature=params['temperature'],
        messages=[
            {"role": "system", "content": params['system']},
            {"role": "user", "content": message}
        ],
        model=model,
        stream=True
    )

    bufnr.append("", end_line)
    bufnr.append("<RESPONSE>", end_line+1)
    end_line += 2

    buffer_text = ""
    buffer_lines = []
    for chunk in response:
        if self.stream_cancelled:
            return

        content = chunk.choices[0].delta.content
        if content is None:
            continue

        buffer_text += content
        if "\n" in buffer_text:
            lines = buffer_text.split("\n")
            buffer_lines.extend(lines[:-1])
            buffer_text = lines[-1]

            if len(buffer_lines) >= 5:
                bufnr.append(buffer_lines, end_line)
                end_line += len(buffer_lines)
                buffer_lines = []

    if buffer_lines:
        bufnr.append(buffer_lines, end_line)
        end_line += len(buffer_lines)
    if buffer_text:
        bufnr.append(buffer_text, end_line)
        end_line += 1
    bufnr.append("<END RESPONSE>", end_line)

def run_perplexity(message, end_line, bufnr, params, model, client, self):
    print(model)
    response = client.chat.completions.create(
        max_completion_tokens=params['max_tokens'],
        temperature=params['temperature'],
        messages=[
            {"role": "system", "content": params['system']},
            {"role": "user", "content": message}
        ],
        model=model,
        stream=True
    )

    bufnr.append("", end_line)
    bufnr.append("<RESPONSE>", end_line+1)
    end_line += 2

    buffer_text = ""
    buffer_lines = []
    citations = []
    for chunk in response:
        if self.stream_cancelled:
            return

        buffer_text += chunk.choices[0].delta.content
        if "\n" in buffer_text:
            lines = buffer_text.split("\n")
            buffer_lines.extend(lines[:-1])
            buffer_text = lines[-1]

            if len(buffer_lines) >= 5:
                bufnr.append(buffer_lines, end_line)
                end_line += len(buffer_lines)
                buffer_lines = []
        citations = chunk.citations

    if buffer_lines:
        bufnr.append(buffer_lines, end_line)
        end_line += len(buffer_lines)
    if buffer_text:
        bufnr.append(buffer_text, end_line)
        end_line += 1
    bufnr.append("<END RESPONSE>", end_line)
    end_line += 1

    bufnr.append("", end_line)
    bufnr.append("<CITATIONS>", end_line+1)
    end_line += 2
    for i, citation in enumerate(citations):
        bufnr.append(f" {i+1}. " + citation, end_line)
        end_line += 1
    bufnr.append("<END CITATIONS>", end_line)
