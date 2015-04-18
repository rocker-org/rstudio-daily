
## image: rocker/rstudio-daily:verse
## rstudio-daily with packages from Github. 
## Includes some system dependencies (e.g. for databases in dplyr), but no heavy LaTeX system.

FROM rocker/rstudio-daily
MAINTAINER Carl Boettiger cboettig@ropensci.org

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    default-jre \
    libcairo2-dev/unstable \
    libgsl0-dev \
    libmysqlclient-dev \
    libpq-dev \
    libsqlite3-dev \
    libxslt1-dev \
    libxt-dev \
  && R CMD javareconf \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && install2.r --repo http://cran.rstudio.com --error devtools \
  && installGithub.r \
    RcppCore/Rcpp \
    eddelbuettel/bh \
    rstudio/shiny \
    hadley/xml2 \
    hadley/assertthat \
    hadley/devtools \
    hadley/dplyr \
    hadley/haven \
    hadley/ggplot2 \
    hadley/httr \
    hadley/lineprof \
    hadley/purrr \
    hadley/reshape \
    hadley/readr \
    hadley/readxl \
    hadley/rvest \
    hadley/stringr \
    hadley/testthat \
    hadley/tidyr \
    klutometis/roxygen \
    ramnathv/htmlwidgets \ 
    rstudio/dygraphs \
    rstudio/leaflet \
    rstudio/packrat \
    rstudio/rmarkdown \
    rstudio/rticles \
    yihui/knitr \
    yihui/servr \
    jimhester/covr

