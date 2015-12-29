FROM rocker/drd

## This handle reaches Carl and Dirk
MAINTAINER "Carl Boettiger and Dirk Eddelbuettel" rocker-maintainers@eddelbuettel.com

ENV DEBIAN-FRONTEND noninteractive  
ENV PATH /usr/lib/rstudio-server/bin/:$PATH   

RUN apt-get update \
  && apt-get install -y -t unstable --no-install-recommends \
    libxml2-dev \
  && install2.r httr XML downloader \
  && wget --no-check-certificate \
    https://raw.githubusercontent.com/rocker-org/rstudio-daily/master/latest.R \
  && Rscript latest.R && rm latest.R 

RUN apt-get update \
  && apt-get install -y -t unstable --no-install-recommends \
    ca-certificates \
    file \
    git \
    libapparmor1 \
    libedit2 \
    libcurl4-openssl-dev \
    libssl1.0.0 \
    libssl-dev \
    psmisc \
    python-setuptools \
    runit \
    sudo 

RUN dpkg -i rstudio-server-daily-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
  && wget https://github.com/jgm/pandoc-templates/archive/1.15.2.1.tar.gz \
  && mkdir -p /opt/pandoc/templates && tar zxf 1.15.2.1.tar.gz \
  && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
  && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/

## Ensure that if both httr and httpuv are installed downstream, oauth 2.0 flows still work correctly.
RUN echo '\n\
\n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
\n# is not set since a redirect to localhost may not work depending upon \
\n# where this Docker container is running. \
\nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
\n  options(httr_oob_default = TRUE) \
\n}' >> /etc/R/Rprofile.site

## A default user system configuration. For historical reasons,
## we want user to be 'rstudio', but it is 'docker' in r-base
RUN usermod -l rstudio docker \
  && usermod -m -d /home/rstudio rstudio \
  && groupmod -n rstudio docker \
  && echo '"\e[5~": history-search-backward' >> /etc/inputrc \
  && echo '"\e[6~": history-search-backward' >> /etc/inputrc \
  && echo "rstudio:rstudio" | chpasswd

COPY add-students.sh /usr/local/bin/add-students
COPY run.sh /etc/service/rstudio/run

EXPOSE 8787

## Have RStudio run with the pre-release R as well
RUN cd /usr/local/bin \
  && mv Rdevel R \
  && mv Rscriptdevel Rscript

CMD ["runsvdir", "/etc/service"] 
