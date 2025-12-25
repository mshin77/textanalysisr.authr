FROM rocker/shiny-verse:latest

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

# Create Python virtual environment and install spaCy
ENV WORKON_HOME=/opt/virtualenvs
ENV RETICULATE_PYTHON=/opt/virtualenvs/spacy_virtualenv/bin/python
RUN python3 -m venv /opt/virtualenvs/spacy_virtualenv && \
    /opt/virtualenvs/spacy_virtualenv/bin/pip install --no-cache-dir spacy && \
    /opt/virtualenvs/spacy_virtualenv/bin/python -m spacy download en_core_web_sm

# Set Python environment variables for reticulate/spacyr
ENV SPACY_PYTHON=/opt/virtualenvs/spacy_virtualenv/bin/python
ENV LD_LIBRARY_PATH=/usr/lib/python3/config-3.12-x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu

# Enable Docker detection for TextAnalysisR (enables Python/spaCy features)
ENV TEXTANALYSISR_DOCKER=true

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
    shinycssloaders \
    shinyWidgets \
    shinydashboard \
    bslib \
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

# NLP (Suggests - optional, may need Python setup)
RUN install2.r -r ${CRAN_MIRROR} \
    spacyr \
    koRpus

# Install TextAnalysisR from GitHub (cache busts when repo has new commits)
ADD "https://api.github.com/repos/mshin77/TextAnalysisR/commits/HEAD" /tmp/textanalysisr_version
RUN R -e "remotes::install_github('mshin77/TextAnalysisR', dependencies = TRUE, force = TRUE)"

# Expose Shiny port
EXPOSE 3838

# Override the default entrypoint from rocker/shiny-verse
ENTRYPOINT []

# Run Shiny app directly (echo 'n' to skip Python setup prompt)
# Set spacyr to use the virtual environment Python with spaCy installed
CMD ["/bin/sh", "-c", "echo 'n' | R -e \"Sys.setenv(RETICULATE_PYTHON='/opt/virtualenvs/spacy_virtualenv/bin/python'); options(shiny.host = '0.0.0.0', shiny.port = 3838, shiny.trace = TRUE); TextAnalysisR::run_app()\""]
