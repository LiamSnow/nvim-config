import anthropic
from openai import OpenAI

RESPONSE_START = "<!-- response -->"
RESPONSE_END = "<!-- end response -->"
THINKING_START = "<!-- thinking -->"
THINKING_END = "<!-- end thinking -->"
CITATION_START = "<!-- citations -->"
CITATION_END = "<!-- end citations -->"

def run(message, end_line, bufnr, params, self):
    config = self.config["configs"][params["config"]]
    hide_markers = False
    if "hide_markers" in config:
        hide_markers = config["hide_markers"]
    match config["provider"]:
        case "anthropic":
            if config["thinking"]:
                hide_thinking = False
                if "hide_thinking" in config:
                    hide_thinking = config["hide_thinking"]
                run_anthropic_thinking(
                    message,
                    end_line,
                    bufnr,
                    params,
                    config["model"],
                    config["system"],
                    hide_thinking,
                    hide_markers,
                    self,
                )
            else:
                run_anthropic(
                    message,
                    end_line,
                    bufnr,
                    params,
                    config["model"],
                    config["system"],
                    hide_markers,
                    self,
                )
        case "openai":
            self.client = OpenAI(api_key=self.config["api_keys"]["openai"])
            run_openai(
                message,
                end_line,
                bufnr,
                params,
                config["model"],
                config["system"],
                hide_markers,
                self,
            )
        case "perplexity":
            run_perplexity(
                message,
                end_line,
                bufnr,
                params,
                config["model"],
                config["system"],
                hide_markers,
                self,
            )
        case "deepseek":
            self.client = OpenAI(
                api_key=self.config["api_keys"]["deepseek"],
                base_url="https://api.deepseek.com",
            )
            run_openai(
                message,
                end_line,
                bufnr,
                params,
                config["model"],
                config["system"],
                hide_markers,
                self,
            )
        case _:
            bufnr.append(f"Invalid client: {params['client']}")

def run_anthropic_thinking(message, end_line, bufnr, params, model, system, hide_thinking, hide_markers, self):
    self.client = anthropic.Anthropic(api_key=self.config["api_keys"]["anthropic"])
    try:
        with self.client.messages.stream(
            model=model,
            max_tokens=params['max_tokens'],
            system=system,
            thinking={
                "type": "enabled",
                "budget_tokens": 16000
            },
            messages=[{"role": "user", "content": message}],
        ) as stream:
            bufnr.append("", end_line)
            end_line += 1
            if not hide_markers:
                bufnr.append(RESPONSE_START, end_line)
                end_line += 1

            # add stream line by line to buffer
            buffer_text = ""
            buffer_lines = []
            self.stopped = False
            for event in stream:
                if self.stopped:
                    stream.close()
                    break

                if event.type == "content_block_delta":
                    text = None
                    if not hide_thinking and event.delta.type == "thinking_delta":
                        text = event.delta.thinking
                    elif event.delta.type == "text_delta":
                        text = event.delta.text
                    else:
                        continue

                    buffer_text += text
                    if "\n" in text:
                        lines = buffer_text.split("\n")
                        buffer_lines.extend(lines[:-1])
                        buffer_text = lines[-1]

                        if len(buffer_lines) >= 5:
                            bufnr.append(buffer_lines, end_line)
                            end_line += len(buffer_lines)
                            buffer_lines = []

                elif not hide_thinking and event.type == "content_block_start" and event.content_block.type == "thinking":
                    bufnr.append(THINKING_START, end_line)
                    end_line += 1
                elif not hide_thinking and event.type == "content_block_stop" and event.content_block.type == "thinking":
                    bufnr.append(THINKING_END, end_line)
                    end_line += 1


            # append remaining lines
            if not self.stopped:
                if buffer_lines:
                    bufnr.append(buffer_lines, end_line)
                    end_line += len(buffer_lines)
                if buffer_text:
                    bufnr.append(buffer_text, end_line)
                    end_line += 1
    except anthropic.APIConnectionError as e:
        self.nvim.err_write(f"PyGPT: Anthropic API Connection Error {e.__cause__}\n")
    except anthropic.RateLimitError as e:
        self.nvim.err_write("PyGPT: Anthropic Rate Limit Error\n")
    except anthropic.APIStatusError as e:
        self.nvim.err_write(f"PyGPT: Anthropic Error status={e.status_code} response={e.response}\n")
    finally:
        if not hide_markers:
            bufnr.append(RESPONSE_END, end_line)
        self.client.close()

