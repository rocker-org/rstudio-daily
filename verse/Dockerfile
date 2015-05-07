
## image: rocker/rstudio-daily:verse
## rstudio-daily with packages from Github. 
## Includes some system dependencies (e.g. for databases in dplyr), but no heavy LaTeX system.

FROM rocker/rstudio-daily
MAINTAINER Carl Boettiger cboettig@ropensci.org

## Add binaries for more CRAN packages, deb-src repositories in case we need `apt-get build-dep`
RUN echo 'deb http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
  && gpg --keyserver keyserver.ubuntu.com --recv-keys AE05705B842492A68F75D64E01BF7284B26DD379 \
  && gpg --export AE05705B842492A68F75D64E01BF7284B26DD379  | apt-key add - \
  && echo 'deb-src http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
  && echo 'deb-src http://http.debian.net/debian testing main' >> /etc/apt/sources.list

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    default-jdk \
    default-jre \
    libblas-dev \
    libcairo2-dev/unstable \
    libgsl0-dev \
    liblapack-dev \
    libmysqlclient-dev \
    libpq-dev \
    libsqlite3-dev \
    libv8-dev \
    libxslt1-dev \
    libxt-dev \
    libiodbc2-dev \
    libodbc1 \
    odbc-postgresql \
    libmyodbc \
    r-cran-rgl \
    r-cran-rsqlite.extfuns \
    vim \
  && R CMD javareconf \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && install2.r --repo http://cran.rstudio.com --error \
    data.table \
    devtools \
    igraph \
    Lahman \
    microbenchmark \
    mgcv \
    nycflights13 \
    RMySQL \
    RODBC \
    RPostgreSQL \
    RSQLite \
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
    yihui/formatR \
    yihui/highr \
    yihui/knitr \
    klutometis/roxygen \
    ramnathv/htmlwidgets \ 
    rstudio/dygraphs \
    rstudio/leaflet \
    rstudio/packrat \
    rstudio/rmarkdown \
    rstudio/rticles \
    yihui/servr \
    jimhester/covr \
    jimhester/lintr

