FROM rocker/shiny-verse:latest

LABEL maintainer="Mikyung Shin <shin.mikyung@gmail.com>"
LABEL description="Docker image for TextAnalysisR Shiny application"

RUN apt-get update -qq && \
    apt-get install -y libglpk40 libssl-dev libsasl2-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN install2.r -r 'https://packagemanager.rstudio.com/all/__linux__/focal/latest' remotes  
RUN R -e "install.packages('Matrix', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('ggplot2', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages(c('numform', 'utils', 'purrr'), repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('plotly', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('dplyr', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('quanteda', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('stm', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('stminsights', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('tidyr', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('tidytext', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('textmineR', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('tibble', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages(c('stats', 'scales', 'readxl'), repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('ggraph', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('ggdendro', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('widyr', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('markdown', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('shiny', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('shinyjs', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('shinyBS', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('DT', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('shinycssloaders', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('quanteda.textstats', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "install.packages('devtools', repos='https://packagemanager.rstudio.com/all/__linux__/focal/latest')"
RUN R -e "devtools::install_github('mshin77/TextAnalysisR')"