def run_anthropic(message, end_line, bufnr, params, model, system, hide_markers, self):
    self.client = anthropic.Anthropic(api_key=self.config["api_keys"]["anthropic"])
    try:
        self.stream = self.client.messages.create(
            max_tokens=params["max_tokens"],
            system=system,
            temperature=params["temperature"],
            messages=[{"role": "user", "content": message}],
            model=model,
            stream=True,
        )

        # add prefix
        bufnr.append("", end_line)
        end_line += 1
        if not hide_markers:
            bufnr.append(RESPONSE_START, end_line)
            end_line += 1

        # add stream line by line to buffer
        buffer_text = ""
        buffer_lines = []
        self.stopped = False
        for event in self.stream:
            if self.stopped:
                break

            if event.type == "content_block_delta":
                text = event.delta.text
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
        if not self.stopped:
            if buffer_lines:
                bufnr.append(buffer_lines, end_line)
                end_line += len(buffer_lines)
            if buffer_text:
                bufnr.append(buffer_text, end_line)
                end_line += 1

    except anthropic.APIConnectionError as e:
        self.nvim.err_write(f"PyGPT: Anthropic API Connection Error {e.__cause__}\n")
    except anthropic.RateLimitError as e:
        self.nvim.err_write("PyGPT: Anthropic Rate Limit Error\n")
    except anthropic.APIStatusError as e:
        self.nvim.err_write(
            f"PyGPT: Anthropic Error status={e.status_code} response={e.response}\n"
        )
    finally:
        if not hide_markers:
            bufnr.append(RESPONSE_END, end_line)
        if self.stream is not None:
            self.stream.close()
        self.client.close()


def run_openai(
    message, end_line, bufnr, params, model, system, hide_markers, self
):
    self.stream = self.client.chat.completions.create(
        max_completion_tokens=params["max_tokens"],
        temperature=params["temperature"],
        messages=[
            {"role": "system", "content": system},
            {"role": "user", "content": message},
        ],
        model=model,
        stream=True,
    )

    bufnr.append("", end_line)
    end_line += 1
    if not hide_markers:
        bufnr.append(RESPONSE_START, end_line)
        end_line += 1

    buffer_text = ""
    buffer_lines = []
    self.stopped = False
    for chunk in self.stream:
        if self.stopped:
            break

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

    if not self.stopped:
        if buffer_lines:
            bufnr.append(buffer_lines, end_line)
            end_line += len(buffer_lines)
        if buffer_text:
            bufnr.append(buffer_text, end_line)
            end_line += 1

    self.stream.close()
    self.client.close()

    if not hide_markers:
        bufnr.append(RESPONSE_END, end_line)


def run_perplexity(message, end_line, bufnr, params, model, system, hide_markers, self):
    self.client = OpenAI(
        api_key=self.config["api_keys"]["perplexity"],
        base_url="https://api.perplexity.ai",
    )
    self.stream = self.client.chat.completions.create(
        max_completion_tokens=params["max_tokens"],
        temperature=params["temperature"],
        messages=[
            {"role": "system", "content": system},
            {"role": "user", "content": message},
        ],
        model=model,
        stream=True,
    )

    bufnr.append("", end_line)
    end_line += 1
    if not hide_markers:
        bufnr.append(RESPONSE_START, end_line)
        end_line += 1

    buffer_text = ""
    buffer_lines = []
    citations = []
    self.stopped = False
    for chunk in self.stream:
        if self.stopped:
            break

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

    if not self.stopped:
        bufnr.append("", end_line)
        bufnr.append(CITATION_START, end_line + 1)
        end_line += 2
        for i, citation in enumerate(citations):
            bufnr.append(f" - [{i+1}]: " + citation, end_line)
            end_line += 1
        bufnr.append(CITATION_END, end_line)
        end_line += 1

    self.stream.close()
    self.client.close()

    if not hide_markers:
        bufnr.append(RESPONSE_END, end_line)
