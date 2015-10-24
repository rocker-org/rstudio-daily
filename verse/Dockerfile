
## image: rocker/rstudio-daily:verse
## rstudio-daily with packages from Github. 
## Includes some system dependencies (e.g. for databases in dplyr), but no heavy LaTeX system.

FROM rocker/rstudio-daily
MAINTAINER Carl Boettiger cboettig@ropensci.org

## Add binaries for more CRAN packages, deb-src repositories in case we need `apt-get build-dep`
#RUN echo 'deb http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
#  && gpg --keyserver keyserver.ubuntu.com --recv-keys AE05705B842492A68F75D64E01BF7284B26DD379 \
#  && gpg --export AE05705B842492A68F75D64E01BF7284B26DD379  | apt-key add - \
#  && echo 'deb-src http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
#  && echo 'deb-src http://http.debian.net/debian testing main' >> /etc/apt/sources.list

RUN apt-get update \
  && apt-get install -y -t unstable --no-install-recommends \
    aspell \
    aspell-en \
    cdbs \ 
    debhelper \
    default-jdk \
    default-jre \
    libblas-dev \
    libcairo2-dev \
    libgsl0-dev \
    liblapack-dev \
    libmysqlclient-dev \
    libssl-dev \
    libpq-dev \
    libsqlite3-dev \
    libv8-dev \
    libxslt1-dev \
    libxt-dev \
    libodbc1 \
    libmyodbc \
    odbc-postgresql \
    qpdf \
    r-cran-rgl \
    unixodbc-dev \
    vim \
  && R CMD javareconf \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && install2.r --repo http://cran.rstudio.com --repo http://carlboettiger.info/drat --error \
    data.table \
    DBI \
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
    XML \
    RCurl \
    shiny \
    xml2 \
    assertthat \
    devtools \
    dplyr \
    haven \
    ggplot2 \
    httr \
    lineprof \
    reshape \
    readr \
    readxl \
    rvest \
    stringr \
    testthat \
    tidyr \
    formatR \
    highr \
    knitr \
    roxygen2 \
    htmlwidgets \ 
    dygraphs \
    leaflet \
    packrat \
    rmarkdown \
    rticles \
    servr \
    covr \
    lintr \
    DiagrammeR \
    UnidecodeR \
    broom \
  && R -e 'update.packages(ask=FALSE)'

