FROM rocker/shiny-verse:4.4.2

LABEL maintainer="Mikyung Shin <shin.mikyung@gmail.com>"
LABEL description="Docker image for TextAnalysisR: Text Mining Workflow Tool (Version 0.0.3)"

# System dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    libglpk40 \
    libssl-dev \
    libsasl2-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libpoppler-cpp-dev \
    pandoc \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    libpython3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create Python virtual environment with all dependencies
ENV WORKON_HOME=/opt/virtualenvs
ENV RETICULATE_PYTHON=/opt/virtualenvs/textanalysisr-env/bin/python
RUN python3 -m venv /opt/virtualenvs/textanalysisr-env && \
    /opt/virtualenvs/textanalysisr-env/bin/pip install --no-cache-dir \
    spacy>=3.5.0 \
    "pandas>=1.5.0,<3.0" \
    pdfplumber>=0.10.0 \
    scikit-learn && \
    /opt/virtualenvs/textanalysisr-env/bin/python -m spacy download en_core_web_sm

# Install CPU-only PyTorch first from the PyTorch index
RUN /opt/virtualenvs/textanalysisr-env/bin/pip install --no-cache-dir \
    torch>=2.0.0 --index-url https://download.pytorch.org/whl/cpu

# Deep learning and embedding packages (uses torch already installed above)
RUN /opt/virtualenvs/textanalysisr-env/bin/pip install --no-cache-dir \
    sentence-transformers>=2.2.0 \
    transformers>=4.30.0

# BERTopic and clustering dependencies
RUN /opt/virtualenvs/textanalysisr-env/bin/pip install --no-cache-dir \
    bertopic \
    umap-learn \
    hdbscan

# Set Python environment variables for reticulate
ENV SPACY_PYTHON=/opt/virtualenvs/textanalysisr-env/bin/python

# Enable Docker detection for TextAnalysisR (enables Python/spaCy features)
ENV TEXTANALYSISR_DOCKER=true

# Ollama base URL (host.docker.internal resolves to the host machine)
ENV OLLAMA_BASE_URL=http://host.docker.internal:11434

# Set CRAN mirror
ENV CRAN_MIRROR=https://packagemanager.posit.co/cran/__linux__/jammy/latest

# Core dependencies (Imports from TextAnalysisR)
RUN install2.r -r ${CRAN_MIRROR} \
    remotes \
    devtools \
    Matrix \
    ggplot2 \
    dplyr \
    tidyr \
    tibble \
    rlang \
    magrittr \
    purrr

# Text analysis packages (Imports)
RUN install2.r -r ${CRAN_MIRROR} \
    quanteda \
    quanteda.textstats \
    tidytext \
    tidylo \
    stm \
    widyr \
    igraph \
    stopwords

# Visualization packages (Suggests)
RUN install2.r -r ${CRAN_MIRROR} \
    plotly \
    ggraph \
    visNetwork \
    RColorBrewer \
    scales \
    wordcloud2

# Shiny packages (mixed Imports/Suggests)
RUN install2.r -r ${CRAN_MIRROR} \
    shiny \
    shinyjs \
    shinybusy \
    shinyBS \
    shinyWidgets \
    DT \
    htmltools \
    htmlwidgets \
    fontawesome

# Markdown and documentation (Suggests - required at runtime)
RUN install2.r -r ${CRAN_MIRROR} \
    markdown \
    rmarkdown \
    knitr

# Clustering and statistics (Suggests)
RUN install2.r -r ${CRAN_MIRROR} \
    cluster \
    moments \
    Rtsne \
    umap \
    clusterCrit \
    dbscan \
    mclust \
    aricode \
    MASS \
    pscl \
    proxy

# File handling and utilities (Suggests)
RUN install2.r -r ${CRAN_MIRROR} \
    broom \
    numform \
    readxl \
    openxlsx \
    officer \
    pdftools \
    jsonlite \
    httr \
    dotenv \
    progress \
    reticulate \
    syuzhet \
    textdata

# UI enhancement packages (Suggests)
RUN install2.r -r ${CRAN_MIRROR} \
    colourpicker \
    digest \
    stringr

# Install TextAnalysisR from GitHub (cache busts when repo has new commits)
ADD "https://api.github.com/repos/mshin77/TextAnalysisR/commits/HEAD" /tmp/textanalysisr_version
RUN R -e "remotes::install_github('mshin77/TextAnalysisR', dependencies = TRUE, force = TRUE)"

# Expose Shiny port
EXPOSE 3838

# Override the default entrypoint from rocker/shiny-verse
ENTRYPOINT []

CMD ["Rscript", "-e", "Sys.setenv(RETICULATE_PYTHON='/opt/virtualenvs/textanalysisr-env/bin/python'); options(shiny.host='0.0.0.0', shiny.port=3838, shiny.trace=TRUE); TextAnalysisR::run_app()"]
