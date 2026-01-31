# TextAnalysisR Docker Image

Pre-built Docker image for [TextAnalysisR](https://mshin77.github.io/TextAnalysisR) with Python integration (spaCy, BERTopic, sentence-transformers) ready to use.

## Quick Start

```bash
docker pull mshin77/textanalysisr.authr
docker run -p 3838:3838 mshin77/textanalysisr.authr
```

Open <http://localhost:3838> in your browser.

## Using AI Features (API Keys)

TextAnalysisR supports three AI providers. Ollama runs locally with no key. For OpenAI or Gemini, pass your key when starting the container:

```bash
docker run -p 3838:3838 \
  -e OPENAI_API_KEY=sk-... \
  -e GEMINI_API_KEY=AIza... \
  mshin77/textanalysisr.authr
```

Or use an environment file:

```bash
# 1. Create a .env file with your keys
echo "OPENAI_API_KEY=sk-..." > .env
echo "GEMINI_API_KEY=AIza..." >> .env

# 2. Run with --env-file
docker run -p 3838:3838 --env-file .env mshin77/textanalysisr.authr
```

You can also enter API keys directly in the Shiny app interface.

## Using Ollama (Local LLM)

To connect the container to an Ollama instance running on your host machine:

```bash
# macOS / Windows (Docker Desktop)
docker run -p 3838:3838 \
  -e OLLAMA_HOST=http://host.docker.internal:11434 \
  mshin77/textanalysisr.authr

# Linux
docker run -p 3838:3838 --network host mshin77/textanalysisr.authr
```

Make sure you have pulled the models you need:

```bash
ollama pull llama3.2              # text generation
ollama pull llava                 # vision / multimodal PDF extraction
ollama pull nomic-embed-text      # embeddings
```

## Build from Source

```bash
docker build -t mshin77/textanalysisr.authr .

# Full rebuild (no cache)
docker build --no-cache -t mshin77/textanalysisr.authr .
```

## Included Components

| Layer | Contents |
|-------|----------|
| Base | `rocker/shiny-verse:latest` (R + tidyverse + Shiny Server) |
| Python | spaCy, pdfplumber, sentence-transformers, BERTopic, PyTorch (CPU) |
| R | quanteda, stm, plotly, DT, reticulate, and all TextAnalysisR dependencies |

## Container Management

```bash
docker ps                          # list running containers
docker stop <CONTAINER_ID>         # stop
docker rm <CONTAINER_ID>           # remove
docker images                      # list images
docker rmi mshin77/textanalysisr.authr  # remove image
```
